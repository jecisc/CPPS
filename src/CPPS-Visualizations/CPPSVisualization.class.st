"
Description
--------------------

This class is the abstract class for the toolkit visualizations. 

This class manage the language and keep a link to the solution.
"
Class {
	#name : #CPPSVisualization,
	#superclass : #TLVisualization,
	#instVars : [
		'language'
	],
	#classVars : [
		'FontIntervals'
	],
	#category : #'CPPS-Visualizations-Core'
}

{ #category : #'class initialization' }
CPPSVisualization class >> defaultFontIntervals [

	^ Dictionary
		  with: (0 to: 10) -> 44
		  with: (11 to: 27) -> 18
		  with: (28 to: 40) -> 13
		  with: (41 to: 1000) -> 9
]

{ #category : #accessing }
CPPSVisualization class >> dynamicFontSizeFor: aString [

	^ (self fontIntervals associations detect: [ :asso | asso key rangeIncludes: aString size ]) value
]

{ #category : #accessing }
CPPSVisualization class >> fontIntervals [

	^ FontIntervals
]

{ #category : #accessing }
CPPSVisualization class >> fontIntervals: aDictionary [

	FontIntervals := aDictionary
]

{ #category : #initialization }
CPPSVisualization class >> initialize [

	super initialize.
	self fontIntervals: self defaultFontIntervals
]

{ #category : #building }
CPPSVisualization >> addLegendForChildrenBorderStyle [

	self legend
		description: (self translate: ('Has children' french: 'Possède des enfants'))
		forBorderShape: TLDashedLineStyle
]

{ #category : #conveniance }
CPPSVisualization >> addLegendForIncomings [

	self legend
		description: (self translate: ('Incoming dependencies' french: 'Dépendances entrantes'))
		forConnectionStyle: (TLStyleSheet new
				 color: MDLColor blue;
				 fontSize: '2em')
		icon: '→'
]

{ #category : #conveniance }
CPPSVisualization >> addLegendForOutgoings [

	self legend
		description: (self translate: ('Outgoing dependencies' french: 'Dépendances sortantes'))
		forConnectionStyle: (TLStyleSheet new
				 color: MDLColor orange;
				 fontSize: '2em')
		icon: '→'
]

{ #category : #conveniance }
CPPSVisualization >> highlightConnectionsOnMouseOver [

	^ { 
		  (TLStyleCustomizationAction
			   custom:
				   [ :style :drawable | 
				   self
					   setOutgoingHighlightStyleTo: style
					   for: drawable
				   ]
			   target: [ :aDrawable | aDrawable incomingConnections flatCollectAsSet: #withConnectedNodes ]) onMouseOver propagateToChildren.
		  (TLStyleCustomizationAction
			   custom:
				   [ :style :drawable | 
				   self
					   setIncomingHighlightStyleTo: style
					   for: drawable
				   ]
			   target: [ :aDrawable | aDrawable outgoingConnections flatCollectAsSet: #withConnectedNodes ]) onMouseOver propagateToChildren }
]

{ #category : #accessing }
CPPSVisualization >> language [

	^ language ifNil: [ #english ]
]

{ #category : #accessing }
CPPSVisualization >> language: aLanguage [

	language := aLanguage
]

{ #category : #conveniance }
CPPSVisualization >> setIncomingHighlightStyleTo: aStylesheet [

	aStylesheet
		color: MDLColor orange;
		width: 3
]

{ #category : #conveniance }
CPPSVisualization >> setIncomingHighlightStyleTo: aStylesheet for: aDrawable [

	aDrawable isConnection
		ifTrue: [ self setIncomingHighlightStyleTo: aStylesheet ]
		ifFalse:
			[ aStylesheet
				labelSize: 20;
				nodeLabel: #name;
				textColor: MDLColor orange
			]
]

{ #category : #conveniance }
CPPSVisualization >> setOutgoingHighlightStyleTo: aStylesheet [

	aStylesheet
		color: MDLColor blue;
		width: 3
]

{ #category : #conveniance }
CPPSVisualization >> setOutgoingHighlightStyleTo: aStylesheet for: aDrawable [

	aDrawable isConnection
		ifTrue: [ self setOutgoingHighlightStyleTo: aStylesheet ]
		ifFalse:
			[ aStylesheet
				labelSize: 20;
				nodeLabel: #name;
				textColor: MDLColor blue
			]
]

{ #category : #translate }
CPPSVisualization >> translate: aTranslateText [

	^ aTranslateText textInLanguage: self language
]

{ #category : #translate }
CPPSVisualization >> translate: anEnglishText french: aFrenchText [

	^ self translate: (anEnglishText french: aFrenchText)
]
