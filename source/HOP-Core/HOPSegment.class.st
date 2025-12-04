Class {
	#name : 'HOPSegment',
	#superclass : 'HOPTreeNode',
	#instVars : [
		'methods'
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

{ #category : 'services' }
HOPSegment >> addSegment: key routeMatch: routeMatch [
	^ routeMatch addNode: self
]

{ #category : 'adding' }
HOPSegment >> addToHOPNode: aTreeNode [ 
	^ aTreeNode addNode: self 
]

{ #category : 'converting' }
HOPSegment >> asHOPSegment [
	^ self
]

{ #category : 'converting' }
HOPSegment >> asHOPUriSpace [
	^ HOPUriSpace new
"		name: name; 
"		addNode: self root;
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

{ #category : 'testing' }
HOPSegment >> hasMethods [ 
	^ methods notEmpty
]

{ #category : 'initialization' }
HOPSegment >> initialize [ 
	super initialize.
	methods := Dictionary new
]

{ #category : 'as yet unclassified' }
HOPSegment >> initializePresenter [
]

{ #category : 'as yet unclassified' }
HOPSegment >> mergeInto: aNode [
	nodes do: [ :each | 
		aNode addNode: each ].
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
