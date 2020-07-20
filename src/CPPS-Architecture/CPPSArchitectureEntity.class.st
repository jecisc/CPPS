"
Description
--------------------

I represent an abstract entity of a architecture simulation model.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	modelLink:		<anObject>							Object linked to the architectural element. Can be a tag, a CPPSArchitectureEntityBridge, a NullEntity...
	name:				<aString>								Name of the entity.
	parent:			<aCPPSArchitectureLayer>			Owner of the entity. 

"
Class {
	#name : #CPPSArchitectureEntity,
	#superclass : #MooseEntity,
	#instVars : [
		'parent',
		'name',
		'modelLink'
	],
	#category : #'CPPS-Architecture-Model'
}

{ #category : #meta }
CPPSArchitectureEntity class >> annotation [
	<FMClass: #Element super: #MooseEntity>
	<package: #CPPS>
	<abstract>
	
]

{ #category : #'instance creation' }
CPPSArchitectureEntity class >> named: aName [
	^ self new
		name: aName;
		yourself
]

{ #category : #'instance creation' }
CPPSArchitectureEntity class >> named: aName linkedTo: anEntity [
	^ self new
		name: aName;
		linkTo: anEntity;
		yourself
]

{ #category : #comparing }
CPPSArchitectureEntity >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	(self name isNil or: [ self isAssigned not ]) ifTrue: [ ^ false ].
	^ self name = anObject name and: [ self modelEntity = anObject modelEntity ]
]

{ #category : #private }
CPPSArchitectureEntity >> addAllAncestorsIn: aCollection [
	self parent
		ifNotNil: [ :p | 
			aCollection add: p.
			p addAllAncestorsIn: aCollection ].
	^ aCollection
]

{ #category : #dependencies }
CPPSArchitectureEntity >> allClientsIn: aMooseGroup forModel: aMooseModel [
	self isAssigned ifFalse: [ ^ #() ].

	^ self modelEntity allClientsIn: aMooseGroup forModel: aMooseModel
]

{ #category : #accessing }
CPPSArchitectureEntity >> allProviders [
	self isAssigned ifFalse: [ ^ #() ].
	
	^ self modelEntity allProviders
]

{ #category : #dependencies }
CPPSArchitectureEntity >> allProvidersIn: aMooseGroup forModel: aMooseModel [
	self isAssigned ifFalse: [ ^ #() ].

	^ self modelEntity allProvidersIn: aMooseGroup forModel: aMooseModel
]

{ #category : #accessing }
CPPSArchitectureEntity >> ancestors [
	^ self addAllAncestorsIn: OrderedCollection new
]

{ #category : #accessing }
CPPSArchitectureEntity >> architecturalElementsChildrenInModel: aModel [
	"Only layers should return something."

	^ #()
]

{ #category : #accessing }
CPPSArchitectureEntity >> children [
	^ #()
]

{ #category : #testing }
CPPSArchitectureEntity >> includesAnyTag: aCollectionOfTags [
	^ aCollectionOfTags anySatisfy: [ :tag | tag = self modelLink or: [ self modelLink isTag not and: [ self modelLink includesTag: tag ] ] ]
]

{ #category : #testing }
CPPSArchitectureEntity >> isAncestorOf: anArchitectureElement [
	anArchitectureElement ifNil: [ ^ false ].

	anArchitectureElement parent ifNil: [ ^ false ].

	^ anArchitectureElement parent == self or: [ self isAncestorOf: anArchitectureElement parent ]
]

{ #category : #testing }
CPPSArchitectureEntity >> isArchitecturalElement [
	^ true
]

{ #category : #accessing }
CPPSArchitectureEntity >> isAssigned [
	^ self modelLink isAssigned
]

{ #category : #testing }
CPPSArchitectureEntity >> isTagGenerated [
	^ false
]

{ #category : #accessing }
CPPSArchitectureEntity >> linkTo: anEntity [
	self modelLink: (CPPSArchitectureEntityBridge from: self to: anEntity)
]

{ #category : #accessing }
CPPSArchitectureEntity >> modelEntity [
	^ self modelLink entity
]

{ #category : #accessing }
CPPSArchitectureEntity >> modelLink [
	^ modelLink ifNil: [ modelLink := CPPSArchitectureNullEntity new ]
]

{ #category : #accessing }
CPPSArchitectureEntity >> modelLink: anObject [
	modelLink := anObject
]

{ #category : #accessing }
CPPSArchitectureEntity >> name [
	<FMProperty: #name type: #String>
	<FMComment: 'Name of the element'>
	^ name ifNil: [ #noname ]
]

{ #category : #accessing }
CPPSArchitectureEntity >> name: anObject [
	name := anObject
]

{ #category : #testing }
CPPSArchitectureEntity >> nameMatches: anArchitecturalElement [
	"for comparing two architectural elements, they are compared by their moose names to include scope information"

	^ self modelEntity mooseName = anArchitecturalElement modelEntity mooseName
]

{ #category : #accessing }
CPPSArchitectureEntity >> parent [
	<FMProperty: #parent type: #CPPSArchitectureLayer opposite: #children>
	<FMComment: 'parent of the element'>
	<container>
	^ parent
]

{ #category : #accessing }
CPPSArchitectureEntity >> parent: aParent [
	(self isAncestorOf: aParent) ifTrue: [ self error: 'The node is ancestor of the one you want to set as parent, it will create a cycle' ].
	parent := FMMultivalueLink
		on: self
		update: #children
		from: self parent
		to: aParent
]

{ #category : #printing }
CPPSArchitectureEntity >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: (self name ifNil: [ 'no name' ]);
		nextPut: $)
]

{ #category : #actions }
CPPSArchitectureEntity >> remove [
	self parent removeChildren: self
]

{ #category : #accessing }
CPPSArchitectureEntity >> tags [
	^ self modelLink asOrderedCollection
]
