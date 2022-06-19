# RagdollSystem
A Module used to simplify the process of ragdolling roblox character objects

# RagdollSystem API Documentation
## Methods
```
    RagdollSystem.RigCharacter(Character: RbxInstance) -> Instance
```
Description: Creates a rig for the specific character instance; This rig can be manipulated to enable/disable the humanoid state

---
```
    RagdollSystem.SetRagdollState(Character: RbxInstance, State: Boolean)
```
Description: Sets the character ragdoll state.

---
## Example
The example below is essentially just psuedo code used to explain how the RagdollSystem Module works.
```
local RagdollSystem = require("RagdollSystem")

RagdollSystem.RigCharacter(workspace.RagdolledCharacter)
RagdollSystem.SetRagdollState(workspace.RagdolledCharacter, true)
```
