--[[
	NetworkModule.lua

	
]]--

-- // Variables
local RagdollNetwork = { }

-- // Functions
function RagdollNetwork:SetOwner(Character, Owner)
	local CanSet, Exception = Character.PrimaryPart:CanSetNetworkOwnership()

	if Owner == false then
		Owner = nil
	end

	if CanSet then
		Character.PrimaryPart:SetNetworkOwner(Owner)
	else
		return warn(("NetworkOwner Failed // %s: %s"):format(tostring(Character), Exception))
	end
end

-- // Module
return RagdollNetwork