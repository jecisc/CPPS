Class {
	#name : #CPPSMultipleFileAnchor,
	#superclass : #CPPSSourceAnchor,
	#traits : 'FamixTMultipleFileAnchor',
	#classTraits : 'FamixTMultipleFileAnchor classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSMultipleFileAnchor class >> annotation [

	<FMClass: #MultipleFileAnchor super: #CPPSSourceAnchor>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #adding }
CPPSMultipleFileAnchor >> addFile: aFileAnchor [
	self allFiles add: aFileAnchor
]
