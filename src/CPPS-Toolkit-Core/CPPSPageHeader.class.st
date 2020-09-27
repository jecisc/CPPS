"
Description
--------------------

I am a component to render the header of Web Solution. I am a work in progress. For now I am full of hack to get a working version but I should be clean latter.
"
Class {
	#name : #CPPSPageHeader,
	#superclass : #CPPSComponent,
	#instVars : [
		'onBrowserChange'
	],
	#category : #'CPPS-Toolkit-Core-Core'
}

{ #category : #'instance creation' }
CPPSPageHeader class >> onBrowserChange: aBlock [

	^ self new
		  onBrowserChange: aBlock;
		  yourself
]

{ #category : #accessing }
CPPSPageHeader >> browsers [

	^ CPPSAbstractBrowser allConcreteSubclasses sorted: [ :a :b | a priority > b priority ]
]

{ #category : #testing }
CPPSPageHeader >> canAccessToBrowsers [

	^ self session isLogged and:
		  [ [ self currentUser version.
		  true
		  ]
			  on: NoGeneratedVersionException
			  do: [ false ]
		  ]
]

{ #category : #accessing }
CPPSPageHeader >> currentUserVersion [

	^ self currentUser version
]

{ #category : #testing }
CPPSPageHeader >> isGenerationInProgress [

	^ self session isLogged and: [ self currentUser project generationInProgress ]
]

{ #category : #accessing }
CPPSPageHeader >> onBrowserChange [

	^ onBrowserChange
]

{ #category : #accessing }
CPPSPageHeader >> onBrowserChange: aBlock [

	onBrowserChange := aBlock
]

{ #category : #rendering }
CPPSPageHeader >> renderAdministrationOn: html [

	(self session isLogged and:
		 [ self flag: #TODO. "self currentUser isAllowedTo: #adminAccess"
		 true
		 ]) ifFalse: [ ^ self ].
	html mdlNavigationLink
		id: html nextId;
		callback: [ self onBrowserChange value: CPPSAdminBrowser ];
		with: [ html mdlIcon: #build ].
	html
		mdlLargeTooltipFor: html lastId
		with: 'Administration'
]

{ #category : #rendering }
CPPSPageHeader >> renderBrowserNameOn: html [

	"Do not display the browser name if the user is not logged or if there is no version generated."

	(self session isLogged not or: [ self hasAtLeastOneProjectVersion not ]) ifTrue: [ ^ self ].
	html span
		class: #'browser-name';
		with: ([ self translate: self rootComponent browser class browserName ]
				 on: MessageNotUnderstood
				 do:
					 [ :ex | 
					 'ERROR no browser name to display.' record.
					 ''
					 ])
]

{ #category : #rendering }
CPPSPageHeader >> renderContentOn: html [

	html mdlLayoutHeader:
		[ html mdlLayoutHeaderRow:
			[ self renderLogoOn: html.
			self renderBrowserNameOn: html.
			html mdlLayoutSpacer.
			html mdlNavigation:
				[ self
					renderCurrentTagOn: html;
					renderAdministrationOn: html;
					renderHeaderNavigationOn: html;
					renderGenerationStateOn: html;
					renderLanguageSelectionOn: html;
					renderLogoutOn: html
				]
			]
		].
	self renderDrawerOn: html
]

{ #category : #rendering }
CPPSPageHeader >> renderCurrentTagOn: html [

	self session isLogged ifFalse: [ ^ self ].
	html mdlNavigationLink
		id: #'current-tag';
		style: 'cursor: pointer;';
		openDialogWithId: self rootDialogOpenId;
		onClickUpdateRootDialogWith: [ :r | self renderCurrentTagSelectionOn: r ];
		with: [ self renderCurrentTagInfoOn: html ]
]

{ #category : #rendering }
CPPSPageHeader >> renderDrawerOn: html [

	self canAccessToBrowsers ifFalse: [ ^ self ].
	html mdlLayoutDrawer:
		[ html mdlNavigation:
			[ self browsers do:
				[ :browser | 
				html mdlNavigationLink
					beCurrentIf: self rootComponent browser class = browser;
					callback: [ self onBrowserChange value: browser ];
					with: (self translate: browser browserName)
				]
			]
		]
]

{ #category : #rendering }
CPPSPageHeader >> renderGenerationStateOn: html [

	self isGenerationInProgress ifFalse: [ ^ self ].
	html div
		id: html nextId;
		class: 'generationState';
		with: [ html mdlSpinner active ].
	html
		mdlLargeTooltipFor: html lastId
		with: (self
				 english: 'A version is in generation.'
				 french: 'Une version est en cours de génération.')
]

{ #category : #rendering }
CPPSPageHeader >> renderHeaderNavigationOn: html [

	self session isLogged ifFalse: [ ^ self ].
	html mdlNavigationLink
		id: html nextId;
		callback: [ self onBrowserChange value: CPPSProjectManager ];
		with: [ html mdlIcon: #featured_play_list ].
	html
		mdlLargeTooltipFor: html lastId
		with: ([ String streamContents:
				 [ :s | 
				 s nextPutAll: (self
						  english: 'You are currently on the version '
						  french: 'Vous travaillez actuellement sur la version ').
				 self currentUserVersion printIdOn: s
				 ]
			 ]
				 on: NoGeneratedVersionException
				 do:
					 [ self
						 english: 'No version currently available'
						 french: 'Pas de version actuellement disponible'
					 ])
]

{ #category : #rendering }
CPPSPageHeader >> renderLanguageSelectionOn: html [

	html render: CPPSLanguageSelectionComponent new
]

{ #category : #rendering }
CPPSPageHeader >> renderLogoOn: html [
	| link |
	link := html mdlNavigationLink.
	self canAccessToBrowsers ifTrue: [ link callback: [ self onBrowserChange value: CPPSAbstractBrowser default ] ].
	link
		style: 'padding: 0;';
		with: [ self renderTechnologyLogoOn: html ]
]

{ #category : #rendering }
CPPSPageHeader >> renderLogoutOn: html [

	self session isLogged ifFalse: [ ^ self ].
	html mdlNavigationLink
		id: html nextId;
		callback: [ self session disconnect ];
		with: [ html mdlIcon: 'power_settings_new' ].
	html
		mdlLargeTooltipFor: html lastId
		with: (self
				 english: 'Log out '
				 french: 'Déconnexion ') , self session loggable login
]

{ #category : #rendering }
CPPSPageHeader >> renderTechnologyLogoOn: html [

	html image
		class: 'logo';
		url: self strategy urlOfLogo
]
