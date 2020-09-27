Class {
	#name : #CPPTechnology,
	#superclass : #Object,
	#instVars : [
		'imageGeneratorPath'
	],
	#category : #'CPPS-Toolkit-Server-Technology'
}

{ #category : #accessing }
CPPTechnology class >> technologyLabel [

	^ 'C++'
]

{ #category : #accessing }
CPPTechnology class >> technologyName [

	"A name to define a specific technology. For example CPP for C++"

	^ self printString copyUpToSubString: 'Technology'
]

{ #category : #accessing }
CPPTechnology >> imageGeneratorPath [
	^ imageGeneratorPath
]

{ #category : #accessing }
CPPTechnology >> imageGeneratorPath: anObject [
	imageGeneratorPath := anObject
]

{ #category : #'TO-CHANGE' }
CPPTechnology >> modelGenerator [

	"We collect the potential launchers for a technology and we select the one with the higher priority in the image. 
	
	This can be usefull for example in the case of Ada. There is an Ada launcher and a Thales launcher. In an ada image, the ada launcher will be selected. In  a Thales image, the thales launcher will be selected because it has a higher priority."

	^ ((PragmaCollector filter: [ :prg | prg selector = #launcherFor:priority: and: [ (prg argumentNamed: #launcherFor) asLowercase = self technologyName asLowercase ] ]) reset collected sorted: [ :a | (a argumentNamed: #priority) asInteger ] descending)
		  ifEmpty: [ self error: 'No model found for this technology.' ]
		  ifNotEmpty: [ :coll | coll anyOne methodClass ]
]

{ #category : #'TO-CHANGE' }
CPPTechnology >> specificActionAfterGenerationOn: anUploadedFile inGenerationFolder: aTempFolder for: aProject [
	self flag: #todo. "Should be in the parsers later."
	aProject isPersistanceRequiredForSources ifFalse: [ aProject latestGeneratedVersion mooseSource directory: aProject sourceHolder importDirectory fullName ].
	aProject latestGeneratedVersion mooseModel rootFolder: aProject sourceHolder importDirectory fullName.

	aProject isPersistanceRequiredForSources ifTrue: [ ^ self ].
	aProject latestGeneratedVersion mooseModel replicationManager.

	"We build the caches"
	aProject latestGeneratedVersion mooseModel postLoadAction
]

{ #category : #'TO-CHANGE' }
CPPTechnology >> specificActionBeforeGenerationOn: anUploadedFile inGenerationFolder: aTempFolder for: aProject [

	self flag: #todo. "Should be in the parsers later."
	aTempFolder
		ensureCreateDirectory;
		deleteAllChildren.
	('Copy ' , anUploadedFile basename , ' to ' , aTempFolder pathString) record.
	aTempFolder / anUploadedFile basename writeStreamDo:
		[ :stream | 
		self
			writeContentOfRef: anUploadedFile
			to: stream
		].
	aProject isPersistanceRequiredForSources ifTrue:
		[ aProject sourceHolder importDirectory children do:
			[ :eachChildFileReference | 
			aTempFolder / eachChildFileReference basename ifAbsent:
				[ "we may be about to copy an inner ref file (present in the import directory), 
				that exists in the destination folder (has been explicitely created by the previous statement).
				We want to be flexible and hanle this case.
				We will copy everything except this inner ref file" 
				SICommand default copyAll: eachChildFileReference to: aTempFolder / eachChildFileReference basename ]
			]
		]
]

{ #category : #accessing }
CPPTechnology >> technologyLabel [

	^ self class technologyLabel
]

{ #category : #accessing }
CPPTechnology >> technologyName [

	^ self class technologyName
]

{ #category : #'TO-CHANGE' }
CPPTechnology >> writeContentOfRef: anUploadedFile to: stream [

	| contents |

	self flag: #todo. "There is currently a bug in the Pharo VM with file upload changing the first 4 bytes of the file sometimes. Since Siemens use a pattern in its CVS we can try to correct this problem while the bug is not corrected in the stable VM. The file should begin by `#Files`, so if we have a line with `xxxxes` it might be a right file with the wrong first 4 bytes."
	contents := anUploadedFile contents.
	(contents first: 6) = '#Files' ifFalse:
		[ (contents
			 copyFrom: 9
			 to: 18) = 'ileId,path' ifTrue:
			[ stream
				nextPutAll: '#Files';
				lf;
				nextPutAll: 'fileId,path';
				nextPutAll: (contents allButFirst: 18).
			^ stream
			]
		].
	stream << contents
]
