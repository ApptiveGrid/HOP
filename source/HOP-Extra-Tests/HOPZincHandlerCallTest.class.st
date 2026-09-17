Class {
	#name : 'HOPZincHandlerCallTest',
	#superclass : 'TestCase',
	#category : 'HOP-Extra-Tests',
	#package : 'HOP-Extra-Tests'
}

{ #category : 'tests' }
HOPZincHandlerCallTest >> testTheConfiguredHandlerIsTheOneThatAnswers [
	"The point of carrying the handler rather than its class: whoever builds the route can
	prepare it, and that same prepared object answers the request."
	| handler call request |
	handler := HOPTestZincHandler new answer: 'prepared'; yourself.
	call := HOPZincHandlerCall new handler: handler; yourself.
	request := ZnRequest get: '/anything'.
	self
		assert: (call handleRoute: (HOPRouteMatch new request: request; yourself)) entity contents
		equals: 'prepared'.
	self assert: handler seenRequest identicalTo: request
]

{ #category : 'tests' }
HOPZincHandlerCallTest >> testACallAnswersItselfAsRouteHandler [
	"A prepared instance goes into the route as it is - that is what makes it configurable."
	| call |
	call := HOPZincHandlerCall new.
	self assert: call asHOPRouteHandler identicalTo: call
]
