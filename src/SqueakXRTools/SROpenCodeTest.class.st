"
Tests for the OpenCode panel.
"
Class {
	#name : #SROpenCodeTest,
	#superclass : #TestCase,
	#instVars : [
		'openCodePanel'
	],
	#category : #'SqueakXRTools-Tests-OpenCode',
	#'squeak_changestamp' : '<historical>'
}

{
	#category : #running,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:51'
}
SROpenCodeTest >> setUp [

	super setUp.
	openCodePanel := SROpenCode new.
	openCodePanel panel morph: (SROpenCodeTestTerminalMorph new extent: 800 @ 600).
]

{
	#category : #running,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:51'
}
SROpenCodeTest >> tearDown [

	openCodePanel ifNotNil: [openCodePanel panel removeMorph].
	super tearDown.
]

{
	#category : #tests,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:52'
}
SROpenCodeTest >> testAddingToAWorldMountsTheTerminalMorph [

	| testWorld terminalMorph |
	testWorld := SRWorld new project: SRDummyMorphicProject new; yourself.
	terminalMorph := openCodePanel panel morph.
	[
		testWorld addChild: openCodePanel.
		self assert: terminalMorph owner identical: testWorld morphicWorld.
		self assert: (testWorld children select: [:each | each isMorphPanel]) isEmpty]
		ensure: [testWorld removeChild: openCodePanel].
]

{
	#category : #tests,
	#'squeak_changestamp' : 'leo-MCPServer 11/18/2026 17:40'
}
SROpenCodeTest >> testAligningTurnsTheWholeAppSoThePanelFacesTheCamera [

	| camera panelRotation |
	camera := 0 @ 1.6m @ 0.
	panelRotation := openCodePanel panel localRotation.
	openCodePanel
		globalTranslation: 1m @ 3.5m @ -2m;
		globalRotation: (Quaternion angle: 30 axis: Vector3 forward).
	openCodePanel panel alignTowards: camera.
	[openCodePanel panel alignmentTween isStepping] whileTrue: [openCodePanel panel alignmentTween step: 0.1].
	self assert: ((openCodePanel panel forward dot: (camera - openCodePanel panel globalTranslation) normalized) closeTo: 1).
	self assert: openCodePanel panel localRotation equals: panelRotation
]

{
	#category : #tests,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:46'
}
SROpenCodeTest >> testEmptyDirectoryKeepsTheShellWorkingDirectory [

	#('Win32' 'unix') do: [:platformName |
		self assert: (SROpenCode launchCommandForDirectory: '' platform: platformName) equals: 'opencode'].
]

{
	#category : #tests,
	#'squeak_changestamp' : 'leo-MCPServer 11/18/2026 17:36'
}
SROpenCodeTest >> testGrabbingTheAppStopsAligning [

	openCodePanel globalRotation: (Quaternion angle: 30 axis: Vector3 forward).
	openCodePanel panel alignTowards: 0 @ 1.6m @ 0.
	openCodePanel panel grabTarget startGrabbing: nil.
	self deny: openCodePanel panel alignmentTween isStepping
]

{
	#category : #tests,
	#'squeak_changestamp' : 'leo-MCPServer 11/18/2026 14:15'
}
SROpenCodeTest >> testMuteToggleWritesControlYAndNeverEndsTheCall [

	openCodePanel toggleMicrophoneMute.
	self assert: openCodePanel panel morph lastInput asByteArray equals: #[25].
	self deny: (openCodePanel panel morph lastInput includes: (Character value: 24))
]

{
	#category : #tests,
	#'squeak_changestamp' : 'leo-MCPServer 11/18/2026 17:43'
}
SROpenCodeTest >> testNearCameraHeightTheWholeAppFacesTheCameraAxis [

	| panelRotation |
	panelRotation := openCodePanel panel localRotation.
	openCodePanel
		globalTranslation: 1m @ 50cm @ -2m;
		globalRotation: (Quaternion angle: 30 axis: Vector3 forward).
	openCodePanel panel alignTowards: 0 @ 0 @ 0.
	[openCodePanel panel alignmentTween isStepping] whileTrue: [openCodePanel panel alignmentTween step: 0.1].
	self assert: (openCodePanel panel up - Vector3 up) length < 0.001.
	self assert: (openCodePanel panel forward - (-1 @ 0 @ 2) normalized) length < 0.001.
	self assert: openCodePanel panel localRotation equals: panelRotation
]

{
	#category : #tests,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 15:00'
}
SROpenCodeTest >> testOnlyTheTerminalPanelIsTurnedAround [

	openCodePanel positionVoiceMenu.
	self assert: (openCodePanel panel forward dot: openCodePanel forward) < -0.999.
	self assert: (openCodePanel voiceMenu forward dot: openCodePanel forward) > 0.999.
]

{
	#category : #tests,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 15:10'
}
SROpenCodeTest >> testResizeHandlesKeepTheirOwnGrabTargets [

	openCodePanel panel resizers do: [:each |
		self assert: each grabTarget identical: each].
]

{
	#category : #tests,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 15:10'
}
SROpenCodeTest >> testTerminalSurfaceGrabsTheContainer [

	| surface |
	surface := openCodePanel panel children detect: [:each | each isKindOf: SRPlane].
	self assert: surface grabTarget identical: openCodePanel.
]

{
	#category : #tests,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:46'
}
SROpenCodeTest >> testUnixStartingDirectoryIsQuotedLiterally [

	self assert: (SROpenCode launchCommandForDirectory: '/home/O''Brien/My Project' platform: 'unix')
		equals: 'cd -- ''/home/O''"''"''Brien/My Project'' && opencode'.
]

{
	#category : #tests,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:52'
}
SROpenCodeTest >> testUsesComposition [

	self assert: SROpenCode superclass equals: SRObject.
	self assert: openCodePanel panel class equals: SRMorphPanel.
	self assert: (openCodePanel children includes: openCodePanel panel).
	self assert: (openCodePanel children includes: openCodePanel voiceMenu).
	self assert: openCodePanel panel grabTarget identical: openCodePanel.
]

{
	#category : #tests,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:52'
}
SROpenCodeTest >> testVoiceMenuFollowsPanelTranslation [

	| originalPosition |
	openCodePanel positionVoiceMenu.
	originalPosition := openCodePanel voiceMenu localPosition.
	openCodePanel panel localPosition: 10cm @ 20cm @ 0.
	openCodePanel step: 0.
	self assert: (openCodePanel voiceMenu localPosition - originalPosition - (10cm @ 20cm @ 0)) length < 0.00001.
]

{
	#category : #tests,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:51'
}
SROpenCodeTest >> testVoiceMenuFollowsTheLowerRightCorner [

	| menuPosition halfWidth halfHeight |
	openCodePanel panel morph extent: 1000 @ 700.
	openCodePanel panel followMorphExtent.
	openCodePanel step: 0.
	menuPosition := openCodePanel voiceMenu localPosition.
	halfWidth := openCodePanel panel morph width / openCodePanel panel pixelsPerMeter / 2.
	halfHeight := openCodePanel panel morph height / openCodePanel panel pixelsPerMeter / 2.
	self assert: (menuPosition x - (openCodePanel voiceMenu slabWidth / 2) > halfWidth).
	self assert: (menuPosition y - (openCodePanel voiceMenu slabHeight / 2) + halfHeight) abs < 0.00001.
]

{
	#category : #tests,
	#'squeak_changestamp' : 'leo-MCPServer 11/18/2026 14:15'
}
SROpenCodeTest >> testVoiceMenuHasToggleAndMuteActions [

	| rows |
	rows := openCodePanel voiceMenu children select: [:each | each isMenuItem].
	self assert: rows size equals: 2.
	self assert: (rows collect: [:each | each label]) asArray equals: #('Toggle voice mode' 'Mute / unmute mic').
	self assert: (rows allSatisfy: [:each | each keepsMenuOpen]).
	rows first action value.
	self assert: openCodePanel panel morph lastInput asByteArray equals: #[24 118].
	rows second action value.
	self assert: openCodePanel panel morph lastInput asByteArray equals: #[25].
]

{
	#category : #tests,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 15:10'
}
SROpenCodeTest >> testVoiceMenuRowsGrabTheContainer [

	| row |
	row := openCodePanel voiceMenu children detect: [:each | each isMenuItem].
	self assert: row grabTarget identical: openCodePanel.
]

{
	#category : #tests,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:51'
}
SROpenCodeTest >> testVoiceToggleWritesControlXThenV [

	openCodePanel toggleVoiceMode.
	self assert: openCodePanel panel morph lastInput asByteArray equals: #[24 118].
]

{
	#category : #tests,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:46'
}
SROpenCodeTest >> testWindowsStartingDirectoryIsQuotedLiterally [

	self assert: (SROpenCode launchCommandForDirectory: 'C:\Users\O''Brien\My Project' platform: 'Win32')
		equals: 'Set-Location -LiteralPath ''C:\Users\O''''Brien\My Project'' -ErrorAction Stop; if ($?) { opencode }'.
]
