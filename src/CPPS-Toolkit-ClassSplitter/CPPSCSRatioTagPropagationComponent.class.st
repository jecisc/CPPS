Class {
	#name : #CPPSCSRatioTagPropagationComponent,
	#superclass : #CPPSCSAbstractTagPropagationComponent,
	#instVars : [
		'ratio',
		'propagationStrategy'
	],
	#category : #'CPPS-Toolkit-ClassSplitter'
}

{ #category : #rendering }
CPPSCSRatioTagPropagationComponent >> description [

	self flag: #todo.
	"Translate the description to french"
	^ 'I allow one to automatize the propagation of tags in the current visualization. When executed, I will tag containers containing the selected tag (or any tag if the option is selected) if it is present at least at a certain ratio configured via the next slider.'
]

{ #category : #initialization }
CPPSCSRatioTagPropagationComponent >> initialize [

	super initialize.
	ratio := 60.
	propagationStrategy := CPPSCSTagPropagationStrategy defaultStrategy
]

{ #category : #accessing }
CPPSCSRatioTagPropagationComponent >> propagationStrategy [

	^ propagationStrategy
]

{ #category : #accessing }
CPPSCSRatioTagPropagationComponent >> propagationStrategy: anObject [

	propagationStrategy := anObject
]

{ #category : #accessing }
CPPSCSRatioTagPropagationComponent >> ratio [

	^ ratio
]

{ #category : #accessing }
CPPSCSRatioTagPropagationComponent >> ratio: anObject [

	ratio := anObject
]

{ #category : #rendering }
CPPSCSRatioTagPropagationComponent >> renderFormContentOn: html [

	html mdlSliderContainer:
		[ | outputId |

		outputId := html nextId.
		html label
			for: html nextId;
			with: 'Ratio'.
		html mdlSlider
			callback: [ :int | self ratio: int asNumber ];
			onInput: outputId , '.value = ' , html lastId , '.value';
			id: html lastId;
			min: 0;
			max: 100;
			value: self ratio.
		html output
			id: outputId;
			for: html lastId;
			with: self ratio.
		html text: '%'
		].
	html mdlGrid
		formControl;
		mdlTypographyTextJustify;
		with:
			[ html radioGroup
				callback: [ :strategy | self propagationStrategy: strategy ];
				selected: self propagationStrategy;
				with:
					[ :group | 
					CPPSCSTagPropagationStrategy strategies do:
							[ :strategy | 
							html mdlRadioContainer
								for: html nextId;
								beCell: 6
								phoneSize: 4
								tabletSize: 2;
								rippleEffect;
								with:
									[ group mdlRadioButton
										id: html lastId;
										value: strategy.
									html mdlRadioLabel: (self translate: strategy label)
									]
							]
					]
			]
]

{ #category : #accessing }
CPPSCSRatioTagPropagationComponent >> shouldTag: entity with: tag [

	^ (self visualization containedEntitiesOf: entity)
		  ifNotEmpty:
			  [ :children | 
			  | ratioOfTagPresence |

			  ratioOfTagPresence := (children select: [ :child | child isTaggedWith: tag ]) size / children size.
			  self ratio percent < ratioOfTagPresence
			  ]
		  ifEmpty: [ false ]
]

{ #category : #accessing }
CPPSCSRatioTagPropagationComponent >> tagsToPropagate [

	| entitiesToTag tagsToAdd |

	entitiesToTag := self visualization entitiesToShow.
	tagsToAdd := Dictionary new.
	([ self propagationStrategy tagsToPropagateFor: self ]
		 on: Error
		 do:
			 [ :e | 
			 feedback := e messageText.
			 ^ nil
			 ]) do:
		[ :tag | 
		entitiesToTag
			reject: [ :entity | entity isTaggedWith: tag ]
			thenDo:
				[ :entity | 
				(self
					 shouldTag: entity
					 with: tag) ifTrue:
					[ (tagsToAdd
						 at: entity
						 ifAbsentPut: [ Set new ]) add: tag
					]
				]
		].
	^ tagsToAdd
]

{ #category : #accessing }
CPPSCSRatioTagPropagationComponent >> title [

	^ self
		  english: 'Ratio tag propagation'
		  french: 'Propagation de tags par ratio'
]
