"
I am a component to split the selected tag into two tags.

Description
------------------

There is some discutions about what I should do but for now I let the user split a tag into two tags. 
The user will choose the repartition of the composite tags and the tagged entities.

Internal Representation and Key Implementation Points.
-----------------

    Instance Variables
	errorMessage:		<aString>		An error message to display in case there is a problem.
	firstEntities:			<aCollection>	The entities to keep for the first tag.
	firstTag:				<aTag>			The first tag to create. It's possible that it is the selected tag itself.
	secondEntities:		<aCollection>	The entities to keep for the second tag.
	secondTag:			<aTag>			The second tag to create.
"
Class {
	#name : #CPPSTagSplitComponent,
	#superclass : #CPPSTagBrowserComponent,
	#instVars : [
		'firstTag',
		'secondTag',
		'firstEntities',
		'secondEntities',
		'errorMessage',
		'table'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #components }
CPPSTagSplitComponent >> defaultTable [

	^ MDLSortableTable new
		  header: { 
				  (self
					   english: 'Name'
					   french: 'Nom').
				  (self
					   english: 'Kind'
					   french: 'Type').
				  'Destination'.
				  'Destination' };
		  rows: [ self tableRows ];
		  rowsPerPagePossibilities: #( 10 50 100 200 )
]

{ #category : #accessing }
CPPSTagSplitComponent >> errorMessage [

	^ errorMessage
]

{ #category : #accessing }
CPPSTagSplitComponent >> errorMessage: anObject [

	errorMessage := anObject
]

{ #category : #accessing }
CPPSTagSplitComponent >> firstEntities [

	^ firstEntities ifNil:
		  [ self resetVariables.
		  ^ self firstEntities
		  ]
]

{ #category : #accessing }
CPPSTagSplitComponent >> firstEntities: anObject [

	firstEntities := anObject
]

{ #category : #accessing }
CPPSTagSplitComponent >> firstTag [

	^ firstTag
]

{ #category : #accessing }
CPPSTagSplitComponent >> firstTag: anObject [

	firstTag := anObject
]

{ #category : #rendering }
CPPSTagSplitComponent >> renderFormOn: html [

	self
		renderWarningOn: html;
		renderTagsNamesInputsOn: html.
	html render: self table.
	html
		mdlSubmitButton: (self
				 english: 'Split'
				 french: 'Diviser')
		callback: [ self split ]
]

{ #category : #rendering }
CPPSTagSplitComponent >> renderSwitchLabelFor: anObject displaying: anEntity labeled: aString on: html [

	html div
		onClick: (html jQuery ajax
				 callback: [ self toogleContainerFor: anObject ];
				 context: (JSStream on: 'this');
				 onSuccess: (html jQuery script:
							  [ :s | 
							  s << (html jQuery this parent parent load
									   html:
										   [ :ajaxHtml | 
										   self table
											   renderRowContentFor: (self
													    tableRowFor: anObject
													    displaying: anEntity)
											   on: ajaxHtml
										   ];
									   onComplete: 'componentHandler.upgradeDom();')
							  ]);
				 onError: 'location.reload()');
		style: 'cursor: pointer';
		with: aString
]

{ #category : #rendering }
CPPSTagSplitComponent >> renderTagsNamesInputsOn: html [

	html div
		class: #splitNewTags;
		with:
			[ { 
				((self
					  english: 'First tag name'
					  french: 'Nom du premier tag') -> [ :name | self firstTag: name ]).
				((self
					  english: 'Second tag name'
					  french: 'Nom du second tag') -> [ :name | self secondTag: name ]) } do:
					[ :assoc | 
					html render: (MDLTextFieldWidget
								 labeled: assoc key
								 callback: assoc value
								 floatingLabel: true)
					]
			]
]

{ #category : #rendering }
CPPSTagSplitComponent >> renderWarningOn: html [

	self errorMessage ifNotNil:
		[ :warn | 
		html div
			class: #errorMessage;
			with: warn.
		self errorMessage: nil
		]
]

{ #category : #initialization }
CPPSTagSplitComponent >> resetVariables [

	self tag ifNotNil:
		[ self firstEntities: ((OrderedCollection withAll: (self model associationsForTag: self tag))
				 addAll: self tag subTags;
				 yourself)
		].
	self secondEntities: OrderedCollection new
]

{ #category : #accessing }
CPPSTagSplitComponent >> secondEntities [

	^ secondEntities
]

{ #category : #accessing }
CPPSTagSplitComponent >> secondEntities: anObject [

	secondEntities := anObject
]

{ #category : #accessing }
CPPSTagSplitComponent >> secondTag [

	^ secondTag
]

{ #category : #accessing }
CPPSTagSplitComponent >> secondTag: anObject [

	secondTag := anObject
]

{ #category : #accessing }
CPPSTagSplitComponent >> selectedTag: aTag [

	self resetVariables
]

{ #category : #action }
CPPSTagSplitComponent >> split [

	| firstTargetTag secondTargetTag |

	(self firstTag isEmptyOrNil or: [ self secondTag isEmptyOrNil ]) ifTrue:
		[ self errorMessage: (self
				 english: 'Enter two names for the new tags.'
				 french: 'Entrez deux nouveaux noms de tags.').
		^ self
		].
	firstTargetTag := self tag subTagNamed: self firstTag.
	secondTargetTag := self tag subTagNamed: self secondTag.
	self
		split: self firstEntities
		in: firstTargetTag.
	self
		split: self secondEntities
		in: secondTargetTag.
	"We remove the original tag only of it's not one of the targets and if is has no child anymore"
	(self tag children isEmpty and: [ firstTargetTag ~= self tag and: [ secondTargetTag ~= self tag ] ]) ifTrue: [ self tag remove ].
	self owner selectedTag: firstTargetTag
]

{ #category : #action }
CPPSTagSplitComponent >> split: aCollectionOfEntities in: aTag [

	aTag description ifNil:
		[ aTag description: (self
				 english: 'Tag created by spliting '
				 french: 'Tag obtenu en divisant ') , self tag name
		].
	aCollectionOfEntities do:
		[ :entity | 
		entity isTag
			ifTrue:
				[ [ [ entity changeParentTagTo: aTag ]
					on: FamixAlreadyExistTagFailure
					do:
						[ :ex | 
						ex existingTag
							mergeWith: entity
							forModel: self model
						]
				]
					on: FamixTagRecursiveFailure
					do: [ "if a tag is splitted into itself, nothing to do" ]
				]
			ifFalse: [ entity tag: aTag ]
		].
	^ aTag
]

{ #category : #accessing }
CPPSTagSplitComponent >> table [

	^ table ifNil: [ table := self defaultTable ]
]

{ #category : #accessing }
CPPSTagSplitComponent >> tableRowFor: anObject displaying: anEntity [

	^ { 
		  anEntity name.
		  anEntity class englishName.
		  [ :html | 
		  (self firstEntities includes: anObject) ifTrue:
			  [ self
				  renderSwitchLabelFor: anObject
				  displaying: anEntity
				  labeled: 'Tag 1 >>'
				  on: html
			  ]
		  ].
		  [ :html | 
		  (self secondEntities includes: anObject) ifTrue:
			  [ self
				  renderSwitchLabelFor: anObject
				  displaying: anEntity
				  labeled: '<< Tag2'
				  on: html
			  ]
		  ] }
]

{ #category : #accessing }
CPPSTagSplitComponent >> tableRows [

	^ ((self model associationsForTag: self tag) collect:
		   [ :anAssociation | 
		   self
			   tableRowFor: anAssociation
			   displaying: anAssociation entity
		   ]) , (self tag subTags collect:
		   [ :anEntity | 
		   self
			   tableRowFor: anEntity
			   displaying: anEntity
		   ])
]

{ #category : #accessing }
CPPSTagSplitComponent >> title [

	^ self
		  english: 'Split your Tag'
		  french: 'Divisez votre tag'
]

{ #category : #action }
CPPSTagSplitComponent >> toogleContainerFor: anObject [

	(self firstEntities includes: anObject)
		ifTrue:
			[ self firstEntities remove: anObject.
			self secondEntities add: anObject
			]
		ifFalse:
			[ self secondEntities remove: anObject.
			self firstEntities add: anObject
			]
]
