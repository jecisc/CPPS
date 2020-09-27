"
Description
-------------------

I am a component use to remember  and display the applied queries of the QueryBrowser.

I keep a model query containing the seed of the query and all the atiomic queries done by the user. 

I am able to display them as a path, to allow the user to remove some and to give the current query result.

Public API and Key Messages
--------------------

- #addNextQuery: aQuery 		I add a query in the sequence of query I keep.
- #isEmpty 					Return true if there is no query 
- #queryResult 				Return the current query result. If a query fail it will remove the last query and retry.
- #resetQueryUntil: anInteger 	Remove the queries that are after the x first ones.

Example
--------------------

	CPPSQueryPathComponent  refreshBlock: [ :queryResult | queryResult crLog ]
 
Internal Representation and Key Implementation Points.
---------------------

    Instance Variables
	modelQuery:			<aQuery>	I am a query keeping the seed of the query and all the steps of the query made by the user.
	queryError:			<aString>	I am an optional error message to display to the user during the next rendering of the page.
	refreshBlock:		<aBlock>	I am a block to execute when the query change.

"
Class {
	#name : #CPPSQueryPathComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'modelQuery',
		'refreshBlock',
		'queryResult',
		'queryError',
		'focusedQuery'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #'instance creation' }
CPPSQueryPathComponent class >> refreshBlock: aBlock [

	^ self new
		  refreshBlock: aBlock;
		  yourself
]

{ #category : #action }
CPPSQueryPathComponent >> combineFocusedQuery: aClassCombinatorQuery [

	self focusedQuery useCombinator: aClassCombinatorQuery.
	self swapToAddingModeForQuery: self focusedQuery parentQuery.
	self executeCurrentModelQuery
]

{ #category : #action }
CPPSQueryPathComponent >> computeQuerieResult [

	^ self modelQuery
		  runOn: self currentUser model
		  upTo: (self focusedQuery queryToRunToFor: self modelQuery)
]

{ #category : #action }
CPPSQueryPathComponent >> deleteFocusedQuery [

	self focusedQuery delete.
	self swapToAddingModeForQuery: self focusedQuery parentQuery.
	self executeCurrentModelQuery
]

{ #category : #updating }
CPPSQueryPathComponent >> executeCurrentModelQuery [

	self refreshBlock value: self queryResult
]

{ #category : #action }
CPPSQueryPathComponent >> focusOnQuery: aQuery [

	focusedQuery := aQuery.
	self resetQueryResult.
	self executeCurrentModelQuery
]

{ #category : #accessing }
CPPSQueryPathComponent >> focusedQuery [

	^ focusedQuery
]

{ #category : #action }
CPPSQueryPathComponent >> foldInSequentialQueryNamed: name [

	| query |

	query := self modelQuery query named: name.
	self queryStorage add: query.
	self modelQuery
		removeComposableQuery;
		addQuery: query.
	self flag: #TODO. "Will change when only a part of the current query will be saved"
	self swapToAddingModeForQuery: self modelQuery query
]

{ #category : #testing }
CPPSQueryPathComponent >> isEditing [

	^ self focusedQuery
		  ifNil: [ false ]
		  ifNotNil: [ :query | query isFakeQuery not ]
]

{ #category : #testing }
CPPSQueryPathComponent >> isEmpty [

	^ self modelQuery isNil
]

{ #category : #accessing }
CPPSQueryPathComponent >> modelQuery [

	^ modelQuery
]

{ #category : #accessing }
CPPSQueryPathComponent >> modelQuery: anObject [

	modelQuery := anObject.
	self swapToAddingModeForQuery: self modelQuery
]

{ #category : #testing }
CPPSQueryPathComponent >> modelQueryDeserveToBeSaved [

	^ self modelQuery isNotNil and: [ self modelQuery hasComposableQuery ]
]

{ #category : #accessing }
CPPSQueryPathComponent >> queryError [

	self flag: #todo. "For now we manage query error be sending a message to the user. Later we should only propose applicable queries to the user"
	^ queryError
]

{ #category : #accessing }
CPPSQueryPathComponent >> queryError: anObject [

	queryError := anObject
]

{ #category : #accessing }
CPPSQueryPathComponent >> queryResult [

	self modelQuery ifNil: [ ^ MooseGroup new ].
	^ queryResult ifNil:
		  [ queryResult := [ self computeQuerieResult sorted: #name ascending ]
			                 on: Error
			                 do:
				                 [ :e | 
				                 self modelQuery removeLast.
				                 self queryError: (self
						                  english: 'Query not applicable on the current selection.'
						                  french: 'Requête non applicable sur la selection courante.').
				                 self queryResult
				                 ]
		  ]
]

{ #category : #accessing }
CPPSQueryPathComponent >> refreshBlock [

	^ refreshBlock
]

{ #category : #accessing }
CPPSQueryPathComponent >> refreshBlock: anObject [

	refreshBlock := anObject
]

{ #category : #action }
CPPSQueryPathComponent >> removeSequenceQuery [

	self modelQuery removeComposableQuery.
	self swapToAddingModeForQuery: self modelQuery
]

{ #category : #rendering }
CPPSQueryPathComponent >> renderAllQueriesOn: html [

	self renderErrorOn: html.
	self renderRootOn: html.
	self modelQuery ifNotNil:
		[ self renderTypeQueryOn: html.
		self modelQuery hasComposableQuery
			ifTrue:
				[ self modelQuery query doWithIndex:
					[ :query :index | 
					self
						renderQuery: query
						callback: [ :q | self focusOnQuery: q ]
						asSegmentOn: html
					].
				self
					renderNewStepFor: self modelQuery query
					on: html
				]
			ifFalse:
				[ self
					renderNewStepFor: self modelQuery
					on: html
				]
		]
]

{ #category : #rendering }
CPPSQueryPathComponent >> renderChildrenCombinatorOn: html callback: aCallback forQuery: query [

	html div
		class: #'on-hover';
		with:
			[ query children do:
					[ :q | 
					self
						renderQuery: q
						callback: aCallback
						asSegmentOn: html
					].
			self
				renderNewStepFor: query
				on: html
			]
]

{ #category : #rendering }
CPPSQueryPathComponent >> renderContentOn: html [

	self flag: #improve. "When we try to move for more than 1 level we should add a message asking if this is what the user really want."
	html div
		class: #'line-query-path';
		with:
			[ self renderAllQueriesOn: html.
			html div class: #spacer
			].
	self renderSaveButtonOn: html
]

{ #category : #rendering }
CPPSQueryPathComponent >> renderErrorOn: html [

	self queryError ifNil: [ ^ self ].
	html script: (String streamContents:
			 [ :s | 
			 s
				 << 'function showSnackbar(){setTimeout(function(){';
				 << (html mdlSnackbar
						  message: self queryError;
						  timeout: 4000;
						  getJsShowingSnackbar);
				 << ';},2000)}';
				 << 'if(!("Notification" in window)){showSnackbar();';
				 << '}else if(Notification.permission === "granted"){new Notification("';
				 << self queryError;
				 << '");}else if(Notification.permission !== "denied"){ Notification.requestPermission(function(permission){if (permission === "granted"){new Notification("';
				 << self queryError;
				 << '");}else{ showSnackbar(); }});} else{ showSnackbar(); };'
			 ]) js.
	self queryError: nil
]

{ #category : #rendering }
CPPSQueryPathComponent >> renderNewStepFor: query on: html [

	(self focusedQuery isFakeQuery and: [ self focusedQuery parentQuery = query ])
		ifFalse:
			[ self
				renderSegmentNamed: (self
						 english: 'New step'
						 french: 'Nouvelle étape')
				icon: #add
				callback: [ self swapToAddingModeForQuery: query ]
				current: false
				on: html
			]
		ifTrue:
			[ self
				renderSegmentNamed: (self
						 english: 'New step'
						 french: 'Nouvelle étape')
				icon: #add
				callback: [  ]
				current: true
				on: html
			]
]

{ #category : #rendering }
CPPSQueryPathComponent >> renderQuery: query callback: aCallback asSegmentOn: html [

	html div
		class: #'query-path__segment';
		class: #combinator
		if: self focusedQuery ~~ query;
		class: #current
		if: (self focusedQuery withAncestorsIncludes: query);
		with:
			[ self
				renderQueryIconOn: html
				callback: aCallback
				forQuery: query.
			self
				renderChildrenCombinatorOn: html
				callback: aCallback
				forQuery: query
			]
]

{ #category : #rendering }
CPPSQueryPathComponent >> renderQueryAsRuleDialogContentOn: html [

	html form
		class: #'text-center';
		with: [ html render: (CPPSRuleCreatorComponent rule: self modelQuery asRule) ]
]

{ #category : #rendering }
CPPSQueryPathComponent >> renderQueryIconOn: html callback: aCallback forQuery: query [

	html anchor
		callback: [ aCallback value: query ];
		with:
			[ html mdlIcon: query class mdlIconName.
			html text: query displayName
			]
]

{ #category : #rendering }
CPPSQueryPathComponent >> renderRootOn: html [

	self
		renderSegmentNamed: 'Root'
		icon: #home
		callback: [ self modelQuery: nil ]
		current: self modelQuery isNil
		on: html
]

{ #category : #rendering }
CPPSQueryPathComponent >> renderSaveButtonOn: html [

	self modelQueryDeserveToBeSaved ifFalse: [ ^ self ].
	html mdlButton
		class: #'query-path__save';
		openDialogWithId: self rootDialogOpenId;
		onClickUpdateRootDialogWith: [ :r | self renderSaveQueriesDialogContentOn: r ];
		primaryColor;
		rippleEffect;
		with: (self
				 english: 'Save query'
				 french: 'Sauver la requête').
	html space.
	html mdlButton
		class: #'query-path__save';
		primaryColor;
		openDialogWithId: self rootDialogOpenId;
		rippleEffect;
		onClickUpdateRootDialogWith: [ :r | self renderQueryAsRuleDialogContentOn: html ];
		with: (self
				 english: 'Make it a rule'
				 french: 'En faire une règle')
]

{ #category : #rendering }
CPPSQueryPathComponent >> renderSaveQueriesDialogContentOn: html [

	html form
		class: #'text-center';
		with:
			[ html mdlDialogTitle: (self
						 english: 'Save query'
						 french: 'Sauver la requête').
			html mdlDialogContent:
					[ html render: ((MDLTextFieldWidget
								  labeled: (self
										   english: 'Name'
										   french: 'Nom')
								  callback: [ :name | self foldInSequentialQueryNamed: name ]
								  floatingLabel: true)
								 required;
								 yourself)
					].
			html mdlDialogActions:
				[ html mdlSubmitButton: (self
						 english: 'Create'
						 french: 'Créer').
				html mdlButton
					bePush;
					id: self rootDialogCloseId;
					with: (self
							 english: 'Close'
							 french: 'Fermer')
				]
			]
]

{ #category : #rendering }
CPPSQueryPathComponent >> renderSegmentNamed: text icon: icon callback: aCallback current: aBoolean on: html [

	html div
		class: #'query-path__segment';
		class: #current
		if: aBoolean;
		with:
			[ html anchor
				callback: aCallback;
				with:
					[ html mdlIcon: icon.
					html text: text
					]
			]
]

{ #category : #rendering }
CPPSQueryPathComponent >> renderTypeQueryOn: html [

	self
		renderSegmentNamed: self modelQuery displayName
		icon: self modelQuery class mdlIconName
		callback: [ self removeSequenceQuery ]
		current: (self isEditing and: self modelQuery hasComposableQuery not)
		on: html
]

{ #category : #query }
CPPSQueryPathComponent >> resetQueryResult [

	queryResult := nil
]

{ #category : #hooks }
CPPSQueryPathComponent >> states [

	^ Array with: self modelQuery
]

{ #category : #adding }
CPPSQueryPathComponent >> swapToAddingModeForQuery: aQuery [

	self focusOnQuery: (FQFakeCreationQuery new
			 parentQuery: aQuery;
			 yourself)
]

{ #category : #action }
CPPSQueryPathComponent >> useQuery: aQuery [

	self focusedQuery useQuery: aQuery.
	self focusedQuery isFakeQuery
		ifFalse: [ self focusOnQuery: aQuery ]
		ifTrue: [ self swapToAddingModeForQuery: aQuery parentQuery ]
]
