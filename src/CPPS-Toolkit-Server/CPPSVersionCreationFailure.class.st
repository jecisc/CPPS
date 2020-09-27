"
Description
--------------------

This announcement is sent when the web image gets notified by the generator image of a generation failure.
It knows about a  failure description and a stack dump file.


"
Class {
	#name : #CPPSVersionCreationFailure,
	#superclass : #Announcement,
	#instVars : [
		'description',
		'stackDump'
	],
	#category : #'CPPS-Toolkit-Server-Core'
}

{ #category : #accessing }
CPPSVersionCreationFailure >> description [

	^ description
]

{ #category : #accessing }
CPPSVersionCreationFailure >> description: aString [

	description := aString
]

{ #category : #accessing }
CPPSVersionCreationFailure >> stackDump [

	^ stackDump
]

{ #category : #accessing }
CPPSVersionCreationFailure >> stackDump: afileReference [

	stackDump := afileReference
]
