Class {
	#name : #CPPSCodeAnalyzerEntityUpdated,
	#superclass : #Announcement,
	#instVars : [
		'newEntity'
	],
	#category : #'CPPS-Toolkit-CodeAnalyzer-Announcements'
}

{ #category : #'instance creation' }
CPPSCodeAnalyzerEntityUpdated class >> newEntity: aFamixEntity [

	^ self new
		  newEntity: aFamixEntity;
		  yourself
]

{ #category : #accessing }
CPPSCodeAnalyzerEntityUpdated >> newEntity [

	^ newEntity
]

{ #category : #accessing }
CPPSCodeAnalyzerEntityUpdated >> newEntity: anObject [

	newEntity := anObject
]
