Extension { #name : 'Exception' }

{ #category : '*HOP-Core' }
Exception >> hopExceptionType [ 
	^ self class name 
]

{ #category : '*HOP-Core' }
Exception >> hopMessageObject [
	^ self messageText 
]
