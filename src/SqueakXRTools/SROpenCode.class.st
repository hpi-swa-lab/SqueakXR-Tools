"
An OpenCode terminal and voice menu.
"
Class {
	#name : #SROpenCode,
	#superclass : #SRObject,
	#instVars : [
		'panel',
		'voiceMenu'
	],
	#classVars : [
		'StartingDirectory'
	],
	#category : #'SqueakXRTools-OpenCode',
	#'squeak_changestamp' : '<historical>'
}

{
	#category : #private,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:45'
}
SROpenCode class >> launchCommandForDirectory: aDirectory platform: aPlatform [

	| quotedDirectory |
	aDirectory ifEmpty: [^ 'opencode'].
	aPlatform = 'Win32' ifTrue: [
		quotedDirectory := aDirectory copyReplaceAll: '''' with: ''''''.
		^ 'Set-Location -LiteralPath ''', quotedDirectory, ''' -ErrorAction Stop; if ($?) { opencode }'].
	quotedDirectory := aDirectory copyReplaceAll: '''' with: '''"''"'''.
	^ 'cd -- ''', quotedDirectory, ''' && opencode'
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 15:00'
}
SROpenCode class >> open [

	SWATermLibrary ensureInstalled ifFalse: [^ nil].
	^ self new
		startOpenCode;
		openInFront;
		faceCamera;
		yourself.
]

{
	#category : #preferences,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:45'
}
SROpenCode class >> startingDirectory [

	<preference: 'OpenCode starting directory'
		category: 'SqueakXR'
		description: 'Starting directory for new XR OpenCode terminals. Leave empty to use the current working directory.'
		type: #String>
	^ StartingDirectory ifNil: ['']
]

{
	#category : #preferences,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:45'
}
SROpenCode class >> startingDirectory: aString [

	StartingDirectory := aString.
]

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'leo 11/18/2026 11:31'
}
SROpenCode class >> xrMenuOpenOpenCode: aMenu [

	<xrMenu: #(world tools) label: 'OpenCode' priority: 215>
	^ self open
]

{
	#category : #initialization,
	#'squeak_changestamp' : 'leo-MCPServer 11/18/2026 14:15'
}
SROpenCode >> initialize [

	super initialize.
	panel := SRMorphPanel new
		grabTarget: self;
		localRotation: (Quaternion angle: 180 axis: Vector3 up);
		yourself.
	voiceMenu := SRMenu new
		grabTarget: self;
		addItem: 'Toggle voice mode' action: [self toggleVoiceMode] keepOpen: true;
		addItem: 'Mute / unmute mic' action: [self toggleMicrophoneMute] keepOpen: true;
		yourself.
	voiceMenu rebuild.
	self addChildren: {panel. voiceMenu}.
	self name: 'OpenCode'.
]

{
	#category : #private,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:51'
}
SROpenCode >> mountTerminal [

	| morphicWorld |
	panel ifNil: [^ self].
	panel morph ifNil: [^ self].
	self world ifNil: [^ self].
	morphicWorld := self world morphicWorld.
	morphicWorld ifNil: [^ self].
	panel morph owner ifNotNil: [^ self].
	SRMorphPanel withoutAddingToWorldDo: [morphicWorld addMorph: panel morph].
]

{
	#category : #updating,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:51'
}
SROpenCode >> onWorldChanged: oldWorld [

	super onWorldChanged: oldWorld.
	self mountTerminal.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:51'
}
SROpenCode >> panel [

	^ panel
]

{
	#category : #updating,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 15:00'
}
SROpenCode >> positionVoiceMenu [

	| offset |
	panel ifNil: [^ self].
	panel morph ifNil: [^ self].
	offset :=
		(panel morph width / panel pixelsPerMeter / 2 + (voiceMenu slabWidth / 2) + 1cm)
		@ (panel morph height / panel pixelsPerMeter / -2 + (voiceMenu slabHeight / 2))
		@ 0.
	voiceMenu localPosition: panel localPosition + offset.
]

{
	#category : #initialization,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:51'
}
SROpenCode >> startOpenCode [

	panel morph: SWATermMorph new.
	self mountTerminal.
	panel morph startShell.
	panel morph writeInput: (self class
		launchCommandForDirectory: self class startingDirectory
		platform: Smalltalk platformName), String cr.
	self positionVoiceMenu.
]

{
	#category : #updating,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:51'
}
SROpenCode >> step: deltaTime [

	super step: deltaTime.
	self positionVoiceMenu.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'leo 11/18/2026 14:31'
}
SROpenCode >> toggleMicrophoneMute [

	panel ifNil: [^ self].
	panel morph ifNil: [^ self].
	panel morph writeInput: (String with: (Character value: 25)).
]

{
	#category : #actions,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:51'
}
SROpenCode >> toggleVoiceMode [

	panel ifNil: [^ self].
	panel morph ifNil: [^ self].
	panel morph writeInput: (String with: (Character value: 24) with: $v).
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:45'
}
SROpenCode >> voiceMenu [

	^ voiceMenu
]

{
	#category : #testing,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:51'
}
SROpenCode >> wantsGrab [

	^ true
]
