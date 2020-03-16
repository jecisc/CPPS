Extension { #name : #FamixTNamedEntity }

{ #category : #'*CPPS-Entities' }
FamixTNamedEntity classSide >> named: aString model: aModel [
	^ self new
		mooseModel: aModel;
		name: aString;
		yourself
]
