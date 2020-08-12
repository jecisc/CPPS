Extension { #name : #FamixTag }

{ #category : #'*CPPS-Visualizations' }
FamixTag >> cytoscapeShape [

	^ self class cytoscapeShape
]

{ #category : #'*CPPS-Visualizations' }
FamixTag class >> cytoscapeShape [

	^ TLLabel
]

{ #category : #'*CPPS-Visualizations' }
FamixTag >> isSearchTag [

	^ self parentTag
		  ifNil: [ false ]
		  ifNotNil: [ :pt | pt name = #researchs ]
]
