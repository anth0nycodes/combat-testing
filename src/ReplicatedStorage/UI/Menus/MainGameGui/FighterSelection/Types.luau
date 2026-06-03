local Types = {}

export type FighterSelectionGui = ScreenGui & {
	Container: Frame & {
		FighterList: Frame & {
			Brawler: TextButton,
			Slayer: TextButton,
		},
		FighterSelectionButton: TextButton,
	},
}

return Types
