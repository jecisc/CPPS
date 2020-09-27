Extension { #name : #WATagBrush }

{ #category : #'*CPPS-Toolkit-Core' }
WATagBrush >> beCentered [

	self class: 'text-center'
]

{ #category : #'*CPPS-Toolkit-Core' }
WATagBrush >> beGrowing [
	self class: #growing
]

{ #category : #'*CPPS-Toolkit-Core' }
WATagBrush >> formControl [

	self class: #'form-control'
]

{ #category : #'*CPPS-Toolkit-Core' }
WATagBrush >> marginAuto [

	self class: 'auto-margin'
]

{ #category : #'*CPPS-Toolkit-Core' }
WATagBrush >> paddedForm [
	self class: #paddedForm
]

{ #category : #'*CPPS-Toolkit-Core' }
WATagBrush >> pullLeft [

	self class: 'pull-left'
]

{ #category : #'*CPPS-Toolkit-Core' }
WATagBrush >> pullRight [

	self class: 'pull-right'
]

{ #category : #'*CPPS-Toolkit-Core' }
WATagBrush >> style: aString if: aBoolean [

	aBoolean ifTrue: [ self style: aString value ]
]
