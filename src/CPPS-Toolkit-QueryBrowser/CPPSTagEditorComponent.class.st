"
Description
-------------------

I am a component to edit tags

I am pretty close to the CPPSTagCreatorComponent but I edit the tag instead of creating it.

Maybe there is a way to remove some duplication between the tags but no time for now.
"
Class {
	#name : #CPPSTagEditorComponent,
	#superclass : #CPPSTagBrowserComponent,
	#instVars : [
		'categoryComponent'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #accessing }
CPPSTagEditorComponent >> categoryComponent [

	^ categoryComponent
]

{ #category : #accessing }
CPPSTagEditorComponent >> categoryComponent: anObject [

	categoryComponent := anObject
]

{ #category : #components }
CPPSTagEditorComponent >> defaultCategoriesComponent [

	^ CPPSCategoriesEditorComponent
		  categories: [ self tag categories ]
		  addCategoryBlock: [ :cat | self tag addCategory: cat ]
		  removeCategoryBlock: [ :cat | self tag removeCategory: cat ]
]

{ #category : #initialization }
CPPSTagEditorComponent >> initialize [

	super initialize.
	self categoryComponent: self defaultCategoriesComponent
]

{ #category : #rendering }
CPPSTagEditorComponent >> renderColorPickerOn: html [

	| id |

	id := html nextId.
	html colorInput
		callback: [ :color | self tag color: (Color fromHexString: color allButFirst) ];
		value: '#' , self tag color asHexString;
		id: id.
	html label
		for: id;
		class: #label;
		with: (self
				 english: 'Choose a color'
				 french: 'Selectionnez une couleur').
	html break
]

{ #category : #rendering }
CPPSTagEditorComponent >> renderComponentOn: html [

	html div
		class: #form;
		style: 'text-align: center;';
		with:
			[ html render: self categoryComponent.
			html form
				style: 'padding-top: 0;';
				with: [ self renderFormOn: html ]
			]
]

{ #category : #rendering }
CPPSTagEditorComponent >> renderDescriptionInputOn: html [

	html mdlTextFieldContainer:
		[ | id |

		id := html nextId.
		html mdlTextArea
			rows: 2;
			callback: [ :description | self tag description = description ifFalse: [ self tag description: description ] ];
			value: self tag description;
			id: id.
		html mdlTextFieldLabel
			for: id;
			with: 'Description'
		].
	html break
]

{ #category : #rendering }
CPPSTagEditorComponent >> renderFormOn: html [
	self
		renderTagParentOn: html;
		renderTagNameInputOn: html;
		renderDescriptionInputOn: html;
		renderColorPickerOn: html.
	html mdlSubmitButton: (self translate: ('Save' french: 'Sauver'))
]

{ #category : #rendering }
CPPSTagEditorComponent >> renderTagNameInputOn: html [

	html render: ((MDLTextFieldWidget
			  labeled: (self
					   english: 'Tag name'
					   french: 'Nom du tag')
			  callback: [ :name | self tag name = name ifFalse: [ self tag name: (name ifEmpty: [ 'unnamed' ]) ] ]
			  floatingLabel: true)
			 style: 'top: 20px;';
			 value: self tag name;
			 yourself).
	html break
]

{ #category : #rendering }
CPPSTagEditorComponent >> renderTagParentOn: html [

	html
		break;
		render: ((MDLSelectWidget
				  possibilities: (((self tagModel tags copyWithout: self tag) asOrderedCollection sorted: #name ascending)
						   addFirst: nil;
						   yourself)
				  inputLabel: (self
						   english: 'Select parent tag'
						   french: 'Sélectionnez le tag parent')
				  labelBlock:
					  [ :tag | 
					  tag
						  ifNil:
							  [ self
								  english: 'No parent (default)'
								  french: 'Pas de parent (default)'
							  ]
						  ifNotNil: [ tag name ]
					  ]
				  callback:
					  [ :tag | 
					  tag = self tag parentTag ifFalse:
						  [ tag
							  ifNil: [ self tag promoteAsRoot ]
							  ifNotNil: [ self tag changeParentTagTo: tag ]
						  ]
					  ]
				  selectedObject: self tag parentTag
				  tooltip: (self
						   english: 'A tag can be a composite tag and contain other tags. If your new tag should be into a composite tag you can select it here.'
						   french: 'Un tag peut être un tag composite et contenir d''autres tags. Si votre nouveau tag devrait être à l''intérieur d''un tag composite vous avez la possibilité de le selectionner ici.')
				  sortBlock: [ :a :b | (a value isNil or: [ b value isNotNil ]) or: [ a <= b ] ])
				 entryTooltip: [ :tag | tag ifNotNil: #mooseName ];
				 yourself);
		break
]

{ #category : #accessing }
CPPSTagEditorComponent >> title [

	^ self
		  english: 'Edit your tag'
		  french: 'Étitez votre tag'
]
