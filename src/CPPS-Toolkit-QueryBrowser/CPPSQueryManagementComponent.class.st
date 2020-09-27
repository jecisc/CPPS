"
Description
----------------

I am a complexe component managing all the second phase of the query. After the seed is selected I allow the user to make some queries of the seed and to act on the result of this query. 
 
Internal Representation and Key Implementation Points.
----------------

    Instance Variables
	queriesPanel:				<aComponent> 	This component allow the user to create a apply new atomic queries.
	resultList:					<aComponent>	This component is a list displaying the current result of the query the user is creating.
	rightPanelComponent:		<aComponent>	This component render some panels the user can user to list his queries, tag the current result, filter his result from the entities names…
	toolbar:						<aComponent> 	This component is a toolbar allowing to change the right panel and allowing to fold the right panel.

"
Class {
	#name : #CPPSQueryManagementComponent,
	#superclass : #CPPSComponent,
	#traits : 'TRightTabsPanelBrowser + CPPSTQueryBrowserComponent',
	#classTraits : 'TRightTabsPanelBrowser classTrait + CPPSTQueryBrowserComponent classTrait',
	#instVars : [
		'resultList',
		'toolbar',
		'rightPanel',
		'id',
		'groupByContainer'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #accessing }
CPPSQueryManagementComponent >> browserClass [

	^ #'query-manager'
]

{ #category : #hooks }
CPPSQueryManagementComponent >> children [

	^ Array
		  with: self resultList
		  with: self queriesPanel
		  with: self toolbar
		  with: self rightPanel
]

{ #category : #components }
CPPSQueryManagementComponent >> defaultResultList [

	^ (MDLNestedList elements: [ self queryResult ])
		  format: #name;
		  helpBlock: [ :entity | entity tooltipIn: self session language ];
		  iconBlock: #iconComponent;
		  addDecoration: (CPPSTitleDecoration
				   entitled: (self
						    english: 'Query Result'
						    french: 'Résultat de la Requête')
				   badgeBlock: [ self queryResult size ]);
		  beCompact;
		  yourself
]

{ #category : #rendering }
CPPSQueryManagementComponent >> defaultToolbar [

	^ MDLVerticalToolbar buttons: { 
			  (MDLFoldButton
				   for: '#' , self rightPanelId
				   onComplete: 'if($(".query-manager-content").css("display") == "none"){ $("#filter-button").children().click(); }').
			  (self
				   switcherButton: (self
						    english: 'Filter'
						    french: 'Filtre')
				   id: #'filter-button'
				   tooltip: (self
						    english: 'Show the list of entities with the possibility to filter them by name.'
						    french: 'Afficher les entitées avec la possibilité de les filtrer par leur nom.')
				   perform: #setDefaultRightPanel
				   onCompleteHook: 'shrinkQueryRightPanel();initQueryBrowserFilter();').
			  (self
				   switcherButton: (self
						    english: 'Queries'
						    french: 'Requêtes')
				   tooltip: (self
						    english: 'List of saved queries.'
						    french: 'Liste des requêtes sauvées.')
				   perform: #setQueriesPanel
				   onCompleteHook: 'shrinkQueryRightPanel();').
			  (self
				   switcherButton: (self
						    english: 'Act'
						    french: 'Agir')
				   tooltip: (self
						    english: 'Act on the current selection.'
						    french: 'Agir sur le résultat courant.')
				   perform: #setActPanel
				   onCompleteHook: 'extendQueryRightPanel();') } , (self strategy allowToCreateQueryInPharo
			   ifTrue:
				   [ { (self
					    switcherButton: 'Code'
					    tooltip: (self
							     english: 'See code of the query.'
							     french: 'Voir le code de la requête.')
					    perform: #setQueryCodePanel
					    onCompleteHook: 'extendQueryRightPanel(); initPrismComponents();') }
				   ]
			   ifFalse: [ {  } ])
]

{ #category : #deletion }
CPPSQueryManagementComponent >> deleteFocusedQuery [

	self owner deleteFocusedQuery
]

{ #category : #initialization }
CPPSQueryManagementComponent >> initialize [

	super initialize.
	self resultList: self defaultResultList.
	self initializeRightPanel.
	groupByContainer := false
]

{ #category : #accessing }
CPPSQueryManagementComponent >> queriesPanel [

	^ self focusedQuery propertyComponent owner: self
]

{ #category : #rendering }
CPPSQueryManagementComponent >> renderContentOn: html [

	html div
		class: self browserClass;
		class: 'right-panel__extended'
		if: self rightPanel shouldBeExtended;
		class: #'grey-background';
		with:
			[ html leftPanel: [ self renderQueryResultOn: html ].
			html div
				class: self browserClass , '-content';
				with: [ html render: self queriesPanel ].
			self renderRightPanelOn: html
			]
]

{ #category : #rendering }
CPPSQueryManagementComponent >> renderListOn: html [

	html render: self resultList
]

{ #category : #rendering }
CPPSQueryManagementComponent >> renderQueryResultHeaderOn: html [

	html mdlCheckboxContainer
		rippleEffect;
		for: html nextId;
		style: 'margin: auto 10px';
		with:
			[ html mdlCheckbox
				noAutocomplete;
				id: html lastId;
				value: groupByContainer;
				onClick: ((html jQuery id: id) load
						 html:
							 [ :h | 
							 groupByContainer := groupByContainer not.
							 groupByContainer
								 ifTrue:
									 [ | displayCacheElement |

									 displayCacheElement := self queryResult groupedBy: [ :entity | entity parents anyOne ].
									 resultList
										 elements: [ displayCacheElement keys ];
										 children:
											 [ :ent | 
											 displayCacheElement
												 at: ent
												 ifAbsent: #(  )
											 ]
									 ]
								 ifFalse: [ resultList elements: [ self queryResult ] ].
							 self renderListOn: h
							 ];
						 onComplete: 'componentHandler.upgradeDom();').
			html mdlCheckboxLabel with: 'Group by container'
			]
]

{ #category : #rendering }
CPPSQueryManagementComponent >> renderQueryResultOn: html [

	id := html nextId.
	self renderQueryResultHeaderOn: html.
	html div
		id: id;
		style: 'height: calc(100% - 24px); overflow: auto;';
		with: [ self renderListOn: html ].
	html leftPanelResizer
]

{ #category : #accessing }
CPPSQueryManagementComponent >> resultList [

	^ resultList
]

{ #category : #accessing }
CPPSQueryManagementComponent >> resultList: anObject [

	resultList := anObject
]

{ #category : #accessing }
CPPSQueryManagementComponent >> rightPanel [

	^ rightPanel
]

{ #category : #accessing }
CPPSQueryManagementComponent >> rightPanel: aComponent [

	rightPanel := aComponent
]

{ #category : #initialization }
CPPSQueryManagementComponent >> setActPanel [

	self rightPanel: (CPPSQueryBrowserActRightPanel owner: self)
]

{ #category : #components }
CPPSQueryManagementComponent >> setDefaultRightPanel [

	self rightPanel: ((CPPSQueryBrowserSelectionListRightPanel owner: self)
			 addDecoration: (CPPSTitleDecoration entitled: (self
							   english: 'Result'
							   french: 'Résultat'));
			 yourself)
]

{ #category : #initialization }
CPPSQueryManagementComponent >> setQueriesPanel [

	self rightPanel: ((CPPSQueryBrowserQueriesRightPanel owner: self)
			 addDecoration: (CPPSTitleDecoration entitled: (self
							   english: 'Saved Queries'
							   french: 'Requêtes Sauvées'));
			 yourself)
]

{ #category : #initialization }
CPPSQueryManagementComponent >> setQueryCodePanel [

	self rightPanel: ((CPPSQueryCodeRightPanel owner: self)
			 addDecoration: (CPPSTitleDecoration entitled: 'Code');
			 yourself)
]

{ #category : #accessing }
CPPSQueryManagementComponent >> toolbar [

	^ toolbar
]

{ #category : #accessing }
CPPSQueryManagementComponent >> toolbar: aComponent [

	toolbar := aComponent
]
