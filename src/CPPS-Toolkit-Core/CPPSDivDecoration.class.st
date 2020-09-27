"
Description
--------------------

I am a simple Seaside decorator that embedded a component into a div with a class.

Example
------------------

	WAComponent new
		addDecorator: (CPPSDivDecorator htmlClass: 'myClass');
		yourself

Internal Representation and Key Implementation Points.
----------------

    Instance Variables
	htmlClass:		<aStringOrSymbol>		I am the class that need to be added to the classes.

"
Class {
	#name : #CPPSDivDecoration,
	#superclass : #WADecoration,
	#instVars : [
		'htmlClass'
	],
	#category : #'CPPS-Toolkit-Core-Decorator'
}

{ #category : #'instance creation' }
CPPSDivDecoration class >> htmlClass: aString [

	^ self new
		  htmlClass: aString;
		  yourself
]

{ #category : #accessing }
CPPSDivDecoration >> htmlClass [

	^ htmlClass
]

{ #category : #accessing }
CPPSDivDecoration >> htmlClass: anObject [

	htmlClass := anObject
]

{ #category : #rendering }
CPPSDivDecoration >> renderContentOn: html [

	html div
		class: self htmlClass;
		with: [ self renderNextOn: html ]
]
