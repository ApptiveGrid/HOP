Class {
	#name : 'HOPRouteHanderWrapperTest',
	#superclass : 'TestCase',
	#instVars : [
		'uriSpace'
	],
	#category : 'HOP-Core-Tests-Tests',
	#package : 'HOP-Core-Tests',
	#tag : 'Tests'
}

{ #category : 'running' }
HOPRouteHanderWrapperTest >> inDebugModeDo: aBlock [
	"a request in debug mode, as a server started with debugMode: true handles it"
	^ ZnCurrentServer
		value: ((ZnServer on: 0)
			debugMode: true;
			yourself)
		during: aBlock
]

{ #category : 'running' }
HOPRouteHanderWrapperTest >> setUp [ 
	super setUp.
	uriSpace := (HOPUriSpace /+ #first /+ #second) root
]

{ #category : 'tests' }
HOPRouteHanderWrapperTest >> testErrorHandler [
	| response |
	uriSpace / #first @@ (#GET -> (HOPPluggableHandler new block: [:req | Error signal ])).
	uriSpace addHandler: HOPExceptionHandlerWrapper new .
	response := uriSpace asZincDelegate handleRequest: (ZnRequest get: #first).
	self assert: response status equals: 500
]

{ #category : 'tests' }
HOPRouteHanderWrapperTest >> testRetryHandler [
	uriSpace / #first @@ (#GET -> (HOPPluggableHandler new block: [:req | #bar ])).
	uriSpace addHandler: (HOPRouteRetryHandler new	
		numberOfRetries: 2;
		errors: ZeroDivide).
	self 
		assert: (uriSpace asZincDelegate handleRequest: (ZnRequest get: #first)) equals: #bar
]

{ #category : 'tests' }
HOPRouteHanderWrapperTest >> testRetryHandlerExceeded [
	uriSpace / #first @@ (#GET -> (HOPPluggableHandler new block: [:req | 1/0 ])).
	uriSpace addHandler: (HOPRouteRetryHandler new	
		numberOfRetries: 2;
		errors: ZeroDivide);
		addHandler: HOPNoOpHandlerWrapper .
	self 
		should: [ uriSpace asZincDelegate handleRequest: (ZnRequest get: #first) ]
		raise: HOPMaximumRetriesExceeded 
]

{ #category : 'tests' }
HOPRouteHanderWrapperTest >> testHandlerOfASegmentLeavesItsSiblingsAlone [
	| other |
	other := uriSpace /+ #other.
	other @@ (#GET -> (HOPPluggableHandler new block: [ :req | Error signal ])).
	(uriSpace / #first) addHandler: HOPExceptionHandlerWrapper new.
	self
		should: [ uriSpace asZincDelegate handleRequest: (ZnRequest get: #other) ]
		raise: Error
]

{ #category : 'tests' }
HOPRouteHanderWrapperTest >> testHandlerOfASegmentWrapsItsChildren [
	| response |
	uriSpace / #first / #second @@ (#GET -> (HOPPluggableHandler new block: [ :req | Error signal ])).
	(uriSpace / #first) addHandler: HOPExceptionHandlerWrapper new.
	response := uriSpace asZincDelegate handleRequest: (ZnRequest get: '/first/second').
	self assert: response status equals: 500
]

{ #category : 'tests' }
HOPRouteHanderWrapperTest >> testHandlerOfASegmentWrapsItsOwnMethod [
	"a segment that carries handlers answers a method on its own path, it is not only a
	prefix for the segments below it"
	| response |
	uriSpace / #first @@ (#GET -> (HOPPluggableHandler new block: [ :req | Error signal ])).
	(uriSpace / #first) addHandler: HOPExceptionHandlerWrapper new.
	response := uriSpace asZincDelegate handleRequest: (ZnRequest get: #first).
	self assert: response status equals: 500
]

{ #category : 'tests' }
HOPRouteHanderWrapperTest >> testInDebugModeAMappedExceptionIsAnswered [
	"an exception with a mapping of its own is an answer to the client, so debug mode answers it
	as well instead of opening a debugger"
	| response |
	uriSpace / #first @@ (#GET -> (HOPPluggableHandler new block: [ :req | 1 / 0 ])).
	uriSpace addHandler: (HOPExceptionHandlerWrapper new
		exceptionMapper: HOPTestExceptionMapper new;
		yourself).
	response := self inDebugModeDo: [
		uriSpace asZincDelegate handleRequest: (ZnRequest get: #first) ].
	self assert: response status equals: 400
]

{ #category : 'tests' }
HOPRouteHanderWrapperTest >> testInDebugModeAnUnmappedExceptionIsPassed [
	"what the mapper leaves as an internal server error goes on to the debugger"
	uriSpace / #first @@ (#GET -> (HOPPluggableHandler new block: [ :req | Error signal: 'unmapped' ])).
	uriSpace addHandler: (HOPExceptionHandlerWrapper new
		exceptionMapper: HOPTestExceptionMapper new;
		yourself).
	self
		should: [ self inDebugModeDo: [
			uriSpace asZincDelegate handleRequest: (ZnRequest get: #first) ] ]
		raise: Error
		withExceptionDo: [ :error | self assert: error messageText equals: 'unmapped' ]
]
