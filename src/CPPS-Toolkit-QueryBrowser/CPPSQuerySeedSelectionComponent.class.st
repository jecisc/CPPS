"
Description
--------------------

I am a component allowing to select the seed of the query browser to use.

The query browser need a seed to begin a query. A seed is a kind of entity from the current model. 

I will probably only be used by the QueryBrowser. 

Example
--------------------
 
	html render: (CPPSQuerySeedSelectionComponent actionBlock: [ :query | self addNextQuery: query ])
	
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	actionBlock:		<aBlock>	A block to execute when the user select a seed. It will takes as parameter the kind of entity selected as a query.
"
Class {
	#name : #CPPSQuerySeedSelectionComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'actionBlock',
		'selectedEntries'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #'instance creation' }
CPPSQuerySeedSelectionComponent class >> actionBlock: aBlock [

	^ self new
		  actionBlock: aBlock;
		  yourself
]

{ #category : #accessing }
CPPSQuerySeedSelectionComponent >> actionBlock [

	^ actionBlock
]

{ #category : #accessing }
CPPSQuerySeedSelectionComponent >> actionBlock: anObject [

	actionBlock := anObject
]

{ #category : #accessing }
CPPSQuerySeedSelectionComponent >> allEntityTypesModel [

	^ (self model allEntityTypes collect: [ :each | FQModelQuery entityType: each ]) sorted: #displayName ascending
]

{ #category : #QueryModel }
CPPSQuerySeedSelectionComponent >> createQueryModelWithSelectedEntries [

	^ FQModelQuery new
		  entityTypes: (self selectedEntries flatCollect: [ :each | each entityTypes ]);
		  yourself
]

{ #category : #javascript }
CPPSQuerySeedSelectionComponent >> javascriptOnCellClickFor: anEntry on: html [

	^ html jQuery ajax
		  callback: [ self actionBlock value: anEntry ];
		  onComplete: 'location.reload();'
]

{ #category : #rendering }
CPPSQuerySeedSelectionComponent >> renderCellOf: anEntry on: html [

	html mdlCell
		class: 'mdl-card';
		desktopSize: 3;
		tabletSize: 4;
		phoneSize: 4;
		shadow: 2;
		onClick: (self
				 javascriptOnCellClickFor: anEntry
				 on: html);
		with:
			[ html mdlCardTitleContainer: (self translate: anEntry entityTypes first multilanguageDisplayName).
			self
				renderCellTextOf: anEntry
				on: html.
			html mdlCardMenu with:
					[ self
						renderSelectionCheckBoxFor: anEntry
						On: html
					]
			]
]

{ #category : #rendering }
CPPSQuerySeedSelectionComponent >> renderCellTextOf: anEntry on: html [

	html mdlCardTextContainer
		class: #'text-center';
		with: (String streamContents:
					 [ :s | 
					 | size |

					 "We stock it to not recalculate it two times."
					 size := (anEntry runOn: self model) size.
					 s
						 print: size;
						 space;
						 nextPutAll: (size > 1
								  ifTrue: [ (self translate: anEntry entityTypes first multilanguageDisplayName) pluralize ]
								  ifFalse: [ self translate: anEntry entityTypes first multilanguageDisplayName ])
					 ])
]

{ #category : #rendering }
CPPSQuerySeedSelectionComponent >> renderContentOn: html [

	self selectedEntries: nil.
	html form
		class: #'query-browser-seed';
		with:
			[ html heading
				mdlTypographyDisplay1;
				mdlTypographyTextCenter;
				with: (self
						 english: 'From which kind of entity do you want to start?'
						 french: 'À partir de quel type d''entité voulez-vous commencer ?').
			self renderToolbarOn: html.
			html mdlGrid
				class: #'query-browser-seed__entries';
				with:
					[ self allEntityTypesModel do:
							[ :entry | 
							self
								renderCellOf: entry
								on: html
							]
					]
			]
]

{ #category : #rendering }
CPPSQuerySeedSelectionComponent >> renderSelectionCheckBoxFor: anEntry On: html [

	| id |

	id := html nextId.
	html mdlCheckboxContainer
		rippleEffect;
		for: id;
		onClick: 'event.stopPropagation();';
		with:
			[ html mdlCheckbox
				id: id;
				callback: [ :confirmation | confirmation ifTrue: [ self selectEntry: anEntry ] ]
			]
]

{ #category : #rendering }
CPPSQuerySeedSelectionComponent >> renderToolbarOn: html [

	html div
		class: 'flex-bar';
		with:
			[ html mdlSubmitButton
				style: 'margin-left: 15px;';
				callback: [ self actionBlock value: self createQueryModelWithSelectedEntries ];
				with: (self
						 english: 'Create a query with selected types'
						 french: 'Créer une requête avec les types sélectionnés').
			html space
			]
]

{ #category : #QueryModel }
CPPSQuerySeedSelectionComponent >> selectEntry: anEntry [

	(self selectedEntries anySatisfy: [ :anyOne | anyOne == anEntry ])
		ifFalse: [ self selectedEntries add: anEntry ]
		ifTrue: [ self selectedEntries remove: anEntry ]
]

{ #category : #accessing }
CPPSQuerySeedSelectionComponent >> selectedEntries [

	^ selectedEntries ifNil: [ selectedEntries := OrderedCollection new ]
]

{ #category : #accessing }
CPPSQuerySeedSelectionComponent >> selectedEntries: aCollection [

	selectedEntries := aCollection
]
