"
Description
--------------------

I exist only to organize QueryBrowser package.
"
Class {
	#name : #CPPSQueryBrowserRightPanel,
	#superclass : #CPPSAbstractRightPanel,
	#traits : 'CPPSTQueryBrowserComponent',
	#classTraits : 'CPPSTQueryBrowserComponent classTrait',
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #testing }
CPPSQueryBrowserRightPanel class >> isAbstract [

	^ self = CPPSQueryBrowserRightPanel
]
