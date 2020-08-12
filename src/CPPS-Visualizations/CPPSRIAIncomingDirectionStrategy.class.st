"
Description
--------------------

I manage everithing related to directions of the RIA for the incoming direction.
"
Class {
	#name : #CPPSRIAIncomingDirectionStrategy,
	#superclass : #CPPSRIADirectionStrategy,
	#category : #'CPPS-Visualizations-Visualizations-RefactoringImpactAnalyzer'
}

{ #category : #accessing }
CPPSRIAIncomingDirectionStrategy class >> getAllConnectableEntitiesForFamixEntity: anEntity atDefaultScope: aClass [

	aClass ifNil: [ ^ anEntity allClients ].
	^ anEntity allClientsAtScope: aClass
]

{ #category : #accessing }
CPPSRIAIncomingDirectionStrategy class >> getAllConnectableEntitiesForTag: aTag inModel: aModel atDefaultScope: aClass [

	aClass ifNil:
		[ ^ aTag
			  allEntitiesRecursivelyIn: aModel
			  flatCollect: #allClients
		].
	^ aTag
		  allEntitiesRecursivelyIn: aModel
		  flatCollect: [ :each | each allClientsAtScope: aClass ]
]

{ #category : #accessing }
CPPSRIAIncomingDirectionStrategy class >> label [

	^ 'Incoming'
]

{ #category : #actions }
CPPSRIAIncomingDirectionStrategy class >> privateCreateLinksFor: aNode toNode: anotherNode [

	^ anotherNode connectIfNotTo: aNode
]

{ #category : #actions }
CPPSRIAIncomingDirectionStrategy class >> privateCreateLinksFor: aNode toNodes: aCollection [

	^ aCollection collect: [ :each | each connectIfNotTo: aNode ]
]
