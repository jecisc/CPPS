"
Description
--------------------

I am a simple component to display an icon taht can have an help text. 

I was created to be return in an #iconBlock in a CPPSListComponent.

Internal Representation and Key Implementation Points.

    Instance Variables
	helpText:			<aTranslateString> 	A possible help that pop on the moose over
	url:				<aString>					The url of the icon

"
Class {
	#name : #CPPSListIconComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'initial',
		'helpText',
		'entityToTag'
	],
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #'instance creation' }
CPPSListIconComponent class >> entityToTag: anEntity [

	^ self new
		  entityToTag: anEntity;
		  yourself
]

{ #category : #'instance creation' }
CPPSListIconComponent class >> initial: aString helpText: aTranslatedString [

	^ self new
		  initial: aString;
		  helpText: aTranslatedString;
		  yourself
]

{ #category : #'instance creation' }
CPPSListIconComponent class >> url: aString helpText: aTranslatedString [

	self deprecated: 'Use #initial:helpText: instead. Browse the sender to check.'.
	^ self new
		  initial: (aString path last first: 1) asUppercase;
		  helpText: aTranslatedString;
		  yourself
]

{ #category : #comparing }
CPPSListIconComponent >> < aComponent [

	| tagList componentTagList |

	tagList := self entityToTag tags.
	componentTagList := aComponent tags.
	(componentTagList isEmptyOrNil or: [ tagList size > 1 ]) ifTrue: [ ^ false ].
	(componentTagList size > 1 or: [ tagList isEmptyOrNil ]) ifTrue: [ ^ true ].
	^ tagList first color < aComponent tags first color
]

{ #category : #comparing }
CPPSListIconComponent >> > aComponent [

	| tagList componentTagList |

	tagList := self entityToTag tags.
	componentTagList := aComponent tags.
	(componentTagList isEmptyOrNil or: [ tagList size > 1 ]) ifTrue: [ ^ true ].
	(componentTagList size > 1 or: [ tagList isEmptyOrNil ]) ifTrue: [ ^ false ].
	^ tagList first color > componentTagList first color
]

{ #category : #action }
CPPSListIconComponent >> areEntitiesNil [

	^ self currentTag isNil or: [ self entityToTag isNil ]
]

{ #category : #rendering }
CPPSListIconComponent >> createGradientFrom: colors [

	^ String streamContents:
		  [ :s | 
		  { '-webkit-'. '-o-'. '-moz-'. '' } do:
			  [ :vendor | 
			  s
				  << 'background-image: ';
				  << vendor;
				  << 'linear-gradient(left, #';
				  << (', #' join: (colors collect: #asHexString));
				  << '); '
			  ]
		  ]
]

{ #category : #accessing }
CPPSListIconComponent >> entityToTag [

	^ entityToTag
]

{ #category : #accessing }
CPPSListIconComponent >> entityToTag: anObject [

	entityToTag := anObject
]

{ #category : #accessing }
CPPSListIconComponent >> helpText [

	^ helpText
]

{ #category : #accessing }
CPPSListIconComponent >> helpText: anObject [

	helpText := anObject
]

{ #category : #accessing }
CPPSListIconComponent >> initial [

	^ initial
]

{ #category : #accessing }
CPPSListIconComponent >> initial: anObject [

	initial := anObject
]

{ #category : #javascript }
CPPSListIconComponent >> jsTagActionOn: html [

	^ self session refreshOnTagging
		  ifTrue:
			  [ html jQuery ajax
				  callback: [ self manageTagClick ];
				  onComplete: 'location.reload();'
			  ]
		  ifFalse:
			  [ html jQuery this parent load
				  html:
					  [ :r | 
					  self manageTagClick.
					  self renderTagIconOn: r
					  ];
				  onComplete: 'componentHandler.upgradeDom();'
			  ]
]

{ #category : #action }
CPPSListIconComponent >> manageTagClick [

	self areEntitiesNil ifFalse: [ self entityToTag toggleTag: self currentTag ]
]

{ #category : #rendering }
CPPSListIconComponent >> renderContentOn: html [

	html div: [ self renderTagIconOn: html ].
	self renderImageOn: html
]

{ #category : #rendering }
CPPSListIconComponent >> renderIconTooltipFor: id on: html [

	self shouldDisplayIconTooltip ifFalse: [ ^ self ].
	html
		mdlLargeTooltipFor: id
		with: [ html text: (self translate: self helpText) ]
]

{ #category : #rendering }
CPPSListIconComponent >> renderImageOn: html [

	| id |

	self initial ifNil: [ ^ self ].
	html mdlChipContact
		id: (id := html nextId);
		mdlBackgroundColorPrimary;
		with: self initial.
	self
		renderIconTooltipFor: id
		on: html
]

{ #category : #rendering }
CPPSListIconComponent >> renderTagIconOn: html [

	| id tagList colors hasCurrentTag |

	self shouldDisplayTagIcon ifFalse: [ ^ self ].
	tagList := self entityToTag tags.
	colors := tagList collect: #color.
	hasCurrentTag := self currentTag isNotNil.
	html mdlIcon
		class: 'list-tag-icon';
		class: #rainbow
		if: colors size > 1;
		style: [ 'color: #' , colors anyOne asHexString ]
		if: colors size = 1;
		style: [ self createGradientFrom: colors ]
		if: colors size > 1;
		id: (id := html nextId);
		openDialogWithId: self rootDialogOpenId
		if: hasCurrentTag not;
		onClickUpdateRootDialogWith: [ :r | self renderCurrentTagSelectionOn: r ]
		if: hasCurrentTag not;
		onClick: (self jsTagActionOn: html)
		if: hasCurrentTag;
		with: #label.
	self
		renderTooltipFor: id
		basedOn: tagList
		on: html
]

{ #category : #rendering }
CPPSListIconComponent >> renderTooltipFor: id basedOn: tagList on: html [

	html
		mdlLargeTooltipFor: id
		with: ((tagList collect: #name)
				 ifEmpty:
					 [ (self entityToTag isNotNil and: [ tagList isEmpty ])
						 ifFalse:
							 [ self
								 translate: 'No tag'
								 french: 'Pas de tag'
							 ]
						 ifTrue:
							 [ self
								 translate: 'Tag with current tag'
								 french: 'Tagger avec le tag courant'
							 ]
					 ]
				 ifNotEmpty: [ :names | ' - ' join: names ])
]

{ #category : #testing }
CPPSListIconComponent >> shouldDisplayIconTooltip [

	^ self helpText isNotNil and: [ (self translate: self helpText) isNotEmpty ]
]

{ #category : #testing }
CPPSListIconComponent >> shouldDisplayTagIcon [

	^ self entityToTag isNotNil
]
