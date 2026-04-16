Class {
	#name : 'HOPStandaloneTestCase',
	#superclass : 'HOPTestCase',
	#instVars : [
		'debugMode'
	],
	#category : 'HOP-Core-Tests',
	#package : 'HOP-Core-Tests'
}

{ #category : 'testing' }
HOPStandaloneTestCase class >> isAbstract [ 
	^ self == HOPStandaloneTestCase 
]

{ #category : 'as yet unclassified' }
HOPStandaloneTestCase >> debugMode [ 
	^ debugMode ifNil: [ true ]
]

{ #category : 'as yet unclassified' }
HOPStandaloneTestCase >> handleRequest: aRequest [

	^ self handleResponseDuring: [ 
		self withServerDuring: [ 
			self delegate handleRequest: aRequest  ] ]
		
]

{ #category : 'as yet unclassified' }
HOPStandaloneTestCase >> handleResponseDuring: aBlock [
	^ 
	[ aBlock 
		on: ZnRespond 
		do: [ :error | error response ] ]
			on: Error 
			do: [ :error | 
				self debugMode 
					ifTrue: [ error pass ]
					ifFalse: [ ZnResponse serverError: error messageText ] ]
]

{ #category : 'initialization' }
HOPStandaloneTestCase >> initialize [ 
	super initialize.
	debugMode := false
]

{ #category : 'as yet unclassified' }
HOPStandaloneTestCase >> withServerDuring: aBlock [
	^ ZnCurrentServer 
		value: self 
		during: aBlock
]
