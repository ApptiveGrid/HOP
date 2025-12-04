Extension { #name : 'BlockClosure' }

{ #category : '*HOP-Core' }
BlockClosure >> asHOPSegment [
	^ HOPPluggableSegment new 
		name: self argumentNames first;
		block: self;
		yourself 
]
