Class {
	#name : #CPPSQueryStringFilterComponent,
	#superclass : #CPPSQueryFilterComponent,
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #accessing }
CPPSQueryStringFilterComponent class >> englishName [

	^ 'String properties filter'
]

{ #category : #accessing }
CPPSQueryStringFilterComponent class >> frenchName [

	^ 'Filtre de propriétées textuelles'
]

{ #category : #accessing }
CPPSQueryStringFilterComponent class >> priority [

	^ 30
]

{ #category : #accessing }
CPPSQueryStringFilterComponent >> modelClass [

	^ FQStringQuery
]

{ #category : #rendering }
CPPSQueryStringFilterComponent >> renderComparaisonValueFieldOn: html [

	html render: ((MDLTextFieldWidget
			  labeled: (self
					   english: 'Value'
					   french: 'Valeur')
			  callback: [ :value | self query comparisonValue: value ]
			  floatingLabel: true)
			 value: self query comparisonValue;
			 yourself)
]
