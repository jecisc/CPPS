Class {
	#name : #CPPSTagListIconComponent,
	#superclass : #CPPSListIconComponent,
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #rendering }
CPPSTagListIconComponent >> renderTagIconOn: html [

	self shouldDisplayTagIcon ifFalse: [ ^ self ].
	html mdlIcon
		class: 'list-tag-icon';
		style: 'color: #' , entityToTag color asHexString;
		id: html nextId;
		with: #label.
	html
		mdlLargeTooltipFor: html lastId
		with: (self
				 translate: 'Tag named: '
				 french: 'Tag nommé : ') , self entityToTag name
]
