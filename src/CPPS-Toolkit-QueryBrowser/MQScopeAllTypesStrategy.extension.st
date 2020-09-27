Extension { #name : #MQScopeAllTypesStrategy }

{ #category : #'*CPPS-Toolkit-QueryBrowser' }
MQScopeAllTypesStrategy >> browserDisplayName [

	^ super browserDisplayName , ' (only effective on recursive mode)'
]
