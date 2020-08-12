"
Description
--------------------

This visualization provides a map for the system entities. Each entity is shown with its default color which may be superseded by annotated colors (dead, duplicated, etc.). Height of the entity's shape is the number of outgoing links and width of the entity's shape is the number of incoming links.
"
Class {
	#name : #CPPSSystemOverviewVisualization,
	#superclass : #CPPSVisualization,
	#instVars : [
		'mapEntities',
		'callback'
	],
	#category : #'CPPS-Visualizations-Visualizations-Executive'
}

{ #category : #building }
CPPSSystemOverviewVisualization >> backgroundColorStrategy [

	^ FamixColorStrategy stateThenKindStrategy
]

{ #category : #building }
CPPSSystemOverviewVisualization >> buildLegend [

	self legend
		descriptionForHeight: (self translate: ('Proportional to my dependencies number' french: 'Proportionnel au nombre de mes dépendances'));
		descriptionForWidth: (self translate: ('Proportional to entities depending on me' french: 'Proportionnel aux entités dépendantes de moi')).
	self backgroundColorStrategy addBackgroundLegendToVisualization: self
]

{ #category : #building }
CPPSSystemOverviewVisualization >> buildVisualization [

	| strategy |

	super buildVisualization.
	strategy := self backgroundColorStrategy.
	self styleSheet
		width: [ :aProgram | aProgram allClients size + 10 ];
		height: [ :aProgram | aProgram allProviders size + 10 ];
		backgroundColor: [ :entity1 | strategy colorFor: entity1 ].
	(self > #default)
		addNodesFromEntities: self mapEntities;
		layout: (TLLinearLayout
				 gap: 3
				 ratio: 16 / 9);
		addInteraction: (TLPopUpAction text: [ :entity | entity tooltipIn: self language ]) onMouseOver.
	self > #default addInteraction: (TLSeasideCallBackAction block: self callback) onClick
]

{ #category : #accessing }
CPPSSystemOverviewVisualization >> callback [

	^ callback
]

{ #category : #accessing }
CPPSSystemOverviewVisualization >> callback: anObject [

	callback := anObject
]

{ #category : #default }
CPPSSystemOverviewVisualization >> defaultTitle [

	^ 'System Complexity'
]

{ #category : #accessing }
CPPSSystemOverviewVisualization >> mapEntities [

	^ mapEntities
]

{ #category : #accessing }
CPPSSystemOverviewVisualization >> mapEntities: anObject [

	mapEntities := anObject
]
