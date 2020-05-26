Class {
	#name : #CPPSFor,
	#superclass : #CPPSConditional,
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSFor class >> annotation [

	<FMClass: #For super: #CPPSConditional>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #display }
CPPSFor class >> nameTranslations [
	^ Dictionary
		with: #english -> 'For'
		with: #french -> 'For'
]
