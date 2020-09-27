"
Description
--------------------

I am a panel that display a quick tagging visualization for the entity (that has attributes)
"
Class {
	#name : #CPPSQuickTaggingPanelComponent,
	#superclass : #CPPSEntityCentricPanelComponent,
	#category : #'CPPS-Toolkit-CodeAnalyzer-TabPanels'
}

{ #category : #title }
CPPSQuickTaggingPanelComponent class >> panelTitle [

	^ 'Quick Tagging' french: 'Tagging Rapide'
]

{ #category : #testing }
CPPSQuickTaggingPanelComponent >> computeIsUseful [

	self entity ifNil: [ ^ false ].
	^ self entity dataEntitiesForQuickTagging isNotEmpty and: [ self entity dataAccessorsForQuickTagging isNotEmpty ]
]

{ #category : #rendering }
CPPSQuickTaggingPanelComponent >> renderContentOn: html [

	| userSession |

	userSession := self session.
	html render: ((TLCytoscapeComponent visualization: ((CPPSQuickAttributeTaggingVisualization entity: self entity)
					   addInteraction: ((TLSeasideCallBackAction block:
								     [ :aNode | 
								     self
									     displayBrowserClass: CPPSCodeAnalyzer
									     onEntity: aNode entity
								     ]) withMenu: 'Open the Code Analyzer on it') propagateToChildren;
					   tagActionBlock:
						   [ :aNode | 
						   userSession currentTag ifNotNil:
								   [ :tag | 
								   (aNode entity isTaggedWith: tag)
									   ifTrue:
										   [ "means that the entity is already tagged with the current tag.
									actions is to untag the entity" aNode entity removeTags ]
									   ifFalse:
										   [ "means that the entity is not yet tagged with the current tag.
									actions is to tag the entity"
										   aNode entity removeTags.
										   aNode entity tagWith: tag
										   ]
								   ]
						   ]))
			 withPNGExport;
			 yourself)
]
