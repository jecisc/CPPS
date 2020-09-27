"
Description
--------------------

I am a component to display outgoing links (reference, invocations...) for the entity
"
Class {
	#name : #CPPSOutgoingComponent,
	#superclass : #CPPSEntityCentricInfoComponent,
	#instVars : [
		'outgoingComponent'
	],
	#category : #'CPPS-Toolkit-CodeAnalyzer-RightPanels'
}

{ #category : #hooks }
CPPSOutgoingComponent >> children [

	^ Array with: self outgoingComponent
]

{ #category : #component }
CPPSOutgoingComponent >> defaultOutgoingComponent [

	| list |

	^ (list := MDLNestedList elements: #(  ))
		  format:
			  [ :e | 
			  e name , (e parents
					   ifNotEmpty: [ :ps | ' (From: ' , ps anyOne name , ')' ]
					   ifEmpty: [ '' ])
			  ];
		  helpBlock: [ :entity | entity tooltipIn: self session language ];
		  iconBlock: #iconComponent;
		  actionBlock: [ :anEntity | self parent selectedEntity: anEntity ];
		  beAltCompact;
		  addDecoration: (CPPSTitleDecoration
				   entitled: (self
						    english: 'Entities I depend on'
						    french: 'Entités dont je dépend')
				   badgeBlock: [ list elements size ]);
		  yourself
]

{ #category : #initialization }
CPPSOutgoingComponent >> initialize [

	super initialize.
	self outgoingComponent: self defaultOutgoingComponent
]

{ #category : #accessing }
CPPSOutgoingComponent >> outgoingComponent [

	^ outgoingComponent
]

{ #category : #accessing }
CPPSOutgoingComponent >> outgoingComponent: anObject [

	outgoingComponent := anObject
]

{ #category : #initialization }
CPPSOutgoingComponent >> receiveEntityChangedAnnouncement: anAnnouncement [

	self outgoingComponent elements: ((anAnnouncement newEntity
			  ifNil: [ #(  ) ]
			  ifNotNil: #allProviders) sorted: #name ascending) asOrderedCollection
]

{ #category : #rendering }
CPPSOutgoingComponent >> renderContentOn: html [

	html div
		class: 'invocations';
		class: 'infoComponent';
		style: self customStyle;
		with: [ html render: self outgoingComponent ]
]
