Class {
	#name : #CPPSCSVParserTest,
	#superclass : #PP2CompositeNodeTest,
	#instVars : [
		'model'
	],
	#category : #'CPPS-Parser-Tests'
}

{ #category : #accessing }
CPPSCSVParserTest >> parserClass [
	^ CPPSCSVParser 
]

{ #category : #running }
CPPSCSVParserTest >> setUp [
	super setUp.
	model := CPPSModel new.
	parser model: model
]

{ #category : #tests }
CPPSCSVParserTest >> testClassDataLine [
	"#Classes
id,name,typeId,parentId,file,line,column,abstract,trivial,kind,ComplCyclo,ComplComp,totalLoc,execLoc,commentLines,blankLines,totalLines"

	parser savePath: 'foo/bar' forId: '84d730c'.
	self parse: 'Class,AbstractBase,84da46c,84da04c,84d730c,13,7,1,0,0,2,0,4,10,2,1,7' rule: #classe.
	self assert: (parser entitiesMap at: 'Class') name equals: 'AbstractBase'.
	self assert: (parser entitiesMap at: 'Class') numberOfLinesOfCode equals: 10
]

{ #category : #tests }
CPPSCSVParserTest >> testClearTypeName1 [
	self assert: (parser clearTypeName:'const Counter') equals: 'Counter'
]

{ #category : #tests }
CPPSCSVParserTest >> testClearTypeName2 [
	self assert: (parser clearTypeName:'Counter [17]') equals: 'Counter'
]

{ #category : #tests }
CPPSCSVParserTest >> testClearTypeName3 [
	self assert: (parser clearTypeName:'Counter [size1][45][size2]') equals: 'Counter'
]

{ #category : #tests }
CPPSCSVParserTest >> testFunctionCreationDependingOnParent [
	| function |
	parser entitiesMap
		at: 'Class'
		put:
			(CPPSType new
				name: 'MyClass';
				sourceAnchor: (CPPSFileAnchor new mooseModel: model)).
	parser entitiesMap at: 'Package' put: (CPPSPackage new sourceAnchor: (CPPSFileAnchor new mooseModel: model)).
	parser entitiesMap at: 'typeCode' put: CPPSType new.
	parser savePath: 'foo/bar' forId: 'sourceFile'.
	self parse: 'funcCode,myFunction(),typeCode,Package,sourceFile,45,1,48,-1' rule: #function.
	function := model entityNamed: '.myFunction()'.
	self assert: function isFunction.
	self assert: function signature equals: 'myFunction()'.
	self assert: function name equals: 'myFunction'.
	self parse: 'methodCode,myMethod(),typeCode,Class,sourceFile,45,1,48,-1' rule: #function.
	self assert: (model entityNamed: 'MyClass.myMethod()') isMethod
]

{ #category : #tests }
CPPSCSVParserTest >> testFunctionCreationWithBadConstructor [
	parser entitiesMap
		at: 'Class'
		put:
			(CPPSType new
				name: 'MyClass';
				sourceAnchor: (CPPSFileAnchor new mooseModel: model)).
	parser entitiesMap at: 'Package' put: (CPPSPackage new sourceAnchor: (CPPSFileAnchor new mooseModel: model)).
	parser entitiesMap at: 'typeCode' put: CPPSType new.
	parser savePath: 'foo/bar' forId: 'sourceFile'.
	self parse: 'funcCode,(static initializers for ../insubtkst.cc),typeCode,Class,sourceFile,45,1,48,-1' rule: #function.
	self assert: model allMethods size equals: 1.
	self assert: model allMethods first isStub
]

{ #category : #tests }
CPPSCSVParserTest >> testFunctionCreationWithBadDestructor [
	parser entitiesMap
		at: 'Class'
		put:
			(CPPSType new
				name: 'MyClass';
				sourceAnchor: (CPPSFileAnchor new mooseModel: model)).
	parser entitiesMap at: 'Package' put: (CPPSPackage new sourceAnchor: (CPPSFileAnchor new mooseModel: model)).
	parser entitiesMap at: 'typeCode' put: CPPSType new.
	parser savePath: 'foo/bar' forId: 'sourceFile'.
	self parse: 'funcCode,(static destructors for ../ipaddmov.cc),typeCode,Class,sourceFile,45,1,48,-1' rule: #function.
	self assert: model allMethods size equals: 1.
	self assert: model allMethods first isStub
]

{ #category : #tests }
CPPSCSVParserTest >> testFunctionCreationWithCommaAroundName [
	parser entitiesMap
		at: 'Class'
		put:
			(CPPSType new
				name: 'MyClass';
				sourceAnchor: (CPPSFileAnchor new mooseModel: model)).
	parser entitiesMap at: 'typeCode' put: CPPSType new.
	parser savePath: 'foo/bar' forId: 'sourceFile'.
	self parse: 'methodCode,"myMethod()",typeCode,Class,sourceFile,45,1,48,-1' rule: #function.
	self assert: (model entityNamed: 'MyClass.myMethod()') isMethod
]

{ #category : #tests }
CPPSCSVParserTest >> testFunctionWithLOCandCyclo [
	"id,name,typeId,parentId,file,line,column,lineE,vindex,ComplCyclo,ComplComp,totalLoc,execLoc,commentLines,blankLines,totalLines"

	parser entitiesMap
		at: 'Class'
		put:
			(CPPSType new
				name: 'MyClass';
				sourceAnchor: (CPPSFileAnchor new mooseModel: model)).
	parser entitiesMap at: 'Package' put: (CPPSPackage new sourceAnchor: (CPPSFileAnchor new mooseModel: model)).
	parser entitiesMap at: 'typeCode' put: CPPSType new.
	parser savePath: 'foo/bar' forId: 'sourceFile'.
	self parse: '84f310c,dodo(),typeCode,Class,sourceFile,21,6,23,-1,1,0,3,1,0,0,3' rule: #function.
	self assert: (model entityNamed: 'MyClass.dodo()') isMethod.
	self assert: (model entityNamed: 'MyClass.dodo()') cyclomaticComplexity equals: 1.
	self assert: (model entityNamed: 'MyClass.dodo()') numberOfLinesOfCode equals: 3
]

{ #category : #tests }
CPPSCSVParserTest >> testImportTypesInNamspaces [
	self parse: '672dbd0,PR::Finish::OutputBlockBuffer' rule: #type.
	self assert: model allTypes size equals: 1.
	self assert: model allTypes anyOne name equals: 'OutputBlockBuffer'
]

{ #category : #tests }
CPPSCSVParserTest >> testImportTypesPointerReference [
	self parse: 'kldfjgs,BSClusterEvent' rule: #type.
	self parse: 'ea8c38c,BSClusterEvent&' rule: #type.
	self parse: '17fe60ac,BSClusterEvent*' rule: #type.
	self parse: 'xcvglkzj,BSClusterEvent**' rule: #type.
	self assert: model allTypes size equals: 1
]

{ #category : #tests }
CPPSCSVParserTest >> testMultiFileAnchorCreation [
	| anchor |
	anchor := CPPSFileAnchor new mooseModel: model.
	parser entitiesMap
		at: 'Class'
		put:
			(CPPSType new
				name: 'MyClass';
				sourceAnchor: anchor).
	parser entitiesMap at: 'typeCode' put: CPPSType new.
	parser savePath: 'foo/bar' forId: 'sourceFile'.
	self parse: 'methodCode,myMethod(),typeCode,Class,sourceFile,45,1,48,-1' rule: #function.
	self assert: (parser entitiesMap at: 'Class') sourceAnchor class equals: CPPSMultipleFileAnchor.
	self assert: (parser entitiesMap at: 'Class') sourceAnchor allFiles first equals: anchor.
	self assert: (parser entitiesMap at: 'Class') sourceAnchor allFiles second fileName equals: 'bar'
]
