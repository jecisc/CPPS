"
Description
--------------------

I am an abstract component to render something on the right panel of the code Analyzer.
"
Class {
	#name : #CPPSAbstractRightPanel,
	#superclass : #CPPSComponent,
	#instVars : [
		'owner'
	],
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #'instance creation' }
CPPSAbstractRightPanel class >> owner: aCodeAnalyzer [

	^ self new
		  owner: aCodeAnalyzer;
		  yourself
]

{ #category : #testing }
CPPSAbstractRightPanel class >> shouldBeExtended [

	"I am a hook. Some panels need to be extended, as in the Query Browser. If this is needed override me in the subclasses."

	^ false
]

{ #category : #accessing }
CPPSAbstractRightPanel >> owner [

	^ owner
]

{ #category : #accessing }
CPPSAbstractRightPanel >> owner: anObject [

	owner := anObject
]

{ #category : #rendering }
CPPSAbstractRightPanel >> renderContentOn: html [

	self subclassResponsibility
]

{ #category : #accessing }
CPPSAbstractRightPanel >> selectedEntity [

	^ self owner selectedEntity
]

{ #category : #selection }
CPPSAbstractRightPanel >> selectedEntity: anEntity [

	self owner selectedEntity: anEntity
]

{ #category : #testing }
CPPSAbstractRightPanel >> shouldBeExtended [

	^ self class shouldBeExtended
]
