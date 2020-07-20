Class {
	#name : #CPPSArchitectureDiffTest,
	#superclass : #TestCase,
	#instVars : [
		'changes'
	],
	#category : #'CPPS-Architecture-Tests-Model'
}

{ #category : #running }
CPPSArchitectureDiffTest >> setUp [
	| model package sourceArchitecture evolvedArchitecture |
	super setUp.
	model := CPPSModel new.
	package := CPPSPackage named: 'package1'.
	model add: package.
	package addChildEntity: (CPPSType named: 'class1').
	sourceArchitecture := model createArchitecture.
	package addChildEntity: (CPPSType named: 'class2').
	model add: (CPPSPackage named: 'package2').
	evolvedArchitecture := model createArchitecture.
	changes := CPPSArchitectureDiff updatesBetween: sourceArchitecture and: evolvedArchitecture
]

{ #category : #tests }
CPPSArchitectureDiffTest >> testAdditions [
	self assert: changes additions size equals: 2
]

{ #category : #tests }
CPPSArchitectureDiffTest >> testDeletions [
	self assertEmpty: changes deletions
]

{ #category : #tests }
CPPSArchitectureDiffTest >> testModifications [
	self assert: changes modifications size equals: 2.
	self assert: (changes modifications anySatisfy: [ :element | element modelEntity mooseName = 'package1' ])
]
