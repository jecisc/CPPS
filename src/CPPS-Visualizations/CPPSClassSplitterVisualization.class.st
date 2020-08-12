Class {
	#name : #CPPSClassSplitterVisualization,
	#superclass : #CPPSVisualization,
	#instVars : [
		'tagActionBlock',
		'model'
	],
	#category : #'CPPS-Visualizations-Visualizations-ClassSplitter'
}

{ #category : #accessing }
CPPSClassSplitterVisualization class >> entity: anEntity subEntities: aCollection [

	self subclassResponsibility
]

{ #category : #testing }
CPPSClassSplitterVisualization class >> isAbstract [

	^ self = CPPSClassSplitterVisualization
]

{ #category : #testing }
CPPSClassSplitterVisualization class >> supportMultipleEntities [

	^ false
]

{ #category : #building }
CPPSClassSplitterVisualization >> backgroundColorStrategy [

	^ FamixTagColorStrategy default fallbackStrategy: (FamixSimpleColorStrategy color: Color white)
]

{ #category : #accessing }
CPPSClassSplitterVisualization >> model [

	^ model
]

{ #category : #accessing }
CPPSClassSplitterVisualization >> model: anObject [

	model := anObject
]

{ #category : #refreshing }
CPPSClassSplitterVisualization >> refreshOnTagUpdates [

	"I am called by the browser containing me when a tag was updated."

	self subclassResponsibility
]

{ #category : #accessing }
CPPSClassSplitterVisualization >> tagActionBlock [

	^ tagActionBlock
]

{ #category : #accessing }
CPPSClassSplitterVisualization >> tagActionBlock: aBlock [

	tagActionBlock := aBlock
]
