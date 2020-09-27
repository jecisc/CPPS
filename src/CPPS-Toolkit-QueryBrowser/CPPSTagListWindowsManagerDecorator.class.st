Class {
	#name : #CPPSTagListWindowsManagerDecorator,
	#superclass : #CPPSTagListComponentAbstract,
	#instVars : [
		'tools',
		'lastTool',
		'tagListComponent'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #accessing }
CPPSTagListWindowsManagerDecorator class >> tagList: aTagListComponent [

	^ self new
		  tagListComponent: aTagListComponent;
		  elements: aTagListComponent elements;
		  addTool;
		  yourself
]

{ #category : #'instance creation' }
CPPSTagListWindowsManagerDecorator class >> tags: tagBlock actionBlock: actionBlock actionTooltipBlock: tooltip actionLabelBlock: label [

	^ self new
		  elements: tagBlock;
		  tagListComponent: ((CPPSTagListComponent
				    tags: tagBlock
				    actionBlock: actionBlock
				    actionTooltipBlock: tooltip
				    actionLabelBlock: label)
				   refreshAllComponent;
				   yourself);
		  yourself
]

{ #category : #adding }
CPPSTagListWindowsManagerDecorator >> addCreateTagButton [

	self lastTool: ((CPPSTagListCreateTagDecorator tagList: self lastTool) launchSyncOn: self)
]

{ #category : #adding }
CPPSTagListWindowsManagerDecorator >> addTagFilter [

	self lastTool: (CPPSTagListTagFilterDecorator tagList: self lastTool)
]

{ #category : #adding }
CPPSTagListWindowsManagerDecorator >> addTextFilter [

	self lastTool: (CPPSTagListTextFilterDecorator tagList: self lastTool)
]

{ #category : #adding }
CPPSTagListWindowsManagerDecorator >> addTool: aComponent [

	tools add: aComponent
]

{ #category : #adding }
CPPSTagListWindowsManagerDecorator >> elementsToDisplay: elementsCollection [

	self tagListComponent elements: elementsCollection
]

{ #category : #initialization }
CPPSTagListWindowsManagerDecorator >> initialize [

	super initialize.
	tools := OrderedCollection new.
	self lastTool: self
]

{ #category : #adding }
CPPSTagListWindowsManagerDecorator >> lastTool [

	^ lastTool
]

{ #category : #adding }
CPPSTagListWindowsManagerDecorator >> lastTool: aTagListTool [

	lastTool := aTagListTool
]

{ #category : #rendering }
CPPSTagListWindowsManagerDecorator >> renderContentOn: html [

	self synchElements.
	html div
		id: #'tag-list-decorator';
		with: [ self renderTagListOn: html ]
]

{ #category : #adding }
CPPSTagListWindowsManagerDecorator >> renderOnlyListOn: html [

	self tagListComponent renderContentOn: html
]

{ #category : #rendering }
CPPSTagListWindowsManagerDecorator >> renderTagListOn: html [

	html div
		id: 'toolTagList';
		with: [ self tools do: [ :tool | html render: tool ] ].
	html div
		id: 'tagListContainer';
		with: [ html render: self tagListComponent ]
]

{ #category : #adding }
CPPSTagListWindowsManagerDecorator >> synchElements [

	self lastTool elementsToDisplay: self elements value
]

{ #category : #accessing }
CPPSTagListWindowsManagerDecorator >> tagListComponent [

	^ tagListComponent
]

{ #category : #accessing }
CPPSTagListWindowsManagerDecorator >> tagListComponent: aTagListComponent [

	tagListComponent := aTagListComponent
]

{ #category : #adding }
CPPSTagListWindowsManagerDecorator >> tools [

	^ tools
]
