"
I am the way back to an operation: the uri of the resource it acts on and the http method that reaches it there. The uri builder answers me (HOPUriBuilder>>buildLink); the method is the one the operation hangs at in the uri space, the same a request is routed by.
"
Class {
	#name : 'HOPLink',
	#superclass : 'Object',
	#instVars : [
		'href',
		'method'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'instance creation' }
HOPLink class >> href: aString method: aMethod [
	^ self new 
		href: aString;
		method: aMethod;
		yourself
]

{ #category : 'accessing' }
HOPLink >> href [
	^ href
]

{ #category : 'accessing' }
HOPLink >> href: aString [
	href := aString
]

{ #category : 'accessing' }
HOPLink >> method [
	^ method
]

{ #category : 'accessing' }
HOPLink >> method: aMethod [
	method := aMethod
]

{ #category : 'printing' }
HOPLink >> printOn: aStream [
	super printOn: aStream.
	aStream << '('.
	method ifNotNil: [ aStream << method asString asUppercase << ' ' ].
	aStream << href asString << ')'
]
