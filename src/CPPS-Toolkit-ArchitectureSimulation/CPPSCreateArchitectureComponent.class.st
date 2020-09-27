"
Description
--------------------

I am the component that will create a new architecture
"
Class {
	#name : #CPPSCreateArchitectureComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'newArchitecture',
		'owner'
	],
	#category : #'CPPS-Toolkit-ArchitectureSimulation'
}

{ #category : #'instance creation' }
CPPSCreateArchitectureComponent class >> owner: aComponent [

	^ self new
		  owner: aComponent;
		  yourself
]

{ #category : #actions }
CPPSCreateArchitectureComponent >> createNewArchitectureNamed: name [

	newArchitecture name: (name ifEmpty: [ 'unamed' ]).
	self project addArchitecture: newArchitecture.
	self owner
		defineArchitecture: newArchitecture
		forPosition: 1.
	self owner
		defineVersion: self currentUser version
		forPosition: 1
]

{ #category : #rendering }
CPPSCreateArchitectureComponent >> duplicationChoice: html radioGroup: radioGroup [

	| duplicateSelected |

	self project architectures ifEmpty: [ ^ self ].
	duplicateSelected := false.
	html
		mdlRadioContainerFor: html nextId
		with:
			[ radioGroup mdlRadioButton
				id: html lastId;
				onChange: '$(".uploadContainer").children().prop( "disabled", this.checked);' js;
				callback: [ duplicateSelected := true ].
			html mdlRadioLabel: (self
					 english: 'Copy from: '
					 french: 'Dupliquer: ')
			].
	html div
		class: #'architecture-new__option-duplication';
		with:
			[ html render: (MDLSelectWidget
						 possibilities: self project architectures
						 inputLabel: (self
								  english: 'Select Architecture'
								  french: 'Selectionner une Architecture')
						 labelBlock: #name
						 callback: [ :selected | duplicateSelected ifTrue: [ newArchitecture := selected copy ] ]
						 selectedObject: self project architectures first
						 tooltip: nil
						 sortBlock: [ :a :b | a <= b ])
			]
]

{ #category : #rendering }
CPPSCreateArchitectureComponent >> generateNewArchitectureFromXmi: aFile [

	^ CPPSArchitectureXMIImporter
		  generateArchitectureFrom: aFile rawContents
		  model: self model
		  tagModel: self tagModel
]

{ #category : #accessing }
CPPSCreateArchitectureComponent >> owner [

	^ owner
]

{ #category : #accessing }
CPPSCreateArchitectureComponent >> owner: anObject [

	owner := anObject
]

{ #category : #rendering }
CPPSCreateArchitectureComponent >> renderCancelButtonOn: html [

	self owner hasArchitectures ifTrue: [ ^ self ].
	html mdlAnchorButton
		class: #cancel;
		callback: [ "we just refresh" ];
		with: (self
				 english: 'Cancel'
				 french: 'Annuler')
]

{ #category : #rendering }
CPPSCreateArchitectureComponent >> renderContentOn: html [

	self flag: #todo. "should not be here. Improve the css to make it more generic."
	html div
		class: 'projectManager';
		class: 'architecture-new__form';
		with:
			[ html div
				class: 'smallComponent';
				with:
					[ html heading
						level: 2;
						with: (self translate: ('Create a new architecture' french: 'Créer une nouvelle architecture')).
					self renderNewArchitectureFormOn: html
					]
			]
]

{ #category : #rendering }
CPPSCreateArchitectureComponent >> renderGenerationChoiceOn: html [

	html div
		class: #'architecture-new__radio';
		with:
			[ html radioGroup:
					[ :group | 
					html
						mdlRadioContainerFor: html nextId
						with:
							[ group mdlRadioButton
								id: html lastId;
								callback: [ newArchitecture := CPPSArchitectureLayer newRoot ];
								onChange: '$(".uploadContainer").children().prop( "disabled", this.checked);' js;
								beChecked.
							html mdlRadioLabel: (self
									 english: 'Empty'
									 french: 'Vierge')
							].
					self
						duplicationChoice: html
						radioGroup: group.
					html
						mdlRadioContainerFor: html nextId
						with:
							[ group mdlRadioButton
								id: html lastId;
								onChange: '$(".uploadContainer").children().prop( "disabled", this.checked);' js;
								callback: [ newArchitecture := self model createArchitecture ].
							html mdlRadioLabel: (self
									 english: 'Generated from current version'
									 french: 'Généré depuis la version courante')
							].
					html
						mdlRadioContainerFor: html nextId
						with:
							[ group mdlRadioButton
								id: html lastId;
								onChange: '$(".uploadContainer").children().prop( "disabled", !this.checked);' js;
								onLoad: '$(".uploadContainer").children().prop( "disabled", !this.checked);' js.
							html mdlRadioLabel: (self
									 english: 'Generate from XMI file'
									 french: 'Généré depuis un fichier XMI')
							]
					].
			html div
				class: 'uploadContainer';
				with:
					[ html mdlMajorButton
						disabled: true;
						with: (self
								 english: 'Browse'
								 french: 'Sélectionnez').
					html fileUpload
						onChange: html jQuery ajax serializeThis;
						accept: '.xmi';
						class: 'toHide';
						disabled: true;
						callback: [ :file | newArchitecture := self generateNewArchitectureFromXmi: file ]
					]
			]
]

{ #category : #rendering }
CPPSCreateArchitectureComponent >> renderNewArchitectureFormOn: html [

	html div
		paddedForm;
		with:
			[ html div
				class: 'form-wrap';
				with:
					[ html form
						multipart;
						with:
							[ self renderGenerationChoiceOn: html.
							self renderTextInputOn: html.
							html break.
							html mdlSubmitButton: (self
										 english: 'Create'
										 french: 'Créer')
							].
					self renderCancelButtonOn: html
					]
			]
]

{ #category : #rendering }
CPPSCreateArchitectureComponent >> renderTextInputOn: html [

	html render: (MDLTextFieldWidget
			 labeled: (self translate: ('Architecture name' french: 'Nom de l''architecture'))
			 callback: [ :name | self createNewArchitectureNamed: name ]
			 floatingLabel: true)
]
