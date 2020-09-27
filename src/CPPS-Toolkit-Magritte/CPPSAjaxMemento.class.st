"
Description
--------------------

QCComposedMemento makes it possible to use ""wrapped"" descriptions, that give a value not from the cache, but return a dynamic value, based on other values in the cache.
"
Class {
	#name : #CPPSAjaxMemento,
	#superclass : #MACheckedMemento,
	#category : #'CPPS-Toolkit-Magritte'
}

{ #category : #accessing }
CPPSAjaxMemento >> announcer [

	^ self model announcer
]

{ #category : #private }
CPPSAjaxMemento >> isDifferent: firstDictionary to: secondDictionary [

	"nil is equal to nil"

	| firstValue secondValue |

	self magritteDescription do:
		[ :each | 
		(each isVisible and: [ each isReadonly not ]) ifTrue:
			[ firstValue := firstDictionary
				              at: each
				              ifAbsent: [ nil ].
			secondValue := secondDictionary
				               at: each
				               ifAbsent: [ nil ].
			(firstValue isNil and: [ secondValue isNil ]) ifTrue: [ ^ false ].
			firstValue = secondValue ifFalse: [ ^ true ]
			]
		].
	^ false
]

{ #category : #accessing }
CPPSAjaxMemento >> processVisibilityFor: aDescription value: anObject [

	self magritteDescription do: [ :desc | desc hidden: desc visibilityCondition value not ]
]

{ #category : #private }
CPPSAjaxMemento >> push: aDictionary [

	"Utility method to push a dictionary mapping descriptions to values into the model."

	"we respect description priorities when iterating, because some write accessor may require push of description we lower priority"

	| value |

	(aDictionary keys sort: [ :a :b | a priority < b priority ]) do:
		[ :eachMADescription | 
		value := aDictionary at: eachMADescription.
		(eachMADescription isVisible and: [ eachMADescription isReadonly not ]) ifTrue:
			[ self model
				write: value
				using: eachMADescription
			]
		]
]

{ #category : #private }
CPPSAjaxMemento >> readUsing: aDescription [

	^ self cache
		  at: aDescription
		  ifAbsent: [ self model readUsing: aDescription ]
]

{ #category : #private }
CPPSAjaxMemento >> write: anObject using: aDescription [

	(self readUsing: aDescription) = anObject ifTrue: [ ^ self ].
	super
		write: anObject
		using: aDescription.
	self
		processVisibilityFor: aDescription
		value: anObject
]
