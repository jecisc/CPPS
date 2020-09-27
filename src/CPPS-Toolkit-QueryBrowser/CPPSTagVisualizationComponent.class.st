Class {
	#name : #CPPSTagVisualizationComponent,
	#superclass : #CPPSTagBrowserComponent,
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #rendering }
CPPSTagVisualizationComponent >> renderContentOn: html [

	html render: ((TLCytoscapeComponent visualization: (CPPSTagVisualization
					   tags: { self tag }
					   model: self model))
			 withPNGExport;
			 yourself).

	"The following script is used to init the tag visualization when the user change of tab because it uses ajax. We add a condition because the first time the document might not be ready but we don't care because the visu will be loaded anyway."
	html script: 'if(document.readyState == "complete"){telescope.loadVisuIn(document)}'
]
