"
Description
--------------------

I am a component used to create a new version of a Moose project.
I am responsible for configuring a CPPSVersionCreationStrategy object.
The configuration of this object will later drive the creation of the Moose project version.
I delegate the form display and validation to magritte
"
Class {
	#name : #CPPSVersionCreationFormComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'project',
		'formComponent',
		'formContentId',
		'versionCreator'
	],
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #'instance creation' }
CPPSVersionCreationFormComponent class >> project: aMooseProject [

	^ self new
		  project: aMooseProject;
		  yourself
]

{ #category : #private }
CPPSVersionCreationFormComponent >> ajaxScriptOn: html [

	^ html jQuery script:
		  [ :s | "Last we launch the file upload, serialize the form and display the confirmation if there is no error."
		  s
			  << 'this.disabled = true;' js;
			  "First we disable the button"<< (html jQuery this parent append:
						   [ :r | 
						   r mdlSpinner
							   style: 'float: right;';
							   active;
							   singleColor
						   ]);
			  << 'componentHandler.upgradeDom();' js;
			  "Then we add a spinner and upgrade it."<< ((html jQuery ajax serializeFileUpload: (html jQuery class: CPPSMDLFileUploadComponent fileUploadClass)) onComplete: ((html jQuery id: self formContentId) load
					    serializeChildren: (html jQuery id: self formContentId);
					    html:
						    [ self formComponent save.
						    self formComponent errors
							    ifEmpty: [ self renderConfirmOn: html ]
							    ifNotEmpty: [ self renderFormInputsOn: html ]
						    ];
					    onComplete: 'componentHandler.upgradeDom();' js))
		  ]
]

{ #category : #accessing }
CPPSVersionCreationFormComponent >> errors [

	^ self formComponent errors
]

{ #category : #accessing }
CPPSVersionCreationFormComponent >> formComponent [

	^ formComponent ifNil: [ formComponent := self versionCreator asMagritteComponent ]
]

{ #category : #accessing }
CPPSVersionCreationFormComponent >> formContentId [

	^ formContentId
]

{ #category : #accessing }
CPPSVersionCreationFormComponent >> formContentId: anObject [

	formContentId := anObject
]

{ #category : #accessing }
CPPSVersionCreationFormComponent >> project [

	^ project
]

{ #category : #accessing }
CPPSVersionCreationFormComponent >> project: anObject [

	project := anObject
]

{ #category : #rendering }
CPPSVersionCreationFormComponent >> renderButtonsOn: html [

	html div:
		[ html mdlMajorButton
			bePush;
			onClick: (self ajaxScriptOn: html);
			with: 'Run'
		]
]

{ #category : #rendering }
CPPSVersionCreationFormComponent >> renderConfirmOn: html [

	html text: (self
			 english: 'Do you really want to generate a new version'
			 french: 'Voulez vous vraiment générer une nouvelle version').
	html break.
	html break.
	html mdlButton
		style: ' display: inline-block;';
		callback: [ self answer: (self waitingComponentFor: self versionCreator) ];
		with: 'Yes'.
	html space.
	html mdlButton
		style: ' display: inline-block;';
		with: 'No'
]

{ #category : #rendering }
CPPSVersionCreationFormComponent >> renderContentOn: html [

	html div
		class: 'versionCreator';
		class: 'smallComponent';
		with:
			[ html heading
				level: 2;
				with: (self translate: ('Create new version' french: 'Créer une nouvelle version')).
			html form
				paddedForm;
				multipart;
				with:
					[ html div
						class: 'form-wrap';
						with: [ self renderFormContentOn: html ]
					]
			]
]

{ #category : #rendering }
CPPSVersionCreationFormComponent >> renderErrors: aCollection on: html [

	html break.
	html mdlAlert
		beDanger;
		with:
			[ html unorderedList
				class: 'errors';
				list: aCollection
			]
]

{ #category : #rendering }
CPPSVersionCreationFormComponent >> renderFormContentOn: html [

	self formContentId: html nextId.
	html div
		id: #'create-version__form';
		id: self formContentId;
		with: [ self renderFormInputsOn: html ]
]

{ #category : #rendering }
CPPSVersionCreationFormComponent >> renderFormInputsOn: html [

	self errors ifNotEmpty:
		[ :errors | 
		self
			renderErrors: errors
			on: html
		].
	html render: self formComponent.
	html break.
	self renderButtonsOn: html
]

{ #category : #accessing }
CPPSVersionCreationFormComponent >> versionCreator [

	^ versionCreator ifNil:
		  [ versionCreator := (CPPSVersionCreator
			                     project: self project
			                     technology: self server technology)
			                    initializeFromBrowserStrategy: self server currentStrategy;
			                    yourself
		  ]
]

{ #category : #private }
CPPSVersionCreationFormComponent >> waitingComponentFor: aVersionCreator [

	^ CPPSVersionCreationProgressComponent
		  titled: (self
				   english: 'A version is in generation.'
				   french: 'Une version est en cours de génération.')
		  message: (self
				   english: 'The first version of this project is in generation. When the generation will end the page will reload.'
				   french: 'La première version du projet est en génération. Quand la génération finira, la page se rechargera.')
		  during: [ aVersionCreator createVersionFor: self project ]
]
