"
Description
---------------------

I am a simple component to display a help icon.

I hold a text and I will render an information icon with the text as tooltip. 
The icon will by default have an absolute position and will be in the top-right corner. You can adapt this position with the #helpIcon class in your css.

Example
--------------------

	html render: CPPSHelpComponent message: 'I am a help for the user!'
 
Internal Representation and Key Implementation Points.
-------------------

    Instance Variables
	message:		<aString> 	The message to display in the tooltip.

"
Class {
	#name : #CPPSHelpComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'message'
	],
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #'instance creation' }
CPPSHelpComponent class >> message: aString [

	^ self new
		  message: aString;
		  yourself
]

{ #category : #accessing }
CPPSHelpComponent >> message [

	^ message
]

{ #category : #accessing }
CPPSHelpComponent >> message: anObject [

	message := anObject
]

{ #category : #rendering }
CPPSHelpComponent >> renderContentOn: html [

	| id |

	html mdlButton
		id: (id := html nextId);
		class: #helpIcon;
		labelIcon;
		with: [ html mdlIcon: #info_outline ].
	html
		mdlLargeTooltipFor: id
		with: [ html html: self message ]
]
