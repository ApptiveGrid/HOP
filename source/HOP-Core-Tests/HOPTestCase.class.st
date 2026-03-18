Class {
	#name : 'HOPTestCase',
	#superclass : 'TestCase',
	#category : 'HOP-Core-Tests',
	#package : 'HOP-Core-Tests'
}

{ #category : 'tests' }
HOPTestCase >> baseUri [ 
	^  self subclassResponsibility 
]

{ #category : 'accessing' }
HOPTestCase >> delegate [ 
	^ self uriSpace asZincDelegate
]

{ #category : 'as yet unclassified' }
HOPTestCase >> parseResponse: aZnResponse [ 
	^ NeoJSONReader fromString: aZnResponse contents 
]

{ #category : 'tests' }
HOPTestCase >> uriSpace [ 

	self subclassResponsibility 
]
