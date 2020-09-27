Extension { #name : #FamixTag }

{ #category : #'*CPPS-Toolkit-Core' }
FamixTag >> iconComponent [

	"I should return a ListIconComponent corresponding to the entity."

	^ CPPSTagListIconComponent
		  initial: self kindAbbreviation
		  helpText: self multilanguageDisplayName
]
