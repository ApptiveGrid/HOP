Class {
	#name : 'HOPServerDelegate',
	#superclass : 'Object',
	#instVars : [
		'uriSpace'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'as yet unclassified' }
HOPServerDelegate >> dispatchRouteMatch: routeMatch [
	^ routeMatch dispatch  
	
]

{ #category : 'as yet unclassified' }
HOPServerDelegate >> handleRequest: request [ 
	| routeMatch |
	routeMatch := self 
		matchRoute: request
		ifNone: [ :response | ^ response ].
	
	"now we have a route which means that the request does structural 
	fit the URI space. We create a dedicated route handler object to 
	enable complex operations. This delegate is shared between all 
	processes so concurrency needs to be handled in a method cascade"
	^ self dispatchRouteMatch: routeMatch
	
]

{ #category : 'as yet unclassified' }
HOPServerDelegate >> matchRoute: request	ifNone: aBlock [ 
	| routeMatcher |
	"we turn a request into a route. A route is a resolved request URI 
	and method. If the request path does not resolve to a route we can
	give back a 404 immediately. If the route does not resolve to an 
	operation (does not support the HTTP verb) we can signal a method 
	not allowed."
	routeMatcher := self uriSpace newRouteMatcher.
	^ [[ routeMatcher matchRequest: request ]
				on: HOPSegmentNotFound   
				do: [ :err | aBlock value: (self responseNotFound: request)  ] ]
					on: HOPOperationNotFound 
					do: [:error | aBlock cull: (self responseMethodNotAllowed: request)  ].
]

{ #category : 'as yet unclassified' }
HOPServerDelegate >> responseMethodNotAllowed: request [ 
	^ ZnResponse methodNotAllowed: request
]

{ #category : 'as yet unclassified' }
HOPServerDelegate >> responseNotFound: request [ 
	^ ZnResponse notFound: request uri
]

{ #category : 'accessing' }
HOPServerDelegate >> uriSpace [
	^ uriSpace 
]

{ #category : 'accessing' }
HOPServerDelegate >> uriSpace: anObject [

	uriSpace := anObject
]
