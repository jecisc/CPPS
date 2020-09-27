Extension { #name : #MAExternalFileModel }

{ #category : #'*CPPS-Toolkit-Magritte' }
MAExternalFileModel >> directoryFileName [

	^ self directory pathString
]

{ #category : #'*CPPS-Toolkit-Magritte' }
MAExternalFileModel >> directoryFileName: aString [

	directory := aString asFileReference
]

{ #category : #'*CPPS-Toolkit-Magritte' }
MAExternalFileModel >> directoryFileNameDescription [

	<magritteDescription>
	^ MAStringDescription new
		  accessor: #directoryFileName;
		  label: 'Directory file name';
		  yourself
]
