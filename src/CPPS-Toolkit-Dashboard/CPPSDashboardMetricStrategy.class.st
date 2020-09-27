"
Description
----------------------

I am a Metric strategy. I help to render a metric in a Dashboard.

I am use to help a CPPSDashboardMetricComponent during the rendering of the component.

Public API and Key Messages
----------------------

- class>>#classByIntervals: aDictionaryOfClassesByIntervals name: aText helpText: aHelp displayBlock: aBlock 		I am a constructor for the strategy

- #classForValue: aMetric 		I return a symbole that should be the html's class of the component for a value.
		
- #printMetric: aMetric 		I return the metric pretty printed. 

Example
----------------------

	CPPSDashboardMetricStrategy
		classByIntervals:
			(Dictionary with: (0 to: 33) -> #danger with: (33 to: 66) -> #warning with: (66 to: 100) -> #healthy)
		named: 'Duplication'
		helpText: 'The duplication is the repetition of code among different entites in the application.'
		displayBlock: [ :elem | elem asString , '%' ]
 
Internal Representation and Key Implementation Points.
----------------------

    Instance Variables
	classByIntervals:		<aDictionaryOfIntervals> I am a collection of intervals that should map an interval for the metrics wath a Symbole that is an html's class.
	displayBlock:			<aBlock> 				I am a block that take a Metric as parameter and return a string. This string is the pretty printing of the Metric.
	helpText:				<aString> 				An help text for the metric.
	metricName:			<aString> 				The name of the metric
"
Class {
	#name : #CPPSDashboardMetricStrategy,
	#superclass : #Object,
	#instVars : [
		'classByIntervals',
		'helpText',
		'displayBlock',
		'metricName'
	],
	#category : #'CPPS-Toolkit-Dashboard'
}

{ #category : #helpers }
CPPSDashboardMetricStrategy class >> classAscendingFrom: anInt1 to: anInt2 to: anInt3 to: anInt4 [

	^ Dictionary
		  with: (anInt1 to: anInt2) -> #healthy
		  with: (anInt2 to: anInt3) -> #warning
		  with: (anInt3 to: anInt4) -> #danger
]

{ #category : #helpers }
CPPSDashboardMetricStrategy class >> classAscendingRateFor: anInteger and: anotherInteger [

	^ self
		  classAscendingFrom: 0
		  to: anInteger
		  to: anotherInteger
		  to: 1
]

{ #category : #'instance creation' }
CPPSDashboardMetricStrategy class >> classByIntervals: aDictionaryOfClassesByIntervals named: aText helpText: aHelp displayBlock: aBlock [

	^ self new
		  classByIntervals: aDictionaryOfClassesByIntervals;
		  metricName: aText;
		  helpText: aHelp;
		  displayBlock: aBlock;
		  yourself
]

{ #category : #helpers }
CPPSDashboardMetricStrategy class >> classDescendingFrom: anInt1 to: anInt2 to: anInt3 to: anInt4 [

	^ Dictionary
		  with: (anInt1 to: anInt2) -> #danger
		  with: (anInt2 to: anInt3) -> #warning
		  with: (anInt3 to: anInt4) -> #healthy
]

{ #category : #helpers }
CPPSDashboardMetricStrategy class >> classDescendingRateFor: anInteger and: anotherInteger [

	^ self
		  classDescendingFrom: 0
		  to: anInteger
		  to: anotherInteger
		  to: 1
]

{ #category : #helpers }
CPPSDashboardMetricStrategy class >> displayAsPercentBlock [

	^ [ :float | (float asFloat * 100 round: 1) asString , '%' ]
]

{ #category : #comparing }
CPPSDashboardMetricStrategy >> = anObject [

	^ self == anObject or: [ self metricName = anObject metricName ]
]

{ #category : #accessing }
CPPSDashboardMetricStrategy >> classByIntervals [

	^ classByIntervals
]

{ #category : #accessing }
CPPSDashboardMetricStrategy >> classByIntervals: anObject [

	classByIntervals := anObject
]

{ #category : #accessing }
CPPSDashboardMetricStrategy >> classForValue: aMetric [

	aMetric = MooseUnavailableMetric ifTrue: [ ^ #unavailable ].
	^ [ (self classByIntervals associations detect: [ :asso | asso key rangeIncludes: aMetric ]) value ]
		  on: NotFound
		  do:
			  [ CPPSWrongMetricException
				  metric: aMetric
				  metricName: self metricName englishText
			  ]
]

{ #category : #accessing }
CPPSDashboardMetricStrategy >> displayBlock [

	^ displayBlock
]

{ #category : #accessing }
CPPSDashboardMetricStrategy >> displayBlock: anObject [

	displayBlock := anObject
]

{ #category : #accessing }
CPPSDashboardMetricStrategy >> helpText [

	^ helpText
]

{ #category : #accessing }
CPPSDashboardMetricStrategy >> helpText: anObject [

	helpText := anObject
]

{ #category : #initialization }
CPPSDashboardMetricStrategy >> initialize [

	super initialize.
	classByIntervals := Dictionary new
]

{ #category : #accessing }
CPPSDashboardMetricStrategy >> metricName [

	^ metricName
]

{ #category : #accessing }
CPPSDashboardMetricStrategy >> metricName: anObject [

	metricName := anObject
]

{ #category : #printing }
CPPSDashboardMetricStrategy >> printMetric: aMetric [

	aMetric = MooseUnavailableMetric ifTrue: [ ^ 'Unavailable' ].
	^ self displayBlock value: aMetric
]
