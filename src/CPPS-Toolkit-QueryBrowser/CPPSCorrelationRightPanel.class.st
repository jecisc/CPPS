"
Description
--------------------

I exist only to organize correlation browser classes
"
Class {
	#name : #CPPSCorrelationRightPanel,
	#superclass : #CPPSAbstractRightPanel,
	#category : #'CPPS-Toolkit-QueryBrowser-Correlation'
}

{ #category : #testing }
CPPSCorrelationRightPanel class >> isAbstract [

	^ self = CPPSQueryBrowserRightPanel
]

{ #category : #accessing }
CPPSCorrelationRightPanel >> selectedCorrelation [

	^ self owner selectedCorrelation
]
