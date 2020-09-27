"
Description
--------------------

I am a really simple component to save the current model.
"
Class {
	#name : #CPPSSaveModelComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'newVersionModelPath'
	],
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #testing }
CPPSSaveModelComponent >> isCurrentVersionCopy [

	^ self currentUser version isCopy
]

{ #category : #testing }
CPPSSaveModelComponent >> isGoodToSave [

	self isCurrentVersionCopy ifTrue: [ ^ true ].
	^ self newVersionModelPath isNil or: [ self newModelDirectory = self model rootFolder asFileReference or: [ self newModelDirectory exists ] ]
]

{ #category : #testing }
CPPSSaveModelComponent >> isNewDirectoryDifferentOfOldOne [

	^ self newModelDirectory ~= self model rootFolder asFileReference
]

{ #category : #accessing }
CPPSSaveModelComponent >> newModelDirectory [

	^ self newVersionModelPath asFileReference
]

{ #category : #accessing }
CPPSSaveModelComponent >> newVersionModelPath [

	^ newVersionModelPath
]

{ #category : #accessing }
CPPSSaveModelComponent >> newVersionModelPath: anObject [

	newVersionModelPath := anObject
]

{ #category : #rendering }
CPPSSaveModelComponent >> renderConfirmationOn: html [

	html div
		class: #yesNo;
		with:
			[ html text: (self
						 english: 'This action can take some minutes. Are you sure you want to persist version of the '
						 french: 'Cette action peut prendre plusieurs minutes. Êtes vous certain de vouloir persister la version du ') , self currentUser version separateDateAndTime.
			html div
				style: 'display: flex; margin-top: 10px;';
				with:
					[ html mdlButton
						raised;
						rippleEffect;
						callback: [ self save ];
						with: (self
								 english: 'Yes'
								 french: 'Oui').
					html mdlButton
						raised;
						rippleEffect;
						callback: [  ];
						with: (self
								 english: 'No'
								 french: 'Non')
					]
			]
]

{ #category : #rendering }
CPPSSaveModelComponent >> renderContentOn: html [

	self flag: #todo. "I use the smallComponent in 3-4components for now. Maybe I should create a Trait to not duplicate the code."
	html div
		class: 'smallComponent';
		with:
			[ html heading
				level: 2;
				with: (self translate: ('Save your datas' french: 'Sauvez vos données')).
			html div
				paddedForm;
				with:
					[ html form
						class: 'form-wrap';
						id: 'save-component__form-content';
						with: [ self renderFormContentOn: html ]
					]
			]
]

{ #category : #rendering }
CPPSSaveModelComponent >> renderErrorMessageOn: html [

	self shouldDisplayErrorMessage ifFalse: [ ^ self ].
	html div
		class: #'error-message';
		with: (self
				 english: 'This path does not exist'
				 french: 'Ce chemin n''existe pas.')
]

{ #category : #rendering }
CPPSSaveModelComponent >> renderFormContentOn: html [

	self renderVersionModelPathOn: html.
	self renderInstructionsOn: html.
	self renderSaveButtonOn: html
]

{ #category : #rendering }
CPPSSaveModelComponent >> renderInstructionsOn: html [

	html div
		class: 'instruction';
		with:
			[ html span: (self
						 english: 'Save your current tags and architectures.'
						 french: 'Sauvez vos tags courants et vos architectures.')
			]
]

{ #category : #rendering }
CPPSSaveModelComponent >> renderSaveButtonOn: html [

	"We save the version inside an ivar because the context in not accessible inside a fork. The version is access via the context so we need to reference it before the fork."

	html mdlButton
		bePush;
		accentColor;
		raised;
		rippleEffect;
		onClick: ((html jQuery id: #'save-component__form-content') load html:
					 [ :r | 
					 self isGoodToSave
						 ifTrue: [ self renderConfirmationOn: r ]
						 ifFalse: [ self renderFormContentOn: r ]
					 ]);
		with: (self
				 english: 'Save'
				 french: 'Sauvez')
]

{ #category : #rendering }
CPPSSaveModelComponent >> renderVersionModelPathOn: html [

	self isCurrentVersionCopy ifTrue: [ ^ self ].
	self renderErrorMessageOn: html.
	html div
		class: #'save-component__path-input';
		with:
			[ | id |

			html mdlTextFieldContainer
				floatingLabel;
				with:
					[ html mdlTextFieldLabel
						for: (id := html nextId);
						with: (self
								 english: 'Relative sources path from the server.'
								 french: 'Chemin relatif vers les sources à partir du server.').
					html mdlTextFieldInput
						id: id;
						callback: [ :input | self newVersionModelPath: input ];
						onChange: html jQuery ajax serializeThis;
						value: (self newVersionModelPath ifNil: [ self model rootFolder asFileReference fullName ]);
						type: 'text'
					].
			html anchor
				callback: [ self newVersionModelPath: nil ];
				with:
					[ html mdlIcon
						class: #delete;
						id: (id := html nextId);
						with: #autorenew
					].
			html
				mdlLargeTooltipFor: id
				with: (self
						 english: 'Reset to original path'
						 french: 'Réinitialiser au chemin original')
			]
]

{ #category : #action }
CPPSSaveModelComponent >> save [

	| version |

	self updatePathOfCurrentVersion.
	CPPSServer isPersistanceInProgress: true.
	version := self currentUser version.
	[ [ version persist ]
		on: NoPersistanceManagerException
		do: [  ].
	self server lastVersionModel: version mooseModel.
	CPPSServer isPersistanceInProgress: false
	] fork
]

{ #category : #testing }
CPPSSaveModelComponent >> shouldDisplayErrorMessage [

	^ self newVersionModelPath isNotNil and: [ self newModelDirectory exists not ]
]

{ #category : #testing }
CPPSSaveModelComponent >> shouldUpdatePathOfModel [

	self isCurrentVersionCopy ifTrue: [ ^ false ].
	^ self newVersionModelPath isNotNil and: [ self isNewDirectoryDifferentOfOldOne and: [ self newModelDirectory exists ] ]
]

{ #category : #action }
CPPSSaveModelComponent >> updatePathOfCurrentVersion [

	self shouldUpdatePathOfModel ifFalse: [ ^ self ].
	self currentUser version updatePathOfModelTo: self newVersionModelPath
]
