"
Description
--------------------

I am defining the grammar to read CSV outputed by the CPPS parser.

I am a PetitParser2 parser. 

I define parser for different kind of entities:
- Files: fileLocation
- Namespaces: namespace
- Packages: package
- Types (in general): type
- Classes: classe
- Enums: enum
- Functions: function
- Variables: variable
- Associations: edge
"
Class {
	#name : #CPPSCSVGrammar,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'namespaces',
		'types',
		'classes',
		'enums',
		'functions',
		'variables',
		'edges',
		'csvValue',
		'csvLine',
		'fileLocation',
		'namespace',
		'type',
		'classe',
		'enum',
		'function',
		'variable',
		'edge',
		'filesLocations',
		'edgeUnspecified',
		'edgeBaseClass',
		'edgeFriend',
		'edgeTemplate',
		'edgeTemplateParam',
		'edgeMemberObject',
		'edgeCall',
		'edgeVirtCall',
		'edgeVarRead',
		'edgeVarWrite',
		'edgeConst',
		'edgeFuncAddr',
		'edgeOverCall'
	],
	#category : #'CPPS-Parser'
}

{ #category : #accessing }
CPPSCSVGrammar >> classe [
	^ csvLine
]

{ #category : #accessing }
CPPSCSVGrammar >> classes [
	^ (self header: '#Classes' description: 'id,name,typeId,parentId,file,line,column,abstract,trivial,kind') , classe plus
]

{ #category : #util }
CPPSCSVGrammar >> csvLine [
	^ $# asPParser not, (csvValue separatedBy: $, asPParser) withoutSeparators ", #newline asPParser plus"
]

{ #category : #util }
CPPSCSVGrammar >> csvValue [
	^ (($" asPParser , $" asPParser negate star flatten, $" asPParser) ==> [ :p | p second ]) / ($, asPParser / #newline asPParser) negate star flatten
]

{ #category : #edges }
CPPSCSVGrammar >> edge [
	^ $# asPParser not , ((csvValue , $, asPParser) ==> [ :p | p first ] times: 5)
		,
			(edgeConst / edgeFuncAddr / edgeOverCall / edgeUnspecified / edgeBaseClass / edgeFriend / edgeTemplate / edgeTemplateParam / edgeMemberObject
				/ edgeCall / edgeVirtCall / edgeVarRead / edgeVarWrite)	", #newline asPParser plus"
]

{ #category : #edges }
CPPSCSVGrammar >> edgeBaseClass [
	^ self edgeWithKind: 1
]

{ #category : #edges }
CPPSCSVGrammar >> edgeCall [
	^ self edgeWithKind: 6
]

{ #category : #edges }
CPPSCSVGrammar >> edgeConst [
	^ self edgeWithKind: 10
]

{ #category : #edges }
CPPSCSVGrammar >> edgeFriend [
	^ self edgeWithKind: 2
]

{ #category : #edges }
CPPSCSVGrammar >> edgeFuncAddr [
	^ self edgeWithKind: 11
]

{ #category : #edges }
CPPSCSVGrammar >> edgeMemberObject [
	^ self edgeWithKind: 5
]

{ #category : #edges }
CPPSCSVGrammar >> edgeOverCall [
	^ self edgeWithKind: 12
]

{ #category : #edges }
CPPSCSVGrammar >> edgeTemplate [
	^ self edgeWithKind: 3
]

{ #category : #edges }
CPPSCSVGrammar >> edgeTemplateParam [
	^ self edgeWithKind: 4
]

{ #category : #edges }
CPPSCSVGrammar >> edgeUnspecified [
	^ self edgeWithKind: 0
]

{ #category : #edges }
CPPSCSVGrammar >> edgeVarRead [
	^ self edgeWithKind: 8
]

{ #category : #edges }
CPPSCSVGrammar >> edgeVarWrite [
	^ self edgeWithKind: 9
]

{ #category : #edges }
CPPSCSVGrammar >> edgeVirtCall [
	^ self edgeWithKind: 7
]

{ #category : #edges }
CPPSCSVGrammar >> edgeWithKind: aCodeNumber [
	^ aCodeNumber asString asPParser
]

{ #category : #edges }
CPPSCSVGrammar >> edges [
	^ (self header: '#Edges' description: 'sourceId,targetId,file,line,column,edgeType') , edge plus
]

{ #category : #accessing }
CPPSCSVGrammar >> enum [
	^ csvLine
]

{ #category : #accessing }
CPPSCSVGrammar >> enums [
	^ (self header: '#Enums' description: 'id,name,typeId,parentId,file,line,column') ,  enum plus
]

{ #category : #accessing }
CPPSCSVGrammar >> fileLocation [
	^ csvLine
]

{ #category : #accessing }
CPPSCSVGrammar >> filesLocations [
	^ (self header: '#Files' description: 'fileId,path'),  fileLocation plus
]

{ #category : #accessing }
CPPSCSVGrammar >> function [
	^ csvLine
]

{ #category : #accessing }
CPPSCSVGrammar >> functions [
	^ (self header: '#Funcs' description: 'id,name,typeId,parentId,file,line,column,lineE,vindex') , function plus
]

{ #category : #util }
CPPSCSVGrammar >> header: title description: description [
	^ title asPParser, #newline asPParser, description asPParser, #newline asPParser
]

{ #category : #accessing }
CPPSCSVGrammar >> namespace [
	^ csvLine
]

{ #category : #accessing }
CPPSCSVGrammar >> namespaces [
	^ (self header: '#Namespaces' description: 'id,name,parentId,file,line,column'), namespace plus
]

{ #category : #accessing }
CPPSCSVGrammar >> package [
	^ csvLine
]

{ #category : #accessing }
CPPSCSVGrammar >> start [
	"Answer the production to start this parser with."

	^ (filesLocations, namespaces, types, classes, enums, functions, variables, edges) end
]

{ #category : #accessing }
CPPSCSVGrammar >> type [
	^ csvLine
]

{ #category : #accessing }
CPPSCSVGrammar >> types [
	^ (self header: '#Types' description: 'id,name'), type plus
]

{ #category : #accessing }
CPPSCSVGrammar >> variable [
	^ csvLine
]

{ #category : #accessing }
CPPSCSVGrammar >> variables [
	^ (self header: '#Vars' description: 'id,name,typeId,parentId,file,line,column'), variable plus
]
