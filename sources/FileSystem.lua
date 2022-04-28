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
	local Result = { }

	for _, ModuleObject in ipairs(Source) do
		local Result, Message = FileSystem.SafeRequire(ModuleObject, ...)

		if not Result and Message then
			warn(Message)
		else
			table.insert(Result, FileSystem.SafeRequire(ModuleObject, ...))
		end
	end

	return Result
end

function FileSystem.LoadChildren(Source, ...)
	local Result = { }

	for _, ModuleObject in ipairs(Source:GetChildren()) do
		Result[ModuleObject.Name] = FileSystem.SafeRequire(ModuleObject, ...)
	end

	return Result
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