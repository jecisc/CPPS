Extension { #name : #MooseEntity }

{ #category : #'*CPPS-Entities' }
MooseEntity >> multilanguageDisplayName [
	^ self class multilanguageDisplayName
]

{ #category : #'*CPPS-Entities' }
MooseEntity class >> multilanguageDisplayName [
	^ self englishName french: self frenchName
]
