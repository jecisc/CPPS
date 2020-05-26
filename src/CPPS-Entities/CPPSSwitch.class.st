Class {
	#name : #CPPSSwitch,
	#superclass : #CPPSConditional,
	#category : #'CPPS-Entities-Entities'
}

{ #category : #meta }
CPPSSwitch class >> annotation [

	<FMClass: #Switch super: #CPPSConditional>
	<package: #'CPPS-Entities'>
	<generated>
	^self
]

{ #category : #display }
CPPSSwitch class >> nameTranslations [
	^ Dictionary
		with: #english -> 'Switch'
		with: #french -> 'Switch'
]
