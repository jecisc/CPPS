Extension { #name : #MooseProject }

{ #category : #'*CPPS-Architecture' }
MooseProject >> addArchitecture: anArchitecture [
	self architectures add: anArchitecture
]

{ #category : #'*CPPS-Architecture' }
MooseProject >> architectures [
	^ self genericDictionary at: #architectures ifAbsentPut: [ OrderedCollection new ]
]

{ #category : #'*CPPS-Architecture' }
MooseProject >> cleanArchitectures [
	^ self genericDictionary at: #architectures put: OrderedCollection new
]

{ #category : #'*CPPS-Architecture' }
MooseProject >> removeArchitecture: anArchitecture [
	anArchitecture deleteAllChildren.
	^ self architectures remove: anArchitecture
]

{ #category : #'*CPPS-Architecture' }
MooseProject >> removeArchitectureBasedOnTag: aFamixTag [
	self architectures copy
		do: [ :anArchi | 
			(anArchi isTagGenerated and: [ aFamixTag = anArchi tag or: [ aFamixTag isAncestorOf: anArchi tag ] ])
				ifTrue: [ self removeArchitecture: anArchi ] ]
]
