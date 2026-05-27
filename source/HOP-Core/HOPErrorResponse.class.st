Class {
	#name : 'HOPErrorResponse',
	#superclass : 'Object',
	#instVars : [
		'statusCode',
		'exceptionType',
		'exception'
	],
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'accessing' }
HOPErrorResponse >> exception [

	^ exception
]

{ #category : 'accessing' }
HOPErrorResponse >> exception: anObject [

	exception := anObject
]

{ #category : 'accessing' }
HOPErrorResponse >> exceptionType [

	^ exceptionType ifNil: [ 
		exception hopExceptionType ]
]

{ #category : 'accessing' }
HOPErrorResponse >> exceptionType: anObject [

	exceptionType := anObject
]

{ #category : 'as yet unclassified' }
HOPErrorResponse >> hopMessageObject [ 
	^ exception hopMessageObject 
]

{ #category : 'accessing' }
HOPErrorResponse >> statusCode [

	^ statusCode
]

{ #category : 'accessing' }
HOPErrorResponse >> statusCode: anObject [

	statusCode := anObject
]
