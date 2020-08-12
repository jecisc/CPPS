"
Description
--------------------

I am a visualization used to help one to split an entity based on how other entities use it. 

I'll show each child of the entity to split and I'll display inside each users of the child. On a mouse over, I'll highligh the selected client in the other children.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	allChildrenCache:			<aCollection>	I am a cache used to store 
	clientsOfChildrenMap:		<aDictionary>

"
Class {
	#name : #CPPSClientsExplorerVisualization,
	#superclass : #CPPSSimpleClassSplitterVisualization,
	#instVars : [
		'allChildrenCache',
		'clientsOfChildrenMap'
	],
	#category : #'CPPS-Visualizations-Visualizations-ClassSplitter'
}

{ #category : #building }
CPPSClientsExplorerVisualization >> allChildrenCache [

	"This operation takes time so we cache them"

	^ allChildrenCache ifNil: [ allChildrenCache := self classToAnalyze allChildren ]
]

{ #category : #building }
CPPSClientsExplorerVisualization >> borderColorStrategy [

	^ FamixKindColorStrategy default
]

{ #category : #building }
CPPSClientsExplorerVisualization >> buildLegend [

	super buildLegend.
	self legend descriptionForWidth: (self translate: ('Number of local methods with this client.' french: 'Nombre de méthodes locales avec ce client')).
	self borderColorStrategy addBorderLegendToVisualization: self
]

{ #category : #building }
CPPSClientsExplorerVisualization >> buildVisualization [

	allChildrenCache := nil. "Invalidate caches at each building"
	clientsOfChildrenMap := IdentityDictionary new.
	super buildVisualization.
	(self > #class) styleSheet
		borderColor: [ :entity | self borderColorStrategy colorFor: entity ];
		borderWidth: 2;
		labelSize: 16.
	(self > #class) styleSheet > #children width: [ :client :node | 10 + (self allClassChildrenNodes select: [ :n | n entity = client ]) size ]
]

{ #category : #building }
CPPSClientsExplorerVisualization >> clientsOf: ent [

	^ clientsOfChildrenMap
		  at: ent
		  ifAbsentPut: [ (ent allClientsAtScope: CPPSType) \ { self classToAnalyze } ]
]

{ #category : #accessing }
CPPSClientsExplorerVisualization >> containedEntitiesOf: anEntity [

	^ self clientsOf: anEntity
]

{ #category : #accessing }
CPPSClientsExplorerVisualization >> entitiesToShow [

	^ self classToAnalyze children asOrderedCollection
]

{ #category : #building }
CPPSClientsExplorerVisualization >> popUpTextForNode: node withChild: client [

	^ String streamContents:
		  [ :s | 
		  | localEntitiesForClient externalEntitiesForClient |

		  localEntitiesForClient := self allClassChildrenNodes select: [ :n | n entity = client ].
		  externalEntitiesForClient := client allProviders reject: [ :ent | self allChildrenCache includes: ent ].
		  s
			  << '<div style=""> Information for client <strong>';
			  << client name;
			  << '</strong> of entity <strong>';
			  << node parentNode entity name;
			  << '</strong>: <br><br>';
			  << localEntitiesForClient size asString;
			  << ' local methods have ';
			  << client name;
			  << ' as client<br>';
			  << externalEntitiesForClient size asString;
			  << ' external entities have ';
			  << client name;
			  << ' as client. <br><br> Other local entities with this client:<br>'.
		  localEntitiesForClient size > 20
			  ifTrue:
				  [ (localEntitiesForClient first: 20)
					  do:
						  [ :each | 
						  s
							  nextPutAll: '- ';
							  nextPutAll: each parentNode entity name
						  ]
					  separatedBy: [ s nextPutAll: '<br>' ].
				  s
					  nextPutAll: '<br>And ';
					  nextPutAll: (localEntitiesForClient size - 20) asString;
					  nextPutAll: ' more...'
				  ]
			  ifFalse:
				  [ localEntitiesForClient
					  do:
						  [ :each | 
						  s
							  nextPutAll: '- ';
							  nextPutAll: each parentNode entity name
						  ]
					  separatedBy: [ s nextPutAll: '<br>' ]
				  ].
		  s << '</div>'
		  ]
]
