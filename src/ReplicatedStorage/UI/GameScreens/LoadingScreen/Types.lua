local Types = {}

export type LoadingScreenGui = ScreenGui & {
	LoadingFrame: Frame & {
		LoadingText: TextLabel,
		CanvasGroup: CanvasGroup & {
			LoadingBar: Frame & {
				LoadingMeter: TextLabel,
				Percentage: TextLabel
			}
		}
	},
}

return Types