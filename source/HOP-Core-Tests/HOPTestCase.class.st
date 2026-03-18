Class {
	#name : 'HOPTestCase',
	#superclass : 'TestCase',
	#instVars : [
		'debugMode'
	],
	#category : 'HOP-Core-Tests',
	#package : 'HOP-Core-Tests'
}

{ #category : 'tests' }
HOPTestCase >> baseUri [ 
	^  self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
HOPTestCase >> debugMode [ 
	^ debugMode ifNil: [ true ]
]

{ #category : 'as yet unclassified' }
HOPTestCase >> handleRequest: aRequest [
	^ [[ self uriSpace asZincDelegate handleRequest: aRequest ]
		on: ZnRespond 
		do: [ :error | error response ]]
			on: Error 
			do: [ :error | 
				self debugMode 
					ifTrue: [ error pass ]
					ifFalse: [ ZnResponse serverError: error messageText ] ]
]

{ #category : 'as yet unclassified' }
HOPTestCase >> parseResponse: aZnResponse [ 
	^ NeoJSONReader fromString: aZnResponse contents 
]

{ #category : 'tests' }
HOPTestCase >> uriSpace [ 

	self subclassResponsibility 
]
