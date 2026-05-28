Class {
	#name : 'HOPResourceRoute',
	#superclass : 'Object',
	#instVars : [
		'routeMatch',
		'receiver'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'converting' }
HOPResourceRoute >> asResourceRoute [ 
	^ self 
]

{ #category : 'accessing' }
HOPResourceRoute >> receiver [
	^ receiver ifNil: [ 
		receiver := self resourceOfNode: routeMatch receiverNode ]
]

{ #category : 'as yet unclassified' }
HOPResourceRoute >> resourceOfNode: node [ 
	^ self perform: node resourceSelector 
]

{ #category : 'accessing' }
HOPResourceRoute >> routeMatch: anAGBaseRouteMatch [ 
	routeMatch := anAGBaseRouteMatch
]

{ #category : 'accessing' }
HOPResourceRoute >> variableAt: key [ 
	^ routeMatch variableAt: key 
]
