local CollectionService = game:GetService("CollectionService")
local class = {}
class.Objects = {}
class.__index = class

local ragdoll = shared.Libraries.Ragdoll

function class.new(player: Player)
	local self = setmetatable({}, class)
	self.Player = player
	self.Instance = player.Character or player.CharacterAdded:Wait()
	self.Id = player.Name
	class.Objects[self.Id] = self

	return self
end

-- Initializer
function class:Init()
	self.Events = {
		Died = shared.Classes.Event.new()
	}

	self.Instance:SetAttribute("Id", self.Id)
	self.Instance:SetAttribute("Class", "Character")
	CollectionService:AddTag(self.Instance, "Object")
	CollectionService:AddTag(self.Instance, "Character")
	shared.Entities[self.Id] = self

	self.DmgBox = self.Instance.HumanoidRootPart:Clone()
	for _, child in self.DmgBox:GetChildren() do child:Destroy() end

	self.DmgBox.Name = "DmgBox"
	self.DmgBox.Size = Vector3.new(3, 7, 3)
	self.DmgBox.Parent = self.Instance

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = self.Instance.HumanoidRootPart
	weld.Part1 = self.DmgBox
	weld.Parent = self.DmgBox

	self.Instance.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	self.SwitchUIEvent = game.ReplicatedStorage.Remotes.Events.CharSwitchUI
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
	self.SwitchUIEvent:FireClient(self.Player)
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

	ToggleQuery(self, false)

	self.Events.Died:Fire()
	ToggleRegen(self, false)

	self.Prompt = Instance.new("ProximityPrompt", self.Instance.HumanoidRootPart)
	self.Prompt.HoldDuration = 5
	self.Prompt.ActionText = "Revive"

	Ragdoll(self)
	SwitchUI(self)
	Prompt(self)

	local prevX = self.PreviousCoords.x
	local prevZ = self.PreviousCoords.z
	shared.Entities[self.Id] = nil
    shared.GameClasses.RegionsHandler:Remove(prevX, prevZ, self, "Character")
end

function class:Revive()
	if self.Downed == false then return end
	self.Downed = false 

	ToggleQuery(self, true)

	if self.PromptStartConn then self.PromptStartConn:Disconnect() end
	if self.PromptEndconn then self.PromptEndconn:Disconnect() end
	self.Prompt:Destroy()

	ToggleRegen(self, true)
	SwitchUI(self)
	UnRagdoll(self)

	shared.Entities[self.Id] = self
end

function class:IncrementHealth(num: number)
	self.Instance.Humanoid:TakeDamage(-num)
end

function ToggleQuery(self, val: boolean)
	for _, child in self.Instance:GetChildren() do
		if not child:IsA("BasePart") then continue end
		child.CanQuery = val
	end
end

return class
