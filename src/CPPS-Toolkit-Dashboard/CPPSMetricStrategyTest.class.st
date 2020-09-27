"
Description
--------------------

This class contains tests
"
Class {
	#name : #CPPSMetricStrategyTest,
	#superclass : #TestCase,
	#instVars : [
		'strategy'
	],
	#category : #'CPPS-Toolkit-Dashboard-Tests'
}

{ #category : #running }
CPPSMetricStrategyTest >> setUp [

	super setUp.
	strategy := CPPSDashboardMetricStrategy
		            classByIntervals: (Dictionary
				             with: (0 to: 33) -> #danger
				             with: (33 to: 66) -> #warning
				             with: (66 to: 100) -> #healthy)
		            named: 'Duplication'
		            helpText: 'The duplication is the repetition of code among different entites in the application.'
		            displayBlock: [ :elem | elem asString , '%' ]
]

{ #category : #tests }
CPPSMetricStrategyTest >> testClassForValue [

	self
		assert: (strategy classForValue: 15)
		equals: #danger.
	self
		assert: (strategy classForValue: 45)
		equals: #warning.
	self
		assert: (strategy classForValue: 95)
		equals: #healthy
]

{ #category : #tests }
CPPSMetricStrategyTest >> testPrintMetric [

	self
		assert: (strategy printMetric: 5)
		equals: '5%'
]
