--!strict
local services = script.Parent.Services

for _, service in services:GetChildren() do
	local serviceName = service.Name
	local serverModuleScript = service:FindFirstChild(`{serviceName}Server`) :: ModuleScript
	if serverModuleScript then
		local success, result = pcall(function()
			local module = require(serverModuleScript) :: any
			module.Init()
		end)

		if not success then
			warn(`Error initializing {serverModuleScript}: {result}`)
			return
		end

		print(`Initialized {serverModuleScript} successfully!`)
	end
end
