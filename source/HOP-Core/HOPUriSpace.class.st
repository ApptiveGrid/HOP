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
	| resourceRoot |
	self root recursiveDo: [ :node | 
		node hasMethods ifTrue: [
			resourceRoot := node nearestResourceNode. 
			node methods keysAndValuesDo: [ :method :operationMapping |   
				(operationMapping respondsTo: #operation) ifTrue: [  
					self 
						registerSegment: node 
						forResourceRoot: resourceRoot 
						andOperation: operationMapping operation ] ] ] ]
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> buildUriForOperation: aClass resource: anObject [

	| resourceRoot |
	resourceRoot := behaviorSegments at: anObject class.
	^ self newUriBuilder 
		  resource: anObject;
		  visit:
			  (self segmentForResourceRoot: resourceRoot andOperation: aClass);
		  build
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> buildUriForResource: anObject [ 
	^ self newUriBuilder 
		resource: anObject;
		visit: (self segmentForResource: anObject);
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
		uriSpace: self;
		yourself 
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
HOPUriSpace >> registerSegment: segment forResourceRoot: resourceRoot andOperation: aClass [ 
	operationSegments 
		at: { resourceRoot . aClass }
		put: segment 
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> registerSegment: segment  forResourceType: aClass [ 
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
HOPUriSpace >> segmentForResource: aResource [ 	
	^ self segmentForResourceType: aResource yourself class
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> segmentForResource: resource andOperation: anOperation [
	| resourceRoot |
	resourceRoot := self segmentForResource: resource.
	^ operationSegments at: { resourceRoot . anOperation } 
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> segmentForResourceRoot: resourceRoot andOperation: anOperation [
	^ operationSegments at: { resourceRoot. anOperation } 
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> segmentForResourceType: aClass [ 	
	^ behaviorSegments at: aClass
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> segmentForResourceType: resourceClass andOperation: anOperation [
	| resourceRoot |
	resourceRoot := self segmentForResourceType: resourceClass.
	^ operationSegments at: { resourceRoot . anOperation } 
]

{ #category : 'accessing' }
HOPUriSpace >> uriBuilderClass [
	^ HOPUriBuilder
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> zincServerDelegate [ 
	^ HOPServerDelegate new 
]
