local Types = {}

export type SettingsGui = ScreenGui & {
	SettingsMenu: Frame & {
		UIScale: UIScale,
		Options: Frame & {
			ShowHitbox: Frame & {
				Checkbox: TextButton,
				HitboxLabel: TextLabel,
			},
		},
		SettingsLabel: TextLabel,
	},
	SettingsButton: ImageButton,
}

return Types
