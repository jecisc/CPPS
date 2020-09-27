Class {
	#name : #CPPSAddTagComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'ajaxOnClick'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #'as yet unclassified' }
CPPSAddTagComponent class >> withAction: action [

	^ self new
		  ajaxOnClick: action;
		  yourself
]

{ #category : #accessing }
CPPSAddTagComponent >> ajaxOnClick [

	^ ajaxOnClick
]

{ #category : #accessing }
CPPSAddTagComponent >> ajaxOnClick: aScript [

	ajaxOnClick := aScript
]

{ #category : #rendering }
CPPSAddTagComponent >> renderContentOn: html [

	html mdlButton
		labelIcon;
		onClick: (self ajaxOnClick value: html);
		class: #add;
		class: #addBtn;
		with: [ html mdlIcon: #fiber_new ]
]
