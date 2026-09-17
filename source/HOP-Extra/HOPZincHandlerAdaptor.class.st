Class {
	#name : 'HOPZincHandlerAdaptor',
	#superclass : 'HOPCatchAllSegment',
	#instVars : [
		'routeMatch',
		'handlerClass',
		'handler'
	],
	#category : 'HOP-Extra',
	#package : 'HOP-Extra'
}

{ #category : 'execution' }
HOPZincHandlerAdaptor class >> httpParameters [
	^ {  }
]

{ #category : 'instance creation' }
HOPZincHandlerAdaptor >> asHOPRouteHandler [
	^ self
]

{ #category : 'accessing' }
HOPZincHandlerAdaptor >> atMethod: aString ifAbsent: aBlock [
	^ self 
]

{ #category : 'execution' }
HOPZincHandlerAdaptor >> execute [
	^ self handler handleRequest: routeMatch request
]

{ #category : 'accessing' }
HOPZincHandlerAdaptor >> handler [
	"A handler given as an object is used as it is; given as a class, a fresh one per request."
	^ handler ifNil: [ handlerClass new ]
]

{ #category : 'accessing' }
HOPZincHandlerAdaptor >> handler: anObject [
	"Anything that answers handleRequest: with a ZnResponse. Naming the class instead leaves
	nobody a moment to configure it - the object is born inside execute and used in the same
	line, so a handler that has to be told something cannot be told anything."
	handler := anObject
]

{ #category : 'public' }
HOPZincHandlerAdaptor >> handleRoute: aRouteMatch [ 
	^ self handler handleRequest: aRouteMatch request
]

{ #category : 'accessing' }
HOPZincHandlerAdaptor >> handlerClass: aClass [ 
	handlerClass := aClass
]

{ #category : 'testing' }
HOPZincHandlerAdaptor >> matches: aString [ 
	^ name = aString 
]

{ #category : 'options' }
HOPZincHandlerAdaptor >> routeMatch: aHOPRouteMatch [ 

	routeMatch := aHOPRouteMatch 
]
