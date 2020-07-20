Extension { #name : #FamixTag }

{ #category : #'*CPPS-Architecture' }
FamixTag >> asArchitecturalEntity [
	^ (CPPSArchitectureLayer named: self name)
		children: (self subTags collect: #asArchitecturalEntity);
		modelLink: self;
		yourself
]

{ #category : #'*CPPS-Architecture' }
FamixTag >> entity [
	"This method is designed for the polymorphic with SYNArchitectureFAMIXLink"

	^ self
]

{ #category : #'*CPPS-Architecture' }
FamixTag >> isAssigned [
	^ true
]
