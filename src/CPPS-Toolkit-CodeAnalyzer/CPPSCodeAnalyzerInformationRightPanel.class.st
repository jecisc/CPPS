"
Description
--------------------

I display informations about the current selected entity of the Code Analyzer.
"
Class {
	#name : #CPPSCodeAnalyzerInformationRightPanel,
	#superclass : #CPPSAbstractRightPanel,
	#instVars : [
		'componentsToDisplay'
	],
	#category : #'CPPS-Toolkit-CodeAnalyzer-RightPanels'
}

{ #category : #accessing }
CPPSCodeAnalyzerInformationRightPanel >> announcer [

	^ self owner announcer
]

{ #category : #accessing }
CPPSCodeAnalyzerInformationRightPanel >> componentsToDisplay [

	^ componentsToDisplay
]

{ #category : #accessing }
CPPSCodeAnalyzerInformationRightPanel >> componentsToDisplay: aCollection [

	componentsToDisplay := aCollection
]

{ #category : #accessing }
CPPSCodeAnalyzerInformationRightPanel >> defaultComponentsToDisplay [

	^ self possibleComponents collect: [ :c | c newWithParent: self ]
]

{ #category : #accessing }
CPPSCodeAnalyzerInformationRightPanel >> owner: aComponent [

	super owner: aComponent.

	"We initialize #componentsToDisplay here because they need to be initialized before the rendering phase of the code analyzer. If they are not initialized before, they will not be able to receive some announcements when an entity will be selected."
	self componentsToDisplay: self defaultComponentsToDisplay
]

{ #category : #accessing }
CPPSCodeAnalyzerInformationRightPanel >> possibleComponents [

	^ Array
		  with: CPPSIncomingComponent
		  with: CPPSOutgoingComponent
		  with: CPPSAttributesComponent
		  with: CPPSPropertiesComponent
]

{ #category : #rendering }
CPPSCodeAnalyzerInformationRightPanel >> renderContentOn: html [

	html div
		class: #'code-analyzer-info';
		id: #'code-analyzer-right-panel__content';
		with: [ self renderInfoComponents: html ]
]

{ #category : #rendering }
CPPSCodeAnalyzerInformationRightPanel >> renderInfoComponents: html [

	| infoPanelsToDisplay totalSize |

	infoPanelsToDisplay := self componentsToDisplay select: #isUseful.
	totalSize := infoPanelsToDisplay sum: #vSize.
	infoPanelsToDisplay do: [ :c | html render: (c withStyle: 'height: ' , (c vSize / totalSize * 100) asInteger asString , '%') ]
]
