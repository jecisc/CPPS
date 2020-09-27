Extension { #name : #MDLBadge }

{ #category : #'*CPPS-Toolkit-Core' }
MDLBadge >> adaptTo: number [

	self
		class: #'mdl-badge-small'
		if: number size < 3;
		class: #'mdl-badge-medium'
		if: (number size
				 between: 3
				 and: 4);
		class: #'mdl-badge-large'
		if: number size > 4
]
