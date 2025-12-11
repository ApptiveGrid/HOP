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
HOPRouteHanderWrapperTest >> setUp [ 
	super setUp.
	uriSpace := (HOPUriSpace /+ #first /+ #second) root
]

{ #category : 'tests' }
HOPRouteHanderWrapperTest >> testErrorHandler [
	| response |
	uriSpace / #first @@ (#GET -> (HOPPluggableHandler new block: [:req | Error signal ])).
	uriSpace addHandler: HOPErrorHandlerWrapper new .
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
		errors: ZeroDivide).
	self 
		should: [ uriSpace asZincDelegate handleRequest: (ZnRequest get: #first) ]
		raise: HOPMaximumRetriesExceeded 
]
