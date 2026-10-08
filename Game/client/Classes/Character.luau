local Lighting = game:GetService("Lighting")
local StarterPlayer = game:GetService("StarterPlayer")
local UI = require(StarterPlayer.StarterPlayerScripts.Client.ModuleLoader.Modules.Classes.UI)
local class = {}
class.__index = class

function class.initialize()
	game:GetService("StarterGui"):SetCore("ResetButtonCallback", false)
	class.new(game.Players.LocalPlayer)
end

function class.new(plr)
	local self = setmetatable({}, class)
	self.Player = plr
	self.Instance = plr.Character or plr.CharacterAdded:Wait()
	self:Init()
	return self
end

function class:Init()
	self.SwitchUIEvent = game.ReplicatedStorage.Remotes.Events.CharSwitchUI
	self.SwitchUIEvent.OnClientEvent:Connect(function()
		self:SwitchUI(self)
	end)

	self.Instance.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
end

function class:SwitchUI()
	if self.Downed == true then
		self.Downed = false
		Revived(self)
	else
		self.Downed = true

		Downed(self)
		-- self.Instance.HumanoidRootPart.ProximityPrompt:Destroy()
	end
end


function Downed(self)
	-- Close UIs
	local UIs = shared.Classes.UI.Objects

	local structsFrame = UIs.StructsFrame
	local info
	local structsBtn = UIs.StructsBtn

	if structsFrame then info = structsFrame.ExistingInfo structsFrame:Close() end
	if info then info:Close() end
	if structsBtn then structsBtn:Close() end

	-- Open UIs
	local leave = shared.Classes.UI.new("LeaveBtn")
	local revive = shared.Classes.UI.new("SelfReviveBtn")

	-- Blur
	ToggleNonObjUIs(self, 1)
	ToggleBlur(true)
end

function Revived(self)
	-- Close UIs
	local UIs = shared.Classes.UI.Objects
	UIs.LeaveBtn:Close()
	UIs.SelfReviveBtn:Close()

	-- Remove blur
	ToggleNonObjUIs(self, 0)
	ToggleBlur(false)

	-- Open UIs
	shared.Classes.UI.new("StructsBtn")
end

function ToggleBlur(val: boolean)
	Lighting.DepthOfField.Enabled = val
end

function ToggleNonObjUIs(self, num: number)
	self.Cash = self.Player.PlayerGui.ConsiderSafeArea.Cash
	self.Cash.TextTransparency = num
	self.Cash.UIStroke.Transparency = num

	self.WaveState = self.Player.PlayerGui.IgnoreSafeArea.WaveState
	self.WaveState.TextTransparency = num
	self.WaveState.UIStroke.Transparency = num

	self.WaveType = self.Player.PlayerGui.IgnoreSafeArea.WaveType
	self.WaveType.TextTransparency = num
	self.WaveType.UIStroke.Transparency = num
end

return class
