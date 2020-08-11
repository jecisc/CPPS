Extension { #name : #MQNavigationOutgoingDirectionStrategy }

{ #category : #'*Famix-Queries' }
MQNavigationOutgoingDirectionStrategy class >> associationsFor: aMooseGroup [
	^ aMooseGroup allEntityTypes flatCollect: [ :class | class allOutgoingAssociationTypesIn: aMooseGroup metamodel ]
]
