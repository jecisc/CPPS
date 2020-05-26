Class {
	#name : #CPPSIf,
	#superclass : #CPPSConditional,
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSIf class >> annotation [

	<FMClass: #If super: #CPPSConditional>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #display }
CPPSIf class >> nameTranslations [
	^ Dictionary
		with: #english -> 'If'
		with: #french -> 'If'
]
