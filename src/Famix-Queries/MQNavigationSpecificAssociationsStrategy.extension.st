Extension { #name : #MQNavigationSpecificAssociationsStrategy }

{ #category : #'*Famix-Queries' }
MQNavigationSpecificAssociationsStrategy >> displayName [
	^ ', ' join: (associations collect: #englishName)
]

{ #category : #'*Famix-Queries' }
MQNavigationSpecificAssociationsStrategy >> hasAssociation: anAssociation [
	^ associations includes: anAssociation
]
