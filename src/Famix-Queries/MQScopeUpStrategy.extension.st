Extension { #name : #MQScopeUpStrategy }

{ #category : #'*Famix-Queries' }
MQScopeUpStrategy class >> availableScopesForEntity: class in: model [
	^ self allParentsScopesOf: class in: model
]
