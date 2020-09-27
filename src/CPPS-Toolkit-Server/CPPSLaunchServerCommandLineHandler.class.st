"
Description
--------------------

This command will launch the application and initialize the server. It can takes as parameter a configuration file name. By default if no file name is given it will look for `inventiveToolkit.conf`. 

This command line will also make sure that the seaside server is launched. 

Example
---------------------

./pharo JavaOnWeb.image serverDeployment --configuration=”alternativeConfguration.conf”

"
Class {
	#name : #CPPSLaunchServerCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'CPPS-Toolkit-Server-Commands'
}

{ #category : #accessing }
CPPSLaunchServerCommandLineHandler class >> commandName [

	^ 'serverDeployment'
]

{ #category : #accessing }
CPPSLaunchServerCommandLineHandler class >> defaultConfigurationFileName [

	^ 'siemensToolkit.conf'
]

{ #category : #accessing }
CPPSLaunchServerCommandLineHandler class >> description [

	^ 'I deploy a headless server and load or create the project describe by the configuration file.'
]

{ #category : #testing }
CPPSLaunchServerCommandLineHandler class >> requireDeploymentPassword [

	^ false
]

{ #category : #activation }
CPPSLaunchServerCommandLineHandler >> activate [

	(self class printString , ' launched.') record.
	(FileSystem workingDirectory resolve: self configurationFileName)
		ifExists:
			[ :configurationFile | 
			('Configuration file found at ' , configurationFile printString) record.
			"if a server is already launched, the command will not create a new one even if the configuration changed"
			self ensureServerLaunched: configurationFile.
			self ensureSeasideServerLaunched
			]
		ifAbsent: [ self exitForConfigurationFileNotFound ]
]

{ #category : #accessing }
CPPSLaunchServerCommandLineHandler >> configurationFileName [

	^ self
		  optionAt: 'configuration'
		  ifAbsent: [ self class defaultConfigurationFileName ]
]

{ #category : #accessing }
CPPSLaunchServerCommandLineHandler >> currentConfiguration [

	^ self server configuration
]

{ #category : #accessing }
CPPSLaunchServerCommandLineHandler >> currentProject [

	^ self server project
]

{ #category : #activation }
CPPSLaunchServerCommandLineHandler >> ensureSeasideServerLaunched [

	('Launch Inventive Toolkit on port ' , self currentConfiguration serverPort asString) record.
	ZnZincServerAdaptor startOn: self currentConfiguration serverPort.
	WAAdmin defaultDispatcher handlers do:
		[ :handler | 
		handler
			preferenceAt: #serverPort
			put: self currentConfiguration serverPort
		].
	self currentConfiguration serverHostname ifNotEmpty:
		[ :name | 
		('Set server hostname to ' , name) record.
		WAAdmin defaultDispatcher handlers do:
			[ :handler | 
			handler
				preferenceAt: #serverHostname
				put: name
			]
		].
	self currentConfiguration serverProtocol ifNotEmpty:
		[ :name | 
		('Set server protocol to ' , name) record.
		WAAdmin defaultDispatcher handlers do:
			[ :handler | 
			handler
				preferenceAt: #serverProtocol
				put: name
			]
		].
	self currentConfiguration serverPath ifNotEmpty:
		[ :name | 
		('Set server path to ' , name) record.
		WAAdmin defaultDispatcher handlers do:
			[ :handler | 
			handler
				preferenceAt: #serverPath
				put: name
			]
		].
	('Set default websocket port to ' , self currentConfiguration visualizationsPort asString) record.
	TLCytoscapeWebSocketDelegate
		serverPort: self currentConfiguration visualizationsPort;
		clientPort: self currentConfiguration visualizationsPort;
		stop.
	self currentConfiguration ensureMaximumEntitySize
]

{ #category : #activation }
CPPSLaunchServerCommandLineHandler >> ensureServerLaunched: configurationFile [

	self flag: #DANGER. "if a server is already launched, the command will not create a new one even if the configuration changed"
	CPPSServer isAlreadyLaunched
		ifFalse:
			[ self
				execute: [ CPPSServer launchFrom: (CPPSProjectConfiguration readStonFrom: configurationFile) ]
				recordedAs: 'launch new server'
			]
		ifTrue:
			[ self server configuration: (CPPSProjectConfiguration readStonFrom: configurationFile).

			"It could be that the image has been moved,
			and that the model root folder path no longer resolve correctly (seems to be a Pharo 4 specific behavior with relative path. Seems to be fixed with Pharo 6).
			If it's the case, we do a small trick to try finding back the root folder"
			self resolveProjectBrokenPaths.
			self inform: 'Server restored from the previous one; the configuration file is ignored'
			]
]

{ #category : #activation }
CPPSLaunchServerCommandLineHandler >> error: aString [

	self stderr
		<< aString;
		lf.
	self exitFailure
]

{ #category : #activation }
CPPSLaunchServerCommandLineHandler >> exitForConfigurationFileNotFound [

	('ERROR: ' , self configurationFileName , ' does not exist.') record.
	self exitFailure: self configurationFileName , ' does not exist.'
]

{ #category : #activation }
CPPSLaunchServerCommandLineHandler >> makeProjectPathRelative [
	"The generated project is intended to work correctly wherever the execution folders are moved (Techno-onWebFull, ProjectTechno , Sources).
	We should make sure that all project path are set relatively"

	| sourcesDirectory version versionSourceDirectory |
	version := self currentProject latestGeneratedVersion.
	versionSourceDirectory := version mooseSource directory.
	sourcesDirectory := versionSourceDirectory relativeTo: self currentConfiguration projectDirectory asFileReference parent.
	version mooseSource directory: sourcesDirectory asFileReference.
	self server project mooseModel rootFolder: sourcesDirectory
]

{ #category : #activation }
CPPSLaunchServerCommandLineHandler >> resolveProjectBrokenPaths [

	"The generated project is intended to work correctly wherever the execution folders are moved (Techno-onWebFull, ProjectTechno , Sources).
	Here we check that the defined sources path for each project version exists.
	If not, we try our best to resolve them relatively to the execution folder"

	| projectDirectory |

	projectDirectory := self currentConfiguration projectDirectory asFileReference.

	"Iterate over all existing project versions to fix broken paths"
	self currentProject versions do:
		[ :eachProjectVersion | 
		self
			resolveProjectVersionSourcesWith: projectDirectory
			for: eachProjectVersion
		].

	"Persistance manager may also need some adjustment. Can be nil if the user does not persist the sources."
	self currentProject persistanceManager ifNotNil:
		[ :manager | 
		manager rootDirectory ifAbsent: [ :persistanceManagerDirectory | "this directory usually points to the project directory. If it is teh case, we can do something" persistanceManagerDirectory path segments last = projectDirectory basename ifTrue: [ manager rootDirectory: projectDirectory ] ] ]
]

{ #category : #activation }
CPPSLaunchServerCommandLineHandler >> resolveProjectVersionSourcesWith: projectDirectory for: eachProjectVersion [

	^ eachProjectVersion mooseSource directory asFileReference ifAbsent:
		  [ :versionSourceDirectory | 
		  | versionSourceSegments versionSourceRelativeSegments projectDirectoryIndex |

		  "Case of a version sources path not existing. We check if the specified path if relative to the project folder"
		  versionSourceSegments := versionSourceDirectory path segments.
		  projectDirectoryIndex := versionSourceSegments indexOf: projectDirectory basename.
		  projectDirectoryIndex = 0 ifFalse:
			  [ "The specified path seems to be relative to the project folder. We can try to resolve"
			  versionSourceRelativeSegments := versionSourceSegments
				                                   copyFrom: projectDirectoryIndex + 1
				                                   to: versionSourceSegments size.
			  (versionSourceRelativeSegments
				   inject: projectDirectory
				   into: [ :resolvedSourceDirectory :eachPathSegment | resolvedSourceDirectory / eachPathSegment ]) ifExists:
				  [ :resolvedSourceDirectory | "Looks like we succeeded to resolve the path"
				  eachProjectVersion mooseSource directory: resolvedSourceDirectory.
				  eachProjectVersion mooseModel rootFolder: resolvedSourceDirectory
				  ]
			  ]
		  ]
]

{ #category : #accessing }
CPPSLaunchServerCommandLineHandler >> server [

	^ CPPSServer current
]
