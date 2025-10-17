--[[
	@class Core
	
		> [The root manager of the entire Atlas system].
			- Handles initialization, inter-module communication, UI mounting, and lifecycle management.
			- Essentially the brain of the Atlas Explorer runtime.

	> Author: @Bykhovsky
	> Version: 1.0.0
	> Last updated: 10/17/2025
]]--

local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")

local APIService = require(script.Parent.APIService)

local Core = {}

function Core.Signal()
	local bindable = Instance.new("BindableEvent")
	return {
		Connect = function(_, fn) return bindable.Event:Connect(fn) end,
		Fire = function(_, ...) bindable:Fire(...) end,
		Destroy = function(_) bindable:Destroy() end
	}
end

function Core.safeGet(inst, prop)
	local ok, v = pcall(function() return inst[prop] end)
	return ok and v or nil
end
function Core.safeSet(inst, prop, value)
	return pcall(function() inst[prop] = value end)
end

function Core.pathOf(inst: Instance)
	local segs = {}
	local cur = inst
	while cur and cur ~= game do
		table.insert(segs, 1, ("%s[%s]"):format(cur.ClassName, cur.Name))
		cur = cur.Parent
	end
	return table.concat(segs, " > ")
end

function Core.canReparent(child: Instance, newParent: Instance)
	if child == newParent then return false end
	local p = newParent
	while p do
		if p == child then return false end
		p = p.Parent
	end
	return true
end

local function kindOf(v)
	local t = typeof(v)
	if t == "EnumItem" then return "enum" end
	if t == "BrickColor" then return "BrickColor" end
	if t == "Color3" then return "Color3" end
	if t == "Vector3" then return "Vector3" end
	if t == "Vector2" then return "Vector2" end
	if t == "UDim2" then return "UDim2" end
	if t == "UDim" then return "UDim" end
	if t == "CFrame" then return "CFrame" end
	if t == "boolean" then return "boolean" end
	if t == "number" then return "number" end
	if t == "string" then return "string" end
	return "other"
end

local function isWritable(inst, prop, current)
	local ok = pcall(function() inst[prop] = current end)
	return ok
end

local function startsUpper(s) return s:match("^[A-Z]") ~= nil end
local function upperScore(s)
	local n = 0
	for _ in s:gmatch("%u") do n += 1 end
	return n
end

local function pickPreferredName(a, b)
	local au, bu = startsUpper(a), startsUpper(b)
	if au ~= bu then return au and a or b end
	local sa, sb = upperScore(a), upperScore(b)
	if sa ~= sb then return (sa > sb) and a or b end
	return a
end

function Core.bestInsertParent(target: Instance): Instance
	local cur = target
	while cur do
		if cur:IsA("Workspace") or cur:IsA("Model") or cur:IsA("Folder") or cur:IsA("Tool") then
			return cur
		end
		cur = cur.Parent
	end
	return workspace
end

function Core.insertPartInto(parent: Instance): Instance?
	local part = Instance.new("Part")
	part.Name = "Part"
	part.Anchored = true
	part.Size = Vector3.new(4, 1, 4)
	part.Position = Vector3.new(0, 5, 0)
	local ok = pcall(function() part.Parent = parent end)
	if not ok then part:Destroy(); return nil end
	return part
end

function Core.getPropsFor(inst: Instance)
	local specs = {}
	local byKey = {}

	local function consider(propName: string)
		local ok, val = pcall(function() return inst[propName] end)
		if not ok then return end
		local k = propName:lower()
		local cur = byKey[k]
		if not cur then
			byKey[k] = { prop = propName, val = val }
		else
			local chosen = pickPreferredName(cur.prop, propName)
			if chosen ~= cur.prop then
				byKey[k] = { prop = chosen, val = (chosen == propName) and val or cur.val }
			end
		end
	end

	for propName, _ in APIService:GetProperties(inst) do
		consider(propName)
	end

	consider("Name"); consider("Parent"); consider("ClassName")

	for _, e in pairs(byKey) do
		local v = e.val
		local spec = { prop = e.prop, kind = kindOf(v), readOnly = false }

		if spec.kind == "enum" and typeof(v) == "EnumItem" then
			spec.enum = v.EnumType
		end

		if e.prop == "Parent" or e.prop == "ClassName" then
			spec.readOnly = true
		end

		if APIService.IsPropertyWritable then
			local okW, wr = pcall(function() return APIService:IsPropertyWritable(inst, e.prop) end)
			if okW and wr == false then spec.readOnly = true end
		end

		table.insert(specs, spec)
	end

	table.sort(specs, function(a,b)
		local pa = (a.prop == "Name" and 0) or (a.prop == "Parent" and 1) or (a.prop == "ClassName" and 2) or 3
		local pb = (b.prop == "Name" and 0) or (b.prop == "Parent" and 1) or (b.prop == "ClassName" and 2) or 3
		if pa ~= pb then return pa < pb end
		return a.prop:lower() < b.prop:lower()
	end)

	return specs
end

function Core.getTags(inst) return CollectionService:GetTags(inst) end
function Core.addTag(inst, tag) pcall(function() CollectionService:AddTag(inst, tag) end) end
function Core.removeTag(inst, tag) pcall(function() CollectionService:RemoveTag(inst, tag) end) end

function Core.getAttributes(inst)
	local attrs = {}
	for k, v in pairs(inst:GetAttributes()) do
		local t = typeof(v)
		table.insert(attrs, {key = k, value = v, type = t})
	end
	table.sort(attrs, function(a, b) return a.key:lower() < b.key:lower() end)
	return attrs
end

return Core
