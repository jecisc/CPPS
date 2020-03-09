"
A CPPSMethodTest is a test class for testing the behavior of CPPSMethod
"
Class {
	#name : #CPPSMethodTest,
	#superclass : #TestCase,
	#category : #'CPPS-Entities-Tests-Entities'
}

{ #category : #tests }
CPPSMethodTest >> testIsConstructor [
	| meth1 meth2 |
	meth1 := CPPSMethod named: 'TestConstructor'.
	meth1 parentType: (CPPSType named: 'TestConstructor').
	meth2 := CPPSMethod named: 'testNotConstructor'.
	meth2 parentType: (CPPSType named: 'aClass').

	self assert: meth1 isConstructor.
	self deny: meth2 isConstructor
]

{ #category : #tests }
CPPSMethodTest >> testIsDestructor [
	| meth1 meth2 |
	meth1 := CPPSMethod named: '~TestDestructor'.
	meth1 parentType: (CPPSType named: 'TestDestructor').
	meth2 := CPPSMethod named: 'testNotDestructor'.
	meth2 parentType: (CPPSType named: 'aClass').

	self assert: meth1 isDestructor.
	self deny: meth2 isDestructor
]
