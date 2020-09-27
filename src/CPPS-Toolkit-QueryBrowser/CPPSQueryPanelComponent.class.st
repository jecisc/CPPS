"
Description
----------------

I am a component allowing the user to make operations on queries. Each kind of query is handled by a subclass of CPPSQueryComponent.
 


"
Class {
	#name : #CPPSQueryPanelComponent,
	#superclass : #CPPSComponent,
	#traits : 'CPPSTQueryBrowserComponent',
	#classTraits : 'CPPSTQueryBrowserComponent classTrait',
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #adding }
CPPSQueryPanelComponent >> deleteFocusedQuery [

	self owner deleteFocusedQuery
]

{ #category : #'as yet unclassified' }
CPPSQueryPanelComponent >> deleteQueryButton: html [

	html div
		class: #'auto-margin';
		with:
			[ html mdlMajorAnchorButton
				beDanger;
				callback: [ self deleteFocusedQuery ];
				with: (self
						 english: 'Delete'
						 french: 'Supprimer')
			]
]

{ #category : #initialization }
CPPSQueryPanelComponent >> initialize [

	super initialize.
	self initializeQueriesComponents
]

{ #category : #initialization }
CPPSQueryPanelComponent >> initializeQueriesComponents [

	^ self subclassResponsibility
]

{ #category : #rendering }
CPPSQueryPanelComponent >> renderContentOn: html [

	html div
		class: #'query-manager-content__panel';
		shadow: 2;
		with:
			[ self renderHeaderOn: html.
			html div
				class: #'query-manager-content__queries';
				with: [ super renderContentOn: html ]
			]
]

{ #category : #rendering }
CPPSQueryPanelComponent >> renderHeaderOn: html [

	html heading
		mdlTypographyDisplay1;
		mdlTypographyTextCenter;
		with: self title
]

{ #category : #accessing }
CPPSQueryPanelComponent >> title [

	^ self subclassResponsibility
]
