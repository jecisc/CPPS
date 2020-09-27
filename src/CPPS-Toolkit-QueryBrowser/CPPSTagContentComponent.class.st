"
Description
-------------------

I am a component to display the content of a tag to the user.

I will display the entities tagged by the current tag and I will let the user delete the ones he want. 

Internal Representation and Key Implementation Points.
-----------------

    Instance Variables
	tableComponent:		<aComponent> 	The table displaying the content of the tag paginated
"
Class {
	#name : #CPPSTagContentComponent,
	#superclass : #CPPSTagBrowserComponent,
	#instVars : [
		'tableComponent'
	],
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #components }
CPPSTagContentComponent >> defaultTableComponent [

	^ MDLSortableTable new
		  header: { 
				  (self
					   english: 'Name'
					   french: 'Nom').
				  (self
					   english: 'Kind'
					   french: 'Type').
				  (self
					   english: 'Tags'
					   french: 'Tags').
				  (self
					   english: 'Delete'
					   french: 'Supprimer') };
		  rows: [ (self tag taggedEntitiesInModel: self model) collect: [ :entity | self tableRowElementsFor: entity ] ];
		  rowsPerPagePossibilities: #( 10 50 100 200 )
]

{ #category : #javascript }
CPPSTagContentComponent >> jsUpdateRightPanelOn: html [

	^ self owner jsUpdateRightPanelOn: html
]

{ #category : #rendering }
CPPSTagContentComponent >> renderComponentOn: html [

	html div
		class: #form;
		class: #'tag-table';
		id: self tableContenerId;
		with: [ self renderTableOn: html ]
]

{ #category : #rendering }
CPPSTagContentComponent >> renderTableOn: html [

	html render: self tableComponent
]

{ #category : #accessing }
CPPSTagContentComponent >> tableComponent [

	^ tableComponent ifNil: [ tableComponent := self defaultTableComponent "Use ajax to not reload the page" ]
]

{ #category : #accessing }
CPPSTagContentComponent >> tableComponent: anObject [

	tableComponent := anObject
]

{ #category : #accessing }
CPPSTagContentComponent >> tableContenerId [

	^ #'tag-list__table'
]

{ #category : #accessing }
CPPSTagContentComponent >> tableRowElementsFor: anEntity [

	^ { 
		  (CPPSEntityNameCell entity: anEntity).
		  anEntity class englishName.
		  (CPPSEntityTagsCell entity: anEntity).
		  (CPPSDeleteTagCell
			   entity: anEntity
			   from: self) }
]

{ #category : #accessing }
CPPSTagContentComponent >> title [

	^ self
		  english: 'Tagged entities'
		  french: 'Entités taggés'
]
