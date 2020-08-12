"
A SynectiqueQuickAttributeTaggingVisualization is a visualization that show all methods of a class with attributes they access and allow you to tag/detag each one.

Instance Variables
	classToAnalyze:		<Object>

classToAnalyze
	- xxxxx

"
Class {
	#name : #CPPSQuickAttributeTaggingVisualization,
	#superclass : #CPPSSimpleClassSplitterVisualization,
	#category : #'CPPS-Visualizations-Visualizations-ClassSplitter'
}

{ #category : #building }
CPPSQuickAttributeTaggingVisualization >> buildLegend [

	super buildLegend.
	self legend descriptionForWidth: (self translate: ('Number of local methods accessing' french: 'Nombre de méthodes locales accèdant'))
]

{ #category : #building }
CPPSQuickAttributeTaggingVisualization >> buildVisualization [

	super buildVisualization.
	self title: 'Accessed attributes by methods for class: ' , self classToAnalyze name. "Class"
	(self > #class) styleSheet
		backgroundColor: [ :anEntity | self backgroundColorStrategy colorFor: anEntity ];
		labelSize: 10.
	(self > #class) styleSheet > #children width: [ :attr | 1 + (attr localAccesses collectAsSet: #accessor) size * 3 ]
]

{ #category : #accessing }
CPPSQuickAttributeTaggingVisualization >> containedEntitiesOf: anEntity [

	^ anEntity dataEntitiesForQuickTagging sorted: #name ascending
]

{ #category : #accessing }
CPPSQuickAttributeTaggingVisualization >> entitiesToShow [

	^ self classToAnalyze dataAccessorsForQuickTagging
]

{ #category : #interaction }
CPPSQuickAttributeTaggingVisualization >> popUpTextForNode: node withChild: attr [

	^ String streamContents:
		  [ :s | 
		  | localAccesses externalAccesses |

		  localAccesses := attr localAccesses.
		  externalAccesses := attr globalAccesses.
		  s
			  << '<div style=""> Accesses for <strong>';
			  << attr name;
			  << '</strong>: <br><br><table><tr><td>';
			  << (node parentNode entity accesses count: [ :a | a variable = attr ]) asString;
			  << '</td><td>access from</td><td>this method (';
			  << node parentNode entity name;
			  << ')</td></tr><tr><td>';
			  << localAccesses size asString;
			  << '</td><td>access from</td><td>';
			  << (localAccesses collectAsSet: #accessor) size asString;
			  << ' local methods</td></tr><tr><td>';
			  << externalAccesses size asString;
			  << '</td><td>access from</td><td>';
			  << (externalAccesses collectAsSet: #accessor) size asString;
			  << ' external methods</td></tr>';
			  << '</table>';
			  << '</div>'
		  ]
]
