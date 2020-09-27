"
Description
--------------------

I represent a user of the application. 

A user is able to save the project and the version on what he is working.

Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	login:			<aString>			I am the login of the user
	password:		<aString>			I am the password of the user. I should be crypted
	project:			<aMooseProject>		I am the current project on what work the user
	version:			<aMooseVersion>		I am the current version used by the user

"
Class {
	#name : #CPPSUserLoggable,
	#superclass : #Object,
	#traits : 'TLoggable + TUser',
	#classTraits : 'TLoggable classTrait + TUser classTrait',
	#instVars : [
		'project',
		'version',
		'login',
		'password',
		'currentModel',
		'groups',
		'rights'
	],
	#category : #'CPPS-Toolkit-Core-Core'
}

{ #category : #'as yet unclassified' }
CPPSUserLoggable class >> createUserWithLogin: login password: aUserPassword [

	^ self new
		  login: login;
		  password: aUserPassword;
		  yourself
]

{ #category : #translation }
CPPSUserLoggable class >> translatedKind [

	^ 'User' french: 'Utilisateur'
]

{ #category : #checking }
CPPSUserLoggable class >> userWithID: login password: aUserPassword [

	self flag: #todo. "Change this later"
	^ self
		  createUserWithLogin: login
		  password: aUserPassword
]

{ #category : #accessing }
CPPSUserLoggable >> currentModel [

	currentModel ifNil: [ self setDefaultVersion ].
	^ currentModel
]

{ #category : #private }
CPPSUserLoggable >> currentModel: anObject [

	"To avoid use of 2 differents models prefer set version with 'self version:'. This method set version and model"

	currentModel := anObject
]

{ #category : #accessing }
CPPSUserLoggable >> groups [

	^ groups
]

{ #category : #accessing }
CPPSUserLoggable >> groups: anObject [

	groups := anObject
]

{ #category : #testing }
CPPSUserLoggable >> hasVersionAvailable [

	^ [ self version isNotNil ]
		  on: NoGeneratedVersionException
		  do: [ false ]
]

{ #category : #initialization }
CPPSUserLoggable >> initialize [

	super initialize.
	self rights: OrderedCollection new.
	self groups: OrderedCollection new
]

{ #category : #testing }
CPPSUserLoggable >> isAllowedTo: aSymbol [

	^ (self groups anySatisfy: [ :aGroup | aGroup isAllowedTo: aSymbol ]) or: [ self rights includes: aSymbol ]
]

{ #category : #testing }
CPPSUserLoggable >> isPartOf: aHMGroup [

	^ self groups includes: aHMGroup
]

{ #category : #accessing }
CPPSUserLoggable >> loggableManager [

	^ self class
]

{ #category : #accessing }
CPPSUserLoggable >> login [

	^ login
]

{ #category : #accessing }
CPPSUserLoggable >> login: anObject [

	login := anObject
]

{ #category : #accessing }
CPPSUserLoggable >> model [

	^ self currentModel
]

{ #category : #accessing }
CPPSUserLoggable >> name [

	^ self login
]

{ #category : #accessing }
CPPSUserLoggable >> password [

	^ password
]

{ #category : #accessing }
CPPSUserLoggable >> password: aString [

	password := self hydePassword: aString
]

{ #category : #accessing }
CPPSUserLoggable >> project [

	^ project
]

{ #category : #accessing }
CPPSUserLoggable >> project: anObject [

	project := anObject
]

{ #category : #initialization }
CPPSUserLoggable >> resetVersion [

	version := nil
]

{ #category : #accessing }
CPPSUserLoggable >> rights [

	^ rights
]

{ #category : #accessing }
CPPSUserLoggable >> rights: anObject [

	rights := anObject
]

{ #category : #initialization }
CPPSUserLoggable >> setDefaultVersion [

	self version: CPPSServer current project latestGeneratedVersion
]

{ #category : #accessing }
CPPSUserLoggable >> version [

	self flag: #todo. "Latter save the current version of the user"
	version ifNil: [ self setDefaultVersion ].
	^ version
]

{ #category : #accessing }
CPPSUserLoggable >> version: anObject [

	version := anObject.
	self currentModel: version mooseModel
]
