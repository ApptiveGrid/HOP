Class {
	#name : 'HOPUriSpace',
	#superclass : 'HOPNamedSegment',
	#instVars : [
		'operations',
		'behaviorSegments',
		'instanceClassSets'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'arithmetic' }
HOPUriSpace class >> /+ aSegment [
	^ self new /+ aSegment 
]

{ #category : 'converting' }
HOPUriSpace class >> asHOPSegment [
	"a uri space class mounted under a name, as in #auth -> OIDCUriSpace"
	^ self new 
		build;
		asHOPSegment 
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

{ #category : 'building' }
HOPUriSpace >> build [
	"a subclass grows the tree, then the space knows its way back: which segment the
	instances of a class sit at and which segment and method reach an operation"
	self buildTree.
	self 
		buildInstanceMap;
		buildOperationSegments
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> buildInstanceMap [
	"the model we expose via URIs needs to have entries for resolving an object to 
	its canonical location in the tree. Each instance node registers the instance 
	class in the map so it can be looked up. A class may have several canonical
	locations, e.g. the blocks of a space and those of a grid; segmentForResource: chooses
	among them"
	self root recursiveDo: [ :node | 
		((node isKindOf: HOPVariableSegment) and: [ node isCanonical ]) ifTrue: [
			"objects at a URI can be polymorph. Therefor we register all subclasses 
			for the same node"
			node instanceMapClasses do: [ :instanceKind | 
				self registerSegment: node forInstanceClass: instanceKind ] ] ]
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> buildOperationSegments [
	| resourceRoot |
	self root recursiveDo: [ :node | 
		node hasMethods ifTrue: [
			resourceRoot := node nearestResourceNode. 
			node methods keysAndValuesDo: [ :method :entry |   
				entry hopOperation ifNotNil: [ :operation |  
					self 
						registerSegment: node 
						method: method
						forResourceRoot: resourceRoot 
						andOperation: operation ] ] ] ]
]

{ #category : 'building' }
HOPUriSpace >> buildTree [
	self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> buildUriForOperation: aClass resource: anObject [

	^ self newUriBuilder 
		resource: anObject;
		operation: aClass;
		build
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> buildUriForResource: anObject [ 
	^ self newUriBuilder 
		resource: anObject;
		build
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> canonicalUriForResource: resource [

	^ self buildUriForResource: resource
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> canonicalUriForResource: resource operation: operation [
	
	^ self buildUriForOperation: operation resource: resource
]

{ #category : 'initialization' }
HOPUriSpace >> initialize [ 
	super initialize.
	instanceClassSets := IdentityDictionary new.
	behaviorSegments := Dictionary new. "class -> the segments it is canonical at"
	operations := Dictionary new
]

{ #category : 'testing' }
HOPUriSpace >> isResource: anObject inScopeOf: aReceiver [
	"anObject is in the scope of a route's receiver when it is the receiver or the resource the
	receiver stands for. A space whose objects can be stand-ins for themselves, like
	database proxies, compares them its own way"

	^ anObject == aReceiver or: [ anObject == aReceiver extraReceiver ]
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
HOPUriSpace >> registerSegment: segment  forResourceType: aClass [ 
	aClass hopExposedClasses do: [ :behavior | 
		self registerSegment: segment forInstanceClass: behavior ] 
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> registerSegment: segment forInstanceClass: aClass [
	"a class may be canonical at several segments, each is kept once"

	| segments |
	segments := behaviorSegments at: aClass ifAbsentPut: [ OrderedCollection new ].
	(segments anySatisfy: [ :each | each == segment ]) ifFalse: [ segments add: segment ]
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> registerSegment: segment method: aMethod forResourceRoot: resourceRoot andOperation: aClass [ 
	"an operation is reached at a segment with an http method; both together are the way
	back to it"
	operations 
		at: { resourceRoot . aClass }
		ifPresent: [ Error signal: 'try to register operation ', aClass asString, ' for resource root ', resourceRoot asString, ' more than once' ]
		ifAbsent: [ operations at: { resourceRoot . aClass } put: { segment . aMethod } ]
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
HOPUriSpace >> segmentAndMethodForResource: resource andOperation: anOperation [
	"the segment anOperation hangs at and the http method it is reached with there"
	^ operations at: { self segmentForResource: resource . anOperation }
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> segmentForResource: aResource [ 
	"the segment aResource is canonical at. A class with several canonical segments is
	told apart by what is above the resource: only one of the segments has a chain of
	containers up to the root that the segments above accept"

	| segments fitting |
	segments := self segmentsForResourceType: aResource yourself class.
	segments size = 1 ifTrue: [ ^ segments first ].
	fitting := segments select: [ :each | self segment: each fitsContainersOf: aResource ].
	fitting size = 1 ifTrue: [ ^ fitting first ].
	^ Error signal: (fitting isEmpty
		ifTrue: [ 'no canonical segment of ' , aResource yourself class asString , ' fits the containers of the resource' ]
		ifFalse: [ 'more than one canonical segment of ' , aResource yourself class asString , ' fits the containers of the resource' ])
]

{ #category : 'testing' }
HOPUriSpace >> segment: aSegment fitsContainersOf: aResource [
	"walking up from aResource: the container, which the segment names by its
	containerSelector, must be of a class the next variable segment above resolves. A
	segment that resolves no classes cannot be asked and ends the walk, as does the
	root"

	| segment resource |
	segment := aSegment.
	resource := aResource.
	[ | container above |
	(resource respondsTo: segment containerSelector asSymbol) ifFalse: [ ^ false ].
	container := resource perform: segment containerSelector asSymbol.
	above := segment parent ifNotNil: [ :each | each nearestResourceNode ].
	above ifNil: [ ^ true ].
	(self instanceClassSetOf: above) ifNotNil: [ :classes |
		(classes includes: container class) ifFalse: [ ^ false ] ] ifNil: [ ^ true ].
	segment := above.
	resource := container ] repeat
]

{ #category : 'private' }
HOPUriSpace >> instanceClassSetOf: aSegment [
	"the classes a segment resolves, nil when it resolves none. They are asked for each
	step of a chain, and for a class with many subclasses finding them is not cheap, while
	they do not change once the tree stands"

	^ instanceClassSets 
		at: aSegment 
		ifAbsent: [ 
			| classes |
			classes := aSegment instanceMapClasses ifNotNil: #asSet.
			instanceClassSets at: aSegment put: classes.
			classes ]
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> segmentsForResourceType: aClass [
	"all segments the instances of aClass are canonical at"

	^ behaviorSegments at: aClass
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> segmentForResource: resource andOperation: anOperation [
	^ (self segmentAndMethodForResource: resource andOperation: anOperation) first
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> segmentForResourceRoot: resourceRoot andOperation: anOperation [
	^ (operations at: { resourceRoot. anOperation }) first
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> segmentForResourceType: aClass [ 
	"only for a class that is canonical at one segment: without a resource there is nothing
	to tell several apart"

	| segments |
	segments := self segmentsForResourceType: aClass.
	segments size = 1 ifFalse: [
		^ Error signal: aClass asString , ' is canonical at several segments, ask for the resource' ].
	^ segments first
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> segmentForResourceType: resourceClass andOperation: anOperation [
	| resourceRoot |
	resourceRoot := self segmentForResourceType: resourceClass.
	^ (operations at: { resourceRoot . anOperation }) first
]

{ #category : 'accessing' }
HOPUriSpace >> uriBuilderClass [
	^ HOPUriBuilder
]

{ #category : 'as yet unclassified' }
HOPUriSpace >> zincServerDelegate [ 
	^ HOPServerDelegate new 
]
