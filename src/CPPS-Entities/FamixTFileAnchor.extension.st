Extension { #name : #FamixTFileAnchor }

{ #category : #'*CPPS-Entities' }
FamixTFileAnchor >> gtInspectorCompleteSourceTextIn: composite [
	<gtInspectorPresentationOrder: 20>
	composite text
		title: 'Complete source code';
		format: [ self completeText ];
		when: [ self completeText notEmpty ];
		withLineNumbers: true
]

{ #category : #'*CPPS-Entities' }
FamixTFileAnchor >> gtInspectorSourceTextIn: composite [
	<gtInspectorPresentationOrder: 25>
	composite text
		title: 'Source code';
		format: [ self sourceText ];
		when: [ self sourceText notEmpty ];
		withLineNumbers: true
]
