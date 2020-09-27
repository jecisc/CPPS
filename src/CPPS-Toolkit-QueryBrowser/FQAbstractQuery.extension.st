Extension { #name : #FQAbstractQuery }

{ #category : #'*CPPS-Toolkit-QueryBrowser' }
FQAbstractQuery >> isFakeQuery [

	^ false
]

{ #category : #'*CPPS-Toolkit-QueryBrowser' }
FQAbstractQuery class >> mdlIconName [

	^ self subclassResponsibility
]

{ #category : #'*CPPS-Toolkit-QueryBrowser' }
FQAbstractQuery >> propertyComponent [

	^ CPPSEditLeafQueryComponent
]

{ #category : #'*CPPS-Toolkit-QueryBrowser' }
FQAbstractQuery >> queryToRunToFor: aModelQuery [

	^ self
]

{ #category : #'*CPPS-Toolkit-QueryBrowser' }
FQAbstractQuery >> useQuery: aQuery [

	aQuery replace: self
]
