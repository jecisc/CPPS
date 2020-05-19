Class {
	#name : #CPPSFileAnchor,
	#superclass : #CPPSSourceAnchor,
	#traits : 'FamixTFileNavigation',
	#classTraits : 'FamixTFileNavigation classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSFileAnchor class >> annotation [

	<FMClass: #FileAnchor super: #CPPSSourceAnchor>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #adding }
CPPSFileAnchor >> addFileAnchorWithPath: aPath [
	^ CPPSMultipleFileAnchor new
		mooseModel: self mooseModel;
		addFile: self;
		addFileAnchorWithPath: aPath;
		yourself
]
