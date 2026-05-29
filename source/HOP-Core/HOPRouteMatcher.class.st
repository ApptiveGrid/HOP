Class {
	#name : 'HOPRouteMatcher',
	#superclass : 'Object',
	#instVars : [
		'uriSpace',
		'segments',
		'currentIndex',
		'routeMatch',
		'currentSegment',
		'startSegment'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'accessing' }
HOPRouteMatcher >> atEnd [
	^ currentIndex >= segments size
]

{ #category : 'initialization' }
HOPRouteMatcher >> initialize [ 
	super initialize.
	currentIndex := 0.
]

{ #category : 'testing' }
HOPRouteMatcher >> matchPath: aString [ 
	^ self matchUri: aString asZnUrl 
]

{ #category : 'as yet unclassified' }
HOPRouteMatcher >> matchRequest: aZnRequest [ 
	self matchUri: aZnRequest uri.
	routeMatch operation: (currentSegment atMethod: aZnRequest method).
	^ self routeMatch 
		request: aZnRequest;
		yourself
]

{ #category : 'navigating' }
HOPRouteMatcher >> matchRoute [ 
	currentSegment ifNil: [  
		currentSegment := self startSegment ].

	currentSegment isSpaceZone ifTrue: [  
		self routeMatch addHandlers: currentSegment handlers ].
	
	[ self atEnd ] whileFalse: [
		currentSegment := currentSegment 
			detectSegmentNamed: self nextSegment 
			routeMatch: self routeMatch ].
	^ routeMatch 
]

{ #category : 'as yet unclassified' }
HOPRouteMatcher >> matchSegments: aCollection [
	segments := aCollection.
	^ self matchRoute
]

{ #category : 'as yet unclassified' }
HOPRouteMatcher >> matchUri: aUri [
	^ self matchSegments: aUri pathSegments
]

{ #category : 'accessing' }
HOPRouteMatcher >> nextSegment [ 
	^ segments at: (currentIndex := currentIndex + 1)
]

{ #category : 'accessing' }
HOPRouteMatcher >> realNode [
	^ self routeMatch hasExtraPath 
		ifTrue: [ self halt. self routeMatch matchExtraPath routeMatch receiverNode ]
		ifFalse: [ self routeMatch receiverNode ]
]

{ #category : 'resolving' }
HOPRouteMatcher >> resource [
self halt.
	^ routeMatch hasExtraPath 
		ifTrue: [ routeMatch matchExtraPath routeMatch resource ]
		ifFalse: [ routeMatch resource ]

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

	startSegment := uriSpace nodeForResource: aResource
]

{ #category : 'as yet unclassified' }
HOPRouteMatcher >> startSegment [
	^ startSegment ifNil: [ 
		startSegment := uriSpace ]
]

{ #category : 'accessing' }
HOPRouteMatcher >> uriSpace: anAGUriSpace [ 
	uriSpace := anAGUriSpace.
	routeMatch := uriSpace newRouteMatch.
]

{ #category : 'accessing' }
HOPRouteMatcher >> valueAt: aString [ 
	| segment |
	self halt.
	currentSegment := self startSegment.
	currentIndex := 0.
	[ self atEnd ] whileFalse: [
		segment := self nextSegment.
		currentSegment := currentSegment detectSegmentNamed: segment routeMatch: routeMatch.
		(currentSegment name = aString) ifTrue: [ ^ segment  ] ].
	^ nil 
]
