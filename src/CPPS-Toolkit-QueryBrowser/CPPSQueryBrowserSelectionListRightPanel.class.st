"
Description
----------------

I am a component allowing the user to filter his query result with a filter of the name of the entities. 
I will display a list with a search field. If the user is satisfied with a filter he can save it as a query.
 
Internal Representation and Key Implementation Points.
---------------

    Instance Variables
	selectionList:		<aComponent> 	The list of entities filtered from the query result. If there is no filter then I display the query result.
"
Class {
	#name : #CPPSQueryBrowserSelectionListRightPanel,
	#superclass : #CPPSQueryBrowserRightPanel,
	#instVars : [
		'selectionList'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #hooks }
CPPSQueryBrowserSelectionListRightPanel >> children [

	^ Array with: self selectionList
]

{ #category : #components }
CPPSQueryBrowserSelectionListRightPanel >> defaultSelectionList [

	^ (MDLNestedList elements: [ self queryResult ])
		  format: [ :entity | entity name ];
		  helpBlock: [ :entity | entity tooltipIn: self session language ];
		  iconBlock: #iconComponent;
		  entryCustomizationHook: [ :div | div onClick: 'setNestedListFilterWithContentOfEntry("researchFieldIdlistFilter",this)' js ];
		  withResearchField;
		  filterPseudoRegex;
		  id: 'listFilter';
		  beCompact;
		  yourself
]

{ #category : #filtering }
CPPSQueryBrowserSelectionListRightPanel >> displayResearchFilter: aString [

	self selectionList displayResearchFilter: aString
]

{ #category : #accessing }
CPPSQueryBrowserSelectionListRightPanel >> helpMessage [

	^ 'Regex Matching:</br> </br>
	Matching ignores upper/lower case differences. </br> </br>
	Where this string contains #, text may contain any character. </br> </br>
	Where this string contains *, text may contain any sequence of characters. </br> </br>
	Pattern matching init:</br> </br>
	"*"	, "*it", "*ni*", "in*", "init", "i*t", "in*it"	, "Init" , "in#t"</br> </br>
	Pattern not matching init: </br> </br>
	"*ni", "*se*", "ni*", "i*i". </br> </br>
	
	By default if the pattern does not contains any regex caracter, a default search will be used.'
]

{ #category : #initialization }
CPPSQueryBrowserSelectionListRightPanel >> initialize [

	super initialize.
	self selectionList: self defaultSelectionList
]

{ #category : #rendering }
CPPSQueryBrowserSelectionListRightPanel >> renderButtonsOn: html [

	html div
		class: #'query-manager-right-panel__options';
		with:
			[ html div:
					[ html mdlMajorAnchorButton
						beSmall;
						callback:
							[ self useQuery: (FQStringQuery nameMatches: (self selectionList displayResearchFilter ifNil: [ '' ])).
							self selectionList displayResearchFilter: ''
							];
						with: (self
								 english: 'Include filter in query'
								 french: 'Inclure le filtre dans la requête').
					html render: (CPPSHelpComponent message: self helpMessage)
					]
			]
]

{ #category : #rendering }
CPPSQueryBrowserSelectionListRightPanel >> renderContentOn: html [

	self renderButtonsOn: html.
	[ self displayResearchFilter: ((self focusedQuery comparisonValue
			  replaceAllRegex: '\.\*'
			  with: '*') ifNil: [ '' ])
	]
		on: Error
		do: [ self displayResearchFilter: '' ].
	html render: self selectionList.
	html document addLoadScript: 'initQueryBrowserFilter();' js
]

{ #category : #accessing }
CPPSQueryBrowserSelectionListRightPanel >> selectionList [

	^ selectionList
]

{ #category : #accessing }
CPPSQueryBrowserSelectionListRightPanel >> selectionList: anObject [

	selectionList := anObject
]
