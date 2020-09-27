Extension { #name : #CPPSNamespace }

{ #category : #'*CPPS-Toolkit-Core' }
CPPSNamespace >> showInArchitecture [

	"Gaëlle has a 'garbage' namespace called :: that should not be displayed in the architecture."

	^ self name ~= '::'
]
