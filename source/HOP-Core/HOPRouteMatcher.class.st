Class {
	#name : 'HOPRouteMatcher',
	#superclass : 'Object',
	#instVars : [
		'uriSpace',
		'segments',
		'startNode',
		'startReceiver',
		'currentIndex',
		'routeMatch',
		'currentSegment'
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

{ #category : 'navigating' }
HOPRouteMatcher >> findRoute [ 
	currentSegment ifNil: [  
		currentSegment := self startSegment ].

	currentSegment isSpaceZone ifTrue: [  
		routeMatch addHandlers: currentSegment handlers ].
	
	[ self atEnd ] whileFalse: [
		currentSegment := currentSegment 
			detectSegmentNamed: self nextSegment 
			routeMatch: routeMatch ].
	^ currentSegment
]

{ #category : 'initialization' }
HOPRouteMatcher >> initialize [ 
	super initialize.
	currentIndex := 0.
]

{ #category : 'as yet unclassified' }
HOPRouteMatcher >> matchRequest: aZnRequest [ 
	| segment |
	segment := self matchUri: aZnRequest uri.
	routeMatch operation: (segment atMethod: aZnRequest method).
	^ routeMatch 
		request: aZnRequest;
		yourself
]

{ #category : 'as yet unclassified' }
HOPRouteMatcher >> matchUri: aUri [
	segments := aUri segments.
	^ self findRoute
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
	node := self findRoute. 
	^ routeMatch hasExtraPath 
		ifTrue: [ 
			routeMatch 
				receiver: routeMatch receiver scope yourself;
				resolveSegments: routeMatch extraPath;
				receiverNode.
			 ]
		ifFalse: [ routeMatch receiverNode ]
]

{ #category : 'resolving' }
HOPRouteMatcher >> resource [
	
	^ self realNode valueIn: routeMatch
]

{ #category : 'accessing' }
HOPRouteMatcher >> routeMatch [
	^ routeMatch
]

{ #category : 'accessing' }
HOPRouteMatcher >> routeMatch: aRouteMatch [ 
	routeMatch := aRouteMatch
]

{ #category : 'as yet unclassified' }
HOPRouteMatcher >> startReceiver: aResource [ 
	routeMatch startReceiver: aResource.
	startReceiver := aResource
]

{ #category : 'as yet unclassified' }
HOPRouteMatcher >> startSegment [
	^ startNode ifNil: [ 
		startNode := self builStartNode ]
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
	currentSegment := self startSegment.
	currentIndex := 0.
	[ self atEnd ] whileFalse: [
		segment := self nextSegment.
		currentSegment := currentSegment detectSegmentNamed: segment routeMatch: routeMatch.
		(currentSegment name = aString) ifTrue: [ ^ segment  ] ].
	^ nil 
]
