"
Description
----------------

I am a component whose goal is to allow the user to select a subset of the current query result and to act on that subset. The action can be a export of the entities or a group tagging.
 
Internal Representation and Key Implementation Points.
---------------

    Instance Variables
	tableComponent:		<aComponent>	This component has for goal to display the list of entities in the current query result and to let the user select some.

"
Class {
	#name : #CPPSQueryBrowserActRightPanel,
	#superclass : #CPPSQueryBrowserRightPanel,
	#instVars : [
		'tableComponent'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #testing }
CPPSQueryBrowserActRightPanel class >> shouldBeExtended [

	^ true
]

{ #category : #hooks }
CPPSQueryBrowserActRightPanel >> children [

	^ Array with: self tableComponent
]

{ #category : #rendering }
CPPSQueryBrowserActRightPanel >> defaultTableComponent [

	^ MDLSortableTable new
		  header: { 
				  (self
					   english: 'Name'
					   french: 'Nom').
				  (self
					   english: 'Tags'
					   french: 'Tags').
				  (self
					   english: 'Parent'
					   french: 'Parent').
				  'Selection' };
		  rows:
			  [ (self queryResult collect:
					   [ :entity | 
					   { 
						   entity name.
						   (CPPSEntityTagsCell entity: entity).
						   (entity belongsTo
							    ifNotNil: #name
							    ifNil: [ 'No parent' ]).
						   [ :canvas | 
						   self
							   renderCheckboxFor: entity
							   on: canvas
						   ] }
					   ]) asOrderedCollection
			  ];
		  rowsPerPagePossibilities: #( 10 50 100 200 )
]

{ #category : #rendering }
CPPSQueryBrowserActRightPanel >> deselectEntity: entity [

	(self selectedEntities includes: entity) ifTrue: [ self selectedEntities remove: entity ]
]

{ #category : #initialization }
CPPSQueryBrowserActRightPanel >> initialize [

	super initialize.
	self tableComponent: self defaultTableComponent
]

{ #category : #javascript }
CPPSQueryBrowserActRightPanel >> refreshRightPanelDoing: aBlock on: html [

	^ html jQuery ajax
		  callback: aBlock;
		  onComplete: ((html jQuery id: self owner rightPanelId) load
				   html: [ :r | r render: self owner rightPanel ];
				   onComplete: 'componentHandler.upgradeDom();')
]

{ #category : #rendering }
CPPSQueryBrowserActRightPanel >> renderCheckboxFor: entity on: html [

	html mdlCheckboxContainer
		for: html nextId;
		with:
			[ html mdlCheckbox
				id: html lastId;
				callback:
					[ :checked | 
					checked
						ifTrue: [ self selectEntity: entity ]
						ifFalse: [ self deselectEntity: entity ]
					];
				onClick: html jQuery ajax serializeThisWithHidden;
				value: (self selectedEntities includes: entity)
			]
]

{ #category : #rendering }
CPPSQueryBrowserActRightPanel >> renderContentOn: html [

	html form
		class: #'query-browser__table';
		with:
			[ html headerContainer:
					[ html headline: (self
								 english: 'Select entities and act'
								 french: 'Sélectionnez les entités et agissez')
					].
			html render: self tableComponent.
			self renderToolbarOn: html
			]
]

{ #category : #rendering }
CPPSQueryBrowserActRightPanel >> renderToolbarOn: html [

	html div
		class: 'table-toolbar';
		with:
			[ html div
				pullRight;
				with:
					[ html mdlButton
						bePush;
						onClick: (html jQuery ajax
								 callback: [ self selectedEntities: self queryResult asOrderedCollection ];
								 onComplete: 'location.reload();' js);
						with: (self
								 english: 'Select All'
								 french: 'Tout selectionner').
					html space.
					html mdlButton
						bePush;
						onClick: (html jQuery ajax
								 callback: [ self selectedEntities removeAll ];
								 onComplete: 'location.reload();' js);
						with: (self
								 english: 'Deselect All'
								 french: 'Tout deselectionner')
					].
			html div
				pullLeft;
				with:
					[ html mdlMajorButton
						bePush;
						onClick: (self
								 refreshRightPanelDoing: [ self call: (CPPSTaggerComponent owner: self) ]
								 on: html);
						with: (self
								 english: 'Tag Entities'
								 french: 'Taggez vos Entités').
					html space.
					html mdlMajorButton
						bePush;
						onClick: (self
								 refreshRightPanelDoing: [ self call: (CPPSCSVExportComponent owner: self) ]
								 on: html);
						with: (self
								 english: 'CSV Export'
								 french: 'Export CSV')
					]
			]
]

{ #category : #rendering }
CPPSQueryBrowserActRightPanel >> selectEntity: entity [

	(self selectedEntities includes: entity) ifFalse: [ self selectedEntities add: entity ]
]

{ #category : #accessing }
CPPSQueryBrowserActRightPanel >> tableComponent [

	^ tableComponent
]

{ #category : #accessing }
CPPSQueryBrowserActRightPanel >> tableComponent: anObject [

	tableComponent := anObject
]
