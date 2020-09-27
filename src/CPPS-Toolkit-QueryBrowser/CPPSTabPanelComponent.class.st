"
Description
-------------------

I am a component to show a collection of components as a tab panel. 

I take as entry point a collection of CPPSPanelStrategy. I will use those strategies to display the tab and create the components.

I will also keep a reference of the active tab to display the right tab if the page is refresh.

Maybe later I should be improved and move to the core package if other browsers need me.

Public API and Key Messages
-------------------

- #isActiveTabFor: aStrategy 		Return true if the strategy in parameter is the active one.
- #updateActiveTabIfNecessary 	Sometimes the active tab cannot be access anymore (for exemple the tab don't match the display requirement anymore). In that case this method will reset the active tab.

Example
-----------------
		
		| tabPanelStrategies |
		tabPanelStrategies := OrderedCollection new
		add:
				(CPPSPanelStrategy
						id: #queries
						icon: #search
						label: ('Queries' french: 'Requêtes')
						componentClass: CPPSQueriesManagerComponent);
		add:
				(CPPSPanelStrategy
						id: 'select'
						icon: #playlist_add_check
						label: ('Select and Act' french: 'Selectionnez et Agissez')
						componentClass: CPPSQueryResultManagerComponent
						shouldBeDisplayBlock: [ self isAtRoot not ]);
		yourself.
		 
		CPPSTabPanelComponent tabStrategies:  tabPanelStrategies owner: self

Internal Representation and Key Implementation Points.
----------------

    Instance Variables
	activeTab:			<aStrategy>						I am the currently active tab of the component.
	owner:					<aComponent>						I am the owner of the tabPanelComponent
	tabStrategies: 		<aCollectionOfStrategies> 	I am the collection of Strategies to display in the component

"
Class {
	#name : #CPPSTabPanelComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'owner',
		'tabStrategies',
		'activeTabStrategy'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-PanelComponent'
}

{ #category : #'instance creation' }
CPPSTabPanelComponent class >> tabStrategies: aCollectionOfStrategy owner: aComponent [

	^ self new
		  owner: aComponent;
		  tabStrategies: aCollectionOfStrategy;
		  yourself
]

{ #category : #accessing }
CPPSTabPanelComponent >> activeTab [

	^ self activeTabStrategy component
]

{ #category : #accessing }
CPPSTabPanelComponent >> activeTabStrategy [

	^ activeTabStrategy
]

{ #category : #accessing }
CPPSTabPanelComponent >> activeTabStrategy: anObject [

	activeTabStrategy := anObject
]

{ #category : #testing }
CPPSTabPanelComponent >> isActiveTabStrategyFor: aStrategy [

	^ aStrategy = self activeTabStrategy
]

{ #category : #accessing }
CPPSTabPanelComponent >> owner [

	^ owner
]

{ #category : #accessing }
CPPSTabPanelComponent >> owner: anObject [

	owner := anObject
]

{ #category : #rendering }
CPPSTabPanelComponent >> renderActiveComponentOn: html [

	html render: (self activeTabStrategy componentFor: [ self owner ])
]

{ #category : #rendering }
CPPSTabPanelComponent >> renderContentOn: html [

	| id |

	id := html nextId.
	self updateActiveTabIfNecessary.
	html div
		class: #tabPanel;
		id: #tabTagPanel;
		with:
			[ self
				renderTabOn: html
				withId: id
			]
]

{ #category : #rendering }
CPPSTabPanelComponent >> renderHeaderTabFor: aStrategy withId: id on: html [

	html mdlTab
		url: '#content' , id;
		"This is here just to avoid javascript error with the MDL tab widget"isActiveIf: (self isActiveTabStrategyFor: aStrategy);
		onClick: ((html jQuery id: #tabTagPanel) load
				 html:
					 [ :r | 
					 self activeTabStrategy: aStrategy.
					 self
						 renderTabOn: r
						 withId: id
					 ];
				 onComplete: 'componentHandler.upgradeDom()');
		onClick: aStrategy onClickHook
		if: aStrategy onClickHook isNotNil;
		with:
			[ html paragraph: [ html mdlIcon: aStrategy icon ].
			html text: (self translate: aStrategy label)
			]
]

{ #category : #rendering }
CPPSTabPanelComponent >> renderTabContentWithId: id on: html [

	html mdlTabsPanel
		isActive;
		id: 'content' , id;
		with: [ self renderActiveComponentOn: html ]
]

{ #category : #rendering }
CPPSTabPanelComponent >> renderTabOn: html withId: id [

	^ html mdlTabs
		  rippleEffect;
		  with:
			  [ | stratToDisplay |

			  stratToDisplay := self tabStrategies select: #shouldBeDisplay.
			  html mdlTabBar:
					  [ stratToDisplay do:
							  [ :strat | 
							  self
								  renderHeaderTabFor: strat
								  withId: id
								  on: html
							  ]
					  ].
			  self
				  renderTabContentWithId: id
				  on: html
			  ]
]

{ #category : #accessing }
CPPSTabPanelComponent >> tabStrategies [

	^ tabStrategies
]

{ #category : #accessing }
CPPSTabPanelComponent >> tabStrategies: anObject [

	tabStrategies := anObject
]

{ #category : #updating }
CPPSTabPanelComponent >> updateActiveTabIfNecessary [

	(self activeTabStrategy isNil or: [ self activeTabStrategy shouldBeDisplay not ]) ifTrue:
		[ self activeTabStrategy: (self tabStrategies
				 detect: [ :strat | strat shouldBeDisplay ]
				 ifNone: [ nil ])
		]
]
