# ParallelScheduler
A Roblox-Parallel module used to call/set unsafe functions and properties, this module will allow you to remain in parallel and call explicit functions which would normally throw an error of some sort if you tried to call them from inside parallel

# ParallelScheduler API Documentation
## Methods
```
    Scheduler.JobAsync(JobType: string, ...: job parameters) -> Result nil? any
```
Description: Creates a job and then yields until that job is complete

Return: Result `.AwaitJob`

---
```
    Scheduler.Job(JobType: string, ...: job parameters) -> Result string
```
Description: Create a job, this job is what will run your setters/namecalls in a non-serial thread.

Return: string, this is the JobID, a unique identifier at which you can do things like .AwaitJob with.

---
```
    Scheduler.AwaitJob(JobId: string) -> Result nil? any
```
Description: Yield until that job has been completed, if already completed then this will never yield, but also not give any results.

Return: Result of that calling function (setting properties will not yield a result.)

---
```
    Scheduler.InitialiseJobType(JobType: string, JobExecutor: function)
```
Description: Allow you to create your own serial handlers, a handler is a block of code which executes a non-serial job, jobs are like instructions, these handles read and act on these instructions.
An example of the Namecall handler is;

```
Scheduler.InitialiseJobType("Namecall", function(Job) -- If we are to create a namecall job, this will be the function which handles it.
		local Object = table.remove(Job, 1)
		local Method = table.remove(Job, 1)
		local Parameters = table.remove(Job, 1)

		return Object[Method](Object, table.unpack(Parameters)) -- We are then calling our function, returning the result.
	end)
  ```

By default, there are two handlers already created. 
- Namecall (This is when you would call a method with the `:` operator, example `Model:PivotTo`, we're using `:` to Pivot)
- Set (This is when you want to set a property, we can't actually set the CFrame in parallel, so we could set it with this instead)

---
## Properties
```
    Scheduler.Active: Boolean
```

Defines if the scheduler is active at this point in time, the scheduler will only be active IF it is executing in a serial environment.

---
## Example
The example below is how you would randomly change the CFrame of an object in parallel
The script is parented under this object.

```
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ParallelScheduler = require(ReplicatedStorage.ParallelScheduler)
local Object = script.Parent

task.desynchronize()
while true do
	task.wait(1)
	
	local RandomCFrame = Vector3.new(math.random(), Object.Position.Y, math.random())
	
	ParallelScheduler.Job(
		"Set", -- What we want to do
		Object, "CFrame", Object.CFrame + ((math.random() > 0.5 and -RandomCFrame) or RandomCFrame) -- What we're setting
	)
end
```
