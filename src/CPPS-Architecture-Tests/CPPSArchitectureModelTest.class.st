Class {
	#name : #CPPSArchitectureModelTest,
	#superclass : #TestCase,
	#category : #'CPPS-Architecture-Tests-Model'
}

{ #category : #tests }
CPPSArchitectureModelTest >> testChangeParent [
	| layer1 layer2 child |
	layer1 := CPPSArchitectureLayer new.
	layer2 := CPPSArchitectureLayer new.
	child := CPPSArchitectureComponent new.
	layer1 addChild: child.
	layer2 addChild: child.
	self assert: child parent equals: layer2.
	self assertEmpty: layer1 children.
	self assert: layer2 children size equals: 1
]

{ #category : #tests }
CPPSArchitectureModelTest >> testCreateArchitectureOnePackage [
	| model package architecture |
	model := CPPSModel new.
	package := CPPSPackage new mooseModel: model.
	architecture := model createArchitecture.
	self assert: architecture children size equals: 1.
	self assert: architecture children first modelEntity equals: package
]

{ #category : #tests }
CPPSArchitectureModelTest >> testImpossibleToBeItsOwnAncestor [
	| grandFather father child |
	grandFather := CPPSArchitectureLayer new.
	father := CPPSArchitectureLayer new parent: grandFather.
	child := CPPSArchitectureLayer new parent: father.
	self should: [ grandFather parent: child ] raise: Exception
]

{ #category : #tests }
CPPSArchitectureModelTest >> testIsAncestor [
	| grandFather father child |
	grandFather := CPPSArchitectureLayer new.
	father := CPPSArchitectureLayer new parent: grandFather.
	child := CPPSArchitectureLayer new parent: father.
	self assert: (grandFather isAncestorOf: father).
	self assert: (grandFather isAncestorOf: child).
	self assert: (father isAncestorOf: child)
]

{ #category : #tests }
CPPSArchitectureModelTest >> testNewLayersAreDifferents [
	self deny: CPPSArchitectureLayer new equals: CPPSArchitectureLayer new
]
