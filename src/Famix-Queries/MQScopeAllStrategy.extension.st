Extension { #name : #MQScopeAllStrategy }

{ #category : #'*Famix-Queries' }
MQScopeAllStrategy class >> availableScopesForEntity: class in: model [
	^ (self allChildrenScopesOf: class in: model) , (self allParentsScopesOf: class in: model)
]
