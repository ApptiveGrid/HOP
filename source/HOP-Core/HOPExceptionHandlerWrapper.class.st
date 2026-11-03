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
HOPExceptionHandlerWrapper >> checkDebugModeFor: exception response: aResponse routeMatch: aRouteMatch [
	"an exception the mapper answers with a status of its own is an answer to the client, not a
	failure of the server, so in debug mode only what is left as an internal server error goes
	to the debugger"
	aRouteMatch request server ifNotNil: [ :server |
		(server debugMode and: [ aResponse code = ZnStatusLine internalServerError code ])
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
HOPExceptionHandlerWrapper >> exceptionMapper: anObject [

	exceptionMapper := anObject
]

{ #category : 'accessing' }
HOPExceptionHandlerWrapper >> formatter [ 
	^ formatter ifNil: [ 
		formatter := self defaultFormatter  ]
]

{ #category : 'accessing' }
HOPExceptionHandlerWrapper >> formatter: anObject [

	formatter := anObject
]

{ #category : 'as yet unclassified' }
HOPExceptionHandlerWrapper >> handleException: exception routeMatch: aRouteMatch [
	| errorResponse response |
	errorResponse := self exceptionMapper map: exception.
	response := (errorResponse class == ZnResponse)
		ifTrue: [ errorResponse ]
		ifFalse: [ 
			errorResponse asZnResponse
				entity: (self formatter format: errorResponse);
				yourself ].
	self 
		checkDebugModeFor: exception 
		response: response
		routeMatch: aRouteMatch.
	^ response
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
HOPExceptionHandlerWrapper >> noDebugModeFor: exception routeMatch: aRouteMatch [
	"mimick what zinc does in case of error."
	ZnServerHandlerErrorEvent new
		exception: exception;
		emit 

]
