"
Description
----------------

I am a concret component allowing the user to create a query to filter his current result. 

The filter can, for example, be to reject all the entities with less than 10 lines of code.
 
"
Class {
	#name : #CPPSQueryNumericFilterComponent,
	#superclass : #CPPSQueryFilterComponent,
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #accessing }
CPPSQueryNumericFilterComponent class >> englishName [

	^ 'Numeric properties filter'
]

{ #category : #accessing }
CPPSQueryNumericFilterComponent class >> frenchName [

	^ 'Filtre de propriétées numériques'
]

{ #category : #accessing }
CPPSQueryNumericFilterComponent class >> priority [

	^ 10
]

{ #category : #accessing }
CPPSQueryNumericFilterComponent >> modelClass [

	^ FQNumericQuery
]

{ #category : #rendering }
CPPSQueryNumericFilterComponent >> renderComparaisonValueFieldOn: html [

	html render: ((MDLTextFieldWidget
			  labeled: (self
					   english: 'Value'
					   french: 'Valeur')
			  callback:
				  [ :value | 
				  self query comparisonValue: ([ value asNumber ]
							   on: Error
							   do: [ nil ])
				  ]
			  floatingLabel: true)
			 value: self query comparisonValue;
			 type: 'number';
			 yourself)
]
