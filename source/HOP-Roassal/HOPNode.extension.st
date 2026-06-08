Extension { #name : 'HOPNode' }

{ #category : '*HOP-Roassal' }
HOPNode >> children [
	^ nodes
]

{ #category : '*HOP-Roassal' }
HOPNode >> displayLabel [
	^ self name 
]

{ #category : '*HOP-Roassal' }
HOPNode >> numberOfChildren [
	^ nodes size 
]
