"
Description
--------------------

I am the root component of the Web solution.
I am a work in progress. I will change in the future. I am a developemnt version.
"
Class {
	#name : #CPPSRoot,
	#superclass : #CPPSComponent,
	#traits : 'TRootDialogRenderer',
	#classTraits : 'TRootDialogRenderer classTrait',
	#instVars : [
		'browser',
		'headerComponent',
		'browsersInstances',
		'loginComponent'
	],
	#category : #'CPPS-Toolkit-Core-Core'
}

{ #category : #'class initialization' }
CPPSRoot class >> applicationName [

	^ 'siemensToolkit'
]

{ #category : #helpers }
CPPSRoot class >> developmentMode [

	"Because it's a pain in the ass to always set it by hand in Seaside settings."

	<script>
	self restoreSeasideDiv.
	self useInImageDebugger.
	self setTelescopeInDevelopmentMode.
	self setPrismInDevelopmentMode.
	self restoreUIManager
]

{ #category : #initialization }
CPPSRoot class >> initialize [

	(WAAdmin
		 register: self
		 asApplicationAt: self applicationName)
		preferenceAt: #sessionClass
		put: CPPSSession;
		preferenceAt: #maximumAbsoluteAge
		put: 0;
		preferenceAt: #maximumRelativeAge
		put: self sessionDuration;
		addLibrary: MDLLibrary;
		addLibrary: ChartJsLibrary;
		addLibrary: HeimdallFileLibrary;
		addLibrary: PrismLibrary;
		addLibrary: JQDeploymentLibrary;
		addLibrary: JQUiDeploymentLibrary;
		addLibrary: CYSFileLibrary;
		addLibrary: CPPSLibrary;
		initializeCache
]

{ #category : #'world menu' }
CPPSRoot class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #'Development mode')
		order: 5;
		parent: #SiemensToolkit;
		action: [ self developmentMode ].
	(aBuilder item: #'Open tool')
		order: 1;
		iconName: #glamorousOver;
		parent: #SiemensToolkit;
		action: [ self open ]
]

{ #category : #'world menu' }
CPPSRoot class >> open [

	| port |

	WAServerManager default adaptors
		ifEmpty: [ (ZnZincServerAdaptor port: (port := 8087)) start ]
		ifNotEmpty:
			[ :adaptors | 
			adaptors
				detect: #isRunning
				ifFound: [ :anAdaptor | port := anAdaptor server port ]
				ifNone: [ (ZnZincServerAdaptor port: (port := 8087)) start ]
			].
	WebBrowser openOn: 'http://localhost:' , port asString , '/' , self applicationName
]

{ #category : #helpers }
CPPSRoot class >> restoreSeasideDiv [

	<script>
	WAHtmlCanvas
		compile: 'div
	"Defines a section in a document."

	^ self tag: ''div'''
		classified: 'tags-styles'
		withStamp: 'Jenkins 12/21/2016 11:14'
		notifying: nil
]

{ #category : #helpers }
CPPSRoot class >> restoreUIManager [

	"Set back a UIManager that opens debuggers when notifications are raised."

	<script>
	UIManager
		classVarNamed: 'Default'
		put: MorphicUIManager new.
	UIManager default activate
]

{ #category : #'class initialization' }
CPPSRoot class >> sessionDuration [

	"60 minutes"

	^ 3600
]

{ #category : #helpers }
CPPSRoot class >> setPrismInDevelopmentMode [

	<script>
	PrismComponent beDevelopment
]

{ #category : #helpers }
CPPSRoot class >> setTelescopeInDevelopmentMode [

	<script>
	TLCytoscapeWebSocketDelegate beDevelopment
]

{ #category : #helpers }
CPPSRoot class >> useExceptionCatcherDiv [

	<script>
	WAHtmlCanvas
		compile: 'div
	"Defines a section in a document."

	^ self brush: CPPSDivExceptionCatcherTag new'
		classified: 'tags-styles'
]

{ #category : #helpers }
CPPSRoot class >> useInImageDebugger [

	"Because it's a pain in the ass to always set it by hand in Seaside settings."

	<script>
	WAApplication allInstancesDo: [ :app | app exceptionHandler: WADebugErrorHandler ]
]

{ #category : #accessing }
CPPSRoot >> browser [

	^ browser ifNil: [ browser := self instanceOf: CPPSAbstractBrowser default ]
]

{ #category : #accessing }
CPPSRoot >> browser: anObject [

	browser := anObject
]

{ #category : #accessing }
CPPSRoot >> browsersInstances [

	^ browsersInstances
]

{ #category : #accessing }
CPPSRoot >> browsersInstances: anObject [

	browsersInstances := anObject
]

{ #category : #hooks }
CPPSRoot >> children [

	^ { 
		  self headerComponent.
		  self mainComponentToDisplay }
]

{ #category : #components }
CPPSRoot >> defaultHeaderComponent [

	^ CPPSPageHeader onBrowserChange: [ :aBrowser | self displayBrowserClass: aBrowser ]
]

{ #category : #components }
CPPSRoot >> displayBrowserClass: aBrowser [

	^ self browser: (self instanceOf: aBrowser)
]

{ #category : #components }
CPPSRoot >> displayBrowserClass: aBrowser onEntity: anEntity [

	^ self browser: ((self instanceOf: aBrowser) onEntity: anEntity)
]

{ #category : #components }
CPPSRoot >> displayBrowserClass: aBrowser withSelection: aSelection [

	^ self browser: ((self instanceOf: aBrowser)
			   selection: aSelection;
			   yourself)
]

{ #category : #'error-management' }
CPPSRoot >> displayErrorMessages: aCollectionOfErrorMessages on: html [

	aCollectionOfErrorMessages do:
		[ :mess | 
		html script: 'window.addEventListener("load",function(){ ' , (html mdlSnackbar
				 message: (self translate: mess);
				 getJsShowingSnackbar) , ' }, false); '
		]
]

{ #category : #initialization }
CPPSRoot >> ensureCurrentBrowserIsTheAdministrationBrowser [

	browser class = CPPSAdminBrowser ifTrue: [ ^ self ].

	"Do not use the accessor because we might not have any model for now."
	self displayBrowserClass: CPPSProjectManager
]

{ #category : #accessing }
CPPSRoot >> headerComponent [

	^ headerComponent
]

{ #category : #accessing }
CPPSRoot >> headerComponent: anObject [

	headerComponent := anObject
]

{ #category : #initialization }
CPPSRoot >> initialize [

	<siemensToolkitApplication>
	super initialize.
	browsersInstances := Dictionary new.
	headerComponent := self defaultHeaderComponent.
	self session rootComponent: self
]

{ #category : #accessing }
CPPSRoot >> instanceOf: aBrowser [

	^ self browsersInstances
		  at: aBrowser
		  ifAbsentPut: [ aBrowser new ]
]

{ #category : #testing }
CPPSRoot >> isGenerationInProgress [

	^ self server project generationInProgress
]

{ #category : #accessing }
CPPSRoot >> loginComponent [

	^ loginComponent ifNil: [ loginComponent := self newLoginComponent ]
]

{ #category : #accessing }
CPPSRoot >> loginComponent: anObject [

	loginComponent := anObject
]

{ #category : #accessing }
CPPSRoot >> mainComponentToDisplay [

	^ self session isLogged
		  ifTrue:
			  [ self waitingComponent ifNil:
				  [ self hasAtLeastOneProjectVersion ifFalse: [ self ensureCurrentBrowserIsTheAdministrationBrowser ].
				  self browser
				  ]
			  ]
		  ifFalse: [ self loginComponent ]
]

{ #category : #components }
CPPSRoot >> newLoginComponent [

	self flag: #TODO.
	"the post action may use the CPPSServer object instead of moose project"
	^ (CPPSHeimdallLoginComponent
		   withLoggableManager: CPPSUserManager
		   postAction: [ :user | user project: self project ])
		  addDecoration: (CPPSDivDecoration htmlClass: 'loginPage');
		  yourself
]

{ #category : #rendering }
CPPSRoot >> renderContentOn: html [

	html mdlLayout
		fixedHeader;
		with:
			[ html render: self headerComponent.
			(html tag: 'main')
				class: 'browser';
				with: [ html render: self mainComponentToDisplay ]
			].
	self
		displayErrorMessages: self popAllErrorMessages
		on: html.
	self renderEmptyGenericDialogOn: html.
	html mdlSnackbarWithId: 'rootSnackbar'.
	html document addLoadScript: 'updateDefaultQTipOptions()' js
]

{ #category : #updating }
CPPSRoot >> resetInstances [

	self browsersInstances removeAll.
	self browser ifNotNil: [ :brow | self browser: (self instanceOf: brow class) ]
]

{ #category : #hooks }
CPPSRoot >> states [

	^ Array with: self
]

{ #category : #updating }
CPPSRoot >> updateRoot: anHtmlRoot [

	super updateRoot: anHtmlRoot.
	anHtmlRoot beHtml5.
	anHtmlRoot link
		beShortcutIcon;
		url: (self webLibrary urlOf: 'tabLogoPng').
	anHtmlRoot title: 'Inventive Toolkit'
]

{ #category : #accessing }
CPPSRoot >> waitingComponent [

	self flag: #todo. "This is bad and need to be clean later. We should not hardcode this here."
	^ CPPSServer isPersistanceInProgress
		  ifTrue:
			  [ CPPSProgressComponent
				  titled: (self
						   english: 'Persistance of the current version'
						   french: 'Persistance de la version courrante.')
				  message: (self
						   english: 'The current version is been saved in order to persist your tags and architectures. This operation can takes several minutes.'
						   french: 'La version courrante est en train d''être sauvée pour rendre vos tags et architectures persistantes. Cette opération peut prendre quelques minutes. ')
				  isFinishBlock: [ CPPSServer isPersistanceInProgress not ]
			  ]
		  ifFalse: [ nil ]
]
