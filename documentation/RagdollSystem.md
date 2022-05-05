# FileSystem
A Module used to simplify the process of ragdolling roblox character objects

# FileSystem API Documentation
## Methods
```
    FileSystem.RigCharacter(Character: RbxInstance) -> Instance
```
Description: Creates a rig for the specific character instance; This rig can be manipulated to enable/disable the humanoid state

---
```
    FileSystem.SetRagdollState(Character: RbxInstance, State: Boolean)
```
Description: Sets the character ragdoll state.

---
## Example
The example below is essentially just psuedo code used to explain how the FileSystem Module works.
```
local FileSystem = require("FileSystem")

FileSystem.LoadChildren(workspace.Modules)
FileSystem.LoadTable({
    workspace.Module0, worksppace.Module1
})
```
