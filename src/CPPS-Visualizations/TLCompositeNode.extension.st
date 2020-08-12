Extension { #name : #TLCompositeNode }

{ #category : #'*CPPS-Visualizations' }
TLCompositeNode >> borderStyleForChildrenPresence [

	^ self hasChildren
		  ifTrue: [ TLDashedLineStyle ]
		  ifFalse: [ super borderStyleForChildrenPresence ]
]
