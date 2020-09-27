"
Description
---------------------

I am a state for the CPPSArchitectureBrowser. I hold the informations relative to a mode un usage for the browser. 

Public API and Key Messages
---------------------

- #architectureToDisplayFor: aBrowser 		Allow to set the architectures to show of the browser
- #initializeVisus: aColl for: aBrowser 		Allow to initialize a collection of visualizations to display on a browser

Example 
--------------------

		CPPSArchitectureBrowserState
			named: 'evolution'
			description: 'I am a comparison mode allowing to see the impact of evolution between two versions.'
			initializationBlock: [ :browser | 
				browser foldRightPanel.
				browser defaultArchitecturesForComparisonMode ]
			initializationVisusBlock: [ :visus :browser | 
				visus size > 1
					ifTrue: [ browser addEvolutionInteractionWith: visus first to: visus second ] ]
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	description:								<String>		The description of the mode
	initializationBlock:					<aBlock>		A block to execute when the user select the mode
	initializationVisusBlock:			<aBlock> 		A block to initialize the visus to display for a specific mode
	label:										<aString>		The name of the mode


"
Class {
	#name : #CPPSArchitectureBrowserState,
	#superclass : #Object,
	#instVars : [
		'label',
		'initializationBlock',
		'initializationVisusBlock',
		'description'
	],
	#category : #'CPPS-Toolkit-ArchitectureSimulation'
}

{ #category : #'instance creation' }
CPPSArchitectureBrowserState class >> named: aStateName description: aString initializationBlock: aBlock [

	^ self
		  named: aStateName
		  description: aString
		  initializationBlock: aBlock
		  initializationVisusBlock: nil
]

{ #category : #'instance creation' }
CPPSArchitectureBrowserState class >> named: aStateName description: aString initializationBlock: aBlock initializationVisusBlock: anotherBlock [

	^ self new
		  label: aStateName;
		  description: aString;
		  initializationBlock: aBlock;
		  initializationVisusBlock: anotherBlock;
		  yourself
]

{ #category : #api }
CPPSArchitectureBrowserState >> architectureToDisplayFor: architectureBrowser [

	^ self initializationBlock value: architectureBrowser
]

{ #category : #accessing }
CPPSArchitectureBrowserState >> description [

	^ description
]

{ #category : #accessing }
CPPSArchitectureBrowserState >> description: anObject [

	description := anObject
]

{ #category : #accessing }
CPPSArchitectureBrowserState >> initializationBlock [

	^ initializationBlock
]

{ #category : #accessing }
CPPSArchitectureBrowserState >> initializationBlock: anObject [

	initializationBlock := anObject
]

{ #category : #accessing }
CPPSArchitectureBrowserState >> initializationVisusBlock [

	^ initializationVisusBlock ifNil: [ initializationVisusBlock := [  ] ]
]

{ #category : #accessing }
CPPSArchitectureBrowserState >> initializationVisusBlock: anObject [

	initializationVisusBlock := anObject
]

{ #category : #api }
CPPSArchitectureBrowserState >> initializeVisus: visualizations for: aComponent [

	^ self initializationVisusBlock
		  cull: visualizations
		  cull: aComponent
]

{ #category : #accessing }
CPPSArchitectureBrowserState >> label [

	^ label
]

{ #category : #accessing }
CPPSArchitectureBrowserState >> label: anObject [

	label := anObject
]

{ #category : #printing }
CPPSArchitectureBrowserState >> printOn: aStream [

	super printOn: aStream.
	aStream
		<< $[;
		<< (self label ifNil: [ 'No Label' ]);
		<< $]
]
