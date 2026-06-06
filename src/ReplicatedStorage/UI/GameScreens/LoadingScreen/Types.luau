local Types = {}

export type LoadingScreenGui = ScreenGui & {
	LoadingFrame: Frame & {
		Title: TextLabel,
		LoadingText: TextLabel,
		Percentage: TextLabel,
		CanvasGroup: CanvasGroup & {
			LoadingBar: Frame & {
				LoadingMeter: Frame,
			},
		},
	},
}

return Types
