--[[
	PhysicsModule.lua

	
]]--

-- // Services
local PhysicsService = game:GetService("PhysicsService")

-- // Variables
local RagdollPhysics = { }

RagdollPhysics.CollisionGroups = { }

RagdollPhysics.RootCollisionGroupName = "RootPhysics"
RagdollPhysics.RagdollCollisionGroupName = "RagdollPhysics"
RagdollPhysics.DefaultCollisionGroupName = "Default"

-- // Functions
function RagdollPhysics:SetState(Character, State)
	if State then
		for _, Object in ipairs(Character:GetDescendants()) do
			if not Object:IsA("BasePart") then continue end

			local PhysicsGroup = (Object == Character.PrimaryPart and self.RootCollisionGroupName) or self.RagdollCollisionGroupName
			self.CollisionGroups[Object] = PhysicsService:GetCollisionGroupName(Object.CollisionGroupId)

			PhysicsService:SetPartCollisionGroup(Object, PhysicsGroup)
		end
	else
		for _, Object in ipairs(Character:GetDescendants()) do
			if not Object:IsA("BasePart") then continue end

			local PhysicsGroup = self.CollisionGroups[Object]
			self.CollisionGroups[Object] = nil

			PhysicsService:SetPartCollisionGroup(Object, PhysicsGroup or self.DefaultCollisionGroupName)
		end
	end
end

-- // Module
PhysicsService:CreateCollisionGroup(RagdollPhysics.RootCollisionGroupName)
PhysicsService:CreateCollisionGroup(RagdollPhysics.RagdollCollisionGroupName)

PhysicsService:CollisionGroupSetCollidable(RagdollPhysics.RootCollisionGroupName, RagdollPhysics.RootCollisionGroupName, true)
PhysicsService:CollisionGroupSetCollidable(RagdollPhysics.RagdollCollisionGroupName, RagdollPhysics.RagdollCollisionGroupName, true)

PhysicsService:CollisionGroupSetCollidable(RagdollPhysics.RootCollisionGroupName, RagdollPhysics.RagdollCollisionGroupName, false)
PhysicsService:CollisionGroupSetCollidable(RagdollPhysics.RagdollCollisionGroupName, RagdollPhysics.DefaultCollisionGroupName, true)

return RagdollPhysics