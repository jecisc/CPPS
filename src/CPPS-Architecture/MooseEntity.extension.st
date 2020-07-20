Extension { #name : #MooseEntity }

{ #category : #'*CPPS-Architecture' }
MooseEntity >> asArchitectureComponent [
	^ CPPSArchitectureComponent new
		name: self name;
		linkTo: self;
		yourself
]

{ #category : #'*CPPS-Architecture' }
MooseEntity >> includesAnyTag: aCollection [
	^ self tags anySatisfy: [ :aTag | aCollection includes: aTag ]
]

{ #category : #'*CPPS-Architecture' }
MooseEntity >> isArchitecturalElement [
	^ false
]

{ #category : #'*CPPS-Architecture' }
MooseEntity >> isArchitecturalLayer [
	^ false
]
