Class {
	#name : #CPPSServer,
	#superclass : #Object,
	#instVars : [
		'project',
		'lastVersionModel',
		'configuration',
		'groups',
		'announcer',
		'strategyCache'
	],
	#classVars : [
		'IsPersistanceInProgress',
		'UniqueInstance'
	],
	#category : #'CPPS-Toolkit-Server-Core'
}

{ #category : #accessing }
CPPSServer class >> current [

	^ UniqueInstance ifNil: [ self error: 'You first need to generate an instance with a MooseProject. I should be created at launch by the command line.' ]
]

{ #category : #testing }
CPPSServer class >> isAlreadyLaunched [

	^ UniqueInstance isNotNil
]

{ #category : #accessing }
CPPSServer class >> isPersistanceInProgress [

	^ IsPersistanceInProgress ifNil: [ IsPersistanceInProgress := false ]
]

{ #category : #accessing }
CPPSServer class >> isPersistanceInProgress: anObject [

	IsPersistanceInProgress := anObject
]

{ #category : #'instance creation' }
CPPSServer class >> launchFrom: aConfiguration [

	UniqueInstance := self basicNew
		                  project: aConfiguration obtainsProject;
		                  configuration: aConfiguration;
		                  yourself.
	"The next action may need to access CPPSServer instance and its project.
	It should be executed after CPPSServer instance has been initialized"
	UniqueInstance linkLastVersionModel
]

{ #category : #utilities }
CPPSServer class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #'Reset current project')
		parent: #SiemensToolkit;
		action: [ self resetCurrentProject ];
		icon: (self iconNamed: #smallHelpIcon)
]

{ #category : #'instance creation' }
CPPSServer class >> new [

	^ self error: 'I am a Singleton. Use current to get my instance or reset my instance with a new project.'
]

{ #category : #'instance creation' }
CPPSServer class >> reset [

	<script>
	UniqueInstance := nil
]

{ #category : #utilities }
CPPSServer class >> resetCurrentProject [

	self current project ifNotNil:
		[ :aMooseProject | 
		aMooseProject persistanceManager ifNotNil: [ :manager | manager rootDirectory ifNotNil: #ensureDeleteAll ].
		aMooseProject generationInProgress: false
		].
	self launchFrom: (CPPSProjectConfiguration readStonFrom: self current configuration serializationFile). "make sure all users forget about the current project"
	CPPSUserManager singleton users do: #resetVersion
]

{ #category : #accessing }
CPPSServer >> allGroups [

	^ groups ifNil:
		  [ self flag: #TODO.
		  groups := { 
			            (HMGroup named: 'Users').
			            (HMGroup named: 'Super-Users').
			            (HMGroup named: 'Admins') }
		  ]
]

{ #category : #testing }
CPPSServer >> allowsMultipleTechnologies [

	^ self configuration allowsMultipleTechnologies
]

{ #category : #accessing }
CPPSServer >> announcer [

	"CPPSServer seems to be a central class within the web image. 
A singleton instance is generated at startup and is then accessed by multiples processes,
in order to share configuration and current project properties.

This announcer can be used to notify and suscribe to any update concerning the current project "

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
CPPSServer >> configuration [

	^ configuration
]

{ #category : #accessing }
CPPSServer >> configuration: anObject [

	configuration := anObject.
	configuration ensureMaximumEntitySize
]

{ #category : #accessing }
CPPSServer >> currentStrategy [

	^ strategyCache ifNil:
		  [ strategyCache := [ self configuration projectStrategy ]
			                   on: MessageNotUnderstood , Error
			                   do:
				                   [ self flag: #clean. "The catch is here because in development we do not have a model generator all the time."
				                   self lastVersionModel class browserStrategy
				                   ]
		  ]
]

{ #category : #accessing }
CPPSServer >> currentTechnology [

	^ self configuration currentTechnology
]

{ #category : #accessing }
CPPSServer >> currentTechnology: aProjectTechnology [

	self configuration currentTechnology: aProjectTechnology
]

{ #category : #accessing }
CPPSServer >> imageGeneratorPath [

	^ self technology imageGeneratorPath
]

{ #category : #testing }
CPPSServer >> isFirstVersionInGeneration [

	^ self project generationInProgress and: [ self project noGeneratedVersions ]
]

{ #category : #accessing }
CPPSServer >> lastVersionModel [

	"We keep a link to the model to avoid to be garbage collected each time a session time out."

	lastVersionModel ifNil: [ self linkLastVersionModel ].
	^ lastVersionModel
]

{ #category : #accessing }
CPPSServer >> lastVersionModel: anObject [

	lastVersionModel := anObject
]

{ #category : #accessing }
CPPSServer >> linkLastVersionModel [

	self project ifNotNil:
		[ [ self lastVersionModel: self project latestGeneratedVersion mooseModel ]
			on: NoGeneratedVersionException
			do: [  ]
		]
]

{ #category : #accessing }
CPPSServer >> project [

	^ project
]

{ #category : #accessing }
CPPSServer >> project: aProject [

	project := aProject
]

{ #category : #rights }
CPPSServer >> rightsList [

	^ { #adminAccess } , (CPPSAbstractBrowser allConcreteSubclasses collect: #browserAccess)
]

{ #category : #accessing }
CPPSServer >> technology [

	^ self configuration obtainsTechnology
]
