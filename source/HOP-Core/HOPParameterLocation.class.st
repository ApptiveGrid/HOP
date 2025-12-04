Class {
	#name : 'HOPParameterLocation',
	#superclass : 'Object',
	#instVars : [
		'parameter'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'instance creation' }
HOPParameterLocation class >> of: anOAParameter [
	^ self new
		parameter: anOAParameter;
		yourself.
]

{ #category : 'accessing' }
HOPParameterLocation >> parameter: anOAParameter [
	parameter := anOAParameter.
]

{ #category : 'accessing' }
HOPParameterLocation >> parameterName [
	^ parameter name.
]

{ #category : 'accessing' }
HOPParameterLocation >> parameterSchema [
	^ parameter schema.
]

{ #category : 'as yet unclassified' }
HOPParameterLocation >> readFromRequest: aRequest [
	self shouldBeImplemented.
]
