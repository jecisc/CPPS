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

{ #category : #helpers }
CPPSConditionalsParser >> createAnchorFromInfo: info [
	^ CPPSRelativeSourceAnchor new
		startPos: info start;
		endPos: info stop;
		relatedAnchor: self sourceAnchor;
		initializeStartAndEndLineFrom: parsedString; "We do it here to not have to parse again the file."
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

{ #category : #parsing }
CPPSConditionalsParser >> parse [
	^ self parse: self sourceAnchor sourceText
]

{ #category : #parsing }
CPPSConditionalsParser >> parse: aString [
	('Parsing blocks of ' , self method mooseName asString) record.
	parsedString := aString.
	^ super parse: aString
]

{ #category : #accessing }
CPPSConditionalsParser >> parsedString [
	^ parsedString
]

{ #category : #querying }
CPPSConditionalsParser >> productionNames [
	^ super productionNames \ {#method}
]

{ #category : #helpers }
CPPSConditionalsParser >> selectBlocksfrom: collection [
	^ collection select: #isCPPSBlock
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
