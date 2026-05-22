Class {
	#name : 'HOPNoOpHandlerWrapper',
	#superclass : 'HOPRouteHandlerWrapper',
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'as yet unclassified' }
HOPNoOpHandlerWrapper >> handleRoute: aRouteMatch [ 
	^ super handleRoute: aRouteMatch 
]
