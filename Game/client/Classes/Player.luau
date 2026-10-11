local UserInputService = game:GetService("UserInputService")
local class = {}
class.Objects = {}
class.__index = class

function class.initialize()
	game.Players.PlayerAdded:Connect(function(player)
		class.new(player)	
	end)
	for _, plr in game.Players:GetChildren() do
		if class.Objects[plr.Name] then continue end
		class.new(plr)
	end
end

function class.new(plr: Player)
	local self = setmetatable({}, class)
	self.Instance = plr
	self.Character = shared.GameClasses.Character.new(self)
	self.Id = plr.Name
	self:Init()

	class.Objects[self.Id] = self
	return self
end

function class:Init()
	local remoteFunc = game.ReplicatedStorage.Remotes.Functions.UserInput
	while not remoteFunc do remoteFunc = game.ReplicatedStorage.Remotes.Functions.UserInput print(remoteFunc) end
	
	if UserInputService.TouchEnabled then
		shared.Classes.UI.new("RunBtn")

		return
	end

	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent == true then return end
		remoteFunc:InvokeServer(true, input.KeyCode)
	end)

	UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent == true then return end
		remoteFunc:InvokeServer(false, input.KeyCode)
	end)
end

return class
