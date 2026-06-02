Class {
	#name : 'HOPCall',
	#superclass : 'Object',
	#instVars : [
		'resourceRoute'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'instance creation' }
HOPCall class >> asHOPRouteHandler [
	^ self new
]

{ #category : 'execution' }
HOPCall class >> httpParameters [
	^ { } 
]

{ #category : 'instance creation' }
HOPCall class >> newHttpCall [
	^ self new
]

{ #category : 'instance creation' }
HOPCall >> asHOPRouteHandler [
	^ self
]

{ #category : 'execution' }
HOPCall >> execute [ 
	self subclassResponsibility 
]

{ #category : 'public' }
HOPCall >> handleRoute: aRouteMatch [ 
	resourceRoute := aRouteMatch.
	
	^ self execute 
]

{ #category : 'accessing' }
HOPCall >> request [
	^ resourceRoute request 
]

{ #category : 'accessing' }
HOPCall >> resourceRoute: anObject [

	resourceRoute := anObject
]

{ #category : 'accessing' }
HOPCall >> routeMatch [

	^ resourceRoute
]

{ #category : 'accessing' }
HOPCall >> routeMatch: anObject [
self halt.
	resourceRoute := anObject
]
