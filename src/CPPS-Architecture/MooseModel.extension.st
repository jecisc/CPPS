Extension { #name : #MooseModel }

{ #category : #'*CPPS-Architecture' }
MooseModel >> createArchitecture [
	| architecture |
	"add a new architecture first"
	architecture := CPPSArchitectureLayer newRoot
		grid;
		yourself.	"If the group has root folder, we start from it"
	self allRootContainers
		select: #showInArchitecture
		thenDo: [ :each | architecture addChild: each asArchitecturalEntity ].	"otherwise we take root packages"
	architecture hasChildren ifFalse: [ (self allModelPackages select: #isRoot) do: [ :each | architecture addChild: each asArchitecturalEntity ] ].
	^ architecture
]
