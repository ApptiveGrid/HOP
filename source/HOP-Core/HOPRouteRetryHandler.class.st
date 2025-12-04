Class {
	#name : 'HOPRouteRetryHandler',
	#superclass : 'HOPRouteHandlerWrapper',
	#instVars : [
		'numberOfRetries',
		'errors'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'accessing' }
HOPRouteRetryHandler >> errors: anObject [

	errors := anObject
]

{ #category : 'public' }
HOPRouteRetryHandler >> handleRouteMatch: aRouteMatch [
	^ self handleRouteMatchWithRetries: aRouteMatch
]

{ #category : 'public' }
HOPRouteRetryHandler >> handleRouteMatchWithRetries: aRouteMatch [
	| counter |
	"execute request with retries. Conflicts are a timing problem. If we get a 
	conflict error we can retry a bit later and see if the request can succeed
	the next time. But just try numberOfRetriess times and then give up"
	counter := 1.
	[ counter <= numberOfRetries ] whileTrue: [  
		[ ^ super handleRouteMatch: aRouteMatch ]
			on: errors 
			do: [ :error | 
				(counter < numberOfRetries) ifFalse: [ 
					^ self retriesExceededForRequest: aRouteMatch withError: error ].
				self logConflict: counter. 
				counter := counter + 1.
				self waitBeforeRetrying ] ]
]

{ #category : 'public' }
HOPRouteRetryHandler >> logConflict: counter [
]

{ #category : 'accessing' }
HOPRouteRetryHandler >> numberOfRetries: anObject [

	numberOfRetries := anObject
]

{ #category : 'public' }
HOPRouteRetryHandler >> retriesExceededForRequest: request withError: error [ 
	HOPMaximumRetriesExceeded signal: ('request retries exceeded ', numberOfRetries asString, ' for request ', request printString)
]

{ #category : 'public' }
HOPRouteRetryHandler >> waitBeforeRetrying [
	(100 + 100 atRandom) milliSeconds wait
]

{ #category : 'error handling' }
HOPRouteRetryHandler >> wrongMethod: request [
	^ self 
		errorResponse: request 
		code: 405 
		message: 'Wrong HTTP method'
]
