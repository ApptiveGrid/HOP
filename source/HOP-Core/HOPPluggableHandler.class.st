Class {
	#name : 'HOPPluggableHandler',
	#superclass : 'Object',
	#instVars : [
		'block'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'converting' }
HOPPluggableHandler >> asHOPRouteHandler [
	^ self 
]

{ #category : 'accessing' }
HOPPluggableHandler >> block [

	^ block
]

{ #category : 'accessing' }
HOPPluggableHandler >> block: anObject [

	block := anObject
]

{ #category : 'public' }
HOPPluggableHandler >> handleRequest: request [ 
	^ block value: request
]

{ #category : 'public' }
HOPPluggableHandler >> handleRoute: routeMatch [ 
	^ block value: routeMatch
]
