Class {
	#name : #CPPSEditCorrelationRightPanel,
	#superclass : #CPPSCorrelationEditorRightPanel,
	#category : #'CPPS-Toolkit-QueryBrowser-Correlation'
}

{ #category : #accessing }
CPPSEditCorrelationRightPanel >> correlation [

	^ self selectedCorrelation
]

{ #category : #rendering }
CPPSEditCorrelationRightPanel >> renderButtonsOn: html [

	html mdlMajorButton: (self
			 english: 'Edit'
			 french: 'Éditer').
	html mdlMajorButton
		bePush;
		beDanger;
		openDialogWithId: self rootDialogOpenId;
		onClickUpdateRootDialogWith: [ :r | self renderDeleteConfirmationDialogOn: r ];
		with: (self
				 english: 'Delete'
				 french: 'Supprimer')
]

{ #category : #rendering }
CPPSEditCorrelationRightPanel >> renderContentOn: html [

	self owner
		render: [ super renderContentOn: html ]
		ifCorrelationPresentOn: html
]

{ #category : #rendering }
CPPSEditCorrelationRightPanel >> renderDeleteConfirmationDialogOn: html [

	html mdlDialogTitle: (self
			 english: 'Delete correlation'
			 french: 'Supprimer la correlation').
	html mdlDialogContent: (self
			 english: 'Are you sur you wish to delete the correlation?'
			 french: 'Êtes vous sûr de vouloir supprimer la correlation ?').
	html mdlDialogActions:
		[ html mdlMajorAnchorButton
			beDanger;
			callback:
				[ self correlationsStorage remove: self correlation.
				self owner selectedCorrelation: nil
				];
			with: (self
					 english: 'Delete correlation'
					 french: 'Supprimer la correlation').
		html mdlButton
			bePush;
			id: self rootDialogCloseId;
			with: (self
					 english: 'Cancel'
					 french: 'Annuler')
		]
]
