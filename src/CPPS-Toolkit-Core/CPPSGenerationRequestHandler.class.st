"
Description
---------------------

I am a requestHandler used to execute task related to the generation of a new version.

There might be some task related to the generation where we might need to communicate with this image. I am here to help with this communication. 
For example if we generate a version outside this image we need to know when and in what state the generation ended.

Public API and Key Messages
---------------------

I should not be use by the image. I should be use via a request outside the image. See Seaside book chapter about request handler for more info.
"
Class {
	#name : #CPPSGenerationRequestHandler,
	#superclass : #WARequestHandler,
	#category : #'CPPS-Toolkit-Core-Core'
}

{ #category : #initialization }
CPPSGenerationRequestHandler class >> initialize [

	"
	
	self initialize
	
	"

	WAAdmin
		register: self
		at: 'projectGeneration'
]

{ #category : #action }
CPPSGenerationRequestHandler >> failure: aRequestContext [

	| description dump |

	description := aRequestContext request fields at: CPPSCreateVersionCommandLineHandler httpField_failureDescription.
	dump := aRequestContext request fields at: CPPSCreateVersionCommandLineHandler httpField_stackDump.
	"when failure is triggered, we do not modify the current project.
	we consider that the user has to create another version from scratch."
	'Received a failure notification from generator' record.
	self server announcer announce: (CPPSVersionCreationFailure new
			 description: description;
			 stackDump: dump;
			 yourself).
	self server project changeMyStateForGenerationDone
]

{ #category : #handling }
CPPSGenerationRequestHandler >> handleFiltered: aRequestContext [

	<siemensToolkitApplication>
	| generationEndField |

	generationEndField := aRequestContext request fields
		                      at: CPPSCreateVersionCommandLineHandler httpField_signalGenerationEnd
		                      ifAbsent: [ nil ].
	generationEndField ifNotNil:
		[ ^ self
			  handleGenerationEnd: aRequestContext
			  field: generationEndField
		]
]

{ #category : #handling }
CPPSGenerationRequestHandler >> handleGenerationEnd: requestContext field: generationEndField [

	self
		perform: generationEndField asSymbol asMutator
		withArguments: (Array with: requestContext)
]

{ #category : #accessing }
CPPSGenerationRequestHandler >> server [

	^ CPPSServer current
]

{ #category : #action }
CPPSGenerationRequestHandler >> success [

	self server project mergeWith: self server configuration obtainsProject.
	self server lastVersionModel: self server project latestGeneratedVersion mooseModel.
	self server project
		changeMyStateForGenerationDone;
		saveMooseProjectObject
]

{ #category : #action }
CPPSGenerationRequestHandler >> success: aRequestContext [

	'Received a success notification from generator' record.
	self success
]
