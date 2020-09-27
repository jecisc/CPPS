"
Description
------------------

I am a simple component to allow the user to easilly create a new tag.


Example
------------------

	CPPSSimpleNewTagComponent
		label: (self english: 'New tag named' french: 'Nouveau tag nommé')
		creationBlock: [ :name | self createTagNamed: name ]
 
Internal Representation and Key Implementation Points.
-----------------

    Instance Variables
	creationBlock:		<aBlock>		aBlock taking as parameter the name of the tag. It will be used to create the tag.
	label:					<aString> 	The label of the component
"
Class {
	#name : #CPPSSimpleNewTagComponent,
	#superclass : #CPPSComponent,
	#instVars : [
		'label',
		'creationBlock'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #'instance creation' }
CPPSSimpleNewTagComponent class >> label: aString creationBlock: aBlock [

	^ self new
		  label: aString;
		  creationBlock: aBlock;
		  yourself
]

{ #category : #accessing }
CPPSSimpleNewTagComponent >> creationBlock [

	^ creationBlock
]

{ #category : #accessing }
CPPSSimpleNewTagComponent >> creationBlock: anObject [

	creationBlock := anObject
]

{ #category : #initialization }
CPPSSimpleNewTagComponent >> initialize [

	self flag: #clean. "
/!\/!\ I WILL BE DELETED AS SOON AS WE FINISH TO REPLACE ME BY BETTER TAG CREATION COMPONENT. DO NOT USE ME PLEASE. /!\/!\"
	super initialize
]

{ #category : #accessing }
CPPSSimpleNewTagComponent >> label [

	^ label
]

{ #category : #accessing }
CPPSSimpleNewTagComponent >> label: anObject [

	label := anObject
]

{ #category : #rendering }
CPPSSimpleNewTagComponent >> renderContentOn: html [

	self flag: #todo. "This component will probably be killed."
	html div
		class: #'new-simple-tag';
		with:
			[ html div:
					[ html form
						id: #'new-simple-tag__form';
						with:
							[ html render: (MDLTextFieldWidget
										 labeled: self label
										 callback: [ :name | self creationBlock value: name ]
										 floatingLabel: true)
							].
					html mdlIcon
						onClick: (html jQuery: '#new-simple-tag__form') submit;
						with: #fiber_new
					]
			]
]
