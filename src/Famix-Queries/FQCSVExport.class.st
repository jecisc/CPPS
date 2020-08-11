"
Description
--------------------

I am a class responsible for some simple CSV exports.

I am able to export the result of some queries or correlations.
"
Class {
	#name : #FQCSVExport,
	#superclass : #Object,
	#category : #'Famix-Queries-Export'
}

{ #category : #generation }
FQCSVExport class >> exportCorrelation: aCorrelation forModel: aModel [
	^ String streamContents: [ :stream | self new exportCorrelation: aCorrelation forModel: aModel on: stream ]
]

{ #category : #generation }
FQCSVExport class >> exportQueryBrowserResults: aMooseGroup withProperties: selectedQueries [
	^ String streamContents: [ :stream | self new exportQueryBrowserResults: aMooseGroup withProperties: selectedQueries on: stream ]
]

{ #category : #export }
FQCSVExport >> exportCorrelation: aCorrelation forModel: aModel on: aStream [
	self writeLine: #(#name) , (aCorrelation columnsEntities collect: #mooseName) on: aStream.
	aCorrelation linesEntities
		do: [ :each | 
			self
				writeLine:
					((OrderedCollection with: each mooseName)
						addAll: (aCorrelation columnsEntities collect: [ :columnEntity | self valueOf: aCorrelation forLineEntity: columnEntity columnEntity: each ]);
						yourself)
				on: aStream ]
]

{ #category : #export }
FQCSVExport >> exportQueryBrowserResults: aMooseGroup withProperties: exportProperties on: aStream [
	self writeLine: #('Full Entity Name') , (exportProperties collect: #displayName) on: aStream.
	aMooseGroup do: [ :each | self writeLine: {each mooseName} , (exportProperties collect: [ :aProp | (each perform: aProp property) asString ]) on: aStream ]
]

{ #category : #export }
FQCSVExport >> separator [
	^ $;
]

{ #category : #export }
FQCSVExport >> valueOf: aCorrelation forLineEntity: columnEntity columnEntity: lineEntity [
	^ aCorrelation isCount
		ifFalse: [ (aCorrelation is: columnEntity correlatedTo: lineEntity)
				ifTrue: [ 'true' ]
				ifFalse: [ 'false' ] ]
		ifTrue: [ (aCorrelation numberOfMatchesFor: columnEntity correlatedTo: lineEntity) asString ]
]

{ #category : #export }
FQCSVExport >> writeLine: aCollectionOfStrings on: aStream [
	aCollectionOfStrings do: [ :each | aStream nextPutAll: each ] separatedBy: [ aStream nextPut: self separator ].
	aStream lf
]
