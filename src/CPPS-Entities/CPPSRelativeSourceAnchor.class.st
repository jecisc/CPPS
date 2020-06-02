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
	#traits : 'FamixTRelativeSourceAnchor',
	#classTraits : 'FamixTRelativeSourceAnchor classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSRelativeSourceAnchor class >> annotation [

	<FMClass: #RelativeSourceAnchor super: #CPPSEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #testing }
CPPSRelativeSourceAnchor >> startBeforeFileAnchor: aTFileAnchor [
	(self startLine isNil or: [ aTFileAnchor startLine isNil ]) ifTrue: [ ^ false ].
		
	^ aTFileAnchor startLine >= self startLine
]
