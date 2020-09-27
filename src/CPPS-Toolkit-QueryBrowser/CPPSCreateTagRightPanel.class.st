Class {
	#name : #CPPSCreateTagRightPanel,
	#superclass : #CPPSAbstractRightPanel,
	#instVars : [
		'component'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #accessing }
CPPSCreateTagRightPanel >> component [

	^ component
]

{ #category : #accessing }
CPPSCreateTagRightPanel >> component: anObject [

	component := anObject
]

{ #category : #component }
CPPSCreateTagRightPanel >> defaultComponent [

	^ CPPSTagCreatorComponent new owner: self
]

{ #category : #initialization }
CPPSCreateTagRightPanel >> initialize [

	super initialize.
	self component: self defaultComponent
]

{ #category : #accessing }
CPPSCreateTagRightPanel >> parentTag [

	^ self owner parentTag
]

{ #category : #accessing }
CPPSCreateTagRightPanel >> parentTag: aTag [

	^ self owner parentTag: aTag
]

{ #category : #rendering }
CPPSCreateTagRightPanel >> renderContentOn: html [

	html render: self component
]
