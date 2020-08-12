Extension { #name : #CPPSBehaviouralEntity }

{ #category : #'*CPPS-Visualizations' }
CPPSBehaviouralEntity >> childrenForTransitiveExploreEntitesVisualization [

	^ self blocks
]

{ #category : #'*CPPS-Visualizations' }
CPPSBehaviouralEntity >> dataEntitiesForQuickTagging [

	^ (self accesses collectAsSet: #variable) select: [ :var | var isAttribute and: [ self parents includes: var parentType ] ]
]
