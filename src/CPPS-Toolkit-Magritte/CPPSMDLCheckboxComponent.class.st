Class {
	#name : #CPPSMDLCheckboxComponent,
	#superclass : #MACheckboxComponent,
	#category : #'CPPS-Toolkit-Magritte-Components'
}

{ #category : #rendering }
CPPSMDLCheckboxComponent >> renderEditorOn: html [

	html mdlCheckboxContainer
		for: self labelId;
		with:
			[ html mdlCheckbox
				id: self labelId;
				disabled: self isReadonly;
				on: #value
				of: self.
			html mdlCheckboxLabel: self magritteDescription checkboxLabel
			]
]
