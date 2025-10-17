--[[
	* MainHandler.lua
	
		> [This is the client initiator for the User-Interface].
	
	> Author: @Bykhovsky
	> Version: 1.0.0
	> Last updated: 10/17/2025
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

local client = Players.LocalPlayer

local ui = script.Parent
local modules = ui.Modules

local APIService = require(modules.APIService)

local Id = require(modules.AtlasId)
local Core = require(modules.AtlasCore)
local Icons = require(modules.AtlasIcons)
local TreeModule = require(modules.AtlasTree)
local DragModule = require(modules.AtlasDrag)
local Clipboard = require(modules.AtlasClipboard)
local PropsModule = require(modules.AtlasProperties)
local MenuModule = require(modules.AtlasContextMenu)
local ObjectBrowser = require(modules.AtlasObjectBrowser)

local mainFrame = ui:WaitForChild("MainFrame")

local Explorer = mainFrame:WaitForChild("Explorer")
local Properties = mainFrame:WaitForChild("Properties")

local TreeFrame: Frame = Explorer.Tree
local TreeList: ScrollingFrame = TreeFrame.TreeList
local RowTemplate: Frame = TreeFrame.RowTemplate
local ExplorerSearch: TextBox = Explorer.SearchBox.Input

local PropContainer: Frame = Properties.Container
local PropList: ScrollingFrame = PropContainer.PropertyList
local PropTitle: TextLabel = Properties.Title
local PropSearch: TextBox = Properties.SearchBox.Input

local ContextMenu: Frame = mainFrame.ContextMenu
local ItemTemplate: TextButton = ContextMenu.ItemTemplate

local ObjectBrowserFrame: Frame = mainFrame:WaitForChild("ObjectBrowser")
local OBSearch: TextBox = ObjectBrowserFrame.SearchBox.Input
local OBList: ScrollingFrame = ObjectBrowserFrame.ObjectList
local OBTemplate: Frame = ObjectBrowserFrame.ObjectTemplate

local lastPrimary: Instance? = nil
local currentHover: Instance? = nil

local tree = TreeModule.new(TreeList, RowTemplate)
local serviceSignals = {
	game:GetService("Workspace"),
	game:GetService("Players"),
	game:GetService("Lighting"),
	game:GetService("MaterialService"),
	game:GetService("NetworkClient"),
	game:GetService("ReplicatedFirst"),
	game:GetService("ReplicatedStorage"),
	game:GetService("ServerScriptService"),
	game:GetService("ServerStorage"),
	game:GetService("StarterGui"),
	game:GetService("StarterPack"),
	game:GetService("StarterPlayer"),
	game:GetService("Teams"),
	game:GetService("SoundService"),
	game:GetService("TextChatService"),
}

tree:Mount(serviceSignals)

local creatableClassMembers = APIService:GetCreatableclassMembers()
-- // print(#creatableClassMembers, creatableClassMembers)

local HILITE_SEL   = Color3.fromRGB(20, 114, 255)
local HILITE_HOVER = Color3.fromRGB(180, 180, 180)

local function repaintSelection(selectedSet: {[Instance]:boolean}?, hoverInst: Instance?)
	for _, child in pairs(TreeList:GetChildren()) do
		if child:IsA("Frame") and child:GetAttribute("AtlasRow") == true then
			local aid  = child:GetAttribute("AtlasId")
			local inst = aid and Id.Resolve(aid) or nil
			local isSel = inst and selectedSet and selectedSet[inst] or false
			if isSel then
				child.BackgroundColor3 = HILITE_SEL
				child.BackgroundTransparency = 0.65
			else
				local isHover = hoverInst and aid == Id.Get(hoverInst)
				child.BackgroundColor3 = HILITE_HOVER
				child.BackgroundTransparency = isHover and 0.85 or 1
			end
		end
	end
end

local function rowExistsFor(inst: Instance?): boolean
	if not inst then return false end
	local id = Id.Get(inst)
	for _, child in pairs(TreeList:GetChildren()) do
		if child:IsA("Frame") and child:GetAttribute("AtlasRow") == true then
			if child:GetAttribute("AtlasId") == id then return true end
		end
	end
	return false
end

local function highlightInstance(hoverInst: Instance?)
	currentHover = hoverInst
	local _, set = tree:GetSelection()
	repaintSelection(set, currentHover)
end

local dragSys = DragModule.new(tree, Id.Resolve, ui, highlightInstance)

local function bindAllRowsForDrag()
	for _, child in pairs(TreeList:GetChildren()) do
		if child:IsA("Frame") and child:GetAttribute("AtlasRow") == true then
			dragSys:BindRow(child)
		end
	end
end

do
	local origRender = tree.Render
	tree.Render = function(self, filter)
		origRender(self, filter)
		bindAllRowsForDrag()
		if currentHover and not rowExistsFor(currentHover) then
			currentHover = nil
		end
		local _, set = self:GetSelection()
		repaintSelection(set, currentHover)
	end
end

tree:Render()

local props = PropsModule.new(PropList, PropTitle, Properties)

local browser = ObjectBrowser.new(ObjectBrowserFrame, OBSearch, OBList, OBTemplate, APIService, Icons)

if dragSys.OnDropped then
	dragSys.OnDropped:Connect(function(moved, parent)
		if moved and #moved > 0 then
			props:Render(moved[#moved], nil)
		end
	end)
end

tree.OnHover:Connect(function(inst)
	currentHover = inst
	local _, set = tree:GetSelection()
	repaintSelection(set, currentHover)
end)

tree.OnSelectionChanged:Connect(function(selectionArray, primary)
	lastPrimary = primary
	if primary then
		PropSearch.Text = ""
		props:Render(primary, nil)
	else
		props:Render(nil, nil)
	end
	local _, set = tree:GetSelection()
	repaintSelection(set, nil)
	if currentHover and not rowExistsFor(currentHover) then currentHover = nil end
	repaintSelection(set, currentHover)
end)

local menu = MenuModule.new(ContextMenu, ItemTemplate)
tree.OnRightClick:Connect(function(inst)
	local selection = select(1, tree:GetSelection())
	local hasSel = #selection >= 1
	local actions = {
		{text="Rename", enabled = (#selection == 1)},
		{text="Duplicate", enabled = hasSel},
		{text="Copy", enabled = hasSel},
		{text="Cut", enabled = hasSel},
		{text="Paste", enabled = Clipboard.Has()},
		{text="Delete", enabled = hasSel},
		{text="————————", enabled = false},
		{text="Expand All", enabled = true},
		{text="Collapse All", enabled = true},
		{text="Select Children", enabled = (#inst:GetChildren() > 0)},
		{text="Insert Part", enabled = true},
		{text="Insert Object", enabled = true},
	}
	menu:Show(actions, inst, UserInputService:GetMouseLocation())
end)

menu.OnChoose:Connect(function(action, target)
	local selection = select(1, tree:GetSelection())
	local targets = (#selection >= 1) and selection or {target}

	if action == "Expand All" then
		local parents = (#selection > 0) and selection or { target }
		tree:ExpandAllSet(parents)
	elseif action == "Collapse All" then
		local parents = (#selection > 0) and selection or { target }
		tree:CollapseAllSet(parents)
	elseif action == "Select Children" then
		local parents = (#selection >= 1) and selection or { target }
		tree:ExpandSet(parents)
		local newSel = {}
		for _, p in pairs(parents) do
			for _, c in pairs(p:GetChildren()) do
				table.insert(newSel, c)
			end
		end
		if #newSel > 0 then
			tree:SetSelection(newSel, newSel[#newSel])
			tree:Reveal(newSel[1])
		else
			tree:ClearSelection()
		end
	elseif action == "Insert Part" then
		local parents = (#selection >= 1) and selection or { target }
		local inserted = {}
		for _, t in pairs(parents) do
			local p = Core.insertPartInto(Core.bestInsertParent(t))
			if p then table.insert(inserted, p) end
		end
		if #inserted > 0 then
			tree:Refresh()
			tree:ExpandPaths(inserted)
			tree:SetSelection(inserted, inserted[#inserted])
			tree:Reveal(inserted[#inserted])
			props:Render(inserted[#inserted], nil)
		end
	end
	if action == "Rename" and #selection == 1 then
		local inst = selection[1]
		local new = tostring(inst.Name) .. "_Renamed"
		Core.safeSet(inst, "Name", new)
		tree:Refresh()
		props:Render(inst, PropSearch.Text ~= "" and PropSearch.Text:lower() or nil)
	elseif action == "Delete" and #selection >= 1 then
		for _, inst in pairs(selection) do pcall(function() inst:Destroy() end) end
		tree:Refresh()
		props:Render(nil, nil)
	elseif action == "Duplicate" and #selection >= 1 then
		for _, inst in pairs(selection) do
			local ok, clone = pcall(function() return inst:Clone() end)
			if ok and clone then
				clone.Name = inst.Name .. "_Copy"
				clone.Parent = inst.Parent
			end
		end
		tree:Refresh()
	elseif action == "Copy" and #selection >= 1 then
		Clipboard.Copy(selection)
	elseif action == "Cut" and #selection >= 1 then
		Clipboard.Cut(selection)
		tree:Refresh()
	elseif action == "Paste" and Clipboard.Has() then
		local parent = target
		local pasted = Clipboard.PasteInto(parent)
		if #pasted > 0 then
			tree:RefreshNow()
			tree:ExpandSet({ parent })
			tree:SetSelection(pasted, pasted[#pasted])
			tree:Reveal(parent)
			tree:Reveal(pasted[#pasted])
			props:Render(pasted[#pasted], nil)
		end
	end
	if action == "Insert Object" then
		local parents = selection
		browser:Open(parents, function(created)
			if #created > 0 then
				tree:Refresh()
				for _, inst in pairs(created) do
					tree:ExpandPath(inst)
				end
				tree:SetSelection(created, created[#created])
				tree:Reveal(created[#created])
			end
		end)
	end
end)

ExplorerSearch:GetPropertyChangedSignal("Text"):Connect(function()
	local txt = ExplorerSearch.Text
	local q = (txt ~= "" and txt:lower() or nil)
	if q then
		tree:Render(q)
	else
		if lastPrimary then
			tree:Reveal(lastPrimary)
		else
			tree:Render(nil)
		end
	end
end)

PropSearch:GetPropertyChangedSignal("Text"):Connect(function()
	local q = PropSearch.Text:lower()
	if q == "" then q = nil end
	props:Render(props.Selected, q)
end)

RunService.RenderStepped:Connect(function()
	if props.Selected and props.Selected.Parent == nil then
		props:Render(nil, nil)
	end
end)

ObjectBrowserFrame.Exit.MouseButton1Click:Connect(function()
	browser:Close()
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.Escape then
		tree:ClearSelection(); menu:Hide()
	end
end)
