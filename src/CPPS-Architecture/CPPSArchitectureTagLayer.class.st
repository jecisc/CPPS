"
Description
--------------------

I am a special layer based on a tag. I will be converted as an architecture layer when I need to be displayed
"
Class {
	#name : #CPPSArchitectureTagLayer,
	#superclass : #CPPSArchitectureEntity,
	#instVars : [
		'tag'
	],
	#category : #'CPPS-Architecture-Model'
}

{ #category : #meta }
CPPSArchitectureTagLayer class >> annotation [
	<FMClass: #TagLayer super: #CPPSArchitectureEntity >
	<package: #CPPS>
]

{ #category : #'instance creation' }
CPPSArchitectureTagLayer class >> fromTag: aTag [
	^ self new
		tag: aTag;
		yourself
]

{ #category : #testing }
CPPSArchitectureTagLayer >> isTagGenerated [
	^ true
]

{ #category : #accessing }
CPPSArchitectureTagLayer >> name [
	^ name ifNil: [ self tag ifNil: [ 'unnamed' ] ifNotNil: #name ]
]

{ #category : #layer }
CPPSArchitectureTagLayer >> obtainLayer [
	^ self tag asArchitecturalEntity 
]

{ #category : #accessing }
CPPSArchitectureTagLayer >> tag [
	^ tag
]

{ #category : #accessing }
CPPSArchitectureTagLayer >> tag: anObject [
	tag := anObject
]
