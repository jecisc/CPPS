Extension { #name : #MQScopeTypesStrategy }

{ #category : #'*Famix-Queries' }
MQScopeTypesStrategy >> displayName [
	^ ' - ' join: (scopes collect: #englishName)
]
