Class {
	#name : #CPPSTextFilterComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'elements',
		'ajaxOnChange'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #'as yet unclassified' }
CPPSTextFilterComponent class >> withOnChange: aScript [

	^ self new
		  ajaxOnChange: aScript;
		  yourself
]

{ #category : #accessing }
CPPSTextFilterComponent >> ajaxOnChange [

	^ ajaxOnChange
]

{ #category : #accessing }
CPPSTextFilterComponent >> ajaxOnChange: aScript [

	ajaxOnChange := aScript
]

{ #category : #rendering }
CPPSTextFilterComponent >> renderContentOn: html [

	html mdlIcon: 'search'.
	html mdlTextFieldContainer with:
		[ | fieldId |

		html mdlTextFieldInput
			id: (fieldId := html nextId);
			type: 'text';
			onChange: (self ajaxOnChange value: html).
		html mdlTextFieldLabel
			for: fieldId;
			with: 'text filter'
		]
]
