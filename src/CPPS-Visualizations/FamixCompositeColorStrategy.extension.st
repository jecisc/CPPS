Extension { #name : #FamixCompositeColorStrategy }

{ #category : #'*CPPS-Visualizations' }
FamixCompositeColorStrategy >> addBackgroundLegendToVisualization: aTLVisualization [

	self strategies do: [ :s | s addBackgroundLegendToVisualization: aTLVisualization ]
]

{ #category : #'*CPPS-Visualizations' }
FamixCompositeColorStrategy >> addBorderLegendToVisualization: aTLVisualization [

	self strategies do: [ :s | s addBorderLegendToVisualization: aTLVisualization ]
]
