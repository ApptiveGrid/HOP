Class {
	#name : 'HOPRouteMatcher',
	#superclass : 'Object',
	#instVars : [
		'uriSpace',
		'segments',
		'startNode',
		'startReceiver',
		'currentIndex',
		'currentNode',
		'routeMatch'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'accessing' }
HOPRouteMatcher >> atEnd [
	^ currentIndex >= segments size
]

{ #category : 'as yet unclassified' }
HOPRouteMatcher >> builStartNode [
	| n |
	^ startReceiver isNil 
		ifTrue: [ uriSpace ]
		ifFalse: [ 
			n := uriSpace nodeForResource: startReceiver.
			routeMatch 
				receiverNode: n;
				receiver: startReceiver.
			n ]
]

{ #category : 'accessing' }
HOPRouteMatcher >> currentNode [
	^ currentNode
]

{ #category : 'initialization' }
HOPRouteMatcher >> initialize [ 
	super initialize.
	currentIndex := 0.
]

{ #category : 'as yet unclassified' }
HOPRouteMatcher >> matchRequest: aZnRequest [ 
	self segments: aZnRequest uri segments.
	routeMatch 
		request: aZnRequest;
		operation: (self resolveNode atMethod: aZnRequest method).
	^ routeMatch 
]

{ #category : 'as yet unclassified' }
HOPRouteMatcher >> matchUri: aUri [
	self segments: aUri segments.
	^ self resolveNode
]

{ #category : 'accessing' }
HOPRouteMatcher >> nextSegment [ 
	^ segments at: (currentIndex := currentIndex + 1)
]

{ #category : 'accessing' }
HOPRouteMatcher >> path: aString [ 
	self uri: aString asZnUrl 
]

{ #category : 'accessing' }
HOPRouteMatcher >> realNode [
	| node |
	node := self resolveNode. 
	^ routeMatch hasExtraPath 
		ifTrue: [ 
			routeMatch 
				receiver: routeMatch receiver scope yourself;
				resolvePathSegments: routeMatch extraPath;
				receiverNode.
			 ]
		ifFalse: [ routeMatch receiverNode ]
]

{ #category : 'navigating' }
HOPRouteMatcher >> resolveNode [ 
	currentNode ifNil: [  
		currentNode := self startNode ].

	(currentNode respondsTo: #handlers) ifTrue: [  
		currentNode hasHandlers ifTrue: [ 
			routeMatch addHandlers: currentNode handlers ] ].
	
	[ self atEnd ] whileFalse: [
		currentNode := currentNode 
			detectSegmentNamed: self nextSegment 
			routeMatch: routeMatch ].
	^ currentNode
]

{ #category : 'resolving' }
HOPRouteMatcher >> resource [
	
	^ self realNode valueIn: routeMatch
]

{ #category : 'accessing - segments' }
HOPRouteMatcher >> segments [
	^ segments 
]

{ #category : 'accessing' }
HOPRouteMatcher >> segments: aCollection [ 
	segments := aCollection
]

{ #category : 'as yet unclassified' }
HOPRouteMatcher >> startNode [
	^ startNode ifNil: [ 
		startNode := self builStartNode ]
]

{ #category : 'as yet unclassified' }
HOPRouteMatcher >> startReceiver: aResource [ 
	routeMatch startReceiver: aResource.
	startReceiver := aResource
]

{ #category : 'accessing' }
HOPRouteMatcher >> uri: aZnUrl [ 
	self segments: aZnUrl segments 
]

{ #category : 'accessing' }
HOPRouteMatcher >> uriSpace: anAGUriSpace [ 
	uriSpace := anAGUriSpace.
	routeMatch := uriSpace newRouteMatch.
]

{ #category : 'accessing' }
HOPRouteMatcher >> valueAt: aString [ 
	| segment |
	currentNode := self startNode.
	currentIndex := 0.
	[ self atEnd ] whileFalse: [
		segment := self nextSegment.
		currentNode := currentNode detectSegmentNamed: segment routeMatch: routeMatch.
		(currentNode name = aString) ifTrue: [ ^ segment  ] ].
	^ nil 
]
