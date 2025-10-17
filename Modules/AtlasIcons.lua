--[[
	@class AtlasIcons

	> [Centralized icon library for representing Roblox instance types (e.g., Model, Part, Script)].
		- Icons are dynamically assigned and used throughout both the Explorer and Object Browser UIs.
		- count: 316 instance type icons
		
	> Author: @Bykhovsky
	> Version: 1.0.0
	> Last updated: 10/17/2025
]]--

local AtlasIcons = {
	-----------------------------------[[ || Services || ]]-----------------------------------
	["Workspace"] = {
		["ImageRectOffset"] = Vector2.new(100, 480),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Camera"] = {
		["ImageRectOffset"] = Vector2.new(160, 160),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Terrain"] = {
		["ImageRectOffset"] = Vector2.new(180, 440),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Players"] = {
		["ImageRectOffset"] = Vector2.new(380, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Player"] = {
		["ImageRectOffset"] = Vector2.new(320, 360),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Backpack"] = {
		["ImageRectOffset"] = Vector2.new(420, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["PlayerGui"] = {
		["ImageRectOffset"] = Vector2.new(400, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["PlayerScripts"] = {
		["ImageRectOffset"] = Vector2.new(440, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Lighting"] = {
		["ImageRectOffset"] = Vector2.new(260, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["MaterialService"] = {
		["ImageRectOffset"] = Vector2.new(340, 80),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["NetworkClient"] = {
		["ImageRectOffset"] = Vector2.new(240, 340),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ClientReplicator"] = {
		["ImageRectOffset"] = Vector2.new(40, 180),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ReplicatedFirst"] = {
		["ImageRectOffset"] = Vector2.new(400, 260),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ReplicatedStorage"] = {
		["ImageRectOffset"] = Vector2.new(400, 260),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ServerScriptService"] = {
		["ImageRectOffset"] = Vector2.new(420, 160),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ServerStorage"] = {
		["ImageRectOffset"] = Vector2.new(420, 180),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["StarterGui"] = {
		["ImageRectOffset"] = Vector2.new(400, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["StarterPack"] = {
		["ImageRectOffset"] = Vector2.new(420, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["StarterGear"] = {
		["ImageRectOffset"] = Vector2.new(420, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["StarterPlayer"] = {
		["ImageRectOffset"] = Vector2.new(440, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["StarterPlayerScripts"] = {
		["ImageRectOffset"] = Vector2.new(440, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["StarterCharacterScripts"] = {
		["ImageRectOffset"] = Vector2.new(360, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Teams"] = {
		["ImageRectOffset"] = Vector2.new(60, 440),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Team"] = {
		["ImageRectOffset"] = Vector2.new(20, 440),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["SoundService"] = {
		["ImageRectOffset"] = Vector2.new(120, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["TextChatService"] = {
		["ImageRectOffset"] = Vector2.new(420, 440),
		["ImageRectSize"] = Vector2.new(20, 20)
	},

	-----------------------------------[[ || Remotes & Events || ]]-----------------------------------
	["RemoteEvent"] = {
		["ImageRectOffset"] = Vector2.new(400, 160),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["UnreliableRemoteEvent"] = {
		["ImageRectOffset"] = Vector2.new(400, 160),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["RemoteFunction"] = {
		["ImageRectOffset"] = Vector2.new(400, 180),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BindableEvent"] = {
		["ImageRectOffset"] = Vector2.new(140, 100),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BindableFunction"] = {
		["ImageRectOffset"] = Vector2.new(140, 120),
		["ImageRectSize"] = Vector2.new(20, 20)
	},

	-----------------------------------[[ || Constraints || ]]-----------------------------------
	["Motor6D"] = {
		["ImageRectOffset"] = Vector2.new(120, 340),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["HingeConstraint"] = {
		["ImageRectOffset"] = Vector2.new(300, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["SpringConstraint"] = {
		["ImageRectOffset"] = Vector2.new(280, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["PrismaticConstraint"] = {
		["ImageRectOffset"] = Vector2.new(80, 380),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BallSocketConstraint"] = {
		["ImageRectOffset"] = Vector2.new(60, 120),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["CylindricalConstraint"] = {
		["ImageRectOffset"] = Vector2.new(220, 120),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["RopeConstraint"] = {
		["ImageRectOffset"] = Vector2.new(0, 400),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["PlaneConstraint"] = {
		["ImageRectOffset"] = Vector2.new(260, 360),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Weld"] = {
		["ImageRectOffset"] = Vector2.new(40, 480),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["WeldConstraint"] = {
		["ImageRectOffset"] = Vector2.new(60, 480),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Handles"] = {
		["ImageRectOffset"] = Vector2.new(160, 280),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ArcHandles"] = {
		["ImageRectOffset"] = Vector2.new(0, 100),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["SelectionBox"] = {
		["ImageRectOffset"] = Vector2.new(420, 40),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["SelectionSphere"] = {
		["ImageRectOffset"] = Vector2.new(420, 40),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BoxHandleAdornment"] = {
		["ImageRectOffset"] = Vector2.new(160, 120),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["SphereHandleAdornment"] = {
		["ImageRectOffset"] = Vector2.new(240, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ConeHandleAdornment"] = {
		["ImageRectOffset"] = Vector2.new(200, 60),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["CylinderHandleAdornment"] = {
		["ImageRectOffset"] = Vector2.new(220, 80),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["WireframeHandleAdornment"] = {
		["ImageRectOffset"] = Vector2.new(80, 480),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ImageHandleAdornment"] = {
		["ImageRectOffset"] = Vector2.new(0, 300),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["LineHandleAdornment"] = {
		["ImageRectOffset"] = Vector2.new(20, 320),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Beam"] = {
		["ImageRectOffset"] = Vector2.new(140, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Trail"] = {
		["ImageRectOffset"] = Vector2.new(460, 360),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Smoke"] = {
		["ImageRectOffset"] = Vector2.new(420, 380),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Attachment"] = {
		["ImageRectOffset"] = Vector2.new(120, 60),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Accessory"] = {
		["ImageRectOffset"] = Vector2.new(40, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Shirt"] = {
		["ImageRectOffset"] = Vector2.new(420, 240),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Pants"] = {
		["ImageRectOffset"] = Vector2.new(360, 240),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ShirtGraphic"] = {
		["ImageRectOffset"] = Vector2.new(420, 260),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	-----------------------------------[[ || Movers || ]]-----------------------------------
	["AlignOrientation"] = {
		["ImageRectOffset"] = Vector2.new(0, 60),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AlignPosition"] = {
		["ImageRectOffset"] = Vector2.new(20, 60),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AngularVelocity"] = {
		["ImageRectOffset"] = Vector2.new(80, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BodyForce"] = {
		["ImageRectOffset"] = Vector2.new(160, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BodyVelocity"] = {
		["ImageRectOffset"] = Vector2.new(160, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BodyGyro"] = {
		["ImageRectOffset"] = Vector2.new(160, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BodyThrust"] = {
		["ImageRectOffset"] = Vector2.new(160, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BodyPosition"] = {
		["ImageRectOffset"] = Vector2.new(160, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BodyAngularVelocity"] = {
		["ImageRectOffset"] = Vector2.new(160, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BodyMover"] = {
		["ImageRectOffset"] = Vector2.new(160, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["LineForce"] = {
		["ImageRectOffset"] = Vector2.new(0, 320),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Explosion"] = {
		["ImageRectOffset"] = Vector2.new(260, 80),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	-----------------------------------[[ || Values || ]]-----------------------------------
	["BoolValue"] = {
		["ImageRectOffset"] = Vector2.new(320, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["StringValue"] = {
		["ImageRectOffset"] = Vector2.new(320, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["NumberValue"] = {
		["ImageRectOffset"] = Vector2.new(320, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Vector3Value"] = {
		["ImageRectOffset"] = Vector2.new(320, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ObjectValue"] = {
		["ImageRectOffset"] = Vector2.new(320, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["RayValue"] = {
		["ImageRectOffset"] = Vector2.new(320, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["DoubleConstrainedValue"] = {
		["ImageRectOffset"] = Vector2.new(320, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["IntValue"] = {
		["ImageRectOffset"] = Vector2.new(320, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["CFrameValue"] = {
		["ImageRectOffset"] = Vector2.new(320, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["IntConstrainedValue"] = {
		["ImageRectOffset"] = Vector2.new(320, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BinaryStringValue"] = {
		["ImageRectOffset"] = Vector2.new(320, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Color3Value"] = {
		["ImageRectOffset"] = Vector2.new(320, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BrickColorValue"] = {
		["ImageRectOffset"] = Vector2.new(320, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["VehicleSeat"] = {
		["ImageRectOffset"] = Vector2.new(420, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	-----------------------------------[[ || UIObjects || ]]-----------------------------------
	["ScreenGui"] = {
		["ImageRectOffset"] = Vector2.new(160, 400),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Frame"] = {
		["ImageRectOffset"] = Vector2.new(220, 260),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ScrollingFrame"] = {
		["ImageRectOffset"] = Vector2.new(220, 260),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ImageButton"] = {
		["ImageRectOffset"] = Vector2.new(300, 280),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ImageLabel"] = {
		["ImageRectOffset"] = Vector2.new(20, 300),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["VideoFrame"] = {
		["ImageRectOffset"] = Vector2.new(480, 280),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["TextLabel"] = {
		["ImageRectOffset"] = Vector2.new(460, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["TextButton"] = {
		["ImageRectOffset"] = Vector2.new(260, 440),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["TextBox"] = {
		["ImageRectOffset"] = Vector2.new(260, 440),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BillboardGui"] = {
		["ImageRectOffset"] = Vector2.new(120, 60),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["SurfaceGui"] = {
		["ImageRectOffset"] = Vector2.new(140, 60),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["CanvasGroup"] = {
		["ImageRectOffset"] = Vector2.new(80, 460),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["UIAspectRatioConstraint"] = {
		["ImageRectOffset"] = Vector2.new(80, 460),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["UIConstraint"] = {
		["ImageRectOffset"] = Vector2.new(80, 460),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["UICorner"] = {
		["ImageRectOffset"] = Vector2.new(80, 460),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["UIGradient"] = {
		["ImageRectOffset"] = Vector2.new(80, 460),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["UIGridLayout"] = {
		["ImageRectOffset"] = Vector2.new(80, 460),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["UIFlexItem"] = {
		["ImageRectOffset"] = Vector2.new(80, 460),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["UIListLayout"] = {
		["ImageRectOffset"] = Vector2.new(80, 460),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["UIPadding"] = {
		["ImageRectOffset"] = Vector2.new(80, 460),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["UIPageLayout"] = {
		["ImageRectOffset"] = Vector2.new(80, 460),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["UIScale"] = {
		["ImageRectOffset"] = Vector2.new(80, 460),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["UISizeConstraint"] = {
		["ImageRectOffset"] = Vector2.new(80, 460),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["UIStroke"] = {
		["ImageRectOffset"] = Vector2.new(80, 460),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["UITableLayout"] = {
		["ImageRectOffset"] = Vector2.new(80, 460),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["UITextSizeConstraint"] = {
		["ImageRectOffset"] = Vector2.new(80, 460),
		["ImageRectSize"] = Vector2.new(20, 20)
	},

	-----------------------------------[[ || Lighting Objects || ]]-----------------------------------
	["Sky"] = {
		["ImageRectOffset"] = Vector2.new(100, 180),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Clouds"] = {
		["ImageRectOffset"] = Vector2.new(100, 180),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Atmosphere"] = {
		["ImageRectOffset"] = Vector2.new(20, 140),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BloomEffect"] = {
		["ImageRectOffset"] = Vector2.new(20, 140),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BlurEffect"] = {
		["ImageRectOffset"] = Vector2.new(20, 140),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["DepthOfFieldEffect"] = {
		["ImageRectOffset"] = Vector2.new(20, 140),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["SunRaysEffect"] = {
		["ImageRectOffset"] = Vector2.new(20, 140),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ColorCorrectionEffect"] = {
		["ImageRectOffset"] = Vector2.new(20, 140),
		["ImageRectSize"] = Vector2.new(20, 20)
	},

	-----------------------------------[[ || Sound Objects || ]]-----------------------------------
	["SoundGroup"] = {
		["ImageRectOffset"] = Vector2.new(100, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Sound"] = {
		["ImageRectOffset"] = Vector2.new(60, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ChorusSoundEffect"] = {
		["ImageRectOffset"] = Vector2.new(460, 400),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["CompressorSoundEffect"] = {
		["ImageRectOffset"] = Vector2.new(460, 400),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["DistortionSoundEffect"] = {
		["ImageRectOffset"] = Vector2.new(460, 400),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["EchoSoundEffect"] = {
		["ImageRectOffset"] = Vector2.new(460, 400),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["EqualizerSoundEffect"] = {
		["ImageRectOffset"] = Vector2.new(460, 400),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["FlangeSoundEffect"] = {
		["ImageRectOffset"] = Vector2.new(460, 400),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["PitchShiftSoundEffect"] = {
		["ImageRectOffset"] = Vector2.new(460, 400),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ReverbSoundEffect"] = {
		["ImageRectOffset"] = Vector2.new(460, 400),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["TremoloSoundEffect"] = {
		["ImageRectOffset"] = Vector2.new(460, 400),
		["ImageRectSize"] = Vector2.new(20, 20)
	},

	-----------------------------------[[ || Animation Objects || ]]-----------------------------------
	["Animation"] = {
		["ImageRectOffset"] = Vector2.new(100, 40),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AnimationController"] = {
		["ImageRectOffset"] = Vector2.new(100, 40),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["KeyframeSequence"] = {
		["ImageRectOffset"] = Vector2.new(100, 40),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Animator"] = {
		["ImageRectOffset"] = Vector2.new(100, 40),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["CharacterMesh"] = {
		["ImageRectOffset"] = Vector2.new(100, 40),
		["ImageRectSize"] = Vector2.new(20, 20)
	},

	-----------------------------------[[ || Other || ]]-----------------------------------]
	["AccessoryDescription"] = {
		["ImageRectOffset"] = Vector2.new(300, 220),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Accoutrement"] = {
		["ImageRectOffset"] = Vector2.new(40, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Actor"] = {
		["ImageRectOffset"] = Vector2.new(0, 40),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AdGui"] = {
		["ImageRectOffset"] = Vector2.new(20, 40),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AdPortal"] = {
		["ImageRectOffset"] = Vector2.new(40, 40),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AdvancedDragger"] = {
		["ImageRectOffset"] = Vector2.new(60, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AirController"] = {
		["ImageRectOffset"] = Vector2.new(60, 40),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AnimationRigData"] = {
		["ImageRectOffset"] = Vector2.new(80, 80),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AnimationConstraint"] = {
		["ImageRectOffset"] = Vector2.new(80, 80),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioAnalyzer"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioChannelMixer"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioChannelSplitter"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioChorus"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioCompressor"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioDeviceInput"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioDeviceOutput"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioDistortion"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioEcho"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioEmitter"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioEqualizer"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioFader"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioFilter"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioFlanger"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioGate"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioLimiter"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioListener"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioPitchShifter"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioPlayer"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioRecorder"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioReverb"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioSearchParams"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioSpeechToText"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioTextToSpeech"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["AudioTremolo"] = {
		["ImageRectOffset"] = Vector2.new(120, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BodyPartDescription"] = {
		["ImageRectOffset"] = Vector2.new(300, 220),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ClimbController"] = {
		["ImageRectOffset"] = Vector2.new(60, 180),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ControllerManager"] = {
		["ImageRectOffset"] = Vector2.new(20, 200),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["CurveAnimation"] = {
		["ImageRectOffset"] = Vector2.new(200, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["CustomEvent"] = {
		["ImageRectOffset"] = Vector2.new(200, 20),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["CustomEventReceiver"] = {
		["ImageRectOffset"] = Vector2.new(200, 40),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["CylinderMesh"] = {
		["ImageRectOffset"] = Vector2.new(200, 100),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["DataStoreIncrementOptions"] = {
		["ImageRectOffset"] = Vector2.new(20, 220),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["DataStoreOptions"] = {
		["ImageRectOffset"] = Vector2.new(20, 220),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["DataStoreSetOptions"] = {
		["ImageRectOffset"] = Vector2.new(0, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Dialog"] = {
		["ImageRectOffset"] = Vector2.new(60, 240),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["DialogChoice"] = {
		["ImageRectOffset"] = Vector2.new(80, 240),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Dragger"] = {
		["ImageRectOffset"] = Vector2.new(180, 240),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["EulerRotationCurve"] = {
		["ImageRectOffset"] = Vector2.new(200, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["FaceControls"] = {
		["ImageRectOffset"] = Vector2.new(220, 120),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["FileMesh"] = {
		["ImageRectOffset"] = Vector2.new(140, 40),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Flag"] = {
		["ImageRectOffset"] = Vector2.new(20, 260),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["FlagStand"] = {
		["ImageRectOffset"] = Vector2.new(40, 260),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["FloatCurve"] = {
		["ImageRectOffset"] = Vector2.new(100, 260),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["FloorWire"] = {
		["ImageRectOffset"] = Vector2.new(120, 260),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["FunctionalTest"] = {
		["ImageRectOffset"] = Vector2.new(280, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["GetTextBoundsParams"] = {
		["ImageRectOffset"] = Vector2.new(260, 100),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Glue"] = {
		["ImageRectOffset"] = Vector2.new(260, 160),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["GroundController"] = {
		["ImageRectOffset"] = Vector2.new(260, 200),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["GuiMain"] = {
		["ImageRectOffset"] = Vector2.new(80, 280),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Highlight"] = {
		["ImageRectOffset"] = Vector2.new(260, 280),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Hint"] = {
		["ImageRectOffset"] = Vector2.new(180, 120),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Hole"] = {
		["ImageRectOffset"] = Vector2.new(300, 40),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["HopperBin"] = {
		["ImageRectOffset"] = Vector2.new(300, 80),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["IKControl"] = {
		["ImageRectOffset"] = Vector2.new(300, 240),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["LinearVelocity"] = {
		["ImageRectOffset"] = Vector2.new(300, 300),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ManualWeld"] = {
		["ImageRectOffset"] = Vector2.new(40, 480),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Motor"] = {
		["ImageRectOffset"] = Vector2.new(100, 340),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Message"] = {
		["ImageRectOffset"] = Vector2.new(180, 120),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ManualGlue"] = {
		["ImageRectOffset"] = Vector2.new(300, 320),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["LocalizationTable"] = {
		["ImageRectOffset"] = Vector2.new(80, 320),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["NoCollisionConstraint"] = {
		["ImageRectOffset"] = Vector2.new(360, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["NegateOperation"] = {
		["ImageRectOffset"] = Vector2.new(220, 340),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["MaterialVariant"] = {
		["ImageRectOffset"] = Vector2.new(340, 100),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ParticleEmitter"] = {
		["ImageRectOffset"] = Vector2.new(360, 320),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["PartOperation"] = {
		["ImageRectOffset"] = Vector2.new(360, 340),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Plane"] = {
		["ImageRectOffset"] = Vector2.new(260, 360),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["PathfindingModifier"] = {
		["ImageRectOffset"] = Vector2.new(60, 360),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["PathfindingLink"] = {
		["ImageRectOffset"] = Vector2.new(60, 360),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["PointLight"] = {
		["ImageRectOffset"] = Vector2.new(260, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["SpotLight"] = {
		["ImageRectOffset"] = Vector2.new(260, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["SurfaceLight"] = {
		["ImageRectOffset"] = Vector2.new(260, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ProximityPrompt"] = {
		["ImageRectOffset"] = Vector2.new(120, 380),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["RigidConstraint"] = {
		["ImageRectOffset"] = Vector2.new(400, 300),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["RocketPropulsion"] = {
		["ImageRectOffset"] = Vector2.new(160, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["RodConstraint"] = {
		["ImageRectOffset"] = Vector2.new(400, 380),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Seat"] = {
		["ImageRectOffset"] = Vector2.new(420, 0),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["SpecialMesh"] = {
		["ImageRectOffset"] = Vector2.new(200, 100),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["SwimController"] = {
		["ImageRectOffset"] = Vector2.new(0, 440),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["TextChannel"] = {
		["ImageRectOffset"] = Vector2.new(320, 440),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["TextChatCommand"] = {
		["ImageRectOffset"] = Vector2.new(340, 440),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["TextChatMessageProperties"] = {
		["ImageRectOffset"] = Vector2.new(400, 440),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Torque"] = {
		["ImageRectOffset"] = Vector2.new(460, 220),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["TorsionSpringConstraint"] = {
		["ImageRectOffset"] = Vector2.new(280, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["UniversalConstraint"] = {
		["ImageRectOffset"] = Vector2.new(440, 460),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Vector3Curve"] = {
		["ImageRectOffset"] = Vector2.new(480, 120),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["VectorForce"] = {
		["ImageRectOffset"] = Vector2.new(480, 160),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["VehicleController"] = {
		["ImageRectOffset"] = Vector2.new(480, 180),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["VelocityMotor"] = {
		["ImageRectOffset"] = Vector2.new(480, 220),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ViewportFrame"] = {
		["ImageRectOffset"] = Vector2.new(300, 280),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	
	
	["Texture"] = {
		["ImageRectOffset"] = Vector2.new(460, 60),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BodyColor"] = {
		["ImageRectOffset"] = Vector2.new(80, 140),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BodyColors"] = {
		["ImageRectOffset"] = Vector2.new(80, 140),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Bone"] = {
		["ImageRectOffset"] = Vector2.new(160, 80),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Configuration"] = {
		["ImageRectOffset"] = Vector2.new(200, 80),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Decal"] = {
		["ImageRectOffset"] = Vector2.new(0, 240),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Fire"] = {
		["ImageRectOffset"] = Vector2.new(0, 260),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Humanoid"] = {
		["ImageRectOffset"] = Vector2.new(300, 180),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["HumanoidDescription"] = {
		["ImageRectOffset"] = Vector2.new(300, 220),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Tool"] = {
		["ImageRectOffset"] = Vector2.new(460, 160),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Model"] = {
		["ImageRectOffset"] = Vector2.new(60, 340),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Script"] = {
		["ImageRectOffset"] = Vector2.new(200, 400),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ModuleScript"] = {
		["ImageRectOffset"] = Vector2.new(80, 340),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["LocalScript"] = {
		["ImageRectOffset"] = Vector2.new(100, 320),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Folder"] = {
		["ImageRectOffset"] = Vector2.new(160, 263),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["TouchTransmitter"] = {
		["ImageRectOffset"] = Vector2.new(180, 260),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ForceField"] = {
		["ImageRectOffset"] = Vector2.new(180, 260),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["BlockMesh"] = {
		["ImageRectOffset"] = Vector2.new(220, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Part"] = {
		["ImageRectOffset"] = Vector2.new(20, 480),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["TrussPart"] = {
		["ImageRectOffset"] = Vector2.new(20, 480),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["WedgePart"] = {
		["ImageRectOffset"] = Vector2.new(20, 480),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["CornerWedgePart"] = {
		["ImageRectOffset"] = Vector2.new(20, 480),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["SurfaceAppearance"] = {
		["ImageRectOffset"] = Vector2.new(440, 340),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Hat"] = {
		["ImageRectOffset"] = Vector2.new(220, 280),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["UnionOperation"] = {
		["ImageRectOffset"] = Vector2.new(360, 280),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["MeshPart"] = {
		["ImageRectOffset"] = Vector2.new(360, 280),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["WorldModel"] = {
		["ImageRectOffset"] = Vector2.new(120, 480),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["ClickDetector"] = {
		["ImageRectOffset"] = Vector2.new(20, 180),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["Sparkles"] = {
		["ImageRectOffset"] = Vector2.new(140, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["SpawnLocation"] = {
		["ImageRectOffset"] = Vector2.new(180, 420),
		["ImageRectSize"] = Vector2.new(20, 20)
	},

	["WrapLayer"] = {
		["ImageRectOffset"] = Vector2.new(160, 480),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["WrapTarget"] = {
		["ImageRectOffset"] = Vector2.new(200, 480),
		["ImageRectSize"] = Vector2.new(20, 20)
	},
	["WrapDeformer"] = {
		["ImageRectOffset"] = Vector2.new(180, 480),
		["ImageRectSize"] = Vector2.new(20, 20)
	},

	-----------------------------------[[ || Default || ]]-----------------------------------
	["Instance"] = {
		["ImageRectOffset"] = Vector2.new(260, 300),
		["ImageRectSize"] = Vector2.new(20, 20)
	}
}

return AtlasIcons
