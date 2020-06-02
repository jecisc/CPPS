"
Description
--------------------

I am a source anchor storing the sources by pointing another source anchor and defining a subpart of this source as my sourced.

I point another source anchor and define a start and end position in the source text of this source anchor as my anchor.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	endPos:					<anInteger>				Position of the last character of my source in the source text of the relative anchor.
	relatedAnchor:			<aSourceAnchor>			The anchor I'll get my relative sources from.
	startPos:					<anInteger>				Position of the first character of my source in the source text of the relative anchor.

"
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
CPPSRelativeSourceAnchor >> endLine [
	^ self privateState
		cacheAt: #endLine
		ifAbsent: [ self ensureStartAndEndLineAreSet.
			self privateState cacheAt: #endLine ifAbsent: [ self error ] ]
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
CPPSRelativeSourceAnchor >> ensureStartAndEndLineAreSet [
	self initializeStartAndEndLineFrom: self relatedAnchor sourceText
]

{ #category : #accessing }
CPPSRelativeSourceAnchor >> fileName [
	^ self relatedAnchor fileName
]

{ #category : #accessing }
CPPSRelativeSourceAnchor >> initializeStartAndEndLineFrom: sourceText [
	self privateState cacheAt: #startLine put: (sourceText lineNumberCorrespondingToIndex: self startPos) + (self relatedAnchor startLine ifNil: [ 0 ]).
	self privateState cacheAt: #endLine put: (sourceText lineNumberCorrespondingToIndex: self endPos) + (self relatedAnchor startLine ifNil: [ 0 ])
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
CPPSRelativeSourceAnchor >> sourceText [
	^ self relatedAnchor sourceTextFrom: self startPos to: self endPos
]

{ #category : #accessing }
CPPSRelativeSourceAnchor >> sourceTextFrom: start to: end [
	^ self relatedAnchor sourceTextFrom: start + self startPos - 1 to: self startPos + end - 1
]

{ #category : #testing }
CPPSRelativeSourceAnchor >> startBeforeFileAnchor: aTFileAnchor [
	(self startLine isNil or: [ aTFileAnchor startLine isNil ]) ifTrue: [ ^ false ].
		
	^ aTFileAnchor startLine >= self startLine
]

{ #category : #accessing }
CPPSRelativeSourceAnchor >> startLine [
	^ self privateState
		cacheAt: #startLine
		ifAbsent: [ self ensureStartAndEndLineAreSet.
			self privateState cacheAt: #startLine ifAbsent: [ self error ] ]
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
