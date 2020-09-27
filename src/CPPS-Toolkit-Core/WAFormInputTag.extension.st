Extension { #name : #WAFormInputTag }

{ #category : #'*CPPS-Toolkit-Core' }
WAFormInputTag >> noAutocomplete [

	self attributes
		at: 'autocomplete'
		put: 'off'
]
