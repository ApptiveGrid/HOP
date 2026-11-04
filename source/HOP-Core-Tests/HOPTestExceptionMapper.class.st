"
I map ZeroDivide to a bad request, so a test has an exception with a mapping of its own.
"
Class {
	#name : 'HOPTestExceptionMapper',
	#superclass : 'HOPReflectiveExceptionMapper',
	#category : 'HOP-Core-Tests-TestData',
	#package : 'HOP-Core-Tests',
	#tag : 'TestData'
}

{ #category : 'visiting' }
HOPTestExceptionMapper >> mapZeroDivide: anException [

	^ self badRequest: anException
]
