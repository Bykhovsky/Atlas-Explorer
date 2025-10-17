--[[
	@class AtlasContextMenu

	> [Responsible for right-click context interactions within the Explorer tree].
		- Dynamically generates context actions such as Delete, Duplicate, Cut, Paste, Expand/Collapse All, Select Children, and Insert Object.
	
	> Author: @Bykhovsky
	> Version: 1.0.0
	> Last updated: 10/17/2025
]]--

local Core = require(script.Parent.AtlasCore)

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local Menu = {}
Menu.__index = Menu

local CURSOR_MARGIN = Vector2.new(6, 6)

function Menu.new(menuFrame: Frame, itemTemplate: TextButton)
	local self = setmetatable({}, Menu)
	self.Frame = menuFrame
	self.ItemTemplate = itemTemplate:Clone()
	self.ItemTemplate.Parent = nil

	self.Frame.Visible = false
	self.Frame.ClipsDescendants = false
	self.Frame.AnchorPoint = Vector2.new(0, 0)
	self.OnChoose = Core.Signal()

	local layout = self.Frame:FindFirstChildOfClass("UIListLayout")
	if not layout then
		layout = Instance.new("UIListLayout")
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Padding = UDim.new(0, 2)
		layout.Parent = self.Frame
	end

	self._outsideConn = nil
	return self
end

local function destroyOldItems(container: Instance)
	for _, child in ipairs(container:GetChildren()) do
		if child:GetAttribute("AtlasMenuItem") == true then child:Destroy() end
	end
end

local function screenToParent(parent: GuiObject, screenPos: Vector2): Vector2
	local inset = GuiService:GetGuiInset()
	local guiPos = screenPos - inset
	local p0 = parent.AbsolutePosition
	return guiPos - p0
end

local function adjustedMouseFor(gui: GuiObject): Vector2
	local pos = UserInputService:GetMouseLocation()
	local sg = gui:IsA("ScreenGui") and gui or gui:FindFirstAncestorOfClass("ScreenGui")
	if sg and sg.IgnoreGuiInset then
		pos -= GuiService:GetGuiInset()
	end
	return pos
end

local function pointInGui(gui: GuiObject, ptScreen: Vector2): boolean
	local p, s = gui.AbsolutePosition, gui.AbsoluteSize
	return ptScreen.X >= p.X and ptScreen.X <= p.X + s.X
		and ptScreen.Y >= p.Y and ptScreen.Y <= p.Y + s.Y
end

function Menu:_bindOutsideToHide()
	if self._outsideConn then self._outsideConn:Disconnect() end
	self._outsideConn = UserInputService.InputBegan:Connect(function(input)
		if not self.Frame.Visible then return end

		if input.KeyCode == Enum.KeyCode.Escape then self:Hide(); return end

		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.MouseButton2
			or input.UserInputType == Enum.UserInputType.MouseButton3 then
			local mpos = adjustedMouseFor(self.Frame)
			if not pointInGui(self.Frame, mpos) then self:Hide() end
		end
	end)
end

function Menu:Show(actions: {string | {text:string, enabled:boolean}}, target: Instance, screenPos: Vector2)
	destroyOldItems(self.Frame)
	self.Frame.Visible = true

	for i, a in pairs(actions) do
		local text, enabled
		if type(a) == "table" then text, enabled = a.text, (a.enabled ~= false) else text, enabled = a, true end
		local item = self.ItemTemplate:Clone()
		item.Visible = true
		item.Name = "Item_" .. i
		item:SetAttribute("AtlasMenuItem", true)
		item.Parent = self.Frame
		item.Text = text
		if enabled then
			item.AutoButtonColor = true
			item.TextTransparency = 0
			item.MouseButton1Click:Connect(function()
				self.OnChoose:Fire(text, target); self:Hide()
			end)
		else
			item.AutoButtonColor = false
			item.TextTransparency = 0.35
			item.Active = false
		end
	end

	task.defer(function()
		if not self.Frame.Parent then return end
		local parent = self.Frame.Parent :: GuiObject
		local desired = screenToParent(parent, screenPos) + CURSOR_MARGIN

		local menuSize = self.Frame.AbsoluteSize
		local parentSize = parent.AbsoluteSize
		local maxX = math.max(0, parentSize.X - menuSize.X)
		local maxY = math.max(0, parentSize.Y - menuSize.Y)

		local x = math.clamp(desired.X, 0, maxX)
		local y = math.clamp(desired.Y, 0, maxY)
		self.Frame.AnchorPoint = Vector2.new(0, 0)
		self.Frame.Position = UDim2.fromOffset(x, y)
	end)

	self:_bindOutsideToHide()
end

function Menu:Hide()
	self.Frame.Visible = false
	if self._outsideConn then self._outsideConn:Disconnect(); self._outsideConn = nil end
end

return Menu
