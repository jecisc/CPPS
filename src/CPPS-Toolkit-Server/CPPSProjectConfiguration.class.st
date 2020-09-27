Class {
	#name : #CPPSProjectConfiguration,
	#superclass : #Object,
	#instVars : [
		'technologies',
		'serializationFile',
		'serverPort',
		'visualizationsPort',
		'currentTechnology',
		'maxUploadSizeInMo',
		'runtimeParameters',
		'serverHostname',
		'serverProtocol',
		'serverPath',
		'projectDirectory'
	],
	#category : #'CPPS-Toolkit-Server-Configuration'
}

{ #category : #ston }
CPPSProjectConfiguration class >> readFromStonFile: aFileReference [

	^ (STON fromString: aFileReference contents)
		  serializationFile: aFileReference;
		  yourself
]

{ #category : #ston }
CPPSProjectConfiguration class >> readFromStonString: aString [

	^ STON fromString: aString
]

{ #category : #ston }
CPPSProjectConfiguration class >> readStonFrom: aFileReferenceOrString [

	^ aFileReferenceOrString isString
		  ifTrue: [ self readFromStonString: aFileReferenceOrString ]
		  ifFalse: [ self readFromStonFile: aFileReferenceOrString ]
]

{ #category : #ston }
CPPSProjectConfiguration class >> stonAllInstVarNames [

	^ super stonAllInstVarNames \ #( #serializationFile )
]

{ #category : #ston }
CPPSProjectConfiguration class >> stonName [
	^ #ProjectConfiguration
]

{ #category : #testing }
CPPSProjectConfiguration >> allowsMultipleTechnologies [

	^ self technologies size > 1
]

{ #category : #action }
CPPSProjectConfiguration >> createMooseProject [
	^ (MooseProject persistanceDirectory: self persistantDirectory)
		  mooseModelGenerator: self modelGenerator;
		  yourself
]

{ #category : #action }
CPPSProjectConfiguration >> createMooseProjectWithoutPersistance [

	^ MooseProject new
		  mooseModelGenerator: self modelGenerator;
		  yourself
]

{ #category : #accessing }
CPPSProjectConfiguration >> currentTechnology [

	^ currentTechnology
]

{ #category : #accessing }
CPPSProjectConfiguration >> currentTechnology: aProjectTechnology [

	currentTechnology := aProjectTechnology
]

{ #category : #action }
CPPSProjectConfiguration >> ensureMaximumEntitySize [

	"The following need to be cleaned up when Zinc will be stabilized."

	[ ZnConstants maximumEntitySize: self maxUploadSizeInMo * 1024 * 1024 ]
		on: MessageNotUnderstood
		do: [ ZnZincServerAdaptor default ifNotNil: [ :adaptor | adaptor server maximumEntitySize: self maxUploadSizeInMo * 1024 * 1024 ] ]
]

{ #category : #generation }
CPPSProjectConfiguration >> generateVersionFrom: aFile in: aProject dated: aDateTime [

	'Launch the specific action before generation.' record.
	self obtainsTechnology
		specificActionBeforeGenerationOn: aFile
		inGenerationFolder: aFile parent / 'sources'
		for: aProject.
	'Launch generation.' record.
	aProject generateVersionFromSource: (MooseDirectorySource
			 date: aDateTime
			 directory: aFile parent / 'sources').
	'Launch the specific action after generation.' record.
	self obtainsTechnology
		specificActionAfterGenerationOn: aFile
		inGenerationFolder: aFile parent / 'sources'
		for: aProject. "Here i save the mooseProject to ensure the fuel will have the modifications introduced by #specificActionAfterGenerationOn:inGenerationFolder:for: but it will not save modification done in the mooseModel of the version"
	[ aProject saveMooseProjectObject ]
		on: NoPersistanceManagerException
		do: [  ]
]

{ #category : #accessing }
CPPSProjectConfiguration >> hasProjectDirectory [

	^ self projectDirectory isEmptyOrNil not
]

{ #category : #export }
CPPSProjectConfiguration >> initializeDefaultValues [

	"I initialize the default values of the configuration in order to export them after."

	(PragmaCollector new filter: [ :prg | prg selector = #configurationParameter ]) reset collected do: [ :pragma | self perform: pragma method selector ]
]

{ #category : #testing }
CPPSProjectConfiguration >> isPersitanceActivated [

	^ self persistantDirectory isNotNil
]

{ #category : #'accessing - parameters' }
CPPSProjectConfiguration >> maxUploadSizeInMo [

	"The max upload size tolerated by the tool in upload in Mo. By default: 80Mo."

	<configurationParameter>
	^ maxUploadSizeInMo ifNil: [ maxUploadSizeInMo := 80 ]
]

{ #category : #accessing }
CPPSProjectConfiguration >> maxUploadSizeInMo: anObject [

	maxUploadSizeInMo := anObject
]

{ #category : #accessing }
CPPSProjectConfiguration >> modelGenerator [

	self flag: #todo. "Latter this will evolve in order to get more than one generator if we have more than one technology."
	^ self currentTechnology
		  ifNil: [ technologies first modelGenerator ]
		  ifNotNil: #modelGenerator
]

{ #category : #accessing }
CPPSProjectConfiguration >> obtainsProject [
	self hasProjectDirectory ifFalse: [ ^ self createMooseProjectWithoutPersistance ].
	^ [ MooseProject loadFromDirectory: self persistantDirectory ]
		  on: FileException
		  do: [ self createMooseProject ]
]

{ #category : #accessing }
CPPSProjectConfiguration >> obtainsTechnology [

	^ self allowsMultipleTechnologies
		  ifTrue: [ self currentTechnology ]
		  ifFalse:
			  [ self
				  assert: technologies size = 1
				  description: 'We do not manage the multi technologies for now. Latter we could return a composite technology.'.
			  self technologies first
			  ]
]

{ #category : #accessing }
CPPSProjectConfiguration >> persistantDirectory [

	self projectDirectory isEmptyOrNil ifTrue: [ ^ nil ].
	^ (self serializationFile
		   ifNil: [ FileSystem workingDirectory ]
		   ifNotNil: [ self serializationFile parent ]) resolve: self projectDirectory
]

{ #category : #'accessing - parameters' }
CPPSProjectConfiguration >> projectDirectory [

	"Path to a folder where the sources should be (or are) persisted. If no folder is defined, there will be no persistency and everything will happen in memory."

	<configurationParameter>
	^ projectDirectory ifNil: [ projectDirectory := '' ]
]

{ #category : #accessing }
CPPSProjectConfiguration >> projectDirectory: aStringPath [

	projectDirectory := aStringPath
]

{ #category : #accessing }
CPPSProjectConfiguration >> projectStrategy [

	^ self modelGenerator modelClass browserStrategy
]

{ #category : #'accessing - parameters' }
CPPSProjectConfiguration >> runtimeParameters [

	"Hook so that any package can provide its own 'runtime parameter', without having to modify core configuration implementation. Answers a dictionary associating parameter names to their values."

	<configurationParameter>
	^ runtimeParameters ifNil: [ runtimeParameters := Dictionary new ]
]

{ #category : #accessing }
CPPSProjectConfiguration >> serializationFile [

	^ serializationFile
]

{ #category : #accessing }
CPPSProjectConfiguration >> serializationFile: anObject [

	serializationFile := anObject
]

{ #category : #'accessing - parameters' }
CPPSProjectConfiguration >> serverHostname [

	"Server hostname used for URL generation. This does not implement HTTPs but ease the use of apache. By default: none, delegating to the web framework"

	<configurationParameter>
	^ serverHostname ifNil: [ serverHostname := '' ]
]

{ #category : #accessing }
CPPSProjectConfiguration >> serverHostname: anObject [

	serverHostname := anObject
]

{ #category : #'accessing - parameters' }
CPPSProjectConfiguration >> serverPath [

	"Server path used for URL generation. This does not implement HTTPs but ease the use of apache. By default: none, delegating to the web framework"

	<configurationParameter>
	^ serverPath ifNil: [ serverPath := '' ]
]

{ #category : #accessing }
CPPSProjectConfiguration >> serverPath: anObject [

	serverPath := anObject
]

{ #category : #'accessing - parameters' }
CPPSProjectConfiguration >> serverPort [

	"Port on which the server should deserve the application. By default: 8080."

	<configurationParameter>
	^ serverPort ifNil: [ serverPort := 8080 ]
]

{ #category : #accessing }
CPPSProjectConfiguration >> serverPort: anObject [

	serverPort := anObject asInteger
]

{ #category : #'accessing - parameters' }
CPPSProjectConfiguration >> serverProtocol [

	"Server protocol used for URL generation. This does not implement HTTPs but ease the use of apache. By default: none, delegating to the web framework"

	<configurationParameter>
	^ serverProtocol ifNil: [ serverProtocol := '' ]
]

{ #category : #accessing }
CPPSProjectConfiguration >> serverProtocol: anObject [

	serverPort := anObject
]

{ #category : #accessing }
CPPSProjectConfiguration >> sourceDirectoryFrom: aProjectDirectoryFileReference [

	"The 'Sources' directory where source files are extracted seems to be derived, implicitely, from the location of projectDirectory.
	See method #generateVersionFrom:in:dated: 
	Trying to make it more explicit here.
	Should we refactor and use this new method whenever we want to know the location of the 'Sources' folder ?"

	^ aProjectDirectoryFileReference parent / 'sources'
]

{ #category : #'accessing - parameters' }
CPPSProjectConfiguration >> technologies [

	"A collection of supported technologies and their configurations."

	<configurationParameter>
	^ technologies ifNil: [ technologies := #(  ) ]
]

{ #category : #accessing }
CPPSProjectConfiguration >> technologies: aCollection [

	technologies := aCollection
]

{ #category : #'accessing - parameters' }
CPPSProjectConfiguration >> visualizationsPort [

	"Port used to update the visualizations of siemens toolkit when interacting with them. By default: 1701."

	<configurationParameter>
	^ visualizationsPort ifNil: [ visualizationsPort := 1701 ]
]

{ #category : #accessing }
CPPSProjectConfiguration >> visualizationsPort: anObject [

	visualizationsPort := anObject asInteger
]
