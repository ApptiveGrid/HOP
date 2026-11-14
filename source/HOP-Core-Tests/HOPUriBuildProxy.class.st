"
I stand in for another object and forward every message to it, as a proxy of a database does.
"
Class {
	#name : 'HOPUriBuildProxy',
	#superclass : 'ProtoObject',
	#instVars : [
		'object'
	],
	#category : 'HOP-Core-Tests-TestData',
	#package : 'HOP-Core-Tests',
	#tag : 'TestData'
}

{ #category : 'instance creation' }
HOPUriBuildProxy class >> on: anObject [

	^ self basicNew setObject: anObject
]

{ #category : 'reflective operations' }
HOPUriBuildProxy >> doesNotUnderstand: aMessage [

	^ aMessage sendTo: object
]

{ #category : 'initialization' }
HOPUriBuildProxy >> setObject: anObject [

	object := anObject
]
