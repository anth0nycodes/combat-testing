--!strict

-- Game Services
local RS = game:GetService("ReplicatedStorage")

-- UI
local UI = require(RS.UI)
-- TODO: initialize client modules once play clicked is true

UI()

for _, service in RS.Shared.Services:GetChildren() do
	local serviceName = service.Name
	local clientModuleScript = service:FindFirstChild(`{serviceName}Client`) :: ModuleScript
	
	if clientModuleScript then
		local success, result = pcall(function()
			local module = require(clientModuleScript) :: any
			module:Init()
		end)
		
		if not success then
			warn(`Error initializing {clientModuleScript}: {result}`)
			return
		end
		
		print(`Initialized {clientModuleScript} successfully!`)
	end
end
