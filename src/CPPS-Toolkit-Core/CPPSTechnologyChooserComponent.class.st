"
Description
--------------------

I am a component that allows the user to choose which technology should be used to create the initial project.

Available technologies should be provided at startup, by the configuration file  (inventiveToolkit.conf for example)
"
Class {
	#name : #CPPSTechnologyChooserComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'selectedTechnology'
	],
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #accessing }
CPPSTechnologyChooserComponent >> availableTechnologies [

	^ self server configuration technologies
]

{ #category : #rendering }
CPPSTechnologyChooserComponent >> createVersionComponent [

	^ CPPSVersionCreationFormComponent project: self currentUser project
]

{ #category : #accessing }
CPPSTechnologyChooserComponent >> ensureCurrentTechnology [

	"Memorize the technology selected by the user at the server level,
	so that next chained component (VersionCreationComponent) knows about it"

	self server currentTechnology: self selectedTechnology
]

{ #category : #rendering }
CPPSTechnologyChooserComponent >> renderContentOn: html [

	self shouldSelectTechnology ifFalse:
		[ "It could be that only one technology is specified by the configuration.
		Instead of letting the user clicking on a single avaialble option, we directly callback to jump to the next component"
		html script: (html javascript callback: [ self answer: self createVersionComponent ]).
		^ self
		].
	html div
		class: 'versionCreator';
		class: 'smallComponent';
		with:
			[ html heading
				level: 2;
				with: (self translate: ('Choose technology' french: 'Choisir la technologie')).
			html form
				multipart;
				paddedForm;
				with:
					[ html div
						class: 'form-wrap';
						with: [ self renderFormOn: html ]
					]
			]
]

{ #category : #rendering }
CPPSTechnologyChooserComponent >> renderFormOn: html [

	html div
		id: #'choose-technology__form';
		with:
			[ html radioGroup
				callback:
					[ :techno | 
					self selectedTechnology: techno.
					self ensureCurrentTechnology.
					self answer: self createVersionComponent
					];
				selected: (self selectedTechnology ifNil: [ self availableTechnologies anyOne ]);
				with:
					[ :group | 
					self availableTechnologies do:
							[ :aTechnology | 
							html
								mdlRadioContainerFor: html nextId
								with:
									[ group mdlRadioButton
										id: html lastId;
										value: aTechnology.
									html mdlRadioLabel:
										[ html
											text: aTechnology technologyLabel;
											space;
											space
										]
									]
							]
					].
			html mdlSubmitButton: (self
					 english: 'Validate'
					 french: 'Valider')
			]
]

{ #category : #accessing }
CPPSTechnologyChooserComponent >> selectedTechnology [

	^ selectedTechnology
]

{ #category : #accessing }
CPPSTechnologyChooserComponent >> selectedTechnology: aProjectTechnology [

	selectedTechnology := aProjectTechnology
]

{ #category : #private }
CPPSTechnologyChooserComponent >> shouldSelectTechnology [

	^ self server allowsMultipleTechnologies "and: [ self technologyChooserComponent selectedTechnology isNil ]"
]
