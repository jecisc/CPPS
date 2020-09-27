Class {
	#name : #CPPSCorrelationCountCell,
	#superclass : #CPPSComponent,
	#instVars : [
		'count',
		'color'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Correlation'
}

{ #category : #'instance creation' }
CPPSCorrelationCountCell class >> count: anInteger [

	^ self new
		  count: anInteger;
		  yourself
]

{ #category : #comparing }
CPPSCorrelationCountCell >> < aCell [

	^ count < aCell count
]

{ #category : #comparing }
CPPSCorrelationCountCell >> > aCell [

	^ aCell < self
]

{ #category : #accessing }
CPPSCorrelationCountCell >> color [

	^ color
]

{ #category : #accessing }
CPPSCorrelationCountCell >> color: anObject [

	color := anObject
]

{ #category : #accessing }
CPPSCorrelationCountCell >> count [

	^ count
]

{ #category : #accessing }
CPPSCorrelationCountCell >> count: anObject [

	count := anObject
]

{ #category : #rendering }
CPPSCorrelationCountCell >> renderContentOn: html [

	html div
		style: 'width: 100%; text-align: right; color: #' , self color asHexString;
		with: self count asString
]
