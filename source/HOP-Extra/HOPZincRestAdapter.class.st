Class {
	#name : 'HOPZincRestAdapter',
	#superclass : 'Object',
	#instVars : [
		'routeMatch',
		'restClass'
	],
	#category : 'HOP-Extra',
	#package : 'HOP-Extra'
}

{ #category : 'initialization' }
HOPZincRestAdapter class >> adapt: aClass [
	^ self new 
		restClass: aClass 
]

{ #category : 'adding' }
HOPZincRestAdapter >> addMethodsTo: aHOPSegment [ 
	#(get post put path delete) do: [ :method | 
		(restClass canUnderstand: method) ifTrue: [  
			aHOPSegment @@ (method -> self) ] ]
]

{ #category : 'instance creation' }
HOPZincRestAdapter >> asHOPRouteHandler [
	^ restClass new 
]

{ #category : 'execution' }
HOPZincRestAdapter >> execute [
	^ restClass new 
		request: routeMatch request;
		perform: routeMatch request method asLowercase asSymbol;
		response
]

{ #category : 'as yet unclassified' }
HOPZincRestAdapter >> restClass: aClass [ 
	restClass := aClass 
]

{ #category : 'options' }
HOPZincRestAdapter >> routeMatch: aHOPRouteMatch [ 
	routeMatch := aHOPRouteMatch 
]
