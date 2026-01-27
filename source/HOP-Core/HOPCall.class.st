Class {
	#name : 'HOPCall',
	#superclass : 'Object',
	#instVars : [
		'routeMatch'
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
	routeMatch := aRouteMatch.
	
	^ self execute 
]

{ #category : 'accessing' }
HOPCall >> request [
	^ routeMatch request 
]

{ #category : 'accessing' }
HOPCall >> routeMatch [

	^ routeMatch
]

{ #category : 'accessing' }
HOPCall >> routeMatch: anObject [

	routeMatch := anObject
]
