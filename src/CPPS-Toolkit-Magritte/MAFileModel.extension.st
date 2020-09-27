Extension { #name : #MAFileModel }

{ #category : #'*CPPS-Toolkit-Magritte' }
MAFileModel >> filenameDescription [

	<magritteDescription>
	^ MAStringDescription new
		  accessor: #filename;
		  label: 'Filename';
		  yourself
]

{ #category : #'*CPPS-Toolkit-Magritte' }
MAFileModel >> mimetypeDescription [

	<magritteDescription>
	^ MAStringDescription new
		  accessor: #mimetype;
		  label: 'Mimetype';
		  yourself
]
