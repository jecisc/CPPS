Extension { #name : #MQScopeDownStrategy }

{ #category : #'*Famix-Queries' }
MQScopeDownStrategy class >> availableScopesForEntity: class in: model [
	^ self allChildrenScopesOf: class in: model
]
