"
Description
--------------------

The component provides a list of tags. The user can select one tag and apply it to several entities at once in a visualization.
"
Class {
	#name : #CPPSSelectTagComponent,
	#superclass : #CPPSAbstractArchitectureRightPanel,
	#category : #'CPPS-Toolkit-ArchitectureSimulation'
}

{ #category : #'instance creation' }
CPPSSelectTagComponent class >> owner: anOwner [

	^ self new
		  owner: anOwner;
		  yourself
]

{ #category : #accessing }
CPPSSelectTagComponent >> filteredTags [

	^ self tagModel rootTags
]

{ #category : #rendering }
CPPSSelectTagComponent >> renderContentOn: html [

	self selectedTag: nil.
	html div
		class: #'architecture-tags';
		with:
			[ html
				render: self categoryEditorComponent;
				render: self newTagComponent.
			html div
				id: #'architecture-tags_select-list-component';
				with: [ html render: self tagListComponent ]
			]
]
