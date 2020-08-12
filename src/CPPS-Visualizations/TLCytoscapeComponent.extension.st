Extension { #name : #TLCytoscapeComponent }

{ #category : #'*CPPS-Visualizations' }
TLCytoscapeComponent >> withPNGExport [

	self exportStrategy: (TLCytoscapePngExportStrategy new
			 maxHeight: 800;
			 maxWidth: 1900;
			 yourself)
]
