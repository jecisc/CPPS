Class {
	#name : #CPPSAbstractPresenter,
	#superclass : #SpPresenter,
	#category : #'CPPS-Toolkit-Server'
}

{ #category : #'instance creation' }
CPPSAbstractPresenter class >> open [

	<script>
	^ self new openWithSpec
]

{ #category : #'instance creation' }
CPPSAbstractPresenter class >> openFull [

	<script>
	^ self new openWorldWithSpec
]

{ #category : #specs }
CPPSAbstractPresenter class >> title [

	^ 'Siemens Toolkit'
]

{ #category : #initialization }
CPPSAbstractPresenter >> initialize [
	PolymorphSystemSettings uiThemeClass = PharoLightTheme ifFalse: [ PolymorphSystemSettings uiThemeClass: PharoLightTheme ].
	super initialize
]
