"
Description
----------------

I am a concret component allowing the user to create a query to change the scope of his current result. 

For example if the current result is at the level of a class, the user should have the possibility to change the scope to see the methods or the packages contained/containing by/the class.

"
Class {
	#name : #CPPSQueryScopeComponent,
	#superclass : #CPPSQueryComponent,
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #accessing }
CPPSQueryScopeComponent class >> englishName [

	^ 'Scope'
]

{ #category : #accessing }
CPPSQueryScopeComponent class >> frenchName [

	^ 'Portée'
]

{ #category : #accessing }
CPPSQueryScopeComponent class >> priority [

	^ 50
]

{ #category : #rendering }
CPPSQueryScopeComponent >> availableScopes [

	^ self query availableTypeStrategiesFor: self queryResult
]

{ #category : #testing }
CPPSQueryScopeComponent >> isUnavailable [

	^ (MQScopeAllStrategy availableScopesFor: self queryResult) isEmpty
]

{ #category : #accessing }
CPPSQueryScopeComponent >> modelClass [

	^ FQScopeQuery
]

{ #category : #rendering }
CPPSQueryScopeComponent >> renderDirectionOn: html [

	html render: ((MDLSelectWidget
			  possibilities: self modelClass directionStrategies
			  inputLabel: (self
					   english: 'Scope direction'
					   french: 'Direction de la portée')
			  labelBlock: #label
			  callback: [ :direction | self query directionStrategy: direction ]
			  selectedObject: self query directionStrategy)
			 customizationBlock: [ :textField :renderer | textField onChange: (html jQuery ajax serializeThis onComplete: (((html jQuery id: self scopeChoicesId) load html: [ :htm | self renderScopesOn: htm ]) onComplete: 'componentHandler.upgradeDom();')) ];
			 yourself)
]

{ #category : #rendering }
CPPSQueryScopeComponent >> renderFormContentOn: html [

	html formContainer:
		[ self renderDirectionOn: html.
		html div
			id: self scopeChoicesId;
			with: [ self renderScopesOn: html ]
		].
	html formContainer: [ self renderRecursionInputOn: html ]
]

{ #category : #rendering }
CPPSQueryScopeComponent >> renderRecursionInputOn: html [

	html mdlSwitchContainer
		rippleEffect;
		style: 'width: auto; margin-bottom: 20px;';
		for: html nextId;
		with:
			[ html mdlSwitch
				value: self query isRecursive;
				callback: [ :value | self query isRecursive: value ];
				id: html lastId.
			html mdlSwitchLabel: 'Be recursive'
			]
]

{ #category : #rendering }
CPPSQueryScopeComponent >> renderScopesOn: html [

	html render: (MDLSelectWidget
			 possibilities: self availableScopes
			 inputLabel: (self
					  english: 'Select a property'
					  french: 'Selectionnez une propriété')
			 labelBlock: #browserDisplayName
			 callback: [ :scope | self query typeStrategy: scope ]
			 selectedObject: self query typeStrategy)
]

{ #category : #accessing }
CPPSQueryScopeComponent >> scopeChoicesId [

	^ 'query-scope__level'
]

{ #category : #accessing }
CPPSQueryScopeComponent >> unavailableMessage [

	^ self
		  translate: 'There is no possible scope change for this result'
		  french: 'Il n''y a aucun changement de niveau possible pour ce résultat'
]
