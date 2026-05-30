Class {
	#name : 'HOPResourceRoute',
	#superclass : 'Object',
	#instVars : [
		'routeMatch',
		'receiver',
		'resources'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'converting' }
HOPResourceRoute >> asResourceRoute [ 
	^ self 
]

{ #category : 'initialization' }
HOPResourceRoute >> initialize [ 
	super initialize.
	resources := Dictionary new
]

{ #category : 'as yet unclassified' }
HOPResourceRoute >> matchExtraPath [ 
	| scopedReceiver |
	
	scopedReceiver := self receiver scope.
	^ (routeMatch matchExtraPathIn: scopedReceiver) asResourceRoute
			resourceAt: scopedReceiver resourceLabel put: scopedReceiver;
			yourself
]

{ #category : 'testing' }
HOPResourceRoute >> matchesScope: aResource [
	routeMatch lastVariableSegment ifNil: [ ^ false ].
	^ aResource matchesScopeOf: self receiver.
]

{ #category : 'instance creation' }
HOPResourceRoute >> newHttpCall [ 
	^ routeMatch newHttpCall 
		routeMatch: self 
]

{ #category : 'as yet unclassified' }
HOPResourceRoute >> nodeMatchingScope: aResource [

	(aResource isKindOf: AGUser) ifTrue: [ "we try to match any resource 'below' the root user.
		if it comes to the user resource itself, we do not match existing node and rebuild the full uri instead.
		because we dont want to generate uris in the shape /a/userid/spaces/space/id/..."
		^ nil ].
	routeMatch nodes reverse do: [ :eachNode |
		(eachNode matchesScope: aResource in: self) ifTrue: [^ eachNode].
		 ].
	^ nil
]

{ #category : 'accessing' }
HOPResourceRoute >> nodes [
	^ routeMatch nodes 
]

{ #category : 'accessing' }
HOPResourceRoute >> receiver [
	^ receiver ifNil: [ 
		receiver := self resourceOfNode: routeMatch receiverNode ]
]

{ #category : 'accessing' }
HOPResourceRoute >> receiverNode [
	^ routeMatch receiverNode
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
HOPResourceRoute >> routeMatch: anAGBaseRouteMatch [ 
	routeMatch := anAGBaseRouteMatch
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
