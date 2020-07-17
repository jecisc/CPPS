Extension { #name : #MooseAbstractGroup }

{ #category : #'*CPPS-Entities' }
MooseAbstractGroup >> gtInspectorItemsIn: composite [
	<gtInspectorPresentationOrder: 0>
	^ composite fastTable
		title: 'Items';
		display: [ :aCollection | (1 to: self size) collect: [ :index | index -> (self at: index) ] ];
		beMultiple;
		column: 'Index' evaluated: [ :assoc | assoc key asString ];
		column: 'Item' evaluated: [ :assoc | GTObjectPrinter new asTruncatedTextFrom: assoc value ];
		send: [ :result | 
			result
				ifNotNil: [ result value size = 1
						ifTrue: [ result anyOne value ]
						ifFalse: [ self species withAll: (result collect: [ :each | each value ]) ] ] ]
]
