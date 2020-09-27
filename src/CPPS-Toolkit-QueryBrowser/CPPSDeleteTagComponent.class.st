"
Description
--------------------

I am a simple component allowing the user to delete a tag.
"
Class {
	#name : #CPPSDeleteTagComponent,
	#superclass : #CPPSTagBrowserComponent,
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #accessing }
CPPSDeleteTagComponent >> buttonLabel [

	^ self tag isComposite
		  ifTrue:
			  [ self
				  english: 'Delete me and children'
				  french: 'Supprimer ainsi que les enfants'
			  ]
		  ifFalse:
			  [ self
				  english: 'Delete'
				  french: 'Supprimer'
			  ]
]

{ #category : #action }
CPPSDeleteTagComponent >> deleteTag [

	(self currentTag == self tag or: [ self tag isAncestorOf: self currentTag ]) ifTrue: [ self currentTag: nil ].
	self removeArchitectureBasedOnTag: self tag.
	self tag removeAndDeleteAssociationsInModel: self model.
	self resetSelection
]

{ #category : #hook }
CPPSDeleteTagComponent >> renderComponentOn: html [

	html render: (MDLCardWidget new
			 shadow: 2;
			 style: 'width: 100%; text-align: center;';
			 title: 'Confirmation';
			 addTextContainer:
				 [ html
					 text: (self
							  english: 'Do you really want to delete '
							  french: 'Voulez vous vraiment supprimer ') , self tag name , '?';
					 break;
					 text: (self
							  english: 'This action cannot be revert.'
							  french: 'Cette action ne peut pas être annulée.');
					 break
				 ];
			 addAction:
				 [ html mdlAnchorButton
					 callback: [ self deleteTag ];
					 accentColor;
					 rippleEffect;
					 with: self buttonLabel
				 ];
			 actionsBordered;
			 yourself)
]

{ #category : #api }
CPPSDeleteTagComponent >> resetSelection [

	self owner selectedTag: nil
]

{ #category : #api }
CPPSDeleteTagComponent >> title [

	^ self
		  english: 'Delete tag'
		  french: 'Suppression le tag'
]
