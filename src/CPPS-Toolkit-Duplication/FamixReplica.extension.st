Extension { #name : #FamixReplica }

{ #category : #'*CPPS-Toolkit-Duplication' }
FamixReplica >> positionOfFirstCharacter [

	^ self
		  propertyNamed: #positionOfFirstCharacter
		  ifAbsentPut: [ self entitySourceCode positionOfFirstCharacterOfLine: self startLine ]
]

{ #category : #'*CPPS-Toolkit-Duplication' }
FamixReplica >> positionOfLastCharacter [

	^ self
		  propertyNamed: #positionOfLastCharacter
		  ifAbsentPut: [ self entitySourceCode positionOfLastCharacterOfLine: self endLine ]
]
