--[[
	FileSystem.lua

	@Author: AsynchronousMatrix
	@Licence: ...

	Module used to simplify importing modules
]]--

-- // Variables
local FileSystem = { Name = "FileSystem" }

-- // Functions
function FileSystem.SafeRequire(Module, ...)
	local Success, Result = pcall(require, Module)

	if Success then
		return (type(Result) == "function" and Result(...)) or Result
	else
		return nil, Result
	end
end

function FileSystem.LoadTable(Source, ...)
	for _, ModuleObject in ipairs(Source) do
		local Result, Message = FileSystem.SafeRequire(ModuleObject, ...)

		if not Result and Message then
			warn(Message)
		else
			coroutine.wrap(FileSystem.SafeRequire)(ModuleObject, ...)
		end
	end
end

function FileSystem.LoadChildren(Source, ...)
	for _, ModuleObject in ipairs(Source:GetChildren()) do
		coroutine.wrap(FileSystem.SafeRequire)(ModuleObject, ...)
	end
end

function FileSystem.LoadTableInto(Source, Table, ...)
	for _, ModuleObject in ipairs(Source) do
		if ModuleObject == script then
			continue
		end

		Table[ModuleObject.Name] = FileSystem.SafeRequire(ModuleObject, ...)
	end
end

function FileSystem.LoadChildrenInto(Source, Table, ...)
	for _, ModuleObject in ipairs(Source:GetChildren()) do
		if ModuleObject == script then
			continue
		end

		Table[ModuleObject.Name] = FileSystem.SafeRequire(ModuleObject, ...)
	end
end

-- // Module
return FileSystem
