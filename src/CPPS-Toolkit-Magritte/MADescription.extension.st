Extension { #name : #MADescription }

{ #category : #'*CPPS-Toolkit-Magritte' }
MADescription >> addEarlyCondition: aCondition labelled: aString [

	"Add ==aCondition== as an additional early validation condition to the receiver and give it the label ==aString==. The first argument is either a block-context or any other object that responds to ==#value:== with ==true== or ==false==."

	self earlyConditions: (self earlyConditions copyWith: (Association
				  key: aCondition
				  value: aString))
]

{ #category : #'*CPPS-Toolkit-Magritte' }
MADescription >> earlyConditions [

	"Answers a collection of additional conditions that will be checked before any other condition (even before 'isRequired' condition).
	As example, this is usefull to check ajax file upload size "

	^ self
		  propertyAt: #earlyConditions
		  ifAbsent: [ OrderedCollection new ]
]

{ #category : #'*CPPS-Toolkit-Magritte' }
MADescription >> earlyConditions: aCollectionOfMAConditions [

	^ self
		  propertyAt: #earlyConditions
		  put: aCollectionOfMAConditions
]

{ #category : #'*CPPS-Toolkit-Magritte' }
MADescription >> hidden [

	^ self
		  propertyAt: #hidden
		  ifAbsent: [ false ]
]

{ #category : #'*CPPS-Toolkit-Magritte' }
MADescription >> hidden: aValue [

	self
		propertyAt: #hidden
		put: aValue
]

{ #category : #'*CPPS-Toolkit-Magritte-Components' }
MADescription >> mdlComponentClass [

	"hook for using a specific component class, without introducing dependencies between UI and model.
	By default answers the default component class.
	Overwrite for specific behavior"

	^ self componentClass
]

{ #category : #'*CPPS-Toolkit-Magritte' }
MADescription >> translatableComment [

	^ self
		  propertyAt: #translatableComment
		  ifAbsent: [ nil ]
]

{ #category : #'*CPPS-Toolkit-Magritte' }
MADescription >> translatableComment: aString [

	self
		propertyAt: #translatableComment
		put: aString
]

{ #category : #'*CPPS-Toolkit-Magritte' }
MADescription >> validateEarlyConditions: anObject [

	"Validate ==anObject== to satisfy all its custom conditions."

	self earlyConditions do:
		[ :each | 
		(each key value: anObject) ifFalse:
			[ MAConditionError
				description: self
				signal: each value
			]
		]
]
