"
Description
--------------------

I am a dangerous query that take some code as input and will evaluate it with a mooseGroup named `inputCollection` as parameter.

I will be used to let the clients to code their own queries but we need to keep in mind that this is really dangerous!

Examples
--------------------

	(SQScriptQuery code: 'inputCollection reject: #isStub') runOn: aMooseGroup	
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	code:		<aString> 	The code to execute. This code can use a variable `inputCollection` and should return a collection of moose entities.

"
Class {
	#name : #FQScriptQuery,
	#superclass : #FQLeafQuery,
	#instVars : [
		'code'
	],
	#category : #'Famix-Queries-Model-Leafs'
}

{ #category : #'instance creation' }
FQScriptQuery class >> code: aString [
	^ self new
		code: aString;
		yourself
]

{ #category : #comparing }
FQScriptQuery >> = anObject [
	^ super = anObject and: [ self code = anObject code ]
]

{ #category : #accessing }
FQScriptQuery >> code [
	^ code
]

{ #category : #accessing }
FQScriptQuery >> code: anObject [
	code := anObject
]

{ #category : #printing }
FQScriptQuery >> displayName [
	^ 'Script'
]

{ #category : #initialization }
FQScriptQuery >> initialize [
	super initialize.
	code := 'inputCollection reject: #isStub'
]

{ #category : #run }
FQScriptQuery >> runOn: aMooseGroup [
	^ (self runWithoutOmmissionOn: aMooseGroup) asSet asMooseGroup
]

{ #category : #run }
FQScriptQuery >> runWithoutOmmissionOn: aGroup [
	| result |
	result := (self class compiler evaluate: '[ :inputCollection | ' , self code , ']') value: aGroup.
	(result isCollection and: [ result allSatisfy: [ :each | each isMooseEntity or: [ each isTag ] ] ])
		ifFalse: [ self error: 'The result of a script query should be a collection of Moose entities.' ].
	^ result asMooseGroup
]

{ #category : #printing }
FQScriptQuery >> storeOn: aStream [
	aStream
		nextPut: $(;
		nextPutAll: self className;
		nextPutAll: ' code: ';
		print: code;
		nextPut: $)
]
