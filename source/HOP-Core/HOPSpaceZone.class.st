"
I am what is left of the space zone. Handlers belong to every segment now (see HOPSegment>>addHandler:), so a zone is a named segment like any other. I stay until the services have stopped creating me, then I go.
"
Class {
	#name : 'HOPSpaceZone',
	#superclass : 'HOPNamedSegment',
	#category : 'HOP-Core',
	#package : 'HOP-Core'
}

{ #category : 'testing' }
HOPSpaceZone class >> isDeprecated [
	^ true
]
