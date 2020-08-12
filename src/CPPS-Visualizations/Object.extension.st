Extension { #name : #Object }

{ #category : #'*CPPS-Visualizations' }
Object >> ifKeyedTree: aBlock ifNot: aBlock2 [

	^ (self isKindOf: KeyedTree)
		  ifTrue: [ aBlock value ]
		  ifFalse: [ aBlock2 value ]
]

{ #category : #'*CPPS-Visualizations' }
Object >> style [

	^ #entity
]
