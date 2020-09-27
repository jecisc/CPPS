Class {
	#name : #CPPSCheckboxesComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'possibilities',
		'selectedElements'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Correlation'
}

{ #category : #'as yet unclassified' }
CPPSCheckboxesComponent class >> possibilities: aCollection selection: anotherCollection [

	^ self new
		  possibilities: aCollection;
		  selectedElements: anotherCollection;
		  yourself
]

{ #category : #accessing }
CPPSCheckboxesComponent >> possibilities [

	^ possibilities
]

{ #category : #accessing }
CPPSCheckboxesComponent >> possibilities: anObject [

	possibilities := anObject
]

{ #category : #rendering }
CPPSCheckboxesComponent >> renderContentOn: html [

	html mdlGrid
		formControl;
		with:
			[ possibilities do:
					[ :anElement | 
					html mdlCell:
							[ html mdlCheckboxContainer
								rippleEffect;
								for: html nextId;
								with:
									[ html mdlCheckbox
										value: (self selectedElements includes: anElement);
										id: html lastId;
										onTrue: [ self selectedElements add: anElement ]
										onFalse:
											[ self selectedElements
												remove: anElement
												ifAbsent: [ "Do nothing" ]
											].
									html mdlCheckboxLabel: (self translate: anElement multilanguageDisplayName)
									]
							]
					]
			]
]

{ #category : #accessing }
CPPSCheckboxesComponent >> selectedElements [

	^ selectedElements value
]

{ #category : #accessing }
CPPSCheckboxesComponent >> selectedElements: anObject [

	selectedElements := anObject
]
