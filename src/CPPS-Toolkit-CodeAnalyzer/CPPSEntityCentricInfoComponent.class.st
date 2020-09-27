"
Description
--------------------

I am an abstract class for all info component that will be displayed in the code analyzer
"
Class {
	#name : #CPPSEntityCentricInfoComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'parent',
		'customStyle'
	],
	#category : #'CPPS-Toolkit-CodeAnalyzer-RightPanels'
}

{ #category : #'instance creation' }
CPPSEntityCentricInfoComponent class >> newWithParent: aParent [

	^ self new
		  parent: aParent;
		  yourself
]

{ #category : #accessing }
CPPSEntityCentricInfoComponent >> announcer [

	^ self parent announcer
]

{ #category : #accessing }
CPPSEntityCentricInfoComponent >> customStyle [

	^ customStyle
]

{ #category : #accessing }
CPPSEntityCentricInfoComponent >> customStyle: anObject [

	customStyle := anObject
]

{ #category : #accessing }
CPPSEntityCentricInfoComponent >> entity [

	^ self parent selectedEntity
]

{ #category : #testing }
CPPSEntityCentricInfoComponent >> isUseful [

	^ true
]

{ #category : #accessing }
CPPSEntityCentricInfoComponent >> parent [

	^ parent
]

{ #category : #accessing }
CPPSEntityCentricInfoComponent >> parent: anObject [

	parent == anObject ifTrue: [ ^ self ].
	parent := anObject.
	self announcer
		when: CPPSCodeAnalyzerEntityUpdated
		send: #receiveEntityChangedAnnouncement:
		to: self
]

{ #category : #initialization }
CPPSEntityCentricInfoComponent >> receiveEntityChangedAnnouncement: anAnnouncement [

	"This is raised when the code analyzer entity change. By default I do nothing."

	
]

{ #category : #style }
CPPSEntityCentricInfoComponent >> vSize [

	"I represent the pound of my vertical size; if it is 2; i will take twice the height compared to a component with 1"

	^ 1
]

{ #category : #style }
CPPSEntityCentricInfoComponent >> withStyle: aStyle [

	self customStyle: aStyle
]
