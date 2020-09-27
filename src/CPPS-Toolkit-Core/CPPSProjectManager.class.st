"
Description
--------------------

I am a work in progress. I manage an a component used to manage  a project.  

I should render some components link to the project. For now I only have a component to create a new version but this should evolved latter.

Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	versionCreationComponent:		<aComponent> 	I am an instance of a CPPSVersionCreationComponent that allow the user to create a new version.
"
Class {
	#name : #CPPSProjectManager,
	#superclass : #CPPSComponent,
	#instVars : [
		'versionCreationComponent',
		'versionChooserComponent',
		'saveModelComponent',
		'tagExportImportComponent',
		'disableTagRefreshComponent'
	],
	#category : #'CPPS-Toolkit-Core-Core'
}

{ #category : #accessing }
CPPSProjectManager class >> browserName [

	^ 'Project manager' french: 'Gestionnaire du projet'
]

{ #category : #accessing }
CPPSProjectManager >> children [

	^ Array
		  with: self versionCreationComponent
		  with: self versionChooserComponent
		  with: self tagExportImportComponent
		  with: self saveModelComponent
]

{ #category : #accessing }
CPPSProjectManager >> componentsToRender [

	| comps |

	comps := OrderedCollection withAll: { 
			         self tagExportImportComponent.
			         self versionChooserComponent.
			         self versionCreationComponent.
			         self saveModelComponent.
			         self disableTagRefreshComponent }.
	^ comps
]

{ #category : #accessing }
CPPSProjectManager >> disableTagRefreshComponent [

	^ disableTagRefreshComponent
]

{ #category : #accessing }
CPPSProjectManager >> disableTagRefreshComponent: anObject [

	disableTagRefreshComponent := anObject
]

{ #category : #initialization }
CPPSProjectManager >> initialize [

	super initialize.
	self flag: #todo. "This class need some refactoring because we add too much components by hand."
	self
		versionCreationComponent: (self newVersionCreationComponentFrom: CPPSVersionCreationTask);
		versionChooserComponent: CPPSVersionChooserComponent new;
		saveModelComponent: CPPSSaveModelComponent new;
		tagExportImportComponent: CPPSTagExportImportComponent new;
		disableTagRefreshComponent: CPPSDisableTagRefreshComponent new
]

{ #category : #initialization }
CPPSProjectManager >> newVersionCreationComponentFrom: aComponentClass [

	^ aComponentClass project: self currentUser project
]

{ #category : #rendering }
CPPSProjectManager >> renderContentOn: html [

	html div
		class: 'projectManager';
		with:
			[ self currentUser hasVersionAvailable
				ifFalse: [ html render: self versionCreationComponent ]
				ifTrue:
					[ html mdlGrid:
							[ self componentsToRender do:
									[ :component | 
									html
										mdlCellDesktop: 6
										tablet: 4
										phone: 4
										with: [ html render: component ]
									]
							]
					]
			]
]

{ #category : #accessing }
CPPSProjectManager >> saveModelComponent [

	^ saveModelComponent
]

{ #category : #accessing }
CPPSProjectManager >> saveModelComponent: anObject [

	saveModelComponent := anObject
]

{ #category : #private }
CPPSProjectManager >> shouldSelectTechnology [

	^ self server allowsMultipleTechnologies and: [ self technologyChooserComponent selectedTechnology isNil ]
]

{ #category : #accessing }
CPPSProjectManager >> tagExportImportComponent [

	^ tagExportImportComponent
]

{ #category : #accessing }
CPPSProjectManager >> tagExportImportComponent: anObject [

	tagExportImportComponent := anObject
]

{ #category : #accessing }
CPPSProjectManager >> versionChooserComponent [

	^ versionChooserComponent
]

{ #category : #accessing }
CPPSProjectManager >> versionChooserComponent: anObject [

	versionChooserComponent := anObject
]

{ #category : #accessing }
CPPSProjectManager >> versionCreationComponent [

	^ versionCreationComponent
]

{ #category : #accessing }
CPPSProjectManager >> versionCreationComponent: aComponent [

	versionCreationComponent := aComponent
]
