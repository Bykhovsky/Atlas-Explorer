--[[
	@class AtlasClipboard

	> [Handles cut, copy, paste, and duplication operations within the Explorer].
		- Keeps a consistent clipboard state across multiple selections and ensures correct parenting and hierarchy replication.

	> Author: @Bykhovsky
	> Version: 1.0.0
	> Last updated: 10/17/2025
]]--

local Clipboard = {}
Clipboard._mode = nil
Clipboard._items = {}

function Clipboard.Has()
	return #Clipboard._items > 0
end

function Clipboard.Clear()
	Clipboard._mode = nil
	table.clear(Clipboard._items)
end

function Clipboard.Copy(instances: {Instance})
	Clipboard._mode = "copy"
	Clipboard._items = {}
	for _, inst in pairs(instances) do
		table.insert(Clipboard._items, inst)
	end
end

function Clipboard.Cut(instances: {Instance})
	Clipboard._mode = "cut"
	Clipboard._items = {}
	for _, inst in pairs(instances) do
		table.insert(Clipboard._items, inst)
		pcall(function() inst.Parent = nil end)
	end
end

function Clipboard.PasteInto(parent: Instance): {Instance}
	local pasted = {}
	if not parent then return pasted end
	if Clipboard._mode == "copy" then
		for _, src in pairs(Clipboard._items) do
			if src then
				local ok, clone = pcall(function() return src:Clone() end)
				if ok and clone then clone.Parent = parent; table.insert(pasted, clone) end
			end
		end
	elseif Clipboard._mode == "cut" then
		for _, inst in pairs(Clipboard._items) do
			if inst and inst.Parent == nil then
				local ok = pcall(function() inst.Parent = parent end)
				if ok then table.insert(pasted, inst) end
			end
		end; Clipboard.Clear()
	end
	return pasted
end

return Clipboard
