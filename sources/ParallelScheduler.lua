local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local Scheduler = { }
local Awaiting = { }

Scheduler.Jobs = {}
Scheduler.JobType = {}
Scheduler.JobHandlers = {}
Scheduler.Active = false

function Scheduler.JobAsync(...)
	return Scheduler.AwaitJob(Scheduler.Job(...))
end

function Scheduler.Job(JobType, ...)
	local JobID = HttpService:GenerateGUID(false)

	Awaiting[JobID] = { }

	table.insert(Scheduler.Jobs, {
		tostring(JobType),
		JobID,
		{ ... }
	})

	return JobID
end

function Scheduler.AwaitJob(JobID)
	if Awaiting[JobID] then
		table.insert(Awaiting[JobID], coroutine.running())

		return coroutine.yield()
	end
end

function Scheduler.InitialiseJobType(JobType, JobExecutor)
	Scheduler.JobType[JobType] = newproxy(true)
	getmetatable(Scheduler.JobType[JobType]).__tostring = function()
		return JobType
	end

	Scheduler.JobHandlers[Scheduler.JobType[JobType]] = JobExecutor
end

function Scheduler.ExecuteJob(Job)
	local JobType = table.remove(Job, 1)
	local JobTypeEnum = Scheduler.JobType[JobType]
	local JobHandler = Scheduler.JobHandlers[JobTypeEnum]

	table.remove(Job, 1)

	return JobHandler(table.remove(Job, 1))
end

function Scheduler.init()
	Scheduler.InitialiseJobType("Namecall", function(Job)
		local Object = table.remove(Job, 1)
		local Method = table.remove(Job, 1)
		local Parameters = table.remove(Job, 1)

		return Object[Method](Object, table.unpack(Parameters))
	end)

	Scheduler.InitialiseJobType("Set", function(Job)
		local Object = table.remove(Job, 1)
		local Property = table.remove(Job, 1)
		local Value = table.remove(Job, 1)

		Object[Property] = Value
	end)

	coroutine.resume(Scheduler.Thread)
end

function Scheduler.new()
	Scheduler.Thread = coroutine.create(function()
		while true do
			if #Scheduler.Jobs > 0 then
				Scheduler.Active = true
				Scheduler.ExecuteJob(table.remove(Scheduler.Jobs, 1))
			else
				Scheduler.Active = false
				RunService.Stepped:Wait()
			end
		end
	end)

	Scheduler.init()

	return Scheduler
end

return Scheduler.new()
