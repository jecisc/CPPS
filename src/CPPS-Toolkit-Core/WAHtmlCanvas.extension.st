Extension { #name : #WAHtmlCanvas }

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> description [
	^ self paragraph
		class: #description;
		yourself
]

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> description: aBlock [
	^ self description
		  with: aBlock;
		  yourself
]

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> divClass: aSymbole with: aBlock [

	^ self div
		  class: aSymbole;
		  with: aBlock;
		  yourself
]

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> formContainer [

	^ self div
		  class: 'form-flex';
		  yourself
]

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> formContainer: aBlock [

	^ self formContainer
		  with: aBlock;
		  yourself
]

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> headerContainer [

	^ self div
		  class: 'title-container';
		  yourself
]

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> headerContainer: aBlock [

	^ self headerContainer
		  with: aBlock;
		  yourself
]

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> headline [

	^ self div
		  mdlTypographyHeadline;
		  mdlTextColorPrimary;
		  yourself
]

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> headline: aBlock [

	^ self headline
		  with: aBlock;
		  yourself
]

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> hr [

	^ self tag: #hr
]

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> leftPanel: aBlock [

	^ self leftPanel
		  with: aBlock;
		  yourself
]

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> mdlLargeTooltipFor: anId with: aString [

	^ self mdlTooltip
		  large;
		  for: anId;
		  with: aString
]

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> mdlMajorAnchorButton [

	^ self mdlAnchorButton
		  accentColor;
		  raised;
		  rippleEffect;
		  yourself
]

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> mdlMajorButton [

	^ self mdlButton
		  accentColor;
		  raised;
		  rippleEffect;
		  yourself
]

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> mdlMajorButton: aBlock [

	^ self mdlMajorButton
		  with: aBlock;
		  yourself
]

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> mdlRadioContainerFor: anId with: aBlock [

	^ self mdlRadioContainer
		  for: anId;
		  rippleEffect;
		  with: aBlock;
		  yourself
]

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> mdlSubmitButton [

	^ self mdlMajorButton
		  beSubmit;
		  yourself
]

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> mdlSubmitButton: aBlock [

	^ self mdlSubmitButton
		  with: aBlock;
		  yourself
]

{ #category : #'*CPPS-Toolkit-Core' }
WAHtmlCanvas >> mdlSubmitButton: aBlock callback: aBlock2 [

	^ self mdlSubmitButton
		  callback: aBlock2;
		  with: aBlock;
		  yourself
]
