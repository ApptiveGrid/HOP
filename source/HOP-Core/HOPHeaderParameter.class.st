Class {
	#name : 'HOPHeaderParameter',
	#superclass : 'HOPParameterLocation',
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'reading' }
HOPHeaderParameter >> readFromRequest: aRequest [
	^ parameter read: (aRequest headers at: parameter name ifAbsent: [ ^ nil ])
]
