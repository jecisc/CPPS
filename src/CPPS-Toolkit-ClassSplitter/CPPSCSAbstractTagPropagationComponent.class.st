Class {
	#name : #CPPSCSAbstractTagPropagationComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'lastPropagation',
		'owner',
		'feedback'
	],
	#category : #'CPPS-Toolkit-ClassSplitter'
}

{ #category : #'instance creation' }
CPPSCSAbstractTagPropagationComponent class >> owner: aComponent [

	^ self new
		  owner: aComponent;
		  yourself
]

{ #category : #accessing }
CPPSCSAbstractTagPropagationComponent >> description [

	^ self subclassResponsibility
]

{ #category : #actions }
CPPSCSAbstractTagPropagationComponent >> highlightTagsToPropagate [

	self removeHighlighting. "In case we highlighted with another value."
	self tagsToPropagate ifNotNil:
		[ :dict | 
		dict
			ifEmpty: [ feedback := 'Nothing to propagate' ]
			ifNotEmpty:
				[ dict keysAndValuesDo:
					[ :entity :tags | 
					| node |

					node := self visualization nodeForEntity: entity.
					node styleSheet
						borderColor: (tags size = 1
								 ifTrue: [ tags anyOne color ]
								 ifFalse: [ Color black ]);
						borderWidth: 5.
					node requireUpdate
					]
				]
		]
]

{ #category : #rendering }
CPPSCSAbstractTagPropagationComponent >> jsShowFeedbackOn: s [

	feedback ifNil: [ ^ self ].
	s << (self jsShowRootDialog: feedback).
	feedback := nil
]

{ #category : #accessing }
CPPSCSAbstractTagPropagationComponent >> owner [

	^ owner
]

{ #category : #accessing }
CPPSCSAbstractTagPropagationComponent >> owner: anObject [

	owner := anObject
]

{ #category : #actions }
CPPSCSAbstractTagPropagationComponent >> propagateTags [

	self tagsToPropagate
		ifNil: [ "We can have nil throught the #tagsToPropagate in some cases where we got an error and we give feedback to the user." ^ self ]
		ifNotNil:
			[ :tags | 
			lastPropagation := tags.
			lastPropagation
				ifEmpty: [ feedback := 'No tag to propagate' ]
				ifNotEmpty:
					[ lastPropagation keysAndValuesDo: [ :entity :tags2 | tags2 do: [ :tag | entity tagWith: tag ] ].
					feedback := lastPropagation size asString , ' tags propagated'.
					self removeHighlighting
					]
			]
]

{ #category : #actions }
CPPSCSAbstractTagPropagationComponent >> removeHighlighting [

	self visualization allNodesDo:
		[ :node | 
		node styleSheet attributes
			removeKey: #borderColor
			ifAbsent: [ "do nothing" ];
			removeKey: #borderWidth
			ifAbsent: [ "do nothing" ].
		node requireUpdate
		]
]

{ #category : #rendering }
CPPSCSAbstractTagPropagationComponent >> renderButtonsOn: html [

	html div
		flag: #todo;
		"Move to SASS"style: 'display:flex; justify-content: space-around; flex-wrap: wrap;';
		with:
			[ html mdlMajorButton
				bePush;
				onClick: (html jQuery ajax
						 serializeForm;
						 script:
							 [ :s | 
							 self propagateTags.
							 self visualization update.
							 self jsShowFeedbackOn: s
							 ]);
				with: (self
						 english: 'Propagate'
						 french: 'Propager').
			html mdlButton
				bePush;
				primaryColor;
				onClick: (html jQuery ajax
						 serializeForm;
						 script:
							 [ :s | 
							 self highlightTagsToPropagate.
							 self visualization update.
							 self jsShowFeedbackOn: s
							 ]);
				with: (self
						 english: 'Preview'
						 french: 'Preview').
			html mdlButton
				bePush;
				onClick: (html jQuery ajax script:
							 [ :s | 
							 self removeHighlighting.
							 self visualization update.
							 s << (self jsShowRootDialog: 'Preview removed')
							 ]);
				with: (self
						 english: 'Reset'
						 french: 'Reset').
			html mdlButton
				bePush;
				onClick: (html jQuery ajax script:
							 [ :s | 
							 self revertLastPropagation.
							 self visualization update.
							 s << (self jsShowRootDialog: 'Last propagation reverted.')
							 ]);
				with: (self
						 english: 'Undo'
						 french: 'Undo')
			]
]

{ #category : #rendering }
CPPSCSAbstractTagPropagationComponent >> renderContentOn: html [
	self renderTitleOn: html.
	self renderFormOn: html
]

{ #category : #rendering }
CPPSCSAbstractTagPropagationComponent >> renderFormContentOn: html [

	self subclassResponsibility
]

{ #category : #rendering }
CPPSCSAbstractTagPropagationComponent >> renderFormOn: html [

	html form:
		  [ self
			  renderFormContentOn: html;
			  renderButtonsOn: html
		  ]
]

{ #category : #rendering }
CPPSCSAbstractTagPropagationComponent >> renderTitleOn: html [
	html headerContainer: [ html headline: self title ].
	html description: self description
]

{ #category : #actions }
CPPSCSAbstractTagPropagationComponent >> revertLastPropagation [

	lastPropagation ifNil: [ ^ self ].
	lastPropagation keysAndValuesDo: [ :entity :tags | tags do: [ :tag | entity removeTag: tag ] ].
	lastPropagation := nil
]

{ #category : #accessing }
CPPSCSAbstractTagPropagationComponent >> tagsToPropagate [

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSCSAbstractTagPropagationComponent >> title [

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSCSAbstractTagPropagationComponent >> visualization [

	^ self owner visualization
]
