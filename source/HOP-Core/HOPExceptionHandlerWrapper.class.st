Class {
	#name : 'HOPExceptionHandlerWrapper',
	#superclass : 'HOPRouteHandlerWrapper',
	#instVars : [
		'exceptionMapper',
		'formatter'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'as yet unclassified' }
HOPExceptionHandlerWrapper >> checkDebugModeFor: exception routeMatch: aRouteMatch [
	aRouteMatch request server ifNotNil: [ :server |
		server debugMode
			ifTrue: [ self debugModeFor: exception routeMatch: aRouteMatch ]
			ifFalse: [  self noDebugModeFor: exception routeMatch: aRouteMatch ] ].

]

{ #category : 'as yet unclassified' }
HOPExceptionHandlerWrapper >> debugModeFor: exception routeMatch: aRouteMatch [
	exception pass
]

{ #category : 'as yet unclassified' }
HOPExceptionHandlerWrapper >> defaultExceptionMapper [
	^ HOPReflectiveExceptionMapper new 
]

{ #category : 'accessing' }
HOPExceptionHandlerWrapper >> defaultFormatter [
	^ HOPJsonResponseFormatter new 
]

{ #category : 'as yet unclassified' }
HOPExceptionHandlerWrapper >> exceptionMapper [
	^ exceptionMapper ifNil: [ 
		exceptionMapper := self defaultExceptionMapper ]
]

{ #category : 'accessing' }
HOPExceptionHandlerWrapper >> formatter [ 
	^ formatter ifNil: [ 
		formatter := self defaultFormatter  ]
]

{ #category : 'as yet unclassified' }
HOPExceptionHandlerWrapper >> handleException: exception routeMatch: aRouteMatch [
	| errorResponse |
	self 
		checkDebugModeFor: exception 
		routeMatch: aRouteMatch.
	errorResponse := self exceptionMapper map: exception.
	^ (self httpErrorResponse: errorResponse)
		entity: (self formatter format: errorResponse);
		yourself 
]

{ #category : 'as yet unclassified' }
HOPExceptionHandlerWrapper >> handleRoute: aRouteMatch [
	^ [ super handleRoute: aRouteMatch ]
		on: Exception
		do: [ :exception | 
			self 
				handleException: exception 
				routeMatch: aRouteMatch ]
]

{ #category : 'as yet unclassified' }
HOPExceptionHandlerWrapper >> httpErrorResponse: responseObject [ 
	^ ZnResponse new 
		statusLine: (ZnStatusLine code: responseObject statusCode);
		headers: ZnHeaders defaultResponseHeaders;
		yourself
]

{ #category : 'as yet unclassified' }
HOPExceptionHandlerWrapper >> noDebugModeFor: exception routeMatch: aRouteMatch [
	"mimick what zinc does in case of error."
	ZnServerHandlerErrorEvent new
		exception: exception;
		emit 

]
