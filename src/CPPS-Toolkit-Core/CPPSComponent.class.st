"
Description
--------------------

I am an abstract class for all the toolkit's components.

I allow to implement some conveniance methods as un acces to the server or to the library.
"
Class {
	#name : #CPPSComponent,
	#superclass : #WAComponent,
	#traits : 'THeimdallComponent + TWithRootDialogComponent',
	#classTraits : 'THeimdallComponent classTrait + TWithRootDialogComponent classTrait',
	#category : #'CPPS-Toolkit-Core-Core'
}

{ #category : #conveniance }
CPPSComponent class >> colorPalette [

	^ MDLColor
]

{ #category : #conveniance }
CPPSComponent class >> webLibrary [

	^ CPPSLibrary
]

{ #category : #convenience }
CPPSComponent >> addArchitecture: anArchitecture [

	^ self project addArchitecture: anArchitecture
]

{ #category : #convenience }
CPPSComponent >> architectures [

	^ self project architectures
]

{ #category : #convenience }
CPPSComponent >> colorPalette [

	^ self class colorPalette
]

{ #category : #convenience }
CPPSComponent >> configuration [

	^ self server configuration
]

{ #category : #personalisation }
CPPSComponent >> confirm: aString onAnswer: aBlock [

	"Display a yes/no dialog with caption aString. Evaluate aBlock passing in true if the response is yes, false if no."

	self
		call: (CPPSYesOrNoDialog new
				 addMessage: aString;
				 addDecoration: (CPPSDivDecoration htmlClass: 'yesNo');
				 yourself)
		onAnswer: aBlock
]

{ #category : #convenience }
CPPSComponent >> correlationsStorage [

	^ self project correlationsStorage
]

{ #category : #convenience }
CPPSComponent >> currentTag [

	^ self session currentTag
]

{ #category : #convenience }
CPPSComponent >> currentTag: aTag [

	self session currentTag: aTag
]

{ #category : #convenience }
CPPSComponent >> currentUser [

	^ self session loggable ifNil: [ CPPSUserNotLoggedException signal: 'No user logged.' ]
]

{ #category : #'convenience-navigation' }
CPPSComponent >> displayBrowserClass: class onEntity: anEntity [

	^ self rootComponent
		  displayBrowserClass: class
		  onEntity: anEntity
]

{ #category : #'convenience-navigation' }
CPPSComponent >> displayBrowserClass: browserClass withSelection: selection [

	^ self rootComponent
		  displayBrowserClass: browserClass
		  withSelection: selection
]

{ #category : #convenience }
CPPSComponent >> english: aString french: aTranslation [

	^ self translate: (aString french: aTranslation)
]

{ #category : #testing }
CPPSComponent >> hasAtLeastOneProjectVersion [

	^ self server project versions isNotEmpty
]

{ #category : #convenience }
CPPSComponent >> jsShowRootDialog: aString [

	^ ('showRootSnackbar("' , aString , '");') js
]

{ #category : #convenience }
CPPSComponent >> model [

	^ self currentUser model
]

{ #category : #'convenience-navigation' }
CPPSComponent >> obtainBrowserFor: selectionOrEntity [

	"We sort by lower priority because there is a high chance that the higher priority can open on more entities. Maybe this should be refactored later to use a notation system to know which revelent browser is the most revelent for the input."

	^ (CPPSAbstractBrowser allConcreteSubclasses sorted: [ :a :b | a priority < b priority ])
		  detect: [ :class | class isReleventFor: selectionOrEntity ]
		  ifNone: [ CPPSNoBrowserToDisplayException signal ]
]

{ #category : #'convenience-navigation' }
CPPSComponent >> openAdaptatedBrowserOn: anEntityOrACollectionOfEntities [

	| browserClass |

	browserClass := self obtainBrowserFor: anEntityOrACollectionOfEntities.
	anEntityOrACollectionOfEntities isCollection
		ifTrue:
			[ self
				displayBrowserClass: browserClass
				withSelection: anEntityOrACollectionOfEntities
			]
		ifFalse:
			[ self
				displayBrowserClass: browserClass
				onEntity: anEntityOrACollectionOfEntities
			]
]

{ #category : #convenience }
CPPSComponent >> project [

	^ self server project
]

{ #category : #convenience }
CPPSComponent >> queries [

	^ self queryStorage
]

{ #category : #convenience }
CPPSComponent >> queryStorage [

	^ self project queryStorage
]

{ #category : #javascript }
CPPSComponent >> refreshCurrentTagScriptFrom: html [

	^ (html jQuery id: #'current-tag') load html: [ :r | self renderCurrentTagInfoOn: r ]
]

{ #category : #architecture }
CPPSComponent >> removeArchitectureBasedOnTag: aFamixTag [

	self project removeArchitectureBasedOnTag: aFamixTag
]

{ #category : #rendering }
CPPSComponent >> renderCurrentTagInfoOn: html [

	html mdlIcon
		style: [ 'color: #' , self currentTag color asHexString , ';' ]
		if: self currentTag isNotNil;
		style: 'text-shadow: -1px 0 3px rgba(255,255,255,0.2), 0 1px 3px rgba(255,255,255,0.2), 1px 0 3px rgba(255,255,255,0.2), 0 -1px 3px rgba(255,255,255,0.2);'
		if: (self currentTag isNotNil and: [ self currentTag color luminance < 0.5 ]);
		with: #label.
	html break.
	html text: (self currentTag
			 ifNil:
				 [ self
					 english: 'No current tag'
					 french: 'Pas de tag courant'
				 ]
			 ifNotNil: [ :t | t name ]).
	html
		mdlLargeTooltipFor: #'current-tag'
		with: (self
				 english: 'This tag is your current tag. You will be able to use it as a fast way to act on some tools.'
				 french: 'Voici votre tag courant. Vous serez capable de l''utiliser pour agir rapidement sur certain outils.')
]

{ #category : #rendering }
CPPSComponent >> renderCurrentTagSelectionOn: html [

	html mdlDialogTitle: (self
			 english: 'Select current tag'
			 french: 'Sélectionner le tag courant').
	html mdlDialogContent:
		[ html render: ((CPPSTagListWindowsManagerDecorator
				  tags: [ self tagModel rootTags ]
				  actionBlock: [ :tag | self currentTag: tag ]
				  actionTooltipBlock:
					  [ :tag | 
					  (self
						   english: 'Set as current tag: '
						   french: 'Utiliser comme tag courant: ') , tag name
					  ]
				  actionLabelBlock:
					  [ :tag | 
					  self currentTag = tag
						  ifTrue: [ #label ]
						  ifFalse: [ #label_outline ]
					  ])
				 addTagFilter;
				 addTextFilter;
				 addCreateTagButton)
		].
	html mdlDialogActions:
		[ html mdlButton
			bePush;
			id: self rootDialogCloseId;
			onClick: 'location.reload();' js
			if: self currentTag isNil;
			with: (self
					 english: 'Close'
					 french: 'Fermer')
		]
]

{ #category : #components }
CPPSComponent >> rootComponent [

	^ self session rootComponent
]

{ #category : #convenience }
CPPSComponent >> rulesManager [

	self flag: #TODO. "Change it, it is stupid the rules manager being known by the model; it should be known by the project"
	^ self model rulesManager
]

{ #category : #accessing }
CPPSComponent >> server [

	^ CPPSServer current
]

{ #category : #accessing }
CPPSComponent >> strategy [

	^ self server currentStrategy
]

{ #category : #convenience }
CPPSComponent >> tagModel [

	^ self project tagModel
]

{ #category : #convenience }
CPPSComponent >> webLibrary [

	^ self class webLibrary
]
