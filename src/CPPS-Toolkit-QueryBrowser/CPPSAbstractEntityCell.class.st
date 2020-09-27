Class {
	#name : #CPPSAbstractEntityCell,
	#superclass : #CPPSComponent,
	#instVars : [
		'entity'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #'instance creation' }
CPPSAbstractEntityCell class >> entity: anEntity [

	^ self new
		  entity: anEntity;
		  yourself
]

{ #category : #comparing }
CPPSAbstractEntityCell >> < aCell [

	^ self subclassResponsibility
]

{ #category : #comparing }
CPPSAbstractEntityCell >> > aCell [

	^ aCell < self
]

{ #category : #accessing }
CPPSAbstractEntityCell >> entity [

	^ entity
]

{ #category : #accessing }
CPPSAbstractEntityCell >> entity: anObject [

	entity := anObject
]

{ #category : #rendering }
CPPSAbstractEntityCell >> renderContentOn: html [

	self subclassResponsibility
]
