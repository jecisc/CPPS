Extension { #name : #CPPSContainerEntity }

{ #category : #'*CPPS-Architecture' }
CPPSContainerEntity >> asArchitecturalEntity [
	| rootLayer |
	rootLayer := (CPPSArchitectureLayer named: self name linkedTo: self)
		grid;
		yourself.
	(self children select: #showInArchitecture) do: [ :aChild | rootLayer addChild: aChild asArchitecturalEntity ].
	^ rootLayer
]
