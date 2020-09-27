"
Description
--------------------

I am a simple extension of the WAYesOnNoDialog in order to get a better looking component via MaterialDesignLite.
I will be call by the #confirm:onAnswer: method in a CPPSComponent.
"
Class {
	#name : #CPPSYesOrNoDialog,
	#superclass : #WAYesOrNoDialog,
	#category : #'CPPS-Toolkit-Core-Extension'
}

{ #category : #actions }
CPPSYesOrNoDialog >> addForm [

	self addDecoration: (CPPSFormDecoration buttons: self buttons)
]
