"
A resource route that resolves its stand-in segment to a fixed object, so a test can build uris relative to a route without a model behind it.
"
Class {
	#name : 'HOPTestResourceRoute',
	#superclass : 'HOPResourceRoute',
	#instVars : [
		'standIn'
	],
	#category : 'HOP-Core-Tests-TestData',
	#package : 'HOP-Core-Tests',
	#tag : 'TestData'
}

{ #category : 'accessing' }
HOPTestResourceRoute >> standIn [
	^ standIn
]

{ #category : 'accessing' }
HOPTestResourceRoute >> standIn: anObject [
	standIn := anObject
]
