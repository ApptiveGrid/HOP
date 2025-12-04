Extension { #name : 'ZnRestCall' }

{ #category : '*HOP-Extra' }
ZnRestCall class >> asHOPAdapter [

	^ HOPZincRestAdapter new
		  restClass: self;
		  yourself
]
