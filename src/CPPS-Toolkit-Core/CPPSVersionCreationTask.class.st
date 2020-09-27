"
Description
--------------------

I am responsible  for  distributing the rendering  of the ""version creation"" screen to the involved seaside components.
I know the first seaside component to call.
Then I wait for the component answer, which is expected a seaside component OR nil.
As long as the answer is a seaside component, I loop over the  above mechanism.
"
Class {
	#name : #CPPSVersionCreationTask,
	#superclass : #WATask,
	#instVars : [
		'project',
		'nextComponent'
	],
	#category : #'CPPS-Toolkit-Core-Components'
}

{ #category : #'instance creation' }
CPPSVersionCreationTask class >> project: aProject [

	^ self new
		  project: aProject;
		  yourself
]

{ #category : #accessing }
CPPSVersionCreationTask >> componentToDisplay [

	^ self isGenerationInProgress
		  ifTrue:
			  [ "we do not allow parallel version creation.
				if at least one generation is in progress, we display a progress bar "
			  CPPSVersionCreationProgressComponent
				  titled: (self
						   english: 'A version is in generation.'
						   french: 'Une version est en cours de génération.')
				  message: (self
						   english: 'A version creation for this project is already in progress. Page will refresh once the generation is done.'
						   french: 'Une creation de version pour ce projet est deja en cours. La page se rechargera a la fin de la generation')
				  during: [ [ self isGenerationInProgress ] whileTrue: [ (Delay forSeconds: 5) wait ] ]
			  ]
		  ifFalse: [ CPPSTechnologyChooserComponent new ]
]

{ #category : #convenience }
CPPSVersionCreationTask >> english: aString french: aTranslation [

	^ self translate: (aString french: aTranslation)
]

{ #category : #running }
CPPSVersionCreationTask >> go [

	| currentComponent |

	currentComponent := self componentToDisplay.
	nextComponent := self call: currentComponent.
	[ nextComponent isNotNil ] whileTrue:
		[ nextComponent isClass ifTrue: [ nextComponent := nextComponent new ].
		nextComponent := self call: nextComponent
		]
]

{ #category : #testing }
CPPSVersionCreationTask >> isGenerationInProgress [

	^ self project generationInProgress
]

{ #category : #accessing }
CPPSVersionCreationTask >> project [

	^ project
]

{ #category : #accessing }
CPPSVersionCreationTask >> project: aProject [

	project := aProject
]
