"
Description
--------------------

Specific error triggered when the creation of a moose project version fails. I am instanciated by CPPSVersionCreationError object.
"
Class {
	#name : #CPPSVersionCreationError,
	#superclass : #Error,
	#instVars : [
		'stackDump'
	],
	#category : #'CPPS-Toolkit-Server-Technology'
}

{ #category : #accessing }
CPPSVersionCreationError >> stackDump [

	^ stackDump
]

{ #category : #accessing }
CPPSVersionCreationError >> stackDump: aStackDumpFileReference [

	stackDump := aStackDumpFileReference
]
