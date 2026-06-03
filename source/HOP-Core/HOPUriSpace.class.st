Class {
	#name : 'HOPUriSpace',
	#superclass : 'HOPSpaceZone',
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'arithmetic' }
HOPUriSpace class >> /+ aSegment [
	^ self new /+ aSegment 
]

{ #category : 'visiting' }
HOPUriSpace >> acceptHOP: aHOPVisitor [
	^ aHOPVisitor visitUriSpace: self 
]

{ #category : 'converting' }
HOPUriSpace >> asZincDelegate [
	^ self zincServerDelegate	
		uriSpace: self;
		yourself 
]

{ #category : 'accessing' }
HOPUriSpace >> build [
	self subclassResponsibility 
]

{ #category : 'accessing' }
HOPUriSpace >> buildUriForResource: anObject startingAt: aHOPSegment [
	^ self uriBuilderClass new
		resource: anObject;
		visit: aHOPSegment;
		build
]

{ #category : 'initialization' }
HOPUriSpace >> initialize [ 
	super initialize.
	"self build"
]

{ #category : 'printing' }
HOPUriSpace >> isRoot [
	^ parent isNil 
]

{ #category : 'accessing' }
HOPUriSpace >> name [ 
	^ name ifNil: [ '/' ]
]

{ #category : 'instance creation' }
HOPUriSpace >> newRouteMatch [
	^ self routeMatchClass new 
		uriSpace: self 
]

{ #category : 'instance creation' }
HOPUriSpace >> newRouteMatcher [
	^ self routeMatcherClass new 
		uriSpace: self;
		yourself.
]

{ #category : 'accessing' }
HOPUriSpace >> newUriBuilder [
	^ self uriBuilderClass new
]

{ #category : 'printing' }
HOPUriSpace >> nodeLabel [ 
	^ 'uri space'
]

{ #category : 'printing' }
HOPUriSpace >> printOn: aStream [ 
	self isRoot
		ifTrue: [ aStream  << '/' ] 
		ifFalse: [ aStream  << name asString ].
	aStream << ' [uri space]'.

]

{ #category : 'instance creation' }
HOPUriSpace >> routeMatchClass [
	^ HOPRouteMatch
]

{ #category : 'instance creation' }
HOPUriSpace >> routeMatcherClass [
	^ HOPRouteMatcher
]

{ #category : 'accessing' }
HOPUriSpace >> uriBuilderClass [
	^ HOPUriBuilder
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> zincServerDelegate [ 
	^ HOPServerDelegate new 
]
