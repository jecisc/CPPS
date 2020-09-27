Extension { #name : #Number }

{ #category : #'*CPPS-Toolkit-Core' }
Number >> printFormated [

	| str |

	str := self asString.
	^ String streamContents:
		  [ :s | 
		  str doWithIndex:
			  [ :c :index | 
			  s << c.
			  (str size - index \\ 3 = 0 and: [ str size - index > 1 ]) ifTrue: [ s space ]
			  ]
		  ]
]

{ #category : #'*CPPS-Toolkit-Core' }
Number >> printShowingMaxDecimalPlaces: placesDesired [

	| result |

	result := self printShowingDecimalPlaces: placesDesired.
	[ (result includes: $.) and: [ { $0. $. } includes: result last ] ] whileTrue: [ result := result allButLast ].
	^ result
]
