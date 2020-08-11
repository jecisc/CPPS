"
Description
--------------------

I navigate from entities following moose associations (Access, Invocation, Inheritance, Reference and Tait usage).
I use MooseQuery to get the associations and return their opposite.
My result will be entities of this class that are related to the entities of the input MooseGroup following the chosen associations.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	associationStrategy:		<aClass>			A strategy to define which associations to collect.
	direction:					<aClass>			A strategy to define if we should collect incoming or outgoing dependencies.
	isLocal:						<aBoolean>		A boolean to determine if we should collect only local dependencies or all dependencies in the input and their children.
	withoutSelfLoops:			<aBoolean>		A boolean to determine if we should reject results contained in the receivers of the query.

"
Class {
	#name : #FQNavigationQuery,
	#superclass : #FQLeafQuery,
	#instVars : [
		'direction',
		'isLocal',
		'associationStrategy',
		'withoutSelfLoops'
	],
	#category : #'Famix-Queries-Model-Leafs'
}

{ #category : #'instance creation' }
FQNavigationQuery class >> direction: aClass [
	^ self new
		direction: aClass;
		yourself
]

{ #category : #'instance creation' }
FQNavigationQuery class >> direction: aDirectionStrategy isLocal: aBoolean withoutSelfLoops: anotherBoolean associationStrategy: aStrategy [
	^ (self direction: aDirectionStrategy)
		isLocal: aBoolean;
		withoutSelfLoops: anotherBoolean;
		associationStrategy: aStrategy;
		yourself
]

{ #category : #accessing }
FQNavigationQuery class >> directionStrategies [
	^ MQNavigationDirectionStrategy strategies
]

{ #category : #comparing }
FQNavigationQuery >> = anObject [
	^ super = anObject and: [ self associationStrategy = anObject associationStrategy and: [ self direction = anObject direction ] ]
]

{ #category : #accessing }
FQNavigationQuery >> associationStrategy [
	^ associationStrategy
]

{ #category : #accessing }
FQNavigationQuery >> associationStrategy: aStrategy [
	associationStrategy := aStrategy
]

{ #category : #accessing }
FQNavigationQuery >> direction [
	^ direction
]

{ #category : #accessing }
FQNavigationQuery >> direction: anObject [
	direction := anObject
]

{ #category : #printing }
FQNavigationQuery >> displayName [
	^ String
		streamContents: [ :s | 
			isLocal ifTrue: [ s nextPutAll: 'Local ' ].
			s
				nextPutAll: self direction label;
				nextPutAll: ' (';
				nextPutAll: self associationStrategy displayName;
				nextPut: $).
				
			withoutSelfLoops ifTrue: [ s nextPutAll: ' w/t self loops' ]. ]
]

{ #category : #testing }
FQNavigationQuery >> hasAssociation: anAssociation [
	^ associationStrategy
		ifNotNil: [ :asso | asso hasAssociation: anAssociation ]
		ifNil: [ false ]
]

{ #category : #initialization }
FQNavigationQuery >> initialize [
	super initialize.
	direction := self class directionStrategies anyOne.
	withoutSelfLoops := false.
	isLocal := false
]

{ #category : #accessing }
FQNavigationQuery >> isLocal [
	^ isLocal
]

{ #category : #accessing }
FQNavigationQuery >> isLocal: anObject [
	isLocal := anObject
]

{ #category : #run }
FQNavigationQuery >> runOn: aGroup [
	^ self runOn: aGroup resultComputationKind: Set
]

{ #category : #run }
FQNavigationQuery >> runOn: aGroup resultComputationKind: aClass [
	| query |
	query := MQNavigationQuery new
		directionStrategy: self direction;
		shouldCollectChildrenDependencies: isLocal not;
		associationSelectionStrategy: associationStrategy;
		resultKindStrategy: MQNavigationOppositeKindStrategy;
		yourself.
	^ (aGroup
		inject: aClass new
		into: [ :result :entity | 
			| queryResult |
			queryResult := query
				receiver: entity;
				execute.
			result
				addAll:
					(withoutSelfLoops
						ifTrue: [ queryResult withoutSelfLoops ]
						ifFalse: [ queryResult ]);
				yourself ]) asMooseGroup
]

{ #category : #run }
FQNavigationQuery >> runWithoutOmmissionOn: aGroup [
	^ self runOn: aGroup resultComputationKind: OrderedCollection
]

{ #category : #printing }
FQNavigationQuery >> storeOn: aStream [
	aStream
		nextPut: $(;
		nextPutAll: self className;
		nextPutAll: ' direction: '.

	direction storeOn: aStream.

	aStream
		nextPutAll: ' isLocal: ';
		print: isLocal;
		nextPutAll: ' withoutSelfLoops: ';
		print: withoutSelfLoops;
		nextPutAll: ' associationStrategy: '.

	associationStrategy storeOn: aStream.

	aStream nextPut: $)
]

{ #category : #accessing }
FQNavigationQuery >> withoutSelfLoops [
	^ withoutSelfLoops
]

{ #category : #accessing }
FQNavigationQuery >> withoutSelfLoops: anObject [
	withoutSelfLoops := anObject
]
