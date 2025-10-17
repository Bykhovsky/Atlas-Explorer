--[[
	@class AtlasObjectBrowser
		
	> [The searchable creation UI for inserting new Roblox objects].
		- Integrates with `APIService` to display all instantiable classes, allows live filtering, hover and selection effects, and instantiates chosen objects directly into selected parents.

	> Author: @Bykhovsky
	> Version: 1.0.0
	> Last updated: 10/17/2025
]]--

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local ObjectBrowser = {}
ObjectBrowser.__index = ObjectBrowser

local HOVER_BG = Color3.fromRGB(230, 239, 255)
local CLICK_BG = Color3.fromRGB(20, 114, 255)
local CLICK_TEXT = Color3.fromRGB(255, 255, 255)

local TRANS_DEFAULT = 1
local TRANS_HOVER = 0.85
local TRANS_CLICK = 0.65

local function owningScreenGui(gui: GuiObject)
	return gui:IsA("ScreenGui") and gui or gui:FindFirstAncestorOfClass("ScreenGui")
end

local function adjustedMouseFor(gui: GuiObject): Vector2
	local pos = UserInputService:GetMouseLocation()
	local sg  = owningScreenGui(gui)
	if sg and sg.IgnoreGuiInset then pos -= GuiService:GetGuiInset() end
	return pos
end

local function guiContains(gui: GuiObject, ptScreen: Vector2): boolean
	local p, s = gui.AbsolutePosition, gui.AbsoluteSize
	return ptScreen.X >= p.X and ptScreen.X <= p.X + s.X
		and ptScreen.Y >= p.Y and ptScreen.Y <= p.Y + s.Y
end

local function setIcon(iconLabel: ImageLabel?, Icons, className: string)
	if not iconLabel then return end
	local info = Icons["Instance"]
	if Icons and Icons[className] then
		info = Icons[className]
	end
	iconLabel.Image = "rbxassetid://124740049830344"
	iconLabel.ImageRectOffset = info.ImageRectOffset
	iconLabel.ImageRectSize   = info.ImageRectSize
end

local function ensureLayout(listFrame: ScrollingFrame, itemTemplate: Frame)
	local layout = listFrame:FindFirstChildOfClass("UIGridLayout")
	if layout then
		return layout :: UIGridLayout
	end
	local ll = listFrame:FindFirstChildOfClass("UIListLayout")
	if ll then
		ll.FillDirection = Enum.FillDirection.Horizontal
		ll.HorizontalAlignment = Enum.HorizontalAlignment.Left
		ll.VerticalAlignment = Enum.VerticalAlignment.Top
		return ll
	end
	local cell = itemTemplate.AbsoluteSize
	if cell.X == 0 or cell.Y == 0 then cell = Vector2.new(160, 48) end
	local gl = Instance.new("UIGridLayout")
	gl.CellSize = UDim2.fromOffset(cell.X, cell.Y)
	gl.CellPadding = UDim2.fromOffset(8, 8)
	gl.SortOrder = Enum.SortOrder.LayoutOrder
	gl.FillDirection = Enum.FillDirection.Vertical
	gl.HorizontalAlignment = Enum.HorizontalAlignment.Left
	gl.VerticalAlignment = Enum.VerticalAlignment.Top
	gl.Parent = listFrame
	return gl
end

function ObjectBrowser.new(rootFrame: Frame, searchBox: TextBox, listFrame: ScrollingFrame, itemTemplate: Frame, APIService, Icons)
	local self = setmetatable({}, ObjectBrowser)
	self.Root = rootFrame
	self.Search = searchBox
	self.List = listFrame
	self.Template = itemTemplate
	self.API = APIService
	self.Icons = Icons

	self._built = false
	self._items = {}
	self._overlay = nil
	self._escConn = nil
	self._closeConn = nil
	self._outsideConn = nil

	self.List.ScrollingDirection = Enum.ScrollingDirection.X
	self._layout = ensureLayout(self.List, self.Template)

	local function updateCanvasX()
		local size = self._layout.AbsoluteContentSize
		local cur  = self.List.CanvasSize
		self.List.CanvasSize = UDim2.new(cur.X.Scale, size.X, cur.Y.Scale, cur.Y.Offset)
	end
	self._updateCanvasX = updateCanvasX

	self._layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		updateCanvasX()
	end)

	self.Search:GetPropertyChangedSignal("Text"):Connect(function()
		self:_filter(self.Search.Text)
	end)

	return self
end

function ObjectBrowser:_build()
	if self._built then return end
	self._built = true

	local classes = {}
	for _, name in pairs(self.API:GetCreatableclassMembers()) do
		table.insert(classes, name)
	end
	table.sort(classes, function(a, b) return a:lower() < b:lower() end)

	for i, className in pairs(classes) do
		local item = self.Template:Clone()
		item.Name = "Item_" .. className
		item.Visible = true
		item.Parent = self.List
		item.LayoutOrder = i
		item.Active = true

		local label = item:FindFirstChild("Label")
		if label and (label:IsA("TextLabel") or label:IsA("TextButton")) then
			label.Text = className
		end
		local icon = item:FindFirstChild("Icon")
		if icon and icon:IsA("ImageLabel") then
			setIcon(icon, self.Icons, className)
		end

		local baseBg = item.BackgroundColor3
		local baseTrans = item.BackgroundTransparency
		local baseText = (label and label:IsA("TextLabel") or label and label:IsA("TextButton")) and (label :: TextLabel).TextColor3 or Color3.new(1, 1, 1)

		item.MouseEnter:Connect(function()
			if item:GetAttribute("OB_Clicked") == true then return end
			item.BackgroundColor3 = HOVER_BG
			item.BackgroundTransparency = TRANS_HOVER
		end)

		item.MouseLeave:Connect(function()
			if item:GetAttribute("OB_Clicked") == true then return end
			item.BackgroundColor3 = baseBg
			item.BackgroundTransparency = baseTrans
			if label and (label:IsA("TextLabel") or label:IsA("TextButton")) then
				(label :: TextLabel).TextColor3 = baseText
			end
		end)

		local function choose()
			item:SetAttribute("OB_Clicked", true)
			item.BackgroundColor3 = CLICK_BG
			item.BackgroundTransparency = TRANS_CLICK
			if label and (label:IsA("TextLabel") or label:IsA("TextButton")) then
				(label :: TextLabel).TextColor3 = CLICK_TEXT
			end
			if self._onChoose then
				self._onChoose(className)
			end
		end

		local press = item:FindFirstChild("Press")
		if press and press:IsA("TextButton") then
			press.MouseButton1Click:Connect(choose)
		end
		if label and label:IsA("TextButton") then
			label.MouseButton1Click:Connect(choose)
		end

		table.insert(self._items, {
			frame = item,
			name = className,
			label = label :: TextLabel?,
			baseBg = baseBg,
			baseText = baseText,
			baseTrans = baseTrans,
		})
	end

	self._updateCanvasX()
end

function ObjectBrowser:_filter(query: string)
	local q = (query and query:lower() or "")

	local function score(name: string)
		if q == "" then return 5000 end
		local ln = name:lower()
		if ln == q then return 0 end
		if ln:sub(1, #q) == q then return 1 end
		local pos = ln:find(q, 1, true)
		if pos then return 200 + pos end
		return 10000 + #ln
	end

	local i = 0
	for _, it in pairs(self._items) do
		local visible = (q == "") or it.name:lower():find(q, 1, true) ~= nil
		it.frame.Visible = visible
		i += 1
		it.frame.LayoutOrder = score(it.name) * 1000 + i
	end
	
	if self._updateCanvasX then self._updateCanvasX() end
end

local function makeOverlay(root: Frame): Frame
	local parent = root.Parent
	local f = Instance.new("TextButton")
	f.Name = "OB_Overlay"
	f.Text = ""
	f.AutoButtonColor = false
	f.BackgroundTransparency = 1
	f.Active = true
	f.Size = UDim2.fromScale(1,1)
	f.Position = UDim2.fromScale(0,0)
	f.ZIndex = math.max(0, root.ZIndex - 1)
	f.Parent = parent
	return f
end

function ObjectBrowser:Open(targetParents: {Instance}, onCreated: ({})->()?)
	self:_build()
	self.Root.Visible = true
	self.Root.Active = true
	
	for _, it in pairs(self._items) do
		it.frame:SetAttribute("OB_Clicked", nil)
		it.frame.BackgroundColor3 = it.baseBg
		it.frame.BackgroundTransparency = it.baseTrans or TRANS_DEFAULT
		if it.label then it.label.TextColor3 = it.baseText end
	end

	self._overlay = makeOverlay(self.Root)
	if self._closeConn then self._closeConn:Disconnect() end
	self._closeConn = self._overlay.MouseButton1Click:Connect(function()
		self:Close()
	end)

	if self._outsideConn then self._outsideConn:Disconnect() end
	self._outsideConn = UserInputService.InputBegan:Connect(function(input)
		if not self.Root.Visible then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.MouseButton2
			or input.UserInputType == Enum.UserInputType.MouseButton3 then
			local pos = adjustedMouseFor(self.Root)
			if not guiContains(self.Root, pos) then
				self:Close()
			end
		end
	end)

	if self._escConn then self._escConn:Disconnect() end
	self._escConn = UserInputService.InputBegan:Connect(function(input, gpe)
		if input.KeyCode == Enum.KeyCode.Escape then
			self:Close()
		end
	end)

	self._onChoose = function(className: string)
		local created = {}
		for _, parent in pairs(targetParents or {}) do
			local ok, inst = pcall(function()
				local c = Instance.new(className)
				c.Parent = parent return c
			end)
			if ok and inst then table.insert(created, inst) end
		end; self:Close()
		if onCreated then onCreated(created) end
	end

	self.Search.Text = ""; self:_filter("")
end

function ObjectBrowser:Close()
	self.Root.Visible = false
	self._onChoose = nil
	if self._overlay then self._overlay:Destroy(); self._overlay = nil end
	if self._escConn then self._escConn:Disconnect(); self._escConn = nil end
	if self._closeConn then self._closeConn:Disconnect(); self._closeConn = nil end
	if self._outsideConn then self._outsideConn:Disconnect(); self._outsideConn = nil end
	if self.Search then self.Search.Text = "" end
end

return ObjectBrowser
