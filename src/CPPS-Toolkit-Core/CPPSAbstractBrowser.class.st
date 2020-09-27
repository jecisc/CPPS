"
Description
--------------------

I am an abstract class for all of the browsers of the web solution.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	strategy:		<aStrategy> 		I am a strategy use to store the language/project specific informations. See CPPSBrowserStrategy
"
Class {
	#name : #CPPSAbstractBrowser,
	#superclass : #CPPSComponent,
	#category : #'CPPS-Toolkit-Core-Core'
}

{ #category : #accessing }
CPPSAbstractBrowser class >> allConcreteSubclasses [

	^ self allSubclasses reject: #isAbstract
]

{ #category : #accessing }
CPPSAbstractBrowser class >> browserAccess [

	^ self browserName englishText asSymbol
]

{ #category : #accessing }
CPPSAbstractBrowser class >> browserName [

	^ self subclassResponsibility
]

{ #category : #accessing }
CPPSAbstractBrowser class >> default [

	^ self allConcreteSubclasses detectMax: #priority
]

{ #category : #testing }
CPPSAbstractBrowser class >> isAbstract [

	^ self = CPPSAbstractBrowser
]

{ #category : #testing }
CPPSAbstractBrowser class >> isReleventFor: selectionOrEntity [

	"I should answer if the browser I am implemeneted in is revelent for some kind of input entity/ies. For example a DuplicationBrowser is revelent for a DPClonedFragment"

	^ false
]

{ #category : #accessing }
CPPSAbstractBrowser class >> priority [

	^ self subclassResponsibility
]

{ #category : #conveniance }
CPPSAbstractBrowser >> bindNestedListKeysOfId: class on: html [

	self flag: #todo. "This should be in MDL as an option by default."
	html document addLoadScript: ('SiemensToolkit.bindNestedListWith($("#' , class , '"), function(JqElement){JqElement.find("a")[0].click()});') js
]

{ #category : #opening }
CPPSAbstractBrowser >> onEntity: anEntity [

	self subclassResponsibility
]

{ #category : #selection }
CPPSAbstractBrowser >> selection: aSelection [

	self subclassResponsibility
]
