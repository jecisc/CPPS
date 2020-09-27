"
Description
--------------------

I represent one panel in the entity centric component (a main one, centered)
"
Class {
	#name : #CPPSEntityCentricPanelComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'parent',
		'isUseful'
	],
	#category : #'CPPS-Toolkit-CodeAnalyzer-TabPanels'
}

{ #category : #'instance creation' }
CPPSEntityCentricPanelComponent class >> newWithParent: aParent [

	^ self new
		  parent: aParent;
		  yourself
]

{ #category : #title }
CPPSEntityCentricPanelComponent class >> panelTitle [

	self subclassResponsibility
]

{ #category : #comparing }
CPPSEntityCentricPanelComponent >> = anObject [

	^ super = anObject or: [ self species = anObject species ]
]

{ #category : #accessing }
CPPSEntityCentricPanelComponent >> announcer [

	^ self parent announcer
]

{ #category : #testing }
CPPSEntityCentricPanelComponent >> computeIsUseful [

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSEntityCentricPanelComponent >> entity [

	^ self parent entity
]

{ #category : #comparing }
CPPSEntityCentricPanelComponent >> isSimilarTo: aEntityCentricPanelComponent [

	^ self class = aEntityCentricPanelComponent class
]

{ #category : #testing }
CPPSEntityCentricPanelComponent >> isUseful [

	"We cache isUseful because sometime it can be long (for example on the :: namespace in our nck sources) to compute and it will only needs to be invalidated when the entity change for now."

	^ isUseful ifNil: [ isUseful := self computeIsUseful ]
]

{ #category : #title }
CPPSEntityCentricPanelComponent >> panelTitle [

	^ self class panelTitle
]

{ #category : #accessing }
CPPSEntityCentricPanelComponent >> parent [

	^ parent
]

{ #category : #accessing }
CPPSEntityCentricPanelComponent >> parent: anObject [

	parent == anObject ifTrue: [ ^ self ].
	parent := anObject.
	self announcer
		when: CPPSCodeAnalyzerEntityUpdated
		send: #receiveEntityChangedAnnouncement:
		to: self
]

{ #category : #initialization }
CPPSEntityCentricPanelComponent >> receiveEntityChangedAnnouncement: anAnnoucement [

	isUseful := nil
]

{ #category : #rendering }
CPPSEntityCentricPanelComponent >> renderTabHeaderOf: aComponent on: html [

	self isUseful ifFalse: [ ^ self ].
	html mdlTab
		isActiveIf: aComponent currentTab = self;
		class: 'activeByHand'
		if: aComponent currentTab = self;
		id: html nextId;
		callback: [ aComponent currentTab: self ];
		with: (self translate: self panelTitle)
]
