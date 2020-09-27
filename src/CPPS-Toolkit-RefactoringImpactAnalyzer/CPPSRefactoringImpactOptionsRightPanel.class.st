"
Description
--------------------

I am a simple component to manage some options of the Refactoring Impact Analyzer.

For now I only let the user select the directions of the links but later I could have more options.
"
Class {
	#name : #CPPSRefactoringImpactOptionsRightPanel,
	#superclass : #CPPSAbstractRightPanel,
	#category : #'CPPS-Toolkit-RefactoringImpactAnalyzer'
}

{ #category : #accessing }
CPPSRefactoringImpactOptionsRightPanel >> allEntityTypes [

	^ self model allEntityTypes sorted: #name ascending
]

{ #category : #accessing }
CPPSRefactoringImpactOptionsRightPanel >> defaultScope [

	^ self owner defaultScope
]

{ #category : #accessing }
CPPSRefactoringImpactOptionsRightPanel >> defaultScope: aClass [

	self owner defaultScope: aClass
]

{ #category : #accessing }
CPPSRefactoringImpactOptionsRightPanel >> directionStrategy [

	^ self owner directionStrategy
]

{ #category : #accessing }
CPPSRefactoringImpactOptionsRightPanel >> directionStrategy: aStrategy [

	^ self owner directionStrategy: aStrategy
]

{ #category : #accessing }
CPPSRefactoringImpactOptionsRightPanel >> kindsToExclude [

	^ self owner kindsToExclude
]

{ #category : #rendering }
CPPSRefactoringImpactOptionsRightPanel >> renderAtScopeOptionOn: html [

	html form
		marginAuto;
		style: 'width: 90%;';
		mdlTypographyTextCenter;
		noAutocomplete;
		with:
			[ html headerContainer:
					[ html headline: (self
								 english: 'Show higher scope'
								 french: 'Montrer de niveau')
					].
			html mdlGrid
				formControl;
				mdlTypographyTextJustify;
				with:
					[ html render: (MDLSelectWidget
								 possibilities: self allEntityTypes
								 inputLabel: (self
										  english: 'Scope'
										  french: 'niveau')
								 labelBlock: #englishName
								 callback: [ :scope | self showToScope: scope ]).
					html mdlMajorButton
						bePush;
						onClick: html jQuery ajax serializeForm;
						with: (self
								 english: 'Apply'
								 french: 'Appliquer')
					]
			]
]

{ #category : #rendering }
CPPSRefactoringImpactOptionsRightPanel >> renderConnectionHighlightOn: html [

	html form
		marginAuto;
		style: 'width: 90%;';
		mdlTypographyTextCenter;
		noAutocomplete;
		with:
			[ html headerContainer:
					[ html headline: (self
								 english: 'Connection highlight'
								 french: 'Mise en évidence des connexions')
					].
			html mdlGrid
				formControl;
				mdlTypographyTextJustify;
				with:
					[ html paragraph: (self
								 english: 'This option can have failures due to the fact that it is hard to manage mouse over interaction for connections.'
								 french: 'Cette option peut avoir des ratés à cause du fait qu''il est difficile de gérer les interactions de survole de souris pour les connexions.').
					html radioGroup
						callback: [ :value | self setHighlightConnectionOptionTo: value ];
						selected: self directionStrategy highlightConnections;
						with:
							[ :group | 
							(OrderedDictionary
								 with: 'Enable' -> true
								 with: 'Disable' -> false) keysAndValuesDo:
									[ :label :value | 
									html mdlRadioContainer
										rippleEffect;
										beCell: 6
										phoneSize: 4
										tabletSize: 2;
										for: html nextId;
										with:
											[ group mdlRadioButton
												value: value;
												onChange: html jQuery ajax serializeThis;
												id: html lastId.
											html mdlRadioLabel: label
											]
									]
							]
					]
			]
]

{ #category : #rendering }
CPPSRefactoringImpactOptionsRightPanel >> renderContentOn: html [

	html div: [ self renderDirectionOptionOn: html ].
	html div: [ self renderDefaultScopeOptionOn: html ].
	html div: [ self renderKindSelectionOptionsOn: html ].
	html div: [ self renderConnectionHighlightOn: html ].
	html div: [ self renderAtScopeOptionOn: html ]
]

{ #category : #rendering }
CPPSRefactoringImpactOptionsRightPanel >> renderDefaultScopeOptionOn: html [

	html form
		marginAuto;
		style: 'width: 90%;';
		mdlTypographyTextCenter;
		noAutocomplete;
		with:
			[ html headerContainer:
					[ html headline: (self
								 english: 'Default dependencies scope'
								 french: 'Niveau par default des dépendances')
					].
			html mdlGrid
				formControl;
				mdlTypographyTextJustify;
				with:
					[ html paragraph: (self
								 english: 'While asking dependencies of an entity, it will try to show them at this scope. If it cannot go to this scope, it will directly return the entity.'
								 french: '').
					html render: ((MDLSelectWidget
								  possibilities: { nil } , self allEntityTypes
								  inputLabel: (self
										   english: 'Scope'
										   french: 'niveau')
								  labelBlock:
									  [ :scope | 
									  scope
										  ifNil: [ 'Receiver''s scope' ]
										  ifNotNil: #englishName
									  ]
								  callback: [ :scope | self defaultScope: scope ]
								  selectedObject: self defaultScope)
								 customizationBlock: [ :textField :renderer | textField onChange: html jQuery ajax serializeThis ];
								 yourself)
					]
			]
]

{ #category : #rendering }
CPPSRefactoringImpactOptionsRightPanel >> renderDirectionOptionOn: html [

	html form
		marginAuto;
		style: 'width: 90%;';
		mdlTypographyTextCenter;
		noAutocomplete;
		with:
			[ html headerContainer:
					[ html headline: (self
								 english: 'Dependencies directions'
								 french: 'Direction des dépendances')
					].
			html mdlGrid
				formControl;
				mdlTypographyTextJustify;
				with:
					[ html radioGroup
						callback: [ :value | self directionStrategy: value ];
						selected: self directionStrategy;
						with:
							[ :group | 
							CPPSRIADirectionStrategy allSubclassesDo:
									[ :directionStrategy | 
									html mdlRadioContainer
										rippleEffect;
										beCell: 6
										phoneSize: 4
										tabletSize: 2;
										for: html nextId;
										with:
											[ group mdlRadioButton
												value: directionStrategy;
												onChange: html jQuery ajax serializeThis;
												id: html lastId.
											html mdlRadioLabel: directionStrategy label
											]
									]
							]
					]
			]
]

{ #category : #rendering }
CPPSRefactoringImpactOptionsRightPanel >> renderEntityTypeSelectionCheckboxFor: aFAMIXClass on: html [

	html mdlCell:
		[ html mdlCheckboxContainer
			rippleEffect;
			for: html nextId;
			with:
				[ html mdlCheckbox
					value: (self kindsToExclude includes: aFAMIXClass) not;
					onChange: html jQuery ajax serializeThisWithHidden;
					id: html lastId;
					onTrue:
						[ self kindsToExclude
							remove: aFAMIXClass
							ifAbsent: [ "Do nothing" ]
						]
					onFalse: [ self kindsToExclude add: aFAMIXClass ].
				html mdlCheckboxLabel: (self translate: aFAMIXClass multilanguageDisplayName)
				]
		]
]

{ #category : #rendering }
CPPSRefactoringImpactOptionsRightPanel >> renderKindSelectionOptionsOn: html [

	html form
		marginAuto;
		style: 'width: 90%;';
		mdlTypographyTextCenter;
		noAutocomplete;
		with:
			[ html headerContainer:
					[ html headline: (self
								 english: 'Entities kinds to show'
								 french: 'Types d''entités à afficher')
					].
			html mdlGrid
				formControl;
				mdlTypographyTextJustify;
				with:
					[ self allEntityTypes do:
							[ :aFAMIXClass | 
							self
								renderEntityTypeSelectionCheckboxFor: aFAMIXClass
								on: html
							]
					]
			]
]

{ #category : #rendering }
CPPSRefactoringImpactOptionsRightPanel >> setHighlightConnectionOptionTo: aBoolean [

	| connections |

	self directionStrategy highlightConnections: aBoolean.
	connections := self visualization allConnections.
	aBoolean
		ifTrue: [ connections do: [ :connection | connection addInteraction: self directionStrategy defaultInteractionForConnections ] ]
		ifFalse: [ connections do: [ :connection | "We assume the highligh interaction is the only one currently." connection removeAllInteractions ] ].
	connections do: [ :c | c requireUpdate ].
	self visualization update
]

{ #category : #action }
CPPSRefactoringImpactOptionsRightPanel >> showNode: node toScope: aFAMIXClass inGroupNamed: groupName [

	| parents parent groupLevel |

	node parentNode ifNotNil: [ ^ self "It means that during the previous node scope, this node already found its parent." ].
	parents := (node entity atScope: aFAMIXClass) ifEmpty: [ ^ self "No scope to show, nothing to do" ].

	"For now we do not manage the case where there is multiple result..."
	parent := parents anyOne.
	node entity = parent ifTrue: [ ^ self "We already are at the right scope" ].
	groupLevel := groupName asInteger.
	self visualization obtain recursively nodes
		detect: [ :each | each entity = parent ]
		ifFound: [ :parentNode | "This should probably not happen." ]
		ifNone:
			[ self visualization
				createNodeFor: parent
				atLevel: groupLevel
			]
]

{ #category : #action }
CPPSRefactoringImpactOptionsRightPanel >> showToScope: aFAMIXClass [

	"Do not scope for the group0. This is why we do #allButFirst"

	self visualization subGroupsDictionary associations allButFirstDo:
		[ :association | 
		| group |

		group := association value.
		group nodes do:
			[ :node | 
			self
				showNode: node
				toScope: aFAMIXClass
				inGroupNamed: association key
			]
		].
	self visualization update
]

{ #category : #accessing }
CPPSRefactoringImpactOptionsRightPanel >> visualization [

	^ self owner visuComponent visualization
]
