"
Description
--------------------

I should be used to render input elements within a html table.
A column for the input labels.
A column for the input editors / values.
For each input, an additional row displaying the description comment (if there is one).
"
Class {
	#name : #CPPSAjaxMDLTableRenderer,
	#superclass : #MAComponentRenderer,
	#category : #'CPPS-Toolkit-Magritte'
}

{ #category : #rendering }
CPPSAjaxMDLTableRenderer >> basicRenderContainer: aDescription [

	html table
		style: 'background-color: transparent; width: 100%;';
		with: [ super renderContainer: aDescription ]
]

{ #category : #rendering }
CPPSAjaxMDLTableRenderer >> basicRenderControl: aDescription [

	| childComponent |

	childComponent := self childAt: aDescription.
	childComponent isReadonly
		ifTrue: [ html render: childComponent ]
		ifFalse: [ childComponent renderContentOn: html ]
]

{ #category : #private }
CPPSAjaxMDLTableRenderer >> classFor: aDescription [

	| classes |

	classes := OrderedCollection withAll: aDescription currentCssClasses.
	(self hasError: aDescription) ifTrue: [ classes add: 'has-error' ].
	^ ' ' join: classes
]

{ #category : #accessing }
CPPSAjaxMDLTableRenderer >> commentForDescription: aDescription [

	^ aDescription translatableComment
		  ifNil: [ aDescription comment value ]
		  ifNotNil: [ :aTranslateComment | self translate: aTranslateComment ]
]

{ #category : #ajax }
CPPSAjaxMDLTableRenderer >> containerAjaxId [

	^ component ajaxId
]

{ #category : #rendering }
CPPSAjaxMDLTableRenderer >> renderComment: aComment [

	html tableData
		colSpan: 2;
		style: 'color: grey;';
		with:
			[ ((aComment withLineEndings: String cr) findTokens: Character cr)
				do: [ :each | html small: each ]
				separatedBy: [ html break ]
			]
]

{ #category : #rendering }
CPPSAjaxMDLTableRenderer >> renderContainer: aDescription [

	html div
		id: self containerAjaxId;
		style: 'text-align: left';
		with: [ self basicRenderContainer: aDescription ]
]

{ #category : #rendering }
CPPSAjaxMDLTableRenderer >> renderControl: aDescription [

	html tableData with: [ self basicRenderControl: aDescription ]
]

{ #category : #rendering }
CPPSAjaxMDLTableRenderer >> renderElement: aDescription [

	aDescription hidden ifTrue: [ ^ self ].
	aDescription group = group ifFalse: [ self renderGroup: aDescription ].
	html tableRow with: [ self renderElementRow: aDescription ].
	(self commentForDescription: aDescription) ifNotNil: [ :com | html tableRow: [ self renderComment: com ] ]
]

{ #category : #rendering }
CPPSAjaxMDLTableRenderer >> renderElementRow: aDescription [

	"Extracted this method to be better able to override behavior"

	self renderLabel: aDescription.
	self renderControl: aDescription
]

{ #category : #rendering }
CPPSAjaxMDLTableRenderer >> renderLabel: aDescription [

	| label |

	html tableData with:
		[ label := html label
			         class: 'control-label';
			         mdlTypographyTextLeft;
			         yourself.
		(self childAt: aDescription) hasLabelId ifTrue: [ label for: (self childAt: aDescription) labelId ].
		label with: [ html html: aDescription label ]
		]
]

{ #category : #accessing }
CPPSAjaxMDLTableRenderer >> session [

	"needs access to the session in order to manage multi languages"

	^ component session
]

{ #category : #accessing }
CPPSAjaxMDLTableRenderer >> sessionLanguage [

	^ self session language
]

{ #category : #accessing }
CPPSAjaxMDLTableRenderer >> translate: aTranslateText [

	^ aTranslateText textInLanguage: ([ self sessionLanguage ]
			   on: WARequestContextNotFound
			   do: [ #english ])
]
