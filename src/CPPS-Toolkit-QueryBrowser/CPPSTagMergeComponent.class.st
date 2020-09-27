"
Description
-------------------

I am a component to merge two tags.

I will ask to the user a second tag and merge the selected tag with it. 
 
Internal Representation and Key Implementation Points.
-------------------

    Instance Variables
	secondTag:		<aTag>	The tag to merge into the tag to keep.
	tagToKeep:		<aTag>	The tag to keep.

"
Class {
	#name : #CPPSTagMergeComponent,
	#superclass : #CPPSTagBrowserComponent,
	#instVars : [
		'secondTag',
		'tagToKeep'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #actions }
CPPSTagMergeComponent >> merge [

	| tagToDelete |

	tagToDelete := self tagToKeep = self tag
		               ifTrue: [ self secondTag ]
		               ifFalse: [ self tag ].
	self tagToKeep
		mergeWith: tagToDelete
		forModel: self model.
	self owner selectedTag: self tagToKeep.
	self resetVariables
]

{ #category : #rendering }
CPPSTagMergeComponent >> renderComponentOn: html [

	html div
		class: #form;
		style: 'text-align: center;';
		with:
			[ self renderSecondTagListOn: html.
			html form: [ self renderFormOn: html ]
			]
]

{ #category : #rendering }
CPPSTagMergeComponent >> renderFormOn: html [

	self renderTagChoiceOn: html.
	html
		mdlSubmitButton: (self
				 english: 'Merge'
				 french: 'Fusioner')
		callback: [ self merge ]
]

{ #category : #rendering }
CPPSTagMergeComponent >> renderSecondTagListOn: html [

	html
		break;
		render: ((MDLMenuButtonWidget
				  possibilities: (self tagModel allTags asOrderedCollection \ { self tag } sorted: #name ascending)
				  label: [ :tag | tag mooseName ]
				  action: [ :tag | self secondTag: tag ]
				  choosingText: (self
						   english: 'Select a tag to merge with'
						   french: 'Sélectionnez le tag à fusionner'))
				 selectedObject: self secondTag;
				 sortBlock: [ :a :b | (a value isNil or: [ b value isNotNil ]) or: [ a <= b ] ];
				 yourself).
	html break
]

{ #category : #rendering }
CPPSTagMergeComponent >> renderTagChoiceOn: html [

	self secondTag ifNil: [ ^ self ].
	html label
		class: #label;
		with: (self
				 english: 'Select the tag to keep after the merge'
				 french: 'Selectionnez le tag à conserver après la fusion.').
	html radioGroup
		callback: [ :value | self tagToKeep: value ];
		selected: self tag;
		with:
			[ :group | 
			{ 
				self tag.
				self secondTag } do:
					[ :tag | 
					html
						mdlRadioContainerFor: html nextId
						with:
							[ group mdlRadioButton
								id: html lastId;
								value: tag.
							html mdlRadioLabel:
								[ html
									text: tag name;
									space;
									space
								]
							]
					]
			].
	html
		break;
		break
]

{ #category : #initialization }
CPPSTagMergeComponent >> resetVariables [

	self tagToKeep: nil.
	self secondTag: nil
]

{ #category : #accessing }
CPPSTagMergeComponent >> secondTag [

	^ secondTag
]

{ #category : #accessing }
CPPSTagMergeComponent >> secondTag: anObject [

	secondTag := anObject
]

{ #category : #accessing }
CPPSTagMergeComponent >> tagToKeep [

	^ tagToKeep
]

{ #category : #accessing }
CPPSTagMergeComponent >> tagToKeep: anObject [

	tagToKeep := anObject
]

{ #category : #accessing }
CPPSTagMergeComponent >> title [

	^ self
		  english: 'Merge your Tag'
		  french: 'Fusionez votre tag'
]
