"
Description
--------------------

I am a component whose responsibility is to allow the user to select entities to show for a browser. 

I contains a sub component. The sub components allow to get different type of selection. For example sfe CPPSFilterComponent allow the use to toggle some filters. The CPPSProjectNavigationComponent show the entities of the project hierarchically.

Public API and Key Messages
--------------------

- #filterOnSelection: 		Allow to force the CPPSFilterComponent on a selection

Examples
--------------------

	CPPSNavigationComponent
		actionOnUpdate: [ :entities | 
			self tree elements: entities.
			entities isNotEmpty
				ifTrue: [ self selectedEntity: entities first ] ]
		idOfImpactedList: #'code-analyzer-tree'
		ajaxBlock: [ :html | self renderTreeOn: html ]
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	actionOnUpdate:			<aBlock>		A block to execute to update the list of entities when the user interact.
	ajaxBlock:					<aBlock>		A block to execute if there is no need to refresh the page but there is a need to refresh a div.
	idOfImpactedList:			<aSymbol>		Id of the div to refresh with the #ajaxBlock.
	subComponent:				<aComponent>	The subComponent to display.

"
Class {
	#name : #CPPSNavigationComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'subComponent',
		'actionOnUpdate',
		'ajaxBlock',
		'idOfImpactedList',
		'possibleSubComponents'
	],
	#category : #'CPPS-Toolkit-Core-Filters'
}

{ #category : #'instance creation' }
CPPSNavigationComponent class >> actionOnUpdate: aBlock idOfImpactedList: anId ajaxBlock: aBlock2 [

	^ self basicNew
		  actionOnUpdate: aBlock;
		  idOfImpactedList: anId;
		  ajaxBlock: aBlock2;
		  initialize;
		  yourself
]

{ #category : #accessing }
CPPSNavigationComponent >> actionOnUpdate [

	^ actionOnUpdate
]

{ #category : #accessing }
CPPSNavigationComponent >> actionOnUpdate: anObject [

	actionOnUpdate := anObject
]

{ #category : #accessing }
CPPSNavigationComponent >> ajaxBlock [

	^ ajaxBlock
]

{ #category : #accessing }
CPPSNavigationComponent >> ajaxBlock: anObject [

	ajaxBlock := anObject
]

{ #category : #accessing }
CPPSNavigationComponent >> filterOnSelection: aMooseGroup [

	"I force the subComponent to be a FiltersComponent and I set a selection to it."

	self subComponent: ((CPPSFiltersComponent owner: self)
			 removeAllActiveFilters;
			 addSelectiveFilter: aMooseGroup;
			 yourself)
]

{ #category : #accessing }
CPPSNavigationComponent >> id [

	"For now this is not a variable since we have only one in the page."

	^ #'filter-component'
]

{ #category : #accessing }
CPPSNavigationComponent >> idOfImpactedList [

	^ idOfImpactedList
]

{ #category : #accessing }
CPPSNavigationComponent >> idOfImpactedList: anObject [

	idOfImpactedList := anObject
]

{ #category : #accessing }
CPPSNavigationComponent >> possibleSubComponents [

	^ possibleSubComponents ifNil:
		  [ possibleSubComponents := { 
			                           CPPSFiltersComponent.
			                           CPPSProjectNavigationComponent }
		  ]
]

{ #category : #accessing }
CPPSNavigationComponent >> possibleSubComponents: aCollection [

	possibleSubComponents := aCollection
]

{ #category : #rendering }
CPPSNavigationComponent >> renderComponentOn: html [

	html div
		class: 'title';
		with:
			[ "The menu widget is not used anymore but it should be part of a future refactoring of this component. If next year (currently may 2017) it is still not done just replace this widget by label with the needed css."
			html render: (MDLMenuButtonWidget new
						 action: [ :class | self subComponent: (class owner: self) ];
						 objectsPossibilities: self possibleSubComponents;
						 choosingText: (self translate: self subComponent title);
						 textBlock: [ :class | self translate: class title ];
						 selectedObject: self subComponent class;
						 yourself)
			].
	html div: [ html render: self subComponent ]
]

{ #category : #rendering }
CPPSNavigationComponent >> renderContentOn: html [

	html div
		class: self id;
		id: self id;
		shadow: 2;
		with: [ self renderComponentOn: html ]
]

{ #category : #accessing }
CPPSNavigationComponent >> subComponent [

	^ subComponent ifNil: [ subComponent := self possibleSubComponents anyOne owner: self ]
]

{ #category : #accessing }
CPPSNavigationComponent >> subComponent: anObject [

	subComponent := anObject
]
