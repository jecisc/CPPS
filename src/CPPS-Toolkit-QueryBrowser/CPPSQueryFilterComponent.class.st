Class {
	#name : #CPPSQueryFilterComponent,
	#superclass : #CPPSQueryComponent,
	#category : #'CPPS-Toolkit-QueryBrowser-Core'
}

{ #category : #testing }
CPPSQueryFilterComponent class >> isAbstract [

	^ self = CPPSQueryFilterComponent
]

{ #category : #accessing }
CPPSQueryFilterComponent >> comparators [

	^ self modelClass comparators
]

{ #category : #testing }
CPPSQueryFilterComponent >> isUnavailable [

	^ self possibleProperties isEmpty
]

{ #category : #accessing }
CPPSQueryFilterComponent >> possibleProperties [

	^ (self modelClass availablePropertiesFor: self queryResult) asOrderedCollection sort: #yourself ascending
]

{ #category : #rendering }
CPPSQueryFilterComponent >> propertyDisplayName: aProperty [

	^ (' ' join: (aProperty piecesCutWhereCamelCase collect: #asLowercase)) capitalized
]

{ #category : #rendering }
CPPSQueryFilterComponent >> renderComparaisonValueFieldOn: html [

	self subclassResponsibility
]

{ #category : #rendering }
CPPSQueryFilterComponent >> renderCompratorSelectionOn: html [

	html render: (MDLSelectWidget
			 possibilities: self comparators
			 inputLabel: (self
					  english: 'Comparator'
					  french: 'Comparateur')
			 labelBlock: #label
			 callback: [ :value | self query comparator: value ]
			 selectedObject: self query comparator)
]

{ #category : #rendering }
CPPSQueryFilterComponent >> renderFormContentOn: html [

	html formContainer:
		[ self
			renderPropertySelectionOn: html;
			renderCompratorSelectionOn: html;
			renderComparaisonValueFieldOn: html
		]
]

{ #category : #rendering }
CPPSQueryFilterComponent >> renderPropertySelectionOn: html [

	html render: (MDLSelectWidget
			 possibilities: self possibleProperties
			 inputLabel: (self
					  english: 'Select a property'
					  french: 'Selectionnez une propriété')
			 labelBlock: [ :property | self propertyDisplayName: property ]
			 callback:
				 [ :property | 
				 self query
					 property: property;
					 description: (self propertyDisplayName: property)
				 ]
			 selectedObject: self query property)
]

{ #category : #accessing }
CPPSQueryFilterComponent >> unavailableMessage [

	^ self
		  translate: 'There is no filter for this result'
		  french: 'Il y a aucun filtre pour ce résultat'
]
