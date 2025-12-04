Extension { #name : 'HOPTreeNode' }

{ #category : '*HOP-Roassal' }
HOPTreeNode >> children [
	^ nodes
]

{ #category : '*HOP-Roassal' }
HOPTreeNode >> displayLabel [
	^ self name 
]

{ #category : '*HOP-Roassal' }
HOPTreeNode >> numberOfChildren [
	^ nodes size 
]
