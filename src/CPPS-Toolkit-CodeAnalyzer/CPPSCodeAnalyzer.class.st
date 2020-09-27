"
Description
------------------
The CodeAnalyzer is a browser that display a list of entity and alloz the user to get informations on them. 

For each entity he can get:
- Some properties (cyclomatique complexity, if the entity is dead…)
- The entities that invoke the selected entity
- The entities invoked by the selected entity
- The source code of the entity
- A visualisation of the entity with his links to other ertities

I should be dislay by the root component.

Internal Representation and Key Implementation Points.
------------------

    Instance Variables
	codeAndVisualizationComponent:		<aComponent>	A component to display the code and overview of the selected entity
	filterComponent:						<aComponent> 	A component to manage some filter on the list of entities
	invocationsComponent:					<aComponent>	A component to display the list of invocations of the selected entity
	propertiesComponent:					<aComponent> 	A component to display the properties of the selected entity
	selectedEntity:							<anEntity>	 	The currently selected entity
	tree:									<aComponent>  	A component to display the list of filtered entities of the project
"
Class {
	#name : #CPPSCodeAnalyzer,
	#superclass : #CPPSAbstractBrowser,
	#traits : 'TRightTabsPanelBrowser + TFilterBrowser',
	#classTraits : 'TRightTabsPanelBrowser classTrait + TFilterBrowser classTrait',
	#instVars : [
		'codeAndVisualizationComponent',
		'rightPanel',
		'toolbar',
		'announcer'
	],
	#category : #'CPPS-Toolkit-CodeAnalyzer-Core'
}

{ #category : #accessing }
CPPSCodeAnalyzer class >> browserName [

	^ 'Code Analyzer' french: 'Analyseur de Code'
]

{ #category : #testing }
CPPSCodeAnalyzer class >> isReleventFor: selectionOrEntity [

	^ selectionOrEntity isCollection
]

{ #category : #accessing }
CPPSCodeAnalyzer class >> priority [

	^ 100
]

{ #category : #accessing }
CPPSCodeAnalyzer >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
CPPSCodeAnalyzer >> browserClass [

	^ #'code-analyzer'
]

{ #category : #hooks }
CPPSCodeAnalyzer >> children [

	"I don't put the tree here because the filters update it with ajax and I don't know why but the states restore his content on F5 :("

	^ Array
		  with: self filterComponent
		  with: self codeAndVisualizationComponent
		  with: self rightPanel
		  with: self toolbar "
		with: self tree"
]

{ #category : #accessing }
CPPSCodeAnalyzer >> codeAndVisualizationComponent [

	^ codeAndVisualizationComponent
]

{ #category : #accessing }
CPPSCodeAnalyzer >> codeAndVisualizationComponent: anObject [

	codeAndVisualizationComponent := anObject
]

{ #category : #initialization }
CPPSCodeAnalyzer >> defaultCodeAndVisualizationComponent [

	^ CPPSEntityCentricComponent owner: self
]

{ #category : #components }
CPPSCodeAnalyzer >> defaultToolbar [

	^ MDLVerticalToolbar buttons: { ((MDLFoldButton for: '#' , self rightPanelId)
			   resetVisusOnFold;
			   yourself) }
]

{ #category : #initialization }
CPPSCodeAnalyzer >> initialize [

	super initialize.
	self codeAndVisualizationComponent: self defaultCodeAndVisualizationComponent.
	self initializeFilterBrowser.
	self initializeRightPanel
]

{ #category : #selection }
CPPSCodeAnalyzer >> onEntity: anEntity [

	"we restore the filters to be sure entity is part of it"

	self selection: { anEntity }
]

{ #category : #rendering }
CPPSCodeAnalyzer >> renderBrowserContentOn: html [

	html div
		class: #'code-container';
		class: self browserClass , '-content';
		with: [ html render: self codeAndVisualizationComponent ].
	self renderRightPanelOn: html.
	self
		bindNestedListKeysOfId: self filterBrowserTreeId
		on: html
]

{ #category : #accessing }
CPPSCodeAnalyzer >> rightPanel [

	^ rightPanel
]

{ #category : #accessing }
CPPSCodeAnalyzer >> rightPanel: aComponent [

	rightPanel := aComponent
]

{ #category : #accessing }
CPPSCodeAnalyzer >> selectedEntity: anEntity [

	self tree selectedEntity == anEntity ifTrue: [ ^ self ].
	self tree selectedEntity: anEntity.
	self announcer announce: (CPPSCodeAnalyzerEntityUpdated newEntity: anEntity)
]

{ #category : #selection }
CPPSCodeAnalyzer >> selection: aCollectionOfEntities [

	self filterComponent filterOnSelection: aCollectionOfEntities.
	self selectedEntity: aCollectionOfEntities first
]

{ #category : #initialization }
CPPSCodeAnalyzer >> setDefaultRightPanel [

	self rightPanel: (CPPSCodeAnalyzerInformationRightPanel owner: self)
]

{ #category : #accessing }
CPPSCodeAnalyzer >> toolbar [

	^ toolbar
]

{ #category : #accessing }
CPPSCodeAnalyzer >> toolbar: aComponent [

	toolbar := aComponent
]
