"
Description
--------------------

I am a simple extension of the WAFormDecoration in order to get a better looking component via MaterialDesignLite.
"
Class {
	#name : #CPPSFormDecoration,
	#superclass : #WAFormDecoration,
	#category : #'CPPS-Toolkit-Core-Extension'
}

{ #category : #'instance creation' }
CPPSFormDecoration class >> buttons: aCollection [

	^ self new
		  buttons: aCollection;
		  yourself
]

{ #category : #rendering }
CPPSFormDecoration >> renderButtonForSelector: aSymbol on: html [

	html submitButton
		class: 'mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect';
		class: 'submit';
		callback: [ self decoratedComponent perform: aSymbol ];
		value: aSymbol
]
