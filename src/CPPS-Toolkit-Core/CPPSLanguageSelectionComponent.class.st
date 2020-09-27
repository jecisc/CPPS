"
Description
--------------------

I am only here in order to personnalise the style of the Heimdall language widget to use MDL.
"
Class {
	#name : #CPPSLanguageSelectionComponent,
	#superclass : #HeimdallLanguageSelectionComponent,
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #rendering }
CPPSLanguageSelectionComponent >> renderContentOn: html [

	html mdlNavigationLink
		style: 'padding-right: 5px';
		callback: [ self session language: #french ];
		with: [ self renderFrenchFlagOn: html ].
	html mdlNavigationLink
		style: 'padding-left: 5px';
		callback: [ self session language: #english ];
		with: [ self renderEnglishFlagOn: html ]
]
