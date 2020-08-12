Extension { #name : #TLAbstractNode }

{ #category : #'*CPPS-Visualizations' }
TLAbstractNode >> borderStyleForChildrenPresence [

	^ TLSolidLineStyle
]

{ #category : #'*CPPS-Visualizations' }
TLAbstractNode >> hasChildrenToDisplay [

	^ false
]

{ #category : #'*CPPS-Visualizations' }
TLAbstractNode >> openParents [

	self parentNode ifNotNil:
		[ :node | 
		node expanded: true.
		node openParents
		]
]
