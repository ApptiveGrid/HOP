Class {
	#name : 'HOPRouteMatch',
	#superclass : 'Object',
	#instVars : [
		'nodes',
		'receiverNode',
		'extraPath',
		'uriSpace',
		'operation',
		'request',
		'handlers',
		'variables'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'adding' }
HOPRouteMatch >> addExtraPath: aString [ 
	extraPath ifNil: [ extraPath := OrderedCollection new ].
	extraPath add: aString
]

{ #category : 'adding' }
HOPRouteMatch >> addHandler: aHOPRequestHandler [ 
	| handler |
	handler := aHOPRequestHandler asHOPRouteHandler.
	(handler == aHOPRequestHandler ) 
		ifTrue: [ handler := handler copy ].
	handlers ifNotEmpty: [ 
		handlers last next: handler ].
	handlers add: handler
]

{ #category : 'adding' }
HOPRouteMatch >> addHandlers: aCollection [ 
	aCollection do: [ :handler |
		self addHandler: handler ]
]

{ #category : 'accessing' }
HOPRouteMatch >> addNode: aTreeNode [ 
	nodes add: aTreeNode 
]

{ #category : 'accessing' }
HOPRouteMatch >> call [ 
	^ operation asHOPRouteHandler
		routeMatch: self;
		yourself 
]

{ #category : 'accessing' }
HOPRouteMatch >> extraPath [
	^ extraPath
]

{ #category : 'accessing' }
HOPRouteMatch >> firstHandler [
	^ handlers first 
]

{ #category : 'as yet unclassified' }
HOPRouteMatch >> handle [
	self addHandler: (operation asHOPRouteHandler).
	^ handlers first handleRoute: self
]

{ #category : 'as yet unclassified' }
HOPRouteMatch >> handleRequest [
	^ handlers first handleRequest: request 
]

{ #category : 'accessing' }
HOPRouteMatch >> handler [
	^ handlers 
		inject: operation asHOPRouteHandler
		into: [ :next :handler |
			handler next: next  ]
]

{ #category : 'testing' }
HOPRouteMatch >> hasExtraPath [
	^ extraPath notNil and: [ extraPath notEmpty  ]
]

{ #category : 'initialization' }
HOPRouteMatch >> initialize [ 
	super initialize.
	variables := Dictionary new.
	nodes := OrderedCollection new.
	handlers := OrderedCollection new 
]

{ #category : 'as yet unclassified' }
HOPRouteMatch >> lastSegment [
	^ nodes last
]

{ #category : 'as yet unclassified' }
HOPRouteMatch >> matchExtraPath [ 
	^ HOPRouteMatcher new 
		uriSpace: uriSpace;
		startReceiver: self receiver scope yourself;
		matchSegments: extraPath;
		yourself 
]

{ #category : 'as yet unclassified' }
HOPRouteMatch >> matchNested: aBlock [ 
	aBlock value: self matchExtraPath routeMatch
	
]

{ #category : 'testing' }
HOPRouteMatch >> matchesScope: aResource [
	receiverNode ifNil: [ ^ false ].
	^ aResource matchesScopeOf: self receiver.
]

{ #category : 'actions' }
HOPRouteMatch >> merge: aRouteMatch [ 
	variables addAll: aRouteMatch variables.
	receiverNode := aRouteMatch receiverNode.
	operation := aRouteMatch operation.

]

{ #category : 'actions' }
HOPRouteMatch >> mergeInto: aRouteMatch [ 
	aRouteMatch merge: self 
]

{ #category : 'instance creation' }
HOPRouteMatch >> newHttpCall [
	^ self operation newHttpCall 
		routeMatch: self 
]

{ #category : 'accessing' }
HOPRouteMatch >> nodes [
	^ nodes
]

{ #category : 'accessing' }
HOPRouteMatch >> operation [
	^ operation
]

{ #category : 'accessing' }
HOPRouteMatch >> operation: aString [ 
	operation := aString 
]

{ #category : 'accessing' }
HOPRouteMatch >> receiver [
	^ self resourceOfNode: self receiverNode
]

{ #category : 'accessing' }
HOPRouteMatch >> receiver: aResource [ 
	receiverNode := uriSpace nodeForResource: aResource.
	variables 
		at: receiverNode name
		put: aResource
]

{ #category : 'accessing' }
HOPRouteMatch >> receiverNode [

	^ receiverNode
]

{ #category : 'accessing' }
HOPRouteMatch >> receiverNode: anObject [

	receiverNode := anObject
]

{ #category : 'as yet unclassified' }
HOPRouteMatch >> receiverUriPrefix [
	"a request context reflects the whole URI path. When we want to know which 
	is the URI of the receiver we copy up all segments to the receiverNode we
	already have"
	^ ((nodes copyUpThrough: receiverNode) 
		collect: [ :each | each segmentIn: self ]) copyWithFirst: #/
]

{ #category : 'accessing' }
HOPRouteMatch >> request [
	^ request
]

{ #category : 'accessing' }
HOPRouteMatch >> request: aZnRequest [ 
	request := aZnRequest 
]

{ #category : 'initialization' }
HOPRouteMatch >> resetExtraPath [
	extraPath := nil
]

{ #category : 'accessing' }
HOPRouteMatch >> resource [ 
	^ receiverNode valueIn: self 
]

{ #category : 'as yet unclassified' }
HOPRouteMatch >> resourceOfNode: aNode [ 
	^ self variableAt: aNode name
]

{ #category : 'initialization' }
HOPRouteMatch >> setOperation: aString [ 
	operation := self lastSegment atMethod: aString  
]

{ #category : 'as yet unclassified' }
HOPRouteMatch >> startReceiver: aResource [
	receiverNode := uriSpace nodeForResource: aResource.
	self receiver: aResource.
]

{ #category : 'accessing' }
HOPRouteMatch >> uriSpace [
	^ uriSpace
]

{ #category : 'accessing' }
HOPRouteMatch >> uriSpace: aUriSpace [ 
	uriSpace := aUriSpace 
]

{ #category : 'accessing' }
HOPRouteMatch >> variableAt: key [ 
	^ variables 
		at: key 
		
]

{ #category : 'accessing' }
HOPRouteMatch >> variableAt: key ifAbsent: aBlock [
	^ variables 
		at: key 
		ifAbsent: aBlock
		
]

{ #category : 'accessing' }
HOPRouteMatch >> variableAt: key put: anObject [
	^ variables 
		at: key 
		put: anObject 
]

{ #category : 'accessing' }
HOPRouteMatch >> variables [
	^ variables
]
