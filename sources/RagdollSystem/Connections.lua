-- // Services
local PlayersService = game:GetService("Players")

-- // Variables
local Connections = { }

-- // Functions
function Connections:OnPlayerAdded(Callback)
	for _, Player in ipairs(PlayersService:GetPlayers()) do
		task.spawn(Callback, Player)
	end

	return PlayersService.PlayerAdded:Connect(Callback)
end

function Connections:OnPlayerRemoving(Callback)
	return PlayersService.PlayerRemoving:Connect(Callback)
end

return Connections