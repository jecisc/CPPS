Class {
	#name : #CPPSValidatorVisitor,
	#superclass : #MAValidatorVisitor,
	#instVars : [
		'memento'
	],
	#category : #'CPPS-Toolkit-Magritte'
}

{ #category : #private }
CPPSValidatorVisitor >> validate: anObject using: aDescription [

	aDescription validateEarlyConditions: anObject.
	super
		validate: anObject
		using: aDescription
]
