local class = {}
class.__index = class

local ragdoll = shared.Libraries.Ragdoll

function class.new(player: Player)
	local self = setmetatable({}, class)
	self.Player = player
	self.Instance = player.Character or player.CharacterAdded:Wait()

	return self
end

-- Initializer
function class:Init()
	self.Instance.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

	HealthChanged(self)
end

-- Listeners
function HealthChanged(self)
	self.Instance.Humanoid.HealthChanged:Connect(function(health: number)
		if health > 0 then return end
		self:Down()
	end)
end

function Prompt(self)
	self.PromptStartConn = self.Prompt.PromptButtonHoldBegan:Connect(function(player)
		if self.PrevRescuer ~= player then
			self.Prompt.Enabled = false
			self.Prompt.HoldDuration = 5 * 0.5

			self.PrevRescuer = player
		end
		task.wait(0.1)
		self.Prompt.Enabled = true
	end)
	self.PromptEndConn = self.Prompt.Triggered:Connect(function()
		self:Revive()
	end)
end


function SwitchUI(self)
	print("Switch2")
end


-- Ragdoll
function Ragdoll(self)
	ragdoll.SetRagdoll(self.Instance, true)
end

function UnRagdoll(self)
	ragdoll.SetRagdoll(self.Instance, false)
end


function ToggleRegen(self, value: boolean)
	if value == true then
		local original = self.Instance:FindFirstChild("Health")
		local regen = original:Clone()
		regen.Parent = self.Instance
		regen.Enabled = true
		original:Destroy()
	else
		self.Instance:FindFirstChild("Health").Enabled = value
	end
end

-- API
function class:Down()
	if self.Downed == true then return end
	self.Downed = true

	ToggleRegen(self, false)

	self.Prompt = Instance.new("ProximityPrompt", self.Instance.HumanoidRootPart)
	self.Prompt.HoldDuration = 5
	self.Prompt.ActionText = "Revive"

	Ragdoll(self)
	SwitchUI(self)
end

function class:Revive()
	if self.Downed == false then return end
	self.Downed = false 

	if self.PromptConn then self.PromptConn:Disconnect() end
	self.Prompt:Destroy()

	ToggleRegen(self, true)
	SwitchUI(self)
	UnRagdoll(self)
end

return class
