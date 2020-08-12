"
Description
--------------------

I am a telescope action to tag and untag entities.
"
Class {
	#name : #CPPSTagAction,
	#superclass : #TLNodeAction,
	#instVars : [
		'tag'
	],
	#category : #'CPPS-Visualizations-Core'
}

{ #category : #'instance creation' }
CPPSTagAction class >> tag: aTag [

	^ self new
		  tag: aTag;
		  yourself
]

{ #category : #action }
CPPSTagAction >> actionOn: aTLDrawable [

	aTLDrawable entity toggleTag: self tag value.
	aTLDrawable requireUpdate
]

{ #category : #accessing }
CPPSTagAction >> tag [

	^ tag
]

{ #category : #accessing }
CPPSTagAction >> tag: aTag [

	tag := aTag
]
