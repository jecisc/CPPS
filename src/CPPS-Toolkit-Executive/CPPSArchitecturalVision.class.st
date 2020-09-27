"
Description
--------------------

I am the browser that will show the architecture of the system
"
Class {
	#name : #CPPSArchitecturalVision,
	#superclass : #CPPSAbstractBrowser,
	#traits : 'TRightTabsPanelBrowser',
	#classTraits : 'TRightTabsPanelBrowser classTrait',
	#instVars : [
		'entitiesToDraw',
		'selectedVisuClass',
		'rightPanel',
		'toolbar'
	],
	#category : #'CPPS-Toolkit-Executive'
}

{ #category : #accessing }
CPPSArchitecturalVision class >> browserName [

	^ 'Current Architecture Explorer' french: 'Explorateur de l''architecture existante'
]

{ #category : #accessing }
CPPSArchitecturalVision class >> priority [

	^ 90
]

{ #category : #rendering }
CPPSArchitecturalVision >> addMenuInteractionOn: aVisualization with: html [

	aVisualization
		addInteraction: ((TLSeasideCallBackAction inNewTabWithBlock: [ :aNode | self openAdaptatedBrowserOn: { aNode entity } ]) withMenu: 'Show in CodeAnalyzer') propagateToChildren;
		addInteraction: ((TLSeasideAJAXCallBackAction
				  callback: [ self renderCodeOfSelectedEntityOn: html ]
				  forElement: '#' , self rightPanelId
				  on: html)
				 beforeBlock: [ :node :entity | "We can just set the entity of the right panel for now because all panels can have an entity set. Maybe later we should do another way" self rightPanel entity: entity ];
				 withMenu: 'Show code') propagateToChildren
]

{ #category : #accessing }
CPPSArchitecturalVision >> allVisusClasses [

	^ { 
		  CPPSCurrentArchitectureVisualization.
		  CPPSSystemOverviewVisualization }
]

{ #category : #accessing }
CPPSArchitecturalVision >> browserClass [

	"I should return an html class specific to the browser to prefix generated ids and classes for the HTML."

	^ #'architectural-vision'
]

{ #category : #rendering }
CPPSArchitecturalVision >> createVisuFromClass: aVisuClass [

	^ aVisuClass new
		  language: self session language;
		  initializeFromExecutive: self;
		  yourself
]

{ #category : #components }
CPPSArchitecturalVision >> defaultToolbar [

	^ MDLVerticalToolbar buttons: { 
			  ((MDLFoldButton for: '#' , self rightPanelId)
				   resetVisusOnFold;
				   fold;
				   yourself).
			  (self
				   switcherButton: 'Code'
				   tooltip: (self
						    english: 'Code of the selected entity.'
						    french: 'Code de l''entité sélectionnée.')
				   perform: #setDefaultRightPanel) }
]

{ #category : #action }
CPPSArchitecturalVision >> drillDownAction [

	^ TLExpandCollapseCompositeNodeAction new
		  condition: self drillDownCondition;
		  onExternalTrigger
]

{ #category : #action }
CPPSArchitecturalVision >> drillDownCondition [

	^ [ :drawable | 
	  drawable isNode and:
		  [ drawable isComposite and:
			  [ drawable childrenNodes
				  ifEmpty: [ false ]
				  ifNotEmpty: [ (drawable childrenNodes anySatisfy: [ :child | child isVisible ]) not ]
			  ]
		  ]
	  ]
]

{ #category : #accessing }
CPPSArchitecturalVision >> entitiesToDraw [

	^ entitiesToDraw ifNil:
		  [ entitiesToDraw := (self strategy systemMapEntitiesFrom: self model) sorted:
			                    [ :a :b | 
			                    | aPSize bPSize |

			                    aPSize := a allProviders size.
			                    bPSize := b allProviders size.
			                    aPSize = bPSize
				                    ifTrue: [ a allClients size < b allClients size ]
				                    ifFalse: [ aPSize < bPSize ]
			                    ]
		  ]
]

{ #category : #initialization }
CPPSArchitecturalVision >> initialize [

	super initialize.
	self initializeRightPanel
]

{ #category : #rendering }
CPPSArchitecturalVision >> renderCodeOfSelectedEntityOn: html [

	html render: self rightPanel.

	"If the right panel is not open, open it and display the prism component."
	html script: 'if($(".fold-button")[0].dataset.fold=="true"){$(".fold-button")[0].click();}initPrismComponents();initMinimaps();'
]

{ #category : #rendering }
CPPSArchitecturalVision >> renderContentOn: html [

	html div
		class: self browserClass;
		with:
			[ html div
				beGrowing;
				with:
					[ html mdlTabBar:
							[ self allVisusClasses do:
									[ :aVisuClass | 
									html mdlTab
										class: 'activeByHand'
										if: self selectedVisuClass = aVisuClass;
										callback: [ self selectedVisuClass: aVisuClass ];
										with: (self translate: aVisuClass title)
									]
							].
					html div
						class: self browserClass , '__visualization';
						with: [ self renderVisuOn: html ]
					].
			self renderRightPanelOn: html
			]
]

{ #category : #rendering }
CPPSArchitecturalVision >> renderExternalTriggersOf: aVisu for: aVisuComponent on: html [

	| drillDown |

	drillDown := self drillDownAction.
	aVisu addInteraction: drillDown.
	html mdlMajorButton
		class: #'architecture-drill-down';
		onClick: (drillDown externalTriggerForVisuId: aVisuComponent visuDivId);
		with: 'drillDown'
]

{ #category : #rendering }
CPPSArchitecturalVision >> renderVisuOn: html [

	| visu visuComponent |

	[ visu := self createVisuFromClass: self selectedVisuClass.
	self
		addMenuInteractionOn: visu
		with: html.
	visuComponent := (TLCytoscapeComponent visualization: visu)
		                 withPNGExport;
		                 yourself.
	self
		renderExternalTriggersOf: visu
		for: visuComponent
		on: html.
	html render: visuComponent
	]
		on: MessageNotUnderstood
		do:
			[ html mdlAlert
				beWarning;
				with: (self
						 translate: 'This visualization is not available yet for this technology'
						 french: 'Cette visualisation n''est pas encore disponible pour cette technologie ')
			]
]

{ #category : #accessing }
CPPSArchitecturalVision >> rightPanel [

	^ rightPanel
]

{ #category : #accessing }
CPPSArchitecturalVision >> rightPanel: aComponent [

	rightPanel := aComponent
]

{ #category : #accessing }
CPPSArchitecturalVision >> selectedVisuClass [

	^ selectedVisuClass ifNil: [ self allVisusClasses first ]
]

{ #category : #accessing }
CPPSArchitecturalVision >> selectedVisuClass: anObject [

	selectedVisuClass := anObject
]

{ #category : #components }
CPPSArchitecturalVision >> setDefaultRightPanel [

	self rightPanel: (CPPSArchitecturalVisionCodeRightPanel owner: self)
]

{ #category : #accessing }
CPPSArchitecturalVision >> toolbar [

	^ toolbar
]

{ #category : #accessing }
CPPSArchitecturalVision >> toolbar: aComponent [

	toolbar := aComponent
]
