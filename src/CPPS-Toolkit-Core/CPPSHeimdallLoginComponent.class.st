"
Description
--------------------

I am a login component that redefine the forms of my superclass and add some style to get a good looking component.

For more information see my superclass.
"
Class {
	#name : #CPPSHeimdallLoginComponent,
	#superclass : #HeimdallLoginComponent,
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #rendering }
CPPSHeimdallLoginComponent >> renderContentOn: html [

	html div
		class: 'smallComponent';
		with: [ self renderFormOn: html ]
]

{ #category : #rendering }
CPPSHeimdallLoginComponent >> renderFormOn: html [

	html heading
		level: 2;
		with: (self translate: ('Sign in' french: 'Connection')).
	html form
		class: 'loginForm';
		paddedForm;
		with:
			[ html div
				class: 'form-wrap';
				with:
					[ self
						renderWarningOn: html;
						renderUserOn: html;
						renderPasswordOn: html;
						renderSubmitOn: html;
						warning: nil
					]
			]
]

{ #category : #rendering }
CPPSHeimdallLoginComponent >> renderPasswordOn: html [

	html render: ((MDLTextFieldWidget
			  labeled: (self translate: ('Password' french: 'Mot de passe'))
			  callback: [ :value | password := value ]
			  floatingLabel: true)
			 type: #password;
			 value: password;
			 yourself).
	html break
]

{ #category : #rendering }
CPPSHeimdallLoginComponent >> renderSubmitOn: html [

	html
		mdlSubmitButton: (self translate: ('Login' french: 'Se connecter'))
		callback: [ self login ]
]

{ #category : #rendering }
CPPSHeimdallLoginComponent >> renderUserOn: html [

	html render: ((MDLTextFieldWidget
			  labeled: (self translate: ('User' french: 'Utilisateur'))
			  callback: [ :value | userID := value ]
			  floatingLabel: true)
			 value: userID;
			 propertiesAt: #attributeAt:put:
			 put: #( #autofocus true );
			 yourself).
	html break
]

{ #category : #rendering }
CPPSHeimdallLoginComponent >> renderWarningOn: html [

	self flag: #clean. "No time now :("
	self warning
		ifNil:
			[ self session loggable
				ifNil:
					[ (userID isNil or: [ userID isEmpty ])
						ifTrue: [ html text: 'Please enter User ID and Password' ]
						ifFalse:
							[ html mdlAlert
								beDanger;
								with: 'Login failed!'
							]
					]
				ifNotNil:
					[ html mdlAlert
						beInfo;
						with: 'Logged in as ' , self session loggable login
					]
			]
		ifNotNil:
			[ :warn | 
			html mdlAlert
				beDanger;
				with: warn
			]
]
