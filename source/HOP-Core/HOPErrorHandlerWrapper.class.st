Class {
	#name : 'HOPErrorHandlerWrapper',
	#superclass : 'HOPRouteHandlerWrapper',
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'public' }
HOPErrorHandlerWrapper >> errorResponse: request code: code message: message [
	| statusLine text |
	statusLine := ZnStatusLine code: code.
	text := String streamContents: [ :stream | 
		stream << message; space; nextPut: $[; print: code; space; << statusLine reason; nextPut: $]; crlf ].
	^ ZnResponse new
		statusLine: statusLine;
		headers: ZnHeaders defaultResponseHeaders;
		entity: (ZnEntity with: text);
		yourself
]

{ #category : 'public' }
HOPErrorHandlerWrapper >> handleException: exception request: request [
	request server 
		ifNotNil: [ :server |
			request server debugMode
				ifTrue: [ ^ exception pass ]
				ifFalse: [  ZnServerHandlerErrorEvent new
					exception: exception;
					emit ] ].

	^ self serverError: request exception: exception
]

{ #category : 'public' }
HOPErrorHandlerWrapper >> handleRoute: aRouteMatch [
	^ [ super handleRoute: aRouteMatch ]
		on: Error
		do: [ :exception | 
			self 
				handleException: exception 
				request: aRouteMatch request ]
]

{ #category : 'public' }
HOPErrorHandlerWrapper >> serverError: request exception: exception [

	^ self 
		errorResponse: request 
		code: 500 
		message: exception asString
]
