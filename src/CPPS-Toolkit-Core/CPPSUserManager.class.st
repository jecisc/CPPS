"
Description
--------------------

I represent the users manager of your application
"
Class {
	#name : #CPPSUserManager,
	#superclass : #Object,
	#instVars : [
		'users'
	],
	#classInstVars : [
		'singleton'
	],
	#category : #'CPPS-Toolkit-Core-Core'
}

{ #category : #singleton }
CPPSUserManager class >> singleton [

	^ singleton ifNil: [ singleton := self new ]
]

{ #category : #checking }
CPPSUserManager class >> userWithID: login password: password [

	^ self singleton
		  userWithID: login
		  password: password
]

{ #category : #demo }
CPPSUserManager >> demoSetOfUsers [

	^ { (#Siemens -> 'I%n8r!i2A') } collect:
		  [ :asso | 
		  CPPSUserLoggable
			  createUserWithLogin: asso key
			  password: asso value
		  ]
]

{ #category : #users }
CPPSUserManager >> findUserNamed: login [

	^ self users
		  detect: [ :anUser | anUser login = login ]
		  ifNone: [ HMNoUserWithThisNameException signalWithName: login ]
]

{ #category : #checking }
CPPSUserManager >> userWithID: login password: password [

	| user |

	user := self findUserNamed: login.
	(user verifyPassword: password) ifFalse: [ HMWrongPasswordException signal ].
	^ user
]

{ #category : #accessing }
CPPSUserManager >> users [

	^ users ifNil: [ users := self demoSetOfUsers ]
]

{ #category : #accessing }
CPPSUserManager >> users: anObject [

	users := anObject
]
