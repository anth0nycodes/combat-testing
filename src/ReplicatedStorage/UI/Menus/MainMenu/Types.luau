local Types = {}

export type MainMenuGui = ScreenGui & {
	MainMenu: Frame & {
		Buttons: Frame & {
			Credits: TextButton,
			Play: TextButton
		},
		Title: TextLabel
	},
}

export type CreditsGui = ScreenGui & {
	CreditsMenu: Frame & {
		Description: TextLabel,
		Title: TextLabel,
		UIScale: UIScale
	}
}

return Types