Class {
	#name : 'HOPStandaloneTestCase',
	#superclass : 'HOPTestCase',
	#instVars : [
		'debugMode'
	],
	#category : 'HOP-Core-Tests',
	#package : 'HOP-Core-Tests'
}

{ #category : 'as yet unclassified' }
HOPStandaloneTestCase >> debugMode [ 
	^ debugMode ifNil: [ true ]
]

{ #category : 'as yet unclassified' }
HOPStandaloneTestCase >> handleRequest: aRequest [
	^ [[ self delegate handleRequest: aRequest ]
		on: ZnRespond 
		do: [ :error | error response ]]
			on: Error 
			do: [ :error | 
				self debugMode 
					ifTrue: [ error pass ]
					ifFalse: [ ZnResponse serverError: error messageText ] ]
]
