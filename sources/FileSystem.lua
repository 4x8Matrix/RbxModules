--[[
    FileSystem.lua

    @Author: AsynchronousMatrix
    @Licence: ...


]]--

-- // Variables
local FileSystem = { }

-- // Functions
function FileSystem._Require(Module, ...)
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
        local Result, Message = FileSystem._Require(ModuleObject, ...)

        if not Result and Message then
            warn(Message)
        else
            table.insert(Result, FileSystem._Require(ModuleObject, ...))
        end
    end

    return Result
end

function FileSystem.LoadChildren(Source, ...)
    local Result = { }

    for _, ModuleObject in ipairs(Source:GetChildren()) do
        Result[ModuleObject.Name] = FileSystem._Require(ModuleObject, ...)
    end

    return Result
end

-- // Module
return FileSystem