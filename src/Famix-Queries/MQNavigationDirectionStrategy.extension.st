Extension { #name : #MQNavigationDirectionStrategy }

{ #category : #'*Famix-Queries' }
MQNavigationDirectionStrategy class >> associationsFor: aMooseGroup [
	^ self subclassResponsibility
]

{ #category : #'*Famix-Queries' }
MQNavigationDirectionStrategy class >> availableAssociationsFor: aMooseGroup [
	| allAssociations |
	aMooseGroup ifEmpty: [ ^ #() ].
	allAssociations := self associationsFor: aMooseGroup.

	^ (aMooseGroup localMooseModel allAssociationTypes
		select: [ :class | allAssociations anySatisfy: [ :type | class = type or: [ class allTraits includes: type ] ] ]) flatCollect: #withAllSubclasses
]
