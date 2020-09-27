Class {
	#name : #CPPSCorrelationCell,
	#superclass : #CPPSComponent,
	#instVars : [
		'matches'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Correlation'
}

{ #category : #'instance creation' }
CPPSCorrelationCell class >> matches: aBoolean [

	^ self new
		  matches: aBoolean;
		  yourself
]

{ #category : #comparing }
CPPSCorrelationCell >> < aCell [

	^ self matches not
]

{ #category : #comparing }
CPPSCorrelationCell >> > aCell [

	^ aCell < self
]

{ #category : #accessing }
CPPSCorrelationCell >> matches [

	^ matches
]

{ #category : #accessing }
CPPSCorrelationCell >> matches: anObject [

	matches := anObject
]

{ #category : #rendering }
CPPSCorrelationCell >> renderContentOn: html [

	html mdlIcon
		class: (matches
				 ifTrue: [ 'matched' ]
				 ifFalse: [ 'unmatched' ]);
		with: (matches
				 ifTrue: [ #done ]
				 ifFalse: [ #clear ])
]
