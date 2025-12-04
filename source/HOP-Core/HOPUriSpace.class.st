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

{ #category : 'as yet unclassified' }
HOPUriSpace >> zincServerDelegate [ 
	^ HOPServerDelegate new 
]
