"
Description
--------------------

I am a panel that display a butterfly centered on the entity
"
Class {
	#name : #CPPSButterflyPanelComponent,
	#superclass : #CPPSEntityCentricPanelComponent,
	#category : #'CPPS-Toolkit-CodeAnalyzer-TabPanels'
}

{ #category : #title }
CPPSButterflyPanelComponent class >> panelTitle [

	^ 'Overview' french: 'Vue globale'
]

{ #category : #testing }
CPPSButterflyPanelComponent >> computeIsUseful [

	self entity ifNil: [ ^ false ].
	^ self entity allClients isNotEmpty or: [ self entity allProviders isNotEmpty ]
]

{ #category : #components }
CPPSButterflyPanelComponent >> defaultVisualizationComponent [

	| visu session |

	session := self session.
	visu := (CPPSButterflyVisualization mainEntity: self entity)
		        addInteraction: (TLSeasideCallBackAction block:
					         [ :aNode | 
					         self
						         displayBrowserClass: CPPSCodeAnalyzer
						         onEntity: aNode entity
					         ]) onClick propagateToChildren;
		        tagActionBlock:
			        [ :aNode | 
			        session currentTag ifNotNil: [ :tag | aNode entity toggleTag: tag ].
			        aNode requireUpdate
			        ];
		        yourself.
	visu language: self session language.
	^ (TLCytoscapeComponent visualization: visu)
		  withPNGExport;
		  yourself
]

{ #category : #rendering }
CPPSButterflyPanelComponent >> renderContentOn: html [

	html render: self defaultVisualizationComponent
]
