--[[
	@class AtlasDrag

	> [Manages drag-and-drop operations within the Explorer].
		> Handles ghost rendering, selection updates, and smooth positional tracking for accurate instance reordering or reparenting.

	> Author: @Bykhovsky
	> Version: 1.0.0
	> Last updated: 10/17/2025
]]--

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local Core = require(script.Parent.AtlasCore)

local DRAG_THRESHOLD = 6
local GHOST_OFFSET = Vector2.new(0, 0)
local HILITE_OK = Color3.fromRGB(40, 180, 80)
local HILITE_BAD = Color3.fromRGB(200, 60, 60)

local Drag = {}
Drag.__index = Drag

function Drag.new(tree, resolveId, screenGui: ScreenGui, highlighter: (Instance?, boolean?, Instance?)->())
	local self = setmetatable({}, Drag)
	self.Tree = tree
	self.Resolve = resolveId
	self.ScreenGui = screenGui
	self.Highlight = highlighter

	self.IsMouseDown = false
	self.IsDragging = false
	self.StartPos = nil
	self.SourceInst = nil
	self.DragSelection = nil
	self.Target = nil
	self.Ghost = nil
	self.Conns = {}

	self.OnDropped = Core.Signal()

	return self
end

local function owningScreenGui(gui: GuiObject)
	return gui:IsA("ScreenGui") and gui or gui:FindFirstAncestorOfClass("ScreenGui")
end

local function adjustedMouseFor(gui: GuiObject): Vector2
	local pos = UserInputService:GetMouseLocation()
	local sg = owningScreenGui(gui)
	if sg and sg.IgnoreGuiInset then
		pos -= GuiService:GetGuiInset()
	end
	return pos
end

local function guiContains(gui: GuiObject, screenPt: Vector2): boolean
	local p, s = gui.AbsolutePosition, gui.AbsoluteSize
	return screenPt.X >= p.X and screenPt.X <= p.X + s.X
		and screenPt.Y >= p.Y and screenPt.Y <= p.Y + s.Y
end

local function screenToGuiParent(parent: Instance, screenPt: Vector2): Vector2
	local sg = parent:IsA("ScreenGui") and parent or parent:FindFirstAncestorOfClass("ScreenGui")
	local inset = Vector2.new(0, 0)
	if sg and sg.IgnoreGuiInset == false then
		inset = GuiService:GetGuiInset()
	end

	local guiPos = screenPt - inset

	local parentPos = (parent :: any).AbsolutePosition or Vector2.new(0, 0)
	return guiPos - parentPos
end

local function distance(a: Vector2, b: Vector2): number
	local dx, dy = a.X - b.X, a.Y - b.Y
	return math.sqrt(dx * dx + dy * dy)
end

local function rowAtScreenPoint(treeList: ScrollingFrame, screenPt: Vector2)
	for _, child in pairs(treeList:GetChildren()) do
		if child:IsA("Frame") and child:GetAttribute("AtlasRow") == true then
			if guiContains(child, screenPt) then return child end
		end
	end
	return nil
end

local function buildDragSelection(tree, pressedInst: Instance)
	local arr, set = tree:GetSelection()
	if set[pressedInst] then return arr else return { pressedInst } end
end

local function canDrop(selectionSet: {[Instance]: boolean}, child: Instance, newParent: Instance)
	if not newParent then return false end
	if selectionSet[newParent] then return false end
	if child == newParent then return false end
	return Core.canReparent(child, newParent)
end

local function mkSelectionSet(arr)
	local s = {}
	for _, v in pairs(arr) do s[v] = true end
	return s
end

function Drag:_makeGhost(labelText: string)
	if self.Ghost then self.Ghost:Destroy() end
	local f = Instance.new("Frame")
	f.Size = UDim2.fromOffset(260, 22)
	f.BackgroundColor3 = Color3.fromRGB(20, 114, 255)
	f.BackgroundTransparency = 0.35
	f.BorderSizePixel = 0
	f.ZIndex = 1000
	f.Active = false
	f.Parent = self.ScreenGui

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Transparency = 0.3
	stroke.Parent = f

	local txt = Instance.new("TextLabel")
	txt.Size = UDim2.new(1, -10, 1, 0)
	txt.Position = UDim2.fromOffset(10, 0)
	txt.BackgroundTransparency = 1
	txt.TextXAlignment = Enum.TextXAlignment.Left
	txt.Font = Enum.Font.GothamSemibold
	txt.TextSize = 14
	txt.TextColor3 = Color3.new(1, 1, 1)
	txt.Text = labelText
	txt.ZIndex = f.ZIndex + 1
	txt.Parent = f

	self.Ghost = f
end

function Drag:_moveGhost(screenPos: Vector2)
	if not self.Ghost then return end
	local parent = self.Ghost.Parent
	local localPos = screenToGuiParent(parent, screenPos + GHOST_OFFSET)
	self.Ghost.Position = UDim2.fromOffset(localPos.X, localPos.Y)
end

function Drag:_destroyGhost()
	if self.Ghost then self.Ghost:Destroy() end
	self.Ghost = nil
end

function Drag:BindRow(row: Frame)
	local instId = row:GetAttribute("AtlasId")
	if not instId then return end
	local inst = self.Resolve(instId)
	if not inst then return end

	local press = row:FindFirstChild("Press")
	if not press or not press:IsA("TextButton") then
		press = row
	end

	press.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.IsMouseDown = true
			self.IsDragging = false
			self.StartPos = adjustedMouseFor(row)
			self.SourceInst = inst
			self.Target = nil
			self.DragSelection = nil
		end
	end)

	press.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local wasDragging = self.IsDragging
			self.IsMouseDown = false

			if wasDragging then
				self:DropOrRevert()
			end

			self.IsDragging = false
			self.StartPos = nil
			self.SourceInst = nil
			self.Target = nil
			self.DragSelection = nil
			self:_destroyGhost()
			self.Highlight(nil)
		end
	end)

	press.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if self.IsMouseDown and not self.IsDragging then
				local cur = adjustedMouseFor(row)
				if distance(cur, self.StartPos) >= DRAG_THRESHOLD then
					self.IsDragging = true
					self.DragSelection = buildDragSelection(self.Tree, self.SourceInst)
					local label
					if #self.DragSelection == 1 then
						local only = self.DragSelection[1]
						label = string.format("Move: %s [%s]", only.Name, only.ClassName)
					else
						label = string.format("Move %d items", #self.DragSelection)
					end
					self:_makeGhost(label)
					self:_moveGhost(cur)
				end
			end
		end
	end)

	if not self._mouseConn then
		self._mouseConn = UserInputService.InputChanged:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
			if not self.IsDragging then return end

			local mpos = adjustedMouseFor(self.Tree.Frame)
			self:_moveGhost(mpos)

			local treeList = self.Tree.Frame
			local rowHit = rowAtScreenPoint(treeList, mpos)
			local targetInst = nil
			if rowHit then
				local aid = rowHit:GetAttribute("AtlasId")
				if aid then targetInst = self.Resolve(aid) end
			end

			self.Target = nil
			local selSet = mkSelectionSet(self.DragSelection or {})
			if targetInst then
				local okAll = true
				for _, child in pairs(self.DragSelection or {}) do
					if not canDrop(selSet, child, targetInst) then okAll = false; break end
				end
				self.Target = okAll and targetInst or nil
				self.Highlight(targetInst, true)
				if self.Ghost then
					self.Ghost.BackgroundColor3 = okAll and HILITE_OK or HILITE_BAD
				end
			else
				self.Highlight(nil)
				if self.Ghost then self.Ghost.BackgroundColor3 = Color3.fromRGB(20, 114, 255) end
			end
		end)
	end
end

function Drag:DropOrRevert()
	if not self.IsDragging or not self.DragSelection then return end
	local target = self.Target
	if not target then return end

	local selSet = mkSelectionSet(self.DragSelection)
	local moved = {}
	for _, child in pairs(self.DragSelection) do
		if canDrop(selSet, child, target) then
			local ok = pcall(function() child.Parent = target end)
			if ok then table.insert(moved, child) end
		end
	end

	if #moved > 0 then
		if self.Tree.RefreshNow then
			self.Tree:RefreshNow()
		else
			self.Tree:Refresh()
		end

		if self.Tree.ExpandSet then
			self.Tree:ExpandSet({ target })
		end

		if self.Tree.SetSelection then
			self.Tree:SetSelection(moved, moved[#moved])
		end
		if self.Tree.Reveal then
			self.Tree:Reveal(target)
			self.Tree:Reveal(moved[#moved])
		end

		if self.OnDropped then
			self.OnDropped:Fire(moved, target)
		end
	end
end

return Drag
