Extension { #name : #MooseProjectVersion }

{ #category : #'*CPPS-Toolkit-Core' }
MooseProjectVersion >> printIdOn: aStream [

	self versionName ifNotNil:
		[ :aStringName | 
		aStream
			nextPutAll: aStringName;
			nextPutAll: ' ['
		].
	self date printSeparateDateAndTimeOn: aStream.
	self versionName ifNotNil: [ :aStringName | aStream nextPutAll: ']' ]
]

{ #category : #'*CPPS-Toolkit-Core' }
MooseProjectVersion >> separateDateAndTime [

	^ String streamContents:
		  [ :s | 
		  self versionName ifNotNil:
			  [ :aName | 
			  s
				  << aName;
				  << ' ['
			  ].
		  s
			  print: self date asDate;
			  space;
			  << (self date asTime print24 first: 8).
		  self versionName ifNotNil: [ :aName | s << ']' ]
		  ]
]
