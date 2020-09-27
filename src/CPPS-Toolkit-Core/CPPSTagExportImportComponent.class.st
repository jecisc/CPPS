"
Description
--------------------

I am a component that will allow the user to download the current tags of the system and their linking to the entities of its current version. I am also able to receive a similar file from the user and to inject it in the current version and the tag model
"
Class {
	#name : #CPPSTagExportImportComponent,
	#superclass : #CPPSComponent,
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #'as yet unclassified' }
CPPSTagExportImportComponent >> exportTagsForCurrentVersion [

	self requestContext respond:
		[ :response | 
		| stream |

		self model
			exportTagsOn: (stream := '' writeStream)
			tagModel: self tagModel.
		response
			contentType: (WAMimeType
					 main: 'text'
					 sub: 'ston');
			document: stream close;
			contents;
			attachmentWithFileName: (String streamContents:
						 [ :s | 
						 s << 'tags_'.
						 s << Date today yyyymmdd.
						 s << '.ston'
						 ])
		]
]

{ #category : #'as yet unclassified' }
CPPSTagExportImportComponent >> receiveFile: aFile [

	(self confirm: aFile fileName , (self
			  english: ': Are you sure you want to inject this tag file? This operation will not be revertable. None of your current tagging will be lost but this injection can create many new tags and associations'
			  french: ': Etes-vous sûr de vouloir injecter ce fichier de tags? Cette opération ne sera pas réversible. Vous ne perdrez rien de votre tagging actuel mais cette injection peut créer de nombreux tags et associations')) ifFalse: [ ^ self ].
	self model
		importTagsFrom: (aFile contentsDecodedUsing: 'ISO-8859-1') readStream
		tagModel: self tagModel
]

{ #category : #rendering }
CPPSTagExportImportComponent >> renderContentOn: html [

	html div
		class: 'importExportTagComponent';
		class: 'smallComponent';
		with:
			[ html heading
				level: 2;
				with: (self translate: ('Tag Managing' french: 'Gestion des tags')).
			html div
				paddedForm;
				beCentered;
				with:
					[ self tagFileDownload: html.
					html space.
					self tagFileUpload: html
					]
			]
]

{ #category : #rendering }
CPPSTagExportImportComponent >> tagFileDownload: html [

	html div
		class: 'instruction';
		with:
			[ html span: (self
						 english: 'Save the current system tagging'
						 french: 'Télécharger une sauvegarde du tagging actuel du système')
			].
	html mdlAnchorButton
		accentColor;
		raised;
		rippleEffect;
		callback: [ self exportTagsForCurrentVersion ];
		with: (self
				 english: 'Download'
				 french: 'Téléchargement')
]

{ #category : #rendering }
CPPSTagExportImportComponent >> tagFileUpload: html [

	^ html form
		  multipart;
		  paddedForm;
		  class: 'versionCreator';
		  with:
			  [ html div
				  class: 'form-wrap';
				  with:
					  [ html div
						  class: 'instruction';
						  with:
							  [ html span: (self
										   english: 'Upload a previously saved tags file'
										   french: 'Envoyer un fichiers de tags précédemment sauvé')
							  ].
					  html div
						  class: 'uploadContainer';
						  with:
							  [ html mdlMajorButton
								  id: 'tag_input';
								  with: (self
										   english: 'Browse'
										   french: 'Sélectionnez').
							  html fileUpload
								  class: 'toHide';
								  id: #tag_input_toHide;
								  onChange: '$(this).click(function(event){event.preventDefault();});$("#tag_input").prop( "disabled", true );javascript:this.form.submit();';
								  callback: [ :value | self receiveFile: value ]
							  ]
					  ]
			  ]
]
