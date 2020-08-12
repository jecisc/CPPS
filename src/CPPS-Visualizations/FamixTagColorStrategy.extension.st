Extension { #name : #FamixTagColorStrategy }

{ #category : #'*CPPS-Visualizations' }
FamixTagColorStrategy >> addBackgroundLegendToVisualization: aTLVisualization [

	| tags |

	aTLVisualization legend
		backgroundDescription:
			[ :entity | 
			tags := entity tags.
			tags size = 1
				ifTrue: [ 'Tag: ' , tags first name ]
				ifFalse: [ 'Multiple tags' ]
			]
		forNodes: [ aTLVisualization obtain recursively nodesSelect: [ :each | each entity isTagged ] ]
]

{ #category : #'*CPPS-Visualizations' }
FamixTagColorStrategy >> addBorderLegendToVisualization: aTLVisualization [

	| tags |

	aTLVisualization legend
		borderColorDescription:
			[ :entity | 
			tags := entity tags.
			tags size = 1
				ifTrue: [ 'Tag: ' , tags first name ]
				ifFalse: [ 'Multiple tags' ]
			]
		forNodes: [ aTLVisualization obtain recursively nodesSelect: [ :each | each entity isTagged ] ]
]
