Extension { #name : #String }

{ #category : #'*CPPS-Toolkit-Core' }
String >> positionOfFirstCharacterOfLine: aLineNumber [

	| lineIndex |

	lineIndex := 0.
	self lineIndicesDo:
		[ :start :del :end | 
		lineIndex := lineIndex + 1.
		lineIndex = aLineNumber ifTrue: [ ^ start ]
		].
	^ 0
]

{ #category : #'*CPPS-Toolkit-Core' }
String >> positionOfLastCharacterOfLine: aLineNumber [

	| lineIndex |

	lineIndex := 0.
	self lineIndicesDo:
		[ :start :del :end | 
		lineIndex := lineIndex + 1.
		lineIndex = aLineNumber ifTrue: [ ^ end ]
		].
	^ 0
]
