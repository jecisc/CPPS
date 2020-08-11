Extension { #name : #MQNavigationIncomingDirectionStrategy }

{ #category : #'*Famix-Queries' }
MQNavigationIncomingDirectionStrategy class >> associationsFor: aMooseGroup [
	^ aMooseGroup allEntityTypes flatCollect: [ :class | class allIncomingAssociationTypesIn: aMooseGroup metamodel ]
]
