"
Description
------------------

I am an object that describe a panel of a tab panel. 

I define some informations to render a panel of a tab panel. 
I know for example the icon of the panel, the label, the component, I can say if it should be render with the current state of the application...

I should be used by a CPPSTabPanelComponent.

Maybe later I should be improved and move to the core package if other browsers need me.

Public API and Key Messages
-------------------

- #shouldBeDisplay 				Return a boolean to know if this panel should be display or not.
- #componentFor: aComponent 	I take in parameter a component and return an instance of the component I am supposed to manage with the parameter as owner.
		
 Example
------------------

	CPPSPanelStrategy
		id: 'select'
		icon: #playlist_add_check
		label: ('Select and Act' french: 'Selectionnez et Agissez')
		componentClass: CPPSQueryResultManagerComponent
		shouldBeDisplayBlock: [ self isAtRoot not ]

Internal Representation and Key Implementation Points.
------------------

    Instance Variables
	component:						<aComponent>			I act as a cache to not recreate the component each time.
	componentClass:					<aClass> 				I am the class of the component to display in the panel.
	icon:								<aSymbol> 			I am the mdl icon name of the component.
	id:									<aString> 			I am the html id of the panel.
	label:								<aTranslatedText> 	I am the name of the panel tab
	shouldBeDisplayBlock:			<aBlock> 				I am a block that should return true if the component should be display or not. Iam optional.
	shouldBeResetBlock:			<aBlock> 				I am a block to execute to know if I should create a new instance of the component
"
Class {
	#name : #CPPSPanelStrategy,
	#superclass : #Object,
	#instVars : [
		'id',
		'icon',
		'label',
		'componentClass',
		'component',
		'shouldBeDisplayBlock',
		'onClickHook'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-PanelComponent'
}

{ #category : #'instance creation' }
CPPSPanelStrategy class >> id: aString icon: aSymbol label: aTranslatedText componentClass: aClassName [

	^ self
		  id: aString
		  icon: aSymbol
		  label: aTranslatedText
		  componentClass: aClassName
		  shouldBeDisplayBlock: nil
]

{ #category : #'instance creation' }
CPPSPanelStrategy class >> id: aString icon: aSymbol label: aTranslatedText componentClass: aClassName shouldBeDisplayBlock: aBlock [

	^ self
		  id: aString
		  icon: aSymbol
		  label: aTranslatedText
		  componentClass: aClassName
		  shouldBeDisplayBlock: aBlock
		  onClick: nil
]

{ #category : #'instance creation' }
CPPSPanelStrategy class >> id: aString icon: aSymbol label: aTranslatedText componentClass: aClassName shouldBeDisplayBlock: aBlock onClick: aJSStream [

	^ self new
		  id: aString;
		  icon: aSymbol;
		  label: aTranslatedText;
		  componentClass: aClassName;
		  shouldBeDisplayBlock: aBlock;
		  onClickHook: aJSStream;
		  yourself
]

{ #category : #accessing }
CPPSPanelStrategy >> component [

	^ component
]

{ #category : #accessing }
CPPSPanelStrategy >> component: anObject [

	component := anObject
]

{ #category : #accessing }
CPPSPanelStrategy >> componentClass [

	^ componentClass
]

{ #category : #accessing }
CPPSPanelStrategy >> componentClass: anObject [

	componentClass := anObject
]

{ #category : #accessing }
CPPSPanelStrategy >> componentFor: aComponent [

	(self component isNotNil and: [ self component owner == aComponent value ]) ifTrue: [ ^ self component ].
	self component: (self componentClass owner: aComponent value).
	^ self component
]

{ #category : #accessing }
CPPSPanelStrategy >> icon [

	^ icon
]

{ #category : #accessing }
CPPSPanelStrategy >> icon: anObject [

	icon := anObject
]

{ #category : #accessing }
CPPSPanelStrategy >> id [

	^ id
]

{ #category : #accessing }
CPPSPanelStrategy >> id: anObject [

	id := anObject
]

{ #category : #accessing }
CPPSPanelStrategy >> label [

	^ label
]

{ #category : #accessing }
CPPSPanelStrategy >> label: anObject [

	label := anObject
]

{ #category : #accessing }
CPPSPanelStrategy >> onClickHook [

	^ onClickHook
]

{ #category : #accessing }
CPPSPanelStrategy >> onClickHook: anObject [

	onClickHook := anObject
]

{ #category : #testing }
CPPSPanelStrategy >> shouldBeDisplay [

	^ self shouldBeDisplayBlock value
]

{ #category : #accessing }
CPPSPanelStrategy >> shouldBeDisplayBlock [

	^ shouldBeDisplayBlock ifNil: [ shouldBeDisplayBlock := [ true ] ]
]

{ #category : #accessing }
CPPSPanelStrategy >> shouldBeDisplayBlock: anObject [

	shouldBeDisplayBlock := anObject
]
