"
Description
--------------------

I am a query to select or reject entities tagged a specific tag.
	
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	select:		<aBoolean>		If true, select the entities with the tag. If false, reject them.
	tag:			<aTag>				To to look for on entities.

"
Class {
	#name : #FQTagQuery,
	#superclass : #FQLeafQuery,
	#instVars : [
		'tag',
		'select'
	],
	#category : #'Famix-Queries-Model-Leafs'
}

{ #category : #'instance creation' }
FQTagQuery class >> tag: aTag select: aBoolean [
	^ self new
		select: aBoolean;
		tag: aTag;
		yourself
]

{ #category : #printing }
FQTagQuery >> displayName [
	^ self name
]

{ #category : #initialization }
FQTagQuery >> initialize [
	super initialize.
	select := true
]

{ #category : #accessing }
FQTagQuery >> name [
	^ 'TagName: ', self tag name
]

{ #category : #run }
FQTagQuery >> runOn: aMooseGroup [
	"In the future we could use a design pattern strategy instead of hardcoding select and reject."

	^ select
		ifTrue: [ aMooseGroup select: [ :e | e isTaggedWith: self tag ] ]
		ifFalse: [ aMooseGroup reject: [ :e | e isTaggedWith: self tag ] ]
]

{ #category : #accessing }
FQTagQuery >> select [
	^ select
]

{ #category : #accessing }
FQTagQuery >> select: anObject [
	select := anObject
]

{ #category : #printing }
FQTagQuery >> storeOn: aStream [
	aStream
		nextPut: $(;
		nextPutAll: self className;
		nextPutAll: ' tag: UnserializableEntity select:';
		print: select;
		nextPut: $)
]

{ #category : #accessing }
FQTagQuery >> tag [
	^ tag
]

{ #category : #accessing }
FQTagQuery >> tag: anObject [
	tag := anObject
]
