Extension { #name : #MADateAndTimeDescription }

{ #category : #'*CPPS-Toolkit-Magritte' }
MADateAndTimeDescription >> displayCurrent [

	self shouldDisplayCurrent: true
]

{ #category : #'*CPPS-Toolkit-Magritte-Components' }
MADateAndTimeDescription >> mdlComponentClass [

	^ CPPSMDLDateAndTimeComponent
]

{ #category : #'*CPPS-Toolkit-Magritte' }
MADateAndTimeDescription >> shouldDisplayCurrent [

	"when set to true, the editor will be initialized with the current dateAndTime"

	^ self properties
		  at: #shouldDisplayCurrent
		  ifAbsent: [ false ]
]

{ #category : #'*CPPS-Toolkit-Magritte' }
MADateAndTimeDescription >> shouldDisplayCurrent: aBoolean [

	self properties
		at: #shouldDisplayCurrent
		put: aBoolean
]
