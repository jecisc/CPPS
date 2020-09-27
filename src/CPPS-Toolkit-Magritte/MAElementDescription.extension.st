Extension { #name : #MAElementDescription }

{ #category : #'*CPPS-Toolkit-Magritte' }
MAElementDescription >> visibilityCondition [

	^ self
		  propertyAt: #visibilityCondition
		  ifAbsent: [ [ true ] ]
]

{ #category : #'*CPPS-Toolkit-Magritte' }
MAElementDescription >> visibilityCondition: aOneArgumentBlock [

	"set a block taking a memento object as argument as a a visibility condition to be evaluated when rendering this description"

	^ self
		  propertyAt: #visibilityCondition
		  put: aOneArgumentBlock
]
