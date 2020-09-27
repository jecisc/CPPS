"
Description
---------------------

I allow to edit an existing rule. I use the design pattern memento to allow to discard the changes if needed.

Internal Representation and Key Implementation Points.
---------------------

    Instance Variables
	memento:		<aRule>		A memento of the rule to be able to revert the changes if needed. (See Design Pattern Memento for more informations)

"
Class {
	#name : #CPPSRuleEditorComponent,
	#superclass : #CPPSAbstractRuleEditorComponent,
	#instVars : [
		'memento',
		'owner'
	],
	#category : #'CPPS-Toolkit-RulesBrowser'
}

{ #category : #'instance creation' }
CPPSRuleEditorComponent class >> owner: aComponent rule: aBlockOrRule [

	^ self new
		  owner: aComponent;
		  rule: aBlockOrRule;
		  yourself
]

{ #category : #accessing }
CPPSRuleEditorComponent >> memento [

	^ memento
]

{ #category : #accessing }
CPPSRuleEditorComponent >> memento: anObject [

	memento := anObject
]

{ #category : #accessing }
CPPSRuleEditorComponent >> owner [

	^ owner
]

{ #category : #accessing }
CPPSRuleEditorComponent >> owner: anObject [

	owner := anObject
]

{ #category : #rendering }
CPPSRuleEditorComponent >> renderCancelButtonOn: html [

	html mdlMajorButton
		bePush;
		beDanger;
		openDialogWithId: self rootDialogOpenId;
		onClickUpdateRootDialogWith: [ :r | self renderDeleteConfirmationDialogOn: html ];
		with: (self
				 english: 'Delete'
				 french: 'Supprimer').
	html space.
	html mdlButton
		bePush;
		onClick: ((html jQuery id: #'rules-editor-form') load
				 html:
					 [ :r | 
					 self reset.
					 self renderFormOn: r
					 ];
				 onComplete: 'componentHandler.upgradeDom();');
		with: (self
				 english: 'Discard'
				 french: 'Annuler')
]

{ #category : #rendering }
CPPSRuleEditorComponent >> renderDeleteConfirmationDialogOn: html [

	html mdlDialogTitle: (self
			 english: 'Delete Rule'
			 french: 'Supprimer la règle').
	html mdlDialogContent: (self
			 english: 'Are you sur you wish to delete the rule name '
			 french: 'Êtes vous sûr de vouloir supprimer la règle nommée ') , self rule label , '?'.
	html mdlDialogActions:
		[ html mdlMajorAnchorButton
			beDanger;
			callback: [ self owner deleteSelectedRule ];
			with: (self
					 english: 'Delete Rule'
					 french: 'Supprimer là règle').
		html mdlButton
			bePush;
			id: self rootDialogCloseId;
			with: (self
					 english: 'Cancel'
					 french: 'Annuler')
		]
]

{ #category : #accessing }
CPPSRuleEditorComponent >> reset [

	self rule restoreFromMemento: self memento
]

{ #category : #accessing }
CPPSRuleEditorComponent >> rule: aRule [

	super rule: aRule.
	self rule ifNotNil: [ :r | self memento: r createMemento ]
]

{ #category : #actions }
CPPSRuleEditorComponent >> save [

	self memento: self rule createMemento
]

{ #category : #accessing }
CPPSRuleEditorComponent >> title [

	^ self
		  english: 'Edit your rule'
		  french: 'Éditez votre régle'
]
