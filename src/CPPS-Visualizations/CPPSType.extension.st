Extension { #name : #CPPSType }

{ #category : #'*CPPS-Visualizations' }
CPPSType >> dataAccessorsForQuickTagging [

	^ self methods
]

{ #category : #'*CPPS-Visualizations' }
CPPSType >> dataEntitiesForQuickTagging [

	^ self attributes
]
