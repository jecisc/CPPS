"
Description
--------------------

I am a component that allow the user to select a new version of the current project.

I should be part of the Project Manager to help the user to change his current version of the project.

Example
---------------------

	html render: (CPPSVerisonChooserComponent new)
 
Internal Representation and Key Implementation Points.
---------------------

    Instance Variables
	selectedVersion:		<aProjectVersion> 	I stock a version selected in the drop box by the user. This version is used when he click on the validate button.
"
Class {
	#name : #CPPSVersionChooserComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'selectedVersion'
	],
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #rendering }
CPPSVersionChooserComponent >> renderContentOn: html [

	html div
		class: 'smallComponent';
		with:
			[ html heading
				level: 2;
				with: (self translate: ('Choose your version' french: 'Choisissez votre version')).
			html div
				paddedForm;
				with:
					[ html div
						class: 'form-wrap';
						with:
							[ self
								renderVersionChooserOn: html;
								renderSubmitOn: html
							]
					]
			]
]

{ #category : #rendering }
CPPSVersionChooserComponent >> renderSubmitOn: html [

	html mdlMajorAnchorButton
		callback:
			[ self selectedVersion ifNotNil: [ self currentUser version: self selectedVersion ].
			self rootComponent resetInstances
			];
		with: (self
				 english: 'Validate'
				 french: 'Valider')
]

{ #category : #rendering }
CPPSVersionChooserComponent >> renderVersionChooserOn: html [

	html
		render: (MDLMenuButtonWidget new
				 choosingText: (self
						  english: 'Select your version'
						  french: 'Sélectionnez votre version');
				 textBlock: #separateDateAndTime;
				 selectedObject: (self selectedVersion ifNil: [ self currentUser version ]);
				 action: [ :version | self selectedVersion: version ];
				 objectsPossibilities: (self server project versions sort: [ :vers1 :vers2 | vers1 date < vers2 date ]);
				 yourself);
		break
]

{ #category : #accessing }
CPPSVersionChooserComponent >> selectedVersion [

	^ selectedVersion
]

{ #category : #accessing }
CPPSVersionChooserComponent >> selectedVersion: anObject [

	selectedVersion := anObject
]
