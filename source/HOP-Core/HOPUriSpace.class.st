Class {
	#name : 'HOPUriSpace',
	#superclass : 'HOPSpaceZone',
	#instVars : [
		'operationSegments',
		'behaviorSegments'
	],
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

{ #category : 'as yet unclassified' }
HOPUriSpace >> atOperation: operation put: node [
	^ operationSegments 
		at: operation 
		ifPresent: [ Error signal: 'trying to register operation ', operation asString, ' twice' ]
		ifAbsent: [ 
			operationSegments 
				at: operation 
				put: node ]
]

{ #category : 'accessing' }
HOPUriSpace >> build [
	self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> buildInstanceMap [
	"the model we expose via URIs needs to have entries for resolving an object to 
	its canonical location in the tree. Each instance node registers the instance 
	class in the map so it can be looked up"
	self root recursiveDo: [ :node | 
		((node isKindOf: HOPVariableSegment) and: [ node isCanonical ]) ifTrue: [
			"objects at a URI can be polymorph. Therefor we register all subclasses 
			for the same node"
			node instanceMapClasses do: [ :instanceKind | 
				behaviorSegments 
					at: instanceKind 
					ifPresent: [ Error signal: 'try to register class ', instanceKind asString, ' more than once ' ]
					ifAbsent: [ behaviorSegments at: instanceKind put: node ] ] ] ]
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> buildOperationSegments [
	self root recursiveDo: [ :node | 
		node hasMethods ifTrue: [ 
			node methods keysAndValuesDo: [ :method :operationMapping |   
					self 
						atOperation: operationMapping operation 
						put: node ] ] ]
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> buildUriForOperation: aClass resource: anObject [ 
	^ self uriBuilderClass new
		resource: anObject;
		visit: (self segmentOfOperation: aClass);
		build
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> buildUriForResource: anObject [ 
	^ self uriBuilderClass new
		resource: anObject;
		visit: (self segmentOfResource: anObject);
		build
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> canonicalUriForResource: resource [
	| instanceNode |

	instanceNode := behaviorSegments 
		at: resource yourself class
		ifAbsent: [ AGCallNotFound signal: 'no instance node for ', resource asString ].
	^ '/', ($/ join: (instanceNode canonicalUriFor: resource))
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> canonicalUriForResource: resource operation: operation [
	
	| node |
	node := operationSegments at: operation.
	^ '/', ($/ join: (node canonicalUriFor:  resource ))
]

{ #category : 'initialization' }
HOPUriSpace >> initialize [ 
	super initialize.
	behaviorSegments := Dictionary new.
	operationSegments := Dictionary new. 
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

{ #category : 'as yet unclassified' }
HOPUriSpace >> nodeForResource: aResource [ 	
	^ behaviorSegments at: aResource yourself class
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

{ #category : 'as yet unclassified' }
HOPUriSpace >> register: segment  forClass: aClass [ 
	aClass hopExposedClasses do: [ :behavior | 
		behaviorSegments 
			at: behavior 
			ifPresent: [ Error signal: 'try to register class ', behavior asString, ' more than once ' ]
			ifAbsent: [ behaviorSegments at: behavior put: segment ] ] 
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
HOPUriSpace >> segmentOfOperation: anOperation [
	^ operationSegments at: anOperation 
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> segmentOfResource: aResource [
	^ behaviorSegments at: aResource class 
]

{ #category : 'accessing' }
HOPUriSpace >> uriBuilderClass [
	^ HOPUriBuilder
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> uriForOperation: operation resource: resource resourceRoute: resourceRoute [
	| node uri |
	node := operationSegments at: operation.
	uri := '/', ($/ join: (node uriFor: resource resourceRoute: resourceRoute)).
	^ uri
	
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> uriForResource: resource resourceRoute: resourceRoute [
	| instanceNode uri |
	instanceNode := behaviorSegments 
		at: resource class
		ifAbsent: [ AGCallNotFound signal: 'no instance node for ', resource asString ].
	uri := '/', ($/ join: (instanceNode uriFor: resource resourceRoute: resourceRoute)).
	^ uri
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> zincServerDelegate [ 
	^ HOPServerDelegate new 
]
