Class {
	#name : #CPPSRulesBrowser,
	#superclass : #CPPSAbstractBrowser,
	#traits : 'TRightTabsPanelBrowser',
	#classTraits : 'TRightTabsPanelBrowser classTrait',
	#instVars : [
		'entitiesList',
		'codeDisplayer',
		'rulesList',
		'toolbar',
		'rightPanel'
	],
	#category : #'CPPS-Toolkit-RulesBrowser'
}

{ #category : #accessing }
CPPSRulesBrowser class >> browserName [

	^ 'Rules Browser' french: 'Explorateur de régles'
]

{ #category : #testing }
CPPSRulesBrowser class >> isReleventFor: selectionOrEntity [

	^ selectionOrEntity isCollection
		  ifTrue: [ false ]
		  ifFalse: [ selectionOrEntity isRule ]
]

{ #category : #accessing }
CPPSRulesBrowser class >> priority [

	^ 80
]

{ #category : #accessing }
CPPSRulesBrowser >> browserClass [

	^ #'rules-browser'
]

{ #category : #hooks }
CPPSRulesBrowser >> children [

	^ Array
		  with: self rulesList
		  with: self entitiesList
		  with: self codeDisplayer
		  with: self toolbar
		  with: self rightPanel
]

{ #category : #accessing }
CPPSRulesBrowser >> codeDisplayer [

	^ codeDisplayer
]

{ #category : #accessing }
CPPSRulesBrowser >> codeDisplayer: anObject [

	codeDisplayer := anObject
]

{ #category : #components }
CPPSRulesBrowser >> defaultCodeDisplayer [

	^ PrismComponent
		  sourceCode: ''
		  linkObjects: #(  )
		  linkPositionFunction: [ :o |  ]
		  callBack: [ :o |  ]
		  linkStyle: [ :o |  ]
		  language: self strategy languageClass
]

{ #category : #components }
CPPSRulesBrowser >> defaultEntitiesList [

	^ (MDLNestedList elements: #(  ))
		  actionBlock: [ :entity | self selectedEntity: entity ];
		  format: #name;
		  iconBlock: #iconComponent;
		  helpBlock: [ :entity | entity tooltipIn: self session language ];
		  beAltCompact;
		  addDecoration: (CPPSTitleDecoration
				   entitled: (self
						    english: 'Concerned Entities'
						    french: 'Entitées Concernées')
				   badgeBlock: [ self entitiesList elements size ]);
		  addDecoration: (CPPSDivDecoration htmlClass: 'entities');
		  yourself
]

{ #category : #components }
CPPSRulesBrowser >> defaultRulesList [

	^ (MDLNestedList elements: [ self rulesManager listAllRules ])
		  actionBlock: [ :rule | self selectedRule: rule ];
		  format: #label;
		  helpBlock:
			  [ :rule :html | 
			  [ self
				  renderExplanationFor: rule
				  on: html
			  ]
			  ];
		  beAltCompact;
		  addDecoration: (CPPSTitleDecoration entitled: (self
						    english: 'Rules'
						    french: 'Régles'));
		  addDecoration: (CPPSDivDecoration htmlClass: 'rules');
		  yourself
]

{ #category : #components }
CPPSRulesBrowser >> defaultToolbar [

	^ MDLVerticalToolbar buttons: { 
			  ((MDLFoldButton for: '#' , self rightPanelId)
				   fold;
				   yourself).
			  (self
				   switcherButton: (self
						    english: 'Edit'
						    french: 'Éditer')
				   tooltip: (self
						    english: 'Edit the rule'
						    french: 'Éditer la régle')
				   perform: #setDefaultRightPanel
				   onCompleteHook: MDLDialog jsInitializeRootDialog contents) }
]

{ #category : #action }
CPPSRulesBrowser >> deleteSelectedRule [

	self rulesManager removeRule: self selectedRule.
	self selectedRule: nil.
	self selectFirstRuleIfPossible
]

{ #category : #accessing }
CPPSRulesBrowser >> entitiesList [

	^ entitiesList
]

{ #category : #accessing }
CPPSRulesBrowser >> entitiesList: aNestedList [

	entitiesList := aNestedList
]

{ #category : #initialization }
CPPSRulesBrowser >> initialize [

	super initialize.
	self
		rulesList: self defaultRulesList;
		entitiesList: self defaultEntitiesList;
		codeDisplayer: self defaultCodeDisplayer;
		selectFirstRuleIfPossible;
		initializeRightPanel
]

{ #category : #opening }
CPPSRulesBrowser >> onEntity: aRule [

	self selectedRule: aRule
]

{ #category : #rendering }
CPPSRulesBrowser >> renderContentOn: html [

	html div
		class: self browserClass;
		with:
			[ html leftPanel:
					[ html
						render: self rulesList;
						render: self entitiesList;
						leftPanelResizer
					].
			html div
				class: #'code-container';
				with: [ self renderSelectedEntityCodeOn: html ].
			self renderRightPanelOn: html
			]
]

{ #category : #rendering }
CPPSRulesBrowser >> renderExplanationFor: rule on: html [

	| string englishText frenchText |

	string := '<table>
	<tr>
		<td><strong>Description :</strong></td>
		<td>{1}</td>
	</tr>
	<tr>
		<td><strong>{2} :</strong></td>
		<td>{3}</td>
	</tr>
		<td><strong>{4} :</strong></td>
		<td>{5}</td>
	</tr>
</table>'.
	englishText := { 
		               rule explanation.
		               'Time to correct one violation'.
		               rule remediationTime humanReadablePrintString.
		               'Time to correct all violations'.
		               rule totalRemediationTime humanReadablePrintString }.
	frenchText := { 
		              rule explanation.
		              'Temps pour corriger une violation'.
		              rule remediationTime humanReadablePrintString.
		              'Temps pour corriger toutes les violations'.
		              rule totalRemediationTime humanReadablePrintString }.
	html html: (self
			 english: (string format: englishText)
			 french: (string format: frenchText))
]

{ #category : #rendering }
CPPSRulesBrowser >> renderSelectedEntityCodeOn: html [

	html div
		class: #'code-container-panel';
		with:
			[ html mdlTabBar:
					[ html mdlTab
						class: 'activeByHand';
						with: (self
								 english: 'Code'
								 french: 'Code')
					].
			html div
				class: #'code-container-panel__content';
				with: [ html render: self codeDisplayer ]
			]
]

{ #category : #accessing }
CPPSRulesBrowser >> rightPanel [

	^ rightPanel
]

{ #category : #accessing }
CPPSRulesBrowser >> rightPanel: aComponent [

	rightPanel := aComponent
]

{ #category : #accessing }
CPPSRulesBrowser >> rulesList [

	^ rulesList
]

{ #category : #accessing }
CPPSRulesBrowser >> rulesList: aNestedList [

	rulesList := aNestedList
]

{ #category : #initialization }
CPPSRulesBrowser >> selectFirstEntityIfPossible [

	self entitiesList elements ifNotEmpty: [ :elements | self selectedEntity: elements anyOne ]
]

{ #category : #initialization }
CPPSRulesBrowser >> selectFirstRuleIfPossible [

	self rulesList elements ifNotEmpty: [ :elements | self selectedRule: elements anyOne ]
]

{ #category : #accessing }
CPPSRulesBrowser >> selectedEntity [

	^ self entitiesList selectedEntity
]

{ #category : #accessing }
CPPSRulesBrowser >> selectedEntity: anEntity [

	self entitiesList selectedEntity: anEntity.
	self codeDisplayer sourceCode: (anEntity
			 ifNil:
				 [ self
					 english: 'Nothing to display'
					 french: 'Rien à afficher'
				 ]
			 ifNotNil: #sourceText)
]

{ #category : #accessing }
CPPSRulesBrowser >> selectedRule [

	^ self rulesList ifNotNil: #selectedEntity
]

{ #category : #accessing }
CPPSRulesBrowser >> selectedRule: aRule [

	self rulesList selectedEntity: aRule.
	self selectedEntity: nil.
	self entitiesList elements: ((aRule
			  ifNil: [ {  } ]
			  ifNotNil: #violations) sorted: [ :a :b | a name < b name ]).
	self selectFirstEntityIfPossible
]

{ #category : #initialization }
CPPSRulesBrowser >> setDefaultRightPanel [

	self rightPanel: (CPPSRuleEditorComponent
			 owner: self
			 rule: [ self selectedRule ])
]

{ #category : #hooks }
CPPSRulesBrowser >> states [

	^ Array with: self rightPanel
]

{ #category : #accessing }
CPPSRulesBrowser >> toolbar [

	^ toolbar
]

{ #category : #accessing }
CPPSRulesBrowser >> toolbar: anObject [

	toolbar := anObject
]
