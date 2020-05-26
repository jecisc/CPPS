Class {
	#name : #CPPSWhile,
	#superclass : #CPPSConditional,
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSWhile class >> annotation [

	<FMClass: #While super: #CPPSConditional>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #display }
CPPSWhile class >> nameTranslations [
	^ Dictionary
		with: #english -> 'While'
		with: #french -> 'While'
]
