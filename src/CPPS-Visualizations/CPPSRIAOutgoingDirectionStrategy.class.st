"
Description
--------------------

I manage everithing related to directions of the RIA for the outgoing direction.
"
Class {
	#name : #CPPSRIAOutgoingDirectionStrategy,
	#superclass : #CPPSRIADirectionStrategy,
	#category : #'CPPS-Visualizations-Visualizations-RefactoringImpactAnalyzer'
}

{ #category : #accessing }
CPPSRIAOutgoingDirectionStrategy class >> getAllConnectableEntitiesForFamixEntity: anEntity atDefaultScope: aClass [

	aClass ifNil: [ ^ anEntity allProviders ].
	^ anEntity allProvidersAtScope: aClass
]

{ #category : #accessing }
CPPSRIAOutgoingDirectionStrategy class >> getAllConnectableEntitiesForTag: aTag inModel: aModel atDefaultScope: aClass [

	aClass ifNil:
		[ ^ aTag
			  allEntitiesRecursivelyIn: aModel
			  flatCollect: #allProviders
		].
	^ aTag
		  allEntitiesRecursivelyIn: aModel
		  flatCollect: [ :each | each allProvidersAtScope: aClass ]
]

{ #category : #accessing }
CPPSRIAOutgoingDirectionStrategy class >> label [

	^ 'Outgoing'
]

{ #category : #actions }
CPPSRIAOutgoingDirectionStrategy class >> privateCreateLinksFor: aNode toNode: anotherNode [

	^ aNode connectIfNotTo: anotherNode
]

{ #category : #actions }
CPPSRIAOutgoingDirectionStrategy class >> privateCreateLinksFor: aNode toNodes: aCollection [

	^ aNode connectIfNotToAll: aCollection
]
