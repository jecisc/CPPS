Class {
	#name : #CPPSSession,
	#superclass : #HeimdallSession,
	#instVars : [
		'currentTag',
		'refreshOnTagging'
	],
	#category : #'CPPS-Toolkit-Core-Core'
}

{ #category : #accessing }
CPPSSession >> currentTag [

	^ currentTag
]

{ #category : #accessing }
CPPSSession >> currentTag: aTag [

	currentTag := aTag
]

{ #category : #initialization }
CPPSSession >> initialize [

	super initialize.
	refreshOnTagging := true
]

{ #category : #accessing }
CPPSSession >> refreshOnTagging [

	^ refreshOnTagging
]

{ #category : #accessing }
CPPSSession >> refreshOnTagging: anObject [

	refreshOnTagging := anObject
]
