Class {
	#name : #CPPSBlockPanelComponent,
	#superclass : #CPPSEntityCentricPanelComponent,
	#instVars : [
		'visu',
		'entityClicked',
		'visuId'
	],
	#category : #'CPPS-Toolkit-CodeAnalyzer-TabPanels'
}

{ #category : #testing }
CPPSBlockPanelComponent >> computeIsUseful [

	self entity ifNil: [ ^ false ].
	^ self entity allClients isNotEmpty or: [ self entity allProviders isNotEmpty ]
]

{ #category : #components }
CPPSBlockPanelComponent >> defaultVisualization [

	^ CPPSDependenciesExplorerVisualization
]

{ #category : #accessing }
CPPSBlockPanelComponent >> entityClicked [

	^ entityClicked
]

{ #category : #accessing }
CPPSBlockPanelComponent >> entityClicked: anObject [

	entityClicked := anObject
]

{ #category : #components }
CPPSBlockPanelComponent >> exportComponent [

	^ CPPSVisualizationExporter new visu: self visualization
]

{ #category : #components }
CPPSBlockPanelComponent >> exportComponent: aVisualization [

	^ CPPSVisualizationExporter new visu: aVisualization
]

{ #category : #title }
CPPSBlockPanelComponent >> panelTitle [

	^ 'block and methods of' french: 'block et methode de '
]

{ #category : #rendering }
CPPSBlockPanelComponent >> renderContentOn: html [

	| visuComp |

	visuComp := self visualizationComponent: html.
	html render: (self exportComponent: visuComp visualization).
	html render: visuComp
]

{ #category : #rendering }
CPPSBlockPanelComponent >> renderCytoscapeFilters: html [

	html render: (CPPSTLEntitiesFiltersComponent new
			 visuId: visuId;
			 addDecoration: (CPPSTitleDecoration entitled: (self
							   english: 'Filter Blocks'
							   french: 'Filtrer les blocs')))
]

{ #category : #rendering }
CPPSBlockPanelComponent >> renderRigthPanelAsCodeComponent: html [

	html div
		class: 'code-analyzer-block-panel';
		with:
			[ html div
				class: 'code-analyzer-filter';
				with: [ self renderCytoscapeFilters: html ].
			html div
				class: 'code-analyzer-right-panel_code';
				with:
					[ html render: (PrismComponent new
								 sourceCode: [ self entityClicked sourceText ];
								 language: self strategy languageClass;
								 addDecoration: (CPPSTitleDecoration entitled: (self
												   english: 'Entity''s code'
												   french: 'Code de l''entité'));
								 yourself)
					]
			].
	html script: 'initPrismComponents(); componentHandler.upgradeDom();' js
]

{ #category : #components }
CPPSBlockPanelComponent >> visualization [

	^ visu ifNil: [ visu := self defaultVisualization ]
]

{ #category : #components }
CPPSBlockPanelComponent >> visualization: aVisuClass [

	^ visu := aVisuClass
]

{ #category : #components }
CPPSBlockPanelComponent >> visualizationComponent: html [

	| session ajaxInteraction |

	ajaxInteraction := ((TLSeasideAJAXCallBackAction
		                     callback: [ self renderRigthPanelAsCodeComponent: html ]
		                     forElement: '#code-analyzer-right-panel__content'
		                     on: html)
		                    beforeBlock: [ :node :entity | self entityClicked: entity ];
		                    withMenu: (self
				                     translate: 'Show code'
				                     french: 'Afficher le code')) propagateToChildren.
	session := self session.
	visuId := TLCytoscapeComponent nextId.
	^ (TLCytoscapeComponent
		   visualization: (self visualization new
				    language: self session language;
				    elementsToAnalyze: self entity;
				    currentTag: [ session currentTag ];
				    addInteraction: ajaxInteraction;
				    yourself)
		   id: visuId)
		  withPNGExport;
		  yourself
]
