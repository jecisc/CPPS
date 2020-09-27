"
Description
--------------------

I am a Seaside decorator to add a title to a component and optionnaly a badge with a data.

Examples
--------------------

	WAComponent new
		addDecoration: (CPPSTitleDecoration entitled: 'My title');
		yourself.
		
	WAComponent new
		addDecoration: (CPPSTitleDecoration entitled: 'My title' badgeBlock: [self methods size]);
		yourself.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	badgeBlock:		<aBlockOrSymbol>		I am a block that return the value of the optional badge.
	title:			<aString>				I am the title of the component.
"
Class {
	#name : #CPPSTitleDecoration,
	#superclass : #WADecoration,
	#instVars : [
		'title',
		'badgeBlock',
		'tooltip'
	],
	#category : #'CPPS-Toolkit-Core-Decorator'
}

{ #category : #'instance creation' }
CPPSTitleDecoration class >> entitled: aString [

	^ self
		  entitled: aString
		  badgeBlock: nil
]

{ #category : #'instance creation' }
CPPSTitleDecoration class >> entitled: aString badgeBlock: aBlock [

	^ self new
		  title: aString;
		  badgeBlock: aBlock;
		  yourself
]

{ #category : #'instance creation' }
CPPSTitleDecoration class >> entitled: aString badgeBlock: aBlock tooltip: aStringOrBlock [

	^ self new
		  title: aString;
		  badgeBlock: aBlock;
		  tooltip: aStringOrBlock;
		  yourself
]

{ #category : #'instance creation' }
CPPSTitleDecoration class >> entitled: aString tooltip: aStringOrBlock [

	^ self
		  entitled: aString
		  badgeBlock: nil
		  tooltip: aStringOrBlock
]

{ #category : #accessing }
CPPSTitleDecoration >> badgeBlock [

	^ badgeBlock
]

{ #category : #accessing }
CPPSTitleDecoration >> badgeBlock: anObject [

	badgeBlock := anObject
]

{ #category : #rendering }
CPPSTitleDecoration >> renderContentOn: html [

	| id |

	id := html nextId.
	html div
		class: 'titledComponent';
		with:
			[ html div
				class: 'title';
				id: id;
				mdlTypographyTextCenter;
				mdlTypographyTextUppercase;
				with:
					[ self badgeBlock
						ifNil: [ html render: self title ]
						ifNotNil:
							[ :block | 
							| number |

							number := block value asString.
							html mdlBadge
								dataBadge: number;
								adaptTo: number;
								with: [ html render: self title ]
							]
					].
			html div
				class: 'component';
				with: [ super renderContentOn: html ]
			].
	self
		renderTooltipFor: id
		on: html
]

{ #category : #rendering }
CPPSTitleDecoration >> renderTooltipFor: anId on: html [

	self tooltip ifNil: [ ^ self ].
	html
		mdlLargeTooltipFor: anId
		with: (self tooltip isBlock
				 ifTrue: [ self tooltip cull: html ]
				 ifFalse: [ self tooltip ])
]

{ #category : #accessing }
CPPSTitleDecoration >> title [

	^ title
]

{ #category : #accessing }
CPPSTitleDecoration >> title: anObject [

	title := anObject
]

{ #category : #accessing }
CPPSTitleDecoration >> tooltip [

	^ tooltip
]

{ #category : #accessing }
CPPSTitleDecoration >> tooltip: anObject [

	tooltip := anObject
]
