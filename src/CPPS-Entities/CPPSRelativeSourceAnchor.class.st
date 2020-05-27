Class {
	#name : #CPPSRelativeSourceAnchor,
	#superclass : #CPPSEntity,
	#traits : 'FamixTSourceAnchor',
	#classTraits : 'FamixTSourceAnchor classTrait',
	#instVars : [
		'#endPos => FMProperty',
		'#relatedAnchor => FMProperty',
		'#startPos => FMProperty'
	],
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSRelativeSourceAnchor class >> annotation [

	<FMClass: #RelativeSourceAnchor super: #CPPSEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #accessing }
CPPSRelativeSourceAnchor >> completeText [
	^ self relatedAnchor sourceText
]

{ #category : #accessing }
CPPSRelativeSourceAnchor >> endPos [

	<FMProperty: #endPos type: #Number>
	<generated>
	<FMComment: 'Stop position in the source'>
	^ endPos
]

{ #category : #accessing }
CPPSRelativeSourceAnchor >> endPos: anObject [
	<generated>
	endPos := anObject
]

{ #category : #accessing }
CPPSRelativeSourceAnchor >> relatedAnchor [

	<FMProperty: #relatedAnchor type: #FamixTSourceAnchor>
	<generated>
	<FMComment: 'Source anchor to which I am relative.'>
	^ relatedAnchor
]

{ #category : #accessing }
CPPSRelativeSourceAnchor >> relatedAnchor: anObject [
	<generated>
	relatedAnchor := anObject
]

{ #category : #accessing }
CPPSRelativeSourceAnchor >> startPos [

	<FMProperty: #startPos type: #Number>
	<generated>
	<FMComment: 'Start position in the source'>
	^ startPos
]

{ #category : #accessing }
CPPSRelativeSourceAnchor >> startPos: anObject [
	<generated>
	startPos := anObject
]
