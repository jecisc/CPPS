"
Description
--------------------

I am responsible for generating a project version from a set of input properties.

I gather a set of properties that will drive the creation of a moose project version. Each property is described using magritte.

I  know how to trigger the version creation making use of these properties. See method #createVersionFor:.

I am an abstract class intended to be sublcassed for specific needs. The technology objects point to their respective concrete strategy object. See method #versionCreationStrategy in CPPTechnology



"
Class {
	#name : #CPPSVersionCreator,
	#superclass : #Object,
	#instVars : [
		'project',
		'headlessGenerator',
		'sourcesDateAndTime',
		'technology',
		'versionName',
		'sourcesPath',
		'shouldAllowSourcesCopy',
		'shouldAllowSourcesPathChange',
		'shouldCopySources',
		'sourcesInputFile'
	],
	#category : #'CPPS-Toolkit-Server-Technology'
}

{ #category : #accessing }
CPPSVersionCreator class >> label [

	^ 'Import from zip'
]

{ #category : #'instance creation' }
CPPSVersionCreator class >> project: aMooseProject technology: aTechnology [

	^ self new
		  project: aMooseProject;
		  technology: aTechnology;
		  yourself
]

{ #category : #api }
CPPSVersionCreator >> basicCreateVersionFor: aProject [

	self
		project: aProject;
		generateNewVersionFromFileNamed: self sourcesInputFile file basename
		contents: self sourcesInputFile contents
		dated: self sourcesDateAndTime
]

{ #category : #api }
CPPSVersionCreator >> createVersionFor: aProject [

	"create project version synchronously.
	If the generation is made in another image, we wait till the generation status has been updated"

	| failureAnnouncement |

	[ CPPSServer current announcer
		when: CPPSVersionCreationFailure
		do:
			[ :ann | 
			(self logPrefix , 'Received a generation failure notification') record.
			failureAnnouncement := ann
			].
	self basicCreateVersionFor: aProject. "wait till the generation is done"
	[ aProject generationInProgress ] whileTrue: [ (Delay forSeconds: 5) wait ]
	]
		on: Error
		do: [ :ex | self processCreationError: ex ].
	(self logPrefix , 'Generation done. About to check failure announcement (' , failureAnnouncement printString , ')') record.
	self handleAsynchronousGenerationFailure: failureAnnouncement.
	[ self postProcess: aProject ]
		on: Error
		do: [ :ex | self processCreationError: ex ].
	'Generation completed' record
]

{ #category : #'web image' }
CPPSVersionCreator >> generateNewVersionFromFile: aFileReference dated: aDateTime [

	[ self project saveMooseProjectObject ]
		on: NoPersistanceManagerException
		do: [  ].
	self isGeneratingVersionInOtherImage
		ifTrue:
			[ self
				generateVersionInNewImageFrom: aFileReference
				dated: aDateTime
			]
		ifFalse:
			[ "Feels hacky.
			at this step of the process,
			the #generationInProgress: flag has already been set by method #generateNewVersionFromFileNamed:contents:dated:
			Here, we unset this flag.
			The reason seems to be that we try to anticipate the fact that the flag will be set again by method #generateNewVersionFromFileNamed:contents:dated:
			A 'double flag initialization' would raise a generation error.
			
			The best solution would be to avoid to have a 'double flag initialization'
			"
			self project changeMyStateForGenerationDone.
			self
				generateVersionFrom: aFileReference
				dated: aDateTime
				named: self versionName.
			self server lastVersionModel: self project latestGeneratedVersion mooseModel
			]
]

{ #category : #'web image' }
CPPSVersionCreator >> generateNewVersionFromFileNamed: aFileName contents: aByteArray dated: aDateTime [

	| file |

	self project changeMyStateForGenerationInProgress.
	file := self tmpSourceFileFor: aFileName.
	file parent ensureCreateDirectory.
	file parent ensureDeleteAllChildren.
	file ensureCreateFile.
	file binaryWriteStreamDo: [ :stream | stream nextPutAll: aByteArray ].
	self
		generateNewVersionFromFile: file
		dated: aDateTime
]

{ #category : #'web image' }
CPPSVersionCreator >> generateVersionArgumentsFrom: aPathToFileToGenerate dated: aDateTime [

	| arguments |

	arguments := OrderedCollection new.
	self headlessGeneratorEnabled ifTrue: [ arguments add: self vmOptionHeadless ].
	arguments addAll: { 
			self server imageGeneratorPath asFileReference escapedPathForSystemCommand.
			'--no-default-preferences'.
			'generateVersion'.
			('--sourceFilePath=' , aPathToFileToGenerate escapedPathForSystemCommand).
			('--configurationPath=' , self generatorConfigurationFileReference pathString escapedPathForSystemCommand).
			('--technology=' , self server technology className) }.

	"we now make explicit the technology that should be used through a specific command line option."
	"next one is specific to ada gnat generator"
	arguments add: '--dateTime=' , aDateTime asUnixTime asString printString.
	self versionName ifNotNil: [ :name | arguments add: '--versionName=' , name ].
	^ arguments
]

{ #category : #'generator image' }
CPPSVersionCreator >> generateVersionFrom: aFile dated: aDateTime named: aString [

	| generationFolder |

	generationFolder := aFile parent / 'sources'.
	'Launch the specific action before generation.' record.
	self
		specificActionBeforeGenerationOn: aFile
		inGenerationFolder: generationFolder.
	'Launch generation.' record.
	self project
		generateVersionFromSource: (MooseDirectorySource
				 date: aDateTime
				 directory: generationFolder)
		named: aString.
	'Launch the specific action after generation.' record.
	self
		specificActionAfterGenerationOn: aFile
		inGenerationFolder: generationFolder.
	"Here i save the mooseProject to ensure the fuel will have the modifications introduced by #specificActionAfterGenerationOn:inGenerationFolder:for: but it will not save modification done in the mooseModel of the version"
	[ self project saveMooseProjectObject ]
		on: NoPersistanceManagerException
		do: [  ]
]

{ #category : #'web image' }
CPPSVersionCreator >> generateVersionInNewImageFrom: file dated: aDateAndTime [

	self flag: #todo. "Latter we should be able to set the VM we want in the configuration."
	SICommand default
		executeCommand: Smalltalk vm fullPath escapedPathForSystemCommand
		arguments: (self
				 generateVersionArgumentsFrom: file pathString
				 dated: aDateAndTime)
]

{ #category : #'web image' }
CPPSVersionCreator >> generatorConfigurationFileReference [

	^ self server configuration serializationFile
]

{ #category : #api }
CPPSVersionCreator >> handleAsynchronousGenerationFailure: aVersionCreationFailure [
	"it could be that the generation has been done within a generator image,
	and a failure callback has been catched (by handler GenerationRequestHandler).
	In such a case, we raise an error so that the UI gets notified of the failure"

	aVersionCreationFailure
		ifNotNil: [ CPPSVersionCreationError new
				stackDump: aVersionCreationFailure dumpStack;
				signal: 'Generator image failed to create version. Error: ' , aVersionCreationFailure description , '.' ]
]

{ #category : #accessing }
CPPSVersionCreator >> headlessGeneratorEnabled [

	"answers true if the image generator is to be run headless"

	^ headlessGenerator ifNil: [ headlessGenerator := false ]
]

{ #category : #accessing }
CPPSVersionCreator >> headlessGeneratorEnabled: aBoolean [

	headlessGenerator := aBoolean
]

{ #category : #'web image' }
CPPSVersionCreator >> initializeFromBrowserStrategy: aBrowserStrategy [

	"hook to apply sepecific subclasses properties initialization "

	self shouldAllowSourcesCopy: aBrowserStrategy allowToChangeVersionPath.
	self shouldAllowSourcesPathChange: aBrowserStrategy allowToChangeVersionPath
]

{ #category : #testing }
CPPSVersionCreator >> isGeneratingVersionInOtherImage [

	^ self server imageGeneratorPath isNotNil
]

{ #category : #accessing }
CPPSVersionCreator >> label [

	^ self class label
]

{ #category : #api }
CPPSVersionCreator >> logPrefix [

	^ '[Version creator] '
]

{ #category : #api }
CPPSVersionCreator >> postProcess: mooseProject [

	"hook to perform specific actions after generation has been done.
	called by the onWeb image.
	override for specific need"

	
]

{ #category : #api }
CPPSVersionCreator >> processCreationError: ex [

	| dump errorMessage |

	errorMessage := String streamContents:
		                [ :stream | 
		                stream
			                nextPutAll: 'There was an error while generating model: ';
			                nextPutAll: ex description
		                ].
	errorMessage record.
	dump := ex dumpStackFor: thisContext.
	^ CPPSVersionCreationError new
		  stackDump: dump;
		  signal: errorMessage
]

{ #category : #accessing }
CPPSVersionCreator >> project [

	^ project
]

{ #category : #accessing }
CPPSVersionCreator >> project: aProject [

	project := aProject
]

{ #category : #accessing }
CPPSVersionCreator >> server [

	^ CPPSServer current
]

{ #category : #accessing }
CPPSVersionCreator >> shouldAllowSourcesCopy [

	^ shouldAllowSourcesCopy ifNil: [ false ]
]

{ #category : #accessing }
CPPSVersionCreator >> shouldAllowSourcesCopy: aBoolean [

	shouldAllowSourcesCopy := aBoolean
]

{ #category : #accessing }
CPPSVersionCreator >> shouldAllowSourcesPathChange [

	^ shouldAllowSourcesPathChange ifNil: [ false ]
]

{ #category : #accessing }
CPPSVersionCreator >> shouldAllowSourcesPathChange: aBoolean [

	shouldAllowSourcesPathChange := aBoolean
]

{ #category : #accessing }
CPPSVersionCreator >> shouldCopySources [

	^ shouldCopySources
]

{ #category : #accessing }
CPPSVersionCreator >> shouldCopySources: aBoolean [

	shouldCopySources := aBoolean
]

{ #category : #accessing }
CPPSVersionCreator >> shouldCopySourcesDefault [

	^ self project
		  ifNil: [ false ]
		  ifNotNil: [ :tmpproject | tmpproject sourceHolder isNotNil and: [ tmpproject sourceHolder shouldPersistSources ] ]
]

{ #category : #accessing }
CPPSVersionCreator >> shouldCopySourcesDescription [

	<magritteDescription>
	^ MABooleanDescription new
		  accessor: (MAPluggableAccessor
				   read: [ :model | model shouldCopySources ]
				   write:
					   [ :model :value | 
					   value ifNotNil: [ self project ifNotNil: [ self project sourceHolder ifNotNil: [ self project sourceHolder shouldPersistSources: value ] ] ].
					   model shouldCopySources: value
					   ]);
		  label: 'Copy sources';
		  default: self shouldCopySourcesDefault;
		  hidden: self shouldAllowSourcesCopy not;
		  translatableComment: self shouldCopySourcesExplanation;
		  priority: 30;
		  yourself
]

{ #category : #accessing }
CPPSVersionCreator >> shouldCopySourcesExplanation [

	^ 'Copy sources on server' french: 'Copier les sources sur le serveur'
]

{ #category : #accessing }
CPPSVersionCreator >> sourcesDateAndTime [

	^ sourcesDateAndTime
]

{ #category : #accessing }
CPPSVersionCreator >> sourcesDateAndTime: aDateAndTime [

	sourcesDateAndTime := aDateAndTime
]

{ #category : #accessing }
CPPSVersionCreator >> sourcesDateAndTimeDescription [

	<magritteDescription>
	^ MADateAndTimeDescription new
		  accessor: #sourcesDateAndTime;
		  label: 'Sources date and time';
		  translatableComment: self sourcesDateAndTimeExplanation;
		  priority: 2;
		  displayCurrent;
		  yourself
]

{ #category : #accessing }
CPPSVersionCreator >> sourcesDateAndTimeExplanation [

	^ 'The selected date and time will be used to mark and identify the model generated for this version' french: 'La date et l''horaire sélectionnés seront utilisés pour marquer et identifier le modèle généré pour cette version'
]

{ #category : #accessing }
CPPSVersionCreator >> sourcesInputFile [

	^ sourcesInputFile
]

{ #category : #accessing }
CPPSVersionCreator >> sourcesInputFile: aFile [

	sourcesInputFile := aFile
]

{ #category : #accessing }
CPPSVersionCreator >> sourcesInputFileDescription [

	<magritteDescription>
	^ MAFileDescription new
		  label: 'Sources';
		  accessor: #sourcesInputFile;
		  translatableComment: self sourcesInputFileExplanation;
		  kind: MAExternalFileModel;
		  beRequired;
		  priority: 20;
		  yourself
]

{ #category : #accessing }
CPPSVersionCreator >> sourcesInputFileExplanation [

	self technology ifNil: [ ^ '' ].
	^ self technology uploadInstructions ifNil: [ self error: 'Specific instructions should be added for the technology: ' , self technology class technologyLabel ]
]

{ #category : #accessing }
CPPSVersionCreator >> sourcesPath [

	^ sourcesPath
]

{ #category : #accessing }
CPPSVersionCreator >> sourcesPath: aStringPath [

	sourcesPath := aStringPath
]

{ #category : #accessing }
CPPSVersionCreator >> sourcesPathDescription [

	<magritteDescription>
	^ MAStringDescription new
		  accessor: (MAPluggableAccessor
				   read: [ :model | model sourcesPath ]
				   write:
					   [ :model :value | 
					   value ifNotNil: [ self project ifNotNil: [ :aMooseProject | aMooseProject sourceHolder: (MooseSourceHolderDirectory on: value) ] ].
					   model sourcesPath: value
					   ]);
		  label: 'Sources path';
		  translatableComment: self sourcesPathExplanation;
		  hidden: self shouldAllowSourcesPathChange not;
		  addCondition: [ :value | value asFileReference exists ]
		  labelled: 'Should be an existing path on the system';
		  priority: 10;
		  addCondition: [ :value | value isNotEmpty ]
		  labelled: 'Path should not be empty';
		  yourself
]

{ #category : #accessing }
CPPSVersionCreator >> sourcesPathExplanation [

	^ 'In order to generate your version you first need to give the absolute or relative path of the sources on the server.' french: 'Pour générer votre version il vous faut tout d''abord donner un chemin absolu ou relatif des sources sur le serveur. '
]

{ #category : #'generation hooks' }
CPPSVersionCreator >> specificActionAfterGenerationOn: aFile inGenerationFolder: aDirectory [

	"by default delegate to the technology.
	override for specific behavior"

	^ self technology
		  specificActionAfterGenerationOn: aFile
		  inGenerationFolder: aDirectory
		  for: self project
]

{ #category : #'generation hooks' }
CPPSVersionCreator >> specificActionBeforeGenerationOn: aFile inGenerationFolder: aDirectory [

	"by default delegate to the technology.
	override for specific behavior"

	^ self technology
		  specificActionBeforeGenerationOn: aFile
		  inGenerationFolder: aDirectory
		  for: self project
]

{ #category : #accessing }
CPPSVersionCreator >> technology [

	^ technology
]

{ #category : #accessing }
CPPSVersionCreator >> technology: aTechnology [

	technology := aTechnology
]

{ #category : #'web image' }
CPPSVersionCreator >> tmpSourceFileFor: aFileName [

	^ FileSystem workingDirectory / 'tmpSourceHolder' / aFileName
]

{ #category : #accessing }
CPPSVersionCreator >> versionName [

	^ versionName
]

{ #category : #accessing }
CPPSVersionCreator >> versionName: aString [

	versionName := aString
]

{ #category : #accessing }
CPPSVersionCreator >> versionNameDescription [

	<magritteDescription>
	^ MAStringDescription new
		  accessor: #versionName;
		  label: 'Name';
		  translatableComment: self versionNameExplanation;
		  priority: 1;
		  yourself
]

{ #category : #accessing }
CPPSVersionCreator >> versionNameExplanation [

	^ 'A name to identify the version to be created. If no name is supplied, only the date will serve as identifier' french: 'Un nom pour identifier la version qui sera créée. Si aucun nom n''est fourni, seule la date servira d''identifiant'
]

{ #category : #'web image' }
CPPSVersionCreator >> vmOptionHeadless [

	OSPlatform current isMacOS ifTrue: [ ^ '--headless ' ].
	OSPlatform current isUnix ifTrue: [ ^ '-vm-sound-null -vm-display-null ' ].
	"by default, does not run headless"
	^ ''
]
