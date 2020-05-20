Class {
	#name : #CPPSConditionalsParser,
	#superclass : #CPPSConditionalsGrammar,
	#instVars : [
		'method',
		'parsedString',
		'sourceAnchor'
	],
	#category : #'CPPS-Parser-Block'
}

{ #category : #accessing }
CPPSConditionalsParser >> block [
	^ super block info
		==> [ :info | 
			CPPSBlock new
				parentBehavioural: self method;
				sourceAnchor: (self createAnchorFromInfo: info);
				innerBlocks: info element second;
				yourself ]
]

{ #category : #accessing }
CPPSConditionalsParser >> blockContent [
	^ super blockContent ==> [ :p | (p collect: #second thenSelect: #notNil) flatCollect: #value ]
]

{ #category : #accessing }
CPPSConditionalsParser >> case [
	^ super case info
		==> [ :info | 
			CPPSBlock new
				parentBehavioural: self method;
				sourceAnchor: (self createAnchorFromInfo: info);
				yourself ]
]

{ #category : #accessing }
CPPSConditionalsParser >> comment [
	^ super comment ==> [ :p | nil ]
]

{ #category : #accessing }
CPPSConditionalsParser >> condition [
	^ super condition info
		==> [ :info | 
			CPPSCondition new
				parentBehavioural: self method;
				sourceAnchor: (self createAnchorFromInfo: info);
				yourself ]
]

{ #category : #'as yet unclassified' }
CPPSConditionalsParser >> createAnchorFromInfo: info [
	^ SYNRelativeSourceAnchor new
		start: info start;
		stop: info stop;
		relatedAnchor: self sourceAnchor;
		initializeStartAndEndLineFrom: parsedString;
		yourself
]

{ #category : #accessing }
CPPSConditionalsParser >> doWhile [
	^ super doWhile info
		==> [ :info | 
			{(CPPSWhile new
				parentBehavioural: self method;
				sourceAnchor: (self createAnchorFromInfo: info);
				innerBlocks: (self selectBlocksfrom: info element);
				yourself)} ]
]

{ #category : #accessing }
CPPSConditionalsParser >> for [
	^ super for info
		==> [ :info | 
			{(CPPSFor new
				parentBehavioural: self method;
				sourceAnchor: (self createAnchorFromInfo: info);
				innerBlocks: (self selectBlocksfrom: info element);
				yourself)} ]
]

{ #category : #accessing }
CPPSConditionalsParser >> ifElse [
	^ super ifElse info
		==> [ :info | 
			{(CPPSIf new
				parentBehavioural: self method;
				sourceAnchor: (self createAnchorFromInfo: info);
				innerBlocks: (self selectBlocksfrom: info element deepFlatten);
				yourself)} ]
]

{ #category : #accessing }
CPPSConditionalsParser >> method [
	^ method
]

{ #category : #accessing }
CPPSConditionalsParser >> method: anObject [
	method := anObject
]

{ #category : #accessing }
CPPSConditionalsParser >> oneLineStatement [
	^ super oneLineStatement ==> [ :info | nil ]
]

{ #category : #'as yet unclassified' }
CPPSConditionalsParser >> parse [
	^ self parse: self sourceAnchor sourceText
]

{ #category : #'as yet unclassified' }
CPPSConditionalsParser >> parse: aString [
	('Parsing blocks of ' , self method mooseName asString) record.
	parsedString := aString.
	^ super parse: aString
]

{ #category : #accessing }
CPPSConditionalsParser >> parsedString [
	^ parsedString
]

{ #category : #'as yet unclassified' }
CPPSConditionalsParser >> productionNames [
	^ super productionNames \ {#method}
]

{ #category : #help }
CPPSConditionalsParser >> selectBlocksfrom: collection [
	^ collection select: #isFAMIXBlock
]

{ #category : #accessing }
CPPSConditionalsParser >> sourceAnchor [
	^ sourceAnchor
]

{ #category : #accessing }
CPPSConditionalsParser >> sourceAnchor: anObject [
	sourceAnchor := anObject
]

{ #category : #accessing }
CPPSConditionalsParser >> start [
	^ super start ==> [ :p | (p select: #isNotNil) flatCollect: #value ]
]

{ #category : #accessing }
CPPSConditionalsParser >> statement [
	^ super statement info
		==> [ :info | 
			CPPSBlock new
				parentBehavioural: self method;
				sourceAnchor: (self createAnchorFromInfo: info);
				types: (info element ifNil: [ #() ]);
				yourself ]
]

{ #category : #accessing }
CPPSConditionalsParser >> string [
	^ super string ==> [ :p | nil ]
]

{ #category : #accessing }
CPPSConditionalsParser >> switchCases [
	^ super switchCases info
		==> [ :info | 
			{(CPPSSwitch new
				parentBehavioural: self method;
				sourceAnchor: (self createAnchorFromInfo: info);
				innerBlocks: (self selectBlocksfrom: info element deepFlatten);
				yourself)} ]
]

{ #category : #accessing }
CPPSConditionalsParser >> water [
	^ super water ==> [ :p | nil ]
]

{ #category : #accessing }
CPPSConditionalsParser >> while [
	^ super while info
		==> [ :info | 
			{(CPPSWhile new
				parentBehavioural: self method;
				sourceAnchor: (self createAnchorFromInfo: info);
				innerBlocks: (self selectBlocksfrom: info element);
				yourself)} ]
]
