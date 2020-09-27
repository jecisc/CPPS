Class {
	#name : #CPPSCorrelationBrowser,
	#superclass : #CPPSAbstractBrowser,
	#traits : 'TRightTabsPanelBrowser',
	#classTraits : 'TRightTabsPanelBrowser classTrait',
	#instVars : [
		'correlationsList',
		'toolbar',
		'rightPanel'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Correlation'
}

{ #category : #accessing }
CPPSCorrelationBrowser class >> browserName [

	^ 'Correlation browser' french: 'Explorateur de correlations'
]

{ #category : #accessing }
CPPSCorrelationBrowser class >> priority [

	^ 34
]

{ #category : #accessing }
CPPSCorrelationBrowser >> browserClass [

	^ #correlations
]

{ #category : #accessing }
CPPSCorrelationBrowser >> correlationsList [

	^ correlationsList
]

{ #category : #accessing }
CPPSCorrelationBrowser >> correlationsList: anObject [

	correlationsList := anObject
]

{ #category : #initialization }
CPPSCorrelationBrowser >> defaultCorrelationsList [

	^ (MDLNestedList elements: [ self correlationsStorage ])
		  actionBlock: [ :clone | self selectCorrelation: clone ];
		  format: #name;
		  beCompact;
		  addDecoration: (CPPSTitleDecoration entitled: 'Correlations');
		  yourself
]

{ #category : #components }
CPPSCorrelationBrowser >> defaultToolbar [

	^ MDLVerticalToolbar buttons: { 
			  ((MDLFoldButton for: '#' , self rightPanelId)
				   resetVisusOnFold;
				   fold;
				   yourself).
			  (self
				   switcherButton: 'New'
				   tooltip: 'Create new correlation'
				   perform: #setDefaultRightPanel).
			  (self
				   switcherButton: 'Edit'
				   tooltip: 'Edit current correlation'
				   perform: #setEditRightPanel
				   onCompleteHook: MDLDialog jsInitializeRootDialog contents).
			  (self
				   switcherButton: 'CSV'
				   tooltip: 'Export with CSV format the results of the correlation'
				   perform: #setCSVRightPanel) }
]

{ #category : #rendering }
CPPSCorrelationBrowser >> displayBlockFor: entity [

	^ [ :r | 
	  r div
		  id: r nextId;
		  with: entity name.
	  r
		  mdlLargeTooltipFor: r lastId
		  with: (entity tooltipIn: self session language)
	  ]
]

{ #category : #rendering }
CPPSCorrelationBrowser >> getCorrelationsRowsFor: correlation [

	^ correlation linesEntities collect:
		  [ :lineEntity | 
		  (OrderedCollection with: (self displayBlockFor: lineEntity))
			  addAll: (correlation columnsEntities collect:
						   [ :columnEntity | 
						   CPPSCorrelationCell matches: (correlation
									    is: columnEntity
									    correlatedTo: lineEntity)
						   ]);
			  yourself
		  ]
]

{ #category : #rendering }
CPPSCorrelationBrowser >> getCountCorrelationsRowsFor: correlation [

	| rows cells min max gradiant |

	cells := OrderedCollection new.
	rows := correlation linesEntities collect:
		        [ :lineEntity | 
		        (OrderedCollection with: (self displayBlockFor: lineEntity))
			        addAll: (correlation columnsEntities collect:
						         [ :columnEntity | 
						         cells add: (CPPSCorrelationCountCell count: (correlation
											           numberOfMatchesFor: columnEntity
											           correlatedTo: lineEntity))
						         ]);
			        yourself
		        ].
	min := (cells collect: #count) min.
	max := (cells collect: #count) max.
	gradiant := ((MDLColor
		              tint: #red
		              code: #'900')
		             property: #yourself
		             gradientAt: min)
		            to: MDLColor orange
		            at: max / 3;
		            to: MDLColor yellow
		            at: max / 3 * 2;
		            to: MDLColor green
		            at: max.
	cells do: [ :cell | cell color: (gradiant computeForLevel: cell count) ].
	^ rows
]

{ #category : #initialization }
CPPSCorrelationBrowser >> initialize [

	super initialize.
	self initializeRightPanel.
	self correlationsList: self defaultCorrelationsList
]

{ #category : #opening }
CPPSCorrelationBrowser >> onEntity: anEntity [

	"I do not manage entities so I do nothing."

	
]

{ #category : #rendering }
CPPSCorrelationBrowser >> render: aBlock ifCorrelationPresentOn: html [

	self selectedCorrelation
		ifNil:
			[ html div
				beCentered;
				with:
					[ html mdlAlert
						beInfo;
						with: 'No correlation present'
					]
			]
		ifNotNil: aBlock
]

{ #category : #rendering }
CPPSCorrelationBrowser >> renderContentOn: html [

	self selectedCorrelation
		ifNil: [ self correlationsStorage ifNotEmpty: [ :correlations | self selectedCorrelation: correlations anyOne ] ]
		ifNotNil: [ :c | c initializeFor: self model ].
	html div
		class: self browserClass;
		with:
			[ html leftPanel:
					[ html
						render: self correlationsList;
						leftPanelResizer
					].
			html div
				beGrowing;
				class: self browserClass , '-content';
				with: [ self renderCorrelationOn: html ].
			self renderRightPanelOn: html
			]
]

{ #category : #rendering }
CPPSCorrelationBrowser >> renderCorrelationOn: html [

	self
		render:
			[ :correlation | 
			| header rows |

			header := (OrderedCollection with: ' ')
				          addAll: (correlation columnsEntities collect: [ :entity | self displayBlockFor: entity ]);
				          yourself.
			rows := correlation isCount
				        ifTrue: [ self getCountCorrelationsRowsFor: correlation ]
				        ifFalse: [ self getCorrelationsRowsFor: correlation ].
			html div
				style: 'width: 100%; height: 100%; overflow: auto;';
				with: (MDLSortableTable new
						 header: header;
						 rows: rows;
						 rowsPerPagePossibilities: #( 10 50 100 200 ))
			]
		ifCorrelationPresentOn: html
]

{ #category : #accessing }
CPPSCorrelationBrowser >> rightPanel [

	^ rightPanel
]

{ #category : #accessing }
CPPSCorrelationBrowser >> rightPanel: anObject [

	rightPanel := anObject
]

{ #category : #accessing }
CPPSCorrelationBrowser >> selectCorrelation: aCorrelation [

	correlationsList selectedEntity: aCorrelation
]

{ #category : #accessing }
CPPSCorrelationBrowser >> selectedCorrelation [

	^ self correlationsList selectedEntity
]

{ #category : #accessing }
CPPSCorrelationBrowser >> selectedCorrelation: aCorrelation [

	self selectedCorrelation == aCorrelation ifTrue: [ ^ self ].
	self correlationsList selectedEntity: aCorrelation
]

{ #category : #components }
CPPSCorrelationBrowser >> setCSVRightPanel [

	self rightPanel: ((CPPSCorrelationCSVExportRightPanel owner: self)
			 addDecoration: (CPPSTitleDecoration entitled: (self
							   english: 'CSV export'
							   french: 'Export CSV'));
			 yourself)
]

{ #category : #components }
CPPSCorrelationBrowser >> setDefaultRightPanel [

	self rightPanel: ((CPPSNewCorrelationRightPanel owner: self)
			 addDecoration: (CPPSTitleDecoration entitled: (self
							   english: 'New correlation'
							   french: 'Nouvelle correlation'));
			 yourself)
]

{ #category : #components }
CPPSCorrelationBrowser >> setEditRightPanel [

	self rightPanel: ((CPPSEditCorrelationRightPanel owner: self)
			 addDecoration: (CPPSTitleDecoration entitled: (self
							   english: 'Edit correlation'
							   french: 'Éditter la correlation'));
			 yourself)
]

{ #category : #accessing }
CPPSCorrelationBrowser >> toolbar [

	^ toolbar
]

{ #category : #accessing }
CPPSCorrelationBrowser >> toolbar: anObject [

	toolbar := anObject
]
