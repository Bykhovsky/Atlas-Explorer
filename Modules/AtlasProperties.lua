--[[
	@class AtlasProperties
		
		> [Handles the properties panel and value editor].
			- Responsible for displaying, modifying, and syncing instance property data between Roblox and Atlas in real time.
			
	> Author: @Bykhovsky
	> Version: 1.0.0
	> Last updated: 10/17/2025
]]--

local RunService = game:GetService("RunService")

local Core = require(script.Parent.AtlasCore)

local Props = {}
Props.__index = Props

local FAST_HZ = 15
local MED_HZ = 5
local SENTRY_HZ = 1

local HOT_PROPS = {
	Position = true, CFrame = true, Orientation = true, Rotation = true, Size = true,
	Velocity = true, RotVelocity = true,
	AssemblyLinearVelocity = true, AssemblyAngularVelocity = true,
	ExtentsCFrame = true, ExtentsSize = true, AssemblyCenterOfMass = true,
}

local FLASH_COLOR = Color3.fromRGB(248, 238, 164)
local FLASH_TIME  = 0.05
local FLASH_ENABLED = false

local EPS = {
	number = 1e-6,
	Vector2 = 1e-4,
	Vector3 = 1e-4,
	UDim = { scale = 1e-6, offset = 0 },
	UDim2 = { scale = 1e-6, offset = 0 },
	Color3 = 1/255,
	CFrameP = 1e-4,
}

local function clone(t) local c = t:Clone(); c.Visible=true; c.Parent=nil; return c end

local function onEnter(tb: TextBox, fn)
	tb.FocusLost:Connect(function(enterPressed)
		if enterPressed then fn(tb.Text) end
	end)
end

local function isFocused(tb: TextBox)
	local ok, focused = pcall(function() return tb:IsFocused() end)
	return ok and focused
end

local function flash(gui: GuiObject)
	if FLASH_ENABLED == false then return end
	if not gui then return end
	local original = gui.BackgroundColor3
	local origT = gui.BackgroundTransparency
	gui.BackgroundColor3 = FLASH_COLOR
	gui.BackgroundTransparency = math.min(origT, 0.1)
	task.delay(FLASH_TIME, function()
		if gui and gui.Parent then
			gui.BackgroundColor3 = original
			gui.BackgroundTransparency = origT
		end
	end)
end

local function parseBool(s)
	s = s:lower()
	if s == "true" or s == "1" or s == "yes" or s == "on" then return true end
	if s == "false" or s == "0" or s == "no" or s == "off" then return false end
	return nil
end

local function parseVec3(s)
	local x,y,z = s:match("^%s*([%-%d%.]+)%s*[, ]%s*([%-%d%.]+)%s*[, ]%s*([%-%d%.]+)%s*$")
	if not x then return nil end
	return Vector3.new(tonumber(x), tonumber(y), tonumber(z))
end

local function serializeVec3(v: Vector3) return string.format("%.3f, %.3f, %.3f", v.X, v.Y, v.Z) end

local function parseVector2(s)
	local x,y = s:match("^%s*([%-%d%.]+)%s*[, ]%s*([%-%d%.]+)%s*$")
	if not x then return nil end
	return Vector2.new(tonumber(x), tonumber(y))
end

local function serializeVector2(v: Vector2) return string.format("%.3f, %.3f", v.X, v.Y) end

local function parseUDim(s)
	local sc, off = s:match("^%s*([%-%d%.]+)%s*[, ]%s*([%-%d%.]+)%s*$")
	if not sc then return nil end
	return UDim.new(tonumber(sc), math.floor(tonumber(off)))
end

local function serializeUDim(u: UDim) return string.format("%.3f, %d", u.Scale, u.Offset) end

local function parseUDim2(s)
	local xs, xo, ys, yo = s:match("^%s*([%-%d%.]+)%s*[, ]%s*([%-%d%.]+)%s*[, ]%s*([%-%d%.]+)%s*[, ]%s*([%-%d%.]+)%s*$")
	if not xs then return nil end
	return UDim2.new(tonumber(xs), math.floor(tonumber(xo)), tonumber(ys), math.floor(tonumber(yo)))
end

local function serializeUDim2(u: UDim2)
	return string.format("%.3f, %d, %.3f, %d", u.X.Scale, u.X.Offset, u.Y.Scale, u.Y.Offset)
end

local function parseColor3(s)
	local a,b,c = s:match("^%s*([%d%.]+)%s*[, ]%s*([%d%.]+)%s*[, ]%s*([%d%.]+)%s*$")
	if not a then return nil end
	local R,G,B = tonumber(a), tonumber(b), tonumber(c)
	if not (R and G and B) then return nil end
	if R > 1 or G > 1 or B > 1 then
		return Color3.fromRGB(
			math.clamp(math.floor(R + 0.5),0,255),
			math.clamp(math.floor(G + 0.5),0,255),
			math.clamp(math.floor(B + 0.5),0,255)
		)
	else
		return Color3.new(R, G, B)
	end
end

local function serializeColor3(c: Color3)
	return string.format("%d, %d, %d",
		math.floor(c.R*255 + 0.5),
		math.floor(c.G*255 + 0.5),
		math.floor(c.B*255 + 0.5))
end

local function parseBrickColor(s)
	s = s:gsub("^%s+",""):gsub("%s+$","")
	local n = tonumber(s)
	if n then
		local ok, bc = pcall(function() return BrickColor.new(n) end)
		return ok and bc or nil
	else
		local ok, bc = pcall(function() return BrickColor.new(s) end)
		return ok and bc or nil
	end
end

local function serializeBrickColor(bc: BrickColor) return bc.Name end

local function parseEnum(enumType: Enum, s: string)
	s = s:gsub("^%s+",""):gsub("%s+$","")
	for _, item in pairs(enumType:GetEnumItems()) do
		if item.Name:lower() == s:lower() then return item end
	end
	local idx = tonumber(s)
	if idx then
		local items = enumType:GetEnumItems()
		if idx >= 1 and idx <= #items then return items[idx] end
	end
	local val = tonumber(s)
	if val then
		for _, item in pairs(enumType:GetEnumItems()) do
			if item.Value == val then return item end
		end
	end
	return nil
end

local function serializeEnum(val: EnumItem?) return val and val.Name or "" end

local function coerce(kind: string, enumType: Enum?, text: string)
	if kind == "string" then return text end
	if kind == "number" then return tonumber(text) end
	if kind == "boolean" then return parseBool(text) end
	if kind == "Vector3" then return parseVec3(text) end
	if kind == "Vector2" then return parseVector2(text) end
	if kind == "UDim" then return parseUDim(text) end
	if kind == "UDim2" then return parseUDim2(text) end
	if kind == "CFrame" then local v3 = parseVec3(text); if v3 then return CFrame.new(v3) end; return nil end
	if kind == "Color3" then return parseColor3(text) end
	if kind == "BrickColor" then return parseBrickColor(text) end
	if kind == "enum" and enumType then return parseEnum(enumType, text) end
	return nil
end

local function displayString(kind: string, enumType: Enum?, val: any): string
	if val == nil then return "" end
	if kind == "Vector3" and typeof(val) == "Vector3" then return serializeVec3(val) end
	if kind == "Vector2" and typeof(val) == "Vector2" then return serializeVector2(val) end
	if kind == "UDim" and typeof(val) == "UDim" then return serializeUDim(val) end
	if kind == "UDim2" and typeof(val) == "UDim2" then return serializeUDim2(val) end
	if kind == "CFrame" and typeof(val) == "CFrame" then
		local p = val.Position
		return string.format("%.3f, %.3f, %.3f", p.X, p.Y, p.Z)
	end
	if kind == "Color3" and typeof(val) == "Color3" then return serializeColor3(val) end
	if kind == "BrickColor" and typeof(val) == "BrickColor" then return serializeBrickColor(val) end
	if kind == "enum" and typeof(val) == "EnumItem" then return serializeEnum(val) end
	return tostring(val)
end

local function approxEqual(kind: string, a: any, b: any)
	if a == nil and b == nil then return true end
	if a == nil or b == nil then return false end

	if kind == "number" and type(a) == "number" and type(b) == "number" then
		return math.abs(a - b) <= EPS.number
	elseif kind == "boolean" then
		return a == b
	elseif kind == "string" then
		return a == b
	elseif kind == "enum" and typeof(a) == "EnumItem" and typeof(b) == "EnumItem" then
		return a.Value == b.Value
	elseif kind == "BrickColor" and typeof(a) == "BrickColor" and typeof(b) == "BrickColor" then
		return a.Number == b.Number
	elseif kind == "Color3" and typeof(a) == "Color3" and typeof(b) == "Color3" then
		return math.abs(a.R - b.R) <= EPS.Color3 and math.abs(a.G-b.G) <= EPS.Color3 and math.abs(a.B - b.B) <= EPS.Color3
	elseif kind == "Vector2" and typeof(a) == "Vector2" and typeof(b) == "Vector2" then
		return (a - b).Magnitude <= EPS.Vector2
	elseif kind == "Vector3" and typeof(a) == "Vector3" and typeof(b) == "Vector3" then
		return (a - b).Magnitude <= EPS.Vector3
	elseif kind == "UDim" and typeof(a) == "UDim" and typeof(b) == "UDim" then
		return math.abs(a.Scale - b.Scale) <= EPS.UDim.scale and a.Offset == b.Offset
	elseif kind == "UDim2" and typeof(a) == "UDim2" and typeof(b) == "UDim2" then
		return math.abs(a.X.Scale - b.X.Scale) <= EPS.UDim2.scale and a.X.Offset == b.X.Offset
			and math.abs(a.Y.Scale - b.Y.Scale) <= EPS.UDim2.scale and a.Y.Offset == b.Y.Offset
	elseif kind == "CFrame" and typeof(a) == "CFrame" and typeof(b) == "CFrame" then
		return (a.Position - b.Position).Magnitude <= EPS.CFrameP
	end
	return a == b
end

local function setTitle(titleLabel: TextLabel, inst: Instance?)
	if not inst then titleLabel.Text = "Properties"
	else titleLabel.Text = string.format('Properties – %s "%s"', inst.ClassName, inst.Name) end
end

function Props.new(container: Frame, titleLabel: TextLabel, templatesParent: Instance)
	local self = setmetatable({}, Props)
	self.Container = container
	self.Title = titleLabel

	self.TagHeaderTemplate = templatesParent:FindFirstChild("TagHeader")
	self.AttributeHeaderTemplate = templatesParent:FindFirstChild("AttributeHeader")
	self.FieldTemplate = templatesParent:FindFirstChild("FieldTemplate")
	self.ToggleTemplate = templatesParent:FindFirstChild("ToggleTemplate")
	self.AttributeTemplate = templatesParent:FindFirstChild("AttributeTemplate")
	self.TagTemplate = templatesParent:FindFirstChild("TagTemplate")

	self.Selected = nil
	self.OnEdited = Core.Signal()

	self._rowByProp = {}
	self._specByProp = {}
	self._watch = {}
	self._conns = {}
	self._hbConn = nil

	return self
end

function Props:_disconnectAll()
	for _, c in pairs(self._conns) do pcall(function() c:Disconnect() end) end
	self._conns = {}
	if self._hbConn then pcall(function() self._hbConn:Disconnect() end) self._hbConn = nil end
	self._rowByProp, self._specByProp, self._watch = {}, {}, {}
end

function Props:_updateRow(propName: string, forceFlash: boolean?)
	if not self.Selected then return end
	local info = self._rowByProp[propName]; if not info then return end
	local spec = self._specByProp[propName]; if not spec then return end

	local cur = Core.safeGet(self.Selected, propName)
	if info.kind == "boolean" then
		local newText = (cur and "☑" or "☐")
		if info.check and info.check.Text ~= newText then
			info.check.Text = newText; flash(info.row)
		elseif forceFlash then flash(info.row) end
		return
	end

	local editor = info.editor
	if not editor then return end
	if isFocused(editor) then return end

	local newStr = displayString(info.kind, info.enumType, cur)
	if editor.Text ~= newStr then
		editor.Text = newStr; flash(editor)
	elseif forceFlash then flash(editor) end
end

function Props:_registerWatch(inst: Instance, spec)
	local prop = spec.prop
	local kind = spec.kind
	local initial = Core.safeGet(inst, prop)

	local w = {
		kind = kind,
		last = initial,
		method = "auto",
		fast = HOT_PROPS[prop] or false,
		pollHz = HOT_PROPS[prop] and FAST_HZ or MED_HZ,
		sentryHz = SENTRY_HZ,
		tPoll = 0, tSentry = 0,
		signalFired = false,
	}
	self._watch[prop] = w

	local ok, sig = pcall(function() return inst:GetPropertyChangedSignal(prop) end)
	if ok and sig then
		table.insert(self._conns, sig:Connect(function()
			w.signalFired = true
			local cur = Core.safeGet(inst, prop)
			if not approxEqual(kind, cur, w.last) then
				w.last = cur; self:_updateRow(prop)
			end
		end))
	end
	
	table.insert(self._conns, inst.Changed:Connect(function(changedProp)
		if changedProp == prop then
			w.signalFired = true
			local cur = Core.safeGet(inst, prop)
			if not approxEqual(kind, cur, w.last) then
				w.last = cur; self:_updateRow(prop)
			end
		end
	end))
end

function Props:_armHeartbeat()
	if self._hbConn then return end
	self._hbConn = RunService.Heartbeat:Connect(function(dt)
		if not self.Selected then return end
		for prop, w in pairs(self._watch) do
			if w.fast then
				w.tPoll += dt
				if w.tPoll >= (1 / w.pollHz) then
					w.tPoll = 0
					local cur = Core.safeGet(self.Selected, prop)
					if not approxEqual(w.kind, cur, w.last) then
						w.last = cur; self:_updateRow(prop)
					end
				end
			else
				w.tSentry += dt
				if w.tSentry >= (1 / w.sentryHz) then
					w.tSentry = 0
					local cur = Core.safeGet(self.Selected, prop)
					if not approxEqual(w.kind, cur, w.last) then
						if not w.signalFired then
							w.fast = true
							w.pollHz = MED_HZ
							w.tPoll = 0
						end
						w.last = cur; self:_updateRow(prop)
					end
					w.signalFired = false
				end
			end
		end
	end)
end

local function mkRow_Input(container, labelText, initial, onEnterFn, fieldTemplate)
	local row = clone(fieldTemplate)
	row.Parent = container
	row.Label.Text = labelText
	row.Editor.Text = initial or ""
	onEnter(row.Editor, function(txt)
		local ok = pcall(onEnterFn, txt, row.Editor, row)
		if not ok then
			local original = row.Editor.BackgroundColor3
			row.Editor.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
			task.delay(0.15, function()
				if row and row.Parent then row.Editor.BackgroundColor3 = original end
			end)
		end
	end)
	return row
end

local function mkRow_Toggle(container, labelText, initialValue, onToggle, toggleTemplate)
	local row = clone(toggleTemplate)
	row.Parent = container
	row.Label.Text = labelText
	row.Check.Text = initialValue and "☑" or "☐"

	row.Check.MouseButton1Click:Connect(function()
		local curr = (row.Check.Text == "☑")
		local newVal = not curr
		onToggle(newVal, row.Check, row)
	end)

	return row
end

function Props:Render(inst: Instance?, filter: string?)
	self:_disconnectAll()
	self.Selected = inst
	self.Container:ClearAllChildren()
	if not inst then setTitle(self.Title, nil) return end
	setTitle(self.Title, inst)

	local layout = self.Container:FindFirstChildOfClass("UIListLayout") or Instance.new("UIListLayout", self.Container)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 4)

	local specs = Core.getPropsFor(inst)
	table.sort(specs, function(a, b) return a.prop:lower() < b.prop:lower() end)

	for _, spec in pairs(specs) do
		if filter and not spec.prop:lower():find(filter) then
			local v = Core.safeGet(inst, spec.prop)
			if typeof(v) ~= "string" or not tostring(v):lower():find(filter) then continue end
		end

		local cur = Core.safeGet(inst, spec.prop)

		if spec.readOnly then
			local initial = displayString(spec.kind, spec.enum, cur)
			local row = clone(self.FieldTemplate)
			row.Parent = self.Container
			row.Label.Text = spec.prop
			row.Editor.Text = initial or ""
			row.Editor.TextEditable = false
			row.Editor.ClearTextOnFocus = false
			row.Editor.Active = false

			self._rowByProp[spec.prop] = { kind = spec.kind, enumType = spec.enum, row = row, editor = row.Editor }
			self._specByProp[spec.prop] = spec
			self:_registerWatch(inst, spec)
		else
			if spec.kind == "boolean" then
				local row = mkRow_Toggle(self.Container, spec.prop, cur, function(newBool, check)
					if not Core.safeSet(inst, spec.prop, newBool) then return end
					check.Text = newBool and "☑" or "☐"
					self.OnEdited:Fire(inst, spec.prop, newBool); flash(check)
				end, self.ToggleTemplate)
				self._rowByProp[spec.prop] = { kind = "boolean", row = row, check = row.Check }
				self._specByProp[spec.prop] = spec
				self:_registerWatch(inst, spec)
			else
				local initial = displayString(spec.kind, spec.enum, cur)
				local row = mkRow_Input(self.Container, spec.prop, initial, function(text, editor)
					local value = coerce(spec.kind, spec.enum, text)
					if value == nil and spec.kind ~= "string" then error("invalid value") end
					local ok = Core.safeSet(inst, spec.prop, value)
					if not ok then error("failed to set") end
					local now = Core.safeGet(inst, spec.prop)
					local disp = displayString(spec.kind, spec.enum, now)
					if not isFocused(editor) then editor.Text = disp end
					self.OnEdited:Fire(inst, spec.prop, now); flash(editor)
				end, self.FieldTemplate)
				self._rowByProp[spec.prop] = { kind = spec.kind, enumType = spec.enum, row = row, editor = row.Editor }
				self._specByProp[spec.prop] = spec
				self:_registerWatch(inst, spec)
			end
		end
	end

	self:_armHeartbeat()

	do
		local header = self.TagHeaderTemplate and clone(self.TagHeaderTemplate) or Instance.new("TextLabel")
		header.Parent = self.Container
		if not self.TagHeaderTemplate then
			header.Text = "Tags"; header.Size = UDim2.new(1, 0, 0, 22)
			header.BackgroundTransparency = 1; header.TextXAlignment = Enum.TextXAlignment.Left
			header.Font = Enum.Font.GothamBold
		end

		local panel = clone(self.TagTemplate)
		panel.Parent = self.Container
		local function addTagFromText()
			local tag = panel.NewTag.Text
			if tag ~= "" then
				Core.addTag(inst, tag)
				panel.NewTag.Text = ""
				self:Render(inst, filter)
			end
		end
		panel.Add.MouseButton1Click:Connect(addTagFromText)
		onEnter(panel.NewTag, function() addTagFromText() end)

		local tags = Core.getTags(inst)
		table.sort(tags, function(a, b) return a:lower() < b:lower() end)
		for _, t in pairs(tags) do
			local chip = Instance.new("TextButton")
			chip.Size = UDim2.new(0, 120, 0, 22)
			chip.Text = t .. "  ✕"
			chip.BackgroundTransparency = 0.2
			chip.Parent = self.Container
			chip.MouseButton1Click:Connect(function()
				Core.removeTag(inst, t)
				self:Render(inst, filter)
			end)
		end
	end

	do
		local header = self.AttributeHeaderTemplate and clone(self.AttributeHeaderTemplate) or Instance.new("TextLabel")
		header.Parent = self.Container
		if not self.AttributeHeaderTemplate then
			header.Text = "Attributes"; header.Size = UDim2.new(1, 0, 0, 22)
			header.BackgroundTransparency = 1; header.TextXAlignment = Enum.TextXAlignment.Left
			header.Font = Enum.Font.GothamBold
		end

		local panel = clone(self.AttributeTemplate)
		panel.Parent = self.Container

		local function setAttrFromPanel()
			local key = panel:FindFirstChild("Key") and panel.Key.Text or ""
			local t   = panel:FindFirstChild("Type") and panel.Type.Text or ""
			local valTxt = panel:FindFirstChild("Value") and panel.Value.Text or ""
			if key == "" then return end

			local value
			if t == "number" then value = tonumber(valTxt)
			elseif t == "boolean" then value = parseBool(valTxt)
			elseif t == "Vector3" then value = parseVec3(valTxt)
			elseif t == "Vector2" then value = parseVector2(valTxt)
			elseif t == "UDim" then value = parseUDim(valTxt)
			elseif t == "UDim2" then value = parseUDim2(valTxt)
			elseif t == "Color3" then value = parseColor3(valTxt)
			elseif t == "BrickColor" then value = parseBrickColor(valTxt)
			else value = valTxt end

			if value == nil and (t ~= "" and t ~= "string") then
				if panel:FindFirstChild("Value") then flash(panel.Value) end
				return
			end

			inst:SetAttribute(key, value)
			self:Render(inst, filter)
		end

		if panel:FindFirstChild("Value") then onEnter(panel.Value, setAttrFromPanel) end
		local deleteBtn = panel:FindFirstChild("delete") or panel:FindFirstChild("Remove")
		if deleteBtn then
			deleteBtn.MouseButton1Click:Connect(function()
				local keyBox = panel:FindFirstChild("Key")
				if keyBox and keyBox.Text ~= "" then inst:SetAttribute(keyBox.Text, nil) self:Render(inst, filter) end
			end)
		end

		for _, a in pairs(Core.getAttributes(inst)) do
			local row = clone(self.FieldTemplate)
			row.Parent = self.Container
			row.Label.Text = a.key .. ("  (%s)"):format(a.type)
			row.Editor.Text = tostring(a.value)
			onEnter(row.Editor, function(txt)
				local t = a.type
				local newVal
				if t == "number" then newVal = tonumber(txt)
				elseif t == "boolean" then newVal = parseBool(txt)
				elseif t == "Vector3" then newVal = parseVec3(txt)
				elseif t == "Vector2" then newVal = parseVector2(txt)
				elseif t == "UDim" then newVal = parseUDim(txt)
				elseif t == "UDim2" then newVal = parseUDim2(txt)
				elseif t == "Color3" then newVal = parseColor3(txt)
				elseif t == "BrickColor" then newVal = parseBrickColor(txt)
				else newVal = txt end
				if newVal == nil and t ~= "string" then flash(row.Editor) return end
				inst:SetAttribute(a.key, newVal)
				self:Render(inst, filter)
			end)
		end
	end
	
	self.Container.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y)
end

return Props
