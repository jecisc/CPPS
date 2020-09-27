Extension { #name : #MooseProject }

{ #category : #'*CPPS-Toolkit-Core' }
MooseProject >> correlationsStorage [

	^ self genericDictionary
		  at: #correlationsStorage
		  ifAbsentPut: [ OrderedCollection new ]
]

{ #category : #'*CPPS-Toolkit-Core' }
MooseProject >> queryStorage [

	^ self genericDictionary
		  at: #queryStorage
		  ifAbsentPut: [ OrderedCollection new ]
]
