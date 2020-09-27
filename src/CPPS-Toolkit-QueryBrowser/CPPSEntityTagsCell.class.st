"
Description
--------------------

I am a reaaaaaally simple component to show the number of tags of an entity and to display them in a tooltip.

I was created in order to be used inside a MDLSortableTable whithout breaking it.
"
Class {
	#name : #CPPSEntityTagsCell,
	#superclass : #CPPSAbstractEntityCell,
	#category : #'CPPS-Toolkit-QueryBrowser-TagManager'
}

{ #category : #comparing }
CPPSEntityTagsCell >> < aCell [

	^ self size < aCell size
]

{ #category : #rendering }
CPPSEntityTagsCell >> renderContentOn: html [

	| id |

	html span
		id: (id := html nextId);
		with: (self tagsStringOfEntity ifEmpty:
					 [ self
						 english: 'No tag'
						 french: 'Pas de tag'
					 ]).
	self
		renderTooltipFor: id
		on: html
]

{ #category : #rendering }
CPPSEntityTagsCell >> renderTooltipFor: id on: html [

	entity tags ifEmpty: [ ^ self ].
	html
		mdlLargeTooltipFor: id
		with: (String streamContents:
				 [ :s | 
				 s
					 << (self
							  english: 'Tags of '
							  french: 'Tags de ');
					 << entity name;
					 << $:;
					 space;
					 << self tagsStringOfEntity;
					 << $.
				 ])
]

{ #category : #accessing }
CPPSEntityTagsCell >> size [

	^ entity tags size
]

{ #category : #rendering }
CPPSEntityTagsCell >> tagsStringOfEntity [

	^ ' - ' join: ((entity tags sort: #name ascending) collect: #name)
]
