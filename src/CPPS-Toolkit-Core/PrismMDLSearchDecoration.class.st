Class {
	#name : #PrismMDLSearchDecoration,
	#superclass : #PrismSearchDecoration,
	#category : #'CPPS-Toolkit-Core-Decorator'
}

{ #category : #hook }
PrismMDLSearchDecoration >> hookClass [

	^ 'mdl-shadow--2dp'
]

{ #category : #rendering }
PrismMDLSearchDecoration >> renderSearchBarOn: html [

	html mdlTextFieldContainer
		class: #compact;
		onChange: (self jsOnTextChangeOn: html);
		with:
			[ html mdlTextFieldLabel
				for: html nextId;
				with: 'Search'.
			html mdlTextFieldInput
				id: html lastId;
				attributeAt: 'placeholder'
				put: 'Prism\.?languages\.?javascript';
				attributeAt: 'autocomplete'
				put: #off;
				type: 'text'
			].
	html mdlButton icon: #search.
	html mdlButton
		class: 'search-button';
		onClick: self jsOnClickPreviousElement;
		icon: #keyboard_arrow_up.
	html mdlButton
		class: 'search-button';
		onClick: self jsOnClickNextElement;
		icon: #keyboard_arrow_down.
	self renderCounterOn: html
]
