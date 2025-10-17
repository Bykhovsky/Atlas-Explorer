--[[
	@class AtlasTree
	
		> [The backbone of the Explorer window — responsible for rendering, updating, and managing the hierarchical instance tree].
			- Handles selection, multi-selection, hover effects, collapse/expand logic, scrolling behavior, and live syncing with the DataModel.

	> Author: @Bykhovsky
	> Version: 1.0.0
	> Last updated: 10/17/2025
]]--

local Id = require(script.Parent.AtlasId)
local Core = require(script.Parent.AtlasCore)
local Icons = require(script.Parent.AtlasIcons)

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local INDENT = 16
local ROW_H  = 22

local Tree = {}
Tree.__index = Tree

local function owningScreenGui(gui: GuiObject)
	return gui:IsA("ScreenGui") and gui or gui:FindFirstAncestorOfClass("ScreenGui")
end

local function adjustedMouseFor(gui: GuiObject): Vector2
	local pos = UserInputService:GetMouseLocation()
	local sg  = owningScreenGui(gui)
	if sg and sg.IgnoreGuiInset then
		pos -= GuiService:GetGuiInset()
	end
	return pos
end

local function guiContains(gui: GuiObject, ptScreen: Vector2): boolean
	local p, s = gui.AbsolutePosition, gui.AbsoluteSize
	return ptScreen.X >= p.X and ptScreen.X <= p.X + s.X
		and ptScreen.Y >= p.Y and ptScreen.Y <= p.Y + s.Y
end

local function rowUnderMouse(treeList: ScrollingFrame): Frame?
	local mpos = adjustedMouseFor(treeList)
	for _, child in pairs(treeList:GetChildren()) do
		if child:IsA("Frame") and child:GetAttribute("AtlasRow") == true then
			if guiContains(child, mpos) then return child end
		end
	end
	return nil
end

local function iconFor(inst: Instance)
	if Icons[inst.ClassName] then
		return Icons[inst.ClassName]
	end
	return Icons["Instance"]
end

local function nodeMatches(node, q: string)
	local nm  = node.instance.Name:lower()
	local cls = node.instance.ClassName:lower()
	return nm:find(q, 1, true) or cls:find(q, 1, true)
end

function Tree.new(scrollingFrame: ScrollingFrame, rowTemplate: Frame, _opts: {}?)
	local self = setmetatable({}, Tree)
	self.Frame = scrollingFrame
	self.RowTemplate = rowTemplate
	self._opts = _opts or {}

	self.NodeByInstance = {}
	self.Roots = {}
	self.Flat = {}

	self.SelectedSet = {}
	self.Primary = nil :: Instance?
	self.AnchorIndex = nil :: number?

	self.OnHover = Core.Signal()
	self.OnSelect = Core.Signal()
	self.OnRightClick = Core.Signal()
	self.OnSelectionChanged = Core.Signal()

	self._rootConns = {}
	self._refreshScheduled = false
	self._destroyed = false

	local layout = self.Frame:FindFirstChildOfClass("UIListLayout")
	if not layout then
		layout = Instance.new("UIListLayout")
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Parent = self.Frame
	end
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		self.Frame.CanvasSize = UDim2.fromOffset(layout.AbsoluteContentSize.X, layout.AbsoluteContentSize.Y)
	end)

	self._hoverClearConn = UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
		if not self.Frame or not self.Frame.Parent then return end
		local mpos = adjustedMouseFor(self.Frame)
		if not guiContains(self.Frame, mpos) then
			self.OnHover:Fire(nil, self.Primary)
		end
	end)

	self._emptyClickConn = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
		if not self.Frame or not self.Frame.Parent then return end
		local mpos = adjustedMouseFor(self.Frame)
		if guiContains(self.Frame, mpos) and rowUnderMouse(self.Frame) == nil then
			self:ClearSelection()
		end
	end)

	return self
end

function Tree:_disconnectRootConns()
	for _, c in pairs(self._rootConns) do c:Disconnect() end
	table.clear(self._rootConns)
end

function Tree:_bindRootSignals(roots: {Instance})
	self:_disconnectRootConns()
	for _, r in pairs(roots) do
		table.insert(self._rootConns, r.ChildAdded:Connect(function() self:_scheduleRefresh() end))
		table.insert(self._rootConns, r.ChildRemoved:Connect(function() self:_scheduleRefresh() end))
		table.insert(self._rootConns, r.AncestryChanged:Connect(function() self:_scheduleRefresh() end))
	end
end

function Tree:_scheduleRefresh()
	if self._refreshScheduled then return end
	self._refreshScheduled = true
	task.defer(function()
		if self._destroyed then return end
		self._refreshScheduled = false
		self:_doRefresh()
	end)
end

local function buildAndSortChildren(node)
	table.sort(node.children, function(a,b)
		if a.instance.ClassName ~= b.instance.ClassName then
			return a.instance.ClassName < b.instance.ClassName
		end
		return a.instance.Name:lower() < b.instance.Name:lower()
	end)
	node.isLeaf = (#node.children == 0)
end

function Tree:Mount(roots: {Instance})
	self:_disconnectRootConns()

	self.NodeByInstance = {}
	self.Roots = {}

	local function rec(inst: Instance, parent, depth: number)
		local node = {
			instance = inst,
			parent = parent,
			depth = depth,
			children = {},
			expanded = false,
			isLeaf = true,
			_index = 0,
		}
		self.NodeByInstance[inst] = node
		for _, c in pairs(inst:GetChildren()) do
			table.insert(node.children, rec(c, node, depth + 1))
		end
		buildAndSortChildren(node)
		return node
	end
	for _, r in pairs(roots) do
		table.insert(self.Roots, rec(r, nil, 0))
	end

	self:RebuildFlat()
	self:Render()

	self:_bindRootSignals(roots)
end

function Tree:_doRefresh()
	local expanded = {}
	for inst, node in pairs(self.NodeByInstance) do
		if node.expanded then expanded[inst] = true end
	end
	local roots = {}
	for _, r in pairs(self.Roots) do table.insert(roots, r.instance) end

	self.NodeByInstance = {}
	self.Roots = {}

	local function rec(inst: Instance, parent, depth: number)
		local node = {
			instance = inst,
			parent = parent,
			depth = depth,
			children = {},
			expanded = false,
			isLeaf = true,
			_index = 0,
		}
		self.NodeByInstance[inst] = node
		for _, c in pairs(inst:GetChildren()) do
			table.insert(node.children, rec(c, node, depth + 1))
		end
		buildAndSortChildren(node)
		return node
	end
	for _, r in pairs(roots) do
		table.insert(self.Roots, rec(r, nil, 0))
	end

	for inst, node in pairs(self.NodeByInstance) do
		if expanded[inst] and not node.isLeaf then node.expanded = true end
	end

	self:RebuildFlat()
	self:Render()

	self:_bindRootSignals(roots)
end

function Tree:Refresh()
	self:_scheduleRefresh()
end

function Tree:RefreshNow()
	self:_doRefresh()
end

function Tree:RebuildFlat()
	self.Flat = {}
	local function walk(node)
		table.insert(self.Flat, node)
		node._index = #self.Flat
		if node.expanded then
			for _, c in pairs(node.children) do walk(c) end
		end
	end
	for _, r in pairs(self.Roots) do walk(r) end
end

local function markSearchInclusions(node, q: string): boolean
	local selfMatch = nodeMatches(node, q)
	local childMatch = false
	for _, c in pairs(node.children) do
		if markSearchInclusions(c, q) then childMatch = true end
	end
	node._includeSearch = selfMatch or childMatch
	return node._includeSearch
end

local function collectMarkedPreorder(node, out)
	if node._includeSearch then
		table.insert(out, node)
		for _, c in pairs(node.children) do
			collectMarkedPreorder(c, out)
		end
	end
end

function Tree:_buildFilteredFlat(filterLower: string)
	for _, r in pairs(self.Roots) do
		markSearchInclusions(r, filterLower)
	end
	local out = {}
	for _, r in pairs(self.Roots) do
		collectMarkedPreorder(r, out)
	end
	for _, node in pairs(self.NodeByInstance) do
		node._includeSearch = nil
	end
	for i, n in pairs(out) do n._vindex = i end
	return out
end

function Tree:_emitSelectionChanged()
	local arr = {}
	local set = self.SelectedSet
	for _, n in pairs(self.Flat) do
		if set[n.instance] then table.insert(arr, n.instance) end
	end
	self.OnSelectionChanged:Fire(arr, self.Primary)
end

function Tree:_clearSelection()
	table.clear(self.SelectedSet)
	self.Primary = nil
	self.AnchorIndex = nil
end

function Tree:ClearSelection()
	self:_clearSelection()
	self:_emitSelectionChanged()
end

function Tree:_selectionCount()
	local n = 0
	for _ in pairs(self.SelectedSet) do n += 1 end
	return n
end

function Tree:GetSelection()
	local arr = {}
	for _, n in pairs(self.Flat) do
		if self.SelectedSet[n.instance] then table.insert(arr, n.instance) end
	end
	return arr, self.SelectedSet
end

function Tree:SetSelection(list: {Instance}, primary: Instance?)
	self:_clearSelection()
	for _, it in pairs(list) do
		self.SelectedSet[it] = true
	end
	self.Primary = primary or (#list > 0 and list[#list] or nil)
	self.AnchorIndex = self.Primary and (self.NodeByInstance[self.Primary] and self.NodeByInstance[self.Primary]._index) or nil
	self:_emitSelectionChanged()
end

function Tree:_selectOnly(inst: Instance)
	self.SelectedSet = {[inst] = true}
	self.Primary = inst
	self.AnchorIndex = self.NodeByInstance[inst] and self.NodeByInstance[inst]._index or nil
	self:_emitSelectionChanged()
end

function Tree:_toggleSelect(inst: Instance)
	if self.SelectedSet[inst] then
		self.SelectedSet[inst] = nil
		if self.Primary == inst then
			self.Primary = nil
		end
	else
		self.SelectedSet[inst] = true
		self.Primary = inst
	end
	self.AnchorIndex = self.NodeByInstance[self.Primary or inst] and self.NodeByInstance[self.Primary or inst]._index or nil
	self:_emitSelectionChanged()
end

function Tree:_selectRangeVisible(visibleList: {any}, inst: Instance)
	local indexByInst = {}
	for i = 1, #visibleList do
		local n = visibleList[i]
		indexByInst[n.instance] = i
	end

	local targetIdx = indexByInst[inst]
	if not targetIdx then return end

	local anchorInst = self.Primary or inst
	local anchorIdx = indexByInst[anchorInst] or targetIdx

	local lo, hi = math.min(anchorIdx, targetIdx), math.max(anchorIdx, targetIdx)

	self:_clearSelection()
	for i = lo, hi do
		local n = visibleList[i]
		if n and n.instance then
			self.SelectedSet[n.instance] = true
		end
	end

	self.Primary = inst
	self.AnchorIndex = targetIdx
	self:_emitSelectionChanged()
end

function Tree:_removeFromSelection(inst: Instance)
	if not self.SelectedSet[inst] then return end
	self.SelectedSet[inst] = nil
	if self.Primary == inst then
		self.Primary = nil
		for i = #self.Flat, 1, -1 do
			local ii = self.Flat[i].instance
			if self.SelectedSet[ii] then
				self.Primary = ii break
			end
		end
	end
	self.AnchorIndex = self.Primary and (self.NodeByInstance[self.Primary] and self.NodeByInstance[self.Primary]._index) or nil
	self:_emitSelectionChanged()
end

function Tree:_setExpandedRecursive(node, expanded: boolean, includeSelf: boolean)
	if includeSelf and not node.isLeaf then
		node.expanded = expanded
	end
	for _, c in pairs(node.children) do
		if not c.isLeaf then c.expanded = expanded end
		self:_setExpandedRecursive(c, expanded, true)
	end
end

function Tree:ExpandAll(inst: Instance)
	local node = self.NodeByInstance[inst]; if not node then return end
	self:_setExpandedRecursive(node, true, true)
	self:RebuildFlat(); self:Render()
end

function Tree:CollapseAll(inst: Instance)
	local node = self.NodeByInstance[inst]; if not node then return end
	self:_setExpandedRecursive(node, false, true)
	self:RebuildFlat(); self:Render()
end

function Tree:ExpandDescendants(inst: Instance)
	local node = self.NodeByInstance[inst]; if not node then return end
	self:_setExpandedRecursive(node, true, false)
	self:RebuildFlat(); self:Render()
end

function Tree:CollapseDescendants(inst: Instance)
	local node = self.NodeByInstance[inst]; if not node then return end
	self:_setExpandedRecursive(node, false, false)
	self:RebuildFlat(); self:Render()
end

function Tree:ExpandSet(instances: {Instance})
	local changed = false
	for _, inst in pairs(instances) do
		local node = self.NodeByInstance[inst]
		if node and not node.isLeaf and not node.expanded then
			node.expanded = true; changed = true
		end
	end
	if changed then self:RebuildFlat(); self:Render() end
end

local function _markPathExpanded(self, inst: Instance)
	local node = self.NodeByInstance[inst]; if not node then return end
	local p = node.parent
	while p do
		if not p.isLeaf and not p.expanded then p.expanded = true end; p = p.parent
	end
end

function Tree:ExpandPath(inst: Instance)
	_markPathExpanded(self, inst)
	self:RebuildFlat(); self:Render()
end

function Tree:ExpandPaths(list: {Instance})
	local changed = false
	for _, inst in pairs(list) do
		local node = self.NodeByInstance[inst]
		if node then
			local p = node.parent
			while p do
				if not p.isLeaf and not p.expanded then
					p.expanded = true; changed = true
				end; p = p.parent
			end
		end
	end
	if changed then self:RebuildFlat(); self:Render() end
end

function Tree:ExpandAllSet(parents:{Instance})
	for _, p in pairs(parents) do
		local n = self.NodeByInstance[p]
		if n then self:_setExpandedRecursive(n, true, true) end
	end
	self:RebuildFlat(); self:Render()
end

function Tree:CollapseAllSet(parents:{Instance})
	for _, p in pairs(parents) do
		local n = self.NodeByInstance[p]
		if n then self:_setExpandedRecursive(n, false, true) end
	end
	self:RebuildFlat(); self:Render()
end

function Tree:Reveal(inst: Instance)
	if not inst then return end

	local node = self.NodeByInstance[inst]
	if not node then return end

	local changed = false
	local p = node.parent
	while p do
		if not p.isLeaf and not p.expanded then
			p.expanded = true; changed = true
		end; p = p.parent
	end
	if changed then self:RebuildFlat(); self:Render() end

	local id  = require(script.Parent.AtlasId).Get(inst)
	local row = nil
	for _, child in pairs(self.Frame:GetChildren()) do
		if child:IsA("Frame")
			and child:GetAttribute("AtlasRow") == true
			and child:GetAttribute("AtlasId") == id then
			row = child; break
		end
	end
	if not row then return end

	local frame = self.Frame
	local pad = 8

	local fTop = frame.AbsolutePosition.Y
	local fBottom = fTop + frame.AbsoluteSize.Y
	local rTop = row.AbsolutePosition.Y
	local rBottom = rTop + row.AbsoluteSize.Y

	local layout = frame:FindFirstChildOfClass("UIListLayout")
	local contentY = layout and layout.AbsoluteContentSize.Y or frame.CanvasSize.Y.Offset
	local maxY = math.max(0, contentY - frame.AbsoluteSize.Y)
	local cv = frame.CanvasPosition

	if rTop < fTop then
		local delta = (rTop - fTop) - pad
		frame.CanvasPosition = Vector2.new(cv.X, math.clamp(cv.Y + delta, 0, maxY))
	elseif rBottom > fBottom then
		local delta = (rBottom - fBottom) + pad
		frame.CanvasPosition = Vector2.new(cv.X, math.clamp(cv.Y + delta, 0, maxY))
	end
end

function Tree:Toggle(inst: Instance)
	local node = self.NodeByInstance[inst]
	if node and not node.isLeaf then
		node.expanded = not node.expanded
		self:RebuildFlat(); self:Render()
	end
end

function Tree:_clearRows()
	for _, child in pairs(self.Frame:GetChildren()) do
		if child:IsA("Frame") and child:GetAttribute("AtlasRow") == true then
			child:Destroy()
		end
	end
end

function Tree:Render(filter: (nil|string))
	self:_clearRows()

	local searching = (filter ~= nil and filter ~= "")
	local list = searching and self:_buildFilteredFlat(filter:lower()) or self.Flat

	local idx = 0
	for _, n in pairs(list) do
		idx += 1
		local row = self.RowTemplate:Clone()
		row.Name = "Row_" .. idx
		row.Visible = true
		row.Parent = self.Frame
		row.Size = UDim2.new(1, 0, 0, ROW_H)
		row.LayoutOrder = idx
		row:SetAttribute("AtlasRow", true)
		row:SetAttribute("RowIndex", searching and (n._vindex or idx) or (n._index or idx))

		local pad = row:FindFirstChildOfClass("UIPadding") or Instance.new("UIPadding", row)
		pad.PaddingLeft = UDim.new(0, n.depth * INDENT)

		local icon = row:FindFirstChild("Icon")
		if icon and icon:IsA("ImageLabel") then
			local info = iconFor(n.instance)
			icon.Image = "rbxassetid://124740049830344"
			icon.ImageRectOffset = info.ImageRectOffset
			icon.ImageRectSize = info.ImageRectSize
		end

		local twisty = row:FindFirstChild("Twisty")
		if twisty and twisty:IsA("TextButton") then
			if searching then
				twisty.Text = n.isLeaf and "" or "▶"
				twisty.AutoButtonColor = false
				twisty.Active = false
				twisty.TextTransparency = 0.5
			else
				twisty.Text = (n.isLeaf and "") or (n.expanded and "▼" or "▶")
				twisty.AutoButtonColor = not n.isLeaf
				twisty.Active = not n.isLeaf
				twisty.MouseButton1Click:Connect(function()
					self:Toggle(n.instance)
				end)
			end
		end

		row.MouseEnter:Connect(function()
			self.OnHover:Fire(n.instance, self.Primary)
		end)

		local press = row:FindFirstChild("Press")
		if press and press:IsA("TextButton") then
			press.MouseEnter:Connect(function()
				self.OnHover:Fire(n.instance, self.Primary)
			end)

			press.MouseButton1Click:Connect(function()
				local ctrl = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
					or UserInputService:IsKeyDown(Enum.KeyCode.LeftMeta) or UserInputService:IsKeyDown(Enum.KeyCode.RightMeta)
				local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)

				if shift then
					self:_selectRangeVisible(list, n.instance)
				elseif ctrl then
					self:_toggleSelect(n.instance)
				else
					local count = self:_selectionCount()
					if count >= 2 then
						self:_selectOnly(n.instance)
					elseif count == 1 then
						if self.SelectedSet[n.instance] then
							self:ClearSelection()
						else
							self:_selectOnly(n.instance)
						end
					else
						self:_selectOnly(n.instance)
					end
				end
				self.OnSelect:Fire(self.Primary, self.Primary)
			end)

			press.MouseButton2Click:Connect(function()
				if not self.SelectedSet[n.instance] then
					self:_selectOnly(n.instance)
				end
				self.OnRightClick:Fire(n.instance, self.Primary)
			end)
		end

		local label = row:FindFirstChild("Label")
		if label and (label:IsA("TextButton") or label:IsA("TextLabel")) then
			label.Text = n.instance.Name
		end

		local guid = Id.Get(n.instance)
		row:SetAttribute("AtlasId", guid)
	end
end

return Tree
