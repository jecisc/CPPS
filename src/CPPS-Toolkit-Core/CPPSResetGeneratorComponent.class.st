"
Description
--------------------

I am a simple component to allow to remove the lock on the version generation in case some problem occure.
"
Class {
	#name : #CPPSResetGeneratorComponent,
	#superclass : #CPPSComponent,
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #rendering }
CPPSResetGeneratorComponent >> renderCheckboxOn: html [

	html mdlCheckboxContainer
		for: 'confirmationCheckbox';
		with:
			[ html mdlCheckbox
				id: 'confirmationCheckbox';
				callback: [ :confirmation | confirmation ifTrue: [ self server project generationInProgress: false ] ];
				value: false.
			html mdlCheckboxLabel: (self
					 english: 'Remove lock for version generation'
					 french: 'Retirer le verrou de génération de version')
			]
]

{ #category : #rendering }
CPPSResetGeneratorComponent >> renderContentOn: html [

	html div
		class: 'smallComponent';
		with:
			[ html heading
				level: 2;
				with: (self translate: ('Remove Lock' french: 'Retirer le verrou')).
			self renderFormOn: html
			]
]

{ #category : #rendering }
CPPSResetGeneratorComponent >> renderFormOn: html [

	html form
		paddedForm;
		with:
			[ html div
				class: 'form-wrap';
				with:
					[ self renderCheckboxOn: html.
					self renderSubmitOn: html
					]
			]
]

{ #category : #rendering }
CPPSResetGeneratorComponent >> renderSubmitOn: html [

	html mdlSubmitButton: (self
			 english: 'Apply'
			 french: 'Appliquer')
]
