"
Description
--------------------

I am a trait defining the basic structure for a startegy design pattern to configure part of the synectique web solution GUI.

I define the basics info all strategies will return and create the gathering mecanism.
"
Trait {
	#name : #CPPSTGUIStrategy,
	#category : #'CPPS-Toolkit-Core'
}

{ #category : #accessing }
CPPSTGUIStrategy classSide >> defaultStrategy [

	^ self strategies first
]

{ #category : #accessing }
CPPSTGUIStrategy classSide >> label [

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSTGUIStrategy classSide >> priority [

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSTGUIStrategy classSide >> strategies [

	^ (self allSubclasses reject: #isAbstract) sorted: #priority descending
]
