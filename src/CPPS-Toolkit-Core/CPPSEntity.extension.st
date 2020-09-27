Extension { #name : #CPPSEntity }

{ #category : #'*CPPS-Toolkit-Core' }
CPPSEntity >> iconComponent [

	"I should return a ListIconComponent corresponding to the entity."

	^ (CPPSListIconComponent
		   initial: self kindAbbreviation
		   helpText: self multilanguageDisplayName)
		  entityToTag: self;
		  yourself
]
