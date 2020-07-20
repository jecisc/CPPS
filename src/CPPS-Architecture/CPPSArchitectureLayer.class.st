"
Description
--------------------

I am a composite architecture component, i can represent a package, a class or any group of entities.

I can have a display mode for visualisations and a transparency.

I am not linked to any real entity such as a tag or a famix entity.
"
Class {
	#name : #CPPSArchitectureLayer,
	#superclass : #CPPSArchitectureEntity,
	#instVars : [
		'display',
		'children',
		'isTransparent'
	],
	#category : #'CPPS-Architecture-Model'
}

{ #category : #meta }
CPPSArchitectureLayer class >> annotation [
	<FMClass: #Layer super: #CPPSArchitectureEntity >
	<package: #CPPS>
]

{ #category : #'instance creation' }
CPPSArchitectureLayer class >> children: aCollection [
	^ self new
		children: aCollection;
		yourself
]

{ #category : #'instance creation' }
CPPSArchitectureLayer class >> newRoot [
	^ self new
		isTransparent: true;
		yourself
]

{ #category : #adding }
CPPSArchitectureLayer >> addChild: aChildren [
	aChildren parent: self.
	^ aChildren
]

{ #category : #accessing }
CPPSArchitectureLayer >> architecturalElementsChildrenInModel: aModel [
	^ self modelLink isTag
		ifTrue: [ self children , ((self modelLink taggedEntitiesInModel: aModel) collect: #asArchitecturalEntity) ]
		ifFalse: [ self children ]
]

{ #category : #accessing }
CPPSArchitectureLayer >> children [
	<FMProperty: #children type: #CPPSArchitectureEntity opposite: #parent>
	<multivalued>
	<FMComment: 'children of this layer'>
	^ children
]

{ #category : #accessing }
CPPSArchitectureLayer >> children: childrenCollection [
	childrenCollection do: [ :aChildren | aChildren parent: self ].
	children := childrenCollection asOrderedCollection
]

{ #category : #accessing }
CPPSArchitectureLayer >> deleteAllChildren [
	[ self children isEmpty ]
		whileFalse: [ self children first deleteAllChildren.
			self children remove: self children first ]
]

{ #category : #accessing }
CPPSArchitectureLayer >> display [
	<FMProperty: #display type: #String>
	<FMComment: 'The way to display this layer'>
	^ display
]

{ #category : #accessing }
CPPSArchitectureLayer >> display: anObject [
	display := anObject
]

{ #category : #accessing }
CPPSArchitectureLayer >> grid [
	self display: #grid
]

{ #category : #'GTInspector-Extensions' }
CPPSArchitectureLayer >> gtInspectorSubPresentersIn: composite [
	<gtInspectorPresentationOrder: 20>
	composite tree
		title: 'Architecture Layer';
		rootsExpanded;
		display: [ :each | {each} ];
		children: [ :each | each children ];
		when: [ :each | each children isNotEmpty ]
]

{ #category : #testing }
CPPSArchitectureLayer >> hasChildren [
	^ self children isNotEmpty
]

{ #category : #accessing }
CPPSArchitectureLayer >> horizontal [
	self display: #horizontal
]

{ #category : #initialization }
CPPSArchitectureLayer >> initialize [
	super initialize.
	self horizontal.
	children := FMMultivalueLink on: self opposite: #parent:.
	self isTransparent: false
]

{ #category : #testing }
CPPSArchitectureLayer >> isArchitecturalLayer [
	^ true
]

{ #category : #testing }
CPPSArchitectureLayer >> isTransparent [
	<FMProperty: #transparent type: #Boolean>
	<FMComment: 'Boolean if this layer should be transparent'>
	^ isTransparent
]

{ #category : #accessing }
CPPSArchitectureLayer >> isTransparent: anObject [
	isTransparent := anObject
]

{ #category : #accessing }
CPPSArchitectureLayer >> isVertical [
	^ self display = #vertical
]

{ #category : #layer }
CPPSArchitectureLayer >> obtainLayer [
	^ self
]

{ #category : #adding }
CPPSArchitectureLayer >> removeChildren: aChildren [
	^ self children remove: aChildren
]

{ #category : #accessing }
CPPSArchitectureLayer >> transparent [
	self isTransparent: true
]

{ #category : #accessing }
CPPSArchitectureLayer >> vertical [
	self display: #vertical
]
