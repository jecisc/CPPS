"
Description
-------------------

I am an abstract class for all the components that should be in a tabPanel.

My subclasses should be referenced by a CPPSPanelStrategy. Thus a CPPSTabPanelComponent will be able to render me. 

I keep a reference to my owner to be able to get some informations.

Public API and Key Messages
------------------

- #model 	Conveniance method to get the current model

Internal Representation and Key Implementation Points.
-----------------

    Instance Variables
	owner:		<aComponent>		The browser that own  me
"
Class {
	#name : #CPPSAbstractPanelComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'owner'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-PanelComponent'
}

{ #category : #testing }
CPPSAbstractPanelComponent class >> isAbstract [

	^ self = CPPSAbstractPanelComponent
]

{ #category : #'instance creation' }
CPPSAbstractPanelComponent class >> owner: aComponent [

	^ self new
		  owner: aComponent;
		  yourself
]

{ #category : #accessing }
CPPSAbstractPanelComponent >> owner [

	^ owner
]

{ #category : #accessing }
CPPSAbstractPanelComponent >> owner: anObject [

	owner := anObject
]

{ #category : #hook }
CPPSAbstractPanelComponent >> renderComponentOn: html [

	html div
		class: #form;
		with: [ html form: [ self renderFormOn: html ] ]
]

{ #category : #hook }
CPPSAbstractPanelComponent >> renderContentOn: html [

	html div
		class: #panel;
		with:
			[ html headerContainer: [ html headline: self title ].
			self renderComponentOn: html
			]
]

{ #category : #hook }
CPPSAbstractPanelComponent >> renderFormOn: html [

	self subclassResponsibility
]

{ #category : #accessing }
CPPSAbstractPanelComponent >> title [

	"I should return a string that will be the name of the component"

	^ self subclassResponsibility
]
