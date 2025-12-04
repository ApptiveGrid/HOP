Class {
	#name : 'HOPRouteHandlerWrapper',
	#superclass : 'Object',
	#instVars : [
		'next'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'instance creation' }
HOPRouteHandlerWrapper class >> asHOPRouteHandler [
	^ self new 
]

{ #category : 'instance creation' }
HOPRouteHandlerWrapper >> asHOPRouteHandler [
	^ self 
]

{ #category : 'as yet unclassified' }
HOPRouteHandlerWrapper >> handleRouteMatch: aMatch [ 
	^ next handleRouteMatch: aMatch 
]

{ #category : 'accessing' }
HOPRouteHandlerWrapper >> next [

	^ next
]

{ #category : 'accessing' }
HOPRouteHandlerWrapper >> next: aHOPHandler [ 
	next ifNotNil: [ 
		^ next next: aHOPHandler ].
	next := aHOPHandler
]
