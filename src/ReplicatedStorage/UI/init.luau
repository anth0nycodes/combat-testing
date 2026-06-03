--!strict

-- UIs
local LoadingScreen = require(script.GameScreens.LoadingScreen)

return function()
	-- LoadingScreen handles main menu, then main menu handles main game GUIs
	LoadingScreen.Init()
end

-- Commenting the portion below because as of now, I want to manually init each UI to follow a proper flow of Loading -> Main Menu -> All other in game UIs
--return function()
--	for _, moduleScript in script:GetDescendants() do
--		local moduleScript = moduleScript :: ModuleScript
--		if not moduleScript:IsA("ModuleScript") then continue end

--		if moduleScript then
--			local success, result = pcall(function()
--				local uiModule = require(moduleScript) :: any
--				uiModule.Init()
--			end)
			
--			if not success then
--				warn(`Error initializing {moduleScript}: {result}`)
--				return
--			end

--			print(`Initialized {moduleScript} successfully!`)
--		end
--	end
--end