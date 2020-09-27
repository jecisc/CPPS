"
Description
----------------

I am a component whose goal is to display to the user the current queries he has. With those queries he can apply them on delete them.
 
Internal Representation and Key Implementation Points.
---------------

    Instance Variables
	queriesList:		<aComponent>	A component holding and displaying the list of the queries. 

"
Class {
	#name : #CPPSQueryBrowserQueriesRightPanel,
	#superclass : #CPPSQueryBrowserRightPanel,
	#instVars : [
		'queriesList'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #hooks }
CPPSQueryBrowserQueriesRightPanel >> children [

	^ Array with: self queriesList
]

{ #category : #components }
CPPSQueryBrowserQueriesRightPanel >> defaultQueriesList [

	^ (MDLNestedList elements: [ self queries ])
		  format: #displayName;
		  iconBlock: [ :query :html | html mdlListIcon: query class mdlIconName ];
		  rightIconBlock:
			  [ :query :html | 
			  self
				  renderActionsFor: query
				  on: html
			  ];
		  withResearchField;
		  filterPseudoRegex;
		  beCompact;
		  yourself
]

{ #category : #initialization }
CPPSQueryBrowserQueriesRightPanel >> initialize [

	super initialize.
	self queriesList: self defaultQueriesList
]

{ #category : #accessing }
CPPSQueryBrowserQueriesRightPanel >> queriesList [

	^ queriesList
]

{ #category : #accessing }
CPPSQueryBrowserQueriesRightPanel >> queriesList: anObject [

	queriesList := anObject
]

{ #category : #rendering }
CPPSQueryBrowserQueriesRightPanel >> renderActionsFor: aQuery on: html [

	html div
		class: #'query-query-list__actions';
		with:
			[ self
				renderApplyQueryFor: aQuery
				on: html;
				renderDeleteFor: aQuery
				on: html
			]
]

{ #category : #rendering }
CPPSQueryBrowserQueriesRightPanel >> renderApplyQueryFor: aQuery on: html [

	html anchor
		callback: [ self useQuery: aQuery ];
		with:
			[ html mdlIcon
				class: #'mdl-button--accent';
				with: #redo
			]
]

{ #category : #rendering }
CPPSQueryBrowserQueriesRightPanel >> renderContentOn: html [

	self queries
		ifEmpty:
			[ html div
				class: #'text-center';
				style: 'margin: auto;';
				with:
					[ html mdlAlert
						beInfo;
						with: (self
								 english: 'You have 0 saved query.'
								 french: 'Vous avez 0 requête sauvée.')
					]
			]
		ifNotEmpty: [ :qs | html render: self queriesList ]
]

{ #category : #rendering }
CPPSQueryBrowserQueriesRightPanel >> renderDeleteFor: aQuery on: html [

	self flag: #todo. "Modal to ask what to do."
	html anchor
		callback: [ self queryStorage remove: aQuery ];
		with:
			[ html mdlIcon
				class: #delete;
				with: #delete_forever
			]
]
