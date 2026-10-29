Class {
	#name : 'HOPResourceRoute',
	#superclass : 'Object',
	#instVars : [
		'routeMatch',
		'receiver',
		'resources',
		'previous'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'converting' }
HOPResourceRoute >> asResourceRoute [ 
	^ self 
]

{ #category : 'accessing' }
HOPResourceRoute >> call [
	^ routeMatch call 
		resourceRoute: self 
]

{ #category : 'initialization' }
HOPResourceRoute >> initialize [ 
	super initialize.
	resources := Dictionary new
]

{ #category : 'as yet unclassified' }
HOPResourceRoute >> matchExtraPath [ 
	| extraReceiver |
	
	extraReceiver := self receiver extraReceiver.
	^ (routeMatch matchExtraPathIn: extraReceiver) asResourceRoute
		previous: self;
		resourceAt: extraReceiver resourceLabel put: extraReceiver;
		yourself
]

{ #category : 'instance creation' }
HOPResourceRoute >> newHttpCall [ 
	^ routeMatch newHttpCall 
		resourceRoute: self 
]

{ #category : 'accessing' }
HOPResourceRoute >> nodes [
	^ routeMatch nodes 
]

{ #category : 'accessing' }
HOPResourceRoute >> previous [
	^ previous
]

{ #category : 'accessing' }
HOPResourceRoute >> previous: aResourceRoute [ 
	previous := aResourceRoute 
]

{ #category : 'accessing' }
HOPResourceRoute >> receiver [
	^ receiver ifNil: [
		receiver := routeMatch receiverNode
			ifNil: [ previous receiver extraReceiver ]
			ifNotNil: [ :node | self resourceOfNode: node ] ]
]

{ #category : 'accessing' }
HOPResourceRoute >> receiverNode [
	^ routeMatch receiverNode
]

{ #category : 'as yet unclassified' }
HOPResourceRoute >> receiverSegments [
	^ routeMatch receiverSegments 
]

{ #category : 'as yet unclassified' }
HOPResourceRoute >> receiverUriPrefix [
	^ routeMatch receiverUriPrefix 
]

{ #category : 'accessing' }
HOPResourceRoute >> request [
	^ routeMatch request 
]

{ #category : 'accessing' }
HOPResourceRoute >> resource [ 
	^ self receiverNode valueIn: self
]

{ #category : 'accessing' }
HOPResourceRoute >> resourceAt: aString ifAbsentPut: aBlock [
	^ resources 
		at: aString 
		ifAbsentPut: aBlock 
]

{ #category : 'accessing' }
HOPResourceRoute >> resourceAt: aString put: anObject [
	resources 
		at: aString 
		put: anObject 
]

{ #category : 'as yet unclassified' }
HOPResourceRoute >> resourceOfNode: node [ 
	^ self perform: node resourceSelector 
]

{ #category : 'accessing' }
HOPResourceRoute >> routeMatch [
	
	^ routeMatch 
]

{ #category : 'accessing' }
HOPResourceRoute >> routeMatch: aRouteMatch [ 
	
	routeMatch := aRouteMatch
]

{ #category : 'initialization' }
HOPResourceRoute >> scopeNodes [
	^ previous 
		ifNotNil: [ previous nodes ]
		ifNil: [ routeMatch nodes ]
]

{ #category : 'initialization' }
HOPResourceRoute >> setOperation: aString [ 
	routeMatch setOperation: aString 
]

{ #category : 'accessing' }
HOPResourceRoute >> uriSpace [
	^ routeMatch uriSpace 
]

{ #category : 'accessing' }
HOPResourceRoute >> variableAt: key [ 
	^ routeMatch variableAt: key 
]
