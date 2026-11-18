"
A terminal input recorder.
"
Class {
	#name : #SROpenCodeTestTerminalMorph,
	#superclass : #Morph,
	#instVars : [
		'lastInput'
	],
	#category : #'SqueakXRTools-Tests-OpenCode',
	#'squeak_changestamp' : '<historical>'
}

{
	#category : #accessing,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:46'
}
SROpenCodeTestTerminalMorph >> lastInput [

	^ lastInput
]

{
	#category : #testing,
	#'squeak_changestamp' : 'MCPServer (leo) 11/16/2026 14:46'
}
SROpenCodeTestTerminalMorph >> writeInput: aString [

	lastInput := aString.
]
