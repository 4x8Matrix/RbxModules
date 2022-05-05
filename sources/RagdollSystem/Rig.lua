--[[
	RagdollRig.lua
	
	
]]--

-- // Variables
local RagdollRig = { }
local RootObjects = { 
	[Enum.HumanoidRigType.R15] = "UpperTorso", 
	[Enum.HumanoidRigType.R6] = "Torso" 
}

local RootCollisionBlacklist = { 
	"LeftHand", "RightHand",
	"LeftLowerArm", "RightLowerArm",
	"LeftFoot", "RightFoot",
	"LeftLowerLeg", "RightLowerLeg"
}

-- // Function
local function NewInstance(ObjectClass, BaseProperties)
	local BaseProperties = BaseProperties or { }
	local Object = Instance.new(ObjectClass)

	for Index, Value in pairs(BaseProperties) do
		Object[Index] = Value
	end

	return Object
end


function RagdollRig:GetRootPart(Character)
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if Humanoid then
		return Character:FindFirstChild(RootObjects[Humanoid.RigType])
	end
end

function RagdollRig:GetR15RigMap(Character)
	return {
		["Head"] = { Character.UpperTorso.NeckRigAttachment, Character.Head.NeckRigAttachment },

		["LowerTorso"] = { 
			Character.UpperTorso.WaistRigAttachment,
			NewInstance("Attachment", { Parent = Character.LowerTorso, Position = Vector3.new(0, Character.LowerTorso.Size.Y / 2, 0) }), 
		},

		["LeftUpperArm"] = { Character.UpperTorso.LeftShoulderRigAttachment, Character.LeftUpperArm.LeftShoulderRigAttachment },
		["LeftLowerArm"] = { Character.LeftUpperArm.LeftElbowRigAttachment, Character.LeftLowerArm.LeftElbowRigAttachment, "HingeConstraint" },
		["LeftHand"] = { Character.LeftLowerArm.LeftWristRigAttachment, Character.LeftHand.LeftWristRigAttachment, "HingeConstraint" },

		["RightUpperArm"] = { Character.UpperTorso.RightShoulderRigAttachment, Character.RightUpperArm.RightShoulderRigAttachment },
		["RightLowerArm"] = { Character.RightUpperArm.RightElbowRigAttachment, Character.RightLowerArm.RightElbowRigAttachment, "HingeConstraint" },
		["RightHand"] = { Character.RightLowerArm.RightWristRigAttachment, Character.RightHand.RightWristRigAttachment, "HingeConstraint" },

		["LeftUpperLeg"] = { Character.LowerTorso.LeftHipRigAttachment, Character.LeftUpperLeg.LeftHipRigAttachment },
		["LeftLowerLeg"] = { Character.LeftUpperLeg.LeftKneeRigAttachment, Character.LeftLowerLeg.LeftKneeRigAttachment, "HingeConstraint" },
		["LeftFoot"] = { Character.LeftLowerLeg.LeftAnkleRigAttachment, Character.LeftFoot.LeftAnkleRigAttachment, "HingeConstraint" },

		["RightUpperLeg"] = { Character.LowerTorso.RightHipRigAttachment, Character.RightUpperLeg.RightHipRigAttachment },
		["RightLowerLeg"] = { Character.RightUpperLeg.RightKneeRigAttachment, Character.RightLowerLeg.RightKneeRigAttachment, "HingeConstraint" },
		["RightFoot"] = { Character.RightLowerLeg.RightAnkleRigAttachment, Character.RightFoot.RightAnkleRigAttachment, "HingeConstraint" },
	}, {
		["LeftUpperArm"] = { TwistLimitsEnabled = true, UpperAngle = 60 },
		["LeftLowerArm"] = { UpperAngle = 135, LowerAngle = -20 },
		["RightUpperArm"] = { TwistLimitsEnabled = true, UpperAngle = 60 },
		["RightLowerArm"] = { UpperAngle = 135, LowerAngle = -20 },
		["LeftHand"] = { LowerAngle = 0, UpperAngle = -20 },
		["RightHand"] = { LowerAngle = 0, UpperAngle = -20 },

		["LeftUpperLeg"] = { TwistLimitsEnabled = true },
		["RightUpperLeg"] = { TwistLimitsEnabled = true },
		["LeftLowerLeg"] = { UpperAngle = -10, LowerAngle = -20 },
		["RightLowerLeg"] = { UpperAngle = -10, LowerAngle = -20 },
		["LowerTorso"] = { TwistLimitsEnabled = true, UpperAngle = 10 },
		["RightFoot"] = { LowerAngle = 0, UpperAngle = -20 },
		["LeftFoot"] = { LowerAngle = 0, UpperAngle = -20 },

		["Head"] = { TwistLimitsEnabled = true, MaxFrictionTorque = 25 }
	}
end

function RagdollRig:GetR6RigMap(Character)
	return {
		["HumanoidRootPart"] = { Character.HumanoidRootPart.RootAttachment, Character.Torso.BodyFrontAttachment },
		["Head"] = { Character.Torso.NeckAttachment, Character.Head.FaceCenterAttachment },

		["Right Arm"] = { 
			Character.Torso.RightCollarAttachment, 
			NewInstance("Attachment", { Parent = Character["Right Arm"], Position = Vector3.new(-(Character["Right Arm"].Size.X / 2), Character["Right Arm"].Size.Y / 2, 0) }), 
		},
		["Left Arm"] = { 
			Character.Torso.LeftCollarAttachment, 
			NewInstance("Attachment", { Parent = Character["Left Arm"], Position = Vector3.new(Character["Left Arm"].Size.X / 2, Character["Left Arm"].Size.Y / 2, 0) }), 
		},

		["Left Leg"] = {
			NewInstance("Attachment", { Parent = Character.Torso, Position = Vector3.new(-0.5, -1, 0) }), 
			NewInstance("Attachment", { Parent = Character["Left Leg"], Position = Vector3.new(0, 1, 0) })
		},
		["Right Leg"] = {
			NewInstance("Attachment", { Parent = Character.Torso, Position = Vector3.new(0.5, -1, 0) }),
			NewInstance("Attachment", { Parent = Character["Right Leg"], Position = Vector3.new(0, 1, 0) })
		}
	}, {

	}
end

function RagdollRig:GetRigMap(Character)
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if Humanoid.RigType == Enum.HumanoidRigType.R15 then
		return self:GetR15RigMap(Character)
	else
		return self:GetR6RigMap(Character)
	end
end

function RagdollRig:BuildConstraints(Character, TargetParent)
	local RigMap, RigSettings = self:GetRigMap(Character)

	for ObjectName, Map in pairs(RigMap) do
		local Object = Character:FindFirstChild(ObjectName)

		if not Object then continue end

		local Constraint = NewInstance(Map[3] or "BallSocketConstraint", {
			Parent = TargetParent,
			Enabled = false,
			LimitsEnabled = true,
			Attachment0 = Map[1],
			Attachment1 = Map[2],
			Name = Map[2].Name .. "Constraint"
		})

		if RigSettings[ObjectName] then 
			for Index, Value in pairs(RigSettings[ObjectName]) do
				Constraint[Index] = Value
			end
		end
	end
end

function RagdollRig:BuildMotors(Character, TargetParent)
	for _, Object in ipairs(Character:GetDescendants()) do
		if Object.ClassName == "Motor6D" then
			NewInstance("ObjectValue", {
				Parent = TargetParent,
				Name = Object.Name,
				Value = Object
			})
		end
	end
end

function RagdollRig:BuildCollision(Character, TargetParent)
	for _, Object in ipairs(Character:GetChildren()) do
		if Object:IsA("BasePart") and not table.find(RootCollisionBlacklist, Object.Name) then
			for _, CollisionObject in ipairs(Character:GetChildren()) do
				if CollisionObject:IsA("BasePart") and not table.find(RootCollisionBlacklist, CollisionObject.Name) and CollisionObject ~= Object then
					NewInstance("NoCollisionConstraint", {
						Parent = TargetParent,
						Enabled = false,
						Part0 = Object,
						Part1 = CollisionObject
					})
				end
			end
		end
	end
end

function RagdollRig:RigCharacterModel(Character)
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	local RigComponents = NewInstance("Folder", { Parent = Character, Name = "RigComponents" })
	local RigConstraints = NewInstance("Folder", { Parent = RigComponents, Name = "RigConstraints" })
	local RigMotors = NewInstance("Folder", { Parent = RigComponents, Name = "RigMotors" })
	local RigCollision = NewInstance("Folder", { Parent = RigComponents, Name = "RigCollision" })

	self:BuildConstraints(Character, RigConstraints)
	self:BuildMotors(Character, RigMotors)
	self:BuildCollision(Character, RigCollision)

	Humanoid.RequiresNeck = false
	NewInstance("WeldConstraint", {
		Part1 = Character.PrimaryPart,
		Part0 = (Humanoid.RigType == Enum.HumanoidRigType.R15 and Character.UpperTorso) or Character.Torso,
		Parent = RigComponents,
		Enabled = false,
		Name = "RagdollRootConstraint"
	})
	
	return RigComponents, Character.DescendantAdded:Connect(function(Object)
		if Object.ClassName == "Motor6D" then
			NewInstance("ObjectValue", {
				Parent = RigMotors,
				Name = Object.Name,
				Value = Object
			})
		end
	end)
end

-- // Module
return RagdollRig