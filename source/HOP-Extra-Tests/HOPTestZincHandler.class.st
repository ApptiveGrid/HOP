Class {
	#name : 'HOPTestZincHandler',
	#superclass : 'Object',
	#instVars : [
		'answer',
		'seenRequest'
	],
	#category : 'HOP-Extra-Tests',
	#package : 'HOP-Extra-Tests'
}

{ #category : 'accessing' }
HOPTestZincHandler >> answer: aString [
	answer := aString
]

{ #category : 'public' }
HOPTestZincHandler >> handleRequest: aRequest [
	seenRequest := aRequest.
	^ ZnResponse ok: (ZnEntity text: answer)
]

{ #category : 'accessing' }
HOPTestZincHandler >> seenRequest [
	^ seenRequest
]
