"
Description
-------------------

I am a button use to change the content of a panel.

Sometimes we show contents inside a panel but we want to change. This button is here to do that. 

I was designed at the beginning for the code analyzer but can evolve.

I should probably be use inside a CPPSVerticalToolbar. 

Example
--------------------

	CPPSPanelSwitcherButton
		text: 'Tags'
		tooltip: 'Show the Tag panel'
		panelId: #'code-analyzer-right-panel'
		actionBlock: [ :r | 
			self setTagPanel.
			self renderRightPanelOn: r ]
		onComplete: 'var button = $("".fold-button""); if(button.attr(""data-fold"") == ""true""){button.click()}'
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	actionBlock:			<aBlock>	I am a block taking a canvas as parameter. I should draw the content on the panel on this canvas.
	onCompleteJs:		<aString>	I am an optional script to add after the redraw is done.
	panelId:				<aSymbol>	I am the dom id of the panel to redraw.
	text:				<aString>	I am the text to display on the button.
	tooltip:				<aString>	I am an optional tooltip.
"
Class {
	#name : #CPPSPanelSwitcherButton,
	#superclass : #CPPSComponent,
	#instVars : [
		'panelId',
		'text',
		'actionBlock',
		'tooltip',
		'onCompleteJs',
		'id',
		'owner',
		'isSelected'
	],
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #'instance creation' }
CPPSPanelSwitcherButton class >> text: aString tooltip: aTranslatedString panelId: anId actionBlock: aBlock [

	^ self
		  text: aString
		  tooltip: aTranslatedString
		  panelId: anId
		  actionBlock: aBlock
		  onComplete: nil
]

{ #category : #'instance creation' }
CPPSPanelSwitcherButton class >> text: aString tooltip: aTranslatedString panelId: anId actionBlock: aBlock onComplete: aJSString [

	^ self
		  text: aString
		  tooltip: aTranslatedString
		  panelId: anId
		  actionBlock: aBlock
		  onComplete: aJSString
		  id: nil
]

{ #category : #'instance creation' }
CPPSPanelSwitcherButton class >> text: aString tooltip: aTranslatedString panelId: anId actionBlock: aBlock onComplete: aJSString id: anIdBis [

	^ self new
		  text: aString;
		  id: anIdBis;
		  tooltip: aTranslatedString;
		  panelId: anId;
		  actionBlock: aBlock;
		  onCompleteJs: aJSString;
		  yourself
]

{ #category : #accessing }
CPPSPanelSwitcherButton >> actionBlock [

	^ actionBlock
]

{ #category : #accessing }
CPPSPanelSwitcherButton >> actionBlock: anObject [

	actionBlock := anObject
]

{ #category : #accessing }
CPPSPanelSwitcherButton >> id [

	^ id
]

{ #category : #accessing }
CPPSPanelSwitcherButton >> id: anObject [

	id := anObject
]

{ #category : #accessing }
CPPSPanelSwitcherButton >> isSelected [

	^ isSelected ifNil: [ isSelected := false ]
]

{ #category : #accessing }
CPPSPanelSwitcherButton >> isSelected: aBoolean [

	isSelected := aBoolean
]

{ #category : #rendering }
CPPSPanelSwitcherButton >> onCompleteJs [

	^ onCompleteJs
]

{ #category : #accessing }
CPPSPanelSwitcherButton >> onCompleteJs: anObject [

	onCompleteJs := anObject
]

{ #category : #accessing }
CPPSPanelSwitcherButton >> owner [

	^ owner
]

{ #category : #accessing }
CPPSPanelSwitcherButton >> owner: aMDLVerticalToolbar [

	owner := aMDLVerticalToolbar
]

{ #category : #accessing }
CPPSPanelSwitcherButton >> panelId [

	^ panelId
]

{ #category : #accessing }
CPPSPanelSwitcherButton >> panelId: anObject [

	panelId := anObject
]

{ #category : #rendering }
CPPSPanelSwitcherButton >> renderContentOn: html [

	html div
		class: #'panel-switcher-button';
		id: self id;
		with:
			[ html div
				id: html nextId;
				class: #'panel-switcher-button__content';
				class: #'panel-switcher-selected'
				if: self isSelected;
				onClick: '$(".panel-switcher-selected").removeClass("panel-switcher-selected"); $(this).addClass("panel-switcher-selected")' js , ((html jQuery id: self panelId) load
							 html:
								 [ :r | 
								 self owner resetButtonSelection.
								 self select.
								 self actionBlock value: r
								 ];
							 onComplete: self onCompleteJs);
				with: self text
			].
	self tooltip ifNotNil:
		[ :t | 
		html
			mdlLargeTooltipFor: html lastId
			with: t
		]
]

{ #category : #accessing }
CPPSPanelSwitcherButton >> select [

	self isSelected: true
]

{ #category : #accessing }
CPPSPanelSwitcherButton >> text [

	^ text
]

{ #category : #accessing }
CPPSPanelSwitcherButton >> text: anObject [

	text := anObject
]

{ #category : #accessing }
CPPSPanelSwitcherButton >> tooltip [

	^ tooltip
]

{ #category : #accessing }
CPPSPanelSwitcherButton >> tooltip: anObject [

	tooltip := anObject
]
