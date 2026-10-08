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
	else
		self.Downed = true

		Downed(self)
		self.Instance.HumanoidRootPart.ProximityPrompt:Destroy()
	end
end



return class
