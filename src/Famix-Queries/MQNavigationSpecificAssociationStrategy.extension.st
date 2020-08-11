Extension { #name : #MQNavigationSpecificAssociationStrategy }

{ #category : #'*Famix-Queries' }
MQNavigationSpecificAssociationStrategy >> displayName [
	^ association englishName
]

{ #category : #'*Famix-Queries' }
MQNavigationSpecificAssociationStrategy >> hasAssociation: anAssociation [
	^ association = anAssociation
]
