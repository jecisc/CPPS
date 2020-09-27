Class {
	#name : #CPPSComponentTest,
	#superclass : #TestCase,
	#category : #'CPPS-Toolkit-Core-Tests'
}

{ #category : #tests }
CPPSComponentTest >> testObtainBrowserFor [

	self
		shouldnt: [ CPPSComponent new obtainBrowserFor: { CPPSEntity new } ]
		raise: Error
]
