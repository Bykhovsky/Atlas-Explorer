--[[
	@class AtlasId

	> [Provides unique, consistent identifiers for instances within the Explorer].
		- Used internally for selection tracking, drag synchronization, and cross-module reference integrity.
	
	> Author: @Bykhovsky
	> Version: 1.0.0
	> Last updated: 10/17/2025
]]--


local HttpService = game:GetService("HttpService")

local instToId = setmetatable({}, { __mode = "k" })
local idToInst = setmetatable({}, { __mode = "v" })

local Id = {}

function Id.Get(inst: Instance): string
	local id = instToId[inst]
	if id then return id end
	id = HttpService:GenerateGUID(false)
	instToId[inst] = id
	idToInst[id] = inst

	if inst.Destroying then
		inst.Destroying:Once(function()
			idToInst[id] = nil
			instToId[inst] = nil
		end)
	else
		inst.AncestryChanged:Connect(function(_, parent)
			if parent == nil then
				idToInst[id] = nil; instToId[inst] = nil
			end
		end)
	end

	return id
end

function Id.Resolve(id: string): Instance?
	return idToInst[id]
end

return Id
