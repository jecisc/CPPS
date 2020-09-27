"
Description
--------------------

Magritte textInput component for a MAStringDescription
"
Class {
	#name : #CPPSMDLTextInputComponent,
	#superclass : #MATextInputComponent,
	#category : #'CPPS-Toolkit-Magritte-Components'
}

{ #category : #rendering }
CPPSMDLTextInputComponent >> renderInputOn: html [

	html mdlTextFieldContainer
		style: 'display: block';
		floatingLabel;
		with:
			[ | inputId |

			inputId := self labelId.
			html mdlTextFieldLabel for: inputId.
			html mdlTextFieldInput
				id: inputId;
				on: #string
				of: self
			]
]
