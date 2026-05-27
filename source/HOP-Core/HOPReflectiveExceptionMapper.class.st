Class {
	#name : 'HOPReflectiveExceptionMapper',
	#superclass : 'Object',
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'visiting' }
HOPReflectiveExceptionMapper >> badRequest: anException [ 

	^ HOPErrorResponse new 
		statusCode: 400;
		exception: anException
		

]

{ #category : 'visiting' }
HOPReflectiveExceptionMapper >> map: anObject [ 
	| clazz selector |
	clazz := anObject class.
	[ 
		selector := (#map, clazz name) asMutator. 
		self respondsTo: selector ] whileFalse: [ 
			clazz := clazz superclass ].
	^ self perform: selector with: anObject.

]

{ #category : 'visiting' }
HOPReflectiveExceptionMapper >> mapObject: exception [ 

	^ (self unhandledException: exception) 
		exceptionType: 'unspecifiedException';
		yourself 
]

{ #category : 'visiting' }
HOPReflectiveExceptionMapper >> mapUnhandledException: exception [ 

	^ (self unhandledException: exception) 
		exceptionType: 'unhandledException';
		yourself 
]

{ #category : 'visiting' }
HOPReflectiveExceptionMapper >> unhandledException: anException [ 

	^ HOPErrorResponse new 
		statusCode: 500;
		exception: anException
		

]
