"
Description
--------------------

I am a command line whose goal is to take an incomplete ProjectConfiguration in ston and to create a full configuration with the default parameters to ease the configuration management for the clients.

I also generate a documentation of the parameters.

Arguments
--------------------

- #configuration 		A string whose content is the ston configuration. (Not compatible with the #configurationPath argument)
- #configurationPath 	A string containing the relative path to the configuration file to complete. By default 'siemensToolkit.conf'. (Not compatible with the #configuration argument)
- #outputPath			The name of the file to create to export the configuration.

Examples
--------------------

	Pharo.app/Contents/MacOS/Pharo CPP-OnWeb.image --no-default-preferences completeConfiguration --configurationPath=""../siemensToolkit.conf"" --outputPath=""../newSiemensToolkit.conf""
			
			
					
	Pharo.app/Contents/MacOS/Pharo CPP-OnWeb.image --no-default-preferences completeConfiguration --configuration=""ProjectConfiguration {
	#projectDirectory : '../ProjectCPP'
	#technologies : [
		CPPTechnology {
			#imageGeneratorPath : 'CPP-Generator/CPP-Generator.image'
		}
	]
}"" --outputPath=""newSiemensToolkit.conf""
 
"
Class {
	#name : #CPPSCompleteConfigurationCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'CPPS-Toolkit-Server-Commands'
}

{ #category : #accessing }
CPPSCompleteConfigurationCommandLineHandler class >> commandName [

	^ 'completeConfiguration'
]

{ #category : #accessing }
CPPSCompleteConfigurationCommandLineHandler class >> defaultConfigurationFileName [

	^ 'siemensToolkit.conf'
]

{ #category : #accessing }
CPPSCompleteConfigurationCommandLineHandler class >> description [

	^ 'I take as parameter an incomplete configuration and I generate a configuration with all parameters completed with the default values.'
]

{ #category : #activation }
CPPSCompleteConfigurationCommandLineHandler >> activate [

	self
		optionAt: 'configuration'
		ifPresent: [ :conf | self activateWithConfigurationContent: conf ]
		ifAbsent: [ self activateWithFile: self inputFile ].
	self generateHelpForConfiguration.
	Smalltalk
		snapshot: false
		andQuit: true
]

{ #category : #activation }
CPPSCompleteConfigurationCommandLineHandler >> activateWithConfigurationContent: aString [

	| configuration |

	configuration := CPPSProjectConfiguration readFromStonString: aString.
	configuration initializeDefaultValues.
	self outputFile
		ensureDelete;
		ensureCreateFile;
		writeStreamDo:
			[ :s | 
			STON
				put: configuration
				onStreamPretty: s
			]
]

{ #category : #activation }
CPPSCompleteConfigurationCommandLineHandler >> activateWithFile: aFile [

	aFile
		ifExists: [ self activateWithConfigurationContent: aFile contents ]
		ifAbsent: [ self error: aFile pathString , ' does not exist.' ]
]

{ #category : #accessing }
CPPSCompleteConfigurationCommandLineHandler >> defaultConfigurationFileName [

	^ self class defaultConfigurationFileName
]

{ #category : #activation }
CPPSCompleteConfigurationCommandLineHandler >> generateHelpForConfiguration [

	'configurationHelp.txt' asFileReference
		ensureDelete;
		ensureCreateFile;
		writeStreamDo:
			[ :s | 
			s
				nextPutAll: 'This file includes the description of the parameters of the configuration file.';
				lf;
				lf.
			self generateHelpForConfigurationParametersOn: s
			]
]

{ #category : #activation }
CPPSCompleteConfigurationCommandLineHandler >> generateHelpForConfigurationParametersOn: aStream [

	(PragmaCollector new filter: [ :prg | prg selector = #configurationParameter ]) reset collected do:
		[ :pragma | 
		aStream
			<< '- ';
			<< pragma method selector;
			<< ' : ';
			<< (pragma method comment trimBoth: [ :char | char = $" ]);
			lf
		]
]

{ #category : #accessing }
CPPSCompleteConfigurationCommandLineHandler >> inputFile [

	^ (self
		   optionAt: 'configurationPath'
		   ifAbsent: [ self defaultConfigurationFileName ]) asFileReference
]

{ #category : #accessing }
CPPSCompleteConfigurationCommandLineHandler >> outputFile [

	^ (self
		   optionAt: 'outputPath'
		   ifAbsent: [ self defaultConfigurationFileName ]) asFileReference
]
