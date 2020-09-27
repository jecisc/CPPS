Class {
	#name : #CPPSTLEntitiesFiltersComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'visu'
	],
	#category : #'CPPS-Toolkit-CodeAnalyzer-RightPanels'
}

{ #category : #rendering }
CPPSTLEntitiesFiltersComponent >> filterVisualizationWith: filter [

	"I get a filter with which I should filter the block and method visualization."

	self
		execute:
			[ "Set the filter to the visu"
			visu filter: filter.

			"In case a filter is already activated, re-show all nodes before filtering them again."
			visu obtain recursively nodes do: #show.

			"Filter all open nodes"
			self manageVisibilityOf: visu obtain groupRecursively visibles nodes.

			"Update the visualization via the websocket"
			visu update
			]
		recordedAs: 'Filter visu with: ' , filter
]

{ #category : #javascript }
CPPSTLEntitiesFiltersComponent >> jsActivateSpinnerOnChangeOn: html [

	"When the search input change, activate a spinner"

	html script: '$("#' , html lastId , '").change(function () { $("#search-spinner").addClass("is-active");  });'
]

{ #category : #rendering }
CPPSTLEntitiesFiltersComponent >> manageVisibilityOf: nodes [

	| nodesToShow nodesToHide |

	"Get all the nodes matching the filter"
	nodesToShow := nodes reject: [ :n | visu shouldHideWithFilterNode: n ].
	(String streamContents:
		 [ :s | 
		 s nextPutAll: 'Entities matching: '.
		 nodesToShow
			 do: [ :e | s nextPutAll: e entity mooseName ]
			 separatedBy: [ s nextPutAll: ' - ' ]
		 ]) record.

	"Hide the nodes not matching the filter"
	(nodesToHide := nodes \ nodesToShow) do: #hide.
	(String streamContents:
		 [ :s | 
		 s nextPutAll: 'Entities not matching: '.
		 nodesToHide
			 do: [ :e | s nextPutAll: e entity mooseName ]
			 separatedBy: [ s nextPutAll: ' - ' ]
		 ]) record.

	"Repeat the operation on the visible children"
	(nodesToShow flatCollect: [ :node | node childrenNodes select: #isVisible ]) ifNotEmpty: [ :visibleChildren | self manageVisibilityOf: visibleChildren ]
]

{ #category : #rendering }
CPPSTLEntitiesFiltersComponent >> renderContentOn: html [

	html div
		class: 'search';
		with:
			[ html mdlTextFieldContainer
				expandable;
				with:
					[ html mdlButton
						labelIcon;
						id: self searchIconId;
						for: html nextId;
						with: [ html mdlIcon: 'search' ].
					html mdlTextFieldExpandableHolder:
						[ html mdlTextFieldInput
							id: html lastId;
							value: visu filter;
							onChange: (html jQuery ajax
									 callback: [ :filter | self filterVisualizationWith: filter ]
									 value: 'event.target.value' js;
									 onComplete: '$("#search-spinner").removeClass("is-active");').
						html mdlTextFieldLabel
							for: html lastId;
							with: 'Filter'
						]
					].
			self renderHelpOn: html.
			html mdlSpinner
				id: 'search-spinner';
				singleColor.
			self jsActivateSpinnerOnChangeOn: html
			]
]

{ #category : #rendering }
CPPSTLEntitiesFiltersComponent >> renderHelpOn: html [

	html
		mdlLargeTooltipFor: self searchIconId
		with:
			[ html heading
				level6;
				with: 'Block and Method filter'.
			html text: 'This search input allow to filter the block and method visualization. It will hide all node who do not contains the given input.'
			]
]

{ #category : #rendering }
CPPSTLEntitiesFiltersComponent >> searchIconId [

	^ 'block-search-icon'
]

{ #category : #accessing }
CPPSTLEntitiesFiltersComponent >> visuId: anId [

	visu := TLCytoscapeWebSocketDelegate visualizationWithId: anId
]
