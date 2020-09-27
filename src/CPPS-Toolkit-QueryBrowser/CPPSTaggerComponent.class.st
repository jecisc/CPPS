"
Description
----------------

I am a component able to tag a list of entities with different tags.

Internal Representation and Key Implementation Points.
---------------
    Instance Variables
	tagListComponent:		<aComponent> 	The list of available tags to tag the selected entities.
"
Class {
	#name : #CPPSTaggerComponent,
	#superclass : #CPPSComponent,
	#traits : 'CPPSTQueryBrowserComponent',
	#classTraits : 'CPPSTQueryBrowserComponent classTrait',
	#instVars : [
		'tagListComponent'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #hooks }
CPPSTaggerComponent >> children [

	^ Array with: self tagListComponent
]

{ #category : #action }
CPPSTaggerComponent >> createTagNamed: aName [

	self tagSelectedEntitiesWith: (self tagModel tagNamed: (aName ifEmpty: [ 'unnamed' ]))
]

{ #category : #components }
CPPSTaggerComponent >> defaultListComponent [

	^ (CPPSTagListComponent
		   tags: [ self tagModel rootTags ]
		   actionBlock: [ :tag | self tagSelectedEntitiesWith: tag ]
		   actionTooltipBlock:
			   [ :tag | 
			   (self
				    english: 'Tag the selected entities with: '
				    french: 'Tagger les entités selectionnées avec: ') , tag name
			   ]
		   actionLabelBlock:
			   [ :tag | 
			   self selectedEntities
				   detect: [ :entity | (entity isTaggedWith: tag) not ]
				   ifFound:
					   [ self selectedEntities
						   detect: [ :en | en isTaggedWith: tag ]
						   ifFound: [ #more ]
						   ifNone: [ #label_outline ]
					   ]
				   ifNone: [ #label ]
			   ])
		  shouldRefreshPage: true;
		  yourself
]

{ #category : #initialization }
CPPSTaggerComponent >> initialize [

	super initialize.
	self tagListComponent: self defaultListComponent
]

{ #category : #components }
CPPSTaggerComponent >> refreshRightPanelDoing: aBlock on: html [

	^ self owner
		  refreshRightPanelDoing: aBlock
		  on: html
]

{ #category : #rendering }
CPPSTaggerComponent >> renderButtonsOn: html [

	html div
		class: 'button-bar';
		style: 'justify-content: flex-start;';
		with:
			[ html mdlMajorButton
				onClick: (self
						 refreshRightPanelDoing: [ self call: self tagCreatorComponent ]
						 on: html);
				with: (self
						 english: 'New Tag'
						 french: 'Nouveau Tag').
			html space.
			html mdlButton
				onClick: (self
						 refreshRightPanelDoing: [ self answer ]
						 on: html);
				disabled: false;
				with: (self
						 english: 'Return'
						 french: 'Retour')
			]
]

{ #category : #rendering }
CPPSTaggerComponent >> renderContentOn: html [

	html div
		class: 'query-tagger';
		with:
			[ html headerContainer:
					[ html headline: (self
								 english: 'Tag entities'
								 french: 'Tagger les entités')
					].
			self renderButtonsOn: html.
			html div
				class: 'query-tagger-list';
				with: [ html render: self tagListComponent ].
			self renderLabelsLegendOn: html
			]
]

{ #category : #rendering }
CPPSTaggerComponent >> renderLabelsLegendOn: html [

	| entries |

	entries := OrderedDictionary
		           with: #label_outline -> (self
				            english: 'No entity tagged'
				            french: 'Pas d''entité taggée')
		           with: #more -> (self
				            english: 'Some entities already tagged'
				            french: 'Certaines entitées déjà taggées')
		           with: #label -> (self
				            english: 'All entities already tagged'
				            french: 'Toutes les entitées sont déjà taggées').
	html div
		class: #'query-tagger-legend';
		with:
			[ html div: 'Legend: '.
			entries keysAndValuesDo:
					[ :label :text | 
					html div:
							[ html mdlIcon: label.
							html text: text
							]
					]
			]
]

{ #category : #components }
CPPSTaggerComponent >> tagCreatorComponent [

	| comp |

	^ (comp := CPPSTagCreatorComponent new)
		  ajaxSubmitBlock:
			  [ :r | 
			  self
				  refreshRightPanelDoing: [ comp answer ]
				  on: r
			  ];
		  customButtonBlock:
			  [ :r | 
			  r space.
			  r mdlButton
				  bePush;
				  onClick: (self
						   refreshRightPanelDoing: [ comp answer ]
						   on: r);
				  with: (self
						   english: 'Cancel'
						   french: 'Annuler')
			  ];
		  yourself
]

{ #category : #accessing }
CPPSTaggerComponent >> tagListComponent [

	^ tagListComponent
]

{ #category : #accessing }
CPPSTaggerComponent >> tagListComponent: anObject [

	tagListComponent := anObject
]

{ #category : #action }
CPPSTaggerComponent >> tagSelectedEntitiesWith: aTag [

	^ self selectedEntities do: [ :entity | entity tagWith: aTag ]
]
