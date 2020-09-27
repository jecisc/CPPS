"
Description
-------------------

I am an error raised when a metric is out of bounds.

When metrics are displayed the dashboard use the value to do some display. I am raised if the value is not good.

Internal Representation and Key Implementation Points.
-------------------

    Instance Variables
	metric:			<anInteger> 		The current value of the metric.
	metricName:		<aString>		The name of the metric.
"
Class {
	#name : #CPPSWrongMetricException,
	#superclass : #CPPSWebError,
	#instVars : [
		'metric',
		'metricName'
	],
	#category : #'CPPS-Toolkit-Dashboard-Exceptions'
}

{ #category : #'instance creation' }
CPPSWrongMetricException class >> metric: anInteger metricName: aString [

	^ self new
		  metric: anInteger;
		  metricName: aString;
		  signal
]

{ #category : #accessing }
CPPSWrongMetricException >> messageText [

	"Overwritten to initialiaze the message text to a standard text if it has not yet been set"

	^ messageText ifNil: [ messageText := self standardMessageText ]
]

{ #category : #accessing }
CPPSWrongMetricException >> metric [

	^ metric
]

{ #category : #accessing }
CPPSWrongMetricException >> metric: anObject [

	metric := anObject
]

{ #category : #accessing }
CPPSWrongMetricException >> metricName [

	^ metricName
]

{ #category : #accessing }
CPPSWrongMetricException >> metricName: anObject [

	metricName := anObject
]

{ #category : #printing }
CPPSWrongMetricException >> standardMessageText [

	"Generate a standard textual description"

	^ String streamContents:
		  [ :stream | 
		  stream
			  << self metric;
			  << ' is a wrong value for ';
			  << self metricName
		  ]
]
