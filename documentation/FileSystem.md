# FileSystem
A Module used to simplify the process of importing a multitude of Modules, a safe and easier way to require your modules in an experience.

# FileSystem API Documentation
## Methods
```
    FileSystem.LoadTable(Source: Array) -> Array
```
Description: Safely import a array of modules

Return: Table - An Array [Source Index]: Module

---
```
    FileSystem.LoadChildren(Source: RbxInstance) -> Dictionary
```
Description: Safely import the children of an Roblox instance

Return: Table - A Dictionary [ModuleName]: Module

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
