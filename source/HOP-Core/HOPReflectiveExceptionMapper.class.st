Class {
	#name : 'HOPReflectiveExceptionMapper',
	#superclass : 'Object',
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

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
HOPReflectiveExceptionMapper >> mapObject: anObject [ 
	anObject pass 
]
