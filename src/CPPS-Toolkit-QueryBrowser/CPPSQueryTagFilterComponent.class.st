"
Description
----------------

I am a concret component allowing the user to create a query to select by tag name of his current result. 

The filter can, for example, be to select all the entities with tag 'concept'.

"
Class {
	#name : #CPPSQueryTagFilterComponent,
	#superclass : #CPPSQueryComponent,
	#instVars : [
		'tagPossibilities'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #accessing }
CPPSQueryTagFilterComponent class >> englishName [

	^ 'Concept filter'
]

{ #category : #accessing }
CPPSQueryTagFilterComponent class >> frenchName [

	^ 'Filtre par concept'
]

{ #category : #accessing }
CPPSQueryTagFilterComponent class >> priority [

	^ 40
]

{ #category : #testing }
CPPSQueryTagFilterComponent >> isUnavailable [

	^ self tagsPossibilities isEmpty
]

{ #category : #accessing }
CPPSQueryTagFilterComponent >> modelClass [

	^ FQTagQuery
]

{ #category : #rendering }
CPPSQueryTagFilterComponent >> renderFormContentOn: html [

	html formContainer: [ self renderTagSelectionOn: html ].
	html formContainer: [ self renderSelectionInputOn: html ]
]

{ #category : #rendering }
CPPSQueryTagFilterComponent >> renderSelectionInputOn: html [

	html radioGroup
		callback: [ :value | self query select: value ];
		selected: self query select;
		with:
			[ :group | 
			(OrderedDictionary
				 with: 'Select tagged entities' -> true
				 with: 'Reject tagged entities' -> false) keysAndValuesDo:
					[ :label :value | 
					html mdlRadioContainer
						rippleEffect;
						for: html nextId;
						with:
							[ group mdlRadioButton
								value: value;
								id: html lastId.
							html mdlRadioLabel: label
							]
					]
			]
]

{ #category : #rendering }
CPPSQueryTagFilterComponent >> renderTagSelectionOn: html [

	self query tag ifNotNil:
		[ :tag | 
		(self tagsPossibilities includes: tag) ifFalse:
			[ self query tag: nil. "this case is possible after edition of the previous query that remove entities marked with this tag"
			html mdlAlert
				beWarning;
				with: (self
						 translate: 'The previously selected tag for filtering is not on any entity'
						 french: 'Le tag précédement choisi pour le filtrage n''est plus sur aucune entité')
			]
		].
	html render: (MDLSelectWidget
			 possibilities: self tagsPossibilities
			 inputLabel: (self
					  english: 'Select a concept'
					  french: 'Selectionnez un concept')
			 labelBlock: #mooseName
			 callback: [ :tag | self query tag: tag ]
			 selectedObject: self query tag)
]

{ #category : #rendering }
CPPSQueryTagFilterComponent >> tagsPossibilities [

	^ tagPossibilities ifNil: [ tagPossibilities := (self queryResult flatCollectAsSet: #tags) asOrderedCollection ]
]

{ #category : #accessing }
CPPSQueryTagFilterComponent >> unavailableMessage [

	^ self
		  translate: 'No tag on current entities'
		  french: 'Pas de tag sur les entités actuelles'
]
