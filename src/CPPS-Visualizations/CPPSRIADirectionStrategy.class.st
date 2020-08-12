"
Description
--------------------

I am an abstract class to manage the direction of the dependencies to manage in the RIA.

"
Class {
	#name : #CPPSRIADirectionStrategy,
	#superclass : #Object,
	#classVars : [
		'HighlightConnections'
	],
	#category : #'CPPS-Visualizations-Visualizations-RefactoringImpactAnalyzer'
}

{ #category : #actions }
CPPSRIADirectionStrategy class >> createLinksFor: aNode toNode: anotherNode [

	| connection |

	connection := self
		              privateCreateLinksFor: aNode
		              toNode: anotherNode.
	self highlightConnections ifTrue: [ connection addInteraction: self defaultInteractionForConnections ]
]

{ #category : #actions }
CPPSRIADirectionStrategy class >> createLinksFor: aNode toNodes: aCollection [

	| connections |

	connections := self
		               privateCreateLinksFor: aNode
		               toNode: aCollection.
	self highlightConnections ifTrue: [ connections do: [ :connection | connection addInteraction: self defaultInteractionForConnections ] ]
]

{ #category : #actions }
CPPSRIADirectionStrategy class >> defaultInteractionForConnections [

	"On mouse over change the color of the connections and the border color of the connected nodes."

	^ (TLStyleCustomizationAction
		   custom:
			   [ :style :drawable | 
			   drawable isConnection
				   ifTrue:
					   [ style
						   color: MDLColor red;
						   width: 3
					   ]
				   ifFalse:
					   [ style
						   borderColor: MDLColor red;
						   labelSize: 20;
						   textColor: MDLColor red
					   ]
			   ]
		   target:
			   [ :connection | 
			   OrderedCollection
				   with: connection
				   with: connection toNode
				   with: connection fromNode
			   ]) onMouseOver
]

{ #category : #accessing }
CPPSRIADirectionStrategy class >> getAllConnectableEntitiesFor: anEntity in: aModel atDefaultScope: aClass [

	"For an entity I should return the dependencies at a certain level."

	^ Set withAll: (anEntity isTag
			   ifTrue:
				   [ (self
					    getAllConnectableEntitiesForTag: anEntity
					    inModel: aModel
					    atDefaultScope: aClass) \ (anEntity
					    allEntitiesRecursivelyIn: aModel
					    flatCollect: [ :entity | entity allChildren , { entity } ])
				   ]
			   ifFalse:
				   [ self
					   getAllConnectableEntitiesForFamixEntity: anEntity
					   atDefaultScope: aClass
				   ])
]

{ #category : #accessing }
CPPSRIADirectionStrategy class >> getAllConnectableEntitiesForFamixEntity: anEntity atDefaultScope: aClass [

	"For a non tag entity I should return the the dependencies at a certain level."

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSRIADirectionStrategy class >> getAllConnectableEntitiesForTag: aTag inModel: aModel atDefaultScope: aClass [

	"For a tag I should return the all the dependencies at a certain level."

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSRIADirectionStrategy class >> highlightConnections [

	^ HighlightConnections
]

{ #category : #accessing }
CPPSRIADirectionStrategy class >> highlightConnections: anObject [

	HighlightConnections := anObject
]

{ #category : #initialization }
CPPSRIADirectionStrategy class >> initialize [

	self highlightConnections: false
]

{ #category : #accessing }
CPPSRIADirectionStrategy class >> label [

	^ self subclassResponsibility
]

{ #category : #actions }
CPPSRIADirectionStrategy class >> privateCreateLinksFor: aNode toNode: anotherNode [

	self subclassResponsibility
]

{ #category : #actions }
CPPSRIADirectionStrategy class >> privateCreateLinksFor: node toNodes: aCollection [

	self subclassResponsibility
]
