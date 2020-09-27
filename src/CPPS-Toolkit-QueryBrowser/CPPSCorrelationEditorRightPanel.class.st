Class {
	#name : #CPPSCorrelationEditorRightPanel,
	#superclass : #CPPSCorrelationRightPanel,
	#instVars : [
		'columnTypeSelection',
		'linesTypeSelection'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Correlation'
}

{ #category : #accessing }
CPPSCorrelationEditorRightPanel >> correlation [

	^ self subclassResponsibility
]

{ #category : #initialization }
CPPSCorrelationEditorRightPanel >> initialize [

	super initialize.
	columnTypeSelection := CPPSCheckboxesComponent
		                       possibilities: self possibleTypes
		                       selection: [ self correlation columnsQuery entityTypes ].
	linesTypeSelection := CPPSCheckboxesComponent
		                      possibilities: self possibleTypes
		                      selection: [ self correlation linesQuery entityTypes ]
]

{ #category : #initialization }
CPPSCorrelationEditorRightPanel >> possibleTypes [

	^ self model allEntityTypes sorted: #name ascending
]

{ #category : #accessing }
CPPSCorrelationEditorRightPanel >> renderButtonsOn: html [

	^ self subclassResponsibility
]

{ #category : #rendering }
CPPSCorrelationEditorRightPanel >> renderContentOn: html [

	html form
		marginAuto;
		style: 'width: 90%;';
		with:
			[ html
				formContainer: [ self renderNameInputOn: html ];
				text: 'Entity types on which run the column query:';
				formContainer: [ html render: columnTypeSelection ];
				text: 'Query to run on selected types to select column entities:';
				formContainer:
					[ self
						renderQuerySelectionNamed: 'Columns query'
						callback: [ :query | self correlation columnsQuery query: query ]
						selectedElement: self correlation columnsQuery query
						on: html
					];
				text: 'Entity types on which run the line query:';
				formContainer: [ html render: linesTypeSelection ];
				text: 'Query to run on selected types to select line entities:';
				formContainer:
					[ self
						renderQuerySelectionNamed: 'Lines query'
						callback: [ :query | self correlation linesQuery query: query ]
						selectedElement: self correlation linesQuery query
						on: html
					];
				text: 'Query to apply on column entities to find the matching lines entities:';
				formContainer:
					[ self
						renderQuerySelectionNamed: 'Correlation query'
						callback: [ :query | self correlation correlationQuery: query ]
						selectedElement: self correlation correlationQuery
						on: html
					];
				formContainer: [ self renderDisplayToggleOn: html ];
				formContainer: [ self renderButtonsOn: html ]
			]
]

{ #category : #rendering }
CPPSCorrelationEditorRightPanel >> renderDisplayToggleOn: html [

	html mdlSwitchContainer
		rippleEffect;
		style: 'width: auto; margin-bottom: 20px;';
		for: html nextId;
		with:
			[ html mdlSwitch
				value: self correlation isCount;
				callback: [ :value | self correlation isCount: value ];
				id: html lastId.
			html mdlSwitchLabel: 'Display count of correlated elements'
			]
]

{ #category : #rendering }
CPPSCorrelationEditorRightPanel >> renderNameInputOn: html [

	html render: ((MDLTextFieldWidget
			  labeled: (self
					   english: 'Name'
					   french: 'Nom')
			  callback: [ :name | self correlation name: (name ifEmpty: [ 'unnamed' ]) ]
			  floatingLabel: true)
			 value: self correlation name;
			 formControl;
			 yourself)
]

{ #category : #rendering }
CPPSCorrelationEditorRightPanel >> renderQuerySelectionNamed: aString callback: aBlock selectedElement: aQuery on: html [

	html render: ((MDLSelectWidget
			  possibilities: self queries
			  inputLabel: aString
			  labelBlock: #name
			  callback: aBlock
			  selectedObject: aQuery)
			 standardSorting;
			 yourself)
]
