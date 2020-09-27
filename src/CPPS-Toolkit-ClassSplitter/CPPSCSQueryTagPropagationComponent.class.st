Class {
	#name : #CPPSCSQueryTagPropagationComponent,
	#superclass : #CPPSCSAbstractTagPropagationComponent,
	#instVars : [
		'query'
	],
	#category : #'CPPS-Toolkit-ClassSplitter'
}

{ #category : #accessing }
CPPSCSQueryTagPropagationComponent >> description [

	self flag: #todo.
	"Translate the description to french"
	^ 'I allow one to automatize the propagation of tags in the current visualization. The query will be applied on the elements of the visualization. When executed, I will tag every containers matching the selected query.'
]

{ #category : #rendering }
CPPSCSQueryTagPropagationComponent >> renderFormContentOn: html [

	html render: (MDLSelectWidget
			 possibilities: self queries
			 inputLabel: 'Select a query'
			 labelBlock: #name
			 callback: [ :input | query := input ]
			 selectedObject: query)
]

{ #category : #rendering }
CPPSCSQueryTagPropagationComponent >> renderFormOn: html [

	self queries
		ifEmpty:
			[ html mdlAlert
				beWarning;
				with:
					[ html strong: 'No saved query.'.
					html break.
					html text: 'To use this feature you need at least one saved query. You can create and save queries from the Query Browser.'
					]
			]
		ifNotEmpty: [ super renderFormOn: html ]
]

{ #category : #accessing }
CPPSCSQueryTagPropagationComponent >> tagsToPropagate [

	^ self currentTag
		  ifNil:
			  [ feedback := 'No tag selected'.
			  nil
			  ]
		  ifNotNil:
			  [ :currentTag | 
			  | tagsToPropagate |

			  tagsToPropagate := Dictionary new.
			  query ifNotNil:
				  [ (query runOn: self visualization entitiesToShow asMooseGroup) do:
					  [ :entity | 
					  (entity isTaggedWith: currentTag) ifFalse:
						  [ tagsToPropagate
							  at: entity
							  put: { currentTag }
						  ]
					  ]
				  ].
			  tagsToPropagate
			  ]
]

{ #category : #accessing }
CPPSCSQueryTagPropagationComponent >> title [

	^ self
		  english: 'Query tag propagation'
		  french: 'Propagation de tags par requête'
]
