Class {
	#name : #CPPSNewCorrelationRightPanel,
	#superclass : #CPPSCorrelationEditorRightPanel,
	#instVars : [
		'correlation'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Correlation'
}

{ #category : #accessing }
CPPSNewCorrelationRightPanel >> correlation [

	^ correlation
]

{ #category : #initialization }
CPPSNewCorrelationRightPanel >> initialize [

	correlation := FQCorrelation new.
	super initialize
]

{ #category : #rendering }
CPPSNewCorrelationRightPanel >> renderButtonsOn: html [

	html mdlMajorButton
		callback:
			[ self correlationsStorage add: self correlation.
			self initialize
			];
		with: (self
				 english: 'Create'
				 french: 'Créer')
]
