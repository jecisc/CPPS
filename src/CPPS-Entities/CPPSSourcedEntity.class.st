Class {
	#name : #CPPSSourcedEntity,
	#superclass : #CPPSEntity,
	#traits : 'FamixTSourceEntity',
	#classTraits : 'FamixTSourceEntity classTrait',
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSSourcedEntity class >> annotation [

	<FMClass: #SourcedEntity super: #CPPSEntity>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #'as yet unclassified' }
CPPSSourcedEntity >> gtInspectorSourceTextIn: composite [
	<gtInspectorPresentationOrder: 20>
	composite text
		title: 'Source code';
		withLineNumbers: true;
		format: [ self sourceText ];
		when: [ self sourceText isNotEmpty ]
]
