"
Description
--------------------

I am a class that will allow to configure all the browsers of an application. 

I should have a subclass in all the projects that have a web representation.

Since we aim to have a modular application I should not contains code. Instead I wall have a lot of extension present in other packages. Thus I will not depend on other projects.
"
Class {
	#name : #CPPSBrowserStrategy,
	#superclass : #Object,
	#classVars : [
		'MetricCharts',
		'MetricStrategies'
	],
	#category : #'CPPS-Toolkit-Core-Core'
}

{ #category : #testing }
CPPSBrowserStrategy class >> allowToChangeVersionPath [

	"This is a hook used by the component to save model modifications."

	^ false
]

{ #category : #testing }
CPPSBrowserStrategy class >> allowToCreateQueryInPharo [

	^ false
]

{ #category : #accessing }
CPPSBrowserStrategy class >> commonFilters: anObject [

	self subclassResponsibility
]

{ #category : #accessing }
CPPSBrowserStrategy class >> dashboardMetrics [

	^ #( #numberOfLinesOfCode #duplicationRate #deadCodeRate #documentationRate #complexityRate #commentedCodeRate #technicalDebt )
]

{ #category : #'tree-explorer' }
CPPSBrowserStrategy class >> entitiesForTreeExplorerFrom: aTHALESModel [

	^ self subclassResponsibility
]

{ #category : #testing }
CPPSBrowserStrategy class >> isAbstract [

	^ self = CPPSBrowserStrategy
]

{ #category : #accessing }
CPPSBrowserStrategy class >> languageClass [

	"I should return the class name corresponding of the highlighting in prism"

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSBrowserStrategy class >> metricCharts: anObject [

	MetricCharts := anObject
]

{ #category : #accessing }
CPPSBrowserStrategy class >> metricStrategies [

	^ MetricStrategies ifNil:
		  [ MetricStrategies := ((PragmaCollector new filter: [ :prg | prg selector = #metricStrategy:priority: ]) reset collected sorted: [ :p1 :p2 | (p1 argumentAt: 2) < (p2 argumentAt: 2) ])
			                      inject: OrderedDictionary new
			                      into:
				                      [ :dic :pragma | 
				                      dic
					                      at: (pragma argumentAt: 1)
					                      put: (pragma methodClass soleInstance perform: pragma method selector).
				                      dic
				                      ]
		  ]
]

{ #category : #accessing }
CPPSBrowserStrategy class >> metricStrategies: anObject [

	MetricStrategies := anObject
]

{ #category : #accessing }
CPPSBrowserStrategy class >> reset [

	<script>
	self metricCharts: nil.
	self commonFilters: nil.
	self metricStrategies: nil
]

{ #category : #visualizations }
CPPSBrowserStrategy class >> systemMapEntitiesFrom: aModel [

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSBrowserStrategy class >> urlOfLogo [

	^ CPPSLibrary urlOf: self languageClass , 'Png'
]
