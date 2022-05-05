--[[
	RagdollSystem.lua

	ModuleScript which handles ragdolling players
]]--

-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")

-- // Modules
local Connections = require(script.Connections)
local Network = require(script.Network)
local Physics = require(script.Physics)
local Rig = require(script.Rig)

-- // Variables
local RagdollSystem = { }

RagdollSystem.CharacterComponents = { }
RagdollSystem.PlayerConnections = { }
RagdollSystem.PlayerCache = { }

-- // Functions
function RagdollSystem.SetChildrenProperty(Object, Index, Value)
	for _, Object in ipairs(Object:GetChildren()) do
		if Object.ClassName == "ObjectValue" then Object = Object.Value end

		Object[Index] = Value
	end
end

function RagdollSystem.RigCharacter(Character)
	RagdollSystem.CharacterComponents[Character] = Rig:RigCharacterModel(Character)

	return RagdollSystem.CharacterComponents[Character]
end

function RagdollSystem.SetRagdollState(Character, State)
	local Player = PlayerService:GetPlayerFromCharacter(Character)
	local RigComponents = RagdollSystem.CharacterComponents[Character] or RagdollSystem.RigCharacter(Character)
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	Character.Head.CanCollide = State

	Physics:SetState(Character, State)
	
	RigComponents.RagdollRootConstraint.Enabled = State

	RagdollSystem.SetChildrenProperty(RigComponents.RigConstraints, "Enabled", State)
	RagdollSystem.SetChildrenProperty(RigComponents.RigCollision, "Enabled", State)
	RagdollSystem.SetChildrenProperty(RigComponents.RigMotors, "Enabled", not State)

	if Player then
		Network:SetOwner(Character, State == false and Player)
	end

	Humanoid:ChangeState((State and Enum.HumanoidStateType.Physics) or Enum.HumanoidStateType.GettingUp)
end

function RagdollSystem.Initialize()
	Connections:OnPlayerAdded(function(Player)
		RagdollSystem.PlayerCache[Player] = { }
		table.insert(RagdollSystem.PlayerCache[Player], Player.CharacterAppearanceLoaded:Connect(function(Character)
			if RagdollSystem.PlayerConnections[Player] then
				RagdollSystem.PlayerConnections[Player]:Disconnect()
			end

			RagdollSystem.CharacterComponents[Character], RagdollSystem.PlayerConnections[Player] = Rig:RigCharacterModel(Player.Character)
		end))

		table.insert(RagdollSystem.PlayerCache[Player], Player.CharacterRemoving:Connect(function(Character)
			for _, Object in ipairs(Character:GetDescendants()) do
				Physics.CollisionGroups[Object] = nil
			end
		end))

		if Player.Character then
			RagdollSystem.CharacterComponents[Player.Character], RagdollSystem.PlayerConnections[Player] = Rig:RigCharacterModel(Player.Character)
		end
	end)

	Connections:OnPlayerRemoving(function(Player)
		repeat task.wait() until RagdollSystem.PlayerCache[Player]

		for _, Connection in ipairs(RagdollSystem.PlayerCache[Player]) do
			Connection:Disconnect()
		end

		RagdollSystem.PlayerCache[Player] = nil
		if RagdollSystem.PlayerConnections[Player] then
			RagdollSystem.PlayerConnections[Player]:Disconnect()
			RagdollSystem.PlayerConnections[Player] = nil
		end
	end)
	

	_G.Ragdoll = RagdollSystem
	return RagdollSystem
end

-- // Module
return RagdollSystem.Initialize()