Class {
	#name : #CPPSConditionalsGrammar,
	#superclass : #PPCompositeParser,
	#instVars : [
		'while',
		'block',
		'blockClosing',
		'blockContent',
		'blockOpening',
		'blockOrStatement',
		'case',
		'caseDeclaration',
		'cases',
		'comment',
		'condition',
		'conditionClosing',
		'conditionContent',
		'conditionOpening',
		'controlStructure',
		'doWhile',
		'else',
		'elseIf',
		'for',
		'ifElse',
		'oneLineStatement',
		'statement',
		'statementEnding',
		'string',
		'switchCases',
		'water'
	],
	#category : #'CPPS-Parser-Block'
}

{ #category : #accessing }
CPPSConditionalsGrammar >> block [
	^ blockOpening, blockContent, blockClosing
]

{ #category : #accessing }
CPPSConditionalsGrammar >> blockClosing [
	^ $} asParser
]

{ #category : #accessing }
CPPSConditionalsGrammar >> blockContent [
	^ (blockClosing not , (comment / string / controlStructure / water)) plus
]

{ #category : #accessing }
CPPSConditionalsGrammar >> blockOpening [
	^ ${ asParser
]

{ #category : #accessing }
CPPSConditionalsGrammar >> blockOrStatement [ 
	^ block / statement
]

{ #category : #accessing }
CPPSConditionalsGrammar >> case [
	^ caseDeclaration , ((block negate , caseDeclaration not, blockClosing not) plus , block) star , (caseDeclaration / blockClosing) negate plus 
]

{ #category : #accessing }
CPPSConditionalsGrammar >> caseDeclaration [
	^ ('case ' asParser , $: asParser negate plus) / 'default' asParser , $: asParser
]

{ #category : #switchs }
CPPSConditionalsGrammar >> cases [
	^ case plus
]

{ #category : #accessing }
CPPSConditionalsGrammar >> comment [
	^ '//' asParser, #newline asParser negate star
]

{ #category : #accessing }
CPPSConditionalsGrammar >> condition [
	^ conditionOpening, conditionContent, conditionClosing
]

{ #category : #accessing }
CPPSConditionalsGrammar >> conditionClosing [
	^ $) asParser
]

{ #category : #accessing }
CPPSConditionalsGrammar >> conditionContent [
	^ (conditionClosing not , (comment / string / condition / water)) star
]

{ #category : #accessing }
CPPSConditionalsGrammar >> conditionOpening [
	^ $( asParser
]

{ #category : #accessing }
CPPSConditionalsGrammar >> controlStructure [
	^ (for / while / ifElse / doWhile / switchCases) memoized
]

{ #category : #loops }
CPPSConditionalsGrammar >> doWhile [
	^ 'do' asParser trim, block, 'while' asParser trim, condition
]

{ #category : #ifs }
CPPSConditionalsGrammar >> else [
	^ 'else' asParser trim , blockOrStatement
]

{ #category : #ifs }
CPPSConditionalsGrammar >> elseIf [
	^ ('else if' asParser trim , condition trim , blockOrStatement)
]

{ #category : #loops }
CPPSConditionalsGrammar >> for [
	^ 'for' asParser, condition trim, blockOrStatement
]

{ #category : #ifs }
CPPSConditionalsGrammar >> ifElse [
	^ 'if' asParser , condition trim , blockOrStatement , elseIf star , else optional
]

{ #category : #accessing }
CPPSConditionalsGrammar >> oneLineStatement [
	^ (statementEnding negate plus, statementEnding)
]

{ #category : #accessing }
CPPSConditionalsGrammar >> start [
	^ ((controlStructure / comment / water) plus preProcessor: comment ==> [ :p | '' ])
		preProcessor: (#newline asParser , $# asParser , #newline asParser negate plus) ==> [ :p | '' ]
]

{ #category : #accessing }
CPPSConditionalsGrammar >> statement [
	^ controlStructure / oneLineStatement
]

{ #category : #accessing }
CPPSConditionalsGrammar >> statementEnding [
	^ $; asParser
]

{ #category : #accessing }
CPPSConditionalsGrammar >> string [
	^ $" asParser, ('\"' asParser / ($" asParser negate)) plus, $" asParser
]

{ #category : #switchs }
CPPSConditionalsGrammar >> switchCases [
	^ 'switch' asParser trim, condition, blockOpening trim, cases , blockClosing trim
]

{ #category : #accessing }
CPPSConditionalsGrammar >> water [
	^ #any asParser
]

{ #category : #loops }
CPPSConditionalsGrammar >> while [
	^ 'while' asParser, condition trim, blockOrStatement 
]
