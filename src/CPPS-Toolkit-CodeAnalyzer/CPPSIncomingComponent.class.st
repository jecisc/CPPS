"
Description
--------------------

I am a component to display incoming links (reference, invocations...) for the entity
"
Class {
	#name : #CPPSIncomingComponent,
	#superclass : #CPPSEntityCentricInfoComponent,
	#instVars : [
		'incomingComponent'
	],
	#category : #'CPPS-Toolkit-CodeAnalyzer-RightPanels'
}

{ #category : #hooks }
CPPSIncomingComponent >> children [

	^ Array with: self incomingComponent
]

{ #category : #components }
CPPSIncomingComponent >> defaultIncomingComponent [

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
						    english: 'Entities depending on me'
						    french: 'Entités qui dépendent de moi')
				   badgeBlock: [ list elements size ]);
		  yourself
]

{ #category : #accessing }
CPPSIncomingComponent >> incomingComponent [

	^ incomingComponent
]

{ #category : #accessing }
CPPSIncomingComponent >> incomingComponent: anObject [

	incomingComponent := anObject
]

{ #category : #initialization }
CPPSIncomingComponent >> initialize [

	super initialize.
	self incomingComponent: self defaultIncomingComponent
]

{ #category : #initialization }
CPPSIncomingComponent >> receiveEntityChangedAnnouncement: anAnnouncement [

	self incomingComponent elements: ((anAnnouncement newEntity
			  ifNil: [ #(  ) ]
			  ifNotNil: #allClients) sorted: #name ascending) asOrderedCollection
]

{ #category : #rendering }
CPPSIncomingComponent >> renderContentOn: html [

	html div
		class: 'invocations';
		class: 'infoComponent';
		style: self customStyle;
		with: [ html render: self incomingComponent ]
]
