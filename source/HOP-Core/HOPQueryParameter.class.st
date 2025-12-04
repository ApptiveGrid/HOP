Class {
	#name : 'HOPQueryParameter',
	#superclass : 'HOPParameterLocation',
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'accessing' }
HOPQueryParameter >> readFromRequest: aRequest [
	^ aRequest uri 
		queryAt: self parameterName
		ifPresent: [ :val | self parameterSchema readString: val ].
	
]
