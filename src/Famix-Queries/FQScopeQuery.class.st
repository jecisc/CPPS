"
Description
--------------------

I am a query allowing one to move up and/or down in the containment DAG of the input entities.	
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	directionStrategy:		<aStrategy>		Strategy defining if we are going up/down/both in the containment DAG. 
	isRecursive:				<aBoolean>		If true, the query will be recursive.
	typeStrategy:			<aStrategy>		A strategy defining the scope wanted.

"
Class {
	#name : #FQScopeQuery,
	#superclass : #FQLeafQuery,
	#instVars : [
		'directionStrategy',
		'isRecursive',
		'typeStrategy'
	],
	#category : #'Famix-Queries-Model-Leafs'
}

{ #category : #accessing }
FQScopeQuery class >> directionStrategies [
	^ MQScopeDirectionStrategy strategies
]

{ #category : #'instance creation' }
FQScopeQuery class >> entityType: aClass [
	^ self scope: (MQScopeTypeStrategy scope: aClass) direction: MQScopeUpStrategy isRecursive: false
]

{ #category : #'instance creation' }
FQScopeQuery class >> scope: aTypeStrategy direction: aDirection isRecursive: aBoolean [
	^ self new
		typeStrategy: aTypeStrategy;
		directionStrategy: aDirection;
		isRecursive: aBoolean;
		yourself
]

{ #category : #comparing }
FQScopeQuery >> = anObject [
	^ super = anObject and: [ self typeStrategy = anObject typeStrategy ]
]

{ #category : #accessing }
FQScopeQuery >> availableTypeStrategiesFor: aMooseGroup [
	^ (((self directionStrategy availableScopesFor: aMooseGroup) collect: [ :each | MQScopeTypeStrategy scope: each ]) sorted: #displayName ascending)
		, {MQScopeAllTypesStrategy new}
]

{ #category : #accessing }
FQScopeQuery >> directionStrategy [
	^ directionStrategy
]

{ #category : #accessing }
FQScopeQuery >> directionStrategy: anObject [
	directionStrategy := anObject
]

{ #category : #printing }
FQScopeQuery >> displayName [
	^ String
		streamContents: [ :s | 
			s
				nextPutAll: 'Level: ';
				nextPutAll: typeStrategy displayName.
			isRecursive ifTrue: [ s nextPutAll: ' recursively' ] ]
]

{ #category : #initialization }
FQScopeQuery >> initialize [
	super initialize.
	directionStrategy := MQScopeAllStrategy.
	isRecursive := false
]

{ #category : #accessing }
FQScopeQuery >> isRecursive [
	^ isRecursive
]

{ #category : #accessing }
FQScopeQuery >> isRecursive: anObject [
	isRecursive := anObject
]

{ #category : #run }
FQScopeQuery >> runOn: aGroup [
	| query |
	query := MQScopeQuery new
		typeStrategy: typeStrategy;
		direction: directionStrategy;
		isRecursive: isRecursive;
		yourself.

	aGroup
		do: [ :entity | 
			query
				receiver: entity;
				execute ].

	^ query result asMooseGroup
]

{ #category : #run }
FQScopeQuery >> runWithoutOmmissionOn: aGroup [
	| query |
	query := MQScopeQuery new
		result: OrderedCollection new;
		typeStrategy: typeStrategy;
		direction: directionStrategy;
		isRecursive: isRecursive;
		yourself.

	aGroup
		do: [ :entity | 
			query
				receiver: entity;
				execute ].

	^ query result
]

{ #category : #printing }
FQScopeQuery >> storeOn: aStream [
	aStream
		nextPut: $(;
		nextPutAll: self className;
		nextPutAll: ' scope: '.

	self typeStrategy storeOn: aStream.

	aStream nextPutAll: ' direction: '.

	self directionStrategy storeOn: aStream.

	aStream
		nextPutAll: ' isRecursive: ';
		print: isRecursive;
		nextPut: $)
]

{ #category : #accessing }
FQScopeQuery >> typeStrategy [
	^ typeStrategy
]

{ #category : #accessing }
FQScopeQuery >> typeStrategy: anObject [
	typeStrategy := anObject
]
