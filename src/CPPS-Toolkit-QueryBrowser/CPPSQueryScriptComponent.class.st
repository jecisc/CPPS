"
Description
--------------------

I am a really dangerous component allowing the user to create a query from Pharo code. This should not be available to all our customer because they can break the image with this on get access to all our code.

"
Class {
	#name : #CPPSQueryScriptComponent,
	#superclass : #CPPSQueryComponent,
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #accessing }
CPPSQueryScriptComponent class >> englishName [

	^ 'Script'
]

{ #category : #accessing }
CPPSQueryScriptComponent class >> frenchName [

	^ 'Script'
]

{ #category : #accessing }
CPPSQueryScriptComponent class >> priority [

	^ 70
]

{ #category : #testing }
CPPSQueryScriptComponent >> isUnavailable [

	^ self queryResult isEmpty
]

{ #category : #accessing }
CPPSQueryScriptComponent >> modelClass [

	^ FQScriptQuery
]

{ #category : #rendering }
CPPSQueryScriptComponent >> renderContentOn: html [

	self strategy allowToCreateQueryInPharo ifTrue: [ super renderContentOn: html ]
]

{ #category : #rendering }
CPPSQueryScriptComponent >> renderFormContentOn: html [

	html div
		beCentered;
		with:
			[ html mdlAlert
				beInfo;
				with: (self
						 english: 'In this component you have the possibility to use Pharo syntax in order to create your own query. You can use the variable `inputCollection` as input and you should return a collection of entities.'
						 french: 'Dans ce composant vous avez la possibilité d''utiliser la syntaxe Pharo pour créer votre propre query. Vous pouvez utiliser la variable `inputCollection` en tant qu''entré et vous devez retourner une collection d''entités.').
			self renderScriptAreaOn: html
			]
]

{ #category : #rendering }
CPPSQueryScriptComponent >> renderScriptAreaOn: html [

	html mdlTextFieldContainer
		style: 'width: 80%;';
		with:
			[ html mdlTextFieldLabel
				for: html nextId;
				with: 'Script'.
			html mdlTextArea
				id: html lastId;
				value: self query code;
				callback: [ :script | self query code: script ];
				noAutocomplete;
				rows: 3
			]
]

{ #category : #accessing }
CPPSQueryScriptComponent >> unavailableMessage [

	^ self
		  translate: 'There is no entity in the result to proceed'
		  french: 'Il n''y a aucune entité dans le résultat pour continuer'
]
