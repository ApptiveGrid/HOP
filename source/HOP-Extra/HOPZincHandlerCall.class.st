Class {
	#name : 'HOPZincHandlerCall',
	#superclass : 'HOPCall',
	#instVars : [
		'handler'
	],
	#category : 'HOP-Extra',
	#package : 'HOP-Extra'
}

{ #category : 'execution' }
HOPZincHandlerCall >> execute [
	^ handler handleRequest: self request
]

{ #category : 'accessing' }
HOPZincHandlerCall >> handler: anObject [
	"Anything that answers handleRequest: with a ZnResponse. Carrying the handler itself rather
	than its class is the point: it can be configured where the route is built, which is where
	the deployment knows what it wants. HOPZincHandlerAdaptor cannot - it says handlerClass new
	and leaves nobody a moment to say anything about it."
	handler := anObject
]
