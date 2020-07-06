Extension { #name : #Object }

{ #category : #'*CPPS-Entities' }
Object >> isCPPSBlock [
	^ false
]

{ #category : #'*CPPS-Entities' }
Object >> isExistingMetricFor: anEntity [
	^ self ~= anEntity notExistentMetricValue
]
