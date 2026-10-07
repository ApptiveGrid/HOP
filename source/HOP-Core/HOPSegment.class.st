Class {
	#name : 'HOPSegment',
	#superclass : 'HOPNode',
	#instVars : [
		'methods',
		'handlers'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'testing' }
HOPSegment class >> isAbstract [ 
	^ self == HOPSegment 
]

{ #category : 'methods' }
HOPSegment >> @@ anAssociation [ 
	anAssociation addMethodsTo: self
]

{ #category : 'adding' }
HOPSegment >> addHandler: aHandler [
	handlers add: aHandler
]

{ #category : 'services' }
HOPSegment >> addSegment: key routeMatch: routeMatch [
	"the handlers of a segment wrap everything that is reached through it, the
	methods of the segment itself included"
	routeMatch
		addSegment: self;
		addHandlers: handlers
]

{ #category : 'adding' }
HOPSegment >> addToHOPNode: aTreeNode [ 
	^ aTreeNode addSegment: self 
]

{ #category : 'converting' }
HOPSegment >> asHOPSegment [
	^ self
]

{ #category : 'converting' }
HOPSegment >> asHOPUriSpace [
	^ HOPUriSpace new
"		name: name; 
"		addSegment: self root;
		yourself 
]

{ #category : 'accessing' }
HOPSegment >> atMethod: aString [
	
	^ self  
		atMethod: aString asLowercase 
		ifAbsent: [ HOPOperationNotFound signal: 'no operation for ', aString asString, ' found'  ]
]

{ #category : 'accessing' }
HOPSegment >> atMethod: aString ifAbsent: aBlock [ 
	^ methods 
		at: aString 
		ifAbsent: aBlock
]

{ #category : 'accessing' }
HOPSegment >> atMethod: aString put: anObject [
		
		^ methods 
		at: aString
		put: anObject 
]

{ #category : 'accessing' }
HOPSegment >> handlers [
	^ handlers
]

{ #category : 'testing' }
HOPSegment >> hasHandlers [
	^ handlers notEmpty
]

{ #category : 'testing' }
HOPSegment >> hasMethods [ 
	^ methods notEmpty
]

{ #category : 'initialization' }
HOPSegment >> initialize [ 
	super initialize.
	methods := Dictionary new.
	handlers := OrderedCollection new
]

{ #category : 'as yet unclassified' }
HOPSegment >> initializePresenter [
]

{ #category : 'as yet unclassified' }
HOPSegment >> mergeInto: aNode [
	super mergeInto: aNode.
	methods ifNotEmpty: [ Error signal: 'There should not be empty methods in PathTreeNode' ]
]

{ #category : 'accessing' }
HOPSegment >> methods [

	^ methods
]

{ #category : 'accessing' }
HOPSegment >> priority [ 
	self subclassResponsibility 
]
