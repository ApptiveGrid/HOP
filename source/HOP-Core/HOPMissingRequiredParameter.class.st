Class {
	#name : 'HOPMissingRequiredParameter',
	#superclass : 'HOPRequestParameterError',
	#instVars : [
		'parameter'
	],
	#category : 'HOP-Core-Errors',
	#package : 'HOP-Core',
	#tag : 'Errors'
}

{ #category : 'accessing' }
HOPMissingRequiredParameter class >> parameter: aString [
	^ self new 
		parameter: aString
]

{ #category : 'accessing' }
HOPMissingRequiredParameter >> messageText [ 
	^ 'parameter ', parameter , ' is required but not present'
]

{ #category : 'accessing' }
HOPMissingRequiredParameter >> parameter: anObject [
	parameter := anObject
]

{ #category : 'accessing' }
HOPMissingRequiredParameter >> typeLabel [
	^ 'MissingParameter'
]
