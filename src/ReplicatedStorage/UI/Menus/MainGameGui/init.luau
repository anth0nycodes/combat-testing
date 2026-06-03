--!strict
local MainGameGui = {}

function MainGameGui.Init()
	for _, guiModuleScript: ModuleScript in script:GetChildren() do
		local success, result = pcall(function()
			local guiModule = require(guiModuleScript) :: any
			guiModule.Init()
		end)

		if not success then
			warn(`Error initializing {guiModuleScript} game GUI: {result}`)
			return
		end

		print(`Initialized {guiModuleScript} game GUI successfully!`)
	end
end

return MainGameGui
