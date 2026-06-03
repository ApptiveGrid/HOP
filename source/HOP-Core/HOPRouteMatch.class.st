Class {
	#name : 'HOPRouteMatch',
	#superclass : 'Object',
	#instVars : [
		'extraPath',
		'uriSpace',
		'request',
		'handlers',
		'variables',
		'handlerChain',
		'lastVariableSegment',
		'segments',
		'operation'
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
	handlers add: aHOPRequestHandler
]

{ #category : 'adding' }
HOPRouteMatch >> addHandlers: aCollection [ 
	aCollection do: [ :handler |
		self addHandler: handler ]
]

{ #category : 'accessing' }
HOPRouteMatch >> addSegment: aTreeNode [ 
	segments add: aTreeNode 
]

{ #category : 'converting' }
HOPRouteMatch >> asResourceRoute [
	^ HOPResourceRoute new 
		routeMatch: self 
]

{ #category : 'accessing' }
HOPRouteMatch >> call [ 
	^ self operation asHOPRouteHandler
]

{ #category : 'accessing' }
HOPRouteMatch >> extraPath [
	^ extraPath
]

{ #category : 'as yet unclassified' }
HOPRouteMatch >> handle [
	handlerChain := handlers readStream.
	^ self proceed.
]

{ #category : 'testing' }
HOPRouteMatch >> hasExtraPath [
	^ extraPath notNil and: [ extraPath notEmpty  ]
]

{ #category : 'initialization' }
HOPRouteMatch >> initialize [ 
	super initialize.
	variables := Dictionary new.
	segments := OrderedCollection new.
	handlers := OrderedCollection new 
]

{ #category : 'as yet unclassified' }
HOPRouteMatch >> lastSegment [
	^ segments 
		ifNotEmpty: [ segments last ]
		ifEmpty: [ uriSpace ]
]

{ #category : 'accessing' }
HOPRouteMatch >> lastVariableSegment [
	^ lastVariableSegment
]

{ #category : 'accessing' }
HOPRouteMatch >> lastVariableSegment: anObject [

	lastVariableSegment := anObject
]

{ #category : 'as yet unclassified' }
HOPRouteMatch >> matchExtraPathIn: receiver [

	^ (HOPRouteMatcher new 
		uriSpace: uriSpace;
		startReceiver: receiver;
		matchSegments: extraPath)
			request: request;
			yourself 
]

{ #category : 'testing' }
HOPRouteMatch >> matchesScope: aResource [
	lastVariableSegment ifNil: [ ^ false ].
	^ aResource matchesScopeOf: self receiver.
]

{ #category : 'actions' }
HOPRouteMatch >> merge: aRouteMatch [ 
	variables addAll: aRouteMatch variables.
	lastVariableSegment := aRouteMatch receiverNode.
	operation := aRouteMatch operation.

]

{ #category : 'actions' }
HOPRouteMatch >> mergeInto: aRouteMatch [ 
	aRouteMatch merge: self 
]

{ #category : 'instance creation' }
HOPRouteMatch >> newHttpCall [
	^ self operation newHttpCall
]

{ #category : 'accessing' }
HOPRouteMatch >> nodes [
	^ segments
]

{ #category : 'accessing' }
HOPRouteMatch >> operation [
	^ operation ifNil: [ 
		 operation := self lastSegment atMethod: request method ]
]

{ #category : 'accessing' }
HOPRouteMatch >> operation: anObject [

	operation := anObject
]

{ #category : 'accessing' }
HOPRouteMatch >> position [
	^ handlerChain position
]

{ #category : 'accessing' }
HOPRouteMatch >> position: anInteger [ 
	handlerChain position: anInteger 
]

{ #category : 'as yet unclassified' }
HOPRouteMatch >> proceed [

	handlerChain atEnd  
		ifFalse: [ 
			^ handlerChain next asHOPRouteHandler handleRoute: self ].
	 ^ self operation asHOPRouteHandler handleRoute: self
]

{ #category : 'accessing' }
HOPRouteMatch >> receiverNode [

	^ lastVariableSegment
]

{ #category : 'nodes' }
HOPRouteMatch >> receiverSegments [
	^ segments copyUpThrough: self receiverNode
]

{ #category : 'as yet unclassified' }
HOPRouteMatch >> receiverUriPrefix [
	"a request context reflects the whole URI path. When we want to know which 
	is the URI of the receiver we copy up all segments to the receiverNode we
	already have"
	^ ((segments copyUpThrough: lastVariableSegment) 
		collect: [ :each | each segmentIn: self ]) "copyWithFirst: #/"
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

{ #category : 'initialization' }
HOPRouteMatch >> setOperation: aString [ 
	operation := self lastSegment atMethod: aString
]

{ #category : 'as yet unclassified' }
HOPRouteMatch >> startReceiver: aResource [
	lastVariableSegment := uriSpace nodeForResource: aResource
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
