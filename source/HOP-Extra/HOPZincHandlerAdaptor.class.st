Class {
	#name : 'HOPZincHandlerAdaptor',
	#superclass : 'HOPCatchAllSegment',
	#instVars : [
		'routeMatch',
		'handlerClass'
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
	^ handlerClass new handleRequest: routeMatch request 
]

{ #category : 'public' }
HOPZincHandlerAdaptor >> handleRouteMatch: aRouteMatch [ 
	^ handlerClass new handleRequest: aRouteMatch request 
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
