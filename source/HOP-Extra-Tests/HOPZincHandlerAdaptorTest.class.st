Class {
	#name : 'HOPZincHandlerAdaptorTest',
	#superclass : 'TestCase',
	#category : 'HOP-Extra-Tests',
	#package : 'HOP-Extra-Tests'
}

{ #category : 'tests' }
HOPZincHandlerAdaptorTest >> testAHandlerClassStillGivesAFreshOnePerRequest [
	"Unchanged for every route that names a class, which is all of them today: each request gets
	its own handler and nothing is carried between them."
	| adaptor |
	adaptor := HOPZincHandlerAdaptor new handlerClass: HOPTestZincHandler; yourself.
	self deny: adaptor handler identicalTo: adaptor handler
]

{ #category : 'tests' }
HOPZincHandlerAdaptorTest >> testAPreparedHandlerIsTheOneThatAnswers [
	"The point of taking an object rather than a class: whoever builds the route can prepare the
	handler, and that same prepared object answers the request."
	| handler adaptor request |
	handler := HOPTestZincHandler new answer: 'prepared'; yourself.
	adaptor := HOPZincHandlerAdaptor new handler: handler; yourself.
	request := ZnRequest get: '/anything'.
	self
		assert: (adaptor handleRoute: (HOPRouteMatch new request: request; yourself)) entity contents
		equals: 'prepared'.
	self assert: handler seenRequest identicalTo: request
]
