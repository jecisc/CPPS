"
Description
--------------------

I am an abstract class to factorise tag browser components behavior

Public API and Key Messages
--------------------

- #tag 		Return the currently selected tag
"
Class {
	#name : #CPPSTagBrowserComponent,
	#superclass : #CPPSAbstractPanelComponent,
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #selection }
CPPSTagBrowserComponent >> selectedTag: aTag [

	"I am a method to override if you want to act when the selected tag change"

	
]

{ #category : #accessing }
CPPSTagBrowserComponent >> tag [

	^ self owner selectedTag
]
