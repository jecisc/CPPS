"
Description
--------------------

I am a command line to pass the application in deployment mode. This mode will, for example, remove useless applications of Seaside, add passwords to configurations or remove the dev toolbar. 

Examples
--------------------

	./pharo JavaOnWeb.image deployServer
 
"
Class {
	#name : #CPPSDeployServerCommandLineHandler,
	#superclass : #CPPSDeployCommandLineHandler,
	#category : #'CPPS-Toolkit-Core-Cli'
}

{ #category : #accessing }
CPPSDeployServerCommandLineHandler class >> commandName [

	^ 'deployServer'
]

{ #category : #activation }
CPPSDeployServerCommandLineHandler >> activate [

	self
		unregisterUselessTools;
		protectConfigByPassword;
		removeDevToolbar;
		setExceptionHandler;
		setRootAsDefault.
	super activate
]

{ #category : #activation }
CPPSDeployServerCommandLineHandler >> applicationsToUnregister [

	self flag: #discuss. "Let's discuss, maybe we can let some as Status."
	^ WAAdmin defaultDispatcher handlers keys \ #( 'siemensToolkit' 'files' 'projectGeneration' 'config' )
]

{ #category : #activation }
CPPSDeployServerCommandLineHandler >> openCustomFullscreenPresenter [

	CPPSServerDeploymentPresenter openFull
]

{ #category : #deployment }
CPPSDeployServerCommandLineHandler >> protectConfigByPassword [

	| application |

	'Protect configuration by password.' record.
	application := WAAdmin defaultDispatcher handlerAt: 'config'.
	application configuration addParent: WAAuthConfiguration instance.
	application
		preferenceAt: #login
		put: 'admin';
		preferenceAt: #passwordHash
		put: (GRPlatform current secureHashFor: 'seasideiscool').
	application addFilter: WAAuthenticationFilter new
]

{ #category : #deployment }
CPPSDeployServerCommandLineHandler >> removeDevToolbar [

	'Remove the dev toolbar.' record.
	WAAdmin disableDevelopmentTools. "What is following is a hack because of a seaside bug."
	(PragmaCollector filter: [ :prg | prg selector = #siemensToolkitApplication ]) reset do:
		[ :prg | 
		('Reset class: ' , prg methodClass asString) record.
		prg methodClass initialize
		]
]

{ #category : #deployment }
CPPSDeployServerCommandLineHandler >> setExceptionHandler [

	'Set exception handler.' record.
	WAApplication allInstancesDo: [ :app | app exceptionHandler: CPPSHtmlErrorHandler ].
	'Set the error catching div tag.' record.
	CPPSRoot useExceptionCatcherDiv
]

{ #category : #deployment }
CPPSDeployServerCommandLineHandler >> setRootAsDefault [

	"This will set siemensToolkit as the default application to show if the user is on his localhost."

	'Set siemens toolkit as default application' record.
	WAAdmin defaultDispatcher defaultName: 'siemensToolkit'
]

{ #category : #activation }
CPPSDeployServerCommandLineHandler >> unregisterUselessTools [

	"This method will unregistery all the useless tools."

	'Unregister useless tools.' record.
	self applicationsToUnregister do: [ :appName | WAAdmin defaultDispatcher unregister: (WAAdmin defaultDispatcher handlerAt: appName) ]
]
