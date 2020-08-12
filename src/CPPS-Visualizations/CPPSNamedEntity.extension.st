Extension { #name : #CPPSNamedEntity }

{ #category : #'*CPPS-Visualizations' }
CPPSNamedEntity class >> cytoscapeShape [

	^ TLRectangle
]

{ #category : #'*CPPS-Visualizations' }
CPPSNamedEntity >> cytoscapeShape [

	^ self class cytoscapeShape
]
