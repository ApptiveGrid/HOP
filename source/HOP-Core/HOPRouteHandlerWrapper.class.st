Class {
	#name : 'HOPRouteHandlerWrapper',
	#superclass : 'Object',
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'instance creation' }
HOPRouteHandlerWrapper class >> asHOPRouteHandler [
	^ self new 
]

{ #category : 'instance creation' }
HOPRouteHandlerWrapper >> asHOPRouteHandler [
	^ self
]

{ #category : 'as yet unclassified' }
HOPRouteHandlerWrapper >> handleRoute: aMatch [ 
	^ aMatch proceed 
]
