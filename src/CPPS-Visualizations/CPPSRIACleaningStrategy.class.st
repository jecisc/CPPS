"
Description
--------------------

I am an abstract class to manage different cleaning strategies in the RefactoringImpactAnalyzer. 

I can generate the informations for the contextual menu in the visualization. 

Public API and Key Messages
--------------------

- #executeOn: 		This method is call when a node received a cleaning interaction. It takes as parameter the node and should clean it.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	visualization:		<Object>

"
Class {
	#name : #CPPSRIACleaningStrategy,
	#superclass : #Object,
	#category : #'CPPS-Visualizations-Visualizations-RefactoringImpactAnalyzer'
}

{ #category : #accessing }
CPPSRIACleaningStrategy class >> description [

	"Menu item to display in the visualization."

	^ self subclassResponsibility
]

{ #category : #execute }
CPPSRIACleaningStrategy class >> executeOn: aNode in: aVisualization [

	self subclassResponsibility
]

{ #category : #accessing }
CPPSRIACleaningStrategy class >> index [

	"Each strategy should have an index for the menu in the visualization."

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSRIACleaningStrategy class >> strategyAtIndex: anInteger [

	^ self allSubclasses
		  detect: [ :each | each index = anInteger ]
		  ifNone: [ self error: 'No cleaning strategy for this menu entry.' ]
]

{ #category : #accessing }
CPPSRIACleaningStrategy class >> userChoices [

	^ (self allSubclasses sorted: [ :c1 :c2 | c1 index < c2 index ]) collect: [ :class | class index asString , '. ' , class description ]
]
