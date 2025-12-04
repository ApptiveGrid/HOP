Class {
	#name : 'HOPTestCall',
	#superclass : 'Object',
	#instVars : [
		'route',
		'routeMatch'
	],
	#category : 'HOP-Core-Tests-TestData',
	#package : 'HOP-Core-Tests',
	#tag : 'TestData'
}

{ #category : 'converting' }
HOPTestCall >> asHOPRouteHandler [
	^ self 
]

{ #category : 'execution' }
HOPTestCall >> execute [ 
	^ ZnResponse ok: nil 
]

{ #category : 'public' }
HOPTestCall >> handleRouteMatch: aRouteMatch [
	routeMatch := aRouteMatch.
	^ self execute 
]

{ #category : 'options' }
HOPTestCall >> routeMatch: aHOPRoute [ 
	routeMatch := aHOPRoute request 
]
