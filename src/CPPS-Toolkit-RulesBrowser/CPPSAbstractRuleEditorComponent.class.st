"
Description
-------------------

I am an abstract component containing the logic to edit a rule. 

My subclasses should manage what to do if we save/discard.

Public API and Key Messages
-------------------

- #rule 		The rule we are editing.
		
Internal Representation and Key Implementation Points.
-------------------

    Instance Variables
	rule:		<aRule>		This is the rule I am editing.
"
Class {
	#name : #CPPSAbstractRuleEditorComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'rule'
	],
	#category : #'CPPS-Toolkit-RulesBrowser'
}

{ #category : #testing }
CPPSAbstractRuleEditorComponent class >> isAbstract [

	^ self = CPPSAbstractRuleEditorComponent
]

{ #category : #'instance creation' }
CPPSAbstractRuleEditorComponent class >> rule: aRule [

	^ self new
		  rule: aRule;
		  yourself
]

{ #category : #rendering }
CPPSAbstractRuleEditorComponent >> renderButtonsOn: html [

	html div
		pullRight;
		with:
			[ html
				mdlSubmitButton: (self
						 english: 'Save'
						 french: 'Sauver')
				callback: [ self save ].
			html space.
			self renderCancelButtonOn: html
			]
]

{ #category : #rendering }
CPPSAbstractRuleEditorComponent >> renderCancelButtonOn: html [

	self subclassResponsibility
]

{ #category : #rendering }
CPPSAbstractRuleEditorComponent >> renderContentOn: html [

	html div
		class: #'rules-editor';
		with:
			[ self rule
				ifNil:
					[ html div
						class: #'text-center';
						style: 'margin: auto; margin-top: 20px;';
						with: (self
								 english: 'No rule selected.'
								 french: 'Pas de règle selectionnée')
					]
				ifNotNil:
					[ self renderTitleOn: html.
					html form
						id: #'rules-editor-form';
						with: [ self renderFormOn: html ]
					]
			]
]

{ #category : #rendering }
CPPSAbstractRuleEditorComponent >> renderDescriptionInputOn: html [

	html render: ((MDLTextAreaWidget
			  labeled: 'Description'
			  callback: [ :desc | desc ifNotEmpty: [ self rule explanation: desc ] ]
			  floatingLabel: true)
			 value: self rule explanation;
			 formControl;
			 yourself)
]

{ #category : #rendering }
CPPSAbstractRuleEditorComponent >> renderDescriptionOn: html [
	html
		description:
			(self
				english: 'A rule is a query returning a list of infractions for an application. A rule has a name and an estimated time to correct one infraction.'
				french: 'Une règle est une requête retournant une liste d''infractions pour une application. Une règle à un nom et un temps estimé pour corriger une infraction.')
]

{ #category : #rendering }
CPPSAbstractRuleEditorComponent >> renderFormOn: html [

	html div
		style: 'width: 90%;';
		marginAuto;
		with:
			[ self renderNameInputOn: html.
			self renderDescriptionInputOn: html.
			self renderTimeInputOn: html.
			self renderButtonsOn: html
			]
]

{ #category : #rendering }
CPPSAbstractRuleEditorComponent >> renderNameInputOn: html [

	html render: ((MDLTextFieldWidget
			  labeled: (self
					   english: 'Name'
					   french: 'Nom')
			  callback: [ :name | self rule label: (name ifEmpty: [ 'unnamed' ]) ]
			  floatingLabel: true)
			 value: self rule label;
			 required;
			 formControl;
			 yourself)
]

{ #category : #rendering }
CPPSAbstractRuleEditorComponent >> renderTimeInputOn: html [

	html mdlSliderContainer
		formControl;
		with:
			[ | outputId |

			outputId := html nextId.
			html label
				for: html nextId;
				with: (self
						 english: 'Time to correct (min)'
						 french: 'Temps pour corriger (minutes)').
			html mdlIcon: #hourglass_empty.
			html mdlSlider
				onInput: outputId , '.value = ' , html lastId , '.value';
				id: html lastId;
				min: 0;
				max: 500;
				callback: [ :time | self rule remediationTime: time asInteger minutes ];
				value: self rule remediationTime asMinutes asInteger;
				showBounds.
			html output
				id: outputId;
				for: html lastId;
				with: self rule remediationTime asMinutes asInteger.
			html text: 'min'
			]
]

{ #category : #rendering }
CPPSAbstractRuleEditorComponent >> renderTitleOn: html [

	html headerContainer: [ html headline: self title ].
	self renderDescriptionOn: html
]

{ #category : #accessing }
CPPSAbstractRuleEditorComponent >> rule [

	^ rule value
]

{ #category : #accessing }
CPPSAbstractRuleEditorComponent >> rule: anObject [

	rule := anObject
]

{ #category : #actions }
CPPSAbstractRuleEditorComponent >> save [

	self subclassResponsibility
]

{ #category : #accessing }
CPPSAbstractRuleEditorComponent >> title [

	^ self subclassResponsibility
]
