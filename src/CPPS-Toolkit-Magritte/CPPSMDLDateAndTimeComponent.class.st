Class {
	#name : #CPPSMDLDateAndTimeComponent,
	#superclass : #MATimeStampInputComponent,
	#category : #'CPPS-Toolkit-Magritte-Components'
}

{ #category : #rendering }
CPPSMDLDateAndTimeComponent >> renderEditorOn: html [

	| value current dateTime |

	current := DateAndTime
		           date: Date today
		           time: Time now.
	value := self magritteDescription shouldDisplayCurrent
		         ifTrue: [ current ]
		         ifFalse: [ self value ifNil: [ current ] ].
	html div
		class: 'dateAndTime';
		with:
			[ html mdlTextFieldContainer:
					[ html mdlTextFieldInput
						id: 'input_date';
						value: value asDate yyyymmdd;
						callback: [ :date | dateTime := date asDate ];
						pattern: '(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))';
						type: 'date'.
					html mdlTextFieldError: 'Format: YYYY-MM-DD'
					].
			html break.
			html mdlTextFieldContainer:
				[ html mdlTextFieldInput
					id: 'input_date';
					value: value asTime forHtmlTextArea;
					callback:
						[ :time | 
						dateTime := DateAndTime
							            date: dateTime
							            time: time asTime.
						self value: dateTime
						];
					pattern: '(0[0-9]|1[0-9]|2[0-3]):([0-5][0-9])';
					type: 'time'.
				html mdlTextFieldError: 'Format: HH-MM'
				]
			]
]
