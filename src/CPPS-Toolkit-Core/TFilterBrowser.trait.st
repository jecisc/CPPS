"
Description
--------------------

I am a Trait for browsers that needs to display a list of entities and to filter those
"
Trait {
	#name : #TFilterBrowser,
	#instVars : [
		'tree',
		'filterComponent'
	],
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #accessing }
TFilterBrowser >> browserClass [

	"An html class to distinguish the browser for the css"

	^ self explicitRequirement
]

{ #category : #components }
TFilterBrowser >> defaultFilterComponent [

	^ CPPSNavigationComponent
		  actionOnUpdate:
			  [ :entities | 
			  self tree elements: entities.
			  entities ifNotEmpty: [ self selectedEntity: entities first ]
			  ]
		  idOfImpactedList: self filterBrowserTreeId
		  ajaxBlock: [ :html | self renderTreeOn: html ]
]

{ #category : #components }
TFilterBrowser >> defaultTreeComponent [

	^ (MDLNestedList
		   elements: #(  )
		   children: [ :entity | entity children asOrderedCollection ])
		  format: #name;
		  withResearchField;
		  filterInsensitiveSubstring;
		  childrenSortBlock: [ :child1 :child2 | child1 hasPriorityOn: child2 ];
		  actionBlock: [ :entity | self selectedEntity: entity ];
		  iconBlock: #iconComponent;
		  helpBlock:
			  [ :entity :html | 
			  [ html html: (entity
						   tooltipNameIn: self session language
						   forModel: self model)
			  ]
			  ];
		  beCompact;
		  addDecoration: (CPPSTitleDecoration
				   entitled: (self
						    english: 'Entities matching filters'
						    french: 'Entités filtrées')
				   badgeBlock: [ self tree elements size ]);
		  yourself
]

{ #category : #accessing }
TFilterBrowser >> filterBrowserTreeId [

	^ #'filter-browser-tree'
]

{ #category : #accessing }
TFilterBrowser >> filterComponent [

	^ filterComponent
]

{ #category : #accessing }
TFilterBrowser >> filterComponent: anObject [

	filterComponent := anObject
]

{ #category : #hook }
TFilterBrowser >> hookBeforeRendering [

	"By default I do nothing"

	
]

{ #category : #initialization }
TFilterBrowser >> initializeFilterBrowser [

	self tree: self defaultTreeComponent.
	self filterComponent: self defaultFilterComponent
]

{ #category : #rendering }
TFilterBrowser >> renderBrowserContentOn: html [

	self explicitRequirement
]

{ #category : #rendering }
TFilterBrowser >> renderContentOn: html [

	self hookBeforeRendering.
	html div
		class: #'filter-browser';
		class: self browserClass;
		with:
			[ html render: self filterComponent.
			html div
				class: #'filter-browser-core';
				class: #toFoldContainer;
				with:
					[ html leftPanel
						id: self filterBrowserTreeId;
						with: [ self renderTreeOn: html ].
					self renderBrowserContentOn: html
					]
			]
]

{ #category : #rendering }
TFilterBrowser >> renderTreeOn: html [

	html
		render: self tree;
		leftPanelResizer
]

{ #category : #accessing }
TFilterBrowser >> selectedEntity [

	^ self tree selectedEntity
]

{ #category : #accessing }
TFilterBrowser >> selectedEntity: anEntity [

	self tree selectedEntity: anEntity
]

{ #category : #accessing }
TFilterBrowser >> tree [

	^ tree
]

{ #category : #accessing }
TFilterBrowser >> tree: anObject [

	tree := anObject
]
