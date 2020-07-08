Extension { #name : #MooseProject }

{ #category : #'*CPPS-Entities' }
MooseProject >> tagModel [
	^ self genericDictionary at: #tagModel ifAbsentPut: [ FamixTagModel new ]
]

{ #category : #'*CPPS-Entities' }
MooseProject >> tagModel: aModel [
	^ self genericDictionary at: #tagModel put: aModel
]

{ #category : #'*CPPS-Entities' }
MooseProject >> tags [
	^ self tagModel tags
]
