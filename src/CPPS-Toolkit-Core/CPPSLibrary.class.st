"
Description
--------------------

I am the library that contains all the ressources of the web solution.
"
Class {
	#name : #CPPSLibrary,
	#superclass : #WAFileLibrary,
	#category : #'CPPS-Toolkit-Core-Core'
}

{ #category : #'scripts - sass' }
CPPSLibrary class >> cssName [

	^ 'siemensToolkit'
]

{ #category : #'scripts - sass' }
CPPSLibrary class >> deployFiles [

	<script>
	self deploySassFiles.
	self deployJavascriptFiles
]

{ #category : #'scripts - sass' }
CPPSLibrary class >> deployJavascriptFiles [

	<script>
	(FileSystem workingDirectory / self sassFolderName) ensureCreateDirectory.
	(self methods select: [ :m | m protocol = #javascript ]) do:
		[ :each | 
		(FileSystem workingDirectory / self sassFolderName / (self default asFilename: each selector))
			ensureDelete;
			ensureCreateFile;
			writeStreamDo:
				[ :s | 
				s << ((self default perform: each selector)
						 copyReplaceAll: String cr
						 with: String lf)
				]
		]
]

{ #category : #'scripts - sass' }
CPPSLibrary class >> deploySassFiles [

	<script>
	(FileSystem workingDirectory / self sassFolderName) ensureCreateDirectory.
	(self methods select: [ :m | m protocol = #sass ]) do:
		[ :each | 
		(FileSystem workingDirectory / self sassFolderName / (self default asFilename: each selector))
			ensureDelete;
			ensureCreateFile;
			writeStreamDo:
				[ :s | 
				s << ((self default perform: each selector)
						 copyReplaceAll: String cr
						 with: String lf)
				]
		]
]

{ #category : #'scripts - sass' }
CPPSLibrary class >> generateAndImportFiles [

	<script>
	self generateCssFile.
	self importSassFiles.
	(Delay forMilliseconds: 1200) wait.
	self importCssFile
]

{ #category : #'scripts - sass' }
CPPSLibrary class >> generateCssFile [

	<script>
	SICommand default
		executeCommand: 'sass'
		arguments: { 
				(self sassFolderName , '/' , self cssName , '.sass').
				(self sassFolderName , '/' , self cssName , '.css').
				'--style=compressed' }
]

{ #category : #'scripts - sass' }
CPPSLibrary class >> importCssFile [

	<script>
	| file contents |

	file := FileSystem workingDirectory / self sassFolderName / (self cssName , '.css').
	contents := file contents.
	"remove map to avoid http error. Mapping sourcing is usefull for debbug but it's useless in CSS"
	contents lines last = '/*# sourceMappingURL=siemensToolkit.css.map */' ifTrue: [ contents := contents lines allButLast reduce: [ :previous :current | previous , current ] ].
	self
		addFileNamed: file basename
		contents: contents.
	self methods
		detect: [ :m | m selector = (self default asSelector: file basename) ]
		ifFound: [ :m | m protocol: #css ]
]

{ #category : #'scripts - sass' }
CPPSLibrary class >> importFiles [

	"You can use me if you use this command to generate the sass: 
	 sass --watch siemensToolkit.sass:siemensToolkit.css --style=compressed"

	<script>
	self importSassFiles.
	self importCssFile.
	self importJavascriptFiles
]

{ #category : #'scripts - sass' }
CPPSLibrary class >> importJavascriptFiles [

	<script>
	(FileSystem workingDirectory / self sassFolderName allChildrenMatching: '*.js') do:
		[ :file | 
		| fileName |

		fileName := self default asSelector: file basename.
		self
			compileText: file contents
			selector: fileName.
		self methods
			detect: [ :m | m selector = fileName ]
			ifFound: [ :m | m protocol: #javascript ]
		]
]

{ #category : #'scripts - sass' }
CPPSLibrary class >> importSassFiles [

	<script>
	| directory |

	directory := FileSystem workingDirectory.
	(directory / self sassFolderName allChildrenMatching: '*.sass') , (directory / self sassFolderName allChildrenMatching: '*.yml') do:
		[ :file | 
		| fileName |

		fileName := self default asSelector: file basename.
		self
			compileText: file contents
			selector: fileName.
		self methods
			detect: [ :m | m selector = fileName ]
			ifFound: [ :m | m protocol: #sass ]
		]
]

{ #category : #'world menu' }
CPPSLibrary class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #'Export file library')
		order: 100;
		parent: #SiemensToolkit;
		action: [ self deployFiles ];
		icon: Smalltalk ui icons bottom.
	(aBuilder item: #'Import file library')
		order: 105;
		parent: #SiemensToolkit;
		action: [ self importFiles ];
		icon: Smalltalk ui icons top.
	(aBuilder item: #'Generate SASS')
		order: 110;
		parent: #SiemensToolkit;
		action: [ self generateCssFile ];
		icon: Smalltalk ui icons glamorousRefresh
]

{ #category : #'scripts - sass' }
CPPSLibrary class >> openGenerationButton [

	<script>
	SimpleButtonMorph new
		color: Smalltalk ui theme buttonColor;
		label: 'Import SASS';
		target: self;
		actionSelector: #generateAndImportFiles;
		extent: 100 @ 25;
		position: 800 @ 0;
		openInWorld
]

{ #category : #'scripts - sass' }
CPPSLibrary class >> openImportButton [

	<script>
	SimpleButtonMorph new
		color: Smalltalk ui theme buttonColor;
		label: 'Import';
		target: self;
		actionSelector: #importFiles;
		extent: 100 @ 25;
		position: 800 @ 0;
		openInWorld
]

{ #category : #'scripts - sass' }
CPPSLibrary class >> sassFolderName [

	^ 'toolkitCss'
]

{ #category : #javascript }
CPPSLibrary >> FileSaverMinJs [
	^ '/*! @source http://purl.eligrey.com/github/FileSaver.js/blob/master/FileSaver.js */
var saveAs=saveAs||function(e){"use strict";if(typeof e==="undefined"||typeof navigator!=="undefined"&&/MSIE [1-9]\./.test(navigator.userAgent)){return}var t=e.document,n=function(){return e.URL||e.webkitURL||e},r=t.createElementNS("http://www.w3.org/1999/xhtml","a"),o="download"in r,a=function(e){var t=new MouseEvent("click");e.dispatchEvent(t)},i=/constructor/i.test(e.HTMLElement)||e.safari,f=/CriOS\/[\d]+/.test(navigator.userAgent),u=function(t){(e.setImmediate||e.setTimeout)(function(){throw t},0)},s="application/octet-stream",d=1e3*40,c=function(e){var t=function(){if(typeof e==="string"){n().revokeObjectURL(e)}else{e.remove()}};setTimeout(t,d)},l=function(e,t,n){t=[].concat(t);var r=t.length;while(r--){var o=e["on"+t[r]];if(typeof o==="function"){try{o.call(e,n||e)}catch(a){u(a)}}}},p=function(e){if(/^\s*(?:text\/\S*|application\/xml|\S*\/\S*\+xml)\s*;.*charset\s*=\s*utf-8/i.test(e.type)){return new Blob([String.fromCharCode(65279),e],{type:e.type})}return e},v=function(t,u,d){if(!d){t=p(t)}var v=this,w=t.type,m=w===s,y,h=function(){l(v,"writestart progress write writeend".split(" "))},S=function(){if((f||m&&i)&&e.FileReader){var r=new FileReader;r.onloadend=function(){var t=f?r.result:r.result.replace(/^data:[^;]*;/,"data:attachment/file;");var n=e.open(t,"_blank");if(!n)e.location.href=t;t=undefined;v.readyState=v.DONE;h()};r.readAsDataURL(t);v.readyState=v.INIT;return}if(!y){y=n().createObjectURL(t)}if(m){e.location.href=y}else{var o=e.open(y,"_blank");if(!o){e.location.href=y}}v.readyState=v.DONE;h();c(y)};v.readyState=v.INIT;if(o){y=n().createObjectURL(t);setTimeout(function(){r.href=y;r.download=u;a(r);h();c(y);v.readyState=v.DONE});return}S()},w=v.prototype,m=function(e,t,n){return new v(e,t||e.name||"download",n)};if(typeof navigator!=="undefined"&&navigator.msSaveOrOpenBlob){return function(e,t,n){t=t||e.name||"download";if(!n){e=p(e)}return navigator.msSaveOrOpenBlob(e,t)}}w.abort=function(){};w.readyState=w.INIT=0;w.WRITING=1;w.DONE=2;w.error=w.onwritestart=w.onprogress=w.onwrite=w.onabort=w.onerror=w.onwriteend=null;return m}(typeof self!=="undefined"&&self||typeof window!=="undefined"&&window||this.content);if(typeof module!=="undefined"&&module.exports){module.exports.saveAs=saveAs}else if(typeof define!=="undefined"&&define!==null&&define.amd!==null){define("FileSaver.js",function(){return saveAs})}'
]

{ #category : #sass }
CPPSLibrary >> architecturalVisionSass [
	^ '@import "variables"

.architectural-vision
  +box
  +displayFlex
  flex-wrap: nowrap

  .architectural-vision__visualization
    height: calc(100% - 69px)
    margin-bottom: 20px
    position: relative

    .architecture-drill-down
      +abs-pos(5px, auto, auto, 155px)
      z-index: 2
'
]

{ #category : #sass }
CPPSLibrary >> architectureSass [
	^ '@import "variables"

.architecture
  +displayFlex
  +box
  +flexDirection(column)

  .architecture-menu
    +displayFlex
    align-items: center
    justify-content: space-between
    background-color: #FFF
    z-index: 2

    .architecture-menu__selection-item
      +displayFlex
      align-items: center

      form
        margin-left: 10px

    .mdl-textfield
      padding: 20px 0 0 0

      .mdl-textfield__label::after
        bottom: 0

    .architecture-menu__mode
      width: 150px

    i
      &:not(.mdl-icon-toggle__label)
        cursor: pointer

    .architecture-menu__right
      +displayFlex
      padding-left: 10px
      border-left: 1px solid $borderColor
      align-items: center

      &> *
        padding-right: 30px

  .architecture-content
    +displayFlex
    +flexGrow
    height: 100px
    min-height: 100px
    z-index: 1

    .architecture-drill-down
      +abs-pos(5px, auto, auto, 155px)
      z-index: 2

  .architecture-new__form
    button
      display: inline-block

    .architecture-new__radio
      label
        display: block
        text-align: left

    .architecture-new__option-duplication
      text-align: center
      width: 100%

    .cancel
      align-self: end

  #architecture-grid
    padding: 0
    position: relative

    .mdl-cell
      margin: 0
      box-shadow: -2px 0px 3px 0 $borderColor
      position: relative

    .architecture-grid__fab
      +abs-pos(auto, -23px, 0)

  #architecture-right-panel
    +box(30%, 100%)
    overflow: hidden
    max-width: 400px

    &:hover
      overflow-y: auto

    .mdl-textfield
      width: 100%

    .new-simple-tag > div > form
      +flexGrow
'
]

{ #category : #images }
CPPSLibrary >> buttonPng [

	^ #[ 137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 11 0 0 0 11 8 6 0 0 0 169 172 119 38 0 0 0 25 116 69 88 116 83 111 102 116 119 97 114 101 0 65 100 111 98 101 32 73 109 97 103 101 82 101 97 100 121 113 201 101 60 0 0 0 136 73 68 65 84 120 218 180 145 209 9 195 48 12 68 207 66 222 195 224
	     207 110 98 50 80 70 232 64 38 219 24 60 137 92 93 226 143 130 105 67 63 122 240 48 232 142 67 200 161 214 250 0 240 116 138 35 88 101 206 225 236 202 96 206 121 75 41 33 132 176 36 199 24 210 123 223 90 107 103 83 97 112 26 11 212 244 11 155 133 141 102 134 79 18 145 235 193 15 210 183 221 110
	     195 255 107 102 216 120 158 111 225 233 25 215 56 252 142 80 85 196 24 23 56 167 207 28 155 119 30 220 185 253 193 151 0 3 0 182 104 66 243 73 67 114 199 0 0 0 0 73 69 78 68 174 66 96 130 ]
]

{ #category : #images }
CPPSLibrary >> buttonclosedPng [

	^ #[ 137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 11 0 0 0 11 8 6 0 0 0 169 172 119 38 0 0 0 25 116 69 88 116 83 111 102 116 119 97 114 101 0 65 100 111 98 101 32 73 109 97 103 101 82 101 97 100 121 113 201 101 60 0 0 0 162 73 68 65 84 120 218 132 145 205 9 196 32 16 133 71 209 131 177 9 193
	     227 118 34 41 40 37 108 65 146 110 4 123 16 175 186 190 32 139 137 46 59 240 240 231 125 142 227 200 188 247 47 34 122 55 185 38 78 115 148 166 179 233 16 0 173 181 187 49 134 24 99 19 89 107 229 49 198 61 132 112 101 114 0 187 49 9 209 125 7 152 35 227 8 40 165 110 235 126 35 95 213 248 51 196
	     80 27 105 173 191 198 182 109 215 152 115 158 225 209 192 161 17 90 102 126 116 97 9 23 180 103 52 83 74 55 184 207 11 30 120 182 62 146 16 130 164 148 147 176 15 31 28 50 31 104 120 211 223 31 252 8 48 0 91 187 99 207 29 133 44 109 0 0 0 0 73 69 78 68 174 66 96 130 ]
]

{ #category : #images }
CPPSLibrary >> buttonopenPng [

	^ #[ 137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 11 0 0 0 11 8 6 0 0 0 169 172 119 38 0 0 0 25 116 69 88 116 83 111 102 116 119 97 114 101 0 65 100 111 98 101 32 73 109 97 103 101 82 101 97 100 121 113 201 101 60 0 0 0 146 73 68 65 84 120 218 148 145 81 10 3 33 12 68 99 208 47 47 33 248 217
	     155 200 30 104 143 208 3 201 222 70 240 18 254 198 102 90 63 74 67 187 219 129 135 224 12 67 140 174 214 122 35 162 187 82 20 38 43 81 14 101 247 8 230 156 183 148 18 57 231 76 114 206 201 189 247 173 181 246 108 42 8 46 195 0 45 191 160 153 209 40 34 244 77 204 252 58 232 15 249 183 217 40 198
	     104 2 99 12 27 254 52 78 155 175 140 33 88 207 175 240 242 4 15 60 116 143 228 189 167 16 130 1 247 240 145 67 243 142 133 43 167 63 248 16 96 0 220 214 72 212 236 191 224 147 0 0 0 0 73 69 78 68 174 66 96 130 ]
]

{ #category : #images }
CPPSLibrary >> closeIconPng [

	^ #[ 71 73 70 56 57 97 16 0 16 0 145 0 0 0 0 0 255 255 255 51 51 51 255 255 255 33 249 4 1 0 0 3 0 44 0 0 0 0 16 0 16 0 64 2 29 156 143 169 35 45 123 26 146 176 218 107 156 171 155 81 12 134 98 215 65 218 165 125 138 170 138 238 80 0 0 59 ]
]

{ #category : #sass }
CPPSLibrary >> codeAnalyzerSass [
	^ '@import "variables"

.code-analyzer-block-panel
  +box()
  +displayFlex
  flex-direction: column

  .search
    text-align: center

  .code-analyzer-right-panel_code
    +flexGrow
    overflow: hidden

.toFoldContainer
  +displayFlex
  flex-wrap: nowrap

.activeByHand::after
  +box(100%, 2px)
  +abs-pos(auto, auto, 0, 0)
  +transition( all 1s cubic-bezier(.4,0,1,1))
  +animation(border-expand .2s cubic-bezier(.4,0,.4,1).01s alternate forwards)
  display: block
  content: " "
  background: $primaryColor

.code-analyzer
  .withSelect.mdl-tabs__tab
    max-width: 200px
    overflow: visible
    padding: 0

    .mdl-textfield
      line-height: initial

    .mdl-select .mdl-menu__container .mdl-menu .mdl-menu__item
      font-size: 12px

  .code-analyzer-content
    #code-container
      +flexGrow
      height: 1px

    .export-button
      +abs-pos(5px, auto, auto, 150px)
      z-index: 2

  .code-analyzer-info
    +box

    .infoComponent
      border-bottom: 1px solid $accentColor
      box-sizing: border-box

    table
      border:
        right: 0
        left: 0

      td
        max-width: 200px
        overflow: hidden
        text-overflow: ellipsis

    .attributes
      .mdl-grid
        padding: 0

        .mdl-card
          box-shadow: none

  .tag-categories .mdl-dialog
    left: unset
    right: 20px

  #code-analyzer__tag-modal
    dialog
      min-width: 600px

  .prismSelectionMenu
    +border-radius(2px)
    +line-height(24)
    background: $white
    margin: 0
    padding: 8px 0
    box-shadow: 0 1px 6px rgba(0, 0, 0, 0.12), 0 1px 4px rgba(0, 0, 0, 0.12)
    z-index: 1000
    white-space: nowrap
    border: none

    &>div
      border-bottom: 1px solid rgb(224, 224, 224)
      cursor: pointer
      position: relative
      margin-left: 0
      padding: 5px 24px
      transition: all 450ms cubic-bezier(0.23, 1, 0.32, 1) 0ms

      &:hover
        background: rgba(0, 0, 0, 0.1) none repeat scroll 0 0
'
]

{ #category : #sass }
CPPSLibrary >> componentsSass [
	^ '@import "variables"

// Browsers management
.material-design-left-panel
  +box(300px, 100%)
  min-width: 250px

.growing
  +flex(1 1 auto)
  width: 1px

// Filter browser
.filter-browser
  +box
  +displayFlex
  +flexDirection(column)

  &:target
    .toFold
      width: 0

  .filter-browser-core
    +flexGrow
    height: 100px
    min-height: 100px

// Small Component

.smallComponent
  max-width: 500px
  position: relative
  top: 20%
  margin: auto auto 10%
  font-size: 16px

  h2
    +border-radius(7px 7px 0 0)
    font-size: 14px
    margin: 0
    text:
      align: center
      transform: uppercase
    background: $accentColor
    color: #FFF
    font-weight: 300

  .form-wrap
    +box(100%)
    +displayFlex
    +flexDirection(column)
    align-items: center
    position: initial
    background-size: contain
    text-align: center

  .paddedForm
    +border-radius(0 0 7px 7px)
    padding: 20px
    background-color: $white

    .mdl-button--accent
      max-width: 200px
      height: 40px
      bottom: 0
      color:  $white !important

  button, .submit
    display: block
    margin: auto

// Help Icon Component

.helpIcon
  margin: 0 10px

//Element containing code with prism

#code-container
  height: 100%

.code-container
  +box(200px, calc(100% - 40px))
  +flex(1 1 auto)
  margin: auto

  .code-container-panel
    +box(90%, 100%)
    box-shadow: 0 4px 5px 0 rgba(0,0,0,.14),0 1px 10px 0 rgba(0,0,0,.12),0 2px 4px -1px rgba(0,0,0,.2)
    margin: auto

    .code-container-panel__content
      height: calc(100% - 49px)
      +displayFlex
      +flexDirection(column)

      .code-container-panel__options
        +displayFlex
        width: 100%
        justify-content: space-around
        z-index: 3

        .mdl-checkbox
          margin:
            bottom: 3px
            top: 3px
          width: initial

      .minimap-container
        overflow: hidden

      pre
        height: 100%
        margin:
          top: 0
          bottom: 0
        padding:
          top: 0
          bottom: 0
        overflow: hidden

        &:hover
          overflow: auto

//Titled Component

.titledComponent
  $titleComponentHeight: 40px
  +box(100%)
  +box-sizing(border-box)

  .title
    border-bottom: 1px solid $borderColor
    height: $titleComponentHeight
    line-height: $titleComponentHeight
    background-color: $headerBackgroundColor
    color: $primaryColor

  .component
    height: calc(100% - 41px)

// YesNo Component
.yesNo
  width: 50%
  min-width: 200px
  top: 20%
  position: relative
  margin: auto auto 10%
  padding: 20px
  background-color: $white
  border-radius: 7px
  -webkit-border-radius: 7px
  text-align: center

  h3
    position: initial
    font-family: ''Open Sans'', arial, serif
    font-size: 18px
    margin-bottom: 20px
    margin-top: 0

  .dialog-buttons
    +displayFlex
    justify-content: space-around

  .mdl-button--accent
    margin-left: 5%
    margin-right: 5%

  div
    position: initial !important


// Tag Categories Component
.chip-selector
  +border-radius(16px)
  +displayFlex
  width: 90%
  margin: 20px auto
  border: solid 1px $borderColor

  .chip-selector__title
    +font-size(14)
    +font-size(12)
    border-right: 1px solid $borderColor
    color: $grey
    padding: 0 3px

  .chip-selector__content
    +flex(1 1 auto)

    .mdl-chip
      margin: 5px

  .chip-selector__add
    color: $green
    border-left: solid 1px $borderColor

    .mdl-button
      +border-radius(0 16px 16px 0)
      height: 100%

  .chip-selector__title, .chip-selector__content, .chip-selector__add
    +displayFlex
    flex-wrap: wrap

  .chip-selector__title, .chip-selector__add
    +flexDirection(column)
    justify-content: center

  .mdl-dialog
    width: 480px

    .mdl-dialog__content
      text-align: center

    .mdl-textfield
      width: 100%
'
]

{ #category : #sass }
CPPSLibrary >> coreSass [
	^ '@import "variables"

html, body
  +box(100%)
  font-size: 14px
  font-family: $mainFonts
  overflow: hidden

body
  margin-bottom: 0 !important

input
  &:disabled
    cursor: not-allowed

  &[type="color"]
    cursor: pointer

  .material-icons
    vertical-align: middle
    padding-bottom: 6px

.title-container
  width: 80%
  margin: auto auto 10px auto
  text-align: center
  border-bottom: 1px solid $grey400

  div
    margin: 8px 0

  i
    vertical-align: middle

// Some common classes to use

.delete, .query-query-list__actions .delete, .remove, .unmatched
  color: $red

.add, .matched
  color: $green

.defaultIconColor
  color: $blueGrey

.dangerHighlight
  background-color: $red700

.warningHighlight
  background-color: $orange700

.healthyHighlight
  background-color: $green700

.highAttentionHighlight
  background-color: $purple700

.attentionHighlight
  background-color: $blue700

.lowAttentionHighlight
  background-color: $cyan700

.danger
  background-color: $red

  &:hover
    @extend .dangerHighlight

.warning
  background-color: $orange

  &:hover
    @extend .warningHighlight

.healthy
  background-color: $green

  &:hover
    @extend .healthyHighlight

.highAttention
  background-color: $purple

  &:hover
    @extend .highAttentionHighlight

.attention
  background-color: $blue

  &:hover
    @extend .attentionHighlight

.lowAttention
  background-color: $cyan

  &:hover
    @extend .lowAttentionHighlight

.unavailable
  background-color: $purple

  &:hover
    background-color: $purple700

.mdl-alert
  display: inline-block
  border: 0
  border-left: $main-border-thickness solid transparent
  text-align: justify
  max-width: 600px
  margin:
    top: 10px
    bottom: 10px
  padding: 10px

.mdl-alert__default
  +mdl-alert($default-shade1)

.mdl-alert__success
  +mdl-alert($success-shade1)

.mdl-alert__danger
  +mdl-alert($danger-shade1)

.mdl-alert__warning
  +mdl-alert($warning-shade1)

.mdl-alert__primary
  +mdl-alert($primary-shade1)

.mdl-alert__info
  +mdl-alert($info-shade1)

.error-message
  +border-radius(4px)
  color: #a94442
  background-color: #f2dede
  padding: 15px
  margin-bottom: 20px
  border: 1px solid $borderColor

.text-center
  text-align: center

.text-left
  text-align: left

.text-right
  text-align: right

.pull-right
  +clearfix
  float: right

.pull-left
  float: left

.auto-margin
  margin: auto

.grey-background
  background: $blueGrey50

.spacer
  +flexGrow

.form-control
  width: 100%
  font-size: 14px
  color: $grey700

.description
  width: 90%
  margin: auto
  padding:
    bottom: 20px
    top: 10px

.form-flex
  +displayFlex
  flex-wrap: wrap
  justify-content: space-around
  align-items: center

  .mdl-button
    margin: 5px

header
  .logo
    height: 48px !important
    margin-left: 15px

  .browser-name
    +css3(user-select,  none)
    margin-left: 10px
    font-size: 18px

.browser
  +flexGrow
  height: 1px

.loading-container
  +box
  +displayFlex
  align-items: center
  justify-content: center

  .mdl-spinner
    +box(60px)

.mdl-navigation__link--current
  font-weight: bold
  background: #9FA8DA !important
  color: #FFF !important

  &:hover
    background: #7986CB !important

.table-cell
  a
    text-decoration: none
    color: initial

  i
    cursor: pointer

input.toHide
  +abs-pos(0, auto, auto, 0)
  +opacity(0)
  +box(100px, 40px)
  cursor: pointer

.uploadContainer
  +box(100px, 40px)
  position: relative
  display: block
  margin: auto

.right-panel
  .title-container .mdl-typography--headline
    font-size: 18px

  .mdl-radio, .mdl-checkbox__label
    font-size: 14px

// Admin Tools

.adminTools
  +box(100%)
  background: $grey200
  overflow: auto

  .mdl-tabs__panel table
    margin:
      left: auto
      right: auto
      bottom: auto
      top: 30px

    .mdl-data-table__cell--non-numeric
      width: 150px

  .mdl-tabs__tab-bar
    background: $white

  .smallComponent
    top: 10%

.filter-component
  width: 100%
  z-index: 2

  .title
    float: left
    height: 100%
    display: inline-flex

    .mdl-button
      color: $accentColor
      margin: auto

  .mdl-chip
    margin: 5px
    cursor: pointer

  .isActive
    background-color: $accentColorMuchLighter

    &:active
      background-color: $accentColorLighter

    .mdl-chip__contact
      background-color: rgba(251,140,0 ,0.5)

    .mdl-chip__action
      color: #E65100



// Version creation
.versionCreator .dateAndTime
  +displayFlex
  align-items: center
  +flexDirection(column)
  width: 50%
  margin: auto

// Project Manager
.projectManager
  +box(100%)
  background: $grey200
  top: 0
  left: 0
  right: 0
  bottom: 0
  overflow: auto

// Login

.loginPage, .progressComponent
  @extend .grey-background
  +box
  overflow: auto

// Tab Panel
.tabPanel
  +box(100%)

  .mdl-tabs__tab-bar, .mdl-tabs__ripple-container, .mdl-tabs__tab
    height: 58px
    min-height: 58px
    line-height: initial

  .mdl-tabs__tab-bar
    i
      font-size: 20px
      margin: 7px 0 0 0

    .mdl-tabs__tab
      font-size: 12px
      width: 15%
      max-width: 90px
      color: $grey

    p
      margin: 0

  .mdl-tabs__panel
    overflow: auto
    +flex(1 1 auto)
    height: 1px

  .mdl-tabs
    +box(100%)
    +displayFlex
    +flexDirection(column)

  .mdl-checkbox, .mdl-switch
    text-align: initial

  .submit
    margin-top: 20px

  .colorTag
    position: relative

    form
      +abs-pos(15px)
      +opacity(0)
      cursor: pointer
      padding-top: 0

    i
      font-size: 40px !important

//Other

.save-component__path-input
  display: inline-flex

  i
    line-height: 66px

.create-version__persist-sources
  text-align: left
  width: 300px
  margin-bottom: 20px

.toFold
  +transition(width 1s)

.table-toolbar
  +clearfix
  padding: 8px

.button-bar
  +displayFlex
  padding: 20px
  justify-content: flex-end

.flex-bar
  +displayFlex
  padding: 8px

  .text-center
    +flexGrow

  *
    align-self: center
    margin-left: 8px

#root-dialog
  min-width: 800px


.infoComponent
  overflow: hidden

  &:hover
    overflow-y: auto

  .mdl-data-table
    width: 100%
'
]

{ #category : #sass }
CPPSLibrary >> correlationsSass [
	^ '@import "variables"

.correlations
  +box
  +displayFlex
  flex-wrap: nowrap

  .right-panel
    .panel
      overflow: auto
      height: 100%

  .correlations-content
    .mdl-sorted-table        
      td
        i
          width: 100%
          text-align: center'
]

{ #category : #'as yet unclassified' }
CPPSLibrary >> cppLogoPng [

	^ #[ 137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 4 0 0 0 4 0 8 6 0 0 0 127 29 43 131 0 2 57 143 73 68 65 84 120 218 236 253 231 147 28 75 118 231 121 127 221 61 34 82 148 46 104 224 234 238 219 221 108 202 153 229 146 51 28 206 238 60 99 182 255 244 99 54 107 163 200 145 124 40 187 155 87 65
	     23 74 87 106 21 194 207 243 34 50 75 161 32 47 128 11 20 126 31 51 160 180 64 34 195 195 207 241 227 199 157 153 33 34 34 34 34 34 34 34 151 155 215 67 32 34 34 34 34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 136 18 0 34 34 34 34
	     34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 136 18 0 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 136 18 0 34 34 34 34 34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 34 74 0 136 136 136 136 136
	     136 136 136 18 0 34 34 34 34 34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 136 18 0 34 34 34 34 34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34
	     34 34 74 0 136 136 136 136 136 136 136 136 18 0 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 136 18 0 34 34 34 34 34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 136 18 0 34 34 34 34 34 34 34 162 4 128 136 136 136 136 136
	     136 136 40 1 32 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 136 18 0 34 34 34 34 34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 136 18 0 34 34 34 34 34 34 34 162
	     4 128 136 136 136 136 136 136 136 18 0 34 34 34 34 34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 136 18 0 34 34 34 34 34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 40
	     1 32 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 136 18 0 34 34 34 34 34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 136 18 0 34 34 34 34 34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 162 4 128
	     136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 136 18 0 34 34 34 34 34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 136 18 0 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 136 18 0 34
	     34 34 34 34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 136 18 0 34 34 34 34 34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 34 74 0 136 136
	     136 136 136 136 136 136 18 0 34 34 34 34 34 34 34 162 4 128 136 136 136 188 97 119 59 185 221 237 229 166 71 66 68 68 68 78 115 102 154 31 136 136 136 124 136 190 237 96 21 16 66 253 246 112 84 113 212 25 51 154 78 112 222 145 38 1 204 225 240 84 85 73 8 158 102 171 197 234 82 131 70 230 8 1 172
	     4 3 126 125 21 167 71 84 68 68 68 9 0 17 17 17 249 137 124 179 223 179 188 44 41 203 72 89 85 228 21 140 166 48 205 29 69 238 136 128 247 14 115 142 201 180 164 59 24 50 153 230 184 224 73 124 88 220 238 137 101 69 8 142 70 35 163 221 106 211 72 61 193 69 44 130 3 154 13 99 185 13 75 13 112
	     24 33 120 130 15 180 178 148 95 92 95 85 114 64 68 68 68 9 0 17 17 17 121 147 126 183 157 219 120 58 161 63 28 51 158 206 24 140 199 140 166 83 198 147 156 201 36 167 168 160 172 192 92 192 204 19 113 56 28 209 121 42 51 202 24 137 209 192 213 43 255 11 22 35 222 129 115 70 226 3 222 57 28 17
	     204 240 24 222 71 156 131 212 27 14 163 149 165 100 89 96 99 109 153 229 118 155 181 149 37 150 219 109 150 91 9 95 95 207 148 16 16 17 17 81 2 64 68 68 68 94 197 189 195 145 77 139 138 206 40 50 24 85 116 251 19 38 249 140 193 112 194 100 150 51 154 76 25 79 166 76 166 57 211 105 65 57 95 177
	     15 33 1 239 48 2 245 154 61 16 60 62 4 188 119 128 35 158 185 197 27 206 12 139 21 68 195 142 63 104 120 87 39 13 170 202 230 223 201 104 101 9 89 234 89 93 105 179 180 212 98 117 169 205 82 179 69 187 145 112 101 163 193 218 114 96 173 17 32 77 248 217 102 91 9 1 17 17 17 37 0 68 68 68 228
	     188 187 67 172 211 43 56 216 239 176 119 120 196 112 60 165 63 41 41 45 48 43 35 22 35 69 25 169 162 81 84 145 170 170 136 85 164 136 134 69 192 129 247 139 192 191 14 246 235 187 186 195 57 7 222 1 30 59 21 252 3 152 69 156 25 152 157 218 240 239 48 139 216 252 253 96 243 45 0 14 239 28 89 234
	     73 130 39 9 129 196 123 18 15 105 48 146 0 235 75 77 218 75 45 174 95 93 167 213 90 230 230 181 6 95 175 58 37 3 68 68 68 222 83 137 30 2 17 17 145 119 227 219 163 177 13 114 199 206 65 201 193 209 136 253 131 14 219 7 61 134 227 9 147 188 34 73 3 248 80 175 226 187 128 243 30 239 60 62 100
	     184 196 145 185 58 176 63 9 233 23 9 128 121 64 127 42 167 111 110 241 177 211 73 0 195 217 60 93 224 78 109 15 48 192 45 86 255 235 207 53 51 98 132 105 44 176 210 136 86 18 99 133 85 70 89 228 84 85 197 114 187 197 242 210 132 155 253 200 82 107 198 81 127 153 206 213 212 254 236 83 85 4 136
	     136 136 188 143 84 1 32 34 34 242 150 253 255 238 118 172 219 239 243 164 211 103 52 51 122 19 199 120 18 25 79 43 6 147 156 89 21 41 34 4 231 192 123 188 175 131 127 112 120 239 240 206 227 156 225 78 175 246 31 135 234 238 36 29 176 184 165 59 78 133 242 231 110 252 23 254 134 254 220 103
	     215 9 128 186 40 160 2 131 104 17 179 72 140 145 88 86 88 140 36 137 35 203 2 171 205 140 44 9 172 182 3 75 141 200 149 165 192 141 245 101 174 93 93 231 15 63 93 83 50 64 68 68 228 61 161 10 0 17 17 145 183 228 94 39 183 253 195 130 111 31 30 113 208 233 242 100 255 136 89 105 68 2 145 12 210
	     6 46 107 208 112 158 198 188 100 223 112 96 167 98 102 231 142 87 230 13 230 203 245 167 19 0 167 194 250 151 8 181 159 159 246 63 247 115 29 56 194 153 20 129 115 39 125 2 140 136 139 37 195 73 142 183 146 126 175 160 172 10 150 155 41 183 54 39 124 58 172 40 205 219 250 90 131 47 215 212 56
	     80 68 68 68 9 0 17 17 145 75 230 119 59 51 59 236 116 216 62 26 49 28 195 214 65 159 225 120 70 127 10 101 172 131 107 11 224 35 245 158 125 92 93 146 111 231 3 113 227 69 145 189 213 223 238 204 59 78 127 149 157 122 135 155 127 162 61 51 21 224 94 252 62 171 183 23 28 87 9 68 87 231 36 34 80
	     58 202 210 81 89 5 221 41 5 61 70 69 201 202 82 202 238 149 21 91 89 94 230 247 111 54 149 8 16 17 17 81 2 64 68 68 228 195 247 79 123 102 223 61 28 240 104 123 159 157 163 30 70 202 172 52 140 132 70 123 149 100 30 43 27 1 115 129 227 61 253 139 238 126 231 131 115 123 241 154 189 59 21 164
	     219 249 214 127 23 124 189 3 206 110 1 180 51 9 130 243 17 191 187 40 235 176 120 127 72 112 222 225 44 197 101 145 204 34 222 25 185 193 94 111 202 81 127 68 150 6 14 174 231 92 191 2 33 109 216 175 174 168 81 160 136 136 136 18 0 34 34 34 31 168 223 110 119 237 104 80 177 117 144 243 195 227
	     30 251 71 3 14 135 57 33 128 79 82 66 8 36 73 130 57 3 231 136 48 47 245 119 167 194 242 31 207 57 71 140 241 29 252 139 23 39 13 24 184 132 211 93 8 75 139 204 170 138 106 86 82 228 37 129 25 147 34 112 52 50 202 56 99 251 208 219 167 171 109 126 126 83 253 1 68 68 68 148 0 16 17 17 249 128
	     252 237 131 158 125 123 239 9 187 7 99 58 147 72 111 18 41 231 43 254 206 5 204 7 112 80 57 207 188 134 126 254 149 246 70 2 255 243 13 125 157 115 103 222 231 94 176 224 238 94 99 65 254 248 20 2 91 108 67 56 169 67 48 231 112 193 19 124 138 75 82 188 149 76 202 200 126 183 71 62 237 208 78
	     141 131 27 27 12 103 193 254 228 243 101 37 1 68 68 68 148 0 16 17 17 121 191 125 119 48 182 123 219 99 158 236 118 184 247 248 144 131 206 152 220 2 22 26 164 205 37 146 70 99 30 32 215 1 249 34 104 62 137 120 79 58 248 127 184 78 42 24 78 234 14 2 56 135 247 224 67 138 163 36 47 166 76 199
	     83 250 189 9 62 150 12 199 145 81 153 49 204 11 187 181 158 242 179 107 74 4 136 136 136 188 245 187 182 142 1 20 17 17 121 197 192 191 83 217 55 15 246 233 116 7 60 222 237 49 26 151 12 103 37 147 34 18 93 0 151 226 211 12 231 211 227 21 242 139 66 230 218 101 185 15 187 103 254 75 156 139
	     88 85 16 171 28 87 21 56 171 104 103 158 229 102 131 245 213 6 155 43 13 110 93 93 227 87 95 93 231 203 181 68 137 0 17 17 145 183 68 21 0 34 34 34 175 224 191 63 234 219 206 254 148 223 222 59 228 176 211 163 211 27 225 67 74 218 108 19 90 41 14 207 162 52 158 121 99 191 143 35 162 181 103
	     254 59 157 57 156 79 240 33 224 105 226 137 204 138 156 81 111 198 78 119 76 51 77 184 125 84 48 35 208 189 189 108 255 226 198 146 146 0 34 34 34 111 129 42 0 68 68 68 94 194 95 125 179 99 187 7 29 30 30 140 25 231 129 189 126 193 104 146 51 203 35 62 73 72 27 13 8 41 224 192 78 214 195 63 150
	     240 255 185 147 13 230 117 14 245 241 3 56 140 178 42 41 138 18 139 37 1 88 105 122 174 174 37 92 91 205 184 115 109 137 205 245 21 254 242 235 235 122 240 68 68 68 148 0 16 17 17 121 119 254 227 239 142 236 119 223 111 241 100 239 128 131 254 148 164 217 194 194 18 230 2 209 37 24 142 232 192
	     22 93 253 227 201 142 120 167 19 239 206 164 2 108 81 41 224 92 221 39 0 195 83 98 197 132 56 29 144 186 200 181 245 21 110 94 223 224 23 95 221 224 206 141 37 190 94 111 232 65 20 17 17 121 3 180 5 64 68 68 228 2 223 238 205 236 254 147 125 118 59 19 14 186 83 182 15 250 116 71 21 147 34 144
	     57 79 200 28 46 169 131 88 35 96 118 190 4 254 50 52 248 123 91 73 128 250 165 179 58 77 82 153 39 86 158 188 10 80 25 85 119 198 196 250 12 167 57 247 182 26 220 191 182 106 183 174 95 229 15 110 100 74 4 136 136 136 252 152 187 176 42 0 68 68 68 206 250 251 157 210 238 109 117 248 231 239
	     31 114 208 25 18 157 167 36 16 93 32 146 224 205 19 157 195 156 35 226 0 175 7 237 71 137 56 42 156 69 188 51 60 21 193 25 86 76 73 168 184 113 245 10 95 127 241 41 191 248 114 141 223 191 170 38 129 34 34 34 175 75 21 0 34 34 34 115 127 245 237 174 13 243 138 71 7 37 219 123 3 30 239 140 24
	     77 10 124 150 146 100 25 73 218 32 248 132 234 248 43 12 247 156 238 247 242 178 28 134 7 23 168 156 35 175 74 172 42 152 78 192 242 200 184 28 49 139 123 244 39 35 182 54 19 187 190 214 224 79 62 189 162 68 128 136 136 200 171 222 113 85 1 32 34 34 2 255 249 55 219 246 221 131 93 122 163 156
	     206 196 152 148 70 94 56 10 243 68 23 48 18 156 115 156 108 233 95 188 238 48 51 37 1 126 36 179 83 61 19 204 112 84 152 25 222 34 169 143 52 18 79 59 141 172 181 141 59 87 215 248 217 103 183 249 211 47 87 149 4 16 17 17 121 5 170 0 16 17 145 143 214 15 71 19 235 15 167 220 223 27 241 120 235
	     128 251 79 186 140 166 57 179 232 112 73 131 180 177 132 11 217 188 109 157 199 0 59 222 193 110 60 191 199 255 233 148 128 226 212 23 243 199 143 149 185 250 109 231 235 199 109 86 78 25 13 39 28 22 83 246 130 209 29 68 6 179 132 195 97 105 215 54 2 171 237 148 159 111 182 245 32 139 136 136
	     40 1 32 34 34 242 180 223 28 148 118 255 97 151 189 195 14 59 71 3 70 211 146 232 19 146 44 0 1 243 9 248 48 15 243 237 92 64 95 191 190 168 162 123 122 245 63 206 99 254 83 141 0 77 241 233 243 156 84 86 156 52 83 172 31 95 3 31 8 105 3 151 120 60 145 73 97 60 222 237 48 154 76 217 89 77 185
	     185 185 74 110 137 253 250 138 154 4 138 136 136 60 247 126 171 45 0 34 34 242 49 185 219 29 219 238 176 226 254 214 144 111 239 237 179 119 112 196 104 50 37 52 154 100 141 22 206 37 152 243 64 160 154 175 74 215 81 165 63 27 224 63 151 129 91 36 13 230 71 3 42 1 240 154 22 143 99 4 140 0 196
	     188 160 204 39 4 111 52 27 41 55 175 174 242 233 157 117 190 254 100 141 63 255 84 219 2 68 68 68 158 69 21 0 34 34 242 209 248 251 7 29 187 183 115 192 118 119 70 167 31 233 142 102 228 230 177 180 77 76 50 162 75 113 46 204 131 125 119 188 136 239 206 117 249 55 187 248 136 63 119 178 140
	     141 186 2 188 41 139 199 180 254 63 137 64 229 33 38 6 148 204 42 71 119 48 165 120 176 199 176 215 101 119 123 201 62 187 177 201 159 124 190 174 68 128 136 136 136 18 0 34 34 242 49 250 143 191 235 216 15 143 118 249 225 225 14 157 193 20 75 90 184 180 137 111 44 209 244 9 17 135 225 48 115
	     243 208 223 206 132 159 175 31 184 202 143 119 146 128 137 128 75 82 146 36 193 91 137 163 98 52 171 56 234 245 217 217 46 121 188 210 226 240 243 146 81 225 236 223 252 124 77 255 9 34 34 34 74 0 136 136 200 199 224 219 221 169 109 29 118 56 26 228 108 31 140 217 57 232 115 52 172 152 22 30
	     239 61 137 213 165 254 14 143 103 177 251 252 108 204 88 239 148 179 11 2 250 211 111 159 237 9 112 246 227 166 100 192 27 230 240 243 45 22 117 143 134 130 72 17 61 101 233 56 24 149 132 157 30 147 188 228 241 238 158 221 185 190 202 141 141 53 190 190 218 212 127 130 136 136 232 30 170 30 0
	     34 34 114 25 253 183 135 185 221 127 116 192 253 199 59 116 134 99 102 37 148 209 97 36 224 19 162 119 96 30 108 209 117 126 30 252 59 15 207 44 223 127 86 12 169 123 233 187 78 1 64 156 255 111 212 189 1 92 44 113 86 247 10 72 156 17 203 41 169 171 184 125 109 131 47 63 187 205 47 191 188 194
	     31 94 79 149 4 16 17 145 143 154 42 0 68 68 228 82 249 159 15 15 108 247 168 96 107 47 103 107 191 203 65 103 194 120 90 96 33 193 39 9 141 172 65 72 210 249 210 190 205 27 245 159 94 165 127 94 48 191 104 254 231 245 64 255 164 236 56 17 96 248 122 203 70 72 0 163 138 21 179 162 96 58 1 43 43
	     242 106 196 180 218 99 86 20 108 237 37 118 107 179 201 31 223 222 80 34 64 68 68 62 74 170 0 16 17 145 75 227 255 253 199 93 251 254 225 54 59 71 35 6 211 200 164 114 24 25 5 161 238 31 239 60 206 251 69 123 63 234 162 255 179 101 251 207 187 43 46 238 153 117 179 63 119 65 64 42 63 77 50 160
	     238 219 96 139 255 35 51 160 130 88 145 88 65 230 11 86 91 129 118 211 115 251 250 42 159 92 187 206 191 255 131 171 74 2 136 136 200 71 71 21 0 34 34 242 65 251 254 112 108 135 195 156 199 187 3 30 62 62 100 107 175 71 103 48 161 196 225 179 38 89 35 224 146 198 188 147 191 195 44 98 199 41
	     0 237 207 255 240 45 254 39 173 238 225 224 60 56 135 247 41 142 72 153 27 211 201 148 225 120 66 240 208 159 68 246 59 21 157 65 105 55 174 181 184 185 222 224 231 234 15 32 34 34 31 203 93 83 21 0 34 34 242 161 250 251 221 153 221 125 120 192 227 237 3 246 187 35 166 185 145 71 199 172 140
	     68 60 230 2 222 103 152 79 120 118 217 190 238 131 31 126 252 111 231 254 59 235 36 128 35 98 177 128 170 192 91 137 119 70 35 245 120 139 172 45 53 88 95 110 243 197 173 13 190 252 252 10 127 112 61 83 18 64 68 68 46 61 85 0 136 136 200 7 231 159 246 6 182 221 201 217 61 152 241 221 163 67 182
	     119 14 25 79 115 210 102 139 86 187 141 75 3 1 63 63 218 79 129 254 229 102 23 252 223 214 219 0 12 112 46 133 52 128 69 44 70 198 101 201 100 50 227 112 56 163 121 48 161 55 137 116 103 198 97 191 109 119 174 55 248 249 106 75 137 0 17 17 81 2 64 68 68 228 167 246 195 97 97 15 159 236 179 125
	     212 101 175 59 99 156 7 134 227 28 11 25 73 43 35 36 41 145 0 22 230 229 224 139 88 78 49 221 199 156 30 192 252 60 25 80 39 132 66 218 198 17 169 156 209 31 207 120 184 181 199 112 16 232 119 151 217 91 93 182 191 248 197 53 61 97 68 68 228 82 210 22 0 17 17 249 32 252 211 206 204 238 63 233
	     241 221 189 39 236 28 28 209 27 151 248 180 133 133 12 11 9 184 4 156 35 198 211 13 250 28 206 233 62 119 201 103 50 92 184 5 224 233 79 100 81 45 80 55 113 140 88 44 9 177 192 242 41 105 168 184 190 214 226 218 230 58 95 127 113 141 43 235 45 254 248 246 146 18 1 34 34 114 169 168 2 64 68 68
	     222 107 223 29 228 182 115 208 97 235 112 194 238 225 132 237 206 152 81 14 179 232 9 17 124 112 56 2 206 121 222 196 74 255 249 239 96 175 245 85 47 255 149 242 99 227 127 119 238 81 119 47 245 127 85 167 2 60 37 142 136 35 22 142 206 32 167 180 1 56 99 103 63 99 56 88 181 205 141 77 126 239
	     122 162 68 128 136 136 40 1 32 34 34 242 54 253 143 71 133 61 120 114 196 163 173 93 246 142 70 76 43 152 149 134 207 150 104 166 158 202 5 60 161 46 245 183 249 113 112 78 65 248 71 152 6 120 201 144 127 241 180 168 211 4 206 121 240 25 174 17 240 22 153 197 146 124 152 51 152 30 226 205 216
	     61 154 112 243 134 35 143 155 246 199 55 131 146 0 34 34 162 4 128 136 136 200 155 246 15 91 93 219 235 229 60 220 157 242 228 160 207 97 119 76 111 152 131 79 32 73 200 92 3 231 125 221 235 77 251 251 229 21 157 121 206 184 128 115 1 136 20 230 137 101 193 164 200 137 101 69 100 200 40 63 128
	     88 112 120 20 236 214 122 198 239 221 222 208 19 78 68 68 62 88 234 1 32 34 34 239 141 123 221 194 118 246 122 124 251 96 143 237 195 62 7 253 130 105 21 136 33 165 140 0 1 156 199 249 0 56 108 190 146 123 110 217 255 199 221 24 159 10 22 95 231 171 94 254 43 229 237 255 127 189 220 255 169
	     205 247 5 24 142 146 24 43 50 87 225 162 177 218 244 44 103 145 79 110 172 240 243 47 238 240 175 191 86 18 64 68 68 62 76 170 0 16 17 145 159 220 119 71 99 27 140 75 30 109 247 217 63 28 114 127 187 203 81 127 200 40 55 92 214 166 209 106 18 146 0 212 221 253 163 213 29 221 253 188 193 95 157
	     203 126 51 1 247 235 124 23 119 193 87 41 252 127 241 227 124 62 111 99 204 123 250 61 39 120 7 56 189 237 223 176 179 239 56 253 121 243 69 14 7 216 51 147 68 243 13 2 206 81 31 28 225 113 36 4 171 40 139 41 121 62 97 50 41 57 160 100 156 87 140 139 132 206 168 176 207 110 180 104 103 9 95 93
	     209 177 129 34 34 242 225 80 5 128 136 136 252 164 254 199 253 177 253 240 112 151 94 127 196 206 225 128 162 242 12 243 138 162 170 40 205 99 33 37 132 116 222 228 207 99 206 97 230 112 206 29 7 135 245 189 236 167 187 159 105 253 255 245 18 0 231 227 118 247 82 9 128 120 238 235 220 11 19 0
	     192 188 243 255 179 255 247 162 91 124 30 120 3 44 66 85 16 99 133 139 37 158 72 150 64 26 140 229 102 194 141 141 37 174 110 172 241 235 159 93 227 247 111 42 9 32 34 34 31 6 85 0 136 136 200 79 226 183 7 35 123 184 59 99 107 119 192 247 15 143 24 143 70 244 199 5 105 163 129 207 154 248 204
	     147 249 64 196 97 241 84 216 104 167 131 66 197 93 242 227 83 17 246 84 102 162 254 227 67 74 72 50 176 136 115 145 89 89 208 29 140 216 239 141 216 239 205 184 214 45 169 60 236 14 219 246 239 127 126 85 79 70 17 17 121 239 169 2 64 68 68 222 169 111 118 167 246 104 231 144 199 7 29 182 143
	     166 140 167 142 163 126 78 21 141 89 244 248 36 193 135 12 231 29 206 131 195 113 114 171 178 147 160 223 57 22 53 0 102 246 84 21 128 115 239 46 30 83 5 192 235 132 221 239 75 5 192 217 223 229 248 119 152 63 213 60 245 22 19 115 80 197 138 34 207 33 22 100 193 88 74 3 27 171 158 86 230 248
	     236 106 155 245 229 37 126 254 233 53 126 126 125 73 201 0 17 17 121 47 169 2 64 68 68 222 153 223 236 204 236 187 7 29 238 62 222 103 247 176 75 111 156 19 210 38 149 203 8 205 6 45 223 32 46 58 251 155 205 23 252 237 226 112 208 206 173 220 214 59 189 245 32 203 75 5 253 207 205 6 156 122
	     170 217 241 235 158 224 29 105 59 169 123 62 88 65 81 230 236 28 142 176 34 167 211 25 177 185 50 161 168 2 227 42 218 31 221 90 81 18 64 68 68 148 0 16 17 145 143 207 63 61 30 219 221 237 35 14 123 83 118 14 6 28 244 199 140 103 144 91 138 55 15 62 128 5 48 136 118 62 220 119 231 34 179 139
	     163 53 69 91 31 96 128 254 38 190 202 222 238 239 113 246 152 201 250 228 9 3 172 114 16 61 101 149 18 205 232 78 32 47 167 152 59 224 201 81 143 135 91 43 246 201 205 235 252 201 39 234 15 32 34 34 239 209 189 87 91 0 68 68 228 109 250 171 251 19 219 218 238 241 221 253 29 250 195 9 211 34 18
	     113 248 52 163 114 158 10 48 66 93 234 143 231 117 111 75 238 133 193 219 27 138 22 95 59 148 213 253 246 131 158 48 157 121 43 226 48 156 57 156 171 234 215 99 9 49 18 168 32 150 92 221 92 230 139 79 63 225 103 159 109 242 175 63 75 149 4 16 17 145 247 130 42 0 68 68 228 141 251 97 111 108
	     143 143 250 12 39 57 143 118 167 245 202 127 103 202 100 86 18 93 189 207 63 141 9 4 79 52 155 159 7 231 95 41 68 174 203 187 79 142 1 52 212 18 240 227 12 204 221 73 185 254 59 91 212 240 44 54 167 24 9 96 68 28 49 86 84 165 81 22 142 252 104 70 97 123 140 39 35 58 157 204 54 150 50 254 245
	     207 175 235 41 42 34 34 74 0 136 136 200 229 113 175 87 216 131 237 30 223 60 216 99 48 30 115 56 40 168 92 138 75 50 154 33 163 178 128 121 135 185 122 181 223 126 84 244 126 118 123 128 146 0 31 101 6 224 39 97 167 18 15 224 112 222 17 210 132 144 100 164 77 195 83 48 24 12 121 48 29 208 63
	     116 108 110 44 3 193 254 245 207 175 232 41 42 34 34 74 0 136 136 200 135 237 238 254 208 58 195 25 15 246 70 108 237 244 185 247 164 199 116 58 99 92 25 73 6 73 214 192 249 4 243 9 224 136 156 237 218 47 242 33 57 117 190 192 252 165 7 239 234 186 0 131 162 138 76 103 99 250 195 25 157 62 28
	     12 75 114 75 216 239 79 236 179 171 109 90 237 38 191 188 218 86 50 64 68 68 222 41 245 0 16 17 145 31 237 127 220 27 218 214 246 33 251 71 125 246 186 19 38 149 49 156 20 84 17 74 243 16 2 206 55 192 133 121 192 228 143 11 168 69 46 201 148 234 236 91 177 196 44 199 199 130 224 42 82 239 104
	     53 60 173 212 115 99 115 153 43 155 235 124 253 229 13 254 232 186 250 3 136 136 200 187 163 10 0 17 17 121 109 223 238 13 108 175 95 242 207 119 123 220 127 114 72 183 55 96 92 148 36 205 22 62 205 112 105 32 184 20 179 122 143 116 189 99 123 177 119 95 193 191 92 38 118 246 181 224 240 100
	     56 18 162 85 76 202 130 94 119 66 85 20 236 116 103 92 237 84 76 43 79 127 212 178 59 171 41 95 94 89 86 34 64 68 68 222 58 85 0 136 136 200 43 251 254 176 176 163 131 14 223 63 217 99 191 95 112 216 171 232 142 10 166 69 164 52 79 200 18 92 72 113 206 227 156 155 119 246 87 124 35 31 73 42 192
	     12 28 56 103 64 172 83 2 85 69 81 228 196 170 34 13 142 165 86 198 198 82 194 106 19 110 109 182 248 236 198 21 254 226 151 106 18 40 34 34 74 0 136 136 200 123 228 183 187 19 251 246 97 159 237 157 125 238 109 237 48 156 85 152 111 65 200 112 161 129 133 186 184 172 178 197 138 191 238 51 242
	     17 38 0 112 224 141 121 87 0 124 253 145 249 39 84 120 43 137 179 49 49 159 176 190 220 228 179 219 215 248 250 243 235 124 245 201 10 95 111 182 148 8 16 17 145 183 66 91 0 68 68 228 165 252 239 251 61 187 251 164 195 120 92 242 228 96 72 111 56 161 59 245 148 209 225 188 39 16 240 206 3 158
	     179 185 229 179 157 250 69 62 12 113 254 210 191 246 119 112 243 109 47 139 35 3 23 215 130 153 17 99 160 180 132 104 25 189 137 241 112 111 192 52 175 216 222 59 226 159 55 90 246 197 173 107 252 225 109 53 9 20 17 145 55 75 21 0 34 34 242 66 255 229 254 192 190 249 126 151 31 30 236 147 151
	     21 211 162 194 124 10 33 155 119 62 119 24 97 30 44 105 205 95 46 195 12 105 158 0 48 199 211 219 87 94 53 169 101 224 230 41 0 59 249 14 206 69 176 136 139 37 46 150 16 11 130 69 214 215 218 252 252 203 79 248 242 179 43 252 229 103 77 37 1 68 68 228 141 81 5 128 136 136 92 232 251 195 177
	     237 117 250 236 28 78 184 191 59 102 247 104 196 65 47 167 2 162 243 132 52 144 38 89 189 202 233 230 33 141 34 127 145 139 178 9 231 94 175 55 6 24 14 92 66 52 79 85 66 81 84 196 162 98 92 205 40 221 62 221 193 148 221 93 111 235 237 140 207 174 174 242 245 141 21 37 3 68 68 68 9 0 17 17 121
	     179 238 245 103 118 247 113 143 239 31 236 178 125 48 160 63 46 177 180 65 107 169 77 116 158 72 192 240 224 252 60 240 87 228 47 31 147 215 120 190 219 60 118 119 139 109 0 39 239 115 33 144 132 38 105 35 195 17 241 22 25 140 70 204 38 35 14 118 35 27 203 13 166 159 71 66 150 217 87 27 13 37
	     1 68 68 68 9 0 17 17 249 145 65 127 183 180 241 120 194 147 238 144 253 238 132 173 157 33 91 187 125 58 253 41 85 132 230 114 131 164 145 96 206 131 75 176 69 240 194 188 225 153 150 255 229 82 113 239 228 103 216 169 164 0 206 99 46 18 139 130 113 94 97 197 140 195 104 28 13 74 198 197 30 221
	     73 201 227 27 43 118 117 189 205 175 111 168 63 128 136 136 40 1 32 34 34 175 233 241 254 148 237 189 35 30 238 28 48 24 207 152 84 30 75 82 218 43 9 145 128 75 146 121 83 51 3 139 112 170 193 153 200 165 99 47 142 175 207 127 198 203 92 9 103 123 47 217 169 239 97 243 107 203 112 222 145 53
	     90 248 44 197 227 8 222 113 52 152 49 254 225 9 7 135 75 124 126 231 54 149 203 236 15 175 39 74 2 136 136 136 18 0 34 34 242 242 254 230 81 199 14 122 145 31 182 134 60 217 63 98 251 160 75 94 68 210 102 139 36 109 224 211 4 239 195 60 54 113 139 157 203 175 16 242 136 92 154 172 192 11 82 0
	     63 246 251 206 183 7 184 128 243 30 44 33 226 152 69 163 59 30 83 206 198 236 247 74 6 121 198 184 140 28 246 27 118 125 45 240 235 107 171 74 4 136 136 136 18 0 34 34 242 124 255 249 159 182 236 222 238 17 253 177 113 52 136 140 103 5 62 205 72 18 143 79 26 56 31 192 2 22 221 169 48 197 157
	     73 1 136 124 20 220 249 4 192 203 53 189 116 238 228 232 191 103 127 252 244 169 2 134 185 69 109 128 175 95 122 35 100 77 124 240 184 0 131 241 132 71 79 246 232 117 140 195 245 38 253 206 212 254 213 47 174 235 162 20 17 17 37 0 68 68 228 105 191 217 157 217 15 143 122 124 119 127 135 135
	     59 135 204 162 3 223 36 250 4 159 180 72 124 130 115 97 190 226 239 180 226 47 242 206 178 12 254 248 58 139 243 99 53 193 72 50 15 46 197 170 146 222 116 70 111 208 133 178 96 125 165 197 206 173 130 254 212 217 157 235 75 252 254 77 245 6 16 17 17 37 0 68 68 4 248 219 71 61 219 57 234 115
	     212 43 216 217 31 179 215 157 48 173 60 149 121 204 7 188 11 120 159 224 93 130 25 167 66 127 5 254 242 113 177 11 54 248 187 115 199 249 217 75 116 1 176 151 61 33 195 78 127 117 29 244 159 52 216 4 156 195 185 0 46 18 241 68 11 68 34 195 41 60 57 24 97 236 115 208 237 177 189 223 178 219 87
	     54 249 245 237 150 18 1 34 34 242 20 103 58 186 73 68 228 163 240 223 30 12 237 55 223 237 112 239 241 33 131 209 140 194 12 231 3 46 100 68 28 149 75 240 206 83 151 29 123 5 253 242 209 39 0 236 92 128 238 159 158 70 189 48 1 240 70 39 109 0 84 152 85 56 51 112 134 139 21 84 5 105 168 143 15
	     220 92 107 243 233 205 91 252 242 103 215 249 139 207 117 100 160 136 136 156 165 10 0 17 145 75 238 31 31 29 218 227 253 9 15 247 134 60 220 29 178 215 43 152 22 134 11 158 44 107 144 249 172 94 93 180 122 47 242 241 154 163 59 221 225 223 61 181 146 185 120 219 57 135 115 14 37 148 69 94 35
	     209 112 234 186 89 244 11 56 251 186 177 248 20 195 0 95 95 155 222 225 156 97 86 82 152 49 157 230 196 210 200 227 140 89 181 79 17 75 58 157 134 93 95 79 249 63 191 184 166 68 128 136 136 212 247 23 77 216 68 68 46 167 239 59 185 221 127 212 229 254 227 29 30 109 31 209 27 151 148 161 77 21
	     26 117 201 63 1 156 199 251 11 110 14 206 61 55 80 81 2 64 46 125 96 254 142 42 0 94 156 0 56 253 57 118 230 103 186 249 145 156 102 70 180 10 7 36 174 194 202 25 237 36 178 220 240 220 188 178 194 47 190 188 201 151 119 174 240 213 70 170 68 128 136 200 71 78 21 0 34 34 151 204 111 119 134
	     182 211 29 178 119 56 97 111 127 196 227 189 30 135 157 49 69 116 100 203 144 102 9 158 116 17 62 96 182 216 201 108 168 236 95 228 125 230 158 78 60 184 128 243 134 39 224 128 24 11 102 229 148 201 100 74 111 96 140 103 70 94 121 14 251 83 246 110 175 218 122 59 227 87 215 151 149 8 16 17 249
	     88 239 36 90 177 17 17 185 60 254 235 15 19 251 246 238 99 158 236 29 48 154 228 68 50 38 69 69 25 29 37 1 66 130 11 41 117 254 215 230 97 191 59 149 0 120 245 21 205 139 34 9 221 89 228 67 247 62 246 0 56 255 115 29 39 149 1 182 120 221 42 136 37 88 129 195 104 120 71 226 43 82 23 185 190 185
	     204 245 43 155 252 226 139 91 252 217 231 77 37 1 68 68 62 66 170 0 16 17 185 4 254 126 187 111 79 142 140 123 143 7 124 127 191 195 97 183 79 105 208 106 7 66 154 145 100 25 73 8 84 17 162 157 4 14 238 76 16 33 34 31 134 167 207 31 56 126 219 5 92 154 224 200 192 34 179 88 210 31 231 204 38
	     83 14 135 37 123 125 199 44 6 118 59 45 251 252 102 131 63 186 185 170 68 128 136 200 71 68 21 0 34 34 31 176 239 246 103 118 255 209 30 15 119 143 56 24 70 186 99 232 13 167 20 149 81 57 71 8 41 46 36 56 231 33 248 122 157 240 212 249 102 206 206 175 97 170 2 64 4 222 247 10 128 179 63 217
	     206 253 236 147 254 129 134 69 35 198 156 170 44 8 30 26 73 194 149 229 132 86 18 185 115 181 201 245 141 117 62 191 115 149 95 221 80 69 128 136 200 199 64 21 0 34 34 31 160 187 189 153 117 6 112 127 171 203 189 135 251 60 222 237 48 202 35 46 109 64 104 145 182 155 164 120 42 12 172 62 210
	     207 204 46 88 55 20 145 203 225 116 211 192 83 111 123 35 36 45 210 70 11 139 5 121 94 176 123 52 198 138 9 221 94 202 206 90 193 112 22 24 230 107 246 167 159 182 53 64 136 136 40 1 32 34 34 239 147 255 118 183 99 59 251 125 122 195 130 221 195 49 71 253 156 220 82 162 55 156 75 113 206 19 173
	     94 193 196 220 201 222 224 227 189 254 167 217 11 222 126 126 160 81 127 133 214 251 229 195 103 23 44 230 187 103 62 235 23 95 115 246 185 239 222 225 165 96 47 113 141 46 54 250 56 131 72 196 162 195 156 167 114 1 11 25 195 210 81 245 39 216 147 61 122 163 33 187 123 109 251 236 230 21 254
	     240 142 170 1 68 68 46 43 109 1 16 17 249 64 124 63 40 237 251 71 61 30 62 233 242 104 251 136 241 120 198 180 136 56 159 97 105 66 196 99 120 78 118 246 251 231 6 238 47 31 240 243 130 239 163 251 136 124 248 162 227 169 96 254 69 81 240 233 109 2 238 29 39 0 94 39 101 48 63 247 227 228 101
	     172 136 69 78 8 21 13 239 185 186 182 204 151 159 92 231 230 141 13 190 184 221 224 203 37 167 68 128 136 200 37 163 10 0 17 145 15 192 95 125 183 99 123 221 9 15 118 198 116 134 57 135 131 130 89 30 137 120 66 154 16 44 155 111 252 181 227 4 128 136 124 236 236 236 118 0 231 113 142 227 94 32
	     134 167 36 98 69 100 26 141 200 140 232 15 233 142 38 76 198 77 118 151 50 251 87 63 191 170 193 68 68 228 18 81 5 128 136 200 123 236 219 195 220 238 222 63 224 159 239 111 115 208 27 208 159 24 62 107 81 88 32 154 167 34 212 93 191 157 63 158 240 63 103 200 127 42 56 120 205 91 199 27 250
	     62 34 239 143 203 90 1 112 122 158 231 156 195 205 23 245 235 102 160 17 51 195 89 137 199 8 68 130 229 4 10 174 174 55 184 178 218 230 23 159 94 231 214 245 13 126 117 163 161 68 128 136 200 37 160 10 0 17 145 247 208 15 71 19 219 233 140 217 217 31 243 104 167 207 189 157 62 195 201 140 210
	     2 13 103 248 212 131 79 112 120 204 194 217 184 220 22 147 126 59 158 236 95 16 22 28 7 4 23 5 10 103 190 153 194 127 249 8 184 11 222 97 231 18 2 207 251 26 247 22 127 23 123 35 95 113 81 7 16 143 243 174 30 71 136 148 101 206 116 86 82 149 83 166 101 65 127 84 82 89 194 126 127 74 103 180
	     98 27 43 77 126 117 109 73 137 0 17 145 15 249 126 167 10 0 17 145 247 203 95 223 155 216 214 246 1 143 118 15 233 12 102 204 42 24 78 74 34 142 232 2 206 39 16 2 224 235 242 94 115 128 199 251 147 64 126 49 182 187 23 108 225 85 2 64 228 98 118 65 2 224 93 69 190 111 39 1 240 172 175 169 43
	     1 192 112 86 65 204 137 177 34 248 72 234 160 157 121 2 198 213 141 54 215 54 214 248 234 211 235 252 197 87 74 2 136 136 124 168 84 1 32 34 242 158 248 251 237 161 117 6 145 111 30 118 216 218 57 98 255 168 199 180 140 164 141 6 46 105 144 164 41 158 64 21 227 124 167 255 98 207 191 205 39 240
	     254 117 67 29 212 51 64 228 227 184 74 78 146 131 23 36 3 156 199 39 13 130 115 196 88 48 139 21 227 81 78 62 155 113 52 42 216 237 84 76 10 199 112 58 177 91 155 25 127 120 115 85 3 135 136 200 7 70 21 0 34 34 63 177 127 120 50 179 131 195 67 238 109 119 233 143 114 246 122 51 134 211 138 105
	     5 37 158 16 18 92 72 9 46 96 56 34 118 210 230 207 78 194 147 69 31 128 87 25 215 157 179 227 208 198 236 162 130 102 85 0 200 71 26 240 159 171 0 192 94 63 197 246 202 147 179 87 190 198 94 254 43 158 174 14 58 125 173 215 99 11 206 97 49 18 169 168 170 146 42 86 100 24 169 131 141 165 192
	     74 11 174 175 55 249 249 167 183 184 115 253 10 63 187 226 149 8 16 17 249 64 168 2 64 68 228 39 114 183 151 219 126 167 224 251 71 71 28 28 117 120 188 115 196 52 47 201 163 199 165 45 146 102 139 224 146 121 23 111 79 140 246 156 216 220 241 58 9 93 5 239 34 31 187 179 91 127 108 222 252 192
	     92 192 123 143 15 9 153 115 184 88 80 21 57 135 189 49 251 71 19 246 59 13 198 211 64 119 12 69 181 98 191 186 222 84 18 64 68 228 3 160 10 0 17 145 159 192 95 127 223 183 7 219 71 28 118 199 108 31 13 41 202 138 193 40 167 50 35 186 20 151 100 184 180 1 46 28 79 204 89 140 215 206 224 77 237
	     71 62 221 217 76 21 0 34 23 95 14 243 39 250 251 220 3 192 206 127 133 217 201 247 185 160 215 199 179 251 131 184 147 159 233 78 125 247 88 82 85 37 86 206 176 114 70 18 28 107 237 6 235 203 45 110 108 46 177 178 148 240 213 237 43 92 189 182 198 151 203 218 83 36 34 242 190 82 5 128 136 200
	     59 244 221 81 110 15 119 115 238 62 234 112 111 235 128 225 120 204 180 168 200 154 77 146 214 50 9 14 35 80 225 136 167 131 254 83 211 251 121 252 255 150 162 156 23 135 28 246 130 96 69 73 1 185 12 94 230 72 63 119 238 250 177 215 58 7 240 162 238 252 246 138 151 241 185 175 88 4 249 23 253
	     52 247 194 195 13 79 190 214 78 37 0 156 39 73 51 92 26 8 174 9 49 50 204 103 12 15 122 28 244 70 180 27 41 163 220 113 103 226 176 59 77 251 106 45 83 18 64 68 228 189 188 191 169 2 64 68 228 173 251 199 173 190 29 244 6 60 222 31 179 119 84 112 208 47 216 239 78 40 170 18 195 145 54 26 36 73
	     2 206 159 236 229 127 214 228 221 94 47 72 120 107 55 18 37 0 228 163 157 68 189 157 4 0 175 156 0 224 233 4 192 233 158 5 206 189 230 181 237 78 165 36 236 36 43 224 12 171 42 138 60 167 42 74 60 70 26 60 87 215 155 172 183 83 62 189 222 226 234 90 147 79 174 175 242 235 91 107 74 4 136 136
	     188 71 84 1 32 34 242 150 253 102 103 106 223 63 236 178 181 123 200 206 209 128 97 238 32 180 104 52 155 100 222 17 205 207 207 28 119 47 23 214 59 69 217 34 242 252 192 221 185 55 242 141 230 249 132 197 55 171 143 11 172 11 2 18 178 102 130 107 56 28 21 193 34 163 201 148 241 160 207 176
	     239 217 88 105 51 203 35 161 209 176 95 110 170 63 128 136 136 18 0 34 34 151 216 15 157 104 195 225 144 71 251 125 58 195 156 71 79 122 28 30 13 233 77 102 148 36 164 205 10 23 18 156 133 249 62 255 69 224 111 167 119 224 138 136 188 74 172 254 212 235 111 254 167 212 127 234 17 202 215 187
	     136 204 168 204 168 102 70 49 45 25 77 140 254 200 40 57 162 63 43 217 218 104 219 245 245 37 218 237 22 95 109 164 74 6 136 136 40 1 32 34 114 185 60 218 155 177 127 208 225 254 147 67 166 69 201 112 82 17 67 66 107 105 133 10 143 249 164 222 227 143 129 85 224 78 151 219 62 219 251 184 109
	     75 169 10 249 88 189 94 201 255 155 191 130 220 91 186 8 159 26 111 78 109 121 168 95 139 199 9 1 231 29 73 51 35 77 19 82 42 92 128 206 96 202 104 54 101 119 191 193 173 107 87 184 115 29 190 218 72 245 196 17 17 81 2 64 68 228 114 248 95 15 123 118 208 143 124 123 191 207 97 231 144 221 195
	     30 149 115 224 82 124 146 145 164 41 230 60 209 140 121 221 191 136 200 7 206 97 120 204 103 120 7 149 69 138 88 50 28 230 228 249 148 70 58 227 96 0 71 253 146 73 62 177 107 171 9 255 242 179 43 170 4 16 17 81 2 64 68 228 195 244 221 97 97 15 30 111 115 127 167 199 112 12 187 253 130 89 94 226
	     211 38 56 71 244 9 184 132 72 56 117 190 150 59 85 171 171 185 176 136 124 136 22 89 204 58 177 233 1 115 14 188 199 165 142 212 7 156 131 241 172 96 231 160 67 49 237 242 164 237 25 245 166 246 201 39 119 248 114 67 131 159 136 136 18 0 34 34 31 144 255 253 104 104 119 31 247 120 240 104 151
	     199 123 61 202 202 51 115 9 33 201 240 89 11 199 188 179 191 49 47 251 71 251 252 69 228 18 242 24 243 142 38 206 225 147 128 79 12 172 100 92 78 153 78 166 28 28 78 105 4 163 55 130 163 105 147 241 39 45 251 253 91 109 37 1 68 68 148 0 16 17 121 191 253 245 15 29 219 239 12 216 62 24 114 112
	     52 166 63 206 201 99 66 133 199 185 12 92 130 57 143 89 120 137 198 253 74 6 136 200 135 175 30 201 22 35 222 162 210 201 131 75 40 131 225 44 98 209 216 238 76 152 85 79 56 234 101 252 238 65 102 159 222 216 224 207 191 92 87 34 64 68 228 45 115 239 99 67 41 17 145 247 217 183 221 137 237 28
	     78 249 199 111 15 120 178 115 68 119 48 36 143 144 54 150 240 33 173 87 192 92 2 206 81 225 21 219 139 200 199 59 209 60 78 11 68 12 35 184 136 139 70 44 102 88 85 144 122 163 213 200 248 242 211 107 252 193 175 110 242 111 191 88 81 18 64 68 228 45 82 5 128 136 200 75 250 219 7 71 54 24 77 120
	     120 52 162 219 207 121 188 59 161 51 200 153 20 1 115 1 179 148 196 165 243 243 183 61 188 196 186 191 136 200 199 144 6 48 22 199 157 6 162 51 10 139 20 85 133 43 42 166 101 133 223 233 146 23 57 187 219 109 187 115 165 205 213 141 85 190 190 214 82 50 64 68 228 77 143 200 170 0 16 17 121 177
	     255 121 183 107 191 253 97 135 131 78 143 221 238 136 178 114 148 190 65 69 74 164 238 236 111 206 1 126 126 66 182 83 224 47 34 242 12 245 252 51 18 92 69 130 97 229 20 138 41 43 141 192 237 107 235 124 249 233 53 126 241 197 21 126 113 173 169 36 128 136 200 27 164 10 0 17 145 231 248 155
	     187 135 246 232 96 192 206 225 152 7 59 61 6 163 9 131 113 129 11 9 161 233 72 146 128 11 9 206 7 44 70 176 147 240 95 68 68 206 5 254 139 209 209 59 60 30 195 81 90 69 81 194 108 82 49 156 84 76 171 33 227 210 209 25 77 248 126 179 109 55 86 219 108 172 173 240 213 70 208 208 42 34 242 35 169
	     2 64 68 228 2 223 117 43 187 251 120 196 189 7 143 217 58 232 48 171 96 86 64 52 71 105 245 254 126 243 245 75 156 7 60 118 124 188 159 157 154 236 94 156 13 112 26 122 69 228 210 5 247 48 223 3 117 118 188 139 241 228 227 128 115 139 211 80 234 42 0 135 225 172 194 98 133 195 72 156 145 122
	     71 234 75 150 155 41 55 174 108 240 249 157 27 252 252 243 37 190 90 85 18 64 68 228 199 80 5 128 136 200 41 191 221 233 91 103 92 176 181 95 114 239 73 159 199 187 93 58 189 9 33 77 72 178 6 33 164 132 164 49 143 243 29 134 225 206 36 82 237 226 73 241 41 94 15 179 136 92 230 36 192 43 141
	     119 14 195 131 247 16 50 162 69 38 101 193 96 92 80 204 102 100 110 198 225 8 122 211 72 111 184 196 147 235 153 221 90 109 241 179 107 106 22 40 34 162 4 128 136 200 143 240 205 222 200 190 189 183 199 246 193 128 163 97 69 111 90 97 206 177 180 178 2 46 96 62 224 230 231 92 99 245 68 215 172
	     46 105 117 243 115 175 95 214 98 5 76 85 88 34 114 233 29 175 248 95 244 126 135 153 97 230 230 149 81 30 239 51 210 70 32 77 82 130 139 84 102 116 122 93 102 227 67 118 119 19 142 110 94 165 176 212 126 117 93 253 1 68 68 148 0 16 17 121 69 247 142 198 182 213 41 120 180 211 225 187 123 135
	     236 31 14 152 150 134 133 148 208 104 227 178 38 88 221 224 239 108 184 126 182 212 95 51 81 17 145 87 202 12 156 27 81 231 137 81 231 112 33 224 18 32 150 204 202 9 121 127 202 206 108 66 195 195 225 208 24 87 13 6 147 77 187 178 10 95 109 232 180 0 17 17 37 0 68 68 94 194 127 249 182 99 135
	     221 62 59 135 67 142 250 83 6 179 138 24 50 130 115 68 159 128 15 103 2 127 119 65 240 255 188 73 173 3 56 183 202 239 80 182 64 68 46 105 56 127 106 188 123 214 48 119 82 1 117 254 35 117 42 213 205 199 87 91 100 86 67 192 145 145 164 224 189 49 152 20 220 123 178 207 120 58 230 218 122 147
	     238 141 117 251 151 159 104 75 128 136 200 75 141 213 42 63 21 145 143 209 63 29 77 237 225 206 132 239 238 237 179 179 223 229 168 55 36 70 72 26 45 92 72 192 5 34 97 222 224 207 61 51 220 63 61 134 186 227 45 0 238 130 73 173 136 136 156 77 0 188 120 108 92 52 10 244 49 226 156 225 136 20 197
	     140 88 22 100 137 103 99 109 153 47 239 108 242 229 39 235 124 122 173 205 215 235 153 18 1 34 34 207 161 10 0 17 249 168 124 183 55 178 237 195 35 30 117 198 28 116 74 118 142 114 186 163 138 105 25 234 146 83 151 16 124 2 156 93 249 127 241 132 246 121 171 90 207 78 28 56 167 185 170 136 124
	     92 129 255 171 168 123 172 120 204 123 112 16 137 84 46 82 98 148 165 193 48 39 221 235 50 157 12 233 117 218 236 173 181 237 214 213 117 190 186 162 254 0 34 34 23 142 197 170 0 16 145 143 197 223 61 154 216 247 247 119 249 97 235 9 187 157 33 69 76 137 73 107 126 172 95 82 239 59 133 227 85
	     255 151 154 156 30 7 242 224 156 127 70 2 192 148 0 16 17 77 58 207 141 119 175 50 7 181 249 56 107 196 121 7 214 8 22 241 84 4 114 152 142 89 109 7 174 173 175 242 179 47 110 242 229 167 87 248 163 155 234 13 32 34 114 158 42 0 68 228 210 251 135 173 174 237 117 38 108 31 76 121 188 211 101
	     123 127 194 96 82 65 146 144 56 135 15 30 159 36 24 14 139 175 154 20 117 231 90 1 46 86 172 94 109 34 44 34 114 41 130 252 103 4 239 175 26 240 159 77 20 204 95 58 0 143 11 14 204 131 69 98 132 60 55 138 169 145 23 57 211 98 136 37 71 116 71 83 118 15 218 118 107 115 133 63 184 173 254 0 34
	     34 199 227 180 42 0 68 228 178 186 59 194 238 62 236 242 221 189 39 236 236 119 25 23 145 60 58 138 210 17 9 152 247 56 31 128 0 206 205 59 80 191 218 60 209 220 211 235 251 206 220 83 189 173 69 68 62 246 4 192 235 58 153 171 186 250 228 64 15 16 193 172 78 14 196 18 87 85 4 74 28 70 51 115
	     196 42 103 181 153 113 231 198 53 126 249 213 109 254 239 95 44 41 9 32 34 130 42 0 68 228 18 250 254 104 104 135 131 156 157 142 227 238 163 3 30 62 233 114 212 27 97 62 144 54 155 164 105 11 31 210 122 82 106 118 188 110 255 163 38 168 207 153 252 138 136 200 27 82 247 4 172 71 219 121 239
	     21 23 50 124 226 193 74 138 178 32 159 78 25 141 10 58 190 100 48 235 146 211 96 92 228 118 125 5 254 143 207 54 52 76 139 200 71 77 21 0 34 114 169 252 237 163 190 221 125 176 199 214 65 143 222 56 210 25 150 204 74 152 69 135 185 128 15 9 222 39 224 252 226 196 105 22 39 77 189 206 104 184
	     168 0 56 157 0 80 5 128 136 124 180 19 203 103 196 236 63 42 230 63 95 1 112 254 135 217 201 79 138 22 33 150 84 101 36 113 21 193 193 114 43 176 222 128 245 182 231 203 59 87 185 125 227 42 127 242 153 42 2 68 228 227 164 10 0 17 185 20 190 59 156 216 214 225 132 123 143 14 121 252 164 195
	     238 209 144 105 81 97 62 33 109 45 145 182 90 96 190 222 231 191 216 79 250 212 238 253 55 59 233 21 17 145 55 144 84 120 86 207 20 59 255 166 199 59 95 247 119 73 29 206 42 202 124 204 81 127 196 81 49 163 149 6 6 83 216 31 26 195 50 218 234 82 224 143 110 180 53 124 139 136 18 0 34 34 31 138
	     187 3 179 7 143 122 60 124 178 199 110 167 79 119 84 49 43 29 149 111 226 178 136 115 129 232 2 46 158 14 250 235 21 122 115 79 79 38 95 117 38 232 236 162 100 128 86 252 69 228 227 244 211 141 126 238 248 231 59 171 199 122 51 195 124 130 75 50 204 121 42 239 56 236 231 12 167 123 244 6 67 150
	     154 9 187 183 55 236 147 59 27 252 222 70 166 68 128 136 40 1 32 34 242 62 251 135 131 169 61 222 153 241 253 253 67 238 61 218 167 55 28 67 146 209 90 90 197 183 50 50 115 196 121 56 126 210 159 255 236 20 213 158 154 62 190 238 180 83 68 68 126 202 212 195 233 177 216 230 9 221 16 82 92 18
	     112 24 30 199 48 159 210 25 77 232 12 167 164 193 211 155 70 250 51 40 62 95 181 63 186 170 99 3 69 68 9 0 17 145 247 47 240 127 212 179 237 195 14 79 246 71 28 13 141 195 126 193 176 128 34 52 113 62 163 136 1 119 188 87 244 130 245 120 179 83 221 251 53 223 19 17 185 204 41 1 51 143 195 17
	     205 40 45 165 244 134 197 138 153 57 118 59 99 102 179 130 209 176 199 238 230 146 221 186 178 170 99 3 69 68 9 0 17 145 247 38 248 127 50 181 127 126 216 225 225 214 30 59 7 125 74 18 72 154 164 205 38 193 165 24 225 212 228 207 158 55 51 68 241 191 136 200 101 230 142 95 26 128 243 132 204
	     147 100 25 158 18 44 50 205 75 158 140 70 12 7 3 142 14 151 25 77 12 66 106 127 112 163 169 187 131 136 40 1 32 34 242 83 249 251 135 29 123 114 52 165 55 200 185 183 221 97 247 96 66 111 88 224 2 36 205 8 137 195 249 0 120 78 159 110 242 188 253 248 154 221 137 136 188 15 236 165 70 231 243
	     205 0 159 119 146 213 226 67 14 192 251 147 159 98 245 247 169 172 190 87 148 133 145 231 145 217 172 98 86 142 41 93 135 105 81 178 179 223 180 219 87 151 248 245 77 85 3 136 200 229 162 99 0 69 228 189 246 67 31 251 254 65 151 39 187 123 60 217 235 145 87 48 152 148 20 102 148 21 68 60 132
	     128 115 9 184 164 78 0 92 218 38 124 238 5 147 102 17 145 15 48 248 119 23 36 0 204 253 200 4 192 201 199 252 153 4 128 205 19 195 17 44 98 86 97 68 82 139 120 7 205 20 90 169 99 165 149 242 217 205 171 92 187 186 193 191 255 149 146 0 34 114 121 168 2 64 68 222 75 119 15 135 118 48 42 217 57
	     200 249 230 97 151 253 195 46 135 189 17 206 123 98 72 201 210 12 151 166 117 55 127 12 195 207 103 125 241 164 186 223 185 51 19 70 37 60 69 68 62 242 100 195 241 107 14 240 224 60 222 59 34 145 188 44 24 143 11 172 200 105 132 41 195 153 227 106 175 32 47 114 219 92 9 252 217 23 235 74 4 136
	     200 7 79 21 0 34 242 222 249 237 246 200 190 127 176 195 214 94 159 238 168 228 96 88 81 68 24 87 14 204 131 79 240 193 227 156 135 121 10 224 248 8 168 211 229 255 151 46 1 160 10 0 17 185 132 65 249 75 86 0 188 189 132 128 3 34 102 70 140 21 196 146 132 72 51 129 70 128 235 171 13 150 90 158
	     47 239 108 114 251 218 85 254 240 19 157 22 32 34 31 46 85 0 136 200 123 229 191 221 237 218 131 173 14 63 60 220 103 247 160 79 94 65 233 83 178 214 18 105 214 196 240 24 97 30 204 199 249 196 205 41 32 22 17 145 231 170 15 134 113 167 146 193 254 84 42 32 224 156 35 36 41 80 225 172 98 90 76
	     24 143 167 140 134 35 18 239 24 76 35 123 221 138 193 100 195 110 93 109 240 229 134 26 5 138 200 7 56 22 170 2 64 68 222 7 255 233 155 142 29 117 123 60 218 233 209 25 206 232 141 114 70 227 2 115 142 42 100 36 105 3 66 70 189 199 223 205 247 113 158 247 126 140 103 63 118 157 222 120 122 241
	     203 113 193 34 153 136 200 7 238 226 241 206 206 53 112 125 51 21 1 139 138 176 147 185 175 123 230 56 237 172 196 170 28 43 75 130 149 56 140 165 118 66 22 60 215 55 150 184 113 101 153 79 110 108 240 111 127 161 109 1 34 242 97 81 5 128 136 252 164 254 102 123 108 251 157 156 239 238 29 178
	     127 208 225 176 215 167 114 129 144 53 73 218 205 122 207 191 249 115 211 65 67 171 253 34 34 242 227 211 15 231 83 1 139 119 120 66 218 192 39 13 28 21 206 69 198 69 78 103 48 164 51 24 179 115 56 166 51 140 76 43 103 183 174 100 252 193 117 109 11 16 17 37 0 68 68 158 233 127 221 61 178 195
	     222 128 7 123 67 134 99 216 62 154 48 26 229 76 202 4 66 66 98 41 222 37 120 59 213 189 25 167 163 251 68 68 228 29 240 24 80 177 232 50 227 41 204 200 125 147 178 140 84 163 18 219 237 48 154 140 121 180 150 178 115 115 217 214 219 203 252 233 151 170 8 16 145 247 155 182 0 136 200 59 247 215
	     223 247 237 219 187 59 236 31 29 177 219 25 99 62 99 22 19 156 15 68 159 18 241 68 87 151 124 158 180 247 251 128 6 214 115 111 107 11 128 136 200 171 140 119 111 103 11 192 43 141 227 199 219 5 0 34 230 192 185 122 28 246 49 226 40 241 86 224 202 41 173 196 184 177 185 202 245 171 235 252 234
	     171 107 252 233 231 171 74 2 136 200 123 75 21 0 34 242 206 252 247 239 14 236 241 225 136 157 195 9 143 183 187 140 166 83 70 227 136 203 34 4 135 79 2 193 7 112 158 139 115 147 31 79 4 172 217 163 136 124 220 227 221 251 51 10 218 188 217 108 189 104 230 168 156 17 163 39 22 80 204 34 67 139
	     204 202 17 157 113 100 152 231 220 125 178 103 159 95 93 99 115 115 147 175 175 4 13 231 34 242 126 141 185 170 0 16 145 183 237 55 7 149 61 217 29 114 255 209 54 79 14 122 140 243 200 120 86 225 146 132 42 122 204 37 243 21 127 143 185 249 217 204 47 152 14 106 228 18 17 145 119 157 10 168
	     239 61 17 0 79 133 183 136 139 145 224 34 193 71 26 9 164 193 248 228 250 21 62 189 115 135 95 124 177 196 207 87 188 146 0 34 242 222 80 5 128 136 188 53 255 184 213 181 222 164 226 238 246 148 157 131 33 187 7 61 58 131 49 149 115 56 159 146 145 226 67 58 175 238 156 175 176 60 39 232 23 17
	     17 249 201 211 0 243 251 85 196 31 239 205 202 203 41 101 94 98 69 129 89 100 56 235 210 153 120 134 227 85 182 175 4 187 182 220 224 87 55 181 53 64 68 148 0 16 145 75 234 119 219 67 187 251 232 136 131 238 144 39 71 19 6 83 40 112 100 75 109 12 143 89 189 231 31 231 235 53 149 83 251 59 23
	     175 58 208 82 191 136 136 188 39 220 169 172 116 157 176 142 212 253 2 124 146 145 134 4 159 22 64 221 60 240 176 215 37 22 125 14 15 18 62 189 182 134 247 153 253 226 122 83 73 0 17 81 2 64 68 46 81 224 191 55 176 135 187 99 142 58 99 126 120 116 200 97 127 72 127 148 19 67 74 210 88 198 165
	     25 56 15 36 117 243 39 115 243 105 148 34 125 17 17 249 64 18 1 199 66 125 247 114 9 120 195 44 128 51 38 69 78 127 60 225 168 59 163 157 120 58 189 130 209 44 97 183 187 106 183 175 164 252 236 74 91 137 0 17 249 105 70 48 245 0 16 145 55 225 135 110 180 123 143 15 232 244 250 108 237 14 152
	     20 198 209 96 198 100 86 48 139 70 116 9 33 105 226 66 2 206 213 85 0 243 137 148 63 55 14 217 51 166 89 34 34 34 63 181 167 239 81 14 136 199 219 1 156 65 140 5 177 204 113 86 146 121 99 185 145 176 214 110 176 190 210 224 246 181 101 54 87 151 249 191 126 239 170 110 113 34 162 4 128 136 124
	     120 254 105 119 100 223 63 30 241 205 221 61 14 59 61 186 195 9 62 109 64 72 113 222 99 62 128 11 96 30 28 68 231 142 131 127 0 175 97 72 68 68 62 244 180 128 59 157 33 168 43 219 28 21 222 140 88 230 148 249 132 128 177 185 186 204 205 43 171 124 253 213 85 238 220 104 241 199 215 151 149 8 16
	     145 119 70 91 0 68 228 181 253 176 51 180 135 187 135 60 58 28 179 223 43 217 235 142 25 79 35 185 101 4 75 241 46 195 59 15 46 212 103 42 59 142 139 253 13 173 238 139 136 200 101 225 206 237 100 115 243 138 0 71 196 40 29 20 84 20 177 162 59 46 193 15 169 238 230 236 31 100 28 238 46 217 205
	     43 27 252 250 246 138 110 139 34 242 246 71 43 85 0 136 200 235 248 95 247 70 118 247 225 30 63 60 120 194 65 127 76 229 51 10 82 240 9 209 53 192 251 186 67 50 134 195 213 9 0 12 195 136 231 18 0 170 0 16 17 145 203 232 164 218 109 94 17 16 75 188 149 120 10 92 49 37 184 138 27 155 203 124
	     121 251 6 191 250 217 117 254 197 167 170 6 16 145 183 75 21 0 34 242 74 254 219 247 7 214 29 149 60 218 25 176 189 223 103 191 51 99 52 51 66 102 132 52 224 124 6 62 171 167 60 198 60 220 95 88 236 150 60 137 248 189 30 82 17 17 249 80 184 179 161 253 211 43 255 23 125 178 195 225 192 57 92
	     240 196 10 202 170 162 204 33 86 145 210 38 148 241 136 241 172 100 107 191 105 183 55 151 249 151 95 108 42 17 32 34 111 103 24 83 5 128 136 188 140 191 223 205 237 241 118 143 239 31 236 114 212 31 51 24 231 20 17 140 128 185 0 120 162 79 192 39 243 99 254 22 19 36 187 96 66 164 113 71 68 68
	     62 200 153 51 79 181 1 180 23 197 234 39 31 175 139 225 42 176 136 179 178 126 25 75 18 111 36 68 154 41 220 190 177 201 239 125 253 41 95 221 89 225 203 101 167 68 128 136 188 81 170 0 16 145 231 250 155 199 29 235 13 115 30 60 25 179 115 52 98 107 175 207 112 146 83 70 72 178 140 102 179 137
	     15 201 60 224 119 188 120 77 95 193 191 136 136 124 164 172 78 156 59 231 33 4 48 40 139 156 89 158 51 157 205 112 85 197 160 232 50 179 140 222 96 198 227 43 102 235 205 140 63 188 181 174 68 128 136 188 17 170 0 16 145 103 250 47 223 28 216 55 119 119 233 14 134 28 12 114 242 42 48 141 9 149
	     57 170 249 4 198 133 80 151 54 82 151 246 155 243 156 148 68 26 139 181 11 141 53 34 34 242 193 71 239 174 238 246 127 178 19 192 97 175 80 1 112 124 66 128 59 85 15 103 145 104 17 170 18 71 69 226 35 173 196 88 109 56 86 151 60 55 174 172 242 243 207 111 240 103 218 22 32 34 111 128 42 0 68
	     228 41 255 240 164 103 143 14 198 220 123 212 225 254 163 35 6 163 17 147 18 66 214 36 109 53 112 105 74 112 161 158 244 88 221 218 239 120 110 99 103 247 248 139 136 136 92 62 175 23 139 219 153 182 128 243 187 165 11 120 151 224 147 20 136 20 249 132 201 96 64 167 147 147 5 199 97 191 96 48
	     141 116 70 209 238 92 105 242 7 55 213 40 80 68 126 196 232 165 85 57 17 89 248 187 39 19 219 218 233 177 115 208 225 160 55 162 63 169 24 78 10 242 34 82 226 192 39 120 223 172 203 22 93 184 160 154 223 142 247 254 187 55 190 109 209 61 245 179 68 68 68 222 173 197 234 253 201 61 233 233 169
	     180 187 248 235 56 169 134 91 220 35 23 95 235 28 39 21 115 177 128 114 10 85 78 240 70 51 13 52 83 207 198 74 139 171 171 75 220 185 177 201 151 159 175 243 245 122 170 68 128 136 188 50 85 0 136 8 0 255 243 209 192 190 121 208 231 222 214 17 187 7 29 38 211 130 208 200 72 211 6 100 9 137 95
	     52 246 243 24 238 162 25 143 2 115 17 17 185 228 22 149 111 175 145 56 120 238 251 79 98 249 224 83 200 60 88 3 172 100 82 85 116 6 19 118 14 39 44 183 39 236 15 34 131 34 50 184 179 108 255 242 214 146 146 0 34 162 4 128 136 188 188 223 61 234 218 131 253 3 118 59 57 79 58 37 157 81 206 212
	     2 49 113 120 159 18 73 49 119 178 207 223 56 85 230 127 193 42 191 250 21 139 136 200 199 224 252 106 254 51 83 6 174 14 240 47 170 186 61 253 165 139 15 71 168 171 236 230 137 1 115 14 146 6 196 200 52 122 142 70 83 252 163 61 70 131 35 142 246 219 118 107 115 131 223 255 100 85 119 95 17 121
	     41 218 2 32 242 17 251 235 31 70 118 239 209 54 119 31 109 211 25 204 152 145 81 248 20 163 62 206 207 45 58 21 31 175 76 216 43 77 122 222 240 112 117 126 234 165 255 64 17 17 121 15 19 0 238 194 32 223 204 94 241 254 233 128 88 55 216 133 249 209 129 21 137 43 136 249 148 134 43 184 182 190
	     204 231 159 220 228 235 207 175 241 103 95 168 55 128 136 188 152 42 0 68 62 50 63 28 206 108 231 168 71 119 152 179 115 152 179 189 223 99 175 95 50 201 35 49 24 46 56 124 226 113 46 97 113 164 159 205 167 33 86 31 96 92 111 1 152 79 72 158 127 232 159 157 203 29 60 107 146 244 50 193 188 2 126
	     17 17 249 32 82 3 207 76 8 156 4 254 47 151 212 54 252 252 94 234 112 4 12 200 99 73 89 194 172 50 172 59 195 66 135 202 34 71 189 158 221 222 92 226 143 62 213 145 129 34 242 108 170 0 16 249 136 252 115 183 178 223 126 187 203 15 15 247 232 13 198 140 75 40 74 168 156 167 50 192 121 204 37
	     224 60 142 240 84 61 191 185 115 83 20 123 153 4 128 157 154 219 248 31 145 0 16 17 17 185 52 83 240 151 74 0 60 253 21 6 86 65 172 143 12 244 86 17 92 69 51 243 180 211 132 59 215 55 185 121 243 42 191 248 98 131 95 174 161 68 128 136 60 69 21 0 34 31 129 31 14 7 118 48 44 184 191 51 230 135
	     135 71 60 217 27 50 158 230 68 231 241 73 147 180 145 225 66 56 55 41 209 188 65 68 68 228 125 81 87 223 57 156 115 184 36 224 28 148 69 206 36 159 48 152 22 4 43 153 148 61 142 38 70 94 230 236 111 4 187 181 154 241 179 171 234 15 32 34 39 84 1 32 114 201 253 205 131 174 125 127 127 143 71 187
	     61 14 250 51 38 5 148 46 144 71 7 139 189 254 62 204 203 18 237 185 193 255 155 175 0 16 17 17 249 40 167 224 79 223 47 95 225 107 142 143 17 140 37 85 44 32 86 4 51 178 4 60 37 235 237 192 114 19 62 191 190 206 207 191 188 205 191 252 76 73 0 17 169 169 2 64 228 146 250 205 193 208 246 14 135
	     60 124 50 224 238 163 35 118 246 251 76 243 72 218 108 209 88 110 145 36 245 30 255 136 63 53 239 56 61 63 136 188 168 10 224 213 102 19 154 123 136 136 136 188 41 6 184 16 72 124 125 194 128 119 145 162 200 153 77 115 70 163 156 224 140 241 36 50 44 28 189 233 204 62 185 190 196 215 235 109
	     221 140 69 62 114 170 0 16 185 100 254 118 107 102 15 30 239 179 123 212 225 176 59 100 92 120 134 147 146 241 172 34 154 199 37 41 73 154 97 243 238 254 17 127 124 196 223 89 241 248 72 162 119 214 237 223 197 249 172 70 149 2 34 34 242 129 76 166 47 8 204 127 236 247 168 191 143 123 201 47
	     136 243 182 188 17 202 138 170 202 241 86 226 48 150 178 64 226 35 235 203 9 183 174 174 243 201 205 107 124 253 217 21 190 92 213 161 189 34 31 43 85 0 136 92 34 255 245 238 192 238 111 13 184 251 232 128 131 195 14 131 201 140 164 217 38 109 52 201 218 45 112 129 10 135 197 211 115 8 123 206
	     236 226 93 38 8 237 220 235 154 155 136 136 136 92 120 159 180 179 183 235 250 142 233 113 137 35 73 19 156 69 156 51 166 101 193 184 55 96 175 51 100 191 91 210 29 121 202 232 57 220 76 237 79 63 89 209 141 86 68 9 0 17 249 16 253 247 239 14 236 225 238 33 219 135 83 186 195 200 65 127 202
	     36 6 170 180 141 115 25 102 41 33 6 156 119 199 71 248 129 187 48 248 127 247 85 65 139 163 2 85 141 36 34 34 242 234 78 78 212 49 28 209 220 113 5 95 5 88 218 198 98 193 168 112 236 28 246 40 242 9 237 204 120 252 120 217 174 173 175 243 111 126 117 77 137 0 17 37 0 68 228 67 241 159 190 25
	     216 183 247 246 121 180 115 64 119 152 19 125 74 229 18 26 75 75 100 46 193 204 19 231 37 245 39 193 253 226 48 161 23 236 241 127 103 21 130 231 150 50 180 250 47 34 34 242 10 183 80 119 156 76 55 108 126 140 175 39 132 64 123 57 195 17 113 101 193 56 159 49 222 25 18 171 130 78 111 194 141
	     171 21 230 27 118 235 122 139 159 173 167 186 249 138 40 1 32 34 239 163 111 14 38 182 181 223 99 191 147 179 123 56 98 251 160 75 127 84 49 201 129 212 227 124 32 141 1 124 192 236 116 120 125 178 219 223 156 61 181 232 254 211 221 249 221 123 241 91 136 136 136 124 16 49 191 157 77 156 159
	     205 215 187 51 247 125 172 110 18 104 230 168 74 79 44 193 114 199 126 47 103 92 118 41 129 7 59 9 15 174 180 236 198 213 43 252 254 141 166 110 196 34 74 0 136 200 251 226 159 246 115 123 248 164 207 119 15 15 216 63 26 49 158 21 20 17 210 70 27 215 112 84 120 12 15 248 249 4 193 61 115 159
	     191 157 186 197 187 119 221 240 239 204 228 68 255 175 34 34 242 129 6 227 111 237 123 216 107 127 183 51 59 235 230 47 189 247 248 70 134 107 36 132 104 56 42 70 121 197 253 237 14 222 149 236 119 87 248 108 156 82 145 216 31 221 72 148 4 16 81 2 64 68 126 74 127 191 213 181 254 120 202 253
	     221 9 123 135 99 182 118 199 116 134 83 42 140 144 102 52 125 130 185 48 191 237 191 66 25 253 233 128 255 220 254 255 227 115 134 117 90 136 136 136 200 7 170 94 12 48 2 224 235 45 2 193 147 151 57 69 105 12 102 5 85 85 50 169 70 140 102 187 76 102 83 6 253 150 109 174 52 249 189 155 106 20
	     40 162 4 128 136 188 115 127 243 112 104 223 221 63 96 191 211 97 247 104 74 105 9 149 11 100 237 54 17 135 11 129 232 28 102 110 190 172 127 190 28 240 153 243 129 58 208 71 133 247 34 34 34 31 138 215 171 214 91 220 237 235 102 129 62 100 164 62 128 53 48 87 97 206 56 236 244 40 39 125 6 157
	     54 183 175 111 224 93 106 191 212 150 0 17 37 0 68 228 221 248 199 173 174 61 62 154 177 119 56 225 251 7 135 116 122 125 6 147 130 180 185 76 218 72 112 62 197 121 143 115 1 179 56 47 253 183 151 14 230 29 167 86 247 223 234 34 255 217 230 131 63 230 59 252 184 239 34 34 34 114 169 83 3 47 149
	     4 176 121 211 64 231 18 140 136 115 145 188 156 49 154 228 12 250 57 221 193 148 206 168 98 82 122 30 31 182 237 211 235 77 126 113 117 89 183 95 145 203 48 74 168 180 87 228 253 243 207 135 209 238 62 216 99 107 119 143 253 238 132 130 148 238 112 198 52 175 247 251 251 208 192 37 41 184 0 174
	     222 239 143 217 188 130 191 190 166 95 118 117 192 56 73 0 188 149 253 255 206 206 37 0 94 125 207 191 113 174 95 1 39 61 11 68 68 68 228 117 19 5 14 136 243 155 109 142 21 51 176 130 204 27 237 70 202 106 59 163 217 8 220 185 190 202 250 202 50 63 251 244 42 191 216 12 74 4 136 124 192 84 1 32
	     242 158 249 219 157 169 125 247 112 204 63 255 176 199 222 222 62 195 89 73 99 105 9 23 50 92 163 65 70 221 217 63 158 9 214 95 63 26 190 224 48 128 183 232 212 190 3 17 17 17 249 137 216 83 175 59 23 8 141 54 96 68 43 24 228 37 221 225 8 163 100 175 59 99 99 101 202 184 112 28 140 90 246 23
	     159 170 55 128 136 18 0 34 242 163 252 253 253 67 251 225 201 33 251 125 99 175 95 178 223 155 48 179 148 152 100 148 164 56 18 130 37 56 231 79 110 219 231 143 241 115 188 122 128 237 156 66 114 17 17 145 143 54 17 48 111 248 139 39 206 123 4 196 249 54 129 202 67 140 129 254 52 50 171 70 112
	     175 100 119 199 115 244 164 109 183 174 111 242 127 124 185 161 41 132 200 7 70 91 0 68 222 3 255 239 111 59 246 104 107 151 239 30 238 209 31 23 20 62 197 92 131 144 100 68 159 98 68 204 252 169 219 180 227 131 57 59 239 204 22 128 249 239 110 175 54 95 208 22 0 17 17 145 119 151 18 0 135 39
	     30 223 195 93 149 83 89 73 22 103 248 178 224 250 90 155 91 55 174 242 213 23 55 248 255 252 106 93 73 0 145 15 136 42 0 68 126 34 223 236 79 236 254 78 159 254 112 202 131 237 62 157 222 136 195 97 197 180 52 72 28 33 113 64 0 2 209 62 244 123 171 127 106 106 241 238 191 131 124 172 226 51 158
	     71 122 76 222 206 21 46 34 31 42 119 46 17 224 49 3 231 34 149 121 42 115 148 133 195 74 71 213 47 24 86 29 250 211 146 189 163 158 221 88 111 242 233 245 77 126 118 53 85 50 64 228 125 191 210 85 1 32 242 238 253 143 39 19 219 217 233 241 205 221 93 6 163 49 157 225 12 231 83 8 25 209 121 34
	     190 238 208 107 30 115 154 90 139 188 46 59 215 115 210 217 199 216 133 226 220 164 222 217 27 79 162 169 42 71 228 50 143 32 70 157 54 92 204 78 34 46 70 98 149 147 122 99 165 153 112 117 99 133 47 63 189 197 205 171 171 252 249 103 74 2 136 188 207 84 1 32 242 46 3 255 251 135 182 223 155
	     240 96 103 68 111 48 101 107 119 192 36 47 201 43 72 178 64 195 103 56 231 231 141 242 117 255 20 17 17 145 247 33 5 16 0 79 156 111 70 172 98 73 94 150 88 89 48 152 228 12 102 35 134 211 29 30 239 245 216 63 108 218 198 74 202 191 249 249 53 77 100 68 148 0 16 249 120 253 167 223 238 217 221
	     71 251 236 119 135 28 12 166 152 75 113 73 66 43 105 146 16 112 132 58 248 199 97 22 245 128 137 136 136 200 79 238 236 121 1 245 60 197 133 132 134 111 225 155 13 188 1 46 210 237 245 24 12 58 76 250 13 54 215 90 120 195 254 245 215 74 2 136 40 1 32 242 17 185 123 52 181 237 206 144 189 206
	     140 199 219 93 30 62 233 48 24 77 24 21 145 70 195 225 27 77 92 8 120 159 97 230 136 44 74 237 116 191 20 121 83 116 53 233 49 17 145 55 193 207 147 0 14 92 192 121 7 68 98 52 38 101 206 112 150 83 21 57 195 225 140 253 110 206 180 242 236 246 166 246 217 213 37 86 151 26 252 252 218 146 134
	     30 17 37 0 68 46 175 191 223 206 109 255 96 192 253 237 3 58 131 25 131 73 65 137 35 105 182 104 55 60 206 39 152 79 112 120 176 8 248 122 82 254 84 215 124 94 185 107 190 136 204 3 93 123 234 12 138 143 144 61 247 49 121 253 148 129 41 161 32 242 17 142 37 238 212 88 178 120 135 79 18 188 107
	     146 166 41 193 67 225 60 123 71 35 134 195 9 189 78 155 107 155 27 76 98 98 127 120 163 161 225 66 68 9 0 145 203 229 155 131 177 245 70 240 221 163 62 79 246 143 120 188 123 196 104 86 225 66 2 62 16 66 130 15 233 201 93 243 56 184 183 83 47 21 178 136 188 177 36 128 30 2 61 38 34 242 198 19
	     1 39 111 213 21 1 62 109 226 2 148 86 145 151 145 193 209 140 152 207 120 114 48 225 234 102 69 119 22 153 22 43 246 127 126 178 162 33 72 68 9 0 145 203 225 239 239 29 217 189 189 30 131 81 197 227 131 17 189 81 206 172 242 224 61 184 4 243 1 124 130 89 56 158 129 219 185 89 185 59 117 91 180
	     11 138 1 68 68 68 68 222 143 52 128 175 95 51 48 234 109 1 102 30 51 131 16 113 41 204 42 79 103 56 225 193 147 3 102 179 30 135 123 13 251 226 230 117 126 117 123 89 137 0 145 159 128 142 1 20 121 3 190 217 203 237 222 147 30 91 187 135 60 216 62 100 58 45 24 229 70 12 25 49 105 212 71 252
	     153 35 186 186 204 223 240 120 87 223 62 207 92 131 199 9 128 120 42 1 224 208 122 157 136 252 196 211 133 103 78 255 69 68 169 0 12 156 243 56 87 119 50 50 51 156 69 192 112 85 142 197 2 111 57 137 207 217 88 105 241 139 79 111 243 249 173 27 252 229 47 213 23 64 228 93 83 5 128 200 143 240
	     221 65 110 91 251 61 246 143 70 60 218 237 211 27 77 233 12 75 202 42 82 90 128 16 240 46 96 46 204 39 208 14 155 31 240 103 207 190 135 114 182 60 64 247 70 145 203 16 50 191 47 225 178 61 35 150 119 47 154 224 139 136 60 107 180 115 96 103 154 24 59 204 121 156 131 104 1 179 138 162 130 105
	     225 136 86 114 247 73 135 225 36 114 216 111 218 198 74 198 39 215 214 248 234 138 250 3 136 188 147 43 86 21 0 34 175 231 55 7 51 251 237 247 29 190 127 176 203 81 191 207 112 90 16 146 12 115 25 56 135 185 128 225 136 174 62 59 151 121 216 127 124 123 92 252 165 107 80 68 9 128 119 156 0 176
	     167 38 3 74 53 138 200 27 24 247 22 235 23 118 122 28 172 234 102 199 22 129 136 139 21 206 74 82 7 237 102 96 125 165 205 207 62 189 206 207 62 187 194 191 184 149 105 40 18 121 203 84 1 32 242 138 190 221 238 218 86 111 196 227 195 25 15 30 143 216 218 27 49 158 21 84 56 154 46 144 100 41 222
	     123 140 112 46 182 159 239 150 155 223 218 98 172 55 248 59 167 123 157 136 188 195 9 186 169 184 72 68 222 142 122 110 195 241 220 166 94 244 240 224 252 226 20 65 42 43 201 139 72 44 75 250 211 138 254 4 242 106 159 193 104 202 81 167 105 87 215 26 252 241 157 77 141 80 34 111 109 30 160 213
	     71 145 151 246 255 253 187 29 219 221 59 226 241 193 17 157 113 201 180 74 153 85 9 145 0 62 224 156 195 121 207 241 93 238 162 139 110 126 83 140 49 158 121 91 68 46 217 13 246 220 219 239 219 221 54 186 179 73 1 141 68 34 242 99 45 226 138 231 205 109 204 12 155 87 4 56 34 1 35 216 148 150
	     47 89 111 7 110 94 93 231 235 47 111 242 127 253 234 154 134 37 145 183 64 21 0 34 47 225 175 238 238 219 225 209 140 239 31 118 216 61 232 113 212 31 146 87 70 104 57 66 214 32 9 13 240 9 209 12 172 222 229 239 230 141 252 68 68 222 71 207 236 69 34 34 242 22 71 30 231 60 222 215 189 145 140
	     146 170 42 152 76 43 6 211 9 221 30 244 38 48 45 29 195 217 204 62 185 190 194 31 221 90 83 34 64 228 77 94 133 170 0 16 121 182 255 254 96 102 79 158 236 241 96 103 143 209 164 162 63 174 152 230 21 121 52 34 30 146 20 231 83 156 243 224 2 102 139 125 254 14 247 130 169 245 203 100 201 69 228
	     109 132 189 47 98 151 246 95 108 207 120 93 163 144 136 188 137 113 198 94 250 51 23 159 95 129 85 88 149 227 98 137 183 72 35 9 52 50 88 110 192 245 245 37 62 189 121 131 207 110 95 229 15 111 37 26 170 68 222 0 85 0 136 92 224 183 7 35 219 57 170 248 238 97 159 199 187 7 236 28 116 137 21 248
	     36 195 39 41 33 107 224 125 32 178 232 166 101 103 154 249 61 47 248 87 210 77 68 222 183 196 128 136 200 187 73 4 216 185 207 175 79 10 240 89 171 126 71 140 228 177 96 216 31 179 155 79 217 61 154 113 48 74 232 78 29 157 81 203 110 108 4 126 121 69 71 7 138 252 168 235 84 193 136 200 89 255
	     245 55 219 246 112 175 203 65 191 100 183 95 48 156 230 140 102 21 102 14 31 230 43 254 222 207 87 238 23 161 190 189 244 116 90 43 255 34 239 123 216 107 151 250 95 172 187 190 136 188 171 113 230 184 25 224 51 226 141 250 227 145 186 119 82 172 183 81 198 138 170 204 177 178 36 13 176 220
	     202 88 95 201 88 109 26 215 86 19 62 187 113 141 127 243 123 55 52 137 18 121 77 170 0 16 153 251 237 94 105 143 119 186 124 127 111 159 71 187 71 244 167 21 133 11 184 36 35 109 44 97 120 32 28 7 252 246 202 65 5 10 252 69 68 68 228 210 249 113 137 69 63 79 18 212 11 43 120 79 154 165 248 134
	     65 44 25 206 102 140 166 93 182 138 41 79 218 41 71 3 99 74 203 62 187 213 230 235 117 109 11 16 81 2 64 228 21 253 195 246 208 14 59 3 118 15 103 236 29 14 217 239 142 24 228 144 71 71 244 1 111 161 62 56 251 204 145 54 238 141 221 246 68 228 195 153 166 190 179 223 242 13 86 10 189 173 189
	     254 175 243 59 58 59 183 255 215 105 252 20 209 168 124 50 66 29 47 178 56 168 112 152 65 101 96 149 195 98 96 48 115 60 57 28 225 195 14 7 71 25 15 215 50 187 125 99 157 223 187 214 86 34 64 68 9 0 145 23 251 223 79 198 246 253 131 35 30 111 29 177 223 25 50 201 75 44 164 144 181 201 210 249
	     30 127 87 199 255 139 155 146 238 48 34 242 225 79 180 69 68 222 193 152 99 246 74 31 63 238 33 96 0 17 156 35 36 41 36 1 215 104 1 70 119 82 49 121 188 79 178 5 87 214 218 252 108 108 84 62 177 63 184 146 105 138 38 162 4 128 200 197 254 241 209 145 61 25 76 216 62 152 240 100 127 194 222 254
	     152 254 36 167 52 71 214 72 72 179 12 188 167 206 70 219 60 236 215 125 69 68 222 156 211 43 231 23 77 146 127 202 237 66 207 219 183 251 114 123 122 95 110 242 47 34 151 32 200 231 233 41 210 155 41 238 241 245 247 246 139 186 75 71 101 145 188 154 49 158 21 88 85 49 45 29 22 14 41 202 156
	     254 205 101 91 111 166 252 250 246 186 38 108 34 207 187 199 235 230 44 31 155 255 240 143 251 246 96 107 151 237 163 30 131 105 69 30 83 242 210 83 152 39 186 4 231 2 206 47 238 29 186 135 136 200 79 147 0 120 31 126 183 55 157 0 208 22 0 145 203 39 158 155 46 185 55 150 0 120 106 116 1 34 49
	     26 206 10 156 69 178 16 73 172 160 25 42 174 174 53 185 177 185 206 215 95 221 228 207 191 92 211 4 78 228 25 84 1 32 31 141 191 121 220 177 237 253 9 247 182 122 60 222 238 210 237 143 40 112 36 141 128 79 83 124 146 226 92 138 197 147 22 127 167 166 177 63 226 39 235 180 109 17 5 250 175 183
	     103 126 241 53 222 251 183 155 44 48 123 170 107 247 219 121 48 244 124 16 185 156 236 141 92 228 167 199 183 197 105 75 167 7 16 195 227 131 195 225 112 46 82 197 130 233 100 74 103 58 162 55 200 233 142 140 194 5 246 122 3 251 244 198 50 127 114 75 213 0 34 79 221 138 85 1 32 151 221 63 238
	     87 246 237 221 39 60 220 222 163 63 46 25 205 96 52 45 168 42 35 186 128 11 25 248 128 115 1 115 126 222 133 150 23 38 0 220 11 66 253 249 21 118 238 189 94 155 112 69 222 237 109 238 69 87 233 79 150 0 120 149 189 177 111 50 1 224 158 241 179 78 39 0 94 246 119 124 221 199 226 173 38 51 68 228
	     221 7 255 139 37 127 243 207 24 113 94 238 90 127 170 106 200 249 167 71 112 103 56 98 253 86 140 88 85 96 85 78 226 34 105 146 176 210 78 9 20 92 223 88 226 214 181 171 252 242 139 155 252 193 141 160 68 128 200 156 42 0 228 210 250 161 55 182 163 33 124 247 104 200 63 223 59 96 123 183 67 89
	     65 218 108 225 66 70 210 72 241 62 96 230 230 55 28 7 166 38 127 34 34 111 154 142 63 21 185 228 9 128 183 38 158 73 36 184 51 63 207 97 62 224 67 192 187 38 22 75 102 101 201 164 55 101 58 30 115 216 157 178 223 55 10 75 25 204 150 236 230 170 231 203 245 150 6 35 209 61 89 217 119 185 108
	     238 117 167 118 255 201 1 91 123 93 186 3 99 127 144 115 56 152 49 158 69 162 121 146 180 94 241 15 62 1 239 206 221 183 140 151 45 95 83 5 128 200 7 113 155 123 135 19 213 231 7 191 103 43 0 140 23 221 126 143 63 31 78 245 37 129 31 123 219 118 207 249 89 243 95 112 113 234 41 111 106 138 240
	     172 4 128 230 32 34 151 65 60 181 208 255 102 43 0 46 28 67 220 201 92 109 209 127 192 1 49 70 136 21 177 202 169 138 146 134 171 200 210 192 245 141 38 171 173 192 205 141 6 95 222 190 206 159 255 252 138 146 0 242 81 83 5 128 92 42 223 245 166 246 221 131 14 63 60 220 231 241 147 35 198 179
	     146 130 4 151 181 105 46 173 96 22 176 249 57 179 102 118 170 33 213 155 217 187 38 34 242 162 9 109 52 123 169 209 230 108 51 189 183 158 165 56 247 59 191 155 199 66 68 228 217 227 222 51 198 139 197 220 205 205 255 178 249 242 141 243 184 36 16 146 132 86 19 168 114 170 98 198 238 65 143
	     221 42 103 255 160 73 127 228 24 230 193 190 250 100 137 47 87 83 77 250 68 9 0 145 15 213 223 220 31 216 214 126 151 163 254 152 173 131 1 189 225 148 238 20 170 42 96 62 193 91 32 68 207 73 241 216 187 28 243 79 255 172 151 175 48 16 145 15 114 246 250 156 40 218 61 119 28 120 222 103 191
	     245 36 197 143 28 217 78 79 214 207 174 246 219 153 215 236 5 223 67 68 62 200 129 239 61 249 201 14 172 110 20 88 97 152 5 42 18 40 3 177 74 176 145 81 110 119 232 140 11 182 15 86 248 205 74 106 95 220 90 231 15 110 46 105 40 146 143 235 138 85 54 94 62 116 127 125 127 108 247 30 28 241 195
	     195 93 122 163 17 227 89 73 218 108 66 8 68 2 70 160 194 99 230 95 233 38 245 211 23 14 139 200 135 23 255 191 202 209 126 47 59 30 217 27 93 145 127 169 237 75 231 62 209 189 196 239 122 146 0 88 124 177 61 245 51 236 157 28 21 38 34 82 215 123 122 51 60 17 239 34 142 138 178 200 193 34 203
	     173 148 181 229 54 191 248 226 42 183 175 175 243 23 95 40 9 32 31 15 85 0 200 7 233 135 253 177 237 247 250 108 119 70 60 217 47 216 235 228 60 57 154 50 45 42 204 2 205 144 16 92 130 115 1 156 71 173 253 68 228 93 76 56 207 174 238 219 185 88 250 236 199 236 169 143 251 227 207 91 124 204
	     108 254 151 197 55 250 91 190 108 166 160 62 106 203 61 181 69 224 228 183 182 103 252 132 240 156 244 131 182 92 137 200 11 134 159 31 125 18 201 124 187 167 115 84 230 137 24 149 57 102 101 73 89 84 140 242 130 193 116 76 101 251 108 237 118 56 60 90 178 141 229 22 127 249 139 155 26 152 68
	     9 0 145 247 209 221 39 3 238 63 222 101 231 168 79 127 6 230 155 52 90 13 146 86 139 56 159 68 155 171 203 192 206 44 57 137 136 188 141 201 234 34 168 181 197 95 241 169 211 171 207 175 118 27 213 113 48 188 56 239 250 56 61 112 106 210 107 206 230 39 148 196 249 215 189 155 49 109 241 251
	     58 252 34 27 112 252 207 91 140 177 103 18 0 206 157 43 243 63 123 144 234 233 42 130 147 207 244 122 242 136 200 83 129 255 27 29 153 157 97 206 225 92 32 107 182 105 52 235 218 208 132 72 175 63 162 115 56 99 50 104 112 101 125 13 23 83 251 55 191 82 147 64 81 2 64 228 189 241 223 127 216
	     183 221 78 206 221 71 29 182 118 122 116 199 19 74 11 100 173 4 75 154 120 31 192 133 249 153 214 238 220 20 20 84 200 47 242 49 58 189 15 221 61 99 154 248 244 104 241 50 35 198 188 159 255 60 184 141 117 23 106 91 36 0 226 73 115 42 139 56 139 117 96 111 96 68 88 156 99 125 28 112 47 126 126
	     196 78 37 16 178 16 72 179 64 226 234 85 245 104 23 133 216 47 251 8 188 220 103 56 234 227 81 35 80 85 145 170 140 148 85 164 194 142 43 2 108 94 33 176 232 192 141 115 117 177 2 30 168 171 175 234 207 157 63 238 206 31 191 47 46 42 11 78 37 6 236 5 143 243 235 254 203 68 228 253 26 135 95 109
	     244 122 253 224 31 140 56 79 174 30 191 47 212 239 175 162 163 172 10 38 211 138 233 36 103 60 43 57 26 26 165 75 217 29 76 236 198 70 131 235 235 203 124 125 85 199 6 138 18 0 34 63 137 191 123 82 216 238 222 62 247 183 15 232 143 74 58 195 156 130 64 214 90 38 184 128 243 105 61 185 4 204
	     226 98 250 122 193 141 230 229 219 106 105 90 41 114 9 184 167 91 207 157 79 2 56 123 81 154 208 61 61 97 117 167 191 91 253 29 231 177 253 113 201 190 89 133 179 72 36 66 140 184 249 251 99 140 243 113 170 78 18 204 243 5 56 115 117 233 191 69 204 85 56 192 59 135 107 101 52 125 155 102 230
	     49 140 50 218 185 234 130 55 48 150 185 167 223 172 42 168 42 99 86 204 40 242 156 178 168 40 163 225 195 188 186 202 213 171 117 206 215 199 6 154 49 223 114 229 113 62 128 15 128 199 123 143 17 192 25 206 27 230 60 230 234 170 2 239 23 63 205 93 240 11 219 241 75 123 230 175 250 46 91 37 138
	     200 235 135 227 246 194 129 103 113 66 211 51 199 178 211 201 207 103 84 10 28 191 223 22 155 178 78 170 179 252 98 124 118 17 156 195 135 128 107 52 105 39 9 169 143 148 4 118 14 251 236 119 186 108 173 180 248 252 246 13 198 85 106 127 124 35 81 18 64 148 0 16 121 87 126 187 55 180 195 113
	     228 187 135 125 118 247 142 216 218 237 144 23 145 24 2 33 105 224 211 172 222 231 111 28 175 193 189 220 76 87 147 69 17 121 58 112 60 91 202 95 191 18 45 214 227 75 156 151 224 207 135 16 91 212 195 91 5 56 130 55 18 231 8 137 39 241 1 143 39 241 224 157 225 93 29 180 123 111 120 239 241 14
	     176 136 119 70 112 144 120 195 205 107 238 157 197 58 88 166 254 88 187 213 96 121 105 153 70 35 195 12 98 85 61 47 118 127 189 4 128 127 186 2 160 170 140 170 138 76 167 83 102 211 25 179 188 162 52 131 224 231 229 255 204 87 209 234 149 127 231 32 226 137 209 81 153 163 138 117 141 67 172
	     160 194 83 197 122 2 95 69 35 82 81 89 69 85 24 102 174 78 126 184 58 145 128 155 39 67 92 157 0 193 185 179 219 7 220 211 255 114 123 234 100 5 245 25 16 145 179 34 139 77 71 243 170 35 151 224 210 64 72 155 84 177 164 168 42 6 221 41 211 201 132 102 54 225 112 232 233 78 97 86 172 216 70 211
	     248 250 170 26 5 138 18 0 34 111 213 95 255 243 150 221 219 237 211 27 71 118 142 166 76 102 21 37 41 49 24 36 9 49 36 243 85 255 147 213 163 11 219 81 217 201 71 156 243 199 29 170 117 2 134 200 199 199 205 227 196 211 187 209 23 85 2 139 145 196 91 93 132 111 24 177 42 137 85 69 140 21 85 172
	     3 239 104 134 69 35 70 131 202 234 253 165 22 105 164 129 86 163 65 35 109 210 200 82 146 196 211 106 38 164 62 144 165 30 12 154 205 64 171 149 145 165 9 86 213 1 126 171 13 173 166 145 206 251 230 5 171 147 1 139 223 39 77 2 105 154 18 66 253 9 22 79 198 174 151 57 219 100 94 96 240 130 7 230
	     233 55 45 214 143 67 85 150 148 101 69 21 99 189 105 193 57 162 115 84 6 147 41 76 167 48 155 65 8 245 195 81 148 145 201 172 96 54 171 40 171 200 36 47 41 170 200 108 90 82 86 145 105 158 99 49 82 204 10 102 179 146 170 138 224 61 105 240 224 235 0 223 185 128 243 144 248 128 115 1 31 60 62
	     132 121 50 224 212 111 105 28 255 135 154 93 116 122 139 142 94 21 185 52 227 183 123 249 211 72 206 140 101 167 198 184 122 74 184 72 42 214 155 173 188 171 147 1 230 29 70 3 159 121 204 195 209 112 140 123 180 71 49 233 178 185 146 48 25 111 218 31 125 182 161 1 69 46 193 92 72 65 144 188
	     103 254 121 127 108 63 108 117 185 247 112 151 7 79 142 152 22 198 164 242 164 105 11 146 6 209 59 240 126 222 224 111 190 127 212 158 189 170 111 103 122 84 45 18 0 166 4 128 200 229 186 157 93 16 246 46 98 68 59 187 178 111 243 232 118 94 110 143 171 95 119 198 124 223 190 213 173 68 231 171
	     243 193 57 156 183 58 48 93 236 129 199 8 206 207 143 151 114 224 34 141 44 101 169 217 100 101 185 77 171 217 36 77 2 173 118 131 44 36 52 211 128 25 180 91 9 75 203 9 141 204 65 85 7 187 237 38 180 3 100 238 236 191 100 49 170 157 95 241 118 47 248 151 115 241 35 241 90 236 236 95 167 138
	     242 235 164 194 184 130 73 5 211 25 4 95 191 111 150 27 227 113 69 62 171 200 203 138 225 52 167 172 74 38 227 25 101 140 140 167 83 138 178 98 60 153 50 155 149 228 69 73 25 235 102 131 145 69 66 197 205 255 24 139 60 75 52 78 53 25 244 167 254 245 126 190 173 96 81 62 224 142 123 19 68 91 52
	     87 188 232 244 1 221 3 68 222 13 187 96 11 128 227 93 116 105 50 119 65 247 129 197 220 241 204 184 230 240 139 19 88 28 96 37 213 108 138 143 57 203 73 197 234 82 131 47 238 92 229 234 149 43 252 236 147 37 126 239 154 122 3 136 18 0 34 63 218 63 110 79 237 201 65 135 237 189 46 219 7 35 250
	     163 130 163 225 24 139 80 184 148 36 109 224 147 12 243 245 18 145 179 186 217 159 59 51 85 126 217 32 65 207 123 185 140 83 172 231 31 122 225 236 197 193 99 221 64 243 36 234 60 221 163 253 244 177 76 47 186 130 78 206 132 127 91 115 164 243 85 63 79 255 203 220 233 4 192 188 147 190 89 133
	     85 21 85 44 32 150 88 89 98 22 113 177 94 229 119 22 177 104 36 73 66 22 60 43 75 77 150 150 26 180 91 77 154 89 66 18 28 141 36 33 36 129 165 86 74 163 9 237 196 205 75 251 3 89 154 208 108 100 164 73 74 240 142 52 73 8 193 147 4 143 51 72 83 71 150 213 193 242 226 183 78 231 127 194 7 248
	     156 43 129 217 252 165 159 255 127 148 17 138 2 202 2 170 24 201 171 186 122 160 200 75 42 51 138 162 160 178 72 145 215 143 249 180 136 12 199 145 241 52 50 205 11 162 69 138 162 162 40 35 227 105 206 116 50 101 48 158 50 154 150 228 101 69 140 134 247 14 124 192 187 121 175 129 80 55 128 117
	     33 224 67 74 240 9 206 123 170 186 55 227 113 162 120 49 221 175 91 198 68 176 31 119 59 120 91 207 243 120 174 221 132 179 231 167 188 236 133 9 49 221 247 228 167 190 59 185 159 252 55 88 92 1 254 25 137 135 227 228 171 3 179 146 34 159 65 53 35 177 146 102 234 89 95 105 210 106 100 124 122
	     99 133 205 181 37 190 184 185 201 175 111 54 148 8 144 15 142 182 0 200 123 225 111 183 103 246 187 31 186 124 255 96 155 253 195 14 211 202 209 104 181 9 173 85 60 144 16 136 243 86 91 199 43 254 102 231 14 153 122 217 91 128 200 229 157 98 125 108 255 218 167 198 0 59 41 247 180 69 70 196
	     140 232 42 156 25 206 85 120 31 73 125 61 9 244 105 192 89 66 160 4 243 132 121 241 127 51 75 105 165 129 205 245 101 214 86 151 88 91 89 98 169 213 36 77 61 75 141 140 52 4 86 87 2 173 12 26 225 108 255 17 239 79 246 172 159 94 188 63 211 74 240 236 233 121 84 212 127 206 245 171 126 239 58
	     150 216 185 233 188 1 169 213 9 140 197 239 108 14 200 192 210 197 198 138 100 222 220 43 59 14 152 79 142 19 52 170 8 227 194 232 142 35 227 73 73 89 149 76 243 146 89 94 49 24 142 232 15 71 28 245 2 195 209 148 113 94 80 150 117 195 129 202 2 230 147 122 75 2 142 104 14 115 70 101 21 86 81
	     87 16 28 7 230 167 142 132 117 167 210 71 206 78 158 51 239 201 145 132 81 67 153 92 58 238 189 248 13 220 51 63 246 212 25 173 56 28 89 214 0 18 156 69 42 139 28 14 103 148 71 67 142 186 67 214 86 150 233 143 161 95 110 216 191 250 164 169 36 128 40 1 32 242 50 190 221 27 89 119 56 226 254
	     222 144 222 32 178 181 63 101 231 112 66 127 2 248 148 24 83 146 144 18 49 156 243 243 137 163 67 251 57 69 62 128 233 222 91 90 249 95 28 187 119 38 92 91 236 237 52 195 230 29 246 99 172 234 110 251 209 136 49 82 150 5 222 65 154 122 150 219 25 75 205 140 165 102 74 43 203 104 36 41 173 6 100
	     73 164 153 25 73 48 90 105 160 145 4 150 150 154 180 155 13 150 91 77 154 89 74 8 158 86 226 8 190 46 219 127 23 65 223 251 52 226 185 139 38 212 238 121 159 252 114 27 22 86 27 176 177 12 179 34 163 140 144 23 21 69 21 153 76 90 140 242 21 134 147 41 179 105 193 180 172 152 22 198 52 119 245
	     159 210 145 151 145 105 62 99 58 43 25 77 10 134 147 25 211 105 78 25 35 132 64 18 82 156 247 120 231 113 97 113 42 129 39 120 191 152 233 207 183 23 156 164 53 220 51 122 150 191 171 4 139 136 252 212 252 124 184 242 84 24 85 172 40 202 138 178 172 200 135 21 195 124 76 101 187 28 246 250 236
	     238 182 236 206 181 37 174 172 44 241 229 134 146 1 242 1 204 209 180 5 64 126 10 223 29 206 236 119 63 236 179 181 123 192 131 157 14 69 229 41 93 131 130 64 229 18 162 213 165 157 245 57 211 241 212 100 76 13 157 68 158 27 68 254 216 45 0 47 17 174 189 212 102 155 83 219 5 222 100 120 228
	     230 123 52 231 59 191 231 101 253 243 166 121 243 125 253 102 113 126 12 223 226 227 145 50 47 234 166 124 141 148 43 235 43 108 172 45 179 182 178 196 202 242 18 75 141 148 213 37 79 171 105 44 101 142 102 176 186 66 192 57 188 119 120 239 9 206 17 230 255 166 224 234 213 161 224 223 110 74
	     242 125 188 59 159 47 59 119 111 240 185 27 173 126 89 213 229 2 24 245 137 1 149 213 73 156 104 117 3 198 105 229 24 22 198 112 2 195 177 99 146 151 140 198 35 6 195 41 221 222 152 163 94 143 254 112 200 44 47 32 36 36 33 35 58 87 63 39 93 56 158 212 251 249 4 223 220 252 32 71 155 247 18 192
	     230 187 129 221 187 123 126 159 170 140 168 219 22 184 179 137 22 109 1 16 121 75 35 217 203 95 27 102 245 209 173 222 42 28 37 169 229 4 43 88 95 106 114 251 218 26 159 223 185 202 255 243 71 55 52 73 149 247 158 42 0 228 157 250 102 103 104 15 247 199 116 250 83 190 125 112 200 97 175 207
	     65 111 2 46 33 107 37 248 70 70 8 25 129 64 92 28 185 245 158 148 101 138 124 8 83 26 187 84 255 26 119 46 68 52 162 85 16 35 102 21 49 150 16 35 177 44 193 74 146 224 104 53 82 90 141 148 70 35 163 145 37 52 210 132 102 22 72 2 180 26 142 86 150 176 186 188 204 242 82 139 149 118 139 86 59 163
	     153 66 187 5 77 234 63 238 61 122 4 62 164 41 244 143 225 161 62 26 241 248 27 207 255 255 159 81 101 49 3 166 192 56 135 89 158 49 157 101 76 38 57 131 209 18 195 97 147 209 120 149 113 94 49 45 28 211 60 50 203 43 38 69 65 81 84 76 243 130 201 172 164 200 35 17 195 39 9 206 39 224 18 240 73
	     157 4 240 139 45 28 243 215 231 219 21 48 37 161 69 62 198 100 129 225 192 121 156 135 88 21 196 24 153 206 140 98 90 48 24 69 250 19 163 59 53 186 227 153 109 172 52 248 228 234 18 191 186 177 172 193 66 148 0 144 143 219 95 223 157 218 147 221 14 247 158 236 51 157 69 142 6 57 149 79 88 94
	     93 199 8 88 72 235 213 153 249 42 158 123 193 250 134 136 92 48 77 177 103 135 104 23 21 53 191 176 153 223 27 250 221 158 223 44 237 89 199 120 218 185 215 109 190 109 187 130 88 97 243 70 126 148 57 102 21 193 39 180 179 148 205 213 140 213 229 54 107 203 75 44 47 181 89 95 78 89 89 10 44 53
	     28 169 135 16 18 188 15 36 137 39 245 134 119 142 96 117 0 90 112 114 180 158 187 224 81 212 108 238 237 59 221 95 224 212 255 252 153 63 0 153 129 79 160 237 33 102 158 170 221 160 88 79 176 170 69 25 35 211 210 232 143 35 135 189 156 225 104 74 119 48 100 52 205 233 245 192 202 130 42 230
	     243 68 179 213 179 33 111 204 203 206 48 171 79 155 57 126 22 186 211 103 136 185 83 39 35 156 77 187 45 158 231 222 251 167 222 247 252 139 247 92 207 8 123 241 115 206 222 201 149 43 114 89 71 153 103 95 99 118 193 91 199 159 19 231 21 104 62 33 52 150 72 211 6 9 145 2 216 235 14 25 79 38 44
	     55 19 122 189 235 236 119 131 253 219 95 234 180 0 81 2 64 62 66 127 251 164 111 91 123 57 247 158 12 216 61 234 177 123 48 32 98 148 150 144 53 50 210 180 1 206 215 19 174 227 110 76 154 188 136 188 118 18 224 125 152 94 189 82 105 116 93 237 179 232 34 95 175 178 214 29 218 163 25 88 221 157
	     223 57 234 46 252 45 79 51 100 164 73 139 204 67 230 75 26 105 100 185 25 88 93 90 98 109 173 205 106 187 85 151 248 183 91 172 45 57 150 95 178 144 104 113 188 157 93 240 120 94 116 136 156 102 118 111 62 240 95 220 6 230 177 248 113 136 109 167 38 46 158 83 89 26 191 120 246 192 249 146 129
	     28 56 28 49 79 0 180 24 207 102 244 250 83 70 227 49 253 241 140 73 97 76 203 64 17 61 121 105 76 243 200 180 138 204 202 25 22 29 49 206 43 0 124 32 224 112 206 191 245 171 78 207 41 145 247 57 105 96 243 163 70 83 92 2 206 165 84 101 69 94 149 244 7 57 251 157 49 89 8 244 198 158 43 157 130
	     193 116 213 174 110 36 252 217 103 171 186 180 69 9 0 249 56 252 151 223 238 218 214 126 135 157 195 49 251 253 130 89 229 9 141 214 124 47 114 192 135 64 196 115 18 43 56 133 254 34 63 101 2 225 57 123 155 207 175 222 63 47 200 63 191 226 127 254 101 189 87 191 126 233 78 173 176 212 141 252
	     12 179 250 120 190 170 44 137 69 129 89 221 185 63 107 102 180 150 150 88 93 94 102 101 169 197 82 35 225 202 138 99 125 5 150 83 71 150 38 164 141 148 102 18 104 134 148 70 234 72 220 203 7 235 142 167 123 193 187 83 73 138 103 87 3 168 65 233 155 10 124 221 185 35 240 140 147 170 12 120 181
	     94 253 222 96 41 131 212 165 180 154 109 138 170 201 244 202 50 86 148 140 203 138 193 12 246 123 70 111 84 49 154 204 56 236 245 41 70 19 170 233 132 50 26 209 0 31 72 146 4 66 66 8 41 193 7 108 177 41 223 78 87 175 184 121 96 240 166 123 95 136 200 251 114 79 60 62 124 218 205 239 92 230 235
	     97 32 56 18 231 112 73 192 59 99 52 157 81 29 29 66 57 224 224 32 97 54 152 216 191 253 125 245 7 16 37 0 228 18 251 155 173 161 237 29 78 248 225 193 1 91 187 135 116 135 19 102 209 145 53 87 177 180 93 55 208 114 225 248 60 241 103 21 0 139 200 101 117 210 180 207 213 45 224 112 17 82 23 241
	     14 66 18 241 206 145 180 60 169 107 144 5 71 35 243 44 47 181 216 88 91 97 109 117 133 181 213 101 86 90 41 87 55 224 74 58 63 138 238 204 113 123 238 204 219 175 26 136 190 236 251 229 45 39 4 126 196 227 159 56 88 73 129 36 96 52 79 158 125 243 42 131 49 176 51 128 163 190 49 28 142 216 239
	     4 6 195 140 163 94 32 47 35 121 94 223 163 202 8 149 57 202 88 206 183 14 24 17 95 111 91 91 84 29 184 160 103 137 200 199 54 58 205 143 27 117 46 224 124 130 163 194 172 162 63 155 210 27 143 233 116 35 237 52 208 29 86 12 242 196 62 191 181 196 239 223 212 73 1 162 4 128 92 166 192 255 209
	     200 122 195 1 143 119 7 244 134 51 14 122 99 38 51 35 186 4 23 146 122 194 180 24 58 205 142 59 31 107 206 36 242 118 130 236 87 254 138 151 88 185 124 249 61 205 238 153 59 45 205 28 209 12 139 57 148 37 101 145 67 25 9 222 200 210 132 165 86 160 213 72 89 95 110 179 177 178 204 250 74 131
	     213 101 104 53 18 150 91 77 178 70 131 118 51 163 145 193 114 6 153 123 219 167 184 251 23 60 158 238 153 143 211 219 58 18 241 178 62 67 223 244 163 181 232 41 120 166 175 204 252 213 38 112 101 9 90 193 49 93 106 113 109 21 166 211 22 221 201 10 179 153 209 31 70 242 50 210 29 12 233 15 167
	     116 251 99 38 163 9 165 25 149 15 164 73 3 151 54 240 62 193 135 0 206 213 171 129 118 113 15 155 183 150 236 118 118 193 3 171 231 157 124 140 177 249 171 95 11 246 26 247 187 147 237 106 118 238 234 246 56 7 230 19 136 70 21 75 166 149 99 175 59 166 138 219 116 7 75 236 28 46 217 141 43 43
	     252 193 77 245 7 144 159 234 50 81 153 154 188 1 223 116 11 219 59 204 249 230 254 33 251 135 29 118 59 93 138 138 186 163 50 1 115 245 31 240 243 151 245 96 169 9 178 200 7 116 195 120 165 163 207 206 157 165 110 156 90 141 175 87 252 61 17 239 42 66 140 184 88 226 173 162 157 122 218 173 132
	     181 149 38 43 237 6 215 55 55 184 117 125 131 235 27 9 107 169 225 156 195 207 143 116 171 143 117 59 91 50 190 8 213 207 7 147 63 197 8 163 241 237 253 72 0 156 111 38 120 254 125 199 125 7 12 226 252 248 200 50 26 51 131 206 16 38 185 177 115 216 229 240 176 199 206 126 135 163 238 144 105
	     21 201 43 15 105 70 69 10 230 137 46 153 215 179 184 250 244 26 199 187 59 53 192 217 217 71 211 180 37 69 62 230 4 192 79 123 45 56 172 110 86 107 134 163 194 97 196 50 199 202 156 102 150 112 117 125 157 175 62 221 228 215 95 110 242 39 119 148 4 144 119 79 21 0 242 163 220 61 154 218 81 119
	     192 131 253 49 71 131 138 71 187 3 186 195 9 131 145 97 206 145 54 18 124 146 226 93 192 121 79 60 119 80 185 38 198 34 31 80 176 246 18 129 191 59 19 96 213 19 177 122 79 191 81 150 37 101 81 80 197 18 71 164 153 6 150 91 13 150 218 45 54 150 27 180 51 216 92 173 87 255 55 218 25 205 70 194
	     250 202 10 87 214 26 172 102 207 191 97 197 23 252 62 63 69 112 175 241 141 151 126 190 188 139 159 113 58 20 63 85 139 50 111 40 184 200 78 157 164 143 150 129 102 10 179 8 237 198 10 215 86 3 215 54 50 122 147 53 70 211 72 119 8 195 89 228 176 55 101 50 205 25 141 39 68 51 162 119 120 159
	     144 102 25 62 4 156 243 248 197 193 1 139 213 193 250 168 129 103 94 91 122 238 136 124 24 247 195 139 78 252 48 28 206 37 224 12 51 143 17 201 45 82 84 37 211 73 164 98 140 15 142 88 77 217 63 108 218 205 181 6 75 203 75 124 117 69 201 0 121 71 247 94 85 0 200 235 250 167 237 153 253 240 224
	     144 173 157 125 182 14 251 204 162 103 92 122 42 231 137 150 128 115 120 95 175 252 107 68 19 249 88 2 186 197 222 254 136 119 6 206 230 77 63 141 88 150 148 85 129 179 146 196 59 86 219 45 54 215 87 216 92 95 229 147 91 155 172 45 123 110 172 123 154 193 177 228 93 221 11 32 4 146 224 120 223
	     118 87 107 117 255 210 204 226 79 71 221 167 210 2 245 243 173 162 78 46 149 149 17 99 164 168 34 121 140 12 75 216 237 25 7 157 41 15 30 31 210 31 12 57 56 234 83 86 21 69 172 207 39 12 73 130 249 4 231 61 14 79 52 87 183 188 244 190 126 25 121 115 9 0 85 0 136 188 211 107 225 213 142 252 140
	     88 180 250 152 107 139 4 34 169 175 104 50 99 165 149 114 125 115 153 155 215 55 248 213 231 87 248 229 141 182 46 92 121 235 84 1 32 175 236 219 253 145 237 118 167 108 237 140 121 176 117 196 126 183 79 119 56 197 66 192 210 38 33 245 248 52 171 7 93 3 240 216 113 223 84 227 226 157 145 34
	     242 190 134 244 23 78 126 78 127 236 212 217 109 22 43 172 152 98 177 192 202 2 195 104 38 129 70 150 176 178 212 160 213 106 179 218 14 44 181 61 171 205 70 125 84 223 202 50 55 174 182 89 110 193 154 215 141 73 222 31 139 22 127 105 112 16 2 164 245 22 182 77 96 121 5 174 46 55 88 203 96 60
	     105 114 208 107 82 148 145 238 176 100 52 41 24 78 38 244 39 35 242 194 168 34 132 144 224 146 12 11 9 206 167 224 124 253 199 0 23 47 184 238 94 225 14 105 231 63 95 49 132 124 164 206 95 11 238 194 232 253 29 95 35 30 31 230 35 138 69 98 85 48 206 115 6 211 130 222 176 160 63 173 232 79 140
	     217 172 96 191 215 182 191 252 197 77 93 192 242 118 103 118 170 0 144 87 241 15 59 19 251 199 111 158 240 120 183 203 96 156 51 156 84 20 230 169 240 152 115 224 82 92 168 39 53 102 110 62 198 158 106 252 167 4 128 200 37 74 0 156 62 222 47 226 204 112 85 129 85 19 40 11 40 115 32 178 210 206
	     88 109 55 249 244 246 117 110 92 217 228 230 141 6 155 75 158 134 135 44 169 155 167 101 105 93 26 157 112 254 36 247 247 51 156 81 5 192 101 9 22 46 174 0 224 57 247 41 163 174 10 40 128 170 130 60 175 176 88 49 46 43 138 8 59 71 5 123 7 3 30 237 236 241 228 160 203 104 84 48 153 85 164 141
	     6 22 26 117 85 64 200 234 30 57 46 96 230 128 120 234 87 177 121 195 66 221 33 69 222 64 164 243 244 181 244 6 170 2 94 230 168 220 167 197 186 47 128 69 204 42 44 70 130 85 4 95 209 76 18 26 161 100 185 157 240 229 157 155 252 242 103 119 248 23 183 83 221 96 228 173 208 66 139 188 180 255
	     248 67 215 30 60 233 242 237 253 67 246 142 134 148 102 184 144 18 178 38 73 154 205 135 82 127 106 194 116 182 221 146 70 49 145 203 51 161 114 243 102 105 85 21 137 101 5 86 225 49 26 193 177 212 108 208 206 90 172 54 29 105 18 217 92 105 176 210 110 240 201 245 43 92 191 186 193 141 53 200
	     158 17 104 69 94 173 49 220 79 181 230 169 192 255 178 60 151 95 220 29 220 46 120 142 58 234 19 4 92 0 90 117 157 192 149 249 231 108 174 180 184 182 218 96 173 109 220 216 72 25 142 10 142 134 145 60 6 250 147 138 188 50 38 121 65 89 228 84 209 225 66 56 238 21 224 142 251 16 68 221 53 69 46
	     155 249 137 4 206 135 186 71 0 224 172 162 168 114 102 211 130 124 54 37 116 160 63 59 96 84 102 140 166 171 246 151 95 45 107 32 144 183 48 141 83 5 128 188 192 223 61 28 219 214 238 1 223 60 62 224 176 63 99 48 53 166 5 84 56 156 79 113 33 197 215 181 77 199 199 45 217 124 160 59 93 101 229
	     95 48 121 23 145 247 240 38 193 98 165 100 94 162 236 98 221 208 44 86 245 196 37 207 41 139 2 98 253 254 181 229 22 183 174 109 112 253 202 26 159 220 104 177 212 52 174 180 61 105 18 88 105 102 180 26 41 45 255 226 208 198 94 50 168 87 209 243 101 152 16 63 245 164 251 113 223 242 45 52 212
	     91 28 249 181 184 165 61 239 123 22 192 164 52 70 147 25 101 145 51 46 140 221 129 177 223 137 108 237 15 24 142 71 236 29 13 24 79 38 228 165 225 147 64 214 104 214 65 1 30 115 254 184 97 160 233 89 45 242 99 35 29 94 181 2 224 244 245 253 188 56 233 149 199 26 59 115 28 206 252 160 144 88 255
	     137 37 177 170 8 174 34 16 89 109 6 238 92 109 243 179 59 27 252 226 243 171 124 125 77 189 1 228 205 81 5 128 60 215 255 184 63 178 239 239 239 243 240 201 1 143 246 142 152 85 142 172 181 76 210 104 226 93 189 234 97 118 50 139 179 115 19 186 211 99 225 187 222 113 37 34 111 46 74 51 171 192
	     74 176 138 42 70 18 31 73 28 44 183 29 169 107 210 110 4 178 12 54 86 150 184 115 243 10 55 174 174 115 231 102 194 82 168 187 169 191 40 230 123 195 49 160 200 155 141 33 94 226 30 182 8 51 18 96 37 113 172 174 52 169 235 4 224 198 13 216 57 132 181 149 6 163 81 131 43 203 158 225 168 65 111
	     52 35 175 140 50 86 204 242 130 42 58 42 31 112 62 128 75 112 110 126 164 160 174 8 145 247 111 92 120 229 102 157 238 233 123 225 252 148 44 31 60 73 230 240 68 102 163 1 187 157 62 163 241 136 241 172 164 168 96 90 172 219 31 222 94 213 64 32 74 0 200 219 115 183 83 216 119 143 58 108 237
	     245 121 180 211 161 55 156 82 144 225 18 79 244 9 206 230 231 123 187 197 138 136 123 169 169 189 86 252 69 158 113 109 188 96 79 249 233 149 134 231 173 78 188 254 106 167 187 224 26 181 249 187 231 171 19 69 78 44 198 148 69 193 82 35 16 154 41 55 54 214 217 92 93 227 230 213 22 235 75 129
	     165 70 194 250 114 155 102 59 176 26 46 190 201 188 201 25 140 102 67 242 246 46 202 87 123 174 93 180 166 184 248 22 109 224 198 58 180 211 38 69 17 248 244 90 147 225 180 98 255 104 194 65 119 196 238 97 143 195 241 132 60 143 20 56 66 163 137 15 134 133 180 238 19 104 238 57 191 135 61 243
	     194 136 139 143 219 226 247 123 206 170 231 188 124 207 142 183 237 57 204 233 174 45 31 250 117 236 222 163 59 199 243 175 94 179 121 51 221 144 225 210 72 30 43 246 187 19 156 59 160 55 154 112 216 155 216 191 251 189 27 186 237 137 18 0 242 118 124 187 213 229 55 119 15 217 61 236 49 24 207
	     136 206 147 181 151 192 7 162 133 147 149 16 109 33 17 185 84 209 206 233 131 208 220 252 232 34 71 69 226 141 164 225 73 154 13 40 28 27 43 41 43 75 77 190 250 244 10 55 174 93 229 211 235 45 54 90 144 82 111 247 169 230 223 165 226 100 229 212 205 63 166 217 139 188 205 121 248 91 235 207
	     240 18 223 247 116 177 241 226 245 69 127 255 229 0 43 171 1 71 160 184 210 100 102 176 119 84 177 179 223 99 57 51 150 27 48 24 23 12 167 70 12 73 93 25 64 73 140 134 195 207 127 254 203 53 47 179 115 191 139 123 169 17 160 110 62 232 116 133 202 71 62 208 188 203 237 209 238 92 167 17 195
	     145 54 154 36 205 180 62 45 160 40 120 188 63 226 160 55 161 55 46 40 34 246 255 252 190 146 0 162 4 128 188 97 255 225 55 59 118 247 81 151 237 195 1 189 81 73 105 1 231 19 28 9 142 80 159 95 60 31 182 46 90 51 20 145 159 104 138 51 15 80 142 171 9 94 50 104 57 19 178 216 124 79 98 172 136
	     177 160 200 103 120 140 229 118 147 181 213 37 174 109 52 104 38 145 27 235 25 75 173 148 219 87 214 216 88 107 176 217 60 219 216 111 113 115 9 231 18 0 34 31 67 152 177 120 25 57 73 122 157 126 254 7 160 233 32 172 5 154 97 153 165 70 197 205 107 75 116 39 37 251 157 146 238 176 96 167 51 98
	     58 153 48 205 43 66 72 240 105 74 8 41 222 39 167 190 217 179 174 172 147 218 60 91 124 154 189 204 239 239 206 36 4 68 228 221 142 30 139 51 64 42 160 194 168 48 102 69 206 172 44 201 14 199 36 126 159 212 23 246 239 126 239 19 221 82 69 9 0 121 51 254 243 111 119 237 219 123 7 108 31 14 153
	     228 21 62 73 201 146 172 30 152 156 39 158 107 156 162 254 254 34 111 54 120 127 213 143 63 239 235 94 174 239 70 60 153 118 184 10 63 159 122 152 175 48 171 240 190 32 13 129 205 165 140 59 215 87 249 234 211 171 172 45 37 92 91 247 117 199 255 196 147 248 186 123 121 188 32 28 81 224 47 31
	     107 18 0 158 221 252 118 241 39 13 176 185 146 177 218 222 96 230 160 55 51 182 119 11 30 239 14 40 171 138 96 57 84 51 124 0 239 28 206 57 156 63 89 51 52 11 243 80 125 126 2 143 157 10 221 221 211 65 253 75 255 242 138 253 69 222 29 59 223 27 192 48 3 231 3 73 22 32 73 9 177 96 90 148 108
	     109 119 240 85 14 230 236 223 253 250 142 110 175 162 4 128 252 56 127 245 195 129 253 238 193 1 119 159 116 232 79 42 10 151 226 147 64 240 41 224 206 149 68 61 107 167 163 136 188 79 145 136 157 190 100 237 244 250 100 29 66 56 160 170 10 98 44 161 42 112 149 209 72 33 75 28 171 43 41 75 173
	     13 214 150 50 110 93 89 227 218 149 117 62 185 217 102 185 229 88 243 23 7 251 34 242 226 24 123 113 173 120 7 89 0 66 61 29 91 79 97 41 77 89 105 4 214 154 21 189 97 147 206 96 204 100 234 232 143 115 122 195 25 227 217 132 10 95 31 29 24 50 124 72 143 191 179 157 186 37 31 7 254 175 176 143
	     223 206 148 34 235 190 46 242 83 141 18 134 3 231 112 243 94 91 21 145 113 94 50 156 206 168 98 69 12 129 180 145 217 191 249 217 53 221 122 69 9 0 121 61 127 253 125 215 126 119 191 195 214 193 144 113 81 65 72 72 147 172 238 78 106 47 51 13 120 201 250 66 17 121 251 83 135 197 86 0 119 254
	     152 60 59 57 214 175 110 226 49 63 104 172 194 98 142 171 114 172 42 105 52 50 86 154 77 62 189 190 198 39 55 215 185 121 125 137 235 171 25 89 72 104 102 142 224 79 86 48 23 251 250 69 46 101 164 254 22 217 51 94 174 54 160 113 61 227 214 250 85 102 213 58 157 81 197 126 167 224 254 163 67 172
	     56 96 54 153 81 25 56 154 120 31 8 4 204 133 147 162 255 227 45 64 118 246 27 191 66 2 192 206 109 244 19 145 55 121 213 191 248 211 78 182 216 90 125 79 247 1 72 113 13 35 7 30 237 14 113 236 97 230 236 47 127 126 85 23 170 40 1 32 175 230 127 61 236 217 63 221 59 224 187 135 29 6 147 156 202
	     82 124 146 17 146 236 100 191 191 41 192 23 121 175 166 17 207 56 21 224 217 147 142 147 218 94 179 130 88 149 88 85 224 136 52 19 79 187 217 96 173 221 166 153 70 174 173 54 88 93 106 113 231 198 38 159 221 94 227 106 59 33 115 79 79 95 78 127 87 205 62 68 94 249 34 94 92 192 199 215 147 7 90
	     64 59 115 184 44 3 50 110 173 194 209 154 177 154 122 214 91 145 157 78 74 119 108 140 114 207 112 86 81 228 83 74 155 225 124 130 185 128 247 30 231 252 5 167 133 184 11 199 11 83 51 95 145 247 56 95 48 79 216 251 128 57 7 46 48 179 146 65 111 202 44 239 96 64 51 117 246 167 159 95 209 109
	     88 148 0 144 151 12 254 127 56 176 111 30 117 120 188 211 165 63 158 81 185 4 159 54 192 123 234 54 69 154 218 139 124 168 220 185 112 221 59 135 167 162 170 114 98 49 163 156 205 72 28 180 214 87 185 182 177 206 23 159 108 112 117 221 115 115 53 161 221 240 52 155 13 86 90 9 153 2 125 145 183
	     198 159 186 182 46 186 190 50 7 171 109 199 207 62 89 230 198 213 132 195 113 201 214 97 228 225 206 136 199 219 251 28 78 198 20 69 137 79 51 130 79 240 89 99 222 40 208 159 10 34 236 149 122 246 188 181 147 20 68 228 53 18 1 110 190 165 175 62 13 164 50 135 121 35 175 74 30 239 116 104 248
	     18 98 97 127 250 229 77 93 184 162 4 128 60 223 255 126 208 177 127 186 123 192 189 173 14 71 163 130 136 39 164 13 66 210 32 98 68 83 249 159 200 135 24 246 159 204 250 29 206 170 122 234 95 69 170 88 129 149 36 174 100 169 225 105 45 183 89 106 4 110 95 91 231 198 181 171 124 241 217 58 215
	     87 28 171 105 157 254 139 243 111 99 78 193 191 200 219 188 90 47 186 190 78 55 11 204 48 154 237 132 141 246 50 55 55 225 218 6 172 182 91 172 101 37 219 75 70 127 60 35 47 61 121 25 41 226 140 170 200 49 31 112 62 224 92 160 190 162 79 186 140 171 133 175 200 135 150 4 152 95 177 222 99 209
	     17 26 30 231 114 58 131 62 255 124 111 6 206 145 54 90 246 199 183 215 116 89 139 18 0 114 177 191 123 60 177 239 31 15 120 176 211 99 191 63 161 36 193 165 25 224 231 85 137 174 238 66 202 217 227 140 78 79 84 52 194 136 188 175 33 197 124 114 239 28 17 176 170 36 22 51 242 233 152 212 74 86
	     151 155 124 114 229 10 95 220 222 224 218 102 131 155 107 45 150 218 45 150 87 29 237 83 55 6 255 130 8 97 17 156 168 7 128 188 93 241 220 219 254 61 253 253 252 27 191 146 143 239 183 167 86 228 3 112 125 9 26 119 154 220 89 189 206 193 104 153 195 94 193 238 193 148 237 195 30 123 135 61 38
	     147 25 230 2 73 163 69 72 91 248 144 214 99 193 233 114 255 151 59 38 68 228 131 30 49 62 252 251 147 61 245 182 205 79 230 170 156 103 70 130 229 37 15 247 38 180 239 31 209 72 83 251 213 181 182 174 108 81 2 64 206 250 251 173 169 125 115 191 203 221 237 30 157 113 65 233 2 73 218 196 167
	     13 170 232 136 22 57 179 95 152 167 78 40 193 204 52 111 16 249 41 195 252 103 150 232 70 32 98 102 196 50 226 168 240 68 218 141 128 133 132 229 52 225 250 230 10 95 127 126 149 223 251 242 26 215 86 19 218 105 157 52 168 12 162 131 217 124 210 180 248 227 158 57 45 89 52 12 123 207 106 133
	     158 119 96 137 124 224 147 223 247 249 247 123 181 136 250 101 203 236 141 147 35 54 79 39 221 54 155 142 205 214 18 183 172 77 127 108 60 92 155 176 218 14 180 146 146 131 46 76 10 71 97 142 170 42 137 17 162 171 87 15 49 195 57 127 124 47 23 185 84 35 198 83 243 213 15 252 54 112 254 20 15
	     171 219 134 56 103 224 3 105 115 137 64 69 119 18 249 246 65 151 102 154 210 8 222 190 220 108 234 238 39 74 0 72 237 110 55 218 15 143 59 252 238 225 54 187 157 49 133 65 244 13 130 79 137 132 249 12 67 19 2 145 15 141 159 119 245 55 171 176 88 17 203 156 124 86 144 37 208 106 182 184 117 101
	     141 205 213 171 220 218 12 220 88 111 113 99 115 157 91 27 41 217 169 72 57 184 147 20 2 243 32 227 121 193 180 102 23 34 111 121 238 127 234 90 124 170 218 102 254 70 234 28 237 101 71 154 46 113 125 25 62 185 145 177 223 43 120 178 159 179 181 63 226 160 219 103 60 29 224 146 148 164 209 192
	     251 20 159 164 224 28 49 158 79 100 232 170 22 249 32 70 6 7 149 5 204 67 105 129 241 116 194 116 54 100 185 149 176 182 148 241 229 102 83 15 147 40 1 32 181 173 221 9 79 246 186 116 7 3 202 18 210 86 27 115 9 224 177 56 47 43 210 4 64 228 131 99 86 1 21 46 86 120 171 72 92 69 146 86 172 180
	     50 214 87 27 124 126 107 147 207 111 175 240 201 181 148 181 134 39 153 111 247 169 220 73 187 207 139 3 123 59 149 4 112 103 62 168 30 33 34 175 115 173 158 108 209 121 222 199 23 159 243 188 6 156 245 249 224 117 210 110 41 49 150 55 91 108 108 54 184 61 117 172 174 205 8 97 31 170 9 135 54
	     37 186 10 239 35 70 129 139 70 244 126 222 31 192 29 87 243 60 181 124 42 34 239 217 0 226 56 105 241 91 87 243 120 79 157 212 139 51 250 195 9 15 183 123 252 239 86 195 254 244 75 245 3 16 37 0 62 122 127 245 125 199 254 241 219 61 238 109 29 49 152 86 148 164 56 75 235 213 255 227 178 255
	     103 31 247 247 188 102 69 34 242 46 185 51 1 128 179 138 178 156 66 49 37 37 210 106 165 108 172 181 216 92 93 231 218 230 18 87 150 219 220 188 182 201 205 235 41 27 254 25 215 175 93 24 227 139 188 87 207 247 83 207 250 247 248 247 123 183 63 57 204 39 115 89 168 239 225 45 60 235 203 144
	     125 218 102 37 187 202 237 13 216 237 172 208 159 148 28 245 115 122 131 9 227 241 8 243 9 73 214 134 144 30 31 69 120 182 206 64 213 128 114 57 70 140 203 249 175 169 147 0 206 5 34 17 243 129 194 60 251 189 41 69 190 79 240 142 202 7 251 243 207 151 117 75 23 37 0 62 102 79 246 14 217 218
	     219 103 154 71 154 205 54 5 1 239 32 218 217 51 194 47 28 102 236 197 195 145 166 10 34 111 199 217 21 195 249 77 31 63 191 230 98 125 245 85 37 177 156 225 131 103 57 109 113 231 234 42 95 124 186 193 173 107 75 172 103 158 44 245 100 212 251 251 79 55 249 243 47 156 99 188 56 35 240 162 21
	     205 11 7 136 143 96 74 242 17 254 147 63 194 169 252 171 255 126 47 218 251 255 58 71 240 197 83 207 183 56 255 211 14 240 249 245 38 87 87 175 115 115 184 193 246 225 132 187 15 14 40 166 19 70 163 9 209 167 144 100 184 224 49 146 115 129 191 195 157 174 12 16 249 80 70 12 251 176 198 131 23
	     206 158 159 85 149 51 63 169 203 230 179 130 36 120 188 111 66 53 161 63 30 115 208 25 112 165 183 169 39 132 40 1 240 49 251 15 223 238 217 247 143 142 216 235 12 41 92 131 165 86 3 239 194 27 41 247 115 74 0 136 188 179 144 210 205 255 84 85 81 7 222 22 201 2 44 47 101 172 110 54 184 182 146
	     114 243 202 50 159 221 218 228 139 59 107 92 201 78 150 252 23 245 61 241 220 212 195 189 250 175 161 168 86 228 61 75 65 56 234 237 0 126 62 185 107 36 96 73 224 74 163 197 141 181 22 215 254 255 236 253 247 115 28 73 178 239 137 126 60 34 51 75 64 3 4 168 154 108 61 51 103 206 221 187 215
	     158 173 237 191 190 207 108 237 238 187 250 156 179 103 180 232 233 110 118 83 11 168 210 50 85 248 251 33 171 128 2 8 146 32 9 178 65 210 63 109 104 8 86 101 165 8 225 254 13 15 247 245 38 75 17 236 172 9 143 14 235 140 38 129 193 212 49 41 242 106 60 17 71 28 69 136 68 44 134 4 217 220 110
	     24 151 185 231 87 150 129 115 30 135 35 207 61 217 52 240 164 53 130 248 144 70 221 235 231 215 155 124 181 18 219 108 109 152 0 240 41 241 251 7 29 125 248 168 199 104 82 16 215 234 64 92 101 18 214 55 223 239 63 55 8 170 50 97 213 49 68 109 173 192 48 222 216 181 127 193 42 186 16 16 89 88
	     147 147 202 233 15 101 70 145 103 132 160 248 90 204 234 250 10 95 220 92 231 246 213 37 174 174 57 214 26 117 154 177 16 206 216 227 239 78 126 240 177 169 127 222 149 71 61 153 48 236 77 86 44 13 195 184 120 87 192 159 33 10 232 44 136 103 165 230 185 125 115 149 173 205 26 171 155 83 118
	     91 99 126 126 212 101 48 25 49 157 102 136 243 248 230 50 113 236 81 213 202 70 16 48 149 207 48 46 97 159 95 236 150 42 168 66 64 17 23 145 212 154 4 245 180 218 125 158 60 139 88 91 114 176 18 219 77 51 76 0 248 84 184 219 154 232 119 63 31 242 253 207 251 244 211 128 75 234 120 34 194 75 139
	     123 25 198 7 224 48 159 97 252 254 210 71 122 55 215 41 149 8 160 1 52 160 90 224 52 208 240 129 90 221 179 84 75 216 88 173 243 229 141 109 190 253 114 147 27 107 158 101 87 85 5 112 34 175 12 67 55 209 206 48 62 62 33 224 52 49 176 22 9 43 107 117 194 106 157 157 173 21 246 218 57 141 56 98
	     247 48 162 213 155 48 158 150 20 33 167 204 203 234 72 226 193 249 234 251 76 54 60 45 243 159 127 196 124 213 56 251 254 54 204 156 103 196 183 32 39 227 98 91 155 156 171 61 190 121 123 147 163 222 41 62 194 251 136 52 228 244 219 3 98 95 208 168 59 254 63 55 87 236 113 24 38 0 124 42 116
	     199 129 246 96 76 111 52 33 35 162 94 107 160 248 11 155 208 20 142 86 3 205 145 48 222 231 148 170 103 149 164 123 221 70 248 92 125 221 247 159 92 236 249 213 115 57 238 79 114 188 215 95 203 156 144 167 100 211 49 94 3 235 171 75 92 219 92 225 214 213 117 174 95 105 112 99 115 137 43 235
	     17 77 127 60 176 203 27 125 254 185 222 244 250 214 202 251 188 173 151 196 98 55 199 193 184 76 237 176 74 231 81 149 251 92 73 60 209 134 192 151 27 220 188 214 228 217 254 148 7 79 186 60 221 61 164 55 156 226 226 164 90 48 72 18 196 71 85 52 128 130 138 112 114 19 209 121 246 92 235 145
	     112 80 141 55 122 148 201 252 248 223 116 97 171 210 226 107 46 120 238 144 83 211 196 169 26 241 103 125 164 170 60 95 25 197 48 206 225 206 31 71 246 189 184 61 206 123 200 98 181 157 121 148 94 88 176 177 79 207 215 170 103 72 7 34 32 85 118 159 50 20 148 170 76 166 57 135 221 9 127 122 216
	     215 255 116 123 213 166 37 195 4 128 143 157 127 236 167 250 211 195 14 7 221 9 5 160 46 34 184 8 212 189 163 161 206 48 126 185 41 87 46 164 21 203 37 185 154 217 185 104 64 53 32 148 196 18 136 106 194 74 228 105 38 9 183 174 174 241 213 173 107 124 251 249 26 219 75 158 196 11 222 157 220
	     227 255 206 226 124 204 132 48 140 15 78 4 88 28 27 106 64 45 17 150 174 46 17 116 137 195 173 192 198 82 147 186 203 120 180 87 18 92 76 170 66 144 146 178 204 128 121 36 192 155 142 105 47 27 103 229 28 175 121 127 247 41 216 112 103 188 231 25 95 47 172 173 85 89 130 2 2 68 184 164 78 10 60
	     217 31 242 93 253 16 156 234 127 250 204 74 3 26 38 0 124 212 220 127 114 192 221 135 187 244 134 25 18 213 113 46 57 82 6 213 60 119 227 67 55 102 245 227 48 208 84 231 187 251 43 83 96 190 82 230 196 145 231 57 233 100 132 104 206 114 61 97 117 173 201 181 43 107 236 108 54 248 124 115 133
	     157 173 53 174 175 199 212 46 177 156 97 24 198 229 25 55 221 108 140 240 0 34 68 190 26 37 252 186 67 101 149 90 124 157 181 141 21 58 131 130 39 7 35 122 163 49 163 116 140 79 18 146 218 18 18 121 22 214 232 143 114 144 159 248 156 217 42 101 53 70 191 108 5 84 143 199 169 247 52 88 137 218
	     24 105 188 199 62 247 170 8 59 93 232 0 242 124 27 149 23 119 30 94 214 163 130 86 73 1 125 210 32 248 146 254 36 229 105 171 207 246 85 171 10 96 152 0 240 81 243 135 199 45 189 247 248 25 79 246 91 164 52 73 154 75 20 50 47 250 37 216 218 189 241 161 227 62 194 107 18 102 43 254 90 226 156
	     35 33 195 69 57 117 15 59 27 13 110 223 216 228 215 95 111 113 125 179 198 102 236 137 189 35 58 101 127 155 65 107 24 198 203 68 0 121 129 49 120 109 197 179 242 229 54 59 87 55 121 186 159 17 249 61 246 15 75 246 59 67 212 21 56 73 81 141 208 89 78 0 57 215 136 115 158 181 205 87 151 34 182
	     185 195 248 216 251 229 69 246 110 69 8 206 35 46 34 45 167 12 134 83 242 98 66 188 180 204 218 90 67 255 207 235 53 51 21 76 0 48 62 70 118 59 57 7 157 41 131 105 142 171 65 226 163 42 33 88 16 19 0 12 227 82 77 251 199 155 80 203 80 162 69 78 153 79 33 228 44 215 98 174 111 173 113 253 202
	     10 159 93 91 230 234 214 10 95 94 95 97 213 159 204 236 111 43 90 134 97 188 13 30 136 156 80 175 71 52 235 17 171 245 26 73 20 104 239 36 220 123 210 165 221 31 115 56 24 147 21 128 175 67 84 195 71 49 78 252 169 253 203 207 91 23 138 59 103 49 193 203 49 122 153 133 100 252 82 2 128 188 193
	     123 22 234 248 32 226 112 62 194 71 17 65 149 16 2 253 241 152 167 173 17 143 243 62 207 250 83 50 45 112 254 51 253 63 118 150 205 92 48 1 192 248 152 248 221 227 76 119 91 5 25 117 226 250 50 26 69 4 2 4 255 130 233 217 48 62 209 73 87 79 167 118 122 203 122 2 47 40 229 247 138 119 33 132
	     234 187 148 136 148 56 41 240 76 217 94 105 240 235 207 111 240 237 231 27 92 223 116 212 35 79 211 85 123 84 197 156 126 195 248 120 121 205 212 224 175 245 242 249 254 169 133 113 42 44 56 190 14 216 168 193 175 111 46 147 110 215 88 95 89 227 254 211 61 138 123 207 232 141 50 10 45 40 67 4
	     90 69 2 56 20 149 170 12 217 124 63 115 21 186 60 251 105 241 143 103 38 246 147 231 74 139 254 98 163 154 158 149 161 192 108 166 143 213 225 230 23 182 138 229 66 62 92 142 146 6 87 114 64 85 193 35 45 115 210 105 70 171 63 98 191 55 102 60 234 115 239 89 155 60 155 112 117 69 249 63 118 254
	     201 26 130 9 0 198 199 194 95 159 77 244 199 123 7 252 252 168 77 63 5 87 107 162 226 9 229 194 100 108 24 198 37 113 159 171 4 127 69 150 18 202 130 196 67 61 241 108 109 174 176 209 88 229 171 107 155 124 251 197 22 55 183 19 154 114 210 88 89 20 1 230 70 187 97 24 198 121 181 133 211 34 226
	     252 239 53 0 15 205 134 135 134 167 217 168 179 189 172 52 147 146 253 110 198 94 47 112 56 200 152 78 71 128 167 150 36 136 247 204 19 144 157 246 105 220 220 241 215 203 58 14 95 246 179 49 204 2 121 158 146 170 212 111 213 247 28 8 148 33 48 158 166 76 135 19 186 195 33 195 201 152 195 118
	     135 86 111 196 120 156 145 29 236 147 77 70 124 115 107 139 255 244 245 103 250 31 175 173 88 83 55 1 192 248 24 232 13 199 236 31 182 104 119 123 148 81 13 23 213 80 102 19 179 90 96 155 97 188 211 137 252 5 43 255 243 210 87 85 132 192 113 31 244 40 65 11 66 49 37 228 25 113 189 198 106 179
	     201 23 55 55 185 125 125 153 219 235 53 182 86 34 252 25 6 131 51 99 213 48 140 11 26 167 206 202 13 48 31 169 154 17 220 218 106 226 147 27 236 13 2 209 189 30 147 244 128 116 50 34 43 148 196 47 227 92 12 56 68 220 44 147 190 59 113 156 121 169 192 147 229 0 127 121 103 203 44 34 227 178 244
	     69 125 141 236 220 85 41 100 161 20 33 114 14 39 17 42 80 20 25 221 209 136 78 183 207 65 167 203 56 157 50 152 78 73 243 18 245 9 184 136 116 154 177 215 158 176 223 207 224 154 61 3 19 0 140 15 158 159 186 169 62 218 237 177 215 30 48 24 79 73 150 107 212 92 82 133 57 107 224 109 139 165 25
	     134 241 182 198 231 188 200 84 64 66 64 53 39 146 146 229 165 136 102 84 227 218 246 10 219 27 171 252 250 171 109 110 93 173 179 177 48 217 135 83 134 186 245 100 195 48 222 149 99 188 104 49 52 28 208 72 248 182 145 176 179 13 137 79 88 138 149 103 7 142 253 206 132 64 201 180 40 81 231 16
	     98 240 130 35 58 33 2 24 134 113 49 168 19 84 42 177 173 80 37 47 148 52 27 51 73 167 244 71 19 246 219 29 186 189 30 237 254 128 172 40 42 219 33 74 16 151 64 92 99 82 228 252 248 248 128 127 255 126 151 27 219 107 250 219 141 200 204 9 19 0 140 15 153 131 195 33 253 225 20 197 17 197 53 68
	     252 145 186 173 230 46 24 198 243 19 233 187 54 170 69 78 244 61 17 32 8 33 4 202 34 37 100 19 106 177 176 185 185 193 245 173 77 190 254 172 201 250 114 157 107 171 9 141 153 17 238 56 25 178 107 61 217 48 62 65 143 252 98 95 126 98 4 60 202 93 2 179 82 193 103 143 53 2 44 9 124 182 153 80 143
	     183 216 92 107 144 60 104 179 215 234 209 239 141 144 56 34 248 128 35 65 34 193 205 202 145 41 160 46 48 223 168 252 174 246 212 63 191 186 47 103 92 177 173 249 27 191 92 228 199 226 42 191 136 156 123 213 95 230 109 87 4 231 29 120 143 247 9 161 44 73 199 41 237 193 128 86 167 71 183 63 164
	     55 26 146 102 121 213 247 220 44 126 112 214 175 73 234 136 115 116 251 67 238 220 127 196 131 175 87 249 237 198 45 107 16 38 0 24 31 42 191 187 119 168 247 30 183 217 107 13 41 136 168 53 98 212 37 179 56 33 155 240 12 227 151 179 227 21 84 17 173 190 59 41 136 40 137 18 161 214 172 177 222
	     140 249 167 207 183 185 117 227 42 95 95 139 168 123 136 229 120 31 109 105 78 191 97 24 239 212 21 210 35 135 249 69 99 205 124 28 74 128 27 43 49 215 87 34 174 111 172 176 148 212 185 215 128 200 149 148 234 233 231 138 82 144 151 130 18 227 196 161 72 149 251 79 22 220 25 51 75 12 227 53 122
	     169 16 68 8 170 104 25 200 243 128 74 193 112 156 210 29 12 121 214 110 179 223 234 48 26 78 40 202 18 188 67 124 140 184 74 136 43 113 64 128 70 3 92 196 97 103 192 159 190 187 195 215 55 154 108 173 54 245 255 188 181 101 102 134 9 0 198 135 200 40 77 105 245 6 244 7 99 10 95 195 73 60 27 44
	     228 216 9 49 140 143 200 100 61 203 82 149 75 211 204 229 200 176 174 86 213 132 80 22 20 233 148 80 102 68 162 108 174 213 248 236 250 58 159 109 175 240 171 155 107 172 175 197 44 123 240 167 146 253 157 62 170 97 24 198 251 24 193 22 113 11 127 115 213 160 198 122 29 190 188 177 76 35 186
	     130 175 69 180 123 5 227 189 1 195 241 148 105 62 193 39 77 234 245 230 236 13 225 232 40 114 230 232 102 24 6 204 10 101 28 133 253 9 206 57 188 247 56 231 201 67 73 86 20 140 198 99 134 147 41 221 193 144 206 96 68 103 52 102 56 73 43 231 127 246 190 106 155 128 204 66 15 165 58 112 20 161
	     162 12 251 83 158 237 77 121 180 223 167 53 9 118 211 77 0 48 62 84 218 131 41 221 193 152 225 52 39 106 212 170 112 31 49 119 193 248 200 69 128 83 6 234 165 59 67 101 166 189 11 222 101 120 95 16 197 194 114 45 230 214 181 53 254 195 111 174 242 249 181 85 174 39 142 210 85 118 242 98 166
	     14 235 193 134 97 92 70 65 64 129 200 193 141 213 136 173 165 45 86 174 172 242 116 119 132 34 28 182 149 118 127 140 250 140 200 197 148 56 2 139 225 206 191 212 200 102 162 131 241 11 247 163 87 216 229 71 203 6 71 65 50 66 169 144 149 1 130 50 157 102 12 39 99 14 218 29 90 189 62 173 94 143
	     209 52 39 23 79 16 32 73 170 229 7 55 243 1 228 228 242 159 248 8 13 37 101 169 12 39 25 247 247 134 252 240 116 204 183 159 163 223 212 204 228 48 1 192 248 160 248 161 91 106 111 172 140 211 64 90 206 86 28 189 67 102 185 195 245 212 188 247 166 89 71 13 227 114 27 164 122 172 121 169 188
	     224 149 250 74 163 246 109 207 74 231 125 76 5 213 146 162 152 82 164 83 18 7 75 245 152 27 219 171 92 221 90 230 214 213 101 190 185 182 202 102 35 34 158 13 198 175 156 125 45 36 192 48 140 55 116 117 229 13 157 146 23 141 191 30 192 65 228 60 159 109 120 26 46 34 104 73 103 171 193 207 79
	     186 236 182 6 244 251 109 84 18 106 141 37 240 73 245 78 17 84 57 138 4 56 109 135 156 231 124 228 92 215 252 146 17 253 184 44 129 13 164 198 59 119 248 79 228 217 56 179 149 42 58 91 169 23 4 31 69 184 200 131 8 105 17 24 77 166 140 198 19 186 253 1 253 209 136 222 96 72 119 52 100 48 30 87
	     101 190 189 66 148 128 115 168 147 163 3 235 169 207 169 210 16 121 112 17 121 40 217 31 100 60 216 237 179 219 205 241 171 78 191 108 120 235 12 38 0 24 31 10 79 15 50 218 131 146 66 35 36 210 42 236 103 49 241 152 221 34 227 99 116 254 245 69 127 144 95 254 220 80 156 4 28 1 164 68 67 202
	     122 179 206 245 171 235 252 246 155 27 124 113 107 137 205 186 99 45 169 134 224 89 208 222 137 48 91 195 48 140 203 46 50 204 43 148 212 4 174 175 70 52 234 155 76 139 117 86 87 86 249 219 143 143 184 251 240 41 89 25 72 92 147 82 32 60 231 146 252 210 18 137 141 184 198 37 233 75 122 156 164
	     210 205 246 252 23 1 134 105 198 126 183 207 222 254 33 173 110 143 241 52 165 32 144 135 18 245 49 226 29 136 171 4 4 145 147 205 251 84 212 141 234 76 21 72 154 168 212 232 141 11 126 126 248 140 159 239 173 209 252 98 157 47 27 171 246 48 76 0 48 62 4 126 247 120 162 15 159 117 104 245 166
	     228 226 145 88 192 69 167 178 223 218 42 191 97 188 31 81 34 84 73 122 180 32 148 5 162 37 203 53 199 198 230 26 95 125 182 194 231 55 119 248 246 214 26 159 173 184 163 45 11 97 246 117 212 99 85 143 163 8 12 195 48 62 16 99 210 57 184 90 175 204 74 249 124 147 68 50 234 113 198 147 86 198
	     40 11 164 211 73 229 172 120 143 119 209 241 158 167 163 17 244 140 53 252 83 89 211 223 126 160 182 114 200 198 101 51 30 4 39 30 241 14 113 158 82 149 188 44 153 244 39 244 198 83 58 195 49 7 157 46 7 237 14 253 225 8 45 75 136 99 112 130 184 8 113 254 164 165 127 166 201 31 22 126 18 164
	     222 68 9 180 251 99 238 220 185 207 63 110 54 249 108 187 6 152 0 96 2 128 241 65 208 234 118 120 182 127 64 183 63 198 197 30 239 35 68 34 43 251 103 24 239 213 249 215 89 242 190 0 161 64 67 142 211 28 81 184 178 190 198 237 235 91 252 243 55 107 236 172 213 89 175 187 163 210 126 194 241
	     170 191 245 88 195 48 62 172 113 239 228 215 162 223 113 101 5 86 191 185 194 230 70 141 63 255 220 229 199 123 29 70 147 49 94 132 64 132 243 130 16 17 208 217 170 231 251 28 1 45 233 153 241 203 18 88 220 158 43 56 231 171 62 224 34 202 178 160 55 30 179 119 208 98 175 213 165 59 154 48 206
	     114 166 69 1 145 175 148 54 241 179 68 127 254 53 237 253 89 105 226 40 33 80 210 31 116 9 157 67 238 62 94 167 53 184 97 15 198 4 0 227 67 161 219 155 208 234 244 24 77 2 75 126 5 231 99 78 132 250 156 129 237 251 55 140 139 48 125 103 253 72 4 52 80 148 5 148 57 18 50 106 30 54 214 18 150
	     155 53 126 253 249 21 62 191 181 195 215 87 35 154 243 62 56 51 0 252 194 209 88 248 55 195 48 140 15 109 52 92 252 106 56 104 54 34 126 243 217 6 226 235 120 133 122 77 152 100 57 221 97 134 230 129 28 95 149 42 243 51 83 84 221 185 71 66 91 199 55 62 4 78 236 253 159 69 247 205 147 243 57 239
	     17 231 9 10 121 80 38 147 148 180 24 49 78 83 14 59 109 246 14 90 180 186 125 38 105 14 206 67 228 113 81 4 126 150 216 79 28 47 138 156 121 105 199 65 192 249 42 49 103 86 48 30 15 217 109 119 217 109 15 237 129 153 0 96 124 40 140 83 101 154 41 69 80 74 60 42 222 92 8 227 211 156 104 23 115
	     231 203 243 121 2 94 199 88 124 89 216 169 46 100 234 151 249 28 28 2 121 158 66 145 210 112 5 203 141 38 95 223 92 231 218 213 53 126 115 99 141 149 149 136 6 39 43 21 248 55 178 180 159 75 124 96 24 134 141 126 207 141 7 231 27 29 46 110 12 145 51 190 7 32 6 190 222 105 80 119 59 108 110 212
	     121 188 55 224 167 135 135 12 39 19 178 12 106 205 37 92 20 161 250 34 203 229 216 193 209 83 37 82 253 43 116 130 19 99 247 194 254 234 147 215 125 58 254 202 236 39 227 188 73 38 95 191 151 6 85 196 57 156 115 184 40 70 226 152 162 8 12 7 35 14 186 61 90 157 30 253 209 152 254 112 200 52 75
	     73 21 136 34 100 182 226 31 148 227 178 126 111 97 43 137 80 37 31 114 17 46 174 49 201 148 221 253 49 127 121 58 214 255 120 163 105 198 133 9 0 198 101 230 15 143 199 58 158 20 224 28 226 28 224 176 197 125 227 83 181 127 245 200 235 63 61 137 235 75 39 228 55 153 196 23 211 95 149 121 137
	     132 156 136 192 210 82 194 206 234 18 59 235 75 252 246 139 43 92 191 182 202 141 102 124 20 238 87 112 50 236 255 149 70 235 115 159 108 101 0 12 195 120 209 184 240 38 227 129 188 147 51 154 231 54 1 88 246 240 205 213 37 150 151 106 172 54 18 180 44 217 239 12 216 237 76 128 130 50 159 86
	     139 23 46 226 116 65 215 106 56 148 51 71 63 125 221 203 212 83 42 130 141 161 198 251 234 165 34 224 28 78 4 21 40 130 82 76 83 210 105 198 40 205 56 232 116 57 108 119 217 63 108 51 154 76 41 139 2 137 34 92 146 224 23 45 25 213 83 77 88 223 168 187 107 152 245 133 164 6 126 153 162 116 60
	     121 214 227 231 103 93 226 154 232 63 109 53 172 99 152 0 96 92 86 246 91 125 6 163 20 85 193 57 55 91 1 21 76 193 54 140 119 192 113 150 190 202 129 23 129 80 48 29 15 241 161 100 109 105 137 219 215 54 249 246 214 26 215 214 99 190 185 186 68 163 17 31 151 203 122 11 209 193 48 12 227 131
	     25 34 103 248 5 119 222 3 215 150 35 220 141 21 36 114 236 181 54 136 31 180 216 111 119 233 14 251 184 184 70 92 107 18 100 81 4 80 4 177 49 211 184 28 78 252 60 156 255 28 201 40 117 225 187 136 160 34 196 113 76 156 196 228 33 48 24 142 105 119 123 180 7 99 6 147 148 246 112 200 104 58 101
	     48 153 86 73 254 102 239 41 103 193 61 178 40 36 92 148 104 37 2 222 163 234 25 78 115 158 28 180 121 188 123 200 206 118 13 182 26 246 192 77 0 48 46 35 127 122 208 210 195 118 143 113 154 226 188 195 199 145 9 217 134 113 81 134 172 188 40 0 80 113 170 8 1 130 226 180 164 38 5 43 75 17 55 119
	     86 248 230 214 54 255 244 245 58 27 117 88 141 161 84 8 114 50 200 212 186 169 97 24 31 187 16 32 11 163 230 98 202 189 141 102 194 215 55 19 54 214 64 213 19 145 19 138 170 172 153 82 206 60 38 55 147 89 121 171 81 211 242 29 25 23 230 252 191 230 107 231 171 244 42 213 226 156 162 100 33 80
	     228 37 147 52 227 176 59 96 247 160 205 94 171 195 120 154 49 206 114 212 59 156 247 132 56 70 221 44 78 80 245 181 63 255 220 103 41 64 20 163 90 48 153 22 28 180 219 60 217 219 229 155 47 87 129 45 123 232 38 0 24 151 145 254 112 66 167 59 100 50 205 64 98 156 120 187 41 198 39 111 116 190
	     35 53 224 104 194 84 20 209 64 8 25 233 116 66 51 22 182 86 151 248 234 179 13 190 249 236 10 183 174 45 241 217 10 36 179 243 113 114 209 201 170 76 62 48 12 227 195 25 23 78 87 10 240 14 174 212 96 41 1 202 85 86 234 129 122 205 179 219 30 209 25 77 41 130 195 199 9 42 213 190 103 21 57 242
	     166 100 238 208 47 148 58 183 17 209 120 39 14 255 98 242 190 115 172 248 31 175 208 31 255 92 37 236 139 40 17 202 178 100 52 153 50 26 119 233 244 135 180 123 61 58 131 33 189 193 144 172 40 209 160 160 30 124 116 206 190 173 175 57 46 232 252 194 102 206 255 188 234 128 71 163 152 225 100
	     204 184 61 226 231 107 77 254 227 63 95 183 6 96 2 128 113 89 153 230 57 211 105 70 81 148 136 79 112 206 166 65 195 76 224 151 205 137 250 198 199 149 163 121 83 170 188 185 56 41 161 156 210 104 52 248 108 103 147 127 254 230 38 95 220 104 176 236 5 167 80 200 241 62 127 119 94 131 227 149
	     211 190 245 113 195 48 94 48 46 188 171 244 32 23 112 220 121 217 211 121 46 20 157 25 159 215 54 98 150 234 219 224 98 96 143 116 218 162 44 11 60 158 66 103 165 206 102 181 210 4 121 251 193 252 66 103 6 227 163 22 0 22 190 31 69 239 189 68 8 208 89 67 215 249 54 92 173 172 5 196 81 132 64
	     90 228 180 122 125 246 14 58 28 118 123 140 166 211 42 230 197 123 188 175 42 1 168 19 20 63 171 44 180 120 22 238 84 66 227 147 109 86 207 12 88 60 185 85 96 158 69 64 231 85 0 102 17 0 226 4 81 71 154 22 228 131 33 173 94 159 193 100 106 13 192 4 0 227 178 210 27 77 104 247 199 76 166 16 47
	     207 147 0 26 134 113 177 38 64 53 81 42 37 26 10 208 156 80 150 44 215 28 203 235 43 124 115 107 141 95 127 113 149 95 95 111 178 89 23 220 25 239 54 12 195 48 153 226 248 187 3 34 129 90 236 88 139 32 186 189 193 82 172 212 106 202 195 221 62 189 81 73 154 23 248 36 16 136 240 62 170 246 81
	     235 203 93 246 69 7 205 194 255 141 247 41 20 224 4 231 4 239 28 226 34 138 50 48 206 114 210 209 132 206 104 204 56 157 178 119 216 101 191 221 101 60 28 17 66 128 56 174 202 251 121 7 206 161 39 122 202 187 237 135 186 216 103 156 35 43 149 48 77 57 236 77 216 235 20 246 96 77 0 48 46 43 211
	     172 96 154 229 228 133 35 70 102 225 60 47 155 26 13 195 120 157 105 253 88 101 15 160 37 66 137 148 5 90 22 172 212 151 185 186 179 195 111 191 189 194 103 59 203 52 107 242 92 89 63 115 254 13 195 48 94 62 38 6 129 141 37 161 246 197 58 82 19 10 117 76 30 180 24 79 50 196 87 2 172 243 126
	     30 139 93 149 242 51 51 199 120 215 109 245 60 137 254 68 80 213 163 242 146 78 60 226 35 92 28 67 17 24 246 7 180 219 93 158 29 30 50 206 50 250 105 202 52 47 32 137 208 0 226 92 85 253 226 34 19 251 189 250 194 78 246 198 249 142 0 231 33 169 17 92 66 119 236 249 115 39 211 255 125 35 49 51
	     198 4 0 227 50 241 93 107 164 163 84 73 243 146 66 29 42 130 168 44 212 184 53 12 227 205 77 84 157 77 146 138 134 2 45 75 180 204 240 90 178 222 136 88 89 90 226 219 207 54 185 117 235 26 191 186 94 103 37 22 188 77 147 134 97 24 175 141 3 234 30 26 222 243 79 55 214 113 10 53 2 15 246 6 140
	     166 5 131 116 74 200 3 184 8 241 9 226 252 201 232 104 179 123 140 55 70 79 205 253 103 11 0 103 70 147 136 84 102 130 139 112 206 81 138 146 6 37 31 79 152 22 67 38 105 206 211 189 3 58 221 46 251 173 14 89 81 18 102 89 247 37 138 16 239 23 86 252 229 21 109 249 117 247 251 191 228 125 242
	     252 43 170 188 155 17 212 234 100 196 60 235 76 121 208 74 249 223 55 18 107 34 38 0 24 151 137 73 238 41 74 15 206 87 170 157 186 151 12 0 134 241 169 57 240 231 155 224 95 58 177 202 124 215 106 129 22 25 101 54 193 169 178 185 189 201 87 95 108 241 31 191 186 194 250 74 131 229 228 120 16
	     85 22 147 84 201 91 159 185 97 24 198 47 62 128 200 57 134 76 121 243 67 47 186 62 43 137 227 55 55 86 169 121 33 174 39 60 120 210 101 52 237 83 100 57 165 196 212 234 30 241 179 228 101 103 56 101 22 246 111 156 191 241 233 201 198 172 231 108 200 122 188 212 38 62 194 199 9 81 18 147 21 37
	     195 225 152 86 167 199 94 187 199 120 146 210 234 245 41 138 130 76 161 244 190 42 105 57 203 238 175 103 37 232 123 153 80 241 178 20 24 103 157 251 169 235 211 23 92 219 172 182 209 108 43 66 76 17 160 51 24 178 215 30 242 215 126 83 255 183 85 91 222 48 1 192 184 52 244 250 37 105 6 226 99
	     156 90 246 127 195 184 80 99 87 65 203 2 200 161 44 168 123 165 185 90 103 173 30 241 155 47 183 248 245 87 59 124 190 213 192 31 191 252 132 17 107 179 165 97 24 198 249 153 39 8 116 40 107 181 136 111 111 172 19 199 49 117 31 225 189 208 27 78 232 77 74 40 51 74 85 240 49 130 123 145 14 96
	     24 23 218 54 23 141 3 241 174 138 66 81 40 129 73 150 66 150 49 156 164 236 119 123 236 181 90 60 221 59 36 79 115 138 188 192 197 49 26 205 42 117 205 50 21 171 202 47 96 44 132 23 127 160 155 109 35 142 106 164 165 208 234 12 120 250 172 77 239 250 18 172 174 90 35 48 1 192 184 12 252 216
	     46 181 219 27 51 77 11 16 143 56 71 176 16 56 195 184 16 231 223 137 0 129 44 79 113 33 195 107 96 121 169 206 231 215 87 184 117 125 133 127 250 124 157 237 181 38 53 121 153 161 96 24 134 97 188 230 240 139 155 57 40 203 145 240 197 206 50 222 65 125 185 193 147 221 1 15 158 181 105 245 199
	     164 229 148 164 177 68 92 107 18 212 242 1 24 239 216 109 214 112 180 43 80 92 85 162 50 174 37 100 101 32 155 78 232 116 123 244 134 35 218 189 1 237 209 152 225 36 99 156 102 80 6 112 142 82 102 213 44 142 246 249 95 210 6 235 60 68 49 105 128 78 127 204 225 97 143 225 104 27 48 1 192 4 0 227
	     82 48 25 103 140 70 83 178 34 84 29 86 101 22 194 83 201 137 182 250 104 24 175 107 118 234 44 98 95 33 228 72 200 145 50 165 230 148 213 165 132 219 87 215 248 231 111 118 184 125 125 137 171 203 17 78 149 146 23 36 253 19 235 129 134 97 24 175 59 10 47 70 81 41 80 119 202 173 43 75 212 27 13
	     86 150 86 112 78 80 45 104 247 199 72 72 161 116 232 188 84 160 89 62 198 69 59 254 44 108 231 19 33 136 3 39 148 33 144 103 5 195 105 202 112 56 228 217 94 139 221 118 139 238 96 72 150 151 104 148 32 81 2 177 160 78 102 91 116 23 139 10 158 106 174 139 165 45 222 101 57 239 121 226 140 51 108
	     20 213 217 117 58 79 169 194 56 43 24 77 166 100 121 110 13 193 4 0 227 178 144 149 74 90 64 169 98 19 159 97 156 158 223 78 59 228 231 120 143 204 204 79 209 156 34 159 224 202 12 87 20 172 173 47 241 245 103 27 252 246 139 43 252 230 139 117 86 98 42 167 95 94 247 140 172 143 26 134 241 177
	     142 182 114 225 71 22 32 18 97 217 67 125 213 147 196 77 98 127 149 90 205 243 243 131 61 90 189 33 211 209 20 23 47 17 213 150 9 184 185 23 67 21 234 108 24 231 65 94 236 252 171 130 56 162 56 70 124 76 137 144 21 57 189 225 136 209 56 229 160 211 97 60 77 105 119 251 116 135 3 242 44 171 156
	     125 81 240 50 115 180 221 155 53 254 55 186 14 125 139 123 48 203 73 32 17 129 136 105 9 147 162 164 8 165 53 17 19 0 140 75 53 237 186 170 179 170 202 108 239 142 128 202 107 118 248 151 185 78 134 241 129 246 13 57 217 150 79 254 170 47 152 248 2 104 192 105 129 150 25 177 15 212 147 132 27
	     87 86 248 246 246 38 95 94 95 102 37 130 48 155 156 207 55 173 235 59 53 146 13 195 248 132 124 236 203 52 132 156 78 158 118 193 39 231 22 70 207 249 167 172 38 202 237 157 38 206 239 80 150 129 60 77 73 123 163 89 46 128 18 209 197 36 103 199 206 208 233 82 110 111 154 36 208 44 166 143 177
	     127 157 206 188 47 39 108 236 185 160 20 102 251 245 211 162 100 148 166 236 181 187 180 90 93 246 91 109 242 16 200 3 168 143 241 141 152 114 158 25 72 102 253 228 28 237 77 68 142 86 231 245 77 147 8 203 57 90 228 89 199 212 5 27 8 7 18 161 226 9 170 20 161 164 12 214 210 77 0 48 46 13 147
	     201 148 225 120 66 90 148 32 238 104 245 210 210 143 25 198 27 24 118 162 16 10 242 44 197 73 73 221 193 141 205 85 174 93 89 225 55 183 54 248 245 237 13 182 26 85 176 191 167 74 250 99 189 204 48 12 227 29 142 203 28 175 227 71 192 138 23 150 150 133 165 70 147 216 93 195 107 65 252 240 128
	     206 168 32 155 14 81 87 195 197 181 153 51 99 182 144 241 186 173 237 216 73 118 174 202 212 239 156 175 50 251 79 166 12 198 19 58 131 33 147 60 103 175 213 161 215 31 49 26 12 171 106 65 113 2 190 42 235 39 226 80 13 31 144 61 62 63 71 87 9 4 94 73 139 64 57 236 177 183 95 167 59 252 204 154
	     135 9 0 198 101 33 77 83 38 147 41 121 81 30 37 21 81 211 163 13 227 53 81 68 170 189 255 65 11 66 62 69 60 44 47 53 184 182 189 201 87 183 214 184 181 211 100 169 38 148 51 231 127 54 77 154 105 105 24 134 241 142 113 179 114 107 42 16 168 114 29 213 60 236 172 215 24 125 118 149 105 238 201
	     30 237 147 14 199 4 47 248 56 66 145 163 69 17 197 202 2 26 231 241 129 103 54 180 86 171 241 226 4 117 30 137 99 66 169 244 70 35 246 246 15 216 107 119 200 75 24 101 25 33 4 92 179 129 138 84 121 40 112 85 68 174 132 243 173 198 159 176 68 142 243 7 157 142 73 120 31 118 208 92 8 16 81 212
	     57 242 50 71 251 3 186 135 49 195 225 196 218 135 9 0 198 165 17 0 242 130 52 203 40 67 168 6 169 224 44 30 205 48 206 63 219 87 147 29 1 45 51 40 83 98 87 210 104 56 174 109 174 112 237 202 42 191 253 114 155 47 62 91 98 107 182 231 95 225 72 4 48 231 223 48 12 227 253 141 214 243 173 87 209
	     204 96 77 86 60 241 231 107 212 226 152 165 26 220 127 218 226 112 144 145 230 67 148 184 42 187 70 196 107 239 191 54 62 66 94 157 135 71 171 244 254 136 56 10 85 66 80 198 211 9 89 49 162 59 24 176 123 112 200 97 171 77 171 219 71 165 90 2 144 56 170 18 253 225 102 137 251 228 120 207 202
	     7 107 36 56 240 14 205 3 12 39 12 250 67 38 233 212 154 144 9 0 198 165 153 16 157 67 220 44 92 71 142 118 186 193 107 105 135 166 24 24 111 218 0 245 140 166 116 106 159 165 156 172 156 59 223 107 39 191 112 11 212 185 243 47 14 39 66 145 21 76 199 3 150 106 194 202 198 26 55 175 93 225 179
	     235 43 92 221 72 88 138 142 205 199 55 155 211 229 5 63 27 134 97 188 230 16 114 169 79 236 29 157 168 156 156 55 22 3 171 155 49 220 216 78 16 183 67 17 60 131 241 35 122 131 33 26 213 105 196 107 84 219 182 103 239 183 40 128 139 153 63 229 229 166 64 181 132 254 138 55 93 64 139 59 215 211
	     148 147 89 247 101 209 78 209 170 106 150 10 136 120 196 121 188 247 248 56 38 148 37 121 86 208 27 245 105 247 186 28 118 123 116 251 67 210 188 64 162 4 17 33 32 136 119 71 209 41 47 188 246 183 184 183 239 77 28 89 56 127 157 59 20 226 192 123 36 242 224 76 68 51 1 192 184 60 83 175 72 53
	     104 137 95 112 190 204 193 48 222 243 196 241 130 233 249 56 113 211 145 249 117 201 204 86 5 45 32 20 120 114 86 106 194 103 219 43 124 254 217 14 255 252 171 171 92 223 240 172 71 66 36 199 70 167 188 229 39 26 134 97 152 58 241 230 159 36 84 81 88 74 37 204 174 120 88 90 142 216 108 44 83
	     175 57 8 35 252 131 130 65 166 148 154 161 26 16 137 80 49 19 247 93 204 252 242 154 118 193 229 176 83 170 115 170 242 222 85 11 104 37 160 33 48 46 74 52 43 232 142 199 140 167 41 207 246 15 121 118 120 200 168 223 39 148 138 38 117 52 174 49 127 171 178 152 116 82 63 130 39 122 234 177 249
	     8 231 35 156 120 107 244 38 0 24 151 107 226 117 39 83 228 10 11 37 112 12 195 56 179 231 56 135 8 100 211 49 147 233 136 186 43 184 178 190 198 237 155 59 124 126 115 147 171 235 49 107 9 196 11 83 163 152 43 111 24 134 241 203 143 223 179 149 252 170 84 186 224 4 154 145 112 117 171 206 183
	     95 93 35 43 35 126 126 114 200 65 119 64 238 99 234 205 85 188 87 180 156 149 122 157 69 20 232 44 227 186 28 253 126 126 7 238 168 170 128 90 230 165 15 207 189 173 50 68 184 200 19 39 49 226 34 242 80 50 77 115 122 131 1 163 233 152 253 110 143 73 154 211 27 141 24 77 83 138 32 213 42 184
	     115 32 238 23 90 169 127 207 238 197 108 75 68 149 219 192 48 1 192 184 164 61 213 92 19 195 56 143 25 80 109 69 40 240 4 34 205 136 124 206 245 205 101 126 243 197 13 254 195 183 59 108 111 70 108 196 149 243 63 95 245 183 158 101 24 134 113 57 56 42 15 168 85 200 244 124 124 222 76 60 245
	     91 235 212 106 13 162 72 160 124 70 63 45 16 82 40 3 168 39 184 200 70 244 79 212 78 214 217 170 191 40 148 34 168 66 89 40 74 206 48 77 25 140 198 60 217 221 167 221 239 114 216 233 81 148 129 224 61 165 10 212 26 85 72 188 179 182 99 152 0 96 92 74 17 192 48 222 151 47 125 92 99 249 172 54
	     88 5 163 8 103 109 1 208 163 255 203 169 183 233 133 108 130 59 10 132 57 49 249 207 182 205 80 146 78 199 228 249 132 88 2 87 214 151 249 230 246 53 190 253 252 10 183 182 19 150 252 241 96 248 193 231 242 49 12 195 248 232 204 29 57 99 140 135 4 72 18 207 237 107 77 242 124 155 160 240 224
	     73 139 253 222 128 172 240 36 205 85 34 159 80 170 44 204 65 199 145 0 231 154 246 230 167 160 202 249 223 245 203 77 209 39 246 204 235 197 204 101 162 175 218 2 32 167 30 206 89 50 250 155 221 185 183 185 223 78 28 62 142 16 137 192 11 211 188 164 63 153 50 24 141 105 245 250 140 38 19 14 58
	     93 134 163 17 227 233 180 186 129 137 128 143 193 251 74 0 80 56 46 76 121 242 158 156 105 34 25 134 9 0 134 97 124 124 184 115 252 235 203 94 19 206 112 221 47 192 64 225 172 100 65 179 221 122 18 144 114 74 20 38 108 111 174 240 155 175 110 240 207 223 238 240 217 102 194 178 63 94 93 58 223
	     21 26 134 97 24 191 144 14 240 156 115 168 192 74 4 191 190 190 74 45 105 208 72 60 249 15 19 186 131 12 175 1 209 18 102 229 218 222 198 173 12 31 200 61 10 23 62 187 158 103 94 188 60 113 115 58 19 255 103 213 253 16 21 74 85 130 6 122 163 17 207 14 58 236 183 218 28 116 123 20 101 73 86 230
	     104 16 92 173 81 189 215 205 28 127 0 13 214 233 12 19 0 12 195 48 222 222 77 127 63 235 39 78 170 220 182 121 58 161 8 41 158 130 237 141 85 126 245 197 85 126 251 245 54 95 93 175 177 122 134 57 104 206 191 97 24 198 135 49 155 204 169 3 141 186 199 221 240 120 217 166 44 114 126 126 212 102
	     191 55 33 205 114 92 173 137 143 107 207 135 16 24 31 87 155 144 42 75 63 206 225 156 39 47 2 147 188 160 55 24 51 76 199 180 251 67 246 219 93 218 253 17 147 241 120 54 233 59 136 98 92 20 159 209 178 12 195 4 0 195 48 140 15 4 197 17 128 64 150 79 145 50 99 99 189 201 55 95 220 228 215 223
	     108 115 243 74 194 210 130 227 47 44 132 243 217 220 111 24 134 241 65 56 254 122 234 123 77 224 246 149 37 248 167 219 72 84 99 248 221 3 198 131 49 62 142 113 18 129 42 97 158 76 249 5 14 228 209 177 77 44 248 229 103 242 133 103 176 248 108 22 19 50 6 145 163 215 85 149 178 28 42 14 241 142
	     201 52 167 59 24 240 116 111 159 86 183 199 96 60 101 156 103 20 8 212 102 130 144 84 37 239 84 156 61 115 195 4 0 195 48 140 119 103 190 233 59 60 122 85 234 47 47 50 34 45 168 251 192 198 218 50 223 220 222 225 63 252 234 58 95 127 150 176 182 96 254 41 103 239 229 51 12 195 48 62 12 49 96
	     62 132 39 64 35 241 196 55 154 136 187 74 150 78 249 241 97 139 65 58 37 159 228 248 40 65 124 13 181 76 47 31 186 52 80 61 63 145 170 194 143 115 168 8 161 84 178 162 100 148 77 200 139 130 86 119 64 167 223 231 224 176 77 167 63 160 204 75 240 14 146 4 137 98 20 69 240 179 189 37 102 8 24 38
	     0 24 134 97 156 97 109 233 243 115 240 107 27 81 114 70 201 224 211 199 125 253 99 30 133 240 11 16 2 101 58 198 81 178 177 218 228 139 207 118 248 246 139 29 110 108 197 44 115 188 231 223 178 253 27 134 97 124 28 34 128 0 243 202 229 49 240 217 149 26 147 95 223 68 37 230 251 187 143 56 232
	     142 168 53 215 240 81 29 157 185 126 242 92 242 186 143 107 138 190 184 84 124 111 234 164 191 253 187 229 140 103 173 179 82 140 226 28 136 224 162 8 117 158 52 100 12 210 156 189 118 135 222 96 64 187 221 101 156 101 100 89 64 163 24 92 132 32 40 190 90 237 159 109 21 124 19 59 192 18 254
	     25 38 0 24 134 241 9 161 47 48 191 222 196 100 155 31 79 223 242 120 243 119 149 104 89 224 201 105 198 142 181 70 204 23 183 174 240 207 223 94 231 235 155 13 182 226 106 208 83 78 149 251 179 137 220 48 12 227 131 23 1 230 120 96 51 242 252 230 214 42 94 60 33 31 33 180 153 170 146 231 25 234
	     92 149 233 253 244 236 246 17 136 1 242 214 179 233 37 186 142 83 89 31 143 158 142 243 8 66 41 144 151 37 69 94 146 22 37 189 209 136 238 112 196 222 97 155 118 175 199 104 48 170 142 17 215 113 81 130 143 100 65 64 120 83 215 223 48 76 0 48 12 195 248 229 5 9 169 86 254 67 94 146 103 19 188
	     15 44 55 235 92 223 89 229 246 141 45 174 109 213 88 139 143 7 188 197 29 160 54 253 27 134 97 124 28 83 193 145 0 48 27 216 27 14 62 219 169 49 249 250 58 121 72 184 191 219 97 56 24 226 106 117 34 31 85 206 161 69 126 95 118 21 160 218 178 81 213 245 69 196 17 37 49 206 57 114 85 38 163 9 157
	     254 128 206 112 72 187 55 96 52 77 25 76 166 76 242 18 92 84 101 244 23 119 36 250 51 19 22 212 44 0 195 4 0 195 48 140 15 216 70 208 18 209 128 211 156 152 146 229 122 204 237 107 27 124 123 123 135 175 110 174 178 181 236 72 168 86 253 149 106 117 200 166 125 195 48 140 143 223 127 220 170
	     71 248 47 182 41 105 146 149 37 163 233 33 72 137 150 57 234 4 136 80 171 255 114 105 81 57 46 237 23 16 84 161 44 149 50 47 152 102 25 173 110 143 189 195 22 135 157 14 157 225 136 66 33 136 171 162 4 26 241 137 85 126 125 94 93 48 12 19 0 12 195 48 94 57 19 95 192 4 122 50 113 147 28 213 235
	     157 171 253 114 174 35 40 34 213 171 67 25 40 202 20 138 156 24 101 173 17 115 115 103 153 219 215 150 185 186 234 168 75 181 226 31 116 113 5 192 30 167 97 24 198 199 234 248 67 37 246 58 96 173 38 220 184 218 224 176 187 69 171 59 161 63 24 51 156 246 145 56 33 174 173 224 28 132 112 86 125
	     129 15 125 202 62 199 117 188 81 46 159 119 124 222 179 255 139 8 206 57 36 138 96 86 219 103 154 23 76 210 148 254 112 76 111 56 162 211 235 211 238 246 232 143 198 76 210 188 138 234 136 226 89 168 223 76 216 81 61 149 235 65 78 124 211 87 218 58 88 182 96 195 4 0 195 48 204 180 122 23 199
	     124 189 76 0 85 233 31 39 1 167 5 170 5 141 4 214 151 154 220 190 190 193 231 59 203 92 93 247 44 185 106 229 191 212 227 61 255 86 241 207 48 12 227 227 159 154 142 146 195 162 108 44 121 190 186 177 197 96 148 241 248 241 46 89 187 135 6 193 81 160 250 49 215 128 215 215 191 113 151 228 140
	     53 84 57 130 36 64 73 160 8 74 127 60 161 221 239 179 127 216 165 221 235 51 158 164 100 69 78 137 226 227 4 21 65 157 175 242 60 188 48 167 195 41 43 224 185 215 41 207 151 138 52 1 192 48 1 192 48 12 227 157 76 250 243 16 253 87 77 218 2 4 45 9 101 1 69 134 167 100 109 185 201 215 159 109
	     242 235 219 91 220 218 106 176 226 229 68 22 100 115 248 13 195 48 62 192 185 225 5 245 224 95 245 158 121 117 55 7 172 70 112 107 59 97 146 110 145 184 64 166 74 111 148 49 154 142 193 213 136 227 122 85 15 254 40 36 205 120 223 14 255 60 241 159 247 14 241 14 16 202 2 38 105 206 112 58 101
	     56 153 208 25 12 105 245 7 116 187 67 6 227 9 101 89 84 239 140 34 36 170 54 248 169 60 95 255 96 177 221 60 151 236 113 254 251 81 86 224 211 86 131 53 8 195 4 0 195 48 140 119 134 188 242 223 103 59 1 69 144 178 64 67 74 226 74 86 26 117 62 187 186 198 175 191 222 226 171 107 171 172 71 238
	     104 218 118 179 3 219 20 110 24 134 241 233 204 37 162 199 194 114 44 176 86 131 207 174 53 137 235 215 41 136 121 240 244 128 201 126 151 178 84 36 138 113 8 165 101 135 127 239 206 255 60 228 191 84 112 34 179 208 255 8 69 24 23 41 157 94 159 189 78 135 118 175 79 127 60 97 156 102 20 37 168
	     119 224 146 234 64 206 207 28 255 23 88 18 98 207 212 48 76 0 48 12 227 210 225 102 147 182 188 200 85 159 79 224 26 80 85 66 145 35 101 202 210 74 141 175 62 219 224 63 124 189 205 55 87 87 217 136 43 231 191 156 25 22 166 229 27 134 97 124 218 98 128 3 18 129 171 203 142 229 122 157 80 238
	     224 189 50 158 164 116 70 41 161 152 16 66 140 248 24 156 159 229 166 145 23 207 71 47 251 60 57 46 55 103 30 190 158 121 127 116 62 59 11 136 56 156 143 136 156 16 128 172 40 152 12 199 76 210 140 238 96 200 97 167 75 171 215 167 215 31 144 230 5 26 20 73 18 136 35 4 55 219 178 191 176 114
	     127 97 247 61 188 88 80 48 12 19 0 12 195 48 120 193 68 169 47 120 205 243 249 120 95 229 160 31 57 242 26 64 75 92 40 136 68 184 178 222 228 215 95 109 241 235 91 107 108 196 85 162 32 55 251 146 115 156 225 217 19 254 177 44 97 24 134 97 252 130 179 202 155 172 222 138 156 57 183 36 64 18 193
	     141 43 49 33 108 210 27 76 145 189 22 157 193 132 188 40 72 234 30 33 34 124 136 82 177 156 156 193 28 242 78 156 215 179 142 248 218 119 75 33 204 29 119 17 124 156 224 227 136 52 47 25 12 39 236 29 180 104 245 122 244 134 35 134 147 148 172 44 201 130 128 143 17 207 108 143 63 71 34 194 91
	     54 176 51 46 48 188 205 213 25 134 9 0 134 97 24 207 27 10 238 37 78 247 203 12 143 128 134 28 202 140 229 186 176 179 190 198 111 190 184 194 183 215 142 87 254 195 41 163 239 117 207 204 48 12 195 248 248 230 157 249 220 224 128 205 134 146 92 109 50 157 108 19 185 146 34 207 232 142 115 8 57
	     42 126 230 20 202 7 119 141 39 126 215 95 254 10 194 169 187 40 82 57 252 206 121 196 9 138 80 104 168 194 250 39 41 253 241 152 253 86 135 103 251 135 28 246 186 76 211 140 50 8 46 142 32 138 113 222 85 215 169 90 45 244 203 249 230 240 215 139 198 48 91 192 48 1 192 48 12 227 157 32 175 140
	     214 155 91 47 10 234 64 3 78 2 69 153 35 101 198 214 149 21 126 251 171 29 254 183 175 174 176 189 20 31 133 251 71 54 125 27 134 97 24 139 243 13 39 19 204 54 156 99 169 9 233 205 37 74 221 160 63 152 144 23 3 50 205 41 75 16 95 67 196 29 205 38 170 243 242 179 22 14 254 90 204 110 97 208 99
	     1 192 57 79 20 199 136 56 138 16 200 179 41 157 222 128 118 183 207 65 175 71 127 60 102 56 73 25 101 69 85 146 79 170 200 62 68 142 204 2 157 255 110 143 195 48 76 0 48 12 227 195 69 207 44 197 51 39 160 101 70 208 130 186 131 213 229 6 95 222 92 231 215 159 111 114 125 181 134 160 228 8 201
	     130 177 103 24 134 97 24 156 49 179 40 85 146 192 205 101 207 23 215 86 232 247 55 41 74 101 183 59 34 205 82 34 241 179 76 244 225 181 147 2 218 222 255 197 25 92 80 55 171 221 35 142 128 16 68 40 203 146 162 40 152 164 213 170 255 222 225 1 187 7 109 58 253 33 133 6 136 19 124 156 28 57 255
	     122 198 113 47 102 47 130 97 152 0 96 24 134 241 206 57 94 65 57 223 76 45 8 170 5 249 100 130 211 140 157 173 37 126 245 229 14 255 241 155 109 110 109 212 103 78 191 92 208 128 118 86 14 3 147 19 12 195 48 62 38 252 108 184 95 246 142 207 55 154 132 175 182 200 67 65 127 52 166 63 156 34 81
	     4 126 190 97 224 50 23 147 213 83 179 229 5 30 249 168 60 158 188 112 134 60 227 77 11 239 81 80 69 156 199 249 42 193 98 33 48 205 50 122 189 33 253 254 144 206 96 192 56 205 104 247 122 12 70 99 242 60 175 238 185 11 224 28 226 62 164 41 88 76 137 48 76 0 48 12 227 83 68 207 253 154 185 113
	     241 210 180 129 170 85 232 127 40 137 164 36 241 112 237 202 18 223 124 190 205 205 205 101 28 80 204 6 179 183 183 17 204 209 55 12 195 248 216 153 135 144 235 108 254 72 28 92 219 104 112 251 218 10 79 118 123 244 199 5 142 146 188 204 193 197 136 248 133 26 241 122 121 46 226 84 254 28 209
	     119 51 143 233 107 248 182 186 120 122 34 179 29 0 142 82 29 161 12 100 90 210 27 77 121 214 234 208 110 247 104 247 123 228 101 32 43 74 240 17 81 35 166 60 18 16 228 237 205 141 247 134 123 254 124 196 68 0 195 4 0 195 48 12 206 93 140 79 170 12 198 90 22 228 233 8 79 96 99 173 198 245 173
	     85 126 251 205 21 190 186 209 100 61 150 231 13 14 195 48 12 195 56 199 76 20 128 120 246 251 74 226 249 246 198 58 227 113 14 145 99 111 127 192 100 52 33 170 51 219 10 224 142 67 207 63 165 213 93 89 248 210 23 207 183 186 240 221 57 193 57 135 184 106 27 69 86 42 163 233 132 238 120 50 139
	     176 24 241 172 211 99 52 26 51 25 167 199 17 6 81 4 222 45 28 252 120 207 191 97 24 38 0 24 134 241 193 162 175 44 209 59 119 235 157 64 25 74 242 116 138 143 149 237 141 13 190 254 242 58 183 175 47 17 123 71 201 201 164 78 134 97 24 134 113 94 230 41 254 4 40 129 149 122 204 55 183 182 232
	     229 37 195 193 148 86 127 138 132 24 113 113 53 119 189 34 30 253 116 130 192 179 114 1 204 95 243 33 228 9 144 121 146 189 249 57 191 64 248 56 78 208 167 168 8 42 14 197 33 81 132 68 49 69 94 57 254 123 7 135 28 116 122 140 211 140 97 154 161 206 225 106 245 163 104 140 197 207 226 164 6 96
	     24 134 9 0 134 97 124 244 50 65 80 242 144 225 202 140 213 122 196 246 70 147 223 126 185 205 175 191 92 231 179 37 193 205 66 11 193 86 7 12 195 48 140 55 116 114 103 206 167 7 34 17 110 172 213 72 191 217 161 156 228 228 185 48 201 114 6 217 4 137 98 196 123 244 210 200 206 239 47 63 141 188
	     226 119 0 156 195 59 15 78 40 66 96 154 21 76 39 25 133 42 237 126 159 195 118 151 253 195 54 237 126 15 13 74 192 33 181 26 234 162 69 197 129 87 187 251 151 117 159 189 201 20 134 9 0 134 97 24 175 54 42 78 172 132 232 44 125 145 32 78 40 139 156 116 58 161 238 74 182 54 87 248 226 198 22 159
	     109 175 179 146 8 145 200 113 22 103 187 141 134 97 24 198 91 58 184 129 42 34 192 137 176 190 156 240 245 151 219 116 70 240 224 201 30 173 225 152 88 193 251 250 108 161 251 236 217 231 40 175 205 75 74 5 94 216 202 191 190 167 217 111 49 4 95 23 239 89 149 224 47 32 168 8 222 9 190 86 195
	     251 136 98 154 145 22 41 123 173 54 189 241 152 78 127 200 104 60 33 203 50 240 17 234 164 42 177 40 238 196 129 207 218 50 127 226 50 245 84 94 0 153 63 185 75 34 0 152 65 98 152 0 96 24 134 241 250 19 168 106 152 101 103 42 240 148 172 46 37 252 234 243 109 126 251 197 14 95 238 212 137 157
	     205 176 134 97 24 198 133 186 110 71 190 155 3 54 157 163 177 189 194 228 91 143 104 193 56 11 228 37 228 121 138 120 143 184 104 238 2 127 82 247 232 132 31 174 130 243 17 226 4 81 40 20 166 147 148 162 156 208 238 15 232 246 135 60 217 223 165 61 24 145 78 38 4 21 36 142 9 62 70 156 175 166
	     121 91 52 55 12 19 0 12 195 248 196 140 174 51 103 255 130 80 148 16 74 106 113 204 198 202 18 55 118 150 185 182 85 99 57 18 2 231 19 217 23 143 253 178 213 24 195 48 12 227 211 102 113 93 89 168 18 3 186 88 184 186 217 100 112 115 135 131 126 160 221 237 51 30 142 112 62 33 105 44 129 72 85
	     164 6 125 62 33 222 7 232 217 190 42 55 129 46 196 221 233 172 180 159 79 18 226 56 166 84 101 60 153 210 234 116 233 244 251 236 183 123 76 242 156 238 112 196 52 203 41 113 224 170 68 138 213 251 103 146 130 156 42 175 104 130 128 97 152 0 96 24 198 167 130 163 10 227 43 33 228 132 60 101
	     57 137 184 186 185 202 175 62 223 226 243 157 101 214 234 178 152 136 216 34 237 12 195 48 140 119 34 6 204 217 90 2 247 217 42 147 169 114 255 177 50 157 78 200 181 128 80 160 206 205 92 255 249 252 245 241 18 8 213 38 61 87 37 247 67 160 64 40 202 64 145 79 72 243 130 254 96 200 131 103 187
	     28 182 218 116 251 3 240 17 37 14 117 30 151 36 179 123 37 11 66 130 97 24 38 0 24 134 97 134 23 74 40 75 138 233 132 102 179 201 215 55 87 248 231 47 55 184 177 94 35 146 247 229 248 135 51 196 9 195 48 12 227 83 19 2 86 34 161 177 230 25 220 108 66 185 66 187 59 160 55 206 201 202 130 50 56
	     92 148 112 217 229 232 215 157 209 158 75 195 55 207 209 227 61 222 123 196 197 184 56 98 156 229 244 6 35 14 59 109 250 195 17 227 105 202 94 187 203 100 60 33 43 202 234 189 62 6 17 4 169 4 128 163 44 255 178 112 236 215 189 154 197 43 208 119 116 23 12 195 4 0 195 48 140 119 108 102 41 132
	     18 213 130 196 5 26 141 152 27 87 154 252 234 179 21 110 109 212 168 9 20 11 83 255 121 204 173 55 11 251 183 85 9 195 48 140 203 136 158 154 53 94 123 56 151 231 255 73 94 225 46 250 217 107 174 173 123 40 86 233 14 82 30 238 245 216 237 101 148 101 129 139 226 75 54 111 156 42 67 120 70 86
	     61 125 65 174 58 213 51 182 50 8 232 204 129 7 161 12 80 134 42 90 175 61 24 241 236 224 144 39 207 118 233 245 251 4 149 202 241 247 17 174 25 19 164 114 180 229 232 168 199 31 44 71 197 126 159 255 188 215 115 230 229 13 26 194 252 111 22 71 104 152 0 96 24 134 241 139 225 68 41 67 78 58 25
	     176 181 20 113 235 218 22 255 233 219 109 190 190 185 202 146 119 71 134 152 77 217 134 97 24 198 251 112 163 149 121 85 0 216 110 68 44 95 91 97 154 149 228 101 201 97 239 128 113 174 196 73 2 78 23 138 216 127 216 232 162 195 236 92 181 234 31 121 68 28 105 86 48 205 10 58 253 46 227 60 227
	     160 211 229 160 219 163 219 27 144 79 166 224 60 248 8 188 224 220 188 84 162 59 18 22 206 83 224 207 48 12 19 0 12 195 248 232 81 68 203 234 123 200 161 204 89 109 54 249 250 243 171 124 249 217 6 53 31 145 83 37 100 154 239 180 52 12 195 48 140 215 242 230 231 51 206 60 228 252 21 17 98 11
	     107 214 71 206 235 82 228 184 118 165 201 126 167 201 131 167 9 211 60 71 200 80 245 84 18 181 91 120 245 7 232 234 206 202 235 30 95 180 67 197 161 120 80 97 152 230 12 134 35 158 236 238 209 30 244 233 13 199 164 69 137 58 7 75 77 68 164 122 237 137 171 175 86 253 245 164 194 48 203 3 240
	     102 231 104 24 134 9 0 134 97 124 112 46 255 177 129 37 4 180 156 18 138 140 70 36 108 108 173 241 171 47 118 248 167 175 174 112 109 53 194 83 133 254 159 178 225 12 195 48 12 227 157 235 6 243 116 117 110 182 127 253 218 90 157 252 171 77 250 227 156 232 65 155 214 96 196 184 16 106 245 38
	     234 146 217 150 118 185 124 243 149 158 231 37 138 138 199 69 30 113 142 60 4 38 211 156 225 116 64 154 21 28 118 123 140 38 19 246 15 15 233 12 71 144 22 16 121 168 215 16 31 131 184 234 158 233 91 56 248 134 97 152 0 96 24 198 71 228 248 235 98 112 161 224 28 136 6 202 34 163 76 39 212 107
	     75 220 220 217 225 246 205 43 44 53 60 37 199 107 42 139 239 63 94 0 120 23 38 150 201 12 198 251 179 193 173 181 25 198 59 28 157 207 120 195 235 230 134 145 51 126 223 89 109 240 245 237 77 186 163 9 157 126 155 34 85 234 181 38 56 8 179 237 233 162 175 119 108 213 147 46 243 155 150 174 85
	     13 39 142 113 116 30 103 148 197 157 239 194 15 51 113 67 1 117 130 79 106 32 66 153 102 12 38 19 158 29 182 24 12 71 116 250 67 242 16 152 22 1 31 39 148 190 138 205 19 241 179 200 1 253 128 90 142 141 190 134 9 0 134 97 24 239 113 42 174 214 85 52 20 72 200 169 249 128 175 57 110 93 93 230
	     159 190 222 230 219 207 150 89 75 224 120 7 225 89 46 148 188 211 51 52 12 195 48 140 197 153 71 169 230 165 181 200 241 171 155 107 76 243 140 201 120 132 62 29 2 57 211 76 17 31 129 196 151 206 253 61 203 53 15 128 136 171 74 251 105 165 90 100 121 201 56 31 51 73 51 186 195 17 237 110 143
	     199 7 251 140 198 19 210 73 90 237 243 143 34 196 123 92 92 205 206 97 126 115 46 245 212 105 243 186 97 152 0 96 24 198 219 25 67 167 148 126 231 220 11 255 237 104 250 157 109 141 20 4 84 41 139 2 13 57 181 200 177 148 44 177 177 182 194 198 106 196 146 175 246 252 235 41 243 75 196 66 10 13
	     195 48 140 95 206 137 158 187 145 137 19 182 55 215 184 121 237 42 157 129 210 30 78 152 228 41 141 165 21 188 3 169 60 234 115 7 194 203 69 237 109 127 209 113 228 56 171 129 162 179 253 250 130 120 79 18 39 149 192 33 142 105 49 166 215 239 179 215 110 211 233 13 153 102 57 211 52 167 12 64
	     28 131 120 240 30 93 40 229 39 98 201 253 12 195 4 0 195 48 140 23 26 32 1 33 0 1 167 5 145 4 118 214 150 184 182 181 198 175 63 191 194 141 205 136 186 175 86 253 131 221 49 195 48 12 227 18 137 0 115 106 30 110 111 36 232 55 215 72 51 229 199 135 79 153 118 38 196 26 208 80 112 156 12 208
	     253 98 231 120 122 250 61 158 83 29 138 80 58 161 40 161 160 32 205 115 242 82 105 245 122 60 219 221 231 233 193 1 195 209 4 245 49 65 28 68 30 231 227 89 82 192 185 184 97 110 191 97 152 0 96 24 198 39 232 211 207 118 17 190 116 239 223 98 62 101 64 20 209 64 200 11 84 74 150 27 53 174 239
	     172 114 115 179 193 106 221 31 189 90 94 106 214 88 56 159 241 97 59 16 159 42 151 39 15 130 218 83 50 222 168 255 206 183 2 172 56 97 123 53 230 218 246 50 7 157 101 218 131 2 71 73 158 43 46 138 80 153 23 175 117 103 182 185 19 191 93 80 14 0 121 65 91 87 85 156 56 112 17 206 87 95 234 29 227
	     105 206 40 157 112 208 233 49 158 76 105 245 7 180 59 93 70 211 140 34 40 184 0 206 35 200 108 213 127 49 23 143 188 98 238 55 12 195 4 0 195 48 62 109 179 95 181 90 253 15 37 162 129 229 90 196 106 179 193 237 235 171 124 113 99 153 173 229 8 63 23 20 206 52 100 204 48 55 12 227 93 138 0 86
	     104 212 56 95 171 153 23 252 91 171 57 190 184 182 196 116 186 77 154 43 163 241 132 246 48 67 124 21 82 127 222 224 248 119 230 70 11 168 74 245 69 245 115 30 148 16 74 202 60 167 213 29 210 25 244 121 186 183 79 127 56 100 50 201 40 66 32 120 143 139 170 204 254 224 208 133 68 2 86 137 207
	     48 76 0 48 12 227 19 228 117 86 39 230 206 188 19 135 150 5 211 241 136 136 146 205 173 85 110 125 182 197 231 183 214 185 178 86 39 246 242 220 62 75 195 48 12 195 184 52 115 31 11 201 238 5 106 14 174 111 212 201 179 53 90 221 33 247 199 3 178 116 76 221 9 46 137 209 243 230 1 144 139 42 29
	     56 155 69 85 103 121 119 28 226 29 145 143 80 113 228 1 166 89 74 103 48 98 52 153 176 219 233 51 26 143 56 236 247 153 78 166 80 40 120 143 68 49 226 221 44 187 255 169 77 254 86 230 207 48 76 0 48 12 195 56 143 12 32 66 21 1 80 164 212 98 184 177 179 204 111 190 218 225 243 237 58 137 151
	     19 230 139 97 24 134 97 92 70 78 199 137 172 120 225 214 70 141 167 215 150 232 117 19 218 253 41 145 87 74 2 129 114 54 3 186 87 186 237 23 51 211 86 14 187 30 237 212 159 229 34 112 142 162 20 134 211 148 78 191 207 227 221 61 218 221 30 157 225 136 160 80 136 128 175 156 126 188 128 120 2 239
	     167 238 142 97 24 38 0 24 134 241 81 81 25 31 10 148 121 134 47 51 26 145 112 101 189 201 23 215 215 248 124 167 201 102 4 185 221 40 195 48 12 227 3 98 238 28 123 96 181 238 184 117 109 149 201 232 10 227 212 209 27 79 232 79 198 104 92 195 199 141 147 111 184 176 217 117 30 47 55 95 143 175
	     230 91 241 14 31 213 8 174 18 2 38 89 198 180 63 166 63 26 211 25 12 233 15 135 236 181 90 244 6 35 66 154 65 20 65 173 142 120 95 133 252 59 57 18 17 44 191 191 97 152 0 96 24 134 113 210 0 90 72 0 244 210 109 1 170 228 121 74 236 74 182 54 87 248 226 230 38 55 183 151 89 138 43 3 102 190 83
	     82 94 247 184 134 97 188 87 103 231 164 3 242 38 78 203 197 159 143 188 209 201 10 182 174 105 188 45 71 233 253 68 216 94 107 192 151 215 152 164 17 119 30 62 163 221 31 32 226 137 226 249 54 128 112 177 237 78 230 199 212 217 182 4 135 138 34 206 225 163 106 251 65 94 22 116 71 83 246 14 59
	     236 183 91 116 250 35 138 16 200 203 178 90 241 111 68 149 195 239 28 200 60 228 255 249 78 164 242 138 254 101 24 134 9 0 134 97 24 204 12 30 39 130 106 65 145 231 36 75 142 91 55 214 249 167 175 118 184 189 213 164 22 29 11 0 134 97 24 134 113 233 145 19 223 142 196 235 245 216 179 180 221
	     100 48 218 98 48 153 176 223 75 41 20 52 228 128 71 228 98 125 231 48 91 253 119 226 112 222 51 75 179 75 86 150 76 198 99 6 147 148 113 154 113 208 237 242 236 240 144 86 167 75 49 153 66 148 32 73 130 248 104 246 62 157 237 235 159 95 144 158 235 250 13 195 48 1 192 48 12 99 1 61 54 81 84 240
	     170 120 85 234 177 231 218 86 131 91 219 13 214 106 206 18 9 25 134 97 24 31 188 30 224 103 95 177 192 198 90 194 245 237 117 118 187 41 237 254 148 105 153 161 234 145 40 89 240 158 23 210 234 191 225 12 27 84 65 168 86 252 227 24 197 83 150 5 227 241 136 222 112 204 94 171 205 96 52 101 48
	     157 50 156 166 148 10 18 215 80 231 80 117 85 89 191 121 178 64 108 97 223 48 76 0 48 12 195 56 143 225 115 102 120 254 220 176 81 68 75 202 60 35 241 202 214 74 141 91 215 215 185 125 109 141 205 229 120 190 91 241 204 36 67 22 246 111 24 134 97 124 112 40 172 47 57 190 184 177 206 96 146 243
	     243 227 3 118 91 3 178 16 205 194 242 47 224 35 68 142 170 6 20 84 137 251 195 52 99 154 149 76 242 148 86 187 71 187 215 99 183 213 102 52 173 162 16 112 17 206 199 16 251 163 74 6 243 176 126 53 207 223 48 76 0 48 12 195 120 11 73 96 102 152 8 34 74 200 51 38 163 1 141 166 103 231 218 54 223
	     124 113 133 171 87 150 240 167 28 124 115 247 13 227 210 247 236 15 231 124 108 64 49 126 193 134 185 82 115 196 155 53 58 131 37 14 91 135 236 102 83 84 19 164 222 156 45 179 11 122 66 254 62 103 123 87 69 5 188 243 168 171 74 245 161 48 156 78 232 247 71 180 186 61 134 147 9 189 225 136 209
	     100 204 104 154 83 148 10 179 149 254 176 208 53 244 101 125 100 81 17 120 129 24 47 122 150 48 97 143 223 48 76 0 48 12 227 211 70 3 158 128 215 130 229 122 194 173 107 171 124 121 99 141 181 36 34 204 54 77 170 217 234 134 97 24 198 199 48 229 81 165 228 139 17 106 9 92 223 76 216 221 168
	     179 183 148 208 155 10 132 146 160 130 115 254 141 142 141 8 65 170 125 254 33 4 180 40 153 150 129 206 96 204 222 97 155 189 195 22 195 241 132 180 40 171 127 119 30 55 75 6 120 148 124 80 205 81 55 12 195 4 0 195 48 94 131 121 104 190 158 21 51 120 180 36 224 80 13 132 50 167 134 178 84 175
	     177 179 181 198 103 87 87 217 105 198 212 128 242 84 18 37 195 48 12 195 248 24 136 103 223 175 172 212 248 242 179 43 180 251 129 226 105 143 238 116 66 78 76 189 177 180 224 213 191 196 225 159 207 168 78 16 231 241 206 83 138 80 106 96 58 201 25 78 70 116 199 99 90 221 30 173 110 159 238
	     112 68 58 205 170 247 58 1 231 1 55 155 104 197 54 249 27 134 97 2 128 97 24 23 201 124 237 195 1 1 9 5 154 23 212 234 142 213 237 117 110 221 184 194 214 122 29 239 170 192 71 115 252 13 195 48 140 143 13 225 184 216 95 45 246 220 186 190 73 119 232 233 143 74 250 163 22 69 80 164 81 175 146
	     2 30 165 193 61 57 35 134 51 133 128 74 4 40 21 38 89 65 103 48 100 255 176 197 97 183 71 111 60 97 82 150 20 0 73 82 237 241 119 142 249 150 188 19 39 119 174 139 176 25 218 48 76 0 48 12 195 120 13 33 64 52 160 101 78 150 78 104 172 52 185 125 125 157 95 221 190 194 141 141 26 53 87 25 22 14
	     11 255 55 62 160 86 189 16 241 242 190 18 84 206 63 242 93 124 220 252 122 46 67 178 205 119 119 111 245 12 215 204 48 222 109 95 90 44 13 88 19 97 167 46 124 125 99 149 221 214 26 187 237 30 211 113 137 104 113 52 1 10 238 168 165 30 197 208 205 86 239 157 139 8 2 69 8 100 121 78 62 77 25 77
	     50 122 195 17 157 110 143 131 78 135 110 127 68 86 22 168 243 16 199 213 128 225 220 108 223 255 219 85 26 120 113 159 178 190 100 24 38 0 24 134 241 73 58 66 199 134 128 30 217 6 34 32 4 68 3 66 96 169 230 184 182 85 231 198 90 196 90 36 179 218 0 111 104 66 152 61 111 24 198 27 15 24 54 104
	     24 239 183 181 249 89 139 91 107 8 219 155 117 182 54 150 201 116 140 167 36 15 16 57 127 156 137 127 241 24 10 222 69 184 184 134 162 20 105 74 111 60 165 211 237 211 238 246 232 14 71 76 210 140 73 150 83 56 65 92 181 207 95 68 170 10 1 71 225 254 231 115 254 79 39 244 59 59 71 192 137 51 156
	     125 142 97 24 38 0 24 134 241 201 34 51 113 32 20 57 104 193 82 44 172 212 151 185 117 99 157 91 215 86 88 174 187 19 85 143 205 116 48 140 95 38 178 224 93 156 255 203 206 253 93 70 27 124 232 247 207 248 136 231 195 133 121 174 153 192 151 215 87 24 142 183 200 67 73 183 59 166 200 32 106
	     52 17 241 40 138 16 33 78 16 39 104 128 188 40 201 243 49 195 52 167 55 28 210 238 245 56 104 119 232 246 251 76 198 41 234 28 234 35 196 199 224 220 11 10 234 26 134 97 152 0 96 24 198 59 196 41 228 89 74 40 83 150 182 87 185 177 179 197 215 95 109 177 181 190 132 119 174 122 141 221 38 227
	     67 52 232 127 1 231 242 93 126 228 101 114 150 205 113 55 62 134 177 225 244 90 251 226 54 183 36 114 220 186 210 96 156 173 241 172 221 165 211 234 80 164 10 141 250 108 93 93 241 206 225 162 24 241 142 172 44 25 13 71 180 123 3 14 123 125 218 253 33 195 116 202 112 50 37 43 2 193 121 16 7 206
	     45 172 196 91 63 50 12 195 4 0 195 48 222 35 149 161 163 8 37 177 4 174 172 213 249 234 214 22 95 238 172 208 140 164 218 207 108 246 137 97 24 239 109 68 50 140 95 158 64 37 142 55 5 110 110 214 249 108 103 133 214 126 143 73 150 17 9 100 4 196 69 20 78 40 139 146 108 154 50 156 78 105 117
	     186 236 183 218 180 187 61 6 227 41 5 179 176 123 31 227 235 142 112 180 230 111 109 221 48 12 19 0 12 195 120 175 204 55 48 6 32 144 68 80 243 17 87 214 18 174 110 68 108 37 130 179 234 67 134 241 178 222 243 11 186 38 139 184 15 236 252 95 133 51 81 192 248 197 251 119 0 252 172 163 172 37
	     17 183 119 214 233 92 207 200 66 143 20 71 166 130 68 49 105 1 221 225 144 86 167 75 167 55 160 59 24 210 31 141 201 242 130 188 12 85 72 144 247 199 91 241 101 241 83 244 157 247 245 147 239 179 190 100 24 38 0 24 134 241 201 27 57 101 89 224 40 88 105 198 108 173 214 185 182 217 96 165 22 170
	     84 230 11 33 146 242 182 31 100 24 151 140 183 218 227 254 190 194 223 159 75 160 169 47 120 145 92 248 249 191 203 16 255 23 31 91 108 0 49 222 121 159 127 85 91 84 78 230 3 112 34 236 172 46 241 245 237 29 6 57 60 110 13 25 13 115 180 112 180 199 41 7 157 54 187 7 45 122 221 1 89 158 83 32
	     184 184 70 28 37 168 83 84 133 160 188 230 202 255 171 251 186 158 171 107 200 201 159 229 156 31 101 24 134 9 0 134 97 124 84 102 80 21 246 175 129 50 75 113 46 99 99 101 149 95 125 190 205 175 110 109 176 178 92 195 201 201 178 72 102 130 27 159 110 111 57 219 156 62 93 25 227 157 244 17 57
	     235 15 23 243 73 129 227 253 206 250 78 62 193 48 62 142 190 31 59 225 214 122 76 61 89 99 111 60 225 81 103 192 110 171 195 164 80 246 123 67 250 163 17 221 209 132 108 156 86 111 240 158 16 20 156 224 212 83 101 11 48 47 219 48 12 19 0 12 195 120 143 28 175 114 232 172 80 121 64 40 33 20 120
	     31 88 95 169 115 227 202 42 155 43 13 156 171 74 18 29 213 54 182 219 103 124 212 125 226 213 14 128 190 64 16 8 103 57 206 122 234 117 170 39 142 179 40 32 160 111 190 27 120 94 189 252 69 151 33 213 69 46 252 204 115 231 17 206 16 51 156 9 0 198 39 220 231 23 251 79 0 138 89 159 136 128 36
	     10 16 5 70 105 202 126 187 67 127 156 210 30 140 41 21 68 60 174 209 32 44 134 248 139 160 150 228 223 48 12 19 0 12 195 248 229 81 66 153 226 8 52 107 142 173 181 21 110 95 223 224 198 246 50 203 222 17 206 112 84 204 118 49 62 73 135 225 5 63 179 224 44 7 32 155 127 101 149 79 95 6 165 12 80
	     20 37 101 40 40 202 146 188 12 132 112 124 180 16 74 66 8 228 101 73 89 6 52 204 60 5 113 139 65 190 71 34 65 229 76 84 7 112 206 17 69 158 216 123 156 243 179 18 100 1 113 66 228 28 145 119 56 231 136 163 8 239 28 222 11 222 65 20 65 228 32 166 250 154 139 22 167 5 0 195 48 142 197 176 18 24
	     0 15 7 5 63 60 110 241 243 211 125 30 61 221 103 82 150 164 121 0 31 65 156 192 60 203 127 85 95 247 104 254 188 152 17 200 48 12 195 4 0 195 48 94 199 229 87 152 175 247 137 42 69 81 224 37 208 108 36 108 173 175 179 178 188 116 148 240 232 44 243 227 173 22 49 212 108 26 227 227 17 2 206 114
	     18 20 152 22 48 156 66 25 96 154 42 121 17 152 166 25 89 158 49 205 82 38 147 148 16 170 202 225 32 228 69 65 150 229 76 210 140 172 200 9 101 0 4 231 220 66 191 13 39 114 21 132 80 34 8 145 119 212 27 9 141 90 131 90 156 204 4 128 18 239 133 200 123 154 205 58 113 20 81 171 213 168 69 17 181
	     154 39 137 133 90 12 203 141 202 128 112 167 174 79 46 108 172 57 238 240 239 34 143 128 154 155 100 188 203 185 242 84 155 18 170 40 128 39 37 252 245 193 136 191 221 57 228 241 110 155 233 100 2 245 6 174 94 35 136 32 243 168 57 213 5 213 92 79 134 5 153 243 111 24 134 9 0 134 97 188 127 2 142
	     2 138 140 56 129 107 91 235 252 234 243 43 124 113 117 153 165 154 156 112 6 206 147 163 216 48 62 68 227 254 188 38 118 0 210 0 33 64 154 23 148 161 36 43 74 138 16 8 65 41 67 32 15 208 79 97 56 21 134 163 234 111 105 154 147 21 129 73 154 147 230 25 211 44 103 58 73 41 67 152 101 224 112 100
	     101 65 150 22 76 179 140 44 203 41 203 106 87 190 147 5 1 128 114 65 0 128 16 2 34 66 20 57 26 245 132 122 125 74 45 74 240 142 74 0 112 130 143 34 150 26 53 226 200 83 175 39 212 35 79 173 22 147 196 49 181 72 88 94 130 122 162 44 37 85 84 64 205 85 209 2 145 247 85 116 128 119 68 81 68 236
	     132 196 157 63 34 192 198 10 227 67 30 15 22 29 254 0 164 64 123 148 209 26 13 185 215 26 243 231 135 35 190 251 169 197 191 127 247 152 253 78 159 180 208 202 233 143 226 42 80 231 204 141 62 214 51 12 195 48 1 192 48 140 95 208 208 153 239 3 22 133 80 228 136 23 150 235 158 157 141 152 205
	     166 188 50 220 217 48 62 244 62 240 186 2 128 3 178 80 133 246 119 123 41 227 233 132 254 120 204 100 154 51 77 11 38 89 70 90 4 38 57 228 234 201 114 65 131 144 135 64 25 32 47 3 101 80 138 50 80 20 37 69 57 59 15 113 4 133 34 120 74 169 129 143 112 126 126 70 199 103 37 162 200 66 166 1 135
	     34 179 189 197 185 10 154 67 22 202 42 122 167 44 241 14 156 40 211 180 192 121 71 236 33 242 66 228 4 239 132 200 67 226 3 145 87 154 137 35 138 132 229 70 141 36 138 89 106 212 104 214 98 150 26 117 86 150 34 150 27 80 63 199 125 13 167 198 24 89 204 59 96 24 151 120 60 152 111 119 59 157
	     247 194 81 109 145 121 212 158 242 239 127 187 195 31 238 60 228 206 211 49 131 169 163 59 28 82 226 208 122 3 149 248 120 82 181 22 111 24 134 9 0 134 97 92 70 139 71 203 128 184 146 165 122 194 213 141 26 183 175 45 115 99 35 161 33 199 198 144 97 124 140 198 254 105 33 64 128 124 246 115
	     94 42 69 9 165 150 132 50 16 84 73 115 24 103 208 25 20 76 167 25 173 110 143 193 100 74 183 55 100 60 78 25 79 51 6 147 148 34 40 65 65 162 8 164 218 3 172 115 151 194 57 156 120 84 170 58 224 229 252 243 69 1 95 185 26 177 16 71 128 204 92 253 197 218 94 194 145 0 160 84 229 200 160 10 179
	     15 170 164 161 68 66 149 39 192 33 136 6 132 2 52 80 109 54 40 16 13 16 180 74 250 137 162 101 1 170 196 222 145 196 194 242 82 157 90 82 99 117 169 65 163 158 176 186 212 96 109 117 202 234 82 141 237 181 152 122 172 36 222 129 8 222 123 156 8 209 44 167 128 155 93 133 57 252 198 135 68 56 245
	     123 14 148 10 105 174 132 34 103 111 52 229 105 47 231 191 254 254 46 255 249 95 255 204 157 31 239 49 28 22 176 182 73 30 53 144 184 142 107 36 4 107 245 134 97 152 0 96 24 198 229 228 120 85 49 207 51 162 168 100 165 94 227 218 149 13 174 110 174 210 76 162 19 33 255 23 27 9 160 47 40 101
	     102 24 111 238 196 191 110 75 146 23 188 222 3 83 160 155 9 131 97 193 96 52 162 63 28 146 230 57 163 113 65 158 59 134 211 146 188 40 24 78 82 210 172 96 50 77 201 242 146 172 128 73 225 142 115 244 149 14 156 67 197 33 226 1 65 84 112 248 163 62 56 119 24 102 65 253 8 14 153 237 31 62 243
	     122 4 230 65 248 139 89 253 143 214 47 213 205 66 143 3 161 58 26 129 42 151 64 117 94 30 9 2 101 152 125 102 32 132 8 13 74 161 66 22 148 130 64 148 22 140 210 9 113 146 82 239 77 104 180 6 212 147 136 149 165 136 122 13 86 235 117 226 36 102 109 117 133 165 90 131 181 53 88 166 90 37 125 237
	     7 39 111 63 154 25 198 91 13 34 114 114 107 75 4 76 5 158 140 132 199 143 15 249 221 15 247 120 116 56 226 187 123 187 252 248 164 69 39 21 130 36 16 124 149 237 95 170 190 78 80 62 56 217 220 84 126 195 48 1 192 48 140 79 199 234 17 2 101 145 19 39 112 227 202 26 223 220 218 225 230 214 50 137
	     147 247 242 249 102 190 27 191 84 235 47 169 108 245 82 3 170 80 168 162 170 12 114 101 152 10 143 247 115 218 221 49 173 78 135 253 78 143 241 116 202 100 156 225 240 148 50 47 139 57 203 238 141 71 136 209 88 72 98 5 173 182 207 168 131 42 96 223 85 97 250 204 28 251 89 18 48 197 225 194 98
	     73 190 69 167 127 214 71 85 95 110 172 207 75 10 138 226 68 193 87 34 3 84 66 196 92 102 152 71 37 235 252 152 90 197 3 56 81 230 187 149 221 236 108 11 133 34 8 211 52 192 52 7 205 170 138 2 26 16 167 68 222 177 182 84 167 209 104 112 237 74 198 250 242 42 219 87 26 108 172 58 86 98 165 153
	     64 132 16 59 16 113 56 17 156 28 71 6 24 198 101 195 1 185 66 17 148 180 44 105 103 129 253 81 224 127 252 245 144 191 252 227 7 254 245 143 127 167 219 31 50 41 148 92 60 209 198 78 37 0 136 67 197 163 179 132 156 54 159 25 134 97 2 128 97 24 151 132 211 185 251 231 2 64 73 40 10 34 34 182
	     54 26 220 190 186 196 118 211 157 48 138 130 153 52 198 7 72 224 56 27 191 156 209 27 60 48 14 208 29 228 164 121 78 107 56 38 77 83 14 7 57 227 169 163 221 15 12 39 25 253 225 152 238 104 74 154 151 100 89 181 159 94 156 67 188 224 188 199 57 193 139 71 102 161 240 85 230 111 61 90 157 159
	     59 245 199 43 141 199 169 52 21 121 251 206 181 144 16 240 185 244 124 50 191 254 153 164 32 243 123 35 204 63 250 104 119 129 84 2 72 0 8 85 165 129 50 148 132 210 85 219 32 10 157 149 51 12 56 148 65 150 82 31 42 227 84 105 214 39 60 107 213 104 214 97 185 161 172 52 133 213 90 141 205 149
	     6 203 205 6 27 203 241 201 200 0 57 91 148 177 113 198 120 31 204 215 232 221 169 182 232 5 246 10 225 167 251 251 252 225 254 30 123 157 140 127 251 199 46 15 159 29 112 239 89 31 210 28 146 26 212 235 120 223 196 71 49 69 208 163 241 198 150 210 13 195 48 1 192 48 140 75 236 26 5 40 75 92 84
	     210 172 69 108 174 54 217 222 108 176 186 36 207 25 225 86 3 220 248 208 90 247 156 114 193 216 71 171 125 249 138 82 6 24 230 202 65 47 227 217 222 128 241 116 194 211 189 54 253 225 144 246 96 74 161 17 193 39 148 68 132 32 184 168 70 45 114 196 245 106 31 191 72 21 102 191 24 166 175 179
	     146 95 202 113 217 187 197 222 164 39 252 117 121 206 33 57 233 211 159 223 145 56 122 165 202 139 143 119 150 4 34 39 147 32 86 209 1 179 8 5 87 73 39 78 35 240 179 49 32 81 144 89 86 144 0 78 2 165 42 157 225 132 222 96 204 222 65 129 211 130 216 85 99 202 198 218 18 215 175 108 178 179 181
	     202 103 55 86 88 175 121 106 81 21 9 32 82 109 77 88 12 187 94 20 0 108 204 49 222 229 216 48 111 247 197 172 221 231 26 8 34 28 142 114 126 247 115 135 127 251 253 119 252 247 223 125 79 111 156 178 219 157 146 71 53 220 202 26 97 57 2 87 229 244 8 2 161 212 19 233 57 76 194 50 12 195 4 0 195
	     48 46 33 179 12 226 33 35 207 166 52 124 196 250 230 18 95 222 222 230 214 245 53 150 106 22 164 107 124 216 44 238 237 159 27 250 35 96 90 10 221 65 202 120 50 161 63 206 104 247 115 250 253 140 131 238 136 52 205 56 108 15 24 77 166 140 166 25 184 8 159 128 68 138 143 98 156 143 16 231 240
	     18 31 197 206 84 25 52 245 164 115 127 244 61 204 94 229 120 62 221 224 101 185 73 103 137 16 179 191 73 149 47 64 143 2 20 102 158 250 108 187 0 78 9 161 32 204 202 27 106 89 80 228 41 90 22 56 13 36 145 208 30 150 116 70 176 219 73 121 218 25 178 220 140 217 94 73 88 106 212 88 93 94 98 169
	     33 52 163 99 195 229 244 93 50 87 202 120 151 99 131 80 149 245 27 9 220 63 156 178 219 235 241 253 253 67 254 229 79 143 184 115 239 33 127 253 241 25 101 158 3 14 150 61 172 44 131 171 29 29 69 53 156 26 105 12 195 48 76 0 48 12 227 92 238 248 217 150 174 188 165 61 161 114 198 39 133 89 9 49
	     1 180 36 20 83 18 215 96 103 115 149 207 63 219 100 99 181 113 180 162 249 126 204 176 23 253 110 24 47 104 215 186 176 150 45 242 130 141 45 213 235 20 33 204 66 218 187 185 210 234 7 30 60 238 177 119 208 161 215 31 49 152 164 148 193 145 23 74 64 41 92 76 220 140 88 174 87 43 249 65 226 234
	     51 220 44 123 191 42 74 201 217 169 49 79 181 100 225 5 103 246 14 122 211 27 247 89 61 243 111 103 7 31 232 98 168 1 204 162 31 196 59 68 18 36 138 136 146 120 86 121 64 241 162 148 2 157 113 206 48 237 243 248 160 67 236 148 141 229 38 59 87 214 184 121 205 179 125 165 206 246 178 176 26 87
	     161 215 71 66 131 92 76 4 192 81 20 134 200 107 60 3 121 193 123 63 150 249 70 207 184 90 185 20 253 250 149 109 250 109 50 126 206 8 179 227 148 179 246 220 43 2 79 39 37 255 243 239 123 252 254 239 119 184 115 239 17 15 158 117 72 213 225 87 214 16 21 74 23 33 62 70 17 84 203 83 245 115 79
	     59 255 242 138 19 54 12 195 48 1 192 48 140 51 204 4 247 142 142 91 229 29 171 178 131 71 4 18 2 107 53 199 237 171 75 124 117 189 193 149 68 222 99 232 173 57 253 198 219 181 235 179 42 83 148 192 52 40 227 105 65 150 151 244 210 156 113 89 178 219 42 105 245 82 30 239 118 217 111 245 25 140
	     38 164 121 137 143 60 81 148 224 92 245 221 71 85 54 239 121 152 126 181 202 119 50 144 255 248 243 245 28 173 91 63 144 81 231 156 189 116 241 230 75 85 177 0 47 200 220 105 159 57 110 33 148 76 203 146 114 90 82 150 5 211 233 4 41 75 150 26 57 123 131 146 214 8 182 218 43 108 173 122 174 172
	     41 171 181 136 149 122 141 90 189 198 82 252 46 183 0 168 141 73 159 64 2 214 197 188 53 139 87 88 2 19 133 103 189 49 147 201 148 191 60 237 241 243 179 17 255 250 151 135 252 241 187 251 28 30 28 64 150 195 234 26 82 111 226 92 140 143 98 180 218 59 52 19 42 180 18 232 221 252 110 158 37 104
	     155 243 111 24 134 9 0 134 97 252 226 44 100 252 82 197 59 168 197 49 75 245 132 149 58 52 8 196 120 194 11 28 172 35 211 241 35 93 25 51 62 148 102 44 39 218 231 137 176 241 106 243 61 147 172 228 233 225 132 94 127 200 110 119 192 112 148 209 26 230 140 114 101 148 66 41 158 168 214 68 35 173
	     202 119 249 8 17 5 241 4 61 178 234 103 199 118 167 92 38 107 247 213 13 89 172 83 112 92 246 240 168 252 161 122 20 135 248 8 231 2 117 31 33 26 240 30 198 69 96 247 176 67 175 223 227 89 82 178 146 192 214 218 50 55 175 94 225 198 78 204 210 106 85 97 97 241 118 191 40 145 227 203 155 138
	     188 69 51 179 231 252 126 187 245 197 221 239 249 182 159 197 36 160 71 255 11 74 63 47 249 251 207 135 60 120 244 148 127 251 254 62 79 58 19 158 116 50 198 121 129 111 172 80 214 5 146 4 149 152 128 63 74 28 80 181 73 225 248 15 54 36 24 134 97 2 128 97 24 31 128 243 68 25 8 161 160 86 247
	     44 47 175 113 251 198 58 215 54 234 52 188 156 112 170 204 166 49 46 157 207 185 240 37 84 9 188 2 48 45 65 139 64 90 228 180 199 5 187 173 41 143 159 245 232 244 134 236 181 7 12 39 83 198 89 73 112 17 46 105 32 81 13 23 39 196 177 63 218 131 35 11 9 241 228 68 168 187 241 146 1 229 196 207
	     139 119 43 8 168 171 158 148 23 136 164 86 189 66 51 210 162 100 50 25 67 152 34 101 78 44 176 185 54 161 53 20 58 99 232 238 52 216 92 246 44 69 14 23 69 196 177 16 207 83 16 156 26 159 108 156 50 94 212 50 75 32 167 90 241 207 211 192 116 50 229 167 206 136 71 187 35 254 219 239 126 224 167
	     251 143 248 243 79 15 25 76 75 52 89 66 146 38 210 88 198 185 120 150 255 226 140 24 159 163 74 27 193 134 7 195 48 76 0 48 12 227 45 76 104 125 177 89 253 166 174 136 156 78 169 37 30 135 80 134 146 34 77 145 70 204 198 234 50 59 87 54 88 93 169 227 221 241 82 219 44 186 247 5 199 149 231 79
	     200 172 240 79 194 249 230 18 60 114 225 56 60 124 94 162 114 82 64 171 157 115 208 106 179 215 25 208 30 100 116 6 25 227 105 206 56 87 178 224 80 231 192 123 130 120 156 58 16 119 86 30 188 151 95 215 233 196 28 106 13 255 165 227 218 115 131 136 82 101 8 208 234 121 16 129 10 37 48 76 149
	     103 237 1 89 89 208 234 68 108 174 213 216 90 89 99 123 123 149 171 107 114 178 132 224 57 199 67 125 209 216 245 73 63 151 15 56 255 138 156 239 153 207 215 233 147 217 223 38 10 247 251 129 251 247 159 241 251 31 31 178 119 48 226 175 63 63 165 221 27 48 9 30 141 34 112 9 234 170 168 149 163
	     125 253 139 185 35 20 22 55 22 188 184 124 231 187 207 249 97 24 134 97 2 128 97 124 44 198 242 25 70 204 219 31 119 193 8 209 128 8 8 1 17 101 101 41 225 230 181 13 110 95 95 99 99 217 91 200 171 113 169 153 111 77 41 129 160 85 219 158 148 202 32 19 30 236 229 60 120 218 229 241 147 61 246
	     59 61 178 82 9 120 84 60 226 18 168 213 136 230 161 252 226 81 60 47 74 214 245 226 116 113 225 195 117 156 222 11 250 242 113 109 190 119 26 135 243 243 50 131 201 145 152 147 134 146 253 94 74 171 63 198 17 88 91 110 176 189 145 243 249 216 49 190 185 204 181 53 161 233 193 233 172 132 160
	     3 255 70 79 194 158 219 199 116 15 22 163 240 231 238 249 20 240 170 12 139 64 175 20 126 216 157 242 191 254 254 140 239 126 248 129 63 252 237 71 6 227 148 238 48 71 162 24 105 172 19 187 136 82 162 35 231 95 67 56 18 1 230 238 190 158 136 63 114 175 184 135 230 252 27 134 97 2 128 97 24 151
	     192 68 82 164 42 77 38 224 16 26 81 204 198 74 204 102 211 179 180 224 252 155 121 108 92 38 87 242 116 93 120 15 12 129 78 119 194 147 118 151 86 191 96 175 163 236 182 199 236 119 167 244 39 138 170 32 81 132 184 8 239 34 156 28 199 13 40 243 189 188 238 248 248 170 102 180 191 7 167 243 132
	     204 34 14 112 71 178 74 41 158 50 100 104 25 208 160 100 33 99 90 246 41 112 140 134 93 14 54 28 59 171 13 54 87 87 217 88 141 159 139 8 152 63 91 27 191 62 157 49 98 254 229 79 141 17 117 96 138 240 195 195 3 254 241 248 144 191 62 236 242 187 59 251 60 61 56 228 225 225 132 162 40 65 61 68
	     49 206 215 193 121 194 209 187 23 99 8 22 62 77 103 18 164 9 229 134 97 152 0 96 24 198 135 96 120 67 128 178 218 49 93 139 133 70 189 201 213 205 21 54 151 35 26 167 75 110 153 125 99 92 18 195 30 142 215 221 231 123 254 211 0 79 219 37 247 31 182 249 241 254 99 90 221 49 211 178 70 22 60 25
	     66 212 88 6 117 136 68 168 8 130 60 87 250 236 68 59 55 191 255 61 143 69 139 183 220 31 175 224 138 195 199 17 196 101 85 162 148 146 193 52 37 127 186 207 211 103 25 107 13 184 126 101 131 47 110 6 190 188 181 201 206 170 167 49 27 184 202 153 207 230 224 61 86 49 49 126 201 49 34 44 124 165
	     128 83 69 69 168 3 7 5 220 121 210 230 255 251 47 223 243 175 127 250 145 159 158 182 217 27 100 104 173 137 214 150 113 137 160 62 66 197 19 36 58 53 16 156 12 251 127 69 92 139 97 24 134 9 0 134 97 92 172 145 243 86 239 215 106 191 167 72 181 246 159 21 41 170 37 171 245 6 87 183 86 185 113
	     125 157 181 149 100 182 58 250 218 54 188 97 188 51 22 157 56 63 51 240 219 163 130 131 222 152 254 56 231 233 65 198 163 103 45 30 239 14 25 140 83 112 224 226 26 196 9 46 74 170 119 105 181 138 55 15 221 61 111 89 190 151 22 246 83 75 124 113 209 98 192 209 61 23 169 182 33 137 67 136 32 228
	     228 121 73 154 102 148 217 132 254 80 25 165 142 113 238 25 102 5 59 235 9 215 214 234 44 47 45 177 220 168 86 125 207 122 134 242 220 211 125 205 231 118 1 181 231 141 139 111 57 158 227 149 127 128 142 8 247 247 135 164 131 17 223 61 107 241 143 7 251 252 235 31 127 230 111 119 158 209 237
	     143 170 21 255 181 58 210 76 64 28 234 227 121 56 16 39 37 199 179 31 188 48 31 79 196 26 128 97 24 38 0 24 134 113 153 221 168 106 9 195 9 72 200 113 33 103 173 177 204 237 107 27 220 188 185 202 114 195 153 45 99 92 10 22 87 252 23 51 188 151 192 193 4 190 127 208 227 167 251 123 116 6 19 134
	     147 130 113 150 147 73 29 223 108 32 120 144 106 69 79 143 18 243 133 153 177 254 188 211 39 202 44 164 247 117 221 14 235 44 239 182 13 4 68 103 91 5 196 225 162 26 226 60 62 138 17 87 50 200 149 251 123 93 14 187 3 150 235 17 183 175 111 114 227 250 85 190 184 217 100 179 94 137 0 142 147
	     149 34 158 247 215 195 25 227 164 241 33 140 15 243 125 254 243 8 128 249 54 144 22 112 103 127 202 127 249 247 7 252 124 239 9 127 249 249 46 123 221 49 195 73 96 18 53 136 215 151 80 137 8 81 92 109 133 83 133 133 125 254 103 127 218 41 25 201 185 179 116 1 195 48 12 19 0 12 195 184 188 134
	     147 148 5 174 204 88 73 224 198 86 194 245 101 127 230 62 90 195 248 37 88 220 235 47 192 72 149 193 36 163 53 42 120 176 55 225 135 187 7 60 120 214 163 63 154 162 40 18 69 36 245 37 188 139 0 57 114 252 143 157 254 197 93 231 102 181 95 206 145 233 44 7 125 254 236 28 120 135 243 85 130 82
	     165 100 154 167 140 70 25 173 254 132 216 9 189 12 14 198 48 204 214 217 217 136 184 190 148 176 185 92 163 38 150 15 224 221 207 40 239 239 147 148 231 115 129 100 192 193 164 160 211 237 243 135 103 29 238 60 232 241 223 254 116 159 59 247 158 241 244 201 179 106 95 200 202 26 81 115 25 23
	     37 136 120 130 6 208 217 8 161 175 83 71 98 81 252 179 177 196 48 12 19 0 12 195 248 64 240 2 73 4 203 53 101 173 30 88 94 48 103 148 176 96 210 217 138 152 241 126 8 167 76 234 121 110 254 12 216 239 230 252 244 176 197 189 167 7 236 182 38 244 198 74 30 60 46 174 131 115 213 254 93 226 153
	     227 47 11 174 2 85 56 249 185 141 124 227 114 186 153 50 11 96 58 46 250 168 146 64 236 17 23 19 68 233 140 114 70 211 93 250 253 22 155 203 9 95 95 223 224 219 207 183 185 185 94 63 50 134 194 115 14 164 141 111 23 215 115 223 77 84 140 158 250 154 71 5 197 11 255 222 26 195 191 126 255 140
	     63 253 229 123 254 245 135 251 180 6 57 143 187 57 189 113 14 245 85 68 60 26 215 41 136 33 128 136 190 94 248 254 233 148 0 230 248 27 134 97 2 128 97 24 31 140 169 22 74 148 130 122 28 177 181 84 99 103 115 137 149 154 179 245 12 227 23 118 240 78 184 236 20 64 94 194 184 40 120 214 75 185
	     255 100 192 15 119 247 121 240 244 128 193 164 192 37 75 212 151 234 212 102 2 64 192 17 130 30 109 203 151 23 174 40 27 31 46 139 194 142 195 71 30 31 43 162 224 180 36 47 82 134 163 33 227 65 96 63 137 152 78 149 73 14 147 207 55 184 186 90 39 137 35 18 119 44 105 138 181 140 11 122 38 250
	     206 199 134 211 171 255 57 80 40 236 143 166 236 141 114 254 126 175 199 127 253 247 127 240 251 191 126 207 247 63 63 34 184 8 234 43 72 173 73 180 190 68 144 24 84 43 17 80 103 98 224 98 190 155 215 77 5 97 19 165 97 24 38 0 24 134 241 65 24 106 2 69 81 224 201 89 171 215 184 190 179 206 141
	     157 43 44 55 106 103 24 117 134 241 254 156 255 69 247 46 0 153 194 179 118 198 195 189 54 15 158 117 56 232 78 57 236 142 25 151 30 141 98 212 39 20 97 94 62 110 222 100 101 230 37 152 117 254 81 140 88 11 14 218 233 232 141 163 52 142 51 103 46 168 16 240 224 107 148 90 50 46 132 103 173 41
	     253 209 51 118 15 187 124 113 115 135 47 110 110 113 107 51 34 226 100 0 183 141 118 111 219 123 229 157 30 125 254 228 23 171 58 164 192 189 78 206 127 251 253 29 254 242 211 99 238 62 235 241 243 147 22 123 157 33 133 107 130 143 192 37 160 17 148 2 78 79 10 22 34 199 2 192 169 182 37 103
	     140 31 39 163 5 100 150 44 144 11 136 8 176 68 162 134 97 152 0 96 24 198 187 149 0 8 69 1 174 100 117 101 153 91 215 55 184 118 101 141 90 124 186 28 151 25 34 198 171 219 210 69 11 0 37 48 45 149 113 25 56 28 148 252 240 176 203 221 135 45 158 28 116 72 203 128 226 169 53 150 169 249 132 160
	     14 85 87 189 87 79 184 132 207 25 227 111 18 250 47 47 49 211 141 95 210 217 156 249 111 167 125 79 129 200 199 36 205 8 71 137 6 24 229 37 135 189 33 251 237 1 157 161 146 134 26 46 90 97 181 1 235 222 33 78 22 162 1 94 237 158 85 162 132 61 133 119 55 18 188 248 254 7 32 85 232 23 37 20 37
	     247 135 37 255 254 253 30 255 215 191 252 200 31 255 113 151 238 104 74 30 28 81 189 65 115 123 131 128 163 84 79 16 33 40 39 75 127 158 242 221 245 60 142 249 137 7 191 32 6 28 233 10 250 70 87 119 90 108 80 107 96 134 97 152 0 96 24 198 27 155 101 243 21 81 102 97 143 40 78 21 130 226 156
	     178 190 28 113 115 187 193 213 21 135 234 241 190 74 51 63 140 247 232 202 33 28 175 234 13 11 120 210 154 242 100 191 195 110 107 196 131 253 1 135 189 156 222 4 130 120 162 40 194 19 227 136 22 86 6 229 148 243 111 124 154 14 168 204 246 135 203 76 28 130 16 132 105 136 40 210 130 39 7 61 196
	     61 38 157 172 177 189 94 227 203 107 107 108 172 214 88 114 103 7 177 91 123 250 101 198 132 249 215 188 164 159 91 16 0 246 198 57 127 187 251 140 39 79 247 249 238 113 135 239 30 182 248 219 221 3 246 58 105 181 31 32 138 40 139 8 137 146 89 244 136 67 9 71 139 245 151 73 216 48 12 195 48 1
	     192 48 140 119 104 24 207 170 159 135 18 113 74 236 160 89 75 88 93 137 89 110 56 60 85 52 163 133 194 26 239 211 200 15 11 134 190 3 166 1 118 123 57 247 30 247 248 233 193 62 135 221 46 157 177 34 73 131 70 179 73 16 143 82 173 248 135 231 194 111 45 193 223 71 217 86 206 243 76 245 100 67
	     168 222 82 109 244 247 46 102 121 117 21 31 114 138 114 202 179 253 22 217 116 72 123 99 21 39 142 76 225 230 122 141 88 142 5 208 121 213 9 107 77 191 140 227 63 31 27 22 199 135 160 202 131 34 240 143 251 45 254 229 207 247 249 235 63 238 242 253 195 103 180 70 25 121 180 66 125 125 147 2 161
	     196 87 239 16 183 144 198 246 197 79 243 69 237 203 86 225 13 195 48 1 192 48 140 143 130 16 10 4 165 145 68 108 174 53 216 90 95 101 185 17 159 246 163 22 140 234 139 82 4 108 109 205 120 158 121 134 255 28 56 28 229 60 218 31 112 111 119 196 195 221 62 143 118 7 140 38 25 169 10 137 128 139
	     29 72 37 21 232 60 220 95 22 2 120 213 90 156 113 250 249 87 98 145 56 79 64 200 178 148 113 154 49 201 114 6 83 69 157 227 160 63 102 124 99 141 205 141 21 54 235 142 186 59 25 22 126 84 50 245 5 237 234 83 189 179 23 210 163 206 216 250 238 78 221 235 253 2 30 237 13 121 188 187 207 15 123
	     109 238 60 104 241 143 159 159 113 231 254 83 218 7 29 2 14 214 154 104 211 35 226 65 252 66 44 208 187 150 113 206 26 101 222 228 243 108 116 50 12 195 4 0 195 48 46 202 60 209 99 51 214 137 162 161 0 7 141 70 204 198 198 10 203 205 101 156 139 222 147 25 98 46 217 71 235 11 188 193 35 13 11
	     147 211 72 225 238 193 136 127 220 217 231 201 193 144 81 86 82 224 72 154 203 56 241 224 162 106 69 78 171 119 202 25 31 183 120 42 243 104 150 211 231 106 45 238 67 230 28 25 25 228 228 166 144 163 151 168 16 68 136 106 117 36 246 136 20 76 242 146 39 135 61 90 157 33 121 86 240 121 153 80
	     191 213 32 225 56 244 92 223 198 85 251 40 135 59 229 130 149 225 19 71 158 175 248 207 75 251 21 192 227 33 252 207 191 239 242 187 191 253 131 31 30 61 165 213 159 144 230 66 230 99 162 173 109 2 158 16 53 8 50 115 190 181 156 237 125 147 119 127 47 228 98 218 181 218 192 100 24 134 9 0 134
	     97 92 164 81 37 204 146 29 163 20 217 132 160 202 250 214 38 95 92 95 227 230 118 131 90 36 191 208 153 153 8 240 169 233 4 139 142 187 7 70 133 210 155 78 185 243 108 192 63 238 182 184 247 168 67 107 144 34 81 4 46 38 142 106 56 231 41 213 54 167 24 111 51 2 2 56 196 37 136 139 41 67 74 94
	     228 164 237 41 26 2 105 169 116 198 74 94 110 114 115 179 201 86 51 102 53 118 71 123 207 109 196 58 237 252 95 224 152 176 176 242 239 128 9 208 155 100 236 118 122 252 220 26 242 199 187 3 254 199 95 30 242 231 239 126 166 187 119 72 64 144 229 101 72 234 72 173 134 184 136 170 170 159 92 240
	     98 191 165 0 53 12 195 4 0 195 48 62 100 4 156 6 66 158 17 40 89 170 193 181 43 49 87 87 28 17 213 202 139 123 149 253 115 97 198 148 25 82 31 173 139 48 219 79 123 162 116 219 172 125 205 141 252 69 17 160 51 14 124 119 247 128 191 222 125 198 97 55 39 11 14 23 39 224 99 144 132 82 28 162 238
	     149 159 103 24 231 113 55 231 249 35 84 18 240 14 117 30 13 37 195 73 193 253 199 251 104 49 102 116 115 155 95 223 190 194 242 186 9 0 47 118 254 223 238 46 204 87 250 145 227 104 139 57 5 240 195 179 9 255 253 119 127 227 247 63 222 231 126 171 224 217 160 164 159 41 186 180 142 138 160 73
	     13 245 49 34 30 65 142 99 130 46 236 225 188 40 130 192 198 27 195 48 76 0 48 12 227 67 33 148 56 41 73 4 86 106 17 87 214 98 174 46 123 26 114 156 108 201 189 15 21 194 76 233 79 18 55 123 234 37 85 162 238 113 22 24 78 115 254 118 183 195 159 191 127 198 221 39 135 4 151 208 88 94 197 215
	     98 148 104 230 172 205 13 241 139 93 125 52 62 85 170 246 36 18 35 145 67 52 194 17 152 228 41 157 222 144 233 120 74 191 95 146 23 194 244 214 42 219 203 49 235 141 200 42 163 92 224 126 134 211 57 21 114 96 92 64 127 60 161 61 73 185 191 95 240 63 255 248 51 255 249 95 254 202 143 119 238
	     147 105 76 88 222 64 227 101 88 89 193 225 81 20 21 135 170 154 8 104 24 134 97 2 128 97 24 207 91 92 74 8 1 113 74 179 158 112 101 173 198 214 74 131 70 228 159 115 203 223 143 145 235 158 51 41 229 69 182 166 105 4 151 223 159 58 241 235 201 149 255 69 99 95 168 86 247 122 5 220 123 54 225
	     209 238 62 63 220 219 231 160 51 38 184 26 26 213 200 143 234 1 44 182 200 215 55 240 229 13 182 231 202 25 27 113 85 206 227 248 152 3 114 1 77 231 92 110 231 171 223 112 30 87 253 88 128 212 89 153 184 32 17 248 58 147 50 240 228 176 79 112 208 159 76 249 234 250 26 191 185 189 206 74 116
	     178 20 221 185 4 1 249 184 158 150 158 186 168 55 185 188 179 238 93 9 252 212 205 249 235 15 143 248 238 222 83 238 63 29 240 253 131 103 60 220 29 48 146 38 234 98 32 6 113 85 31 157 231 2 145 69 33 89 95 209 183 79 10 136 250 202 28 1 106 253 220 48 12 19 0 12 195 248 160 21 0 202 188 64 226
	     192 230 234 18 159 223 220 224 218 230 42 126 182 247 127 177 6 187 97 92 76 139 59 54 205 231 230 121 90 194 238 184 228 105 43 231 47 63 30 240 224 201 83 246 219 125 226 90 147 230 234 42 37 17 229 108 47 175 28 109 37 48 163 219 120 23 45 243 216 141 21 4 23 213 104 172 196 104 153 51 156
	     76 184 191 219 163 59 206 232 143 11 124 236 185 181 85 103 167 17 33 34 159 168 38 41 23 122 148 12 24 167 57 189 52 231 94 63 231 127 252 245 41 191 255 243 29 254 244 253 61 122 221 62 227 180 128 250 10 181 237 77 2 142 160 66 41 2 170 168 134 147 9 30 223 184 29 200 107 182 21 195 48 12
	     19 0 12 195 248 32 140 54 65 81 138 60 71 35 88 95 89 225 179 235 87 184 182 189 68 35 246 23 108 222 25 198 241 158 255 197 253 254 37 112 56 10 252 227 126 151 135 187 61 126 124 120 64 127 148 147 106 13 168 225 72 8 71 171 140 240 190 54 165 24 159 58 238 56 71 133 120 130 64 33 161 74 16
	     216 157 82 106 139 90 20 152 12 86 169 125 190 206 234 82 237 104 207 250 185 35 1 62 81 230 251 252 253 25 2 64 171 132 191 221 221 231 15 119 30 241 143 199 109 254 124 103 143 131 206 152 39 251 163 74 41 244 9 80 67 168 225 4 116 230 176 171 185 230 134 97 24 38 0 24 134 113 62 119 76 41
	     113 226 88 94 170 113 101 189 206 106 61 194 159 50 163 94 84 231 218 12 92 227 117 145 5 39 96 90 4 14 39 129 251 79 199 220 185 191 199 110 171 195 96 148 146 36 75 196 205 26 224 8 58 119 168 102 241 2 98 173 206 120 215 67 163 28 141 119 138 64 169 32 142 122 179 137 132 146 178 152 50 154
	     102 220 127 220 34 155 100 212 18 199 205 27 107 236 36 17 62 114 39 2 207 173 181 190 216 49 47 102 127 207 139 64 30 74 218 211 130 239 118 135 252 247 127 255 153 255 242 111 127 225 225 211 3 122 99 197 175 175 83 91 93 163 16 71 41 209 76 58 16 74 93 24 85 94 18 17 116 34 241 168 229 5 48
	     12 195 48 1 192 48 62 70 3 75 206 241 234 42 63 114 32 18 165 158 56 54 86 18 182 215 35 154 206 204 86 227 226 89 92 249 47 129 113 161 220 223 155 112 231 105 159 39 123 61 238 62 105 49 206 50 210 224 17 60 222 197 168 10 65 195 169 246 104 109 211 120 215 44 10 0 243 191 56 68 28 42 66 33
	     49 69 94 176 219 77 25 79 149 128 242 184 53 224 63 124 182 201 206 213 53 214 163 74 174 10 214 90 159 155 159 22 163 127 114 160 173 112 119 119 196 253 221 93 254 126 127 143 159 30 116 185 243 96 159 63 223 57 160 28 14 64 106 80 83 168 121 36 138 65 252 204 145 191 248 231 125 242 108 229
	     29 222 5 27 199 12 195 48 1 192 48 140 11 112 174 158 75 186 182 144 184 76 78 101 210 211 80 162 4 34 129 90 18 211 172 215 104 212 29 126 110 85 233 204 4 146 119 228 122 189 34 148 64 206 107 167 25 31 140 241 191 152 248 47 45 3 187 189 140 59 143 186 252 248 240 128 222 120 74 26 148 164
	     177 132 104 85 194 75 67 168 246 252 159 217 96 78 29 255 148 55 32 23 28 37 160 231 202 55 96 43 139 239 106 120 120 223 247 126 222 124 230 5 2 9 213 128 168 82 34 40 181 40 66 124 3 71 78 22 148 199 123 3 14 58 35 68 149 178 158 208 88 175 147 248 79 39 18 224 117 174 173 4 66 168 146 207
	     246 75 229 201 80 249 151 239 246 248 215 63 254 141 127 220 185 71 119 92 82 248 90 181 226 191 182 70 161 17 226 227 42 179 63 10 33 204 62 80 206 253 236 95 182 234 175 231 25 43 228 237 155 155 16 158 123 159 90 52 147 97 24 38 0 24 134 241 126 76 235 0 26 32 100 36 137 163 177 218 224 234
	     149 85 54 55 150 168 123 103 174 140 241 78 28 57 63 51 254 139 162 228 193 254 144 191 61 234 241 253 253 14 15 118 251 213 70 20 23 209 136 18 156 143 9 250 177 187 76 198 7 217 150 21 196 9 34 14 212 147 151 194 180 200 25 140 83 66 200 17 39 76 10 197 125 181 197 245 157 21 150 162 136 136
	     153 64 251 9 181 104 229 249 100 159 110 214 255 7 165 178 219 30 113 208 237 243 253 179 33 15 15 83 254 199 159 239 241 135 239 238 210 127 182 7 196 176 190 1 245 6 81 45 198 139 167 44 171 21 255 35 65 230 13 43 128 24 134 97 24 38 0 24 198 167 99 188 46 216 74 85 165 164 18 66 137 119 142
	     70 173 206 202 242 50 181 90 29 117 243 236 255 182 131 213 184 24 71 32 44 76 52 1 104 143 51 30 238 246 217 221 235 49 26 79 193 123 226 40 198 225 65 222 44 185 159 216 74 154 113 161 227 165 158 28 254 156 156 240 108 231 142 168 72 132 143 164 106 182 165 99 50 45 120 252 184 197 102 2 205
	     149 58 205 149 232 196 97 222 95 57 213 95 190 207 207 69 0 191 120 27 129 113 17 248 241 97 159 127 220 253 153 63 252 248 132 214 40 231 209 254 16 21 193 109 237 16 240 144 212 192 71 148 193 29 85 246 83 177 249 200 48 12 195 4 0 195 48 222 204 89 66 145 80 18 242 148 68 60 59 155 117 110
	     223 88 99 123 173 134 119 102 96 25 23 231 8 200 204 1 200 20 40 149 199 221 49 63 63 237 241 215 187 45 158 28 14 24 23 80 186 24 31 37 120 137 56 85 146 219 48 46 169 64 48 115 70 197 207 242 2 84 34 84 111 146 210 238 12 1 165 76 106 132 47 182 185 190 90 71 28 36 124 26 57 1 244 148 16 48
	     85 200 11 165 51 154 240 180 155 113 247 233 128 255 242 239 223 243 195 221 251 252 253 231 199 76 66 32 144 160 201 18 52 87 17 137 170 99 136 160 42 11 225 251 54 48 24 134 97 152 0 96 24 159 146 43 245 220 30 196 147 127 112 156 90 229 127 206 96 154 173 236 11 56 17 66 89 146 79 51 180
	     240 52 235 176 190 30 177 82 23 68 102 201 218 222 245 138 170 233 12 31 53 97 161 93 206 219 93 123 90 114 127 111 196 131 221 30 173 222 152 73 30 80 159 224 92 124 34 73 197 162 185 63 95 245 155 255 179 40 207 101 255 146 151 56 33 111 222 32 205 217 184 244 78 230 115 57 79 94 247 145 235
	     139 15 54 31 47 95 217 214 20 102 201 1 113 142 160 142 82 60 157 81 206 157 71 109 26 62 98 233 219 29 182 234 254 120 156 254 208 134 192 215 40 253 162 11 125 254 168 36 162 192 227 20 254 114 103 159 63 253 248 136 251 187 29 254 250 211 83 6 195 9 19 34 74 17 130 175 225 162 104 118 12 89
	     152 227 206 167 8 190 48 203 191 202 11 186 186 190 221 61 120 163 219 232 78 53 82 155 4 13 195 48 1 192 48 140 115 91 32 242 22 62 181 130 6 28 129 36 82 150 106 194 214 154 103 103 201 177 226 205 245 49 46 166 165 206 219 98 169 80 134 192 147 126 202 207 207 134 252 249 206 33 251 173 62
	     253 73 73 225 98 162 184 142 72 196 201 20 129 207 55 236 69 199 194 48 46 166 28 233 249 156 49 57 215 49 28 226 226 42 105 101 221 211 207 75 250 15 122 164 211 0 137 231 183 55 55 216 89 142 40 16 106 84 123 225 253 71 208 199 23 197 140 121 15 78 169 146 252 141 138 130 20 248 121 111 202
	     239 126 60 224 95 254 248 61 255 246 151 31 233 247 251 76 39 5 186 180 2 205 117 60 174 74 250 41 50 75 138 167 167 142 248 182 92 38 113 207 156 126 195 48 76 0 48 12 227 125 155 30 161 250 95 228 132 164 22 179 210 172 177 82 139 104 248 227 36 109 134 241 182 142 217 145 0 32 208 25 100
	     220 123 218 227 222 211 30 79 15 251 140 38 5 165 68 136 75 80 137 64 28 58 43 245 119 162 226 132 84 255 59 138 8 152 101 1 51 19 218 184 156 238 176 175 190 69 142 188 200 41 178 130 131 206 136 31 238 238 146 132 156 250 151 87 88 174 215 78 56 204 31 132 75 40 207 95 237 162 92 39 11 47 19
	     160 6 116 69 248 254 113 151 7 251 7 252 233 206 1 127 191 219 230 238 179 22 143 91 19 40 20 52 1 226 89 244 79 116 212 207 245 188 14 250 169 200 12 19 173 13 195 48 76 0 48 12 227 5 150 92 8 37 162 5 141 216 177 186 186 194 181 237 117 214 155 13 188 154 91 101 188 189 27 164 11 191 228 33
	     240 184 63 229 254 227 46 127 187 123 200 65 119 204 104 154 83 250 24 137 102 43 255 58 203 238 45 242 74 103 72 205 249 55 46 187 167 44 81 21 229 237 29 81 29 166 101 198 221 251 135 100 163 9 206 59 190 190 181 205 118 195 83 32 196 31 138 0 112 134 163 189 40 2 148 84 69 101 10 13 4 133
	     39 131 140 71 7 35 254 159 127 249 129 63 125 255 35 63 222 127 70 103 164 20 181 101 164 177 12 46 2 28 42 66 16 55 75 252 41 103 141 34 134 97 24 134 9 0 134 241 9 27 150 250 118 123 7 117 182 60 19 138 128 150 57 174 22 177 182 220 100 115 125 149 229 70 157 104 22 95 109 97 214 31 186 11
	     46 231 248 219 155 25 253 188 164 5 46 174 6 42 213 190 223 126 42 220 123 54 226 231 39 93 30 60 237 146 150 74 17 60 226 35 156 143 171 61 177 33 188 176 201 115 116 60 125 105 203 215 11 187 119 198 7 52 34 158 145 243 228 77 31 249 197 180 42 85 230 97 43 136 120 36 142 201 243 130 201 40
	     167 12 67 86 31 118 113 113 131 230 103 171 212 99 57 26 107 3 213 214 240 163 224 247 183 84 4 78 215 188 127 23 21 50 252 169 159 15 28 220 125 60 162 213 235 242 167 159 247 120 186 55 224 119 127 123 192 79 15 159 209 233 244 128 24 86 155 208 104 224 162 8 21 95 237 15 146 179 198 167 115
	     156 239 121 175 73 94 52 38 26 134 97 152 0 96 24 198 165 231 98 92 243 64 0 13 68 94 88 91 169 179 177 218 164 81 139 95 215 252 50 46 45 225 245 141 233 11 150 31 10 85 90 169 242 96 127 202 79 143 7 236 30 142 24 101 37 46 138 137 107 117 32 154 57 41 225 213 215 17 4 103 45 210 56 163 85
	     191 125 171 112 239 168 255 85 43 218 130 7 23 227 106 13 50 133 7 123 35 212 181 104 196 158 219 59 77 214 99 127 226 34 46 115 133 0 93 56 199 48 19 59 188 40 121 128 86 6 223 31 76 248 127 254 237 30 247 30 220 231 143 63 60 96 154 150 116 199 5 19 98 162 205 171 4 241 224 107 4 17 194 145
	     232 39 239 201 41 15 214 97 12 195 48 76 0 48 140 79 213 104 86 66 8 104 81 144 68 53 118 54 27 92 223 90 98 165 238 79 100 167 254 20 106 85 127 188 110 209 251 95 221 58 253 137 163 28 238 239 141 249 238 238 33 63 61 108 49 205 51 114 34 98 23 227 124 4 234 159 91 165 52 131 221 248 240 209
	     89 103 8 71 18 133 248 8 151 52 200 203 146 189 110 70 90 180 105 212 28 133 110 240 171 43 75 52 27 241 137 213 244 203 56 238 206 37 13 168 86 251 29 48 18 24 76 74 238 239 30 242 199 199 125 238 60 232 243 255 251 227 29 158 238 238 115 240 116 31 196 67 173 9 141 38 81 189 129 243 158 50
	     204 238 207 188 239 203 251 112 254 13 195 48 12 19 0 12 227 147 243 9 79 186 245 18 64 130 82 143 133 141 149 132 173 37 79 44 85 68 229 137 144 90 83 0 204 157 57 50 212 229 165 206 255 60 67 127 169 144 5 56 232 231 60 124 210 225 201 211 67 186 131 17 81 173 134 175 37 179 100 127 16 142
	     222 113 90 176 176 77 254 198 199 35 6 84 85 236 28 234 18 160 160 44 82 70 147 148 39 123 93 164 12 212 69 185 181 179 202 106 226 47 180 221 95 84 200 255 60 70 39 44 136 0 243 36 177 237 81 201 159 239 182 249 215 63 252 149 127 249 199 125 14 7 5 247 15 70 100 1 100 109 163 218 222 227 18
	     136 99 10 60 18 100 54 191 232 209 54 9 195 48 12 195 4 0 195 48 222 161 49 138 42 162 74 236 149 164 94 99 125 181 201 198 74 66 125 182 180 99 107 174 198 155 50 119 14 166 1 158 246 75 190 187 215 230 251 187 187 28 116 6 100 37 120 137 136 226 26 170 186 176 242 47 47 113 59 88 120 141 57
	     10 198 7 140 120 156 8 234 132 160 37 105 153 242 244 96 200 104 152 18 69 14 141 107 124 189 221 164 238 46 215 58 248 98 146 63 128 49 144 21 129 39 221 49 131 172 224 111 63 181 249 183 63 223 229 15 127 255 129 191 221 125 76 192 131 212 96 105 9 191 180 130 34 213 223 16 80 57 71 191 55
	     12 195 48 76 0 48 12 227 229 230 217 153 121 171 94 96 92 9 104 81 2 74 226 133 213 70 131 149 149 37 162 40 58 225 106 205 13 191 15 170 68 149 113 10 119 210 137 62 221 38 228 92 173 235 220 111 89 108 55 211 82 121 114 56 224 167 7 207 216 59 236 67 20 19 215 35 16 127 28 93 34 14 180 82 157
	     170 133 202 217 17 158 11 11 54 140 95 192 95 63 213 95 84 206 227 150 191 40 201 156 156 120 133 247 30 13 49 211 44 163 40 166 60 109 141 89 93 207 217 92 81 174 52 132 248 2 147 255 189 42 10 64 85 171 179 59 245 186 211 242 219 124 52 73 131 242 160 147 242 223 255 112 159 159 31 62 227
	     199 7 251 220 223 237 210 25 77 8 201 50 16 33 62 65 125 66 169 139 179 200 233 217 68 207 127 27 193 118 7 24 134 97 152 0 96 24 198 139 45 163 23 36 180 82 65 80 40 75 148 140 102 51 97 103 107 149 157 141 53 106 73 66 201 113 70 103 11 251 255 104 220 152 11 58 140 188 178 5 10 144 161 100
	     10 63 31 76 248 199 221 125 30 62 107 51 76 11 86 234 203 212 227 58 33 40 65 231 78 137 123 87 103 107 24 151 116 136 174 194 222 157 139 145 200 83 230 129 113 145 241 180 61 70 162 54 245 90 2 215 27 108 55 32 145 247 151 131 101 241 115 22 103 147 0 20 192 184 8 244 179 130 80 150 252 245
	     96 200 63 238 30 242 127 255 175 31 249 238 206 3 246 90 109 66 16 252 218 58 201 234 22 85 89 63 79 121 180 197 103 126 84 243 224 13 195 48 76 0 48 12 227 2 157 60 125 229 191 11 224 20 10 45 208 144 19 251 58 43 205 37 86 150 151 73 106 254 200 0 52 39 204 120 93 191 102 113 125 115 191 55
	     226 135 159 246 120 244 180 195 164 20 36 170 17 156 71 212 17 208 106 79 176 46 22 244 83 212 182 252 27 159 212 120 13 56 143 70 49 160 244 199 25 225 217 1 27 203 158 237 213 27 92 105 68 39 28 243 119 29 133 117 218 61 159 111 184 153 11 194 237 81 198 159 126 120 200 65 171 203 159 30 31
	     242 120 127 204 157 71 7 236 15 82 130 70 224 99 74 170 47 153 253 23 100 118 100 243 251 13 195 48 76 0 48 12 227 130 141 201 163 229 27 125 165 145 39 162 72 40 65 75 146 8 54 86 235 108 172 198 212 35 179 211 62 69 31 228 162 4 128 28 72 128 206 40 231 199 123 45 254 241 211 19 14 122 57 113
	     163 137 115 49 42 142 160 58 147 161 228 204 182 102 237 207 248 36 208 153 28 43 224 163 4 231 98 178 108 196 65 183 207 253 71 142 205 149 37 214 150 182 216 106 86 130 109 34 39 179 239 159 171 123 191 78 8 151 200 81 222 151 130 234 179 74 133 134 84 191 223 237 142 249 243 247 79 249 191
	     255 229 7 238 63 121 202 247 143 15 200 74 97 162 117 124 163 9 205 53 130 68 168 84 251 252 85 22 197 61 147 245 12 195 48 76 0 48 12 227 2 189 183 151 236 239 62 237 248 87 118 30 78 160 12 5 69 54 193 201 50 171 171 142 141 85 142 18 79 45 134 130 154 233 246 105 56 253 47 219 231 47 175
	     112 254 231 255 30 80 122 147 156 187 143 186 220 127 220 161 221 159 50 45 28 222 197 72 84 67 53 160 234 78 56 29 194 241 94 229 69 135 69 231 251 134 245 29 40 22 134 113 94 63 93 222 68 146 210 215 124 149 71 157 162 120 138 224 56 232 142 248 254 238 46 75 117 165 254 205 58 27 81 244 94
	     134 133 232 148 17 216 19 184 219 45 249 233 222 67 254 112 255 41 63 61 232 240 239 223 63 228 217 65 135 110 123 88 69 46 44 37 184 154 67 125 2 46 170 114 119 232 169 43 212 23 204 77 175 186 183 166 6 26 134 97 152 0 96 24 198 91 120 120 71 142 213 204 178 10 1 167 129 90 84 178 210 84 86
	     92 181 122 91 216 13 52 222 192 213 113 64 63 205 121 188 219 231 187 187 7 236 181 199 184 164 78 45 142 16 241 104 144 42 236 127 225 157 114 46 135 222 156 126 227 35 238 63 11 78 110 28 215 136 189 39 43 83 238 63 222 167 30 229 108 172 199 44 95 91 163 54 27 155 147 119 112 14 129 227 18
	     127 49 85 36 143 2 143 6 240 223 255 178 199 127 249 151 63 241 251 239 127 102 26 34 250 147 130 92 18 162 141 109 112 142 224 19 116 230 248 107 8 103 95 216 209 222 2 89 232 206 86 103 198 48 12 195 4 0 195 48 222 210 225 63 239 114 73 32 16 136 188 144 184 152 149 102 194 74 77 168 153 171
	     245 73 59 240 111 242 158 249 30 225 18 200 75 216 235 228 252 244 172 199 189 39 29 6 147 2 73 26 68 174 134 226 81 149 217 130 190 5 6 27 54 98 35 179 45 48 11 229 240 156 139 112 113 68 54 46 24 142 6 220 127 218 101 231 65 135 229 90 141 219 107 9 222 185 231 170 179 92 4 110 193 37 239
	     100 37 63 236 118 104 77 38 252 237 222 132 255 246 167 7 252 254 207 247 216 123 124 0 141 37 164 190 132 212 234 184 122 3 69 102 167 63 251 254 210 36 30 214 219 13 195 48 76 0 48 12 227 23 49 61 67 25 64 74 234 113 196 122 115 133 173 213 101 26 81 116 100 4 58 187 73 214 74 206 225 252
	     47 38 239 27 21 74 119 164 60 220 155 176 215 153 50 156 22 100 42 68 82 173 254 7 78 151 82 155 125 63 165 62 168 90 204 175 241 105 245 179 211 217 246 9 224 188 39 105 52 72 11 207 207 15 58 212 188 167 246 171 45 174 173 54 159 235 131 231 117 171 23 223 19 102 95 158 227 4 127 0 221 18 254
	     241 160 195 255 245 63 254 192 157 135 79 185 119 152 242 184 51 165 159 149 200 198 21 212 37 104 148 160 62 34 168 127 13 255 222 156 127 195 48 12 19 0 12 195 248 197 204 205 16 2 65 74 150 234 9 59 155 75 236 108 174 211 76 146 247 86 106 202 248 184 90 84 25 132 246 168 228 222 211 1 63
	     222 111 113 208 27 147 139 135 200 83 201 73 178 224 234 232 11 220 18 195 248 116 120 241 88 43 168 6 36 138 168 249 101 138 60 227 241 94 31 39 176 181 209 96 169 217 100 61 58 118 222 245 13 250 235 252 187 159 137 0 131 18 246 251 99 210 105 202 31 239 143 248 203 143 247 248 207 255 250
	     61 119 238 63 101 146 6 52 169 225 215 182 112 235 171 132 32 85 36 15 156 82 239 94 124 38 34 179 200 159 231 148 67 177 254 111 24 134 97 2 128 97 24 239 131 160 74 208 64 45 169 177 190 186 204 250 234 10 245 216 186 253 39 214 10 22 126 126 189 152 143 197 98 19 65 32 5 246 187 5 247 31 183
	     120 240 116 159 105 9 165 139 17 247 252 202 255 241 39 134 23 184 39 38 65 25 159 58 130 226 65 28 57 57 69 86 208 234 79 120 186 63 97 115 37 39 222 138 137 253 241 202 253 75 133 219 51 114 240 45 150 245 235 3 223 237 77 249 95 127 248 153 251 143 158 242 215 123 187 236 119 250 236 118
	     70 140 164 142 36 2 113 141 66 35 164 88 116 215 195 41 73 225 117 199 28 172 175 27 134 97 152 0 96 24 198 235 243 6 171 39 2 33 4 74 45 137 35 199 218 106 147 181 149 58 137 55 99 236 83 109 55 242 154 177 31 139 171 143 99 85 246 250 25 247 31 181 121 186 223 161 63 154 86 251 254 147 58 200
	     172 164 196 169 234 229 39 138 255 201 25 210 130 242 10 71 193 86 13 141 15 205 165 63 163 23 190 116 187 139 67 5 196 199 184 56 102 90 6 30 239 246 168 197 49 137 223 98 107 61 34 241 199 101 251 252 107 156 75 63 40 121 90 208 75 83 254 222 73 249 253 95 118 249 175 255 239 29 190 191 251
	     136 131 189 61 212 123 146 181 13 154 155 107 4 241 148 56 66 128 160 1 17 169 74 23 206 207 93 222 230 102 232 171 111 148 242 102 175 49 12 195 48 76 0 48 12 227 216 118 210 178 164 212 130 196 11 27 171 13 54 87 60 117 247 114 99 213 48 158 115 229 5 58 163 140 31 127 222 227 206 131 3 14
	     251 83 130 75 240 46 65 197 35 226 102 37 193 244 40 200 96 238 252 155 205 110 24 47 27 165 171 47 145 4 23 5 166 121 198 195 221 22 101 158 178 220 112 36 141 29 86 154 149 24 231 206 232 163 71 253 84 22 143 86 253 253 113 55 227 111 119 30 243 221 221 7 252 245 225 33 15 246 166 220 219
	     31 208 238 77 32 36 16 197 76 67 2 33 194 57 95 245 218 170 86 103 229 252 159 247 42 196 102 18 195 48 12 19 0 12 195 184 4 166 101 149 254 201 163 212 98 71 179 225 168 251 147 187 49 45 16 219 120 153 243 63 119 48 166 165 178 123 56 226 193 147 3 14 90 29 66 210 164 190 180 4 18 17 112 11
	     177 201 179 85 125 209 215 47 88 97 24 159 104 63 67 65 156 35 241 117 52 87 70 147 17 251 237 130 39 123 43 172 111 108 176 154 68 36 81 85 189 229 172 254 57 255 61 0 148 202 180 40 216 75 3 191 255 113 159 255 246 111 63 242 187 191 125 207 131 221 54 185 175 17 26 43 212 215 86 201 54 174
	     160 42 136 130 58 57 42 25 171 72 165 38 176 160 44 156 247 122 44 177 167 97 24 134 9 0 134 97 252 66 102 165 22 32 16 33 212 226 152 229 102 204 90 211 29 25 144 44 8 0 198 199 142 188 213 59 38 1 158 118 115 126 126 54 228 105 107 66 111 82 16 123 197 39 30 61 74 252 247 50 79 223 90 153
	     97 188 114 204 22 65 197 81 138 39 13 158 222 68 121 180 63 164 182 212 162 81 91 229 214 102 3 55 43 39 184 40 224 206 163 2 10 96 191 128 131 189 49 223 61 122 194 15 15 15 249 219 79 135 252 245 206 99 238 63 233 80 140 83 42 5 88 33 118 136 115 40 14 149 153 122 55 79 246 161 47 235 203
	     239 115 156 50 49 193 48 12 195 4 0 195 48 206 105 70 41 170 1 2 68 145 208 172 39 52 106 9 145 51 71 204 156 255 215 118 75 232 77 75 30 31 142 57 104 167 228 18 19 215 155 56 23 29 189 66 206 202 248 175 28 103 16 127 237 79 124 249 217 155 91 96 92 114 87 254 205 222 161 16 170 80 0 106 141
	     101 18 7 163 84 121 182 215 225 234 154 231 234 74 13 146 42 3 192 98 90 62 167 144 163 244 3 60 104 41 127 250 169 197 255 250 253 29 126 184 247 152 131 222 132 65 26 72 214 214 113 27 158 64 132 74 132 138 160 97 86 36 80 222 190 87 189 209 202 191 158 234 233 106 189 221 48 12 195 4 0 195
	     48 222 144 0 161 64 28 52 146 136 181 149 58 235 203 13 154 177 191 32 183 208 248 4 90 16 14 40 2 236 118 51 126 124 112 200 189 167 109 210 66 209 184 134 186 24 57 177 250 111 24 198 219 171 7 130 184 8 137 29 133 42 173 209 148 52 207 216 88 77 216 222 92 101 105 219 83 147 202 112 83 96
	     28 96 183 55 226 238 94 155 199 157 49 223 63 202 248 243 157 199 252 249 135 251 236 239 30 162 165 64 189 129 214 155 184 184 86 69 25 204 245 6 21 219 3 102 24 134 97 2 128 97 24 151 214 46 156 89 109 175 74 182 36 4 68 181 122 189 66 156 68 52 235 9 181 122 173 202 212 110 24 175 33 0 228
	     10 253 81 78 171 211 99 48 28 19 37 77 124 84 59 181 45 248 120 149 110 177 125 218 126 96 195 56 31 139 253 38 168 67 69 16 74 202 80 50 205 3 189 97 198 126 47 103 103 171 70 205 207 199 122 24 10 124 255 168 199 255 250 227 63 184 243 248 144 135 135 25 207 186 35 166 89 73 188 178 70 166
	     14 92 130 248 184 218 174 163 122 220 91 205 249 55 12 195 48 1 192 48 140 143 192 144 68 102 17 157 57 162 208 168 213 216 218 88 101 99 101 153 56 246 118 131 140 151 50 207 229 23 128 17 129 135 135 41 247 159 180 217 239 12 24 167 5 75 137 39 242 49 26 130 221 44 195 120 141 126 181 232
	     119 191 248 133 90 141 224 226 170 168 248 168 78 70 201 179 110 138 254 124 72 70 224 214 213 37 18 114 14 186 19 254 244 160 195 191 255 233 71 126 247 151 31 185 247 180 69 154 22 148 18 195 242 26 36 77 212 199 128 175 194 235 85 171 253 255 103 109 217 185 116 119 201 48 12 195 48 1 192
	     48 62 117 199 126 97 133 232 204 85 86 169 28 127 209 80 25 122 33 224 156 146 68 142 70 189 65 163 81 35 242 188 102 21 120 227 83 115 82 230 237 67 129 206 56 229 225 179 14 123 135 125 130 58 146 164 138 34 169 130 75 228 5 254 139 94 248 57 25 198 135 223 175 142 199 105 152 249 225 207
	     57 254 80 73 111 130 226 16 31 81 143 99 156 83 70 101 206 131 189 54 133 83 58 185 48 25 15 249 243 119 63 241 135 239 31 176 123 208 165 55 44 72 93 141 162 86 67 93 132 248 8 21 55 235 203 186 240 129 167 156 127 189 68 119 201 38 38 195 48 12 19 0 12 195 120 67 177 128 0 101 1 82 210 172
	     193 230 90 194 218 18 120 51 176 140 87 56 42 5 144 0 195 34 240 104 119 200 143 247 246 120 118 56 36 72 76 189 17 163 226 8 170 102 171 27 198 107 9 0 243 177 249 164 223 45 167 70 110 36 170 146 184 138 80 132 106 11 78 89 4 250 189 62 189 94 155 31 118 91 108 60 234 114 208 27 240 215 63
	     253 133 214 253 199 132 122 29 183 190 129 54 215 241 226 81 87 21 128 21 21 84 21 145 96 66 154 97 24 134 97 2 128 97 124 208 6 229 169 85 86 157 215 94 159 173 51 137 66 89 22 4 41 73 124 201 218 138 176 218 168 58 123 0 108 35 128 181 157 35 199 99 182 34 57 111 81 197 236 123 111 44 28 116
	     114 90 157 33 195 209 148 184 185 130 68 241 108 229 95 142 222 49 143 70 177 253 254 134 241 98 78 68 109 205 187 157 30 247 59 69 136 156 195 197 241 44 87 139 146 166 25 253 225 144 225 104 200 254 97 139 94 191 71 16 33 126 218 101 152 101 236 117 51 144 6 248 58 144 128 68 56 231 65 132
	     160 225 56 218 192 110 191 97 24 134 97 2 128 97 124 244 110 30 14 240 34 212 99 97 181 9 77 57 222 219 109 2 128 113 166 147 2 148 65 233 165 240 224 217 152 39 7 99 198 89 32 72 85 47 220 178 254 27 198 5 226 168 246 230 75 21 242 159 139 32 101 32 15 129 73 94 57 255 123 173 22 253 94 143
	     86 183 71 154 23 132 80 64 187 143 122 143 111 46 81 46 173 207 186 164 32 104 85 30 80 79 186 253 38 205 25 134 97 24 38 0 24 198 71 238 252 139 40 145 119 52 18 97 169 30 209 168 201 81 217 40 75 221 102 188 92 5 80 14 187 41 63 63 58 228 241 126 143 113 233 32 170 161 248 89 122 73 19 0 140
	     79 121 116 61 163 203 188 193 81 20 193 33 72 228 143 246 235 79 243 146 209 100 74 111 56 164 221 31 208 31 142 105 119 187 164 89 202 120 154 17 202 42 183 11 101 1 113 140 212 107 72 28 87 231 84 150 167 206 109 30 165 163 111 125 182 175 190 19 54 38 24 134 97 152 0 96 24 198 47 102 158
	     106 8 56 160 145 196 44 47 121 150 106 49 14 121 193 158 83 227 83 116 88 22 255 126 194 77 80 200 242 64 171 211 101 247 160 69 119 52 133 40 33 242 17 34 81 149 68 252 200 230 159 165 23 179 208 127 227 163 230 212 136 41 103 180 119 149 115 246 186 121 215 17 84 229 40 145 102 161 74 25 74
	     250 147 41 7 157 46 7 135 109 14 58 93 210 52 39 205 51 36 242 184 164 142 211 74 58 8 48 219 38 224 160 40 170 72 130 51 63 87 95 208 243 95 81 74 246 21 93 90 69 95 251 152 134 97 24 134 9 0 134 97 188 11 103 79 1 45 17 167 44 53 98 214 87 27 172 44 53 168 57 57 114 244 204 76 51 78 187 7 243
	     228 127 33 64 171 87 178 123 56 98 191 221 103 144 66 109 169 137 143 146 170 113 169 156 16 13 12 227 83 148 3 194 139 229 129 87 188 217 33 2 206 71 179 36 127 37 89 158 211 31 13 24 76 83 90 253 33 173 238 128 254 96 200 96 56 154 13 232 128 243 224 60 206 87 227 184 155 245 191 176 216 129
	     95 41 245 189 209 25 159 99 244 184 200 99 26 134 97 24 38 0 24 134 241 26 198 88 181 12 20 66 64 157 146 36 142 229 70 66 163 86 195 57 51 208 140 153 169 46 103 239 13 206 3 140 167 129 195 78 206 112 90 130 56 156 171 86 25 181 202 75 142 136 46 172 118 158 74 68 169 250 220 241 13 227 147
	     87 11 230 153 254 212 161 78 112 222 129 115 32 144 102 5 131 209 132 189 195 14 173 222 255 159 189 255 254 142 36 89 238 124 193 143 185 71 68 10 168 210 93 85 221 213 221 213 90 92 173 72 222 123 73 142 32 71 236 219 61 187 251 118 255 210 253 97 207 59 103 222 190 153 121 195 225 80 95 14
	     175 150 173 74 66 164 214 17 225 182 63 68 100 34 145 208 40 160 10 194 62 231 160 27 64 165 66 184 185 135 217 215 205 205 186 52 123 125 134 227 148 28 65 42 201 118 193 205 89 161 205 249 100 3 217 126 125 195 48 12 195 48 1 192 48 174 98 96 7 33 20 169 164 78 96 169 94 225 214 218 42 215
	     215 150 136 157 155 237 254 91 120 102 236 197 40 203 121 188 53 224 183 95 110 241 124 179 79 22 4 137 34 138 146 145 211 61 71 11 54 12 227 40 76 55 229 213 57 92 228 81 138 182 126 163 113 198 48 29 49 78 39 180 186 93 186 189 1 235 91 13 154 221 62 227 113 90 60 57 174 128 119 72 89 209
	     95 231 58 188 204 41 11 54 31 13 195 48 12 19 0 12 227 10 135 255 179 221 32 45 219 63 69 81 76 181 146 80 141 99 188 184 153 187 40 187 221 212 221 175 101 92 38 203 56 210 99 2 129 86 167 203 102 163 65 127 52 194 249 136 136 8 132 194 166 166 182 178 207 1 97 219 249 55 46 113 40 191 227
	     71 217 231 49 219 97 185 22 173 248 80 156 119 68 149 4 196 147 142 39 140 134 25 155 141 38 157 193 144 70 187 195 120 50 97 48 158 16 4 36 142 138 93 127 39 32 110 46 179 255 40 103 251 143 186 158 31 62 79 85 142 187 170 236 241 243 158 31 197 4 11 195 48 12 19 0 12 195 56 101 87 53 16 66
	     142 83 207 114 37 225 218 106 157 213 90 76 236 182 221 52 61 208 105 180 32 238 170 133 54 74 145 254 191 209 153 240 104 189 197 211 205 22 195 92 32 94 33 242 9 97 26 208 216 201 127 195 56 112 149 12 148 217 250 206 205 142 239 79 114 101 60 28 51 206 50 90 221 33 173 78 135 39 27 155 116
	     251 35 186 189 126 89 208 79 192 123 136 139 86 155 59 235 106 234 9 102 245 252 39 149 151 124 21 246 251 119 235 63 99 24 134 97 2 128 97 24 167 19 194 237 242 179 20 52 16 71 66 181 18 81 137 231 138 68 27 198 30 110 249 56 64 119 224 232 143 2 227 44 39 215 8 63 23 60 136 204 190 59 180
	     234 255 142 26 3 214 33 192 184 2 98 192 84 72 83 1 113 142 40 142 16 231 17 39 244 70 19 58 189 62 205 118 135 245 102 155 193 104 76 171 219 103 156 101 228 211 87 16 55 85 14 230 98 103 177 121 101 24 134 97 152 0 96 24 198 62 34 192 180 8 96 249 173 71 168 38 142 229 165 136 106 100 2 128
	     177 127 240 210 207 224 241 86 198 231 143 251 108 245 2 25 49 193 249 50 224 176 190 17 134 113 224 234 43 82 86 228 215 162 178 191 42 89 22 200 53 35 11 208 236 244 120 182 190 201 198 230 22 91 221 14 25 142 44 15 16 249 50 229 223 23 115 204 97 115 205 48 12 195 48 1 192 48 140 237 16 127
	     167 111 56 237 32 189 221 205 125 214 17 42 40 34 16 199 80 173 200 174 224 95 14 248 201 28 208 171 39 0 164 121 206 243 70 135 71 207 154 180 7 41 234 226 217 142 228 118 193 127 61 114 34 178 237 78 26 7 175 93 23 251 40 184 204 205 7 21 193 149 69 254 34 31 225 188 103 56 73 25 141 199 52
	     218 109 250 131 49 91 237 46 91 205 54 253 97 159 193 36 5 23 149 187 253 130 200 180 192 38 59 50 247 103 211 78 142 59 175 206 203 122 174 231 232 86 162 251 255 106 154 85 49 189 182 199 169 99 34 135 189 149 236 211 129 81 15 126 204 124 177 213 3 62 207 98 205 21 91 119 95 116 188 246 250
	     247 61 158 116 132 197 75 102 93 59 108 76 12 19 0 12 195 56 69 55 70 246 188 123 5 32 16 71 142 74 18 81 73 28 73 172 71 240 195 44 232 191 170 4 160 59 24 241 248 217 38 143 215 183 24 5 144 56 65 112 101 17 50 45 31 101 253 35 140 211 9 191 228 50 252 61 82 182 228 83 200 84 139 99 87 162
	     136 4 58 131 17 141 118 151 175 158 62 167 209 234 48 24 142 73 243 12 245 30 87 169 1 190 140 251 138 236 154 211 191 30 114 78 71 254 188 125 150 151 113 157 142 82 7 97 186 182 90 151 149 243 57 219 221 57 182 107 195 48 1 192 48 174 248 125 170 40 213 230 80 92 236 169 36 49 73 20 225 45
	     247 223 216 39 240 119 83 1 96 4 91 237 33 173 110 31 146 42 149 122 13 144 57 87 85 47 73 232 102 24 39 140 225 180 60 12 83 126 239 124 68 20 23 153 50 227 60 99 48 154 208 29 118 201 242 140 245 86 151 86 175 207 179 173 38 189 222 0 242 28 156 7 31 227 188 223 158 71 33 216 156 122 37 34
	     128 204 117 107 56 135 133 77 205 36 94 254 37 127 129 29 123 219 237 55 76 0 48 12 227 37 83 246 102 87 45 156 73 9 120 7 213 40 102 169 94 165 18 199 219 145 158 97 44 8 0 10 116 39 208 232 228 12 82 37 32 8 142 160 190 116 66 173 106 183 97 76 247 101 3 69 246 175 136 16 68 240 190 72 229
	     31 14 71 52 218 29 30 175 111 48 24 14 217 234 246 153 4 101 148 229 16 121 136 226 66 57 40 59 3 104 153 30 47 22 233 189 194 91 167 99 223 86 133 175 84 156 48 46 207 170 97 243 219 48 1 192 48 140 83 71 102 185 168 14 200 53 160 33 197 71 158 149 122 149 107 43 203 212 171 85 164 172 13 96
	     183 34 99 209 45 25 168 242 188 61 225 217 102 143 225 56 67 162 8 113 17 51 97 105 135 213 152 5 25 39 94 169 46 120 120 227 16 47 196 206 21 57 86 162 140 179 156 94 119 192 112 60 98 171 217 46 91 251 109 48 24 142 24 141 39 224 227 162 8 139 159 206 169 233 153 129 242 130 4 11 248 94 141
	     37 78 255 191 88 148 226 184 45 13 143 250 126 178 203 150 142 214 166 81 14 21 6 108 199 249 56 99 126 210 199 237 53 62 114 128 93 233 220 216 216 248 24 38 0 24 134 113 26 183 49 221 231 22 52 205 40 205 3 62 114 44 213 18 86 86 234 84 107 21 188 88 224 102 81 255 220 183 101 59 191 34 245
	     127 194 147 141 22 235 91 77 198 227 140 200 39 232 172 64 89 105 88 106 2 128 113 152 163 172 39 95 187 78 219 212 231 131 34 145 23 56 189 91 22 189 148 105 27 76 71 20 197 228 34 164 65 233 14 135 108 52 154 108 53 91 108 181 59 164 121 70 127 146 145 33 16 39 69 202 191 184 185 160 96 46
	     144 208 233 92 180 0 225 229 7 254 211 1 216 71 22 159 21 3 116 11 226 192 30 143 151 35 188 175 28 54 127 246 121 140 50 247 158 102 39 39 30 243 121 255 231 128 241 210 253 252 36 145 67 215 192 221 207 213 178 120 160 141 155 97 2 128 97 24 103 228 122 239 184 233 132 156 72 60 203 181 132
	     181 149 58 75 181 100 87 165 96 227 106 51 127 34 164 61 152 240 232 217 38 79 55 182 24 165 158 40 169 18 240 59 213 2 195 56 243 181 235 28 126 94 113 224 4 69 16 132 44 15 164 249 152 238 120 204 96 146 177 222 108 243 116 125 131 70 179 205 112 56 132 56 2 231 17 31 227 98 63 43 240 135
	     238 78 51 63 124 111 215 56 91 11 148 50 206 215 131 239 167 83 65 32 132 237 138 143 47 3 45 4 8 113 14 41 91 76 218 82 124 220 107 56 29 179 112 178 113 59 209 36 45 231 188 115 179 46 58 134 97 2 128 97 24 167 224 148 110 23 155 209 217 9 82 45 186 210 4 69 66 142 23 165 82 137 169 87 19 146
	     88 236 30 100 236 112 79 230 253 153 113 158 211 104 247 104 182 251 104 92 39 170 57 36 8 135 250 198 134 113 1 2 61 57 230 220 0 69 181 8 254 157 139 112 145 47 119 247 132 73 127 64 167 223 227 217 86 147 118 127 72 123 48 162 53 24 48 9 1 188 135 178 157 159 178 45 26 176 35 112 83 108 195
	     255 188 216 198 161 189 223 10 145 84 64 179 20 210 20 242 12 52 231 120 5 81 143 211 121 96 42 24 149 207 137 98 36 169 225 162 164 172 215 18 78 96 213 87 109 108 21 164 152 121 18 50 52 77 33 75 33 100 236 213 67 233 96 95 171 28 149 29 55 195 131 82 8 74 177 193 121 136 43 104 156 128 139
	     103 159 201 48 76 0 48 12 227 12 238 125 90 212 108 87 69 68 73 34 71 53 241 196 177 221 123 140 157 78 205 212 149 25 40 116 122 25 189 97 198 40 85 226 168 76 81 22 94 222 78 151 97 156 129 141 159 68 0 0 8 229 238 157 138 43 26 170 102 57 163 52 35 228 202 86 187 69 163 213 228 241 243 13
	     186 253 33 227 32 228 34 248 216 227 226 184 20 101 93 249 166 115 105 221 179 185 100 115 234 213 115 148 49 40 170 230 136 102 136 42 62 2 31 199 68 226 113 26 112 132 178 170 142 158 250 39 43 234 75 56 112 142 60 8 89 8 100 97 2 148 153 0 118 51 63 92 4 80 69 200 137 36 224 43 16 87 35 60
	     14 199 241 230 225 113 43 251 107 249 254 1 207 68 60 169 42 89 200 203 215 176 108 0 195 4 0 195 48 206 204 183 9 160 25 94 3 73 228 72 42 142 200 219 101 49 118 51 1 58 67 104 245 2 163 180 8 124 66 185 131 185 243 204 178 97 156 125 40 38 47 240 152 221 158 251 66 193 139 131 195 133 194
	     193 23 16 231 240 206 227 227 4 21 199 104 146 209 31 12 216 106 181 25 142 38 108 180 90 244 7 125 58 131 49 195 52 47 82 124 189 35 47 159 191 125 222 223 56 159 22 117 88 32 55 159 57 162 132 44 35 18 101 185 94 97 109 169 206 218 82 133 136 64 226 242 217 189 246 104 150 41 135 124 134 105
	     238 73 33 45 72 165 14 190 74 183 55 226 249 230 22 173 110 31 149 8 23 87 103 157 91 140 3 46 117 158 35 33 165 146 56 174 47 85 185 177 156 80 113 142 200 21 227 186 111 113 190 89 237 135 178 230 199 44 191 82 247 125 204 116 252 4 69 157 199 197 21 70 153 163 209 29 210 232 141 232 140 139
	     117 34 15 161 88 31 84 108 137 48 76 0 48 12 227 4 46 206 156 26 189 187 8 96 113 86 209 17 136 124 32 246 224 237 102 99 236 50 22 165 63 17 214 155 25 205 86 70 208 152 184 82 195 249 104 193 193 52 87 211 56 44 208 58 249 43 44 198 230 139 233 241 71 121 204 222 193 255 188 5 43 7 245 64 213
	     217 215 118 113 62 1 50 13 116 71 69 107 191 39 207 55 232 244 135 180 122 125 2 10 46 34 174 250 237 125 96 17 84 101 87 80 176 215 198 225 97 231 184 229 4 207 49 96 239 118 165 115 1 253 30 65 159 238 83 156 79 68 113 170 100 249 4 231 225 90 125 133 183 94 191 205 91 119 175 83 17 88 242
	     121 145 82 30 178 237 58 15 7 46 188 114 200 103 45 5 0 241 228 8 81 109 13 169 44 243 213 211 77 38 131 14 205 173 33 42 49 62 169 16 116 46 195 196 214 231 189 175 119 8 104 158 82 173 212 120 227 206 26 239 221 187 201 82 53 166 234 203 130 160 33 160 186 91 74 153 250 86 7 213 76 218 251
	     49 69 109 8 137 34 42 245 101 90 195 192 111 31 173 147 63 218 160 63 234 131 8 121 8 101 246 157 137 132 134 9 0 134 97 156 114 124 167 40 33 207 64 51 170 177 178 82 131 4 219 207 53 118 226 16 250 227 156 103 27 93 158 111 13 24 103 14 31 87 138 51 204 42 102 41 198 37 151 46 202 234 41 34
	     136 8 113 28 161 226 200 131 210 27 141 25 244 7 244 71 99 54 219 93 218 221 62 155 141 22 189 209 152 124 146 66 228 113 113 2 190 112 228 45 4 187 156 247 82 209 0 147 49 46 130 107 171 117 62 122 247 117 190 247 225 93 234 62 176 230 66 81 11 160 20 0 116 97 189 148 133 213 118 167 237 177
	     199 241 129 226 251 32 158 12 161 86 93 38 170 45 241 207 191 241 60 250 226 55 252 97 60 0 87 221 110 68 96 28 60 120 89 6 147 9 75 149 101 222 189 127 155 63 249 250 67 110 46 71 44 199 224 129 16 230 179 0 230 246 247 23 131 123 221 67 40 218 35 3 64 74 43 136 92 68 125 105 137 103 157 9 113
	     12 141 118 143 103 141 1 34 211 66 132 222 110 173 134 9 0 134 97 156 182 103 91 168 208 129 0 18 168 38 80 79 10 1 32 51 191 193 96 167 8 52 28 143 104 180 218 180 58 93 210 60 224 189 71 157 237 78 24 151 219 254 119 52 127 43 139 253 73 84 65 4 198 147 9 173 94 159 231 155 77 26 157 14 205
	     94 159 60 20 133 50 197 57 164 82 1 87 20 5 212 61 66 61 227 114 196 143 51 210 9 34 66 189 86 229 254 107 55 248 232 189 235 172 72 206 245 210 120 180 12 30 15 22 0 216 67 0 216 251 95 114 132 20 88 117 158 56 241 116 122 49 75 53 208 60 131 60 157 203 110 49 187 219 127 244 28 132 128 132
	     148 106 228 185 125 253 26 239 189 117 143 123 107 202 74 4 49 144 239 41 191 188 168 0 0 49 194 245 74 204 103 173 33 159 109 44 179 84 171 226 156 148 5 154 3 56 61 40 25 201 48 76 0 48 12 227 152 55 61 13 179 155 84 28 69 84 171 17 181 138 80 17 44 225 204 216 69 0 250 195 9 155 141 22 173
	     118 151 16 85 144 40 217 229 200 26 198 75 11 182 94 224 49 7 61 119 241 56 139 120 135 243 17 148 231 173 39 89 96 60 28 209 27 14 233 246 7 60 223 106 242 124 115 139 118 167 203 120 156 66 20 65 28 227 196 33 145 167 40 242 181 95 16 54 149 5 246 56 59 124 2 177 194 56 206 213 58 13 107 146
	     178 152 110 249 154 121 134 4 161 86 137 184 121 173 206 131 101 199 50 142 149 67 198 234 248 2 192 246 191 43 197 46 181 3 238 173 56 234 21 45 130 127 252 92 230 128 173 211 7 146 7 200 51 98 47 172 46 87 185 119 51 230 65 29 234 28 173 50 132 28 115 46 206 103 88 122 224 246 74 133 219 215
	     170 212 18 95 4 255 82 220 116 45 129 195 48 1 192 48 140 83 118 127 148 16 2 206 57 146 106 133 229 90 157 36 138 119 220 160 204 101 48 166 164 10 131 81 96 48 28 51 26 167 120 87 33 114 81 185 187 17 204 98 44 52 95 248 73 79 61 56 149 35 188 144 156 194 155 233 220 26 9 224 157 195 197 9 65
	     28 162 194 112 216 163 217 234 240 100 99 131 118 175 207 96 146 50 28 143 73 113 104 20 23 169 254 34 132 178 181 88 216 241 194 139 133 192 202 207 45 39 191 78 106 81 194 169 216 236 238 235 122 132 245 108 71 251 8 41 235 65 40 46 4 200 243 29 1 250 65 115 225 184 237 227 167 143 15 20 187
	     211 211 77 226 16 64 242 128 211 64 46 69 161 57 91 150 15 185 144 101 150 132 104 241 165 33 47 78 107 148 157 248 252 220 28 150 179 178 60 85 200 115 92 8 56 180 232 44 82 182 5 181 233 109 152 0 96 24 198 233 138 0 26 136 68 168 38 49 181 106 66 236 45 215 204 216 118 44 221 220 255 187
	     3 165 211 207 24 77 114 50 45 182 40 252 172 63 160 185 39 198 69 94 8 183 61 114 5 196 77 207 250 199 128 144 43 12 71 19 250 227 148 73 30 104 52 219 60 223 216 228 233 250 38 163 209 24 141 34 196 123 136 98 92 34 51 127 190 40 244 199 92 149 190 197 157 216 83 116 237 221 62 42 134 113 162
	     224 255 196 207 47 15 221 107 200 200 198 25 163 0 137 219 89 194 239 52 5 128 156 162 59 203 84 186 159 100 138 102 193 2 255 19 9 1 130 106 32 159 164 164 35 101 92 19 234 209 246 125 240 224 210 160 39 120 187 185 239 243 44 103 50 78 33 228 229 187 217 217 127 195 4 0 195 48 206 208 241
	     117 148 233 131 2 78 44 161 219 96 71 85 255 28 152 100 208 106 79 104 119 71 164 185 130 247 136 184 133 232 195 34 14 227 98 71 0 161 180 97 39 30 241 69 107 63 16 58 253 62 27 205 54 27 141 38 189 113 74 103 48 162 219 239 211 159 100 69 155 46 145 237 175 83 95 65 23 95 51 216 80 157 203
	     91 233 52 19 170 88 61 29 57 34 161 56 194 93 118 115 59 171 123 235 188 35 94 220 199 45 118 60 41 142 162 35 146 39 16 225 241 108 167 233 159 166 0 176 107 150 203 180 251 146 46 204 115 187 175 26 38 0 24 134 113 58 49 127 113 123 81 240 26 112 162 36 81 68 37 142 240 222 219 5 50 118 138
	     1 10 157 81 198 102 171 79 183 55 66 113 196 113 92 8 0 234 96 86 214 202 92 78 227 162 174 137 69 240 174 174 8 184 243 178 186 191 142 39 140 211 156 141 70 139 167 207 215 121 190 185 201 96 148 146 162 40 197 177 0 34 95 164 251 79 87 214 160 211 72 226 136 71 175 139 29 227 48 43 20 182
	     199 191 235 194 207 123 244 253 147 133 39 170 5 14 103 202 142 35 27 170 168 232 76 171 153 214 3 112 101 3 183 99 221 152 231 205 226 72 1 235 81 30 90 116 174 80 132 61 251 76 94 237 145 220 121 5 117 91 200 17 252 174 124 157 151 229 159 109 255 100 227 101 152 0 96 24 198 105 222 243 52
	     16 66 134 79 96 117 185 198 245 213 21 106 73 213 194 56 99 135 179 19 128 254 120 66 179 215 167 59 24 145 41 136 139 64 188 185 38 198 69 138 242 119 58 211 82 20 66 157 237 224 123 79 20 199 4 32 203 149 110 175 79 179 211 161 217 238 177 222 108 211 233 118 233 15 71 132 60 47 158 227 139
	     45 59 65 119 251 233 114 112 176 255 34 33 129 113 113 215 210 139 250 250 198 73 231 170 141 140 97 2 128 97 24 231 205 25 81 37 4 197 121 161 86 171 176 92 175 83 137 227 67 171 14 27 87 205 149 81 198 227 9 189 193 136 193 56 37 168 32 206 161 110 86 247 218 108 197 56 81 160 170 139 45 180
	     246 90 175 68 118 60 246 248 245 182 167 143 218 126 156 155 10 0 56 130 19 84 28 33 4 242 60 144 5 101 56 156 176 213 234 240 100 125 131 141 173 6 189 225 16 197 227 226 10 146 72 89 28 206 21 113 127 152 143 254 15 201 189 222 99 231 94 143 114 93 229 232 215 210 120 73 214 174 7 5 123 115
	     187 202 71 61 21 34 39 159 117 71 177 33 179 143 227 120 72 219 131 182 216 250 79 246 141 245 245 133 5 0 149 242 203 238 169 134 9 0 134 97 156 253 237 78 136 156 16 121 193 59 177 27 143 177 195 191 81 129 238 96 192 211 141 38 155 205 1 169 36 248 40 41 170 20 155 79 105 188 50 39 253 56
	     193 255 206 255 7 231 112 222 227 35 15 42 164 33 208 27 14 233 183 123 180 123 125 58 253 33 237 110 143 205 118 135 126 183 15 121 94 120 59 62 66 100 62 157 250 100 194 135 97 24 134 97 152 0 96 24 198 43 10 253 5 13 74 150 101 100 233 132 16 114 100 126 90 235 220 233 110 49 105 224 170
	     16 118 4 77 194 120 146 209 31 12 25 140 70 184 106 92 4 65 186 208 246 109 215 78 173 97 28 178 2 29 97 77 217 207 158 102 103 176 245 240 224 127 167 169 22 193 187 138 67 124 4 65 201 178 156 254 96 204 122 163 193 122 179 65 183 63 100 18 148 92 33 170 86 201 69 80 117 69 224 47 211 230
	     125 186 59 163 223 154 168 24 134 241 130 232 124 18 194 116 141 49 247 203 48 1 192 48 140 23 15 253 11 199 90 243 128 23 79 173 154 176 84 175 80 77 28 174 188 217 216 253 230 138 59 33 64 6 244 39 208 25 228 116 7 41 163 73 70 181 42 68 62 66 131 108 23 46 59 165 247 155 183 79 195 56 77 227
	     18 239 139 163 43 56 50 85 70 89 198 120 56 162 63 24 209 29 141 105 181 219 172 55 26 108 181 59 228 163 49 26 197 16 39 136 143 16 241 229 154 185 104 169 134 113 150 43 240 105 172 136 58 247 101 43 235 217 123 86 134 97 2 128 97 24 231 210 173 40 100 101 37 144 231 57 78 34 150 106 117 86
	     87 150 72 146 104 182 91 86 182 197 5 171 10 112 229 112 101 240 159 1 253 49 140 243 8 113 49 62 202 138 93 208 48 221 153 221 182 137 23 217 249 87 217 231 72 165 113 41 194 151 211 127 101 61 210 206 255 182 33 9 222 121 124 28 17 156 39 207 2 195 225 132 141 102 139 70 163 67 119 56 96 56
	     153 48 24 142 139 2 127 149 10 136 47 190 71 118 216 246 212 46 103 89 5 243 89 12 102 179 198 41 218 248 206 159 221 11 188 142 98 21 229 207 58 214 55 255 200 48 1 192 48 140 139 224 98 168 18 52 71 28 212 107 9 43 245 10 149 35 183 174 50 46 187 111 163 64 39 133 205 86 78 123 8 234 34 124
	     148 128 68 102 32 198 5 176 97 65 61 69 16 175 144 6 24 14 39 12 179 140 238 104 196 102 179 195 211 245 77 154 173 14 227 209 24 245 229 185 254 200 67 148 148 177 82 249 59 179 120 227 66 139 9 1 59 159 98 24 134 9 0 134 97 20 46 109 185 123 21 66 78 158 155 147 96 108 19 128 201 4 6 195 156
	     209 36 39 224 192 21 61 207 167 149 33 196 118 148 140 23 9 77 202 157 117 231 220 142 159 95 36 212 65 139 179 249 222 123 136 29 145 175 0 48 24 141 105 245 250 108 52 155 52 187 125 58 131 33 237 110 159 113 158 147 185 114 45 20 7 206 21 235 224 201 154 13 24 134 97 24 134 9 0 134 97 156
	     83 231 123 166 3 40 34 1 39 1 103 2 128 81 146 7 165 219 157 176 213 238 209 29 140 201 16 240 81 217 2 205 48 94 197 138 37 7 254 107 209 154 178 248 74 69 201 179 128 78 198 76 242 156 70 171 195 179 205 77 158 109 110 210 234 13 200 115 37 0 196 49 226 124 97 215 114 212 158 109 134 113 81
	     48 155 62 31 158 150 141 129 97 2 128 97 24 175 212 31 40 118 200 84 33 168 226 28 84 107 158 106 205 227 96 71 13 0 43 65 123 117 93 70 13 208 27 77 232 246 250 12 70 41 57 101 21 116 220 174 14 0 134 113 34 59 91 232 28 177 253 243 156 227 188 216 120 91 183 91 149 206 50 6 68 192 57 162 56
	     198 69 17 170 48 202 210 98 215 191 213 165 221 235 179 209 108 211 238 247 233 15 70 140 39 89 249 156 178 184 159 19 182 179 159 164 48 254 249 201 128 20 2 129 46 22 102 179 180 0 227 204 86 224 133 159 247 10 44 15 187 63 79 131 127 103 54 251 202 130 127 43 111 107 152 0 96 24 198 121 242
	     47 8 132 16 240 30 234 245 136 122 34 251 220 158 44 43 224 42 146 107 160 63 28 210 238 245 232 15 71 132 32 224 61 98 246 96 188 52 194 190 110 181 108 171 8 4 231 138 66 146 33 16 178 192 36 203 104 247 135 116 186 29 30 63 219 96 179 217 98 208 31 22 143 139 34 92 165 90 28 101 145 61 170
	     79 30 24 32 185 35 62 206 48 94 20 119 196 249 113 88 80 185 40 2 24 47 87 0 48 12 19 0 12 195 56 119 247 39 69 84 73 34 72 236 106 24 243 166 17 148 193 96 72 171 219 167 63 154 16 92 117 86 3 192 178 66 140 87 41 9 76 119 237 35 23 225 162 136 32 66 154 101 244 135 99 218 131 22 157 193 144
	     102 183 207 96 56 100 163 209 162 215 239 67 22 32 142 11 175 197 71 69 56 180 184 169 111 24 134 113 106 88 198 133 97 2 128 97 24 231 38 178 43 79 1 104 185 55 160 32 193 194 57 99 151 153 144 166 57 163 113 74 154 229 72 226 112 114 54 187 72 139 45 255 204 22 175 168 205 237 19 141 207 39
	     210 106 121 78 63 0 226 60 226 60 89 174 244 70 25 155 173 14 207 54 54 104 118 123 116 251 67 114 132 73 174 184 164 138 86 203 29 255 114 39 116 254 148 193 110 131 148 189 63 132 97 188 196 245 215 214 196 139 62 128 178 115 4 109 16 13 19 0 12 195 120 213 20 167 185 153 125 25 198 124 185
	     162 76 149 113 150 49 158 100 164 153 146 36 128 56 84 67 89 253 95 78 217 30 13 227 96 11 17 231 113 206 163 56 84 149 126 154 49 233 143 232 246 7 52 186 61 26 173 22 27 141 6 253 225 144 108 156 65 20 67 20 227 162 24 137 92 177 219 95 138 12 22 207 27 214 234 193 120 249 54 102 24 38 0 24
	     134 241 146 195 187 178 233 31 130 148 91 255 130 120 193 205 137 211 118 187 186 186 129 255 124 88 159 43 228 42 219 59 165 58 253 159 219 254 5 50 43 220 86 252 187 162 251 248 212 102 87 230 6 239 183 34 237 31 128 201 124 248 143 56 143 143 34 82 132 60 203 233 14 70 52 218 109 54 154 45
	     218 157 62 195 201 152 97 154 129 143 161 18 131 119 133 104 5 16 94 48 184 91 76 83 57 82 176 168 22 16 156 119 171 220 85 163 77 79 254 26 58 61 111 175 47 44 38 200 145 31 113 28 123 42 142 252 49 255 113 205 38 45 238 55 12 19 0 12 227 42 132 122 138 42 68 206 17 215 18 234 213 42 145 247
	     182 247 97 204 4 128 12 232 143 97 146 130 78 69 128 99 180 72 91 180 37 203 48 49 78 100 143 206 205 236 78 81 38 105 32 159 140 232 12 39 12 38 99 214 27 13 54 91 109 154 237 30 195 225 8 92 209 13 64 92 130 36 130 34 219 217 42 167 146 180 162 167 240 28 139 12 46 111 164 55 47 0 156 215
	     40 211 86 103 195 48 76 0 48 140 171 231 84 107 113 214 214 57 79 53 174 82 175 85 241 145 183 11 99 110 236 108 111 127 162 48 25 65 200 75 201 72 166 193 84 145 45 178 109 75 186 239 185 237 23 117 99 77 144 186 196 107 208 30 6 176 104 70 34 130 247 174 40 216 39 158 44 4 198 227 33 253 209
	     136 231 91 13 218 253 62 141 110 143 193 104 66 26 2 248 178 64 165 184 237 157 77 217 43 203 192 48 166 132 133 122 15 182 234 24 231 107 165 84 81 116 166 94 138 217 169 97 2 128 97 24 39 21 0 138 160 45 118 66 181 82 161 86 173 18 249 200 110 41 198 108 247 127 48 86 186 189 148 209 36 47
	     142 137 56 153 115 64 130 93 40 227 212 5 129 34 104 151 89 151 137 160 66 154 43 89 158 146 230 19 38 227 140 173 86 139 118 175 207 211 205 13 58 253 1 227 73 90 20 246 139 43 72 156 148 193 190 21 219 50 142 107 125 134 113 110 37 128 61 142 31 25 134 9 0 134 97 28 43 188 163 236 2 160 115
	     157 0 196 220 160 171 30 124 49 183 183 160 48 158 228 12 70 99 38 89 0 113 56 39 51 59 57 204 198 100 97 43 87 142 99 155 230 152 191 204 149 224 196 87 122 186 195 62 159 253 113 152 133 236 200 20 41 119 93 165 60 142 4 10 174 56 175 239 35 143 143 18 66 80 134 227 9 131 97 159 70 167 71 127
	     56 98 171 217 97 56 158 208 27 12 25 103 57 97 154 183 162 229 107 202 121 191 210 166 76 188 248 53 60 137 213 78 197 203 50 199 233 168 195 160 7 252 82 96 90 66 119 26 164 229 120 16 143 10 4 28 90 30 64 57 254 74 166 199 156 181 178 99 110 170 115 168 68 32 158 92 60 42 190 252 172 130 206
	     11 184 114 26 246 168 59 211 119 116 161 232 203 236 103 57 230 144 203 66 37 253 133 249 189 231 235 234 62 151 238 128 247 150 105 230 80 113 157 114 41 58 140 28 123 220 244 184 166 172 59 126 169 101 89 102 197 17 102 159 137 114 28 221 108 252 78 223 1 208 3 255 218 105 141 31 181 126 169
	     134 9 0 134 113 57 220 41 81 37 132 80 100 4 216 101 185 210 246 16 230 68 128 52 40 253 65 74 127 56 32 205 50 80 41 218 255 201 212 9 56 252 76 243 113 221 20 179 191 139 135 46 184 176 114 140 49 150 29 175 81 132 36 65 65 68 201 115 197 145 49 26 231 52 123 93 26 173 38 79 55 27 244 70 35
	     186 221 1 136 35 83 192 199 184 168 56 191 28 206 117 112 109 65 255 139 91 154 123 177 21 67 180 136 140 103 137 76 122 36 97 97 175 141 87 221 163 170 233 244 229 188 66 112 133 150 21 137 206 66 54 57 241 223 125 152 29 237 254 59 188 8 145 43 78 196 224 202 58 152 179 207 125 26 69 15 15
	     88 12 84 203 217 232 78 97 170 232 238 197 101 79 1 96 231 115 246 28 51 57 228 61 157 66 161 63 18 139 226 157 34 18 94 194 204 221 94 65 11 121 74 240 2 222 21 5 154 113 69 0 174 110 254 122 236 81 99 66 95 244 35 232 78 39 192 48 76 0 48 140 203 170 0 76 211 202 114 242 82 4 48 204 44 166
	     238 91 142 146 235 62 62 214 126 126 196 9 54 122 140 203 176 150 28 236 132 206 118 144 0 213 176 237 240 150 59 92 222 199 36 222 147 149 45 38 123 163 49 131 110 159 102 187 75 163 211 165 51 232 179 209 234 48 73 83 178 73 6 62 2 231 17 31 149 175 109 107 151 177 123 33 18 41 139 151 134
	     0 89 6 163 73 241 21 242 242 222 119 184 152 169 71 205 0 208 34 122 74 117 12 207 31 211 175 40 27 239 189 193 112 52 216 126 141 179 88 23 117 119 187 249 60 77 217 220 106 48 252 234 43 144 42 67 28 132 8 240 156 77 129 66 87 220 52 42 14 106 85 168 213 17 239 208 217 13 228 144 247 156 94
	     32 231 182 117 3 5 66 86 168 130 195 113 49 110 89 86 60 118 234 191 236 147 1 176 189 198 204 125 190 3 111 74 190 40 30 218 218 34 27 183 120 118 13 122 157 14 121 150 111 191 221 25 14 225 236 147 135 192 104 216 103 107 107 131 222 227 199 197 245 24 230 104 156 64 52 39 37 169 156 222 39
	     81 41 94 187 90 65 150 150 144 56 70 131 66 152 202 92 182 182 26 38 0 24 198 101 243 146 74 17 64 206 254 206 102 92 40 114 32 11 197 78 108 200 245 4 118 101 92 69 5 224 40 155 71 90 6 3 161 220 169 83 21 156 23 212 121 210 16 72 211 156 173 86 135 245 205 45 158 111 53 233 12 6 228 8 147
	     60 160 18 33 73 84 22 249 147 178 48 165 45 94 198 162 73 150 187 253 165 117 184 82 210 196 165 4 63 1 178 50 57 63 159 61 102 190 29 158 204 111 23 203 81 86 58 135 72 33 0 184 48 33 117 35 196 11 203 146 81 37 39 86 240 114 86 115 111 247 122 155 160 44 185 28 124 10 120 42 110 76 166 57 211
	     124 4 217 206 97 216 83 191 147 67 126 158 255 93 16 65 197 35 174 72 57 16 201 17 205 81 157 59 86 120 236 191 189 144 161 157 230 160 57 194 132 224 38 168 207 128 128 4 16 194 62 165 62 246 58 47 63 237 34 178 223 223 227 138 34 163 110 12 110 194 170 75 169 74 70 164 57 78 95 94 123 100
	     15 84 92 78 221 165 84 221 24 21 199 88 50 188 203 139 99 0 179 79 224 142 184 34 195 126 218 83 40 133 19 85 1 31 33 46 194 147 163 234 139 154 42 59 244 25 187 167 27 38 0 24 198 37 8 250 139 93 184 217 201 68 85 196 41 14 107 6 100 114 80 121 28 32 4 134 131 17 253 222 144 113 154 21 206
	     177 59 168 183 181 158 154 109 26 47 115 37 56 32 128 90 116 25 117 231 239 164 220 121 116 114 148 209 211 237 255 59 240 18 33 229 46 126 174 129 81 150 147 142 7 180 123 125 134 227 49 27 91 13 54 26 13 154 157 30 217 36 133 36 1 31 35 222 151 187 186 86 9 251 106 90 236 65 233 38 138 168
	     204 213 74 15 104 8 56 132 56 114 172 46 213 184 179 118 141 219 107 49 107 17 104 200 11 17 170 12 134 231 5 0 167 114 84 107 158 11 33 139 159 124 200 232 116 238 178 156 56 190 251 201 67 30 222 94 162 6 196 251 252 21 71 15 238 247 123 150 155 253 235 52 241 254 218 114 157 31 127 243 125
	     8 129 161 196 92 191 121 139 113 238 74 1 96 187 211 203 124 93 249 249 149 221 205 7 137 236 220 148 95 172 69 31 4 198 234 9 226 104 246 96 189 213 99 171 217 99 60 25 67 156 128 139 144 82 110 57 32 69 104 231 58 19 2 162 57 177 4 42 177 227 206 173 235 220 190 86 227 90 205 227 157 146 135
	     48 205 216 63 224 78 182 91 0 8 251 252 125 32 120 39 244 7 247 209 116 192 215 223 188 205 167 111 223 97 173 26 17 31 199 41 58 182 66 48 61 152 81 164 255 199 177 227 225 107 215 248 243 111 190 205 237 235 53 20 71 119 146 147 68 158 224 22 51 0 246 199 29 34 234 76 199 48 23 8 206 209 29
	     197 108 180 199 60 221 234 208 31 14 32 174 20 231 71 172 214 175 97 2 128 97 92 38 194 182 47 238 192 123 71 228 28 206 242 182 141 169 133 100 57 189 94 159 118 167 203 104 52 65 113 197 14 143 113 245 214 137 3 188 219 189 186 159 239 251 74 101 231 17 65 144 200 35 46 34 56 79 22 50 90 189
	     46 173 78 151 167 235 91 12 70 35 186 163 33 163 52 37 120 95 164 21 187 114 215 127 186 171 104 75 213 21 21 0 244 80 155 157 134 73 26 2 228 25 206 59 170 81 196 235 183 175 241 167 223 124 192 159 126 231 117 62 170 69 164 170 140 40 118 93 195 174 96 254 240 79 194 30 207 41 74 11 40 33 207
	     240 78 88 169 215 88 91 94 98 201 111 7 221 199 51 93 119 172 71 134 242 235 238 245 53 254 95 255 238 71 252 197 15 191 67 6 184 56 38 87 217 17 224 191 168 0 48 255 201 54 85 72 5 254 249 183 99 254 250 31 127 201 223 108 253 11 163 254 8 89 189 94 8 125 122 204 101 39 203 64 115 170 21 97
	     181 26 243 131 143 31 240 163 239 188 205 119 239 175 145 56 232 168 18 115 252 218 10 7 9 0 66 81 15 201 105 96 185 18 115 109 105 137 27 203 9 201 153 119 71 222 190 146 213 36 226 107 15 239 243 198 173 107 116 198 19 64 200 84 17 145 99 213 56 57 72 0 152 230 188 84 128 33 16 156 240 187
	     117 199 127 251 201 151 252 111 255 253 31 233 109 116 145 101 129 218 18 166 0 24 38 0 24 198 37 116 238 53 4 92 236 169 85 171 212 107 85 162 200 166 178 81 58 9 65 25 141 39 140 198 19 210 44 7 231 112 11 105 148 123 97 26 210 101 225 104 231 132 221 66 20 164 123 134 74 229 89 127 239 240
	     82 236 4 102 1 70 163 17 253 201 152 126 58 225 217 230 22 173 118 159 245 173 38 147 116 82 236 201 250 8 23 199 136 184 157 121 196 10 182 243 111 236 23 152 11 219 103 196 139 76 183 66 67 186 185 92 229 211 135 183 249 203 15 239 115 237 165 223 109 207 208 98 101 59 160 207 203 175 213
	     36 230 218 107 183 224 181 151 243 247 101 192 4 112 30 190 248 226 9 81 62 134 113 31 116 21 39 16 244 136 69 1 85 182 51 0 66 74 34 17 203 145 242 238 221 85 126 252 205 183 248 198 82 114 169 109 55 22 199 107 75 53 94 91 170 189 212 247 190 119 7 158 60 239 83 241 10 163 1 90 93 154 147
	     148 12 195 4 0 195 184 60 206 189 6 84 115 34 23 179 92 175 178 178 84 39 137 35 115 171 141 194 97 149 226 76 118 145 34 98 241 150 113 252 37 38 204 213 231 18 17 136 34 226 184 66 154 43 131 78 143 205 102 147 167 91 91 116 71 99 154 189 30 105 170 140 67 40 206 20 136 7 231 139 253 92 93
	     16 35 76 100 50 142 25 90 57 205 145 144 66 58 65 70 41 84 227 151 250 9 230 119 208 41 59 238 200 25 168 165 110 238 235 101 71 175 42 16 198 41 154 167 160 57 168 150 199 34 116 238 200 206 33 17 240 124 233 5 81 188 166 72 16 36 29 35 147 49 249 82 130 191 196 150 250 42 198 13 1 29 230 184
	     116 128 215 180 232 134 176 99 177 181 155 191 97 2 128 97 92 38 159 8 13 138 247 80 73 18 42 73 5 239 156 45 245 198 236 190 95 164 105 251 67 58 187 27 87 124 25 217 251 247 226 138 192 223 57 130 42 57 202 100 148 49 76 149 254 104 204 198 86 139 231 155 27 60 221 216 100 52 73 73 179 28 137
	     99 92 20 19 92 89 236 106 182 243 175 150 243 111 156 124 33 3 84 115 178 116 66 191 219 103 51 11 172 242 106 116 164 179 12 167 228 21 253 77 1 216 10 48 114 208 238 246 25 143 134 197 116 245 69 206 216 145 234 199 233 66 208 89 94 40 213 128 134 148 241 96 192 86 163 203 248 218 50 117 17
	     38 108 215 84 144 75 99 165 47 111 188 148 66 215 31 170 162 34 52 59 35 134 189 22 170 89 33 250 219 114 107 152 0 96 24 151 220 123 87 41 119 232 78 250 2 118 167 184 172 166 145 231 69 177 165 226 236 168 16 16 43 18 121 33 194 112 225 44 186 142 233 156 163 46 176 171 82 52 179 122 252 69
	     202 191 68 17 113 82 33 205 114 210 201 132 173 78 139 78 127 64 171 215 167 217 238 209 27 13 233 143 179 178 203 68 97 99 170 115 189 218 77 141 52 246 181 241 253 172 91 22 194 236 242 8 10 101 75 117 39 68 114 158 239 90 71 41 250 119 254 136 41 142 1 68 78 230 218 114 158 192 63 88 40 183
	     63 173 53 48 173 85 52 95 3 223 60 143 147 225 230 172 108 154 220 23 57 193 57 185 144 182 103 152 0 96 24 198 49 17 1 130 146 231 57 185 102 101 45 228 163 46 252 193 110 22 151 217 221 86 37 205 82 38 105 74 158 231 168 143 109 156 207 237 68 214 93 33 196 52 229 86 14 200 156 127 145 248
	     122 86 48 76 22 92 75 41 223 59 64 158 41 65 114 250 227 9 221 254 128 103 155 77 54 154 13 90 189 1 195 116 2 226 145 56 198 39 142 124 26 161 77 95 116 241 156 255 66 191 239 197 46 95 150 32 112 233 141 28 8 123 140 251 66 208 34 219 149 240 119 218 171 204 190 2 175 86 186 222 63 245 127
	     191 234 245 231 159 156 105 1 194 169 0 179 40 196 28 197 25 217 173 0 232 236 117 118 102 39 206 215 84 176 169 127 60 230 51 0 166 223 23 61 161 230 101 21 83 95 13 19 0 12 227 114 4 116 115 78 180 76 157 237 153 195 161 135 6 131 211 91 173 21 121 187 26 228 121 96 52 28 49 24 12 73 83 135
	     143 164 232 18 97 227 111 161 152 236 44 4 169 229 162 18 249 8 231 61 170 144 166 57 157 193 128 241 36 101 179 211 161 215 31 178 209 108 209 234 247 153 76 38 104 0 188 131 168 12 213 164 220 151 154 137 0 134 177 120 7 91 12 78 246 15 227 117 87 32 106 188 180 245 97 241 138 207 92 12 61
	     124 40 52 88 145 79 195 48 1 192 48 140 51 117 168 68 193 21 154 253 217 150 41 54 46 130 123 29 96 86 96 41 104 96 50 153 48 30 79 200 210 136 168 86 164 207 6 115 166 175 180 99 63 59 47 52 61 163 75 81 226 11 21 84 28 42 158 52 100 12 39 41 205 86 155 102 183 203 179 173 102 209 81 34 15 228
	     8 84 42 160 142 221 103 143 228 32 213 193 6 192 172 111 97 197 58 202 115 220 142 140 24 227 37 7 255 71 190 1 205 237 231 171 154 47 242 18 239 251 118 169 13 19 0 12 195 120 1 135 204 184 84 142 129 194 36 205 152 76 50 130 250 237 24 76 247 139 207 100 238 185 230 82 188 92 23 78 78 101
	     118 238 153 124 172 219 63 201 252 248 138 224 156 3 113 72 228 201 131 48 202 115 250 253 14 237 110 159 254 112 200 250 86 147 118 167 75 171 211 37 15 57 248 4 162 8 245 190 168 242 191 240 206 50 75 251 213 67 108 234 52 15 51 24 231 255 30 115 10 105 241 243 194 213 153 172 151 187 109
	     246 170 221 87 95 60 223 98 238 217 90 100 25 169 94 212 32 213 14 40 24 38 0 24 134 113 94 92 169 249 8 238 24 119 212 189 157 154 99 220 216 46 230 177 198 43 110 48 130 184 162 21 155 134 162 56 155 133 89 231 116 102 235 209 166 151 30 50 69 117 33 111 87 195 92 209 199 185 53 32 104 64 131
	     224 35 95 180 246 75 42 132 60 208 31 244 121 178 190 193 179 205 45 70 227 140 238 104 76 150 166 132 40 46 220 4 241 69 107 73 113 123 175 67 199 90 82 76 4 184 252 118 61 87 9 174 28 223 109 27 61 254 77 100 90 3 224 84 110 65 167 96 110 186 199 223 124 106 194 221 203 138 113 203 55 59 176
	     40 223 142 49 219 87 65 102 187 228 223 206 181 225 98 11 0 10 231 168 116 174 173 146 134 9 0 134 113 37 99 186 169 186 110 183 1 227 104 246 50 181 25 85 181 66 107 87 128 61 243 9 166 235 70 185 139 234 157 47 91 251 193 112 56 34 27 12 233 14 39 60 219 218 228 233 250 6 155 141 22 154 5 130
	     8 120 143 120 15 206 205 157 203 62 197 32 209 92 218 171 33 6 156 194 56 155 165 188 226 49 20 185 34 190 135 89 154 97 2 128 97 24 231 202 137 42 254 63 13 236 236 54 101 28 205 153 153 110 197 232 172 69 179 113 53 86 11 5 68 21 188 71 203 180 255 56 73 72 243 64 58 153 208 104 117 216 236
	     180 105 180 123 52 123 125 134 227 9 153 186 178 152 132 43 50 72 100 186 63 120 176 229 44 30 29 217 241 179 30 181 13 156 113 57 227 169 82 4 216 55 189 101 103 151 136 61 255 249 12 207 150 139 213 168 216 243 162 23 183 12 153 147 112 14 19 115 116 54 222 69 59 81 61 218 251 156 155 113
	     176 83 245 134 9 0 134 97 24 198 21 33 132 96 206 240 37 10 252 231 6 19 113 14 245 158 92 149 113 154 49 200 3 253 225 136 110 175 207 227 245 77 158 110 54 232 246 122 228 89 128 164 130 139 98 84 100 161 69 155 97 188 168 101 158 44 176 178 112 236 194 221 77 236 18 24 134 9 0 134 97 156
	     46 230 14 25 71 12 254 140 43 227 102 11 224 230 150 134 80 238 150 58 239 241 73 66 16 199 36 205 104 14 122 116 122 3 182 154 45 58 131 1 221 254 128 206 112 68 150 3 110 218 210 175 108 231 55 59 207 43 11 235 207 105 173 65 211 222 21 102 185 151 219 66 79 103 124 221 165 152 165 114 46 95
	     55 156 106 216 174 23 92 4 176 214 147 134 9 0 134 97 156 163 192 95 117 219 1 183 74 237 198 65 46 139 206 185 97 243 245 140 205 106 46 224 204 159 155 235 130 128 219 103 28 231 50 172 125 121 102 191 168 240 31 24 76 198 116 250 35 158 108 110 177 177 213 100 179 213 102 50 73 33 242 224
	     34 124 61 65 101 103 233 171 237 116 222 121 67 123 65 43 18 217 67 72 48 171 188 140 247 171 237 5 73 143 97 23 251 173 109 211 102 128 51 203 220 221 171 158 99 232 13 242 146 174 193 174 159 79 163 227 199 17 94 119 159 235 161 135 92 242 29 242 158 72 113 236 127 218 215 67 15 19 255 116
	     123 220 133 66 72 60 226 154 240 82 138 58 30 233 77 228 208 151 125 149 210 128 221 195 13 19 0 12 195 48 12 195 216 237 209 11 36 149 4 239 99 210 16 104 247 122 60 221 104 176 217 108 243 188 209 162 57 24 48 30 77 74 79 210 21 5 254 145 237 216 94 15 14 200 12 195 184 188 88 128 105 24 38
	     0 24 134 97 24 23 209 137 211 105 150 72 89 187 125 218 71 155 189 247 161 236 220 255 249 27 191 233 184 236 26 155 189 90 84 151 227 171 128 6 37 40 72 80 134 131 49 155 91 13 158 62 125 198 102 163 67 119 52 34 7 162 164 130 58 87 236 40 57 33 160 104 152 190 232 142 18 130 167 43 78 24 198
	     145 236 69 203 29 100 157 21 161 59 119 31 241 146 6 255 86 6 239 226 140 177 173 170 134 9 0 134 113 165 111 81 118 187 54 204 84 174 234 112 138 8 81 20 33 206 19 2 12 211 33 157 70 155 126 191 207 86 179 197 243 173 45 54 26 45 250 253 1 65 1 31 225 171 10 81 132 122 135 170 71 220 92 224
	     127 96 177 117 51 32 195 120 245 33 154 236 49 47 229 37 255 61 182 22 24 134 9 0 134 97 188 124 183 162 220 229 219 169 219 207 31 248 59 165 246 58 38 51 95 64 3 145 242 108 165 155 13 224 44 19 64 153 171 39 97 187 255 175 126 168 100 110 202 30 109 76 100 206 255 22 231 240 62 66 196 17 66
	     96 60 201 216 216 106 240 228 217 51 182 182 26 12 39 99 38 89 94 238 170 58 32 16 210 49 104 6 26 35 177 224 166 173 254 20 130 20 187 174 170 11 111 84 174 41 219 111 44 251 254 29 243 127 139 97 92 216 56 251 66 4 255 71 127 136 188 208 123 202 30 53 65 212 198 127 47 212 124 40 195 4 0 195
	     48 12 195 48 78 201 159 156 10 57 34 14 21 33 87 165 215 31 208 31 140 232 15 135 52 90 109 158 61 127 206 211 103 207 25 247 186 197 51 226 184 168 242 239 21 130 160 26 64 125 217 91 93 209 60 32 222 151 133 191 202 163 1 72 89 254 75 109 175 207 48 12 195 48 76 0 48 12 227 165 7 0 179 221
	     193 35 62 73 196 132 231 43 204 124 245 108 85 37 4 69 165 216 214 45 108 200 172 227 92 204 237 67 118 202 21 80 153 206 127 193 121 71 236 61 81 20 35 62 98 56 30 209 238 118 121 182 190 78 99 171 73 187 223 167 211 235 145 229 25 196 73 241 34 206 239 40 18 8 2 33 64 158 67 80 130 15 16 199
	     72 20 151 201 35 69 237 129 162 150 196 220 26 116 128 221 216 142 191 113 245 110 202 123 44 186 134 141 177 97 152 0 96 24 134 97 188 252 224 95 247 245 95 140 139 54 152 229 126 188 19 20 71 80 101 148 166 228 195 9 147 144 211 233 245 120 242 244 57 79 159 60 97 107 115 139 44 203 138 246
	     143 206 33 81 92 216 193 142 18 255 128 134 66 85 208 172 216 223 207 82 8 57 26 2 46 170 128 211 66 4 0 68 116 174 9 155 152 77 25 134 69 194 134 97 152 0 96 24 198 217 7 116 59 111 193 211 93 65 117 243 143 48 105 250 42 187 103 186 240 139 16 50 242 60 47 138 188 77 119 116 121 121 229 162
	     140 131 102 243 225 206 181 170 162 2 78 132 200 71 196 73 5 31 197 164 105 74 187 211 161 209 104 178 213 106 210 236 118 104 53 219 116 186 61 198 89 6 65 193 149 93 1 68 1 183 96 33 139 103 250 1 66 33 2 168 160 57 224 35 136 28 226 29 148 221 2 68 41 186 5 236 249 55 28 102 160 115 117 3 230
	     50 147 44 107 224 170 216 248 37 12 36 207 245 34 122 90 91 215 178 243 245 100 193 11 145 243 241 215 201 121 27 99 121 241 241 210 133 23 177 123 182 97 2 128 97 92 85 151 74 4 203 73 51 142 226 66 8 130 119 66 228 28 147 32 102 37 23 115 194 163 104 177 155 159 231 132 113 74 152 164 116
	     251 125 158 63 91 231 241 211 167 60 93 127 202 184 63 32 79 115 66 20 35 113 60 27 235 48 123 161 112 176 197 76 215 149 60 135 124 130 186 12 117 17 18 71 184 216 35 234 11 65 1 87 4 239 211 179 0 114 233 66 58 227 76 163 167 96 151 228 21 222 17 94 28 27 191 139 53 94 134 97 2 128 97 92 10
	     103 74 182 183 205 152 85 228 213 34 45 215 18 0 204 213 158 31 126 239 32 73 18 170 213 132 201 196 163 64 174 148 59 56 102 40 231 109 62 207 239 207 11 224 188 39 73 98 156 247 228 170 12 134 67 26 173 45 58 221 30 91 205 38 155 155 45 90 237 54 221 86 183 216 185 71 192 123 16 63 219 239
	     63 78 120 86 20 247 87 208 188 248 127 40 164 135 16 28 146 71 72 228 193 197 224 4 39 2 78 102 117 73 116 94 75 160 172 87 176 135 152 49 255 102 106 38 104 24 23 44 56 13 20 217 68 134 97 152 0 96 24 198 43 196 129 186 109 1 192 184 242 34 192 204 50 156 167 94 171 177 188 84 103 68 94 184
	     111 33 224 156 51 91 57 199 238 53 232 172 248 94 174 160 65 25 140 71 108 53 91 124 249 232 17 79 158 61 167 219 106 147 78 82 130 143 32 42 10 247 205 58 116 21 69 254 143 103 51 170 40 110 78 69 82 32 135 60 20 122 64 150 23 29 2 18 69 162 168 56 30 160 32 69 101 66 220 236 88 128 5 7 134
	     97 24 134 97 2 128 97 24 103 23 50 40 32 130 23 135 115 126 238 136 128 69 120 87 94 12 112 66 181 82 100 0 196 227 9 19 187 36 231 116 26 23 193 179 56 33 137 34 156 43 138 252 165 89 70 179 211 101 48 24 176 213 108 210 108 183 121 250 252 57 91 27 91 48 26 21 59 234 213 26 68 81 81 28 80 164
	     56 251 175 167 180 182 160 133 34 161 20 217 0 161 248 65 66 142 70 25 56 143 136 71 188 67 112 179 29 253 48 107 21 160 7 47 69 161 124 220 76 112 48 46 253 253 234 69 214 179 185 18 148 114 220 151 151 139 116 141 228 248 151 243 20 254 62 199 118 215 152 237 82 159 187 154 143 158 218 184
	     93 238 132 197 179 61 166 41 123 124 191 123 204 204 7 52 76 0 48 140 75 115 83 209 114 139 111 71 89 158 162 76 119 89 17 240 36 142 194 233 220 232 141 243 133 3 188 8 94 4 7 56 2 206 206 112 158 35 7 81 209 0 136 18 84 112 56 156 115 56 113 164 33 163 63 26 241 248 217 51 214 159 111 176
	     177 190 201 56 155 48 158 164 197 92 175 213 10 177 207 121 20 41 130 238 19 20 211 83 216 47 156 154 243 35 165 56 54 162 25 100 129 144 167 144 121 136 34 124 20 131 196 69 93 0 231 64 149 105 121 191 131 63 142 204 190 100 186 182 153 109 94 74 27 63 245 87 156 10 102 151 38 204 219 235 58
	     157 198 95 119 188 251 248 204 125 152 30 233 217 247 174 162 135 95 4 221 45 2 20 237 68 117 46 96 61 189 32 248 252 11 0 114 162 241 146 99 94 8 53 33 213 48 1 192 48 174 8 30 242 16 24 79 82 70 163 9 121 158 32 150 134 107 148 126 129 134 80 124 153 99 112 254 198 71 40 206 211 59 143 23 79
	     22 2 189 193 128 225 96 72 171 223 167 211 233 242 232 201 19 54 54 183 24 183 58 69 17 190 40 46 171 243 251 157 231 247 79 236 25 31 33 72 16 64 66 121 42 32 47 222 45 120 200 115 66 158 35 33 224 92 14 26 21 15 118 30 87 110 254 31 253 40 194 244 115 152 157 26 123 27 182 138 199 249 136
	     184 90 165 22 249 139 22 17 30 153 48 23 106 191 172 8 216 1 213 242 4 80 82 173 226 227 132 233 153 34 125 193 29 101 21 79 112 17 81 82 161 86 175 16 149 181 64 252 165 54 220 179 245 193 230 87 237 168 236 236 83 173 38 68 149 37 16 95 170 175 38 168 26 38 0 24 198 37 141 32 28 226 60 121
	     8 12 134 67 250 195 33 105 94 5 18 187 54 6 168 18 66 78 8 101 81 55 217 233 196 41 101 97 247 125 28 59 107 207 118 6 67 34 219 59 227 94 28 206 59 188 143 240 222 147 14 70 52 26 45 158 175 175 179 177 181 197 96 56 166 211 233 144 102 25 84 146 210 235 243 69 117 199 210 189 219 43 100 150
	     185 98 123 135 141 161 148 227 191 253 48 157 237 200 207 191 178 234 30 238 103 200 209 172 56 22 144 75 14 33 32 145 47 18 6 156 67 16 100 182 175 239 182 95 71 14 8 244 44 241 200 152 183 137 242 43 71 8 206 129 79 136 171 53 146 185 100 231 253 230 193 139 4 87 251 5 92 202 217 230 199 77
	     147 184 243 114 198 184 221 58 200 169 74 100 243 127 71 181 124 191 74 41 0 136 186 185 83 134 194 177 171 118 106 81 29 36 136 67 93 5 87 169 81 171 213 102 221 73 206 50 60 149 133 113 147 151 100 174 251 141 149 158 225 223 57 125 237 164 18 225 170 43 168 36 144 139 105 169 134 9 0 134
	     113 105 189 35 17 4 71 22 148 193 104 204 96 56 36 75 87 16 19 0 12 138 244 255 106 18 83 173 84 136 7 74 26 138 221 28 139 177 94 97 60 35 82 166 238 59 242 160 164 89 206 100 48 34 203 50 154 205 54 143 158 62 225 249 198 38 91 91 13 52 207 33 40 82 77 144 74 165 24 185 133 128 94 207 232
	     147 202 92 127 239 29 217 35 50 87 108 84 139 182 129 26 20 92 14 33 135 16 33 81 0 231 139 245 201 59 220 30 167 137 231 223 107 122 172 105 103 127 113 195 40 237 205 123 84 32 13 66 171 63 225 215 95 109 242 87 119 235 124 188 148 144 6 101 116 12 1 96 175 211 112 187 15 191 21 107 100 200
	     3 145 40 245 106 149 149 90 141 213 90 132 3 226 51 10 40 231 79 222 11 208 207 50 154 157 62 221 225 152 12 112 81 84 150 248 144 35 253 141 114 132 159 231 95 169 145 11 19 47 252 252 139 1 207 183 122 164 62 129 74 64 165 44 248 121 220 245 70 4 85 79 138 99 152 59 62 223 232 243 215 191
	     121 74 250 198 53 18 239 232 230 74 188 135 16 161 135 140 15 236 172 148 176 248 239 65 3 46 40 75 73 196 74 173 194 90 173 66 197 187 151 18 228 8 144 6 104 143 199 116 134 19 6 227 148 32 101 247 157 114 253 231 24 127 243 126 63 79 75 179 36 192 64 129 88 248 237 19 199 231 207 90 12 115
	     7 149 74 209 17 102 246 72 195 48 1 192 48 46 131 87 4 229 254 154 148 65 65 200 3 33 11 123 239 248 201 81 94 239 88 79 48 206 181 101 148 2 128 115 44 213 235 172 44 13 105 12 2 195 97 134 134 28 124 152 245 114 87 221 233 98 204 239 30 95 186 0 92 246 114 185 143 18 49 188 216 53 9 229 156
	     20 47 68 222 227 163 24 239 35 134 147 140 201 112 192 250 86 147 173 173 45 90 141 6 205 86 155 193 100 82 20 220 19 1 95 238 206 235 9 195 253 35 125 244 176 59 40 63 244 154 204 59 150 161 204 245 207 80 13 132 60 20 245 0 226 8 71 209 198 16 41 158 145 79 95 96 199 54 153 158 195 101 231
	     108 139 120 25 71 11 136 17 55 219 6 31 103 129 231 141 46 127 247 211 47 120 190 190 206 237 184 152 91 225 128 17 59 158 0 32 179 16 220 17 24 116 59 212 34 225 195 247 222 226 155 31 125 192 167 239 220 161 34 144 184 157 175 161 47 108 71 50 251 123 167 217 12 17 176 213 238 241 191 255
	     245 63 241 207 191 248 156 137 68 44 95 187 78 26 138 21 62 20 101 55 95 72 0 216 17 68 139 48 84 71 16 225 105 75 249 226 73 131 204 85 160 22 131 120 84 203 150 159 71 186 202 1 68 145 178 40 241 36 4 186 227 148 159 127 246 140 206 112 192 79 150 35 188 131 52 47 186 135 200 41 9 0 129 162
	     222 205 104 52 128 108 204 187 119 111 242 205 15 222 230 91 31 190 195 181 101 135 127 73 205 111 70 89 198 111 191 218 224 159 126 253 5 191 127 188 137 10 12 199 57 113 28 19 196 157 138 0 160 115 215 32 163 104 201 186 217 143 248 252 121 143 81 150 67 125 185 236 212 98 2 128 97 2 128 97
	     92 210 80 175 60 167 167 204 2 5 57 241 235 25 151 195 113 46 157 72 239 89 94 170 179 178 50 162 218 30 35 131 20 213 176 243 36 64 208 99 56 118 151 227 218 44 186 221 103 61 47 68 164 44 212 167 132 52 99 156 5 148 9 237 222 128 110 183 203 227 199 143 121 242 228 41 221 118 167 216 245 175
	     36 184 74 113 6 247 36 101 212 244 24 1 245 94 130 161 30 103 205 144 57 167 63 20 66 128 74 142 138 43 143 4 4 36 142 193 23 25 75 78 220 174 247 212 115 153 255 127 22 69 217 140 99 227 202 68 120 13 140 179 192 122 171 199 70 179 201 63 252 98 140 11 249 142 52 249 112 162 249 191 83 0 112
	     40 34 1 167 19 122 27 79 89 73 28 255 234 71 35 234 215 238 242 240 237 59 136 135 250 153 216 210 246 106 52 117 198 183 186 61 254 243 223 253 130 255 207 127 250 91 198 82 229 218 235 15 24 231 158 105 216 44 47 40 0 236 184 13 136 16 40 95 219 57 212 71 168 175 224 35 79 80 183 255 209 157
	     131 214 6 239 65 61 147 48 33 203 2 63 251 98 139 159 125 246 12 52 224 52 32 186 93 130 244 52 4 0 197 225 156 48 233 180 112 227 14 223 252 248 45 112 53 222 121 240 38 75 181 248 204 59 148 78 63 207 36 205 248 253 211 45 254 211 223 253 154 255 241 179 207 9 226 232 14 51 170 73 66 144 120
	     86 23 229 69 4 128 121 17 64 203 251 139 74 4 46 38 68 9 110 105 137 176 71 198 152 97 152 0 96 24 151 72 4 40 42 35 11 161 60 111 107 75 190 1 115 93 0 28 136 132 98 119 86 173 68 228 206 249 163 156 118 63 45 157 203 166 112 222 147 196 9 206 121 38 89 198 96 56 166 217 110 210 31 142 88 223
	     220 98 48 26 209 104 52 232 116 251 232 100 82 230 176 6 84 138 93 243 226 236 237 57 158 209 202 46 55 124 91 137 20 130 150 167 125 85 81 31 129 119 184 242 24 132 150 5 17 166 213 199 245 5 134 225 56 117 15 140 139 54 77 5 112 4 205 9 57 48 10 48 14 144 103 103 179 30 136 66 200 160 49 161
	     95 17 158 13 114 58 169 35 229 164 231 214 229 248 211 9 24 231 202 243 222 152 193 214 16 68 216 90 74 203 30 155 142 211 47 152 89 118 250 160 76 113 168 70 72 45 66 188 71 243 147 182 22 21 84 32 87 79 70 128 49 197 184 101 89 113 92 232 212 61 21 87 28 61 106 165 48 30 243 180 151 210 30
	     43 99 132 188 28 59 207 217 151 27 201 129 222 36 176 217 203 217 104 167 69 22 203 32 103 18 59 240 114 6 111 92 190 96 164 80 45 219 178 58 95 218 138 173 133 134 9 0 134 113 41 217 145 196 44 82 170 193 134 49 205 32 87 162 89 159 117 157 75 39 47 163 46 153 90 144 92 201 217 115 22 174 224
	     44 61 83 21 13 74 174 16 130 50 28 141 105 117 58 124 249 232 49 141 70 147 245 205 77 50 13 4 45 142 7 72 189 182 227 249 23 50 152 157 217 90 14 57 104 16 130 22 181 12 52 42 119 251 92 217 193 64 139 192 66 69 177 29 118 99 255 9 85 74 106 226 32 174 128 143 161 190 244 226 194 216 162 201
	     105 185 171 46 138 215 49 153 230 36 9 172 172 94 39 174 84 139 68 132 51 12 254 119 125 28 231 89 89 89 35 185 125 151 137 171 83 185 121 135 73 136 208 51 17 0 166 66 75 249 210 226 138 108 128 112 242 227 57 179 79 39 190 8 204 107 17 84 107 115 233 138 167 189 246 248 162 170 109 236 241
	     227 42 171 107 55 72 234 75 56 231 89 60 217 118 150 43 142 136 16 85 42 212 215 174 83 187 249 26 136 48 92 10 184 56 70 37 218 81 7 224 212 199 207 73 145 193 17 130 197 254 134 9 0 134 113 185 195 23 41 82 107 35 143 247 187 111 116 47 30 28 29 223 145 49 94 113 252 85 226 69 168 36 17 149
	     36 33 246 17 211 140 192 98 15 105 127 7 114 26 116 158 89 61 0 217 99 171 87 79 251 175 223 109 199 187 79 222 202 110 167 123 15 103 174 168 146 175 71 122 123 39 142 56 246 136 243 168 6 38 105 70 187 219 99 208 31 178 213 108 210 233 117 121 244 228 41 237 78 135 73 167 83 4 53 149 4 188
	     47 206 202 95 132 160 95 14 184 96 211 192 94 164 56 127 170 160 26 102 78 191 106 14 62 42 142 8 148 157 2 188 184 89 141 128 48 219 108 60 185 139 126 216 199 59 153 45 217 250 119 46 12 79 4 34 95 6 171 47 56 38 187 39 123 145 189 35 90 100 167 84 170 184 4 162 168 130 184 104 223 227 56 103
	     214 17 64 28 62 74 32 169 130 171 66 165 138 134 24 206 74 0 152 190 158 82 158 29 231 148 2 245 242 240 189 155 27 51 57 131 171 55 21 0 42 53 32 197 39 9 174 92 107 244 133 141 227 232 35 174 101 43 84 31 197 72 165 90 172 241 26 208 82 0 64 206 166 132 228 172 78 140 234 201 107 198 24 38
	     0 24 134 113 222 67 127 157 251 238 180 123 104 171 9 0 23 88 0 216 46 2 8 245 90 194 210 210 18 213 36 222 182 16 157 182 116 210 87 106 187 47 221 182 22 234 99 200 94 65 196 162 195 123 4 103 109 26 176 107 41 110 68 226 65 28 1 165 55 28 242 244 233 58 235 207 55 120 182 213 32 203 51 6 131
	     1 33 87 92 165 134 58 138 115 206 101 170 127 56 237 75 125 102 99 184 48 116 58 47 228 204 59 249 229 247 33 64 58 134 60 45 219 185 69 69 135 0 95 193 79 219 27 150 175 27 230 69 144 35 58 203 51 209 106 241 239 150 23 153 73 198 185 188 247 45 158 23 145 19 218 190 46 204 127 41 203 240 137
	     34 58 173 105 81 4 195 178 199 89 245 179 95 203 181 120 111 13 197 255 67 64 66 94 30 49 58 235 245 91 79 255 181 116 241 251 51 184 249 149 237 73 37 20 109 73 81 157 141 221 139 221 163 142 190 62 204 122 57 76 109 72 180 168 135 18 220 44 75 243 98 140 155 97 2 128 97 24 231 200 247 209
	     217 70 8 174 112 98 114 13 140 210 156 209 120 66 158 7 187 78 6 148 230 81 175 10 171 43 9 149 74 84 236 192 230 178 167 63 253 234 186 0 188 194 244 239 83 120 107 231 28 34 82 244 189 119 66 154 101 12 199 99 122 189 1 253 209 128 205 102 139 199 79 158 178 181 217 96 208 233 149 109 244
	     4 23 69 72 37 153 115 136 15 174 188 127 225 206 184 151 199 75 102 71 77 166 213 168 67 81 172 11 159 163 222 67 4 18 98 136 66 177 83 38 82 6 90 206 142 51 25 175 32 200 81 138 122 242 59 14 226 188 194 192 106 86 234 109 238 51 233 75 184 14 23 49 56 221 57 94 114 14 174 145 204 125 166 34
	     191 196 86 52 195 4 0 195 48 94 244 230 226 28 162 144 167 41 253 193 136 110 63 98 146 166 182 119 101 16 74 1 160 234 160 94 119 196 209 116 119 52 28 90 91 254 50 183 2 60 53 87 179 76 115 87 39 56 231 241 206 227 226 136 254 120 66 171 213 230 209 163 39 108 182 154 116 186 61 186 253 62
	     89 22 144 200 23 163 34 130 58 102 85 176 95 117 136 113 182 254 120 216 59 160 201 139 221 185 16 0 159 67 240 197 217 110 31 21 235 26 204 220 229 109 183 217 202 87 26 134 97 24 134 9 0 134 113 85 3 16 40 207 28 11 89 8 140 135 99 134 195 33 89 150 157 225 59 90 96 120 17 23 246 90 162 133
	     0 32 115 169 137 101 199 233 171 212 2 112 145 128 238 44 71 176 95 160 95 124 83 252 95 4 113 130 23 143 138 35 39 16 178 140 238 120 64 174 240 124 115 147 205 205 77 190 122 244 132 118 179 77 158 77 138 231 36 85 168 84 144 105 170 188 228 59 142 14 92 137 17 152 63 18 160 74 81 29 49 37
	     132 12 242 8 162 28 162 4 31 69 32 174 20 2 182 229 170 80 118 22 48 12 195 48 12 195 4 0 195 184 130 148 39 18 165 104 113 147 7 37 207 243 211 246 214 141 139 28 107 149 196 190 168 155 229 230 254 161 216 97 13 101 90 162 188 194 79 247 106 208 19 60 94 40 178 35 188 247 68 81 130 58 199
	     100 48 164 223 239 243 116 125 131 94 127 192 179 205 13 122 189 62 189 94 159 144 101 229 28 117 69 131 78 221 238 183 48 159 197 127 165 228 151 217 209 128 109 43 100 90 177 58 228 144 7 66 22 227 226 8 137 98 68 138 35 22 83 169 100 62 185 247 160 113 50 12 227 170 179 120 100 226 56 119
	     4 91 69 12 19 0 12 195 56 71 81 157 236 168 154 238 202 130 50 190 56 135 44 110 135 115 124 58 117 180 141 139 26 248 79 191 23 133 200 59 146 56 34 246 121 25 128 133 185 13 217 157 227 125 182 93 0 228 165 20 167 59 168 186 255 180 239 188 28 49 250 22 145 226 172 63 160 34 164 33 48 25 141
	     72 179 156 173 86 139 86 171 205 87 79 158 208 234 118 233 182 219 168 74 81 224 174 94 1 138 98 128 179 254 139 123 245 188 63 202 95 118 158 206 253 171 156 108 9 57 168 56 159 78 69 0 69 67 32 104 142 15 10 62 42 123 103 151 181 22 20 114 57 120 141 210 99 154 237 94 89 32 139 175 177 248
	     152 35 93 2 125 241 207 102 156 32 118 51 140 99 9 0 186 199 226 100 19 213 48 1 192 48 140 11 113 171 19 2 20 217 0 128 199 118 195 76 8 40 112 34 212 146 132 122 189 66 101 50 33 80 4 89 136 51 11 57 192 37 148 50 208 20 239 73 146 24 85 33 203 51 250 221 14 205 102 155 78 187 203 243 70 131
	     193 112 72 163 213 102 52 26 193 100 2 226 81 146 34 245 95 116 71 189 238 89 17 40 153 75 133 191 146 1 155 206 21 50 159 235 11 46 20 71 3 52 144 135 28 241 17 184 8 162 168 252 94 240 11 34 138 162 69 100 109 166 108 156 81 8 105 24 134 97 2 128 97 24 231 203 59 81 41 210 100 197 145 229
	     66 62 45 190 109 10 128 65 177 131 93 169 84 88 174 213 168 15 97 56 81 38 154 35 200 158 187 252 86 4 16 112 211 180 115 33 87 37 87 200 211 9 131 241 136 70 179 197 163 199 79 105 108 53 105 182 219 4 85 50 5 31 69 228 81 188 99 210 233 98 33 188 197 248 255 74 175 95 243 173 220 100 71 111
	     119 213 0 89 113 36 128 40 160 170 8 130 47 139 159 136 19 84 101 71 37 139 169 8 96 1 155 113 186 183 89 157 117 223 177 251 169 97 24 38 0 24 134 113 46 68 0 17 112 226 200 3 12 198 57 131 20 106 137 93 26 163 192 59 199 114 189 198 218 202 10 237 126 206 56 29 161 89 14 222 33 226 175 222
	     132 97 234 203 239 33 126 0 226 61 226 221 236 188 249 96 52 162 55 24 208 108 181 105 183 59 108 110 109 241 124 115 139 126 183 71 62 26 129 43 139 44 120 135 248 232 204 106 42 28 116 172 225 178 140 203 98 207 112 213 20 210 105 215 128 156 224 29 78 99 112 30 17 135 119 219 199 158 84 45
	     248 55 78 106 119 28 24 221 155 93 93 84 142 170 218 200 41 216 145 169 67 134 9 0 134 97 188 52 231 69 10 1 192 9 170 48 25 231 76 198 74 158 188 64 45 0 61 131 251 163 241 202 112 2 73 28 83 175 38 36 137 71 36 108 183 3 20 221 247 96 242 69 14 56 247 252 172 178 80 66 78 247 248 43 157 128
	     23 124 228 201 242 162 119 253 112 60 164 213 234 240 228 233 51 154 141 38 253 193 144 225 104 12 145 199 213 107 168 148 237 233 102 197 234 194 225 159 239 56 169 255 170 179 2 132 23 38 48 209 19 24 212 244 154 204 170 85 186 50 195 41 20 181 1 38 1 188 35 132 0 81 140 243 113 81 23 192
	     57 64 9 186 109 203 167 125 214 254 36 175 119 146 231 88 221 128 151 25 27 234 177 130 65 19 1 46 220 157 239 136 2 192 105 4 255 186 32 56 216 164 53 76 0 48 12 227 101 249 220 65 72 39 66 154 155 179 98 108 187 38 222 9 171 43 49 55 214 150 217 104 245 217 108 181 33 79 139 2 107 196 87 250
	     218 160 138 243 14 87 168 104 32 48 201 3 195 209 128 78 183 199 104 60 102 125 115 139 173 86 131 141 141 77 134 189 1 154 229 133 140 144 36 72 228 109 178 157 153 120 160 219 2 192 244 55 185 160 33 67 178 12 141 114 136 227 194 142 203 34 141 136 219 22 1 236 74 26 134 97 24 134 9 0 134
	     113 225 125 227 29 21 218 231 84 102 41 206 40 70 145 39 138 138 228 230 96 151 203 160 216 212 174 84 60 181 106 133 74 18 21 27 172 33 32 90 236 145 20 205 35 101 49 250 186 196 241 165 236 152 75 136 224 162 136 40 142 9 1 6 163 30 173 118 151 167 79 159 209 234 246 216 106 181 24 14 135
	     76 210 148 224 60 68 174 204 20 40 118 152 244 40 215 108 238 189 144 237 195 7 71 202 4 184 106 53 25 116 209 14 231 175 29 69 145 64 50 52 83 84 115 136 98 36 74 192 251 242 33 74 152 191 228 156 77 86 128 113 85 176 29 93 195 48 76 0 48 12 227 188 185 39 34 179 94 217 147 52 99 52 206 153
	     212 29 222 109 239 132 153 251 114 53 153 142 253 74 2 55 175 121 214 234 130 215 148 144 77 112 113 245 10 94 12 153 137 103 46 118 101 218 190 50 24 79 152 244 6 140 198 19 54 55 183 216 106 54 121 250 236 25 221 110 143 108 56 42 66 202 164 8 50 139 187 165 123 233 115 202 118 180 183 197
	     1 205 115 52 207 32 205 33 202 33 206 113 113 140 120 95 140 173 8 136 47 68 3 61 173 235 119 180 243 226 134 97 92 138 133 102 63 143 107 159 223 217 154 96 152 0 96 24 198 25 6 251 187 110 82 34 56 231 9 33 208 235 15 104 119 122 220 88 90 98 169 26 205 30 117 44 17 192 238 99 23 220 119 209
	     29 227 238 68 168 57 184 182 44 212 226 156 144 77 72 39 41 81 53 159 181 186 155 239 194 118 30 2 206 157 153 46 39 152 39 123 198 141 219 53 51 196 59 170 245 37 156 247 140 71 19 90 237 77 158 111 108 208 108 117 217 104 108 49 28 14 233 15 135 164 105 58 173 12 88 188 234 92 1 129 157 13
	     254 142 248 129 202 115 199 199 237 254 247 74 131 255 197 179 210 39 221 74 63 233 31 177 107 205 155 107 27 72 128 60 3 45 90 91 6 239 139 2 129 113 140 23 45 186 57 168 16 202 58 10 133 9 236 92 13 143 246 231 236 213 16 78 78 201 48 95 252 210 26 103 60 5 230 167 193 124 178 212 25 142 87
	     145 44 36 219 89 67 214 157 229 37 6 255 122 140 137 44 11 207 214 163 101 133 25 134 9 0 134 97 188 200 173 74 16 156 115 132 160 244 135 35 58 253 33 163 180 70 189 186 248 56 227 42 226 0 15 44 39 176 82 133 106 197 17 71 101 27 118 205 217 46 150 116 137 157 22 17 68 60 82 54 141 75 179
	     28 198 99 210 44 167 221 238 241 248 241 83 190 120 252 152 86 179 201 120 208 71 69 138 222 243 145 47 206 153 171 148 193 89 216 195 73 60 194 204 146 221 179 214 120 193 232 104 122 45 53 64 22 208 60 67 189 7 31 33 40 206 199 133 109 139 47 90 165 150 146 77 216 37 115 157 100 44 108 12 141
	     151 164 60 24 134 97 152 0 96 24 198 222 126 130 162 226 138 138 228 226 81 17 171 1 96 236 240 35 99 129 165 90 194 181 149 58 157 129 146 57 200 179 0 46 32 226 47 245 158 69 228 61 81 18 35 8 121 8 12 122 61 26 157 14 155 155 13 54 27 45 154 205 22 141 86 139 201 112 88 236 40 59 15 174 216
	     65 118 179 234 254 198 185 67 231 51 2 164 168 15 16 10 81 32 68 41 228 49 234 99 112 17 184 98 23 213 113 180 61 62 195 120 229 49 184 25 233 133 183 29 203 234 49 76 0 48 12 227 197 111 40 178 80 192 172 244 18 20 80 45 91 103 149 187 156 230 59 92 89 35 153 57 31 243 251 250 1 165 94 173
	     113 251 198 53 122 35 71 99 144 147 230 57 138 199 121 255 138 108 247 224 199 190 136 223 44 101 202 126 144 34 32 212 60 144 101 25 163 201 132 141 173 38 79 215 159 243 228 241 19 122 237 46 89 8 4 1 226 4 42 149 34 160 44 63 67 80 155 73 231 47 240 223 195 230 101 42 4 228 144 229 228 185
	     128 207 33 10 72 164 184 168 16 1 28 130 138 162 58 95 192 81 204 81 55 118 26 151 148 45 118 17 100 47 25 64 78 255 93 117 215 47 116 246 165 182 14 93 56 51 42 4 128 233 209 49 171 19 96 152 0 96 24 198 41 7 86 226 60 33 15 12 6 67 186 131 1 227 73 157 171 220 226 205 216 237 167 138 194 114
	     189 194 205 181 101 26 221 140 206 184 95 100 0 80 20 181 191 12 138 145 170 206 122 195 71 190 72 225 207 53 103 48 28 209 239 116 104 54 91 116 250 125 182 154 45 54 55 183 232 180 90 48 154 20 197 253 146 4 124 121 230 214 137 181 209 184 168 94 183 134 66 12 85 138 49 12 10 121 142 102 30
	     137 163 162 91 128 243 136 184 242 80 64 241 216 112 232 20 48 231 221 48 46 228 205 239 229 61 113 207 37 201 48 76 0 48 12 227 133 3 156 221 247 42 135 119 158 16 82 122 131 33 237 110 159 241 100 21 161 62 187 255 152 235 106 62 144 67 72 226 136 165 74 66 45 142 113 2 26 180 56 34 253 18
	     109 87 22 183 90 133 35 21 77 90 204 10 216 123 46 148 133 15 157 67 165 216 189 159 100 25 237 110 135 231 235 27 60 125 250 148 78 175 199 112 52 38 77 51 36 138 209 229 184 232 31 47 82 238 182 205 93 184 197 183 56 113 1 188 11 60 3 47 202 103 215 133 157 182 105 213 191 144 161 33 71 131
	     67 136 17 141 112 81 2 78 17 252 204 254 68 231 142 122 200 66 16 32 11 198 240 178 11 33 26 47 22 191 233 81 199 102 126 140 117 238 119 122 230 195 183 184 63 108 89 124 47 116 179 1 81 68 116 214 61 84 142 28 222 31 166 134 203 209 198 81 230 138 207 238 176 35 243 198 12 19 0 12 195 120
	     225 27 221 180 13 160 35 87 24 141 83 250 195 17 227 52 53 231 193 216 129 3 174 213 98 94 187 185 194 243 246 8 183 222 36 207 198 56 151 16 69 201 197 174 92 236 4 39 14 23 21 187 186 105 150 209 239 244 232 244 251 116 122 61 54 27 13 54 183 54 105 52 90 228 195 97 81 56 206 69 16 87 192
	     71 236 232 53 111 92 154 181 17 13 69 93 0 128 32 168 6 200 115 66 30 138 44 0 23 21 93 3 188 219 81 220 189 152 45 139 97 128 217 198 149 178 157 133 64 124 250 21 56 221 100 110 177 128 255 140 40 142 68 42 174 72 4 42 103 245 94 215 56 44 220 39 143 51 186 123 105 77 106 227 105 152 0 96 24
	     198 153 248 39 11 109 210 130 128 34 168 115 224 166 253 205 13 115 129 230 54 180 5 42 78 88 94 170 80 171 69 56 2 121 158 33 154 191 20 91 153 237 224 47 188 89 208 176 251 49 251 61 119 225 119 170 133 108 225 157 3 28 81 156 160 78 24 142 199 52 91 45 30 63 125 202 86 171 69 191 223 103
	     60 154 20 238 93 165 90 126 8 183 123 103 215 98 188 75 18 184 205 247 181 44 7 85 28 132 178 243 69 208 114 173 12 184 56 70 92 92 20 9 156 157 246 214 29 173 26 213 132 161 203 183 54 46 214 36 153 219 182 13 65 74 193 168 104 247 89 20 216 221 54 37 61 197 229 66 247 19 0 202 163 72 219 103
	     200 15 95 23 175 118 157 0 93 248 73 8 101 239 15 93 184 206 243 99 183 120 244 231 184 123 244 123 61 190 40 219 80 212 109 16 124 89 195 193 161 206 230 157 97 2 128 97 24 167 120 227 19 28 65 97 148 166 12 199 41 105 30 76 0 48 118 56 38 158 66 27 90 91 113 92 95 73 168 37 190 248 157 6 132
	     252 226 217 139 115 184 178 219 69 170 129 201 120 68 123 208 99 60 153 208 104 52 121 242 244 41 143 159 61 167 223 238 64 158 151 231 252 43 69 133 255 125 196 8 227 50 47 147 10 154 3 130 230 121 185 65 152 19 52 67 200 139 108 0 28 174 20 81 231 119 124 11 59 17 19 136 174 216 234 169 34
	     4 231 193 187 233 214 240 174 96 241 180 214 232 233 46 245 252 239 67 185 131 109 134 119 236 155 67 113 199 147 8 117 130 250 221 187 242 123 53 116 157 254 94 78 48 126 179 76 14 41 55 98 196 129 186 93 162 145 97 152 0 96 24 198 201 157 6 217 222 142 16 4 231 28 33 11 140 210 9 195 209 152
	     60 100 83 127 197 82 209 76 4 216 241 255 216 65 37 114 68 222 17 121 1 95 236 145 104 121 156 100 95 91 145 61 254 69 225 40 103 34 103 1 24 187 143 79 203 81 220 45 221 121 6 87 156 224 189 39 169 84 193 57 6 195 33 163 113 143 205 102 131 86 171 69 163 221 162 221 238 146 78 166 45 253 138
	     12 129 29 129 255 94 111 107 19 229 84 236 109 241 210 134 189 236 231 165 215 22 208 221 86 169 1 178 172 88 35 37 32 222 163 81 130 56 69 92 153 12 92 182 26 220 185 185 106 1 217 185 70 143 178 164 232 129 225 99 142 130 10 206 197 84 170 49 75 64 237 12 157 101 199 206 178 189 181 216 225
	     226 34 11 129 80 200 252 139 235 150 117 6 88 24 243 178 248 167 18 192 9 73 146 80 95 130 37 129 228 37 5 59 113 236 169 86 19 188 143 16 41 143 22 169 121 97 134 9 0 134 97 156 246 93 79 4 39 144 7 101 50 73 233 15 39 12 70 57 19 160 202 246 217 55 195 160 116 50 87 150 34 110 95 95 165 209
	     87 250 169 18 242 113 113 27 16 127 64 112 35 236 46 141 47 47 203 202 11 209 171 76 249 15 65 201 210 148 113 174 164 89 74 179 221 102 99 99 139 71 79 30 179 209 216 34 27 12 10 95 208 37 72 20 23 245 253 196 237 110 179 101 92 77 133 98 58 248 33 47 143 4 228 64 138 70 17 168 226 52 130 104
	     123 46 20 89 216 110 161 28 156 181 245 186 148 230 33 20 93 64 188 39 56 97 148 229 180 186 99 158 143 160 46 25 99 4 17 221 247 156 247 97 245 7 247 179 152 28 8 8 53 41 130 200 245 65 206 104 2 234 35 32 34 168 217 219 209 252 33 7 46 34 85 165 59 156 176 222 202 241 171 202 138 131 8 33 136
	     238 37 5 238 121 207 217 239 54 33 186 88 51 70 241 8 75 113 68 99 48 161 217 155 48 41 59 236 132 237 238 204 134 97 2 128 97 24 167 239 181 76 143 51 135 160 140 83 24 101 80 139 94 102 152 102 156 251 184 167 164 82 169 176 178 178 194 114 61 37 237 14 24 166 25 234 41 211 22 129 29 249 35
	     175 204 149 219 129 247 158 56 142 241 206 145 170 210 27 12 104 54 54 105 54 91 108 54 90 116 186 61 182 90 45 198 163 81 145 242 239 138 190 239 219 101 160 183 115 13 108 231 236 229 141 219 249 251 128 211 224 125 42 2 0 82 36 96 75 86 166 253 107 142 168 47 178 71 124 92 136 79 211 5 86
	     117 110 67 79 76 7 184 240 183 78 153 217 109 145 5 85 254 224 35 240 48 158 76 104 182 122 60 217 88 161 230 114 250 94 145 16 138 118 147 236 149 49 117 220 25 48 173 227 35 228 10 245 164 70 180 236 121 222 81 70 99 202 76 148 226 56 130 136 155 171 46 111 99 183 231 117 247 130 122 71 150
	     5 58 221 30 207 54 58 232 216 179 28 11 30 69 3 76 15 72 74 89 41 96 250 221 244 119 112 112 230 164 204 178 217 230 4 0 231 88 169 215 121 218 74 105 116 70 140 38 89 145 137 192 84 72 20 107 2 96 152 0 96 24 198 25 220 250 202 118 128 224 25 140 28 237 62 212 87 33 182 163 171 198 142 248
	     71 89 174 37 220 127 237 58 173 126 198 112 52 160 63 26 151 155 25 241 57 179 105 153 121 230 89 8 104 154 18 20 134 147 9 91 141 45 190 248 242 43 158 173 111 208 235 118 201 85 200 67 40 130 182 74 84 6 109 174 236 194 164 54 7 76 4 216 251 19 206 101 4 104 200 33 205 209 144 66 22 129 143
	     144 4 196 251 178 83 100 153 129 162 211 87 57 205 114 112 198 185 90 119 146 10 33 82 154 237 30 191 248 237 35 242 241 152 138 228 44 69 1 201 115 208 108 22 70 190 184 0 80 20 26 204 21 226 250 26 174 186 194 239 191 220 98 179 171 144 212 193 37 197 10 102 102 118 216 205 13 162 8 168 210
	     27 101 252 238 209 115 170 177 227 218 82 66 53 242 133 0 144 107 25 152 207 11 0 58 19 115 220 145 4 128 242 237 102 241 127 192 249 152 234 210 10 155 253 140 159 127 182 201 102 103 64 62 21 154 189 183 177 51 76 0 48 12 227 12 92 150 114 87 203 185 8 36 34 13 142 73 10 153 77 110 11 194
	     152 238 106 20 91 91 65 132 229 4 238 223 169 177 222 74 248 242 81 202 100 48 36 174 123 226 100 119 85 228 163 59 177 123 59 191 122 130 207 45 64 228 35 240 158 56 46 206 82 142 198 99 218 157 54 205 86 155 118 183 79 171 221 226 233 243 231 180 58 29 24 141 32 138 139 93 59 231 193 251 242
	     204 172 238 16 62 142 242 87 188 148 224 245 69 99 134 87 202 94 87 233 8 87 78 47 130 7 28 138 63 35 211 178 103 88 152 117 87 145 40 6 231 16 239 112 78 64 203 42 227 162 167 52 238 39 188 174 198 11 198 140 11 213 227 131 16 112 16 85 8 62 208 232 14 249 245 231 79 216 220 106 19 19 168 68
	     25 18 114 8 123 9 0 39 183 113 21 71 142 195 85 150 33 174 210 108 247 217 236 167 80 93 2 137 8 65 202 90 26 54 102 7 222 60 92 132 196 9 253 73 206 103 207 26 12 134 67 170 113 76 236 28 78 181 104 5 170 97 94 122 161 172 26 80 36 126 204 189 212 97 25 0 211 35 0 162 10 222 227 42 53 6 41 60
	     111 246 104 244 134 101 17 71 138 162 162 98 169 66 134 9 0 134 97 156 137 95 46 224 60 1 79 154 193 56 85 178 92 80 155 221 198 52 184 41 29 144 154 192 173 37 184 125 35 162 22 43 146 103 101 55 128 87 235 188 105 185 167 26 230 28 171 60 20 191 111 119 123 124 249 232 9 143 190 122 76 171
	     221 38 203 115 198 217 184 232 227 94 173 149 149 151 203 84 237 112 120 209 37 185 232 113 248 43 197 93 190 43 39 11 127 142 6 200 2 132 210 30 179 28 162 24 23 69 184 56 154 229 138 231 211 199 139 93 215 203 18 69 6 4 23 87 80 9 180 135 57 221 81 131 71 235 13 188 6 156 100 101 208 152 239
	     49 232 39 9 242 202 29 103 45 133 7 231 81 113 100 42 197 253 59 169 227 240 133 80 33 86 209 231 80 188 3 18 70 105 206 147 230 128 141 86 23 135 224 117 214 211 99 199 16 73 153 206 179 125 44 160 56 42 182 179 101 223 78 129 91 22 10 4 148 229 105 8 174 16 113 82 245 164 120 114 137 9 33 20
	     71 235 108 220 12 19 0 12 195 56 125 159 165 168 52 163 206 19 16 38 105 96 52 201 201 178 104 251 8 154 97 204 185 168 75 14 174 47 69 172 214 98 106 137 47 119 60 95 242 33 197 178 168 159 136 224 188 67 156 195 121 15 226 152 164 25 227 225 136 222 160 197 112 56 100 125 115 147 71 79 159
	     178 177 177 65 222 235 23 69 218 34 143 36 30 226 100 206 33 211 99 93 11 11 181 78 160 212 92 246 5 69 74 1 64 1 77 65 132 16 2 46 4 52 228 136 134 34 213 216 9 142 109 225 169 56 173 98 150 116 25 44 220 249 136 128 146 165 25 164 19 200 198 115 173 36 247 155 7 39 21 0 230 142 146 76 207
	     151 196 49 84 235 72 82 45 204 49 159 22 96 13 123 172 94 198 12 231 80 132 52 85 38 89 198 48 205 40 84 228 178 209 162 200 30 250 139 204 229 245 187 185 203 187 88 10 240 160 158 126 101 38 166 43 219 205 198 30 124 89 1 80 44 248 55 76 0 48 12 227 140 28 22 196 161 206 145 41 12 199 19 6 195
	     49 227 137 71 19 59 59 104 236 237 178 214 125 196 205 181 21 174 95 159 208 207 28 105 200 8 196 179 205 10 217 109 101 59 157 166 83 48 172 89 90 171 131 200 57 188 143 8 170 12 71 99 154 205 6 143 158 60 101 171 217 162 211 234 48 156 140 138 60 134 106 209 254 79 157 236 74 245 63 122 144
	     39 187 196 8 227 20 3 232 61 23 169 115 244 17 167 197 223 22 199 125 94 68 154 15 2 52 39 100 138 132 28 205 51 72 98 36 138 113 206 35 81 33 0 4 45 118 18 139 215 116 22 167 93 88 227 157 22 133 19 196 71 40 14 124 92 4 137 7 182 116 59 5 1 96 250 237 236 40 211 180 46 235 180 8 165 141 208
	     1 94 80 121 52 167 16 2 136 42 224 226 82 184 41 31 35 123 173 245 50 215 34 214 45 188 230 220 161 56 57 64 0 144 185 251 138 243 115 247 23 11 254 13 19 0 12 195 56 173 155 220 142 179 161 69 128 175 174 72 31 204 2 116 6 35 90 157 62 253 235 17 55 151 19 243 66 175 188 189 108 51 239 142
	     172 84 99 30 220 187 65 115 8 143 54 187 12 7 19 130 8 222 29 118 75 56 157 224 95 188 39 137 60 65 28 121 150 49 24 14 25 141 58 140 39 19 214 183 26 52 219 45 30 61 121 66 167 217 130 241 4 226 24 169 85 145 234 118 90 203 139 236 184 154 47 109 28 221 24 2 4 69 53 71 131 64 200 145 56 199
	     71 101 128 225 138 157 62 71 153 144 85 214 60 8 187 132 51 227 220 199 255 243 67 229 203 110 16 36 224 230 58 71 236 203 113 3 190 176 199 251 203 246 49 148 160 118 251 62 214 60 158 6 235 190 140 108 220 238 235 186 235 154 187 185 44 127 153 19 184 117 78 4 56 96 108 231 110 135 82 126
	     6 13 193 38 188 97 2 128 97 24 167 227 161 206 170 215 78 83 202 116 218 194 168 220 66 117 17 57 48 24 77 232 246 250 12 71 21 130 198 47 30 172 29 181 153 177 113 110 34 25 153 237 68 150 3 38 50 59 223 56 29 194 229 90 194 221 155 215 120 214 204 217 104 15 73 211 49 68 209 172 16 210 238
	     151 157 246 69 47 119 201 84 15 143 108 100 33 0 210 210 94 29 120 31 81 173 86 9 10 221 113 74 163 213 225 201 179 231 244 122 125 182 154 77 198 121 70 127 56 44 138 175 37 9 68 81 185 145 163 229 235 202 65 245 7 143 229 122 191 212 114 107 122 57 108 236 202 68 182 179 160 98 110 7 49 207
	     80 13 228 121 142 228 161 8 20 163 24 231 4 231 252 118 91 185 105 175 128 249 34 136 178 247 53 21 217 254 71 221 115 167 89 15 142 90 95 186 209 202 49 254 253 136 31 93 207 153 133 207 239 30 135 163 124 198 240 98 215 117 215 49 166 5 177 223 130 202 99 94 218 48 231 43 237 115 191 210 176
	     207 125 100 161 101 232 126 99 59 151 90 103 163 99 152 0 96 24 198 25 58 96 11 201 220 197 65 106 196 71 228 154 211 27 78 104 117 251 12 135 75 168 174 216 165 187 82 204 239 92 236 246 180 231 253 237 138 19 238 220 168 114 247 214 10 159 61 221 128 60 71 124 62 235 141 188 191 167 46 199
	     176 217 237 207 81 244 180 134 162 217 82 113 70 51 237 245 25 12 70 108 53 154 60 223 220 228 139 71 95 209 239 245 153 244 251 144 20 149 253 165 82 217 22 46 202 186 1 186 235 111 60 94 16 180 171 250 183 25 206 233 41 24 23 224 98 158 40 115 100 71 188 155 67 86 212 4 208 60 47 236 116 218
	     134 50 214 237 93 69 149 93 51 79 143 116 241 244 136 23 215 189 162 113 151 19 252 251 69 50 113 61 161 93 235 25 79 55 83 223 79 182 70 233 193 143 213 163 250 93 23 119 205 51 12 19 0 12 227 34 199 118 123 221 123 68 65 4 167 158 16 2 195 209 152 193 64 24 79 38 32 214 3 253 170 155 203 252
	     241 199 233 209 196 105 93 226 165 4 86 87 28 213 8 132 28 209 66 0 152 101 149 188 224 39 152 223 187 114 222 19 71 197 153 218 128 210 106 119 105 52 154 108 108 108 177 209 108 50 24 141 233 244 250 228 233 164 120 66 40 118 250 85 66 145 98 109 190 150 241 202 99 10 157 11 24 138 118 128
	     132 0 100 168 42 193 249 162 78 128 247 16 71 56 231 103 243 72 129 160 243 193 134 20 21 196 205 178 13 195 48 12 19 0 12 195 216 43 152 146 93 206 232 226 67 28 65 133 144 5 198 105 198 36 207 9 57 168 183 125 131 171 23 169 200 110 5 96 206 10 166 223 121 96 169 10 107 203 21 86 235 85 38
	     56 208 12 197 149 193 201 110 17 224 168 187 167 69 168 36 219 223 231 1 37 144 101 19 210 60 103 99 107 139 175 190 124 196 211 103 207 233 244 251 184 40 66 67 192 197 49 26 199 204 75 87 86 93 221 56 47 235 240 238 18 24 69 187 64 130 18 200 32 228 69 151 0 20 231 181 16 1 100 59 15 64 203
	     110 27 178 80 136 242 74 154 248 66 129 117 195 48 12 195 4 0 195 48 22 157 207 125 113 20 231 178 133 44 11 76 178 156 73 22 72 131 152 159 117 21 131 255 35 90 146 3 86 106 21 238 220 188 198 237 205 156 230 96 72 127 50 1 60 206 11 42 238 192 83 173 59 146 126 203 8 70 161 108 233 231 112
	     206 23 173 253 128 225 104 196 160 215 99 171 217 164 63 28 241 124 125 147 167 207 159 211 239 116 8 147 49 33 73 192 71 32 14 113 178 251 8 166 97 156 199 249 54 223 99 92 129 140 226 136 128 230 104 20 161 62 66 124 140 224 240 78 102 157 47 22 14 200 236 153 65 47 101 39 2 213 253 238 1 202
	     225 7 233 79 107 213 151 23 248 247 157 61 212 183 75 34 216 29 201 48 12 195 4 0 195 48 246 119 174 246 61 22 90 110 73 73 177 171 36 34 132 28 210 172 40 158 174 149 157 93 207 142 221 201 219 124 180 139 101 39 139 191 57 96 252 2 144 68 49 175 221 190 193 189 22 100 207 54 24 14 71 4 81 196
	     199 40 58 203 2 144 5 3 212 121 147 156 251 166 200 220 47 158 165 101 49 194 160 208 233 13 104 110 53 248 242 241 35 90 189 30 189 222 128 241 120 12 73 140 139 125 209 202 18 202 246 126 115 209 194 94 6 168 102 148 198 171 138 249 101 255 105 39 0 249 76 4 208 144 146 251 24 23 21 243 73
	     156 159 205 11 102 71 109 100 183 157 235 118 240 127 188 133 248 197 106 99 156 77 240 63 253 247 176 255 115 76 228 51 12 195 48 1 192 48 140 67 220 169 29 17 189 150 14 165 204 190 52 192 120 12 131 81 32 93 118 196 98 113 188 177 55 245 24 222 184 85 161 61 88 161 215 221 98 99 99 140 18
	     35 81 21 113 148 59 156 178 109 97 211 30 234 232 236 255 34 197 33 21 231 34 98 95 156 57 201 66 206 112 52 162 219 239 51 28 142 121 190 190 73 179 217 226 217 198 58 163 254 0 205 114 136 60 82 22 251 155 190 207 172 96 129 5 6 198 197 80 4 22 126 12 133 45 103 64 16 200 3 33 40 46 202 17
	     141 139 2 129 145 47 186 114 148 29 53 142 210 226 125 199 188 219 85 227 76 231 31 120 78 175 145 221 129 12 195 48 76 0 48 12 227 244 133 1 4 113 66 16 33 77 3 195 97 202 56 139 112 137 77 116 99 111 18 129 107 85 184 115 77 88 169 41 177 11 132 60 71 9 135 158 75 222 110 87 38 168 8 226 61
	     73 146 16 66 206 112 60 166 217 110 241 229 163 199 180 90 29 26 141 22 105 30 152 76 50 196 123 212 57 144 226 121 243 109 6 231 109 217 52 0 227 98 104 0 11 187 238 243 2 86 80 200 210 162 109 96 8 69 199 0 39 136 3 143 155 237 217 235 156 181 79 55 255 117 15 235 151 237 230 130 251 222 5 206
	     227 157 9 44 113 199 48 12 195 4 0 195 48 206 192 207 18 112 14 21 24 142 83 58 221 17 221 235 9 81 236 137 204 249 186 2 113 136 46 152 131 28 234 150 75 41 2 220 92 245 220 191 185 194 147 235 125 90 189 140 97 200 200 213 161 62 153 43 65 89 158 121 46 143 154 68 206 33 206 3 138 138 48 74
	     39 244 70 3 250 253 62 141 70 139 70 187 201 151 143 30 211 109 119 200 251 67 72 42 72 82 69 226 120 251 21 23 63 243 174 239 76 2 48 46 224 58 188 61 43 33 207 81 205 139 2 129 161 56 90 227 189 7 95 206 37 28 78 10 65 172 152 95 187 139 2 234 44 252 95 44 141 97 243 195 48 12 195 48 1 192
	     48 174 92 160 55 239 10 78 235 167 141 210 9 157 193 128 222 160 202 202 82 21 188 176 189 95 187 151 115 57 253 110 49 32 115 118 193 47 123 188 2 212 227 132 123 183 111 242 122 35 128 107 49 108 13 201 243 9 78 34 240 110 187 200 159 150 245 249 69 112 81 68 82 73 200 21 242 44 167 219 104
	     242 108 99 157 103 235 27 52 155 29 178 60 167 215 27 146 7 133 56 70 74 113 74 167 34 194 158 159 198 236 205 184 232 11 244 220 196 154 254 160 64 158 151 89 1 129 16 121 112 57 120 135 243 17 206 21 5 48 153 22 10 92 92 172 103 75 179 204 205 157 80 254 202 196 50 195 48 12 195 4 0 195 184
	     178 20 85 215 3 131 209 132 102 183 71 167 95 229 206 205 4 202 106 236 230 34 26 123 197 43 177 56 238 222 88 226 225 27 202 56 75 121 222 236 145 167 1 31 135 178 112 89 145 81 32 174 12 208 69 72 211 140 60 40 189 225 128 209 104 204 227 39 79 249 226 209 35 182 214 55 72 7 67 36 169 33 222
	     225 146 42 84 202 32 69 203 4 102 61 32 145 57 204 7 80 134 113 193 145 185 153 22 114 200 3 26 114 112 25 56 143 198 49 226 3 226 35 212 59 68 5 112 197 78 191 28 167 69 160 179 21 222 48 12 195 48 1 192 48 174 76 16 167 224 68 10 135 18 24 12 51 90 157 1 221 254 144 44 172 89 71 53 99 223
	     184 68 128 138 135 100 201 241 198 107 53 158 111 197 56 9 16 2 144 79 195 127 92 20 17 121 79 0 178 60 208 237 180 233 247 7 60 125 254 156 110 191 79 163 221 166 209 106 19 70 147 34 192 15 57 234 138 8 70 68 174 102 175 115 195 152 6 255 211 133 90 129 60 148 255 247 132 16 192 231 136 79
	     32 138 192 57 156 47 102 166 82 102 4 236 74 9 216 111 69 159 207 160 9 231 108 181 145 115 250 217 12 195 48 76 0 48 12 227 66 134 114 133 51 232 196 161 154 51 158 100 116 7 48 24 77 200 130 57 91 87 194 10 246 56 243 63 127 92 100 241 223 101 33 172 16 96 165 174 220 88 141 185 182 178 68
	     166 99 2 57 74 142 136 71 81 38 121 198 112 156 50 153 140 121 250 124 157 198 86 131 39 79 158 210 31 14 200 114 69 17 164 94 47 139 251 233 158 159 99 175 207 163 115 71 12 22 99 38 195 120 121 113 186 78 141 243 212 98 254 217 100 155 126 179 227 32 127 14 185 22 34 64 174 144 7 92 28 21 125
	     55 156 67 194 180 84 96 241 132 128 162 185 2 174 108 251 234 118 118 137 221 241 158 231 73 246 149 125 239 89 134 97 24 134 9 0 134 97 188 144 143 229 9 154 209 31 165 120 38 116 6 67 82 221 174 49 173 71 123 145 5 47 214 114 177 47 181 201 76 5 0 129 229 106 204 27 247 110 240 78 83 240 79
	     91 108 116 250 164 33 197 69 17 195 113 74 187 211 99 125 115 147 254 96 200 243 141 117 186 189 30 189 78 7 178 34 157 121 86 229 92 196 220 123 195 56 76 104 128 162 117 32 90 108 138 107 142 18 17 114 15 206 227 162 8 17 87 28 237 18 8 89 6 105 6 8 26 87 145 216 205 197 210 122 193 98 234
	     253 106 23 232 62 247 34 195 48 12 195 4 0 195 48 118 59 84 2 26 132 60 15 164 89 206 56 205 153 228 58 75 184 212 3 67 126 115 184 46 69 108 49 63 182 71 216 201 156 207 4 200 51 184 182 82 231 205 123 158 225 56 103 171 221 33 77 51 8 66 187 59 226 217 250 6 95 61 126 74 127 208 167 63 232
	     19 84 241 149 10 90 169 148 175 86 22 250 219 243 141 116 247 231 52 149 192 56 87 75 168 28 227 161 101 123 187 163 156 109 81 217 123 213 221 145 25 80 8 1 154 41 80 20 8 12 26 112 145 71 156 130 10 94 41 179 107 132 160 1 209 233 1 1 217 115 142 157 31 194 238 191 95 119 126 102 217 35 141
	     65 197 238 73 134 97 24 38 0 24 134 113 132 112 78 200 85 153 228 74 127 12 173 30 244 151 161 38 22 226 27 7 139 0 177 23 110 70 240 240 126 149 78 183 194 47 127 211 103 227 105 147 126 6 235 173 33 91 173 46 155 91 13 210 209 184 80 11 98 15 113 82 20 251 43 207 44 43 22 217 27 198 145 209
	     50 224 87 55 59 22 160 42 16 60 26 114 36 115 164 165 68 183 182 186 202 181 59 119 152 40 108 109 110 49 106 52 33 73 160 94 47 91 114 110 171 10 186 40 54 24 134 97 24 134 9 0 134 113 193 131 182 114 119 100 59 3 180 12 189 68 112 222 227 60 100 193 49 28 9 195 12 146 24 98 187 108 87 34 152
	     63 41 94 10 27 169 68 129 74 148 145 167 67 54 55 215 217 104 15 217 236 165 228 42 69 145 178 106 133 16 162 162 239 164 8 170 66 216 241 206 115 121 5 150 209 107 92 202 184 253 20 68 46 157 159 24 58 247 179 20 71 3 242 64 8 160 233 24 66 198 210 205 107 188 117 255 14 195 60 208 221 122
	     206 168 185 9 75 75 80 137 112 26 21 34 128 56 84 167 123 238 2 50 237 184 97 19 208 48 12 195 48 1 192 48 46 111 16 24 121 112 142 225 88 216 108 142 185 115 173 66 253 26 36 230 3 26 135 220 16 4 88 173 192 155 175 213 120 243 222 117 254 231 175 62 103 253 209 151 116 155 3 184 118 27 234
	     75 136 128 68 209 142 118 126 182 231 111 24 39 90 173 23 102 143 22 249 240 26 96 50 70 201 137 61 220 88 171 243 71 31 222 227 7 63 120 23 39 202 63 46 143 248 201 178 210 29 165 140 66 198 96 60 98 162 16 92 132 139 42 56 231 9 56 20 199 118 119 128 243 52 75 117 159 223 217 77 202 48 12 195
	     4 0 195 48 246 118 159 118 237 64 73 217 175 221 129 120 130 64 154 7 70 163 148 209 56 35 15 17 248 221 110 214 65 149 226 141 171 21 134 204 190 87 225 238 237 85 222 127 251 13 110 223 248 28 29 15 209 110 15 86 111 224 125 153 154 92 6 255 174 180 168 176 223 171 138 41 4 198 149 90 152
	     167 139 233 225 115 78 138 221 126 213 133 0 88 4 9 160 227 49 232 132 234 218 50 111 222 185 205 215 222 185 203 183 222 93 227 70 61 226 237 27 223 224 238 221 91 252 236 151 127 224 87 191 251 146 70 187 85 20 227 140 18 194 234 13 92 101 169 40 204 233 202 163 5 186 99 213 127 245 193 255
	     194 229 41 74 2 216 253 199 48 12 195 4 0 195 48 78 224 90 9 72 49 181 7 227 140 70 187 67 171 29 147 94 95 70 188 179 11 100 28 42 2 120 17 174 185 152 175 191 247 58 223 253 218 123 252 252 151 191 166 219 75 17 15 26 82 52 40 78 182 123 123 219 185 127 195 56 141 153 87 18 2 101 238 63 145
	     87 62 126 243 54 127 241 71 31 243 239 190 255 46 95 123 99 153 138 23 62 186 126 159 143 30 220 226 127 220 93 229 191 173 56 126 243 197 115 214 59 99 90 195 156 84 96 156 143 73 67 14 46 42 90 10 206 164 58 195 48 12 195 4 0 195 48 46 89 240 15 226 60 234 96 156 6 186 253 33 131 225 136 16
	     234 108 167 130 206 185 158 182 235 127 217 140 96 223 184 226 168 120 41 44 229 198 106 194 219 111 223 225 193 91 15 248 195 122 143 92 148 48 26 64 20 35 62 222 182 57 11 43 12 227 216 115 110 59 251 74 230 164 180 242 88 141 228 160 129 200 11 111 222 189 198 119 191 246 128 143 223 184
	     206 106 92 172 225 149 68 120 231 86 21 249 218 27 44 47 11 159 172 119 248 229 87 67 126 246 251 39 252 230 243 71 164 141 13 16 7 181 101 88 90 66 226 90 145 5 160 69 71 1 125 129 245 225 128 63 104 122 83 49 59 48 12 195 48 1 192 48 140 151 71 113 4 64 5 134 147 148 118 183 79 187 87 35 205
	     214 108 202 27 71 19 0 202 255 87 34 248 248 157 219 252 235 63 249 6 157 73 206 239 63 255 146 198 102 7 234 203 69 122 177 56 152 85 254 55 12 227 69 162 106 1 8 25 154 142 17 175 220 184 177 194 59 247 111 240 131 175 63 228 91 239 221 97 53 113 4 182 219 118 198 192 59 55 235 220 93 125
	     72 103 18 248 197 70 224 225 207 190 224 175 170 202 239 62 15 116 134 41 99 205 201 242 17 185 128 226 74 193 183 168 11 160 150 114 111 24 134 97 2 128 97 24 23 197 169 212 131 5 0 87 244 149 158 164 25 93 205 232 246 71 140 115 11 211 44 254 56 222 75 196 14 222 191 187 202 224 187 31 240
	     213 102 131 231 143 62 167 209 105 64 20 65 82 67 69 8 106 135 252 13 155 111 179 31 118 245 179 63 90 134 76 209 189 37 130 193 0 26 207 209 196 113 239 193 135 252 201 119 191 193 31 127 251 3 238 221 92 153 9 115 89 249 170 17 16 123 71 205 39 220 172 66 117 21 94 171 190 205 27 215 149 95
	     124 246 26 191 248 108 131 95 125 246 140 71 207 183 200 135 19 168 212 97 121 13 226 74 81 40 86 124 113 212 96 190 107 199 11 220 121 166 59 255 211 172 178 83 233 148 96 24 134 97 152 0 96 24 198 33 142 36 20 59 179 2 185 194 56 205 25 140 115 186 195 156 236 90 49 233 247 170 181 108 197
	     0 141 189 66 151 101 129 15 94 95 227 251 31 63 224 55 255 114 131 245 175 158 19 60 100 121 74 40 219 0 98 199 0 12 99 143 208 249 56 243 66 81 13 136 166 72 62 98 173 82 231 235 239 190 206 15 191 247 117 62 124 253 214 236 149 132 237 12 157 105 232 30 202 175 53 96 229 78 133 215 175 189
	     195 119 63 120 157 191 251 213 58 255 185 250 51 254 49 31 240 124 125 72 22 229 228 162 228 4 130 230 219 13 7 100 199 141 128 3 139 119 218 173 193 48 12 195 4 0 195 48 206 167 243 169 101 138 103 174 48 28 231 116 250 57 253 28 86 253 206 64 207 252 57 99 63 92 105 31 183 234 17 127 244 245
	     119 120 250 248 59 172 183 39 60 221 108 210 104 54 161 186 132 212 87 193 57 108 179 207 48 166 179 102 126 133 61 194 196 16 129 124 66 24 14 112 249 132 149 219 55 248 240 189 55 248 241 119 63 226 219 31 221 227 78 189 216 245 15 101 240 63 47 43 76 187 111 120 138 35 1 196 142 229 184 202
	     189 165 42 203 203 203 92 175 194 251 111 44 241 47 95 109 242 104 107 194 87 235 67 54 219 125 116 52 41 142 241 44 45 33 113 101 187 35 193 180 6 129 221 25 12 195 48 76 0 48 12 227 213 5 243 59 83 42 247 72 211 156 219 177 159 62 70 1 231 29 94 35 210 92 233 246 39 116 250 129 234 138 35 145
	     109 247 116 234 234 217 174 191 193 156 61 204 19 128 215 214 234 252 232 123 95 231 243 103 125 254 251 223 253 51 237 39 155 4 231 144 250 18 34 30 85 33 88 22 128 97 44 8 0 7 205 177 178 29 158 83 116 146 194 160 71 181 30 243 201 251 239 242 163 239 125 202 39 239 61 96 37 9 168 186 93 147
	     82 14 8 209 167 119 137 27 85 248 227 143 95 231 131 55 111 240 209 214 128 159 252 106 147 255 246 247 191 37 31 14 233 183 187 4 231 160 234 75 79 48 66 197 145 139 32 58 61 202 176 45 53 204 23 44 60 76 27 176 212 127 195 48 12 19 0 12 195 120 69 190 167 72 132 243 69 45 128 205 70 151 205
	     235 53 150 171 117 146 100 187 230 180 133 253 198 126 65 132 204 5 27 183 43 142 239 125 112 143 167 63 250 22 227 209 128 205 205 22 157 28 178 116 8 33 67 124 130 88 65 64 195 102 206 66 152 126 136 8 16 20 52 131 108 130 230 41 55 111 92 231 199 63 248 148 255 240 167 223 230 27 239 220
	     165 158 236 220 143 63 108 205 214 185 199 220 140 60 55 215 234 188 185 86 231 173 251 55 121 112 243 14 55 171 158 207 222 92 226 151 159 95 99 171 211 99 171 51 166 55 238 144 230 130 250 4 226 42 226 171 54 143 13 195 48 76 0 48 12 227 85 58 148 170 123 57 151 187 92 201 93 142 167 136 32
	     226 200 242 192 112 48 162 55 24 144 230 9 101 178 232 225 239 92 190 177 101 7 92 130 88 4 142 165 246 236 21 112 196 4 222 120 109 149 79 62 124 200 111 63 91 231 243 231 155 108 54 218 228 46 193 213 99 156 115 4 157 182 49 91 120 115 53 27 50 46 24 71 177 97 93 248 225 136 173 240 116 214
	     250 47 131 60 7 205 137 98 207 245 107 75 188 253 224 6 111 223 91 101 37 46 27 4 30 163 181 167 236 241 176 0 84 128 119 110 68 36 223 122 131 239 189 123 157 159 126 209 229 151 191 127 196 95 253 195 47 104 55 26 132 52 39 196 53 88 118 104 92 45 255 12 41 255 102 45 255 30 221 243 253 23
	     139 254 89 17 64 195 48 12 19 0 12 195 56 245 72 238 104 207 241 222 225 157 103 48 26 243 188 209 226 214 245 136 55 238 45 113 187 22 219 37 53 142 45 6 68 145 227 189 251 171 184 240 62 157 254 136 127 248 233 47 249 155 127 236 208 155 76 112 121 6 34 83 233 201 46 154 97 107 245 97 143
	     19 37 164 41 140 251 44 215 35 222 121 255 33 255 246 143 62 225 143 62 121 147 7 215 235 196 101 240 174 108 87 22 144 125 222 73 22 190 159 254 91 94 126 95 1 222 168 122 222 120 112 3 184 193 251 239 194 47 94 191 70 69 198 252 246 203 26 143 91 99 54 250 25 253 20 134 233 0 240 168 139 144
	     178 117 96 144 35 168 15 134 97 24 134 9 0 134 97 188 36 151 83 119 38 134 206 118 129 164 168 31 48 153 164 180 242 140 78 175 70 150 103 71 118 85 109 231 223 2 255 249 164 98 7 172 213 99 30 222 89 229 147 247 238 242 248 249 83 156 0 105 10 73 74 112 30 156 195 149 155 150 106 103 76 140
	     171 57 105 14 127 152 20 53 90 116 50 68 215 215 137 94 191 201 199 31 190 197 143 190 247 9 239 220 190 54 11 248 29 219 137 7 114 130 143 225 203 140 156 197 181 252 102 5 62 122 227 26 195 31 124 196 71 31 221 231 151 95 13 249 251 95 61 227 151 191 253 140 176 190 9 181 42 84 151 209 56 193
	     37 201 44 95 161 184 223 236 252 64 139 27 253 186 199 253 195 178 1 12 195 48 76 0 48 12 227 116 37 128 3 2 120 97 156 230 164 163 33 141 238 136 206 56 103 76 177 35 100 46 153 113 116 11 83 20 161 10 188 182 154 240 237 143 238 211 239 182 249 226 139 231 252 254 203 117 54 251 25 89 58 196
	     37 53 16 63 203 158 54 27 51 76 1 216 253 8 201 115 130 230 136 83 88 173 240 241 251 247 249 143 127 246 45 254 236 91 15 185 30 57 38 115 14 218 11 105 104 34 136 42 50 119 52 33 0 53 224 173 107 53 110 124 235 33 105 80 126 190 161 220 190 254 5 53 6 252 156 17 26 37 140 53 160 146 146 107
	     145 1 160 234 9 69 213 66 116 87 183 131 249 31 143 118 12 194 48 12 195 48 1 192 48 140 253 130 251 69 63 106 207 243 212 123 36 132 74 209 167 189 104 7 168 140 83 97 48 118 140 202 201 47 216 6 237 21 143 69 142 245 66 133 235 15 56 225 245 155 171 252 232 107 111 243 248 89 151 222 232 39
	     172 255 227 47 33 19 244 254 235 120 87 65 243 180 216 121 84 57 162 16 112 152 77 27 198 203 94 122 79 48 129 14 12 126 139 140 44 1 194 168 11 157 38 190 38 188 245 246 155 252 233 15 190 205 119 62 122 192 141 216 207 230 217 97 9 52 123 206 152 185 157 246 233 123 237 245 188 168 156 199
	     215 92 225 6 190 127 23 248 230 61 174 251 143 121 112 103 137 199 27 125 126 245 229 6 141 118 135 73 127 12 62 129 229 21 72 170 72 84 69 92 84 188 151 42 219 7 21 246 186 21 157 116 17 210 61 74 48 216 221 202 48 12 195 4 0 195 184 74 34 192 177 162 186 237 150 77 138 195 199 17 226 170 164
	     26 209 236 40 205 30 248 37 165 110 14 149 113 140 224 127 234 234 3 44 123 199 71 111 220 225 63 252 171 111 211 30 246 249 252 119 159 211 104 12 240 4 116 218 181 92 29 34 199 9 227 197 130 127 227 82 227 80 4 69 67 138 166 3 94 127 235 1 255 203 191 254 33 255 247 191 252 99 222 189 177
	     68 30 192 59 118 236 175 191 248 20 222 189 206 79 107 3 76 191 214 34 248 254 27 75 124 124 235 235 124 251 27 239 240 147 159 125 197 255 254 55 191 224 15 143 159 241 229 147 17 185 228 168 207 193 7 50 31 200 209 114 138 134 185 87 217 57 143 117 94 16 121 41 247 61 195 48 12 195 4 0 195
	     184 196 90 128 44 244 99 222 121 198 114 246 32 84 4 113 17 142 152 52 135 118 55 165 217 83 86 171 176 100 43 128 113 76 41 96 106 101 49 128 247 124 252 206 109 254 226 207 191 193 111 191 220 228 191 254 237 175 24 54 55 17 141 224 250 13 92 146 64 200 177 227 191 198 149 15 252 29 72 8 132
	     209 8 73 199 160 57 201 245 235 124 227 107 31 242 103 127 252 117 62 125 251 58 117 129 108 38 20 28 243 182 160 39 147 217 166 153 6 117 192 69 194 210 114 149 107 203 85 86 147 132 216 5 30 63 187 197 79 190 124 206 70 115 196 31 158 247 105 180 187 144 181 33 170 64 117 9 146 24 164 232
	     56 51 223 4 193 48 12 195 48 1 192 48 140 87 166 23 8 72 140 72 206 56 205 105 116 186 52 91 21 238 44 215 184 190 108 221 0 140 227 9 0 139 251 112 21 129 31 126 244 38 173 255 199 95 146 230 9 127 253 159 255 43 195 118 27 127 125 21 231 64 195 118 160 17 236 18 26 151 126 146 236 222 169
	     118 76 79 205 103 228 217 16 157 12 185 125 231 6 31 190 251 54 255 230 71 223 229 147 119 110 83 47 35 126 127 130 130 127 187 63 194 225 207 246 236 62 98 48 47 238 61 188 179 194 234 15 63 34 157 164 124 99 163 199 47 126 183 201 127 250 171 95 240 139 209 151 180 7 29 72 71 68 85 143 243
	     82 118 253 112 168 74 153 15 160 214 9 196 48 12 195 4 0 195 48 94 237 76 143 32 84 24 78 148 141 173 54 155 107 158 135 119 34 4 19 0 140 147 49 13 30 18 96 41 142 249 243 111 189 205 230 86 143 246 243 175 248 199 255 249 27 194 168 143 78 114 52 169 66 148 32 90 4 65 38 2 24 87 71 12 40 123
	     103 104 32 164 19 66 58 134 108 140 243 194 135 15 239 242 151 63 254 38 255 234 187 239 243 214 141 10 158 23 15 252 79 240 241 118 5 255 211 239 215 28 172 173 214 1 184 113 107 141 7 55 110 18 103 57 239 188 182 196 175 190 120 206 147 205 14 131 52 165 219 238 131 120 112 21 52 78 144 168
	     82 254 225 130 29 233 49 12 195 48 1 192 48 140 87 16 166 5 85 196 57 112 9 227 201 152 86 187 79 179 157 48 158 92 159 185 103 129 185 148 83 59 118 105 236 10 245 117 206 32 118 54 7 156 6 46 55 18 248 225 183 30 178 181 241 67 186 99 229 243 71 79 24 183 27 112 243 54 222 85 138 220 96 149
	     3 114 132 245 100 65 130 236 97 176 122 88 216 35 167 243 222 198 41 68 161 123 92 247 197 226 123 71 121 204 203 248 168 178 221 247 110 154 114 239 68 202 150 151 139 197 255 20 41 139 254 169 6 52 155 64 54 102 181 158 112 107 109 153 239 125 244 38 127 244 141 55 120 255 181 58 203 110 251
	     76 190 156 214 103 124 1 49 192 47 204 138 101 224 227 219 85 234 63 250 128 31 127 231 77 126 250 251 6 127 255 47 127 224 159 127 249 27 126 217 216 34 23 135 186 42 206 45 227 146 4 69 182 203 2 170 28 46 0 168 46 170 38 175 106 136 13 195 48 76 0 48 12 227 60 58 204 133 47 165 179 34 76 71
	     193 129 115 100 97 76 158 142 105 247 6 116 6 99 38 90 158 229 54 71 203 120 65 42 46 240 201 253 37 198 127 250 45 26 221 17 255 229 175 148 95 255 246 43 200 51 116 52 132 40 66 124 132 83 33 88 176 109 92 146 165 120 254 255 186 248 123 13 104 8 104 72 33 79 169 85 34 62 121 239 62 95 123
	     255 1 255 250 123 31 240 141 183 110 178 236 183 139 107 190 72 225 63 57 197 130 174 211 192 63 159 251 92 215 28 172 221 89 70 88 230 237 219 183 184 183 182 204 237 122 96 173 30 211 24 6 190 106 140 8 192 104 216 71 197 129 139 193 71 224 60 71 235 105 176 135 18 97 24 134 97 152 0 96 24
	     198 9 221 84 113 69 59 64 7 1 97 56 9 108 117 38 108 246 114 214 170 158 170 157 4 48 94 32 248 81 32 113 142 4 248 248 193 26 63 250 222 7 116 123 125 154 221 9 173 193 144 113 175 141 44 45 225 124 29 17 87 36 3 236 25 196 148 1 136 233 3 198 171 176 233 210 0 247 45 168 87 254 94 231 13 118
	     218 106 111 46 3 192 149 243 34 132 28 77 83 68 83 188 23 238 92 95 225 123 223 124 143 63 255 254 71 124 255 195 55 120 109 169 182 195 25 147 115 52 183 167 173 8 231 133 137 233 231 187 87 135 63 249 232 53 238 174 124 147 247 63 126 135 207 158 141 248 111 63 249 61 143 158 62 229 209 87
	     235 168 115 16 215 145 74 21 87 173 34 162 228 179 57 175 251 74 29 34 50 151 65 17 202 75 170 152 42 96 24 134 97 2 128 97 24 71 69 183 43 74 169 42 206 121 136 99 210 32 108 53 199 60 111 12 240 183 234 36 145 199 139 185 90 198 241 5 128 233 110 97 160 72 29 94 141 132 111 189 127 151 209
	     224 107 180 186 35 126 253 187 63 240 135 207 159 64 152 160 169 7 23 23 34 192 190 29 202 119 132 88 134 113 126 150 211 121 97 96 113 199 125 42 4 204 82 180 20 242 20 210 62 73 226 120 243 181 155 124 227 253 55 249 241 183 63 228 251 159 190 197 107 43 245 217 188 145 115 188 238 206 135
	     234 105 249 121 131 194 107 75 158 155 31 188 206 155 239 192 239 214 3 113 20 243 235 223 198 196 58 102 148 42 221 84 73 195 4 77 149 32 30 47 17 249 84 136 70 119 94 191 233 247 59 174 169 216 58 96 24 134 97 2 128 97 88 184 245 162 175 33 56 16 79 154 6 154 221 33 91 157 1 215 86 34 174
	     215 171 22 250 27 39 182 63 153 11 20 170 145 227 131 59 203 248 175 61 160 209 110 225 195 144 205 141 45 250 105 74 154 230 80 89 66 42 117 132 226 108 244 43 10 229 94 210 53 178 0 230 85 89 168 190 18 75 42 66 249 160 10 33 160 147 9 244 186 44 221 90 230 219 31 61 224 47 126 248 77 126
	     244 233 155 220 91 169 207 230 203 69 18 93 163 133 120 61 2 222 140 160 118 215 17 125 247 45 190 249 122 133 119 223 88 227 249 230 128 127 249 221 19 190 124 182 65 179 221 38 15 17 212 215 160 82 5 239 75 1 240 56 35 42 103 104 45 54 71 13 195 48 1 192 48 140 243 232 218 190 168 143 50 203
	     78 117 120 231 9 170 244 71 99 58 221 1 195 81 149 160 213 29 133 151 76 10 48 142 226 124 207 159 121 158 238 102 6 138 186 18 111 92 75 248 206 135 119 25 116 219 60 93 223 226 209 122 139 245 173 62 121 200 40 14 162 248 217 243 166 175 163 39 201 253 63 118 165 48 125 73 215 202 250 29 156
	     218 248 233 225 2 212 161 2 128 28 110 7 187 204 79 14 126 17 157 123 210 180 52 166 170 162 33 64 158 18 59 37 90 74 120 235 238 53 126 240 181 183 249 254 215 31 114 127 173 206 72 139 246 153 231 121 231 255 32 242 185 249 158 1 21 224 163 251 117 222 127 237 109 238 222 191 197 151 79 187
	     68 222 19 51 225 119 233 136 206 72 241 145 146 150 179 93 103 233 253 59 111 54 170 71 25 217 211 152 163 175 74 46 50 12 195 48 1 192 48 140 151 234 104 23 71 0 156 139 153 76 70 108 53 186 60 175 11 175 223 169 19 116 5 144 93 69 172 12 227 184 161 245 244 252 243 114 45 225 59 239 221 167
	     42 202 36 203 249 201 47 62 231 127 252 243 231 180 7 41 26 122 16 199 184 56 65 164 16 164 244 210 92 1 22 100 17 227 85 141 192 203 68 160 168 246 31 2 164 35 232 119 168 175 85 248 244 227 247 248 183 223 251 128 191 252 222 7 188 123 111 21 39 66 101 46 12 189 72 107 237 244 179 122 182
	     143 252 196 20 147 126 197 57 136 28 107 247 215 120 227 218 10 85 201 120 247 126 157 159 254 254 14 191 123 210 227 73 115 200 163 173 46 228 229 161 135 74 13 137 42 136 247 224 138 238 32 97 241 157 236 134 100 24 134 97 2 128 97 24 47 230 24 139 128 19 71 158 42 253 241 152 110 111 72 127
	     156 146 206 63 198 46 149 113 204 128 128 133 96 38 47 133 128 213 74 194 39 111 221 163 61 81 112 49 95 60 235 49 121 178 206 112 56 68 201 113 73 140 138 34 90 148 26 211 11 63 195 140 87 61 2 250 74 102 65 0 5 209 188 108 128 55 65 179 17 55 214 174 243 39 223 255 6 255 238 207 190 193 71
	     15 110 147 206 181 199 187 168 187 255 83 220 62 215 94 156 112 163 230 248 230 135 247 120 231 157 91 60 120 187 203 223 255 226 25 255 240 179 223 178 213 108 50 28 13 32 83 36 118 68 248 162 77 98 41 2 58 85 130 184 61 230 148 221 149 12 195 48 76 0 48 12 227 100 225 136 20 29 1 50 133 73
	     154 211 25 100 108 117 51 26 35 37 169 67 44 123 213 103 214 125 66 62 195 216 201 116 103 112 26 12 68 78 184 190 92 227 79 190 246 22 107 181 26 163 113 198 223 255 244 55 252 236 87 159 209 234 13 200 189 67 125 5 226 74 17 82 168 165 205 27 23 44 248 23 135 106 78 8 57 164 3 116 56 96 109
	     173 202 221 143 30 240 151 127 252 117 254 215 127 243 45 190 241 214 109 146 200 17 93 146 224 127 63 25 4 138 227 0 21 47 44 175 84 81 170 220 91 89 226 238 205 53 94 91 241 220 89 141 120 186 217 226 139 167 77 50 113 116 6 61 210 9 40 49 18 39 16 39 197 61 74 229 37 88 139 97 24 134 9 0 134
	     97 92 54 103 120 161 206 145 43 255 31 80 212 57 36 138 9 226 233 140 148 70 87 89 138 224 70 101 175 83 174 135 30 140 53 174 138 93 77 207 59 31 208 115 124 87 112 35 176 150 68 124 235 225 109 122 163 143 136 35 165 177 217 162 221 123 138 142 6 104 4 146 84 11 199 63 167 56 8 44 102 99 198
	     41 133 115 251 214 123 147 19 188 242 66 206 139 120 196 21 118 171 26 144 116 2 189 54 183 222 88 227 207 127 248 77 254 159 255 230 187 124 243 173 219 196 209 78 89 213 93 210 85 84 246 184 107 172 196 142 143 239 214 89 251 254 67 30 62 184 197 239 191 106 243 183 63 253 45 143 158 61 231
	     87 237 199 132 225 4 124 2 75 215 240 149 26 42 30 205 117 225 114 235 254 67 166 167 106 45 134 97 24 38 0 24 134 113 25 157 101 1 23 225 147 10 41 17 155 173 148 47 31 119 168 249 21 214 110 198 236 244 85 205 89 50 78 22 4 192 118 54 128 40 44 87 99 126 248 241 3 86 107 49 147 193 136 164
	     154 240 217 163 77 218 157 33 26 199 224 60 56 143 56 111 86 103 156 127 35 87 133 144 161 121 14 147 17 100 99 174 47 39 172 220 124 157 255 240 39 159 242 191 254 251 31 240 131 247 238 177 20 57 178 185 185 112 89 131 255 249 59 198 124 22 80 162 112 59 22 110 222 93 225 253 91 171 60 122
	     235 54 111 220 168 241 155 207 62 231 214 114 196 179 86 159 199 91 67 58 105 74 232 119 80 34 136 99 240 30 196 21 9 1 182 32 24 134 97 152 0 96 24 198 73 220 178 233 183 130 56 15 81 66 154 59 90 157 1 27 91 45 238 93 119 232 245 85 112 110 209 211 181 203 103 20 214 176 239 206 252 98 166
	     72 145 7 48 125 180 43 191 89 173 198 124 255 189 251 244 254 236 155 100 81 66 127 252 47 180 183 62 135 110 19 124 130 91 189 134 139 60 33 207 9 23 205 236 100 143 15 172 150 201 240 202 2 244 3 150 192 23 193 149 243 64 81 66 54 130 241 8 6 3 152 140 184 243 214 67 126 248 157 143 248 127
	     255 229 183 249 238 135 175 179 92 26 190 155 127 238 229 185 147 236 121 185 23 143 144 57 217 126 84 37 134 232 70 66 229 107 247 249 224 141 58 111 189 125 159 207 158 13 248 63 255 233 247 252 228 215 191 103 248 236 9 184 24 174 223 128 122 141 40 138 17 231 201 115 69 145 66 8 16 171 84
	     99 24 134 97 2 128 97 24 39 112 144 61 226 33 35 167 211 31 176 217 84 90 157 10 105 190 76 53 114 187 2 57 107 105 102 156 52 14 219 41 33 41 113 228 249 238 71 15 200 227 10 147 113 14 4 182 154 45 90 173 1 18 70 132 113 142 184 8 196 219 5 52 206 103 16 156 103 16 38 184 124 76 228 114 214
	     110 47 83 173 93 227 95 255 224 99 254 151 191 248 33 223 253 240 46 75 78 200 22 130 255 171 130 155 19 11 116 238 14 146 1 177 194 27 171 49 247 87 239 240 224 181 219 124 217 201 168 85 107 44 39 41 191 78 50 186 163 64 86 17 134 217 16 242 33 65 226 66 20 112 69 70 128 5 255 134 97 24 38
	     0 24 134 113 136 19 198 142 0 108 174 145 147 115 100 65 25 13 39 180 186 74 171 151 50 12 176 114 168 75 103 24 251 133 251 7 4 77 128 43 31 115 179 94 225 199 159 60 32 206 3 183 111 174 242 47 191 248 3 255 245 239 127 78 103 208 134 145 34 215 110 224 106 43 168 82 180 85 51 187 51 206 129
	     93 139 247 69 177 191 81 31 70 125 188 23 110 93 91 230 71 223 121 159 247 223 187 199 127 248 254 39 124 253 147 55 88 241 59 237 222 219 138 128 0 201 244 155 178 210 127 189 38 172 212 18 42 223 127 147 143 238 71 252 203 103 111 240 251 47 91 252 225 171 77 126 250 155 47 25 118 251 32 81
	     145 17 80 169 23 181 2 156 47 206 4 232 124 38 128 173 15 134 97 24 38 0 24 134 185 172 59 124 34 153 115 197 116 186 39 171 14 197 161 42 228 65 233 143 114 154 253 192 74 5 42 110 103 200 47 71 12 242 140 11 136 30 197 152 94 44 248 151 5 87 61 0 75 2 223 121 255 46 215 174 45 243 218 181
	     53 218 221 62 191 250 236 75 26 79 154 228 249 4 210 49 34 197 174 159 206 231 17 200 49 63 255 75 187 142 54 55 78 182 88 157 193 209 9 61 253 49 21 41 206 252 19 50 200 198 84 189 240 218 237 53 62 121 247 117 254 195 159 126 147 239 124 237 109 222 191 125 141 24 37 47 87 220 233 153 255
	     93 47 123 132 98 154 23 33 168 63 238 144 204 15 203 52 35 32 10 240 222 173 10 111 221 124 155 79 223 185 207 47 191 106 242 87 127 255 107 70 221 14 143 37 163 63 202 193 43 147 144 149 199 0 116 38 32 216 61 201 48 12 195 4 0 195 48 246 117 218 10 87 84 119 56 100 82 252 206 121 210 28 26
	     157 1 143 215 123 44 213 86 184 179 20 145 152 99 101 156 129 214 144 151 65 145 115 112 99 169 194 141 165 10 43 181 42 19 205 121 253 103 175 241 95 255 230 103 60 105 52 209 141 46 44 175 18 173 172 162 56 242 96 103 127 141 87 19 240 58 113 132 124 140 246 187 16 82 136 224 254 235 175 241
	     111 190 255 17 63 248 250 219 252 199 63 254 132 123 215 151 103 207 201 185 218 59 255 135 9 7 83 97 164 202 116 49 40 174 212 173 235 17 119 175 215 185 89 17 30 220 174 241 235 71 13 254 231 103 155 108 182 134 60 218 108 51 25 119 139 171 90 173 33 149 106 33 16 150 247 53 203 1 48 12 195
	     48 1 192 48 140 61 188 175 217 46 172 110 255 67 20 197 136 87 6 195 49 155 141 54 183 215 28 55 42 43 36 145 223 225 88 89 232 101 156 6 126 15 81 224 206 106 194 15 190 249 30 75 203 215 105 116 38 140 255 229 127 210 105 53 9 105 130 228 117 68 124 81 89 220 218 3 26 47 53 88 13 8 138 104
	     64 66 6 147 1 177 207 89 189 126 135 79 62 120 200 15 127 240 117 190 243 222 29 110 44 87 9 28 253 188 191 92 17 59 214 185 242 253 123 253 205 139 247 151 28 136 115 229 253 55 110 114 235 214 10 31 108 141 185 241 47 143 248 201 207 127 207 112 208 167 53 25 146 165 99 66 16 8 30 39 74 16
	     65 241 204 23 30 181 100 28 195 48 12 19 0 12 195 216 215 17 5 159 36 168 100 108 181 6 124 230 50 86 150 132 251 55 234 212 35 63 115 210 204 159 50 78 55 176 42 82 128 167 71 3 174 215 98 254 232 157 27 188 126 235 6 113 148 242 222 235 43 252 213 223 254 79 62 127 218 164 219 217 34 248 24
	     191 180 76 46 9 59 75 11 90 151 10 179 165 179 176 0 65 200 65 3 228 19 178 209 144 56 134 234 181 58 31 189 125 143 239 124 253 61 254 248 155 31 241 239 126 240 33 247 151 252 14 155 182 50 117 199 27 187 233 117 155 58 164 171 94 88 93 170 240 198 82 133 119 110 174 112 123 117 133 135 55
	     19 62 126 125 141 47 158 183 248 252 201 38 235 173 30 173 65 151 81 14 68 85 212 87 144 40 65 202 92 55 171 13 96 24 134 97 2 128 97 92 121 138 141 152 157 7 0 208 162 181 146 23 135 136 48 154 164 116 122 57 253 241 132 160 186 195 185 22 83 2 174 142 55 174 47 255 109 167 59 129 107 85 229
	     91 31 222 227 246 218 26 89 238 216 252 47 127 67 251 209 239 33 169 145 215 106 32 97 187 46 64 8 219 2 192 188 125 47 110 191 46 110 7 158 97 139 56 227 36 139 147 188 176 201 158 68 6 154 238 72 235 174 38 243 174 168 75 16 20 13 1 77 83 104 55 113 43 21 238 188 246 58 223 253 198 71 252
	     233 247 63 226 227 7 55 185 86 41 42 253 71 123 125 46 61 196 230 174 194 210 34 135 23 6 157 94 30 153 91 7 166 117 66 130 194 27 43 17 209 135 247 120 253 206 26 159 61 29 240 79 191 252 130 127 252 217 175 104 108 53 9 105 128 106 64 18 135 196 149 226 85 148 66 217 86 45 254 191 104 25 54
	     215 13 195 48 76 0 48 140 43 228 105 239 237 164 57 71 192 49 76 3 205 126 198 243 198 144 245 126 202 106 189 130 215 162 143 179 197 254 198 89 8 0 211 154 0 211 10 225 215 19 97 237 238 53 190 118 103 141 122 252 125 34 153 240 255 139 115 158 181 71 100 94 233 77 134 224 18 84 162 178 14
	     152 55 159 254 138 218 206 105 199 116 179 215 212 12 13 1 167 19 200 115 86 235 49 82 185 197 167 239 221 227 251 223 252 136 127 255 227 239 241 39 31 223 97 201 11 222 21 106 211 180 221 159 179 161 57 209 221 104 177 93 232 244 255 75 2 75 117 207 221 218 53 194 157 53 158 62 84 222 186
	     189 204 107 75 202 79 174 39 124 185 53 98 107 8 157 81 32 157 12 9 8 206 251 98 93 40 11 5 170 221 185 12 195 48 76 0 48 140 43 233 108 45 236 114 137 8 34 69 186 164 106 40 54 225 124 225 52 13 39 208 232 6 186 107 176 18 65 36 251 120 221 134 113 10 65 215 226 151 115 66 228 132 143 30 92
	     231 255 246 151 223 37 94 169 240 127 252 237 175 249 213 175 190 132 70 15 93 170 67 82 131 250 50 206 11 154 107 185 137 44 123 87 148 55 140 67 214 196 105 161 63 17 37 75 51 24 13 201 39 3 24 143 137 223 120 141 135 239 188 199 191 249 241 215 248 206 167 111 242 193 155 215 89 139 119 86
	     178 216 145 246 111 38 248 66 235 193 244 122 78 69 103 17 112 197 127 184 22 193 167 111 94 99 41 249 128 123 15 110 241 147 223 53 249 135 95 61 163 241 251 175 8 173 13 240 142 176 178 10 149 26 82 169 32 226 139 100 142 233 160 204 213 190 217 63 3 196 48 12 195 4 0 195 48 46 185 195 165
	     64 174 16 37 85 92 12 173 158 242 217 163 14 75 149 152 119 110 87 169 36 22 249 27 103 199 126 187 166 119 87 171 220 252 248 77 238 191 118 139 219 55 111 242 191 121 199 111 255 240 132 81 8 244 198 41 18 134 100 26 225 196 227 240 132 93 251 136 134 113 148 53 80 11 27 212 20 66 78 194 24
	     159 4 86 215 150 168 184 101 190 255 237 15 248 163 239 127 159 255 248 199 15 121 235 122 133 106 180 29 252 79 131 84 219 249 63 221 123 210 126 25 30 75 64 125 173 202 253 229 215 249 244 173 123 124 240 238 136 219 107 191 231 70 37 240 197 35 232 143 50 242 88 72 195 132 52 207 201 130
	     7 98 156 243 179 58 3 166 100 27 134 97 152 0 96 24 87 195 169 18 129 57 23 104 231 102 105 225 2 59 31 35 78 232 13 83 158 111 117 120 227 78 149 112 43 97 62 205 218 92 167 43 226 129 191 98 20 136 156 16 185 136 15 239 172 146 253 224 35 234 100 252 247 159 252 129 95 253 238 9 63 251 205
	     103 208 220 4 137 201 175 221 130 234 74 153 242 59 173 9 16 182 95 105 118 22 120 49 156 56 103 127 180 113 44 251 224 144 17 61 212 192 165 216 103 22 231 208 144 17 58 29 24 180 193 229 44 173 174 242 225 195 55 121 243 245 219 252 197 31 125 202 39 31 62 228 225 157 37 150 132 93 193 191
	     153 210 97 227 163 123 94 22 57 193 133 139 0 156 16 187 136 90 12 159 62 72 112 233 91 188 117 203 241 243 71 175 241 217 163 45 190 120 212 224 243 39 27 76 218 93 144 8 174 221 134 165 213 178 213 96 121 158 77 117 174 244 132 137 134 134 97 152 0 96 24 198 149 8 234 22 203 47 57 156 79 64
	     148 225 104 192 86 179 205 102 179 194 240 222 18 84 106 168 22 181 186 204 183 53 94 86 240 16 216 238 165 254 201 189 235 220 249 183 223 229 189 135 111 241 127 252 183 159 226 195 152 175 30 63 161 211 75 113 30 50 23 208 233 94 174 150 101 196 204 167 191 50 2 192 73 94 65 208 82 23 10 56
	     50 68 114 226 154 227 198 245 21 222 123 243 13 254 47 127 246 29 190 241 241 59 124 231 225 45 86 106 85 18 118 22 169 179 93 255 211 28 177 163 221 89 194 194 171 221 137 224 218 195 53 190 253 122 157 71 195 135 252 244 15 155 252 245 63 252 134 213 36 231 15 95 140 232 143 20 141 114 114
	     151 147 42 32 174 124 39 157 230 125 96 119 53 195 48 76 0 48 12 227 138 56 98 139 78 143 67 156 160 146 51 206 114 58 253 140 102 123 68 119 24 96 13 130 236 110 188 102 110 147 113 86 200 156 0 16 1 222 59 94 95 91 166 254 245 101 98 7 215 175 85 248 217 111 159 241 79 191 254 146 39 141 14
	     147 173 173 98 71 183 82 133 74 13 31 71 168 42 33 104 209 25 124 177 89 192 81 141 119 122 62 88 204 218 47 11 206 129 6 69 243 12 77 39 208 110 17 72 137 86 151 248 224 157 15 249 147 111 188 195 135 111 221 230 207 191 251 17 15 223 188 195 117 127 248 234 105 28 54 155 245 133 95 97 199
	     49 126 41 4 152 170 64 53 241 172 38 158 219 203 85 174 45 47 177 156 8 239 61 88 230 103 159 61 224 87 95 53 248 221 211 14 141 102 3 82 32 137 209 106 21 151 212 16 157 138 134 199 248 28 86 55 192 48 12 19 0 12 195 184 108 142 90 64 80 231 200 113 116 122 25 79 54 199 220 92 173 81 79 132
	     165 72 102 237 153 204 1 54 206 50 92 128 157 59 172 211 152 125 197 195 247 222 191 199 219 247 174 243 157 111 141 120 253 111 126 201 95 253 221 79 248 245 240 119 140 211 148 128 67 213 35 34 228 34 56 157 238 242 202 252 1 24 227 42 5 252 51 11 82 166 90 144 151 28 52 195 145 145 166 125
	     170 181 136 15 222 121 131 255 235 191 253 17 255 254 199 31 114 119 37 230 222 106 149 138 223 157 43 101 29 230 95 237 218 176 95 23 207 28 120 173 234 249 227 15 239 243 221 135 183 248 222 183 83 254 238 215 235 252 127 255 203 63 243 179 225 103 12 243 49 89 158 227 212 129 196 197 189
	     76 93 113 207 195 161 38 242 25 134 97 2 128 97 24 87 203 133 42 200 85 138 90 0 40 205 206 136 63 124 181 201 106 221 241 214 221 37 150 162 216 46 159 241 210 133 128 249 96 43 18 184 89 175 112 179 94 225 141 59 107 92 175 85 120 112 195 243 215 247 150 248 195 163 6 95 60 105 176 213 104
	     224 58 16 170 117 164 182 12 226 17 220 194 70 164 133 111 151 203 82 116 127 235 17 138 51 223 228 48 153 16 198 35 130 166 56 224 206 205 107 44 189 246 54 31 191 243 26 127 254 189 111 242 163 31 124 131 239 189 181 180 67 124 202 247 89 53 45 92 124 209 49 58 61 166 2 97 209 54 176 2 245
	     10 247 175 193 237 235 215 168 229 19 222 189 179 196 103 207 58 124 241 172 73 179 219 167 215 222 64 197 163 81 21 141 18 52 170 206 218 6 238 126 85 91 47 12 195 48 1 192 48 140 139 136 110 187 172 50 235 143 92 22 103 90 216 249 136 162 24 143 210 31 141 121 182 177 201 243 27 142 219 215
	     35 168 199 86 46 201 56 185 9 234 222 246 182 223 99 139 141 123 217 17 108 205 219 94 12 124 250 250 50 175 173 126 157 15 31 222 227 111 254 229 115 254 211 95 253 132 193 214 6 163 110 15 9 57 174 90 47 28 125 133 98 47 120 33 127 229 208 163 201 22 230 157 223 128 114 241 251 197 4 253 98
	     187 95 165 176 37 81 32 75 209 126 135 40 82 146 106 133 247 95 191 201 31 125 247 19 254 236 187 239 242 209 155 175 113 109 181 50 123 213 151 159 233 164 151 70 98 56 126 129 191 35 172 9 232 220 163 100 207 117 37 44 92 205 183 234 194 191 251 206 67 190 241 222 93 126 249 85 155 191 250
	     167 223 241 147 95 254 134 223 55 27 4 60 84 21 113 66 144 10 69 49 92 217 57 250 211 74 129 229 25 4 75 253 55 12 195 4 0 195 48 46 188 91 182 151 15 234 189 199 73 196 168 215 227 121 163 199 211 173 42 111 12 110 241 230 117 187 130 198 203 13 135 230 66 185 29 5 216 166 55 175 181 122 196
	     90 253 26 15 95 187 198 157 27 215 89 74 224 206 245 42 191 248 226 25 27 157 49 89 158 50 26 142 9 234 81 31 35 81 84 236 244 89 141 192 75 188 150 21 39 187 21 133 60 135 60 43 210 253 5 106 75 9 209 202 29 222 189 119 157 7 183 86 249 241 183 222 231 95 253 240 59 124 231 237 155 59 2 255
	     140 221 45 254 206 190 238 201 124 167 22 185 98 99 118 60 137 100 191 158 30 129 237 218 33 14 88 113 194 71 183 87 248 232 246 10 239 62 184 195 173 165 10 15 214 132 191 189 94 161 49 200 217 232 6 186 227 140 209 168 71 46 17 248 4 188 67 156 3 156 173 17 134 97 152 0 96 24 198 37 138 172
	     246 248 113 187 192 95 177 19 146 171 144 6 24 76 28 131 177 103 168 69 10 118 132 165 191 26 39 247 255 143 147 9 176 87 248 32 123 4 1 14 120 251 238 10 127 249 195 79 120 247 225 235 252 221 111 158 241 127 254 253 79 249 249 47 254 0 237 46 168 67 146 42 44 175 224 226 164 8 181 68 102 69
	     1 213 44 250 194 47 104 82 218 148 148 93 31 67 200 208 209 16 70 3 200 83 92 236 185 113 251 62 239 191 253 22 63 252 214 7 124 240 198 10 159 62 184 193 187 247 215 118 188 154 43 191 20 43 118 122 17 244 3 217 99 236 96 119 151 134 235 17 124 231 221 91 220 95 249 148 55 222 185 207 239 31
	     119 249 187 159 61 230 247 79 158 51 218 220 64 130 32 203 171 104 165 134 72 132 115 144 35 219 187 254 214 6 199 48 12 19 0 12 195 184 184 238 242 162 2 160 123 60 70 192 71 40 85 250 19 225 121 115 194 179 59 202 245 26 172 121 243 130 140 147 248 239 178 183 253 237 245 216 125 196 129 197
	     157 191 233 151 7 110 214 18 110 61 188 207 167 15 239 243 214 7 239 176 86 77 88 241 129 199 207 27 180 250 41 253 97 74 70 70 200 243 34 253 23 71 240 82 62 91 108 183 239 194 6 255 101 138 63 138 228 57 142 128 211 140 138 228 80 81 42 75 75 172 45 37 92 95 174 243 237 175 189 207 183 190
	     254 41 63 250 238 39 60 124 77 184 182 96 75 51 33 129 195 170 165 24 175 106 253 56 202 90 49 255 155 105 70 64 197 193 59 55 234 188 115 163 206 91 31 61 224 55 95 244 88 174 45 241 214 31 106 252 124 73 216 234 141 24 229 194 40 27 147 231 41 121 238 113 226 81 231 81 45 91 140 154 69 24 134
	     97 2 128 97 24 151 213 205 10 165 0 0 66 127 148 243 124 171 203 198 86 76 253 118 21 106 201 209 78 19 156 112 167 215 48 142 102 169 59 195 192 233 207 21 224 221 181 132 63 253 206 187 92 95 118 60 89 239 240 219 47 26 252 242 119 159 243 171 223 127 65 218 238 66 92 133 90 29 42 53 72 106
	     224 22 147 189 231 67 194 131 130 207 249 31 247 176 115 57 194 99 140 19 140 248 244 87 14 52 20 163 149 167 48 30 146 79 134 48 232 49 137 132 107 183 174 241 254 155 175 243 141 15 222 224 173 251 215 249 228 157 215 121 235 245 251 188 117 11 214 246 24 74 247 170 134 71 23 255 198 243 179
	     219 124 145 42 19 200 174 123 80 145 13 50 157 221 211 127 191 13 132 123 75 164 95 187 207 215 238 213 121 247 173 107 252 238 201 22 63 251 245 83 126 247 229 6 163 254 16 36 130 149 53 168 175 20 79 242 229 43 40 71 92 31 12 195 48 76 0 48 12 227 130 184 215 211 29 90 231 43 136 11 244 39
	     57 143 55 90 220 90 21 214 42 215 185 85 141 113 22 212 27 39 140 36 228 20 67 136 249 242 111 97 238 107 37 22 126 240 238 29 62 126 235 38 205 97 198 63 253 108 157 187 215 106 48 233 242 133 203 72 169 144 199 17 193 23 65 122 25 66 206 226 243 66 188 210 11 18 246 92 49 3 154 126 47 197
	     129 37 231 138 67 75 145 64 8 66 148 196 16 85 184 177 148 240 225 123 247 249 147 239 125 202 159 254 209 215 249 240 205 27 220 171 71 120 231 9 94 102 213 253 183 237 242 156 138 28 198 139 89 77 57 190 129 66 127 155 102 4 220 78 132 149 247 110 81 123 231 38 95 255 218 91 252 252 179 117
	     86 253 63 227 211 17 143 54 114 90 227 64 28 23 207 81 148 84 2 170 243 66 161 97 24 134 9 0 134 97 92 26 7 91 10 71 199 199 160 202 40 29 49 25 247 216 216 138 232 221 89 37 152 143 106 156 35 118 156 1 86 45 146 251 5 98 239 168 122 199 141 74 76 252 181 55 88 139 198 92 91 10 252 254 105
	     147 207 215 71 124 254 180 201 179 231 155 228 221 54 68 17 36 21 136 98 136 43 219 133 192 68 203 0 194 78 131 191 186 113 157 70 232 101 41 200 105 1 199 201 4 198 99 66 54 134 116 76 94 169 80 95 89 226 225 235 247 120 112 171 206 59 119 151 249 228 225 61 62 249 240 61 62 125 255 46 183
	     171 110 87 191 128 249 115 254 238 48 205 193 226 243 11 16 236 111 207 83 145 221 245 1 2 148 135 127 138 127 171 121 7 30 62 136 61 171 239 189 6 195 247 185 125 179 198 111 30 117 248 249 23 45 54 58 61 54 182 154 133 33 184 4 226 24 169 212 193 205 117 12 152 190 167 217 134 97 24 38 0 24
	     134 113 177 41 207 69 59 45 138 104 79 50 186 253 148 70 39 165 51 18 86 171 16 31 226 243 88 234 191 241 50 131 197 29 71 2 180 204 100 41 11 253 221 89 243 220 249 214 67 222 255 240 46 143 219 41 127 255 211 167 252 143 127 248 37 255 144 79 248 114 208 1 205 183 5 4 241 136 139 80 55 173
	     37 175 132 169 40 102 188 228 113 45 207 248 151 3 236 80 164 208 101 80 151 145 233 152 192 24 152 112 109 169 206 195 183 238 241 163 239 126 157 63 250 214 187 124 237 157 53 94 95 138 168 84 42 68 137 155 181 245 155 183 21 177 160 254 50 202 0 219 163 43 59 199 122 177 171 72 62 247 140
	     215 150 18 126 252 205 119 248 248 147 255 63 123 255 245 29 87 146 236 233 130 159 185 239 29 2 90 16 4 181 200 76 166 150 165 79 29 221 167 107 205 186 119 122 205 154 185 15 253 48 47 243 239 205 125 152 53 211 247 118 31 85 93 85 167 42 179 178 82 103 50 147 100 82 75 104 32 180 142 216
	     219 125 30 246 14 32 0 2 36 72 130 36 64 218 183 22 50 193 64 200 29 238 110 102 63 55 55 59 201 181 165 30 159 124 59 207 55 23 46 242 109 227 58 157 110 76 39 142 176 65 142 64 66 188 9 136 188 73 215 25 61 12 160 40 138 10 0 138 162 60 83 39 103 48 4 122 178 103 145 109 2 248 36 101 210 224
	     189 167 214 236 48 191 86 97 118 122 24 153 201 50 145 11 176 60 60 81 90 107 1 40 207 67 16 240 3 78 255 144 128 228 66 94 203 133 156 153 132 137 161 17 14 15 103 56 53 101 185 116 115 146 181 82 139 181 106 139 122 179 75 189 217 162 91 239 34 206 131 53 248 76 62 205 10 8 192 216 116 192
	     15 182 108 219 250 170 15 187 237 113 38 170 223 58 57 247 231 117 79 223 215 206 253 210 101 215 223 160 239 247 94 119 17 244 122 208 107 227 122 61 136 123 120 28 65 54 195 204 228 48 179 135 102 153 26 203 115 250 216 33 94 59 125 138 143 222 127 135 143 94 159 225 88 110 227 217 220 54 65
	     160 242 50 216 70 217 113 244 201 128 80 208 207 10 56 154 207 36 63 99 48 150 203 113 98 164 199 161 97 161 80 110 113 125 190 64 189 213 161 90 93 75 108 98 56 4 65 154 53 148 102 203 109 251 94 250 9 44 3 5 38 6 231 199 160 93 220 238 246 251 231 210 126 56 154 228 159 96 110 43 138 162 2 128
	     162 40 143 103 124 101 155 64 227 17 227 12 191 245 33 126 171 9 79 119 223 172 193 102 50 116 98 199 98 161 204 237 133 128 76 118 146 209 204 24 214 152 109 123 51 239 133 59 161 238 197 11 24 149 63 253 8 116 253 87 179 37 4 239 159 249 54 192 169 153 44 71 126 126 154 159 191 49 201 141
	     149 247 249 241 234 50 223 94 184 205 189 165 21 174 223 158 103 181 213 38 110 54 193 132 48 102 176 153 16 47 130 55 102 195 207 247 102 125 206 236 216 217 192 235 200 125 240 64 240 219 252 73 64 4 49 22 193 33 222 1 49 174 215 194 119 90 208 105 129 56 38 39 102 249 240 141 83 252 226 131
	     183 120 231 141 227 156 57 54 198 225 161 33 134 198 70 25 203 109 238 7 47 251 121 204 238 243 33 114 144 70 239 102 93 236 225 150 105 80 16 114 3 143 24 6 62 60 145 227 236 240 107 188 114 246 48 247 22 170 252 233 235 43 220 184 59 207 165 27 247 104 119 227 228 84 128 49 136 9 113 70 192
	     249 237 53 128 61 177 144 27 207 37 3 47 226 159 107 10 139 158 143 81 20 21 0 20 69 121 241 100 6 159 8 13 214 24 76 38 67 55 238 178 82 172 50 154 19 38 38 135 57 57 233 201 104 61 36 101 63 143 97 54 10 4 174 187 225 30 70 5 130 209 44 179 163 51 188 122 124 134 215 143 29 229 248 161 73 230
	     22 22 185 120 108 156 197 66 137 59 203 85 106 173 136 70 207 81 239 68 184 118 55 41 96 104 204 122 135 12 140 5 107 49 210 63 46 112 144 130 165 135 237 214 239 109 16 233 183 13 22 252 250 78 172 199 65 228 193 185 228 167 23 225 125 140 15 132 108 214 50 50 51 73 62 115 136 145 16 166 71
	     44 231 78 29 229 103 31 188 203 207 62 120 139 119 79 79 49 108 55 190 243 104 64 240 113 3 175 166 203 149 178 93 88 238 183 136 0 22 152 50 48 61 61 194 236 244 8 11 39 15 51 156 181 220 60 54 202 228 104 192 98 165 195 106 205 83 110 198 196 205 58 120 193 7 33 4 25 48 73 253 144 103 49 175
	     180 54 137 162 40 42 0 40 138 242 244 252 11 49 68 61 79 171 217 165 92 235 80 170 123 26 206 146 79 239 18 160 231 32 149 125 24 228 166 63 118 96 40 111 109 245 150 1 206 204 14 147 203 158 165 241 230 44 63 249 232 85 202 205 46 151 110 212 185 61 191 202 249 203 87 184 122 123 142 122 181
	     138 111 181 32 155 75 126 108 128 100 114 88 27 34 38 4 15 206 15 136 0 126 107 136 59 56 175 6 11 219 189 136 97 213 253 152 77 11 74 122 174 31 143 72 218 129 193 57 156 139 240 221 46 116 59 248 90 21 226 30 76 140 50 125 232 40 239 156 59 195 217 19 199 56 123 98 138 87 142 13 113 116 34
	     199 241 233 73 38 167 38 215 131 255 254 119 30 110 19 228 41 202 246 99 114 115 109 136 173 99 101 24 56 62 26 240 235 247 78 242 225 43 147 188 242 250 113 110 44 53 249 226 252 28 223 93 185 195 234 234 42 116 186 48 54 129 152 17 172 9 64 194 164 118 200 250 9 128 52 221 78 252 11 100 40
	     13 155 43 32 168 24 161 40 42 0 40 138 242 130 185 73 66 44 1 94 66 154 93 97 113 173 197 221 66 11 57 156 101 34 48 15 116 178 245 236 191 178 31 68 128 237 72 146 203 147 243 192 199 38 242 200 68 158 51 199 167 137 128 215 95 129 155 119 139 204 140 91 142 77 103 184 179 176 202 106 177 74
	     236 133 118 148 164 251 118 163 46 113 183 67 210 26 67 192 4 73 134 128 49 32 22 47 219 37 160 63 134 163 44 134 189 136 28 182 206 197 189 222 165 188 255 233 6 155 139 122 240 30 113 46 41 186 232 99 112 61 240 110 61 119 34 99 13 153 188 33 24 25 194 78 134 4 1 28 63 114 136 55 207 158 226
	     163 247 222 225 141 115 103 56 119 98 146 19 19 144 77 133 157 30 158 174 23 172 220 159 238 175 43 143 178 243 186 32 236 52 90 7 215 135 30 96 61 156 154 200 17 76 228 152 57 114 136 183 202 61 198 179 35 140 231 224 202 109 152 91 173 34 65 64 189 211 194 197 2 18 36 2 161 9 241 198 38 197
	     72 119 168 22 184 211 28 124 54 25 4 79 178 170 246 255 175 210 191 162 168 0 160 40 202 51 54 192 79 16 84 236 240 44 219 9 0 30 112 18 66 144 167 17 121 238 44 20 25 206 66 198 78 51 58 51 156 4 60 253 199 123 173 174 173 236 223 153 178 117 198 132 91 238 149 79 255 127 238 16 204 140 76 113
	     100 252 125 254 250 163 227 44 173 213 185 183 84 101 105 185 192 173 185 101 170 245 38 183 230 150 40 148 43 248 74 35 41 4 54 52 146 20 12 204 100 33 200 165 98 192 96 126 140 223 188 11 248 184 78 190 79 155 144 137 60 35 247 123 107 3 189 29 254 221 23 24 100 243 227 188 247 224 35 112
	     14 31 71 208 107 67 212 131 78 3 122 157 228 121 178 25 38 167 38 56 117 244 8 199 143 76 115 246 212 97 166 167 71 121 229 200 24 135 14 77 114 236 240 44 135 103 70 56 20 108 118 92 50 105 169 119 221 127 84 30 60 227 31 29 67 34 52 13 62 229 81 11 19 211 33 185 159 158 228 141 83 57 174 222
	     61 193 249 43 203 220 153 95 225 251 171 119 169 53 91 184 158 135 145 49 24 26 103 189 241 160 33 57 218 178 181 93 201 46 231 251 94 219 254 71 190 166 155 166 250 126 40 68 168 40 138 10 0 138 242 178 57 56 123 224 245 111 173 35 232 183 121 90 147 182 62 243 128 24 139 205 13 225 77 68 177
	     210 224 222 92 204 209 201 144 211 19 121 242 89 115 95 59 36 121 180 79 164 40 207 132 237 106 106 15 142 221 245 214 96 14 198 51 158 119 206 30 226 221 87 103 168 183 60 203 197 38 183 238 45 115 225 234 109 214 138 101 70 114 194 210 114 200 98 70 136 8 112 153 28 177 132 196 24 98 239 147
	     29 238 56 57 133 238 1 140 75 27 148 167 25 3 126 39 181 204 63 36 248 247 3 143 120 60 17 224 209 118 24 253 230 32 164 31 232 15 22 86 240 3 87 115 253 130 166 143 243 46 125 188 67 140 35 204 25 44 25 76 14 196 133 100 66 195 212 72 142 147 71 14 243 246 185 179 188 118 246 36 31 190 247
	     26 71 15 143 51 59 22 32 70 48 128 197 211 243 66 60 176 219 191 83 234 182 162 193 255 94 208 175 11 208 175 41 17 1 214 193 217 233 12 167 103 78 242 218 137 35 28 155 57 194 183 23 174 209 105 213 89 41 86 89 42 181 136 45 68 46 74 218 135 26 191 46 146 11 27 217 60 143 53 111 159 91 70 157
	     236 176 54 233 204 83 20 21 0 20 69 121 97 29 43 143 5 49 244 98 161 214 170 179 90 110 177 80 104 83 106 56 198 179 131 167 123 117 55 78 57 120 225 66 255 247 254 113 242 164 192 229 70 104 57 146 23 142 28 31 225 216 116 158 19 135 134 169 53 26 188 247 198 81 202 213 42 55 151 42 84 234
	     142 229 98 147 181 74 157 213 82 141 229 181 26 81 187 3 237 30 216 36 13 24 43 16 4 96 77 210 97 192 38 98 128 49 246 225 193 252 128 227 47 3 133 6 228 81 68 0 255 224 83 241 50 16 154 200 192 45 131 183 73 90 90 207 167 255 246 62 77 239 119 142 228 208 115 148 252 223 197 16 37 187 254 68
	     81 82 28 109 36 203 104 46 199 209 233 25 38 198 70 56 60 57 202 248 104 142 233 177 144 195 147 25 102 39 198 57 125 228 48 71 102 167 121 245 196 244 122 54 198 118 244 133 26 163 97 136 242 148 215 136 126 29 17 71 154 49 100 32 159 142 188 177 177 144 241 247 143 114 108 84 56 60 149 99 174
	     208 224 171 43 203 44 21 170 220 91 42 211 235 213 146 236 160 76 14 147 205 98 37 76 107 133 136 38 207 43 138 162 2 128 162 40 251 153 129 144 94 132 48 19 98 2 75 163 21 179 90 233 49 57 146 97 56 132 80 250 173 137 84 4 80 14 206 168 222 205 56 141 73 138 212 231 45 156 57 54 73 228 199
	     57 121 122 22 231 29 11 165 14 203 133 54 23 175 45 112 103 110 153 219 115 11 208 235 82 145 136 86 175 9 54 78 194 101 49 105 216 28 39 7 107 188 77 94 223 165 89 2 178 53 236 24 140 68 12 46 77 119 223 62 228 127 120 64 177 105 215 95 54 41 9 233 175 146 62 75 95 0 216 252 187 233 215 213
	     247 27 59 253 30 151 166 248 167 197 252 136 210 39 139 17 137 192 196 136 117 152 140 48 53 154 99 106 98 148 55 206 156 228 200 236 12 175 159 61 193 177 217 105 102 167 51 28 26 51 228 3 97 36 176 132 54 196 197 158 142 21 2 182 223 229 215 192 95 121 86 2 192 118 191 247 133 238 174 135
	     97 113 156 59 49 69 126 98 148 229 114 68 110 120 158 11 87 111 82 171 212 40 186 78 210 225 34 134 192 25 100 93 58 51 201 108 219 205 121 185 231 94 71 103 187 214 195 138 162 168 0 160 40 202 11 231 236 108 31 196 27 60 22 27 100 232 186 152 165 181 58 55 238 22 24 30 18 78 29 202 19 90 117
	     199 149 23 19 75 178 97 159 13 45 195 161 5 15 135 211 144 251 204 248 40 149 51 112 98 102 156 133 197 25 22 151 102 152 91 60 74 165 214 96 173 92 167 211 243 84 234 29 162 40 162 86 111 210 236 116 105 180 218 116 218 29 90 221 152 110 183 187 145 89 107 77 210 94 80 76 234 248 167 255 94
	     191 109 235 108 237 23 29 76 10 15 110 204 220 237 66 150 45 103 245 189 75 2 122 151 84 225 31 108 156 152 100 236 167 233 251 18 131 243 56 151 38 67 187 116 103 63 246 73 36 30 88 134 178 33 97 16 50 148 207 146 11 3 242 217 12 249 124 150 225 92 134 201 241 28 195 249 144 35 83 19 140 142
	     12 115 230 196 49 166 167 167 57 115 234 16 71 39 67 70 73 196 195 245 172 131 129 82 2 235 167 36 182 124 156 135 175 52 154 170 252 114 240 236 206 163 111 39 6 228 4 114 129 97 60 200 48 155 15 169 76 195 68 54 199 155 51 33 167 38 45 243 197 26 119 150 74 204 45 151 169 213 215 232 70 22
	     201 15 33 65 30 99 45 46 8 210 196 156 7 20 212 19 121 252 122 33 138 162 40 42 0 40 138 178 163 115 179 43 255 34 41 98 100 3 11 214 81 107 182 88 46 148 40 86 114 28 155 204 38 169 206 138 178 159 199 249 99 134 22 247 253 91 54 246 198 157 64 198 195 169 153 60 51 163 179 188 113 106 156
	     78 251 52 221 94 204 106 173 71 177 210 101 110 177 72 173 222 224 238 220 60 133 114 133 197 229 53 138 81 151 118 187 9 181 58 196 113 226 232 103 50 233 145 129 244 199 218 245 170 226 201 143 29 248 36 146 244 53 244 62 249 191 152 141 173 113 151 138 3 235 239 220 111 210 12 54 98 253 52
	     93 63 238 247 68 72 31 236 93 242 158 124 156 180 227 115 46 185 143 235 37 63 189 30 68 113 114 164 33 151 33 147 27 103 36 155 73 211 250 135 153 153 30 231 200 204 33 102 14 77 240 234 233 25 166 70 2 14 13 101 241 54 32 63 156 35 27 134 140 228 3 66 73 118 65 29 155 119 249 13 155 181 138
	     39 11 12 85 4 120 49 113 207 228 59 238 103 206 108 215 209 198 13 252 63 18 33 176 240 202 76 192 177 225 163 28 157 29 230 110 161 197 167 223 222 160 81 187 72 121 117 25 218 49 94 102 240 121 131 53 121 68 12 222 187 29 226 126 121 224 104 86 20 69 81 1 64 81 148 103 132 39 8 2 60 142 74
	     179 201 252 74 143 153 229 97 102 15 141 51 58 101 113 36 189 213 213 97 81 94 68 241 192 111 227 144 103 72 118 176 135 135 2 200 7 120 134 128 164 85 96 236 60 189 200 115 175 28 81 173 213 185 117 111 134 66 177 204 252 210 42 107 229 42 229 106 157 114 165 70 187 23 211 234 58 186 222 210
	     141 146 30 226 81 236 137 29 244 34 79 236 60 145 243 116 93 76 114 98 64 240 24 226 216 211 243 49 116 122 201 142 188 239 135 210 131 77 241 182 246 235 78 197 0 35 96 13 214 88 194 140 65 140 193 59 135 17 131 88 33 107 45 70 32 99 33 48 66 96 133 192 64 96 32 180 142 192 192 200 80 134 124
	     38 100 102 122 130 145 161 97 102 167 167 24 31 29 102 118 102 130 163 179 179 204 78 141 114 106 42 71 96 192 202 230 148 103 17 73 106 34 166 239 203 109 27 194 105 208 174 236 71 43 184 49 58 251 51 46 76 215 130 225 188 65 242 195 156 152 24 162 250 138 103 102 56 199 84 54 230 187 195 89
	     238 174 180 232 217 60 165 134 167 135 163 219 237 34 214 14 20 247 219 207 135 231 188 206 73 69 81 1 64 81 148 151 49 0 130 180 99 128 7 231 61 237 200 81 105 56 74 13 104 78 37 14 16 7 192 149 81 148 135 185 185 15 10 65 101 64 16 216 72 81 151 251 243 213 45 228 66 56 17 4 180 199 3 38 199
	     3 154 237 54 181 230 25 154 157 46 221 110 151 94 183 71 179 23 179 80 138 40 148 122 20 171 45 122 189 46 181 102 139 118 171 75 189 209 164 217 238 80 107 54 168 214 155 116 35 151 6 248 134 182 235 208 107 183 160 214 128 86 27 122 105 38 129 217 154 141 227 54 222 113 20 39 231 25 194 12
	     140 14 193 232 8 217 76 142 32 48 196 81 68 38 99 200 132 25 198 71 71 200 102 50 140 143 12 49 148 13 25 25 206 50 60 148 99 40 151 99 114 114 136 209 177 128 153 137 128 172 49 140 102 179 100 194 128 145 124 142 92 24 50 146 207 49 146 31 98 56 31 50 28 236 230 106 251 7 92 111 93 69 148
	     231 104 247 100 231 17 41 219 172 9 253 180 21 27 8 4 240 238 217 105 38 70 223 231 149 183 78 242 221 205 26 183 238 150 185 116 125 145 74 187 137 239 246 32 155 67 172 89 111 160 145 8 116 242 136 157 58 158 197 170 168 237 255 20 69 5 0 69 81 94 222 208 72 192 75 64 152 27 194 91 97 177
	     216 230 135 27 171 4 246 16 167 14 101 201 101 212 57 80 94 208 96 224 49 66 83 15 12 91 24 178 150 137 220 24 206 143 38 221 241 210 191 138 135 216 123 106 29 207 66 61 102 181 20 209 237 117 169 214 26 212 27 109 170 245 26 245 70 131 106 181 74 169 82 163 19 37 77 201 68 12 173 86 139 114
	     173 78 165 92 165 213 104 18 247 122 136 24 228 62 1 96 35 208 142 163 24 99 133 32 155 101 100 108 140 233 201 9 70 135 135 8 131 128 40 234 145 205 88 178 217 44 83 19 19 228 115 57 38 199 71 25 30 202 50 54 50 196 232 200 8 163 195 33 179 19 1 163 25 195 80 152 244 5 176 146 252 63 209 64
	     36 77 48 16 68 60 110 160 249 153 60 32 168 48 79 77 194 81 94 88 91 180 15 48 15 8 151 3 224 212 88 150 19 99 71 121 235 228 44 31 190 25 241 197 133 2 46 142 185 124 251 30 237 122 19 19 134 120 179 145 177 227 53 184 86 20 69 5 0 69 81 71 103 243 1 253 129 82 251 15 8 68 30 213 61 146 93 184
	     88 126 160 111 185 177 33 67 99 121 2 35 148 26 53 58 183 22 152 26 177 204 78 30 93 127 62 109 9 168 188 8 65 254 182 179 242 1 231 130 183 11 16 204 150 182 130 219 49 154 129 225 81 56 58 149 28 191 111 119 199 233 118 34 218 221 14 157 94 39 41 26 216 234 16 185 36 89 222 139 208 235 245
	     104 119 186 52 219 109 218 221 46 113 236 146 214 130 59 190 142 39 246 30 17 8 131 128 124 54 199 240 80 158 108 24 98 141 193 57 71 198 26 108 16 144 207 103 201 6 25 242 249 12 65 24 144 207 100 82 113 0 70 5 178 207 44 92 115 187 8 185 120 196 251 248 109 222 149 209 193 127 160 120 156
	     239 120 183 125 63 246 230 221 25 146 227 51 32 228 179 134 153 153 128 241 15 103 89 88 59 66 177 92 100 101 173 129 21 136 36 201 208 17 76 218 80 163 47 182 203 147 25 237 237 30 182 229 62 94 118 187 42 234 17 0 69 81 1 64 81 148 151 47 48 50 38 117 22 60 61 151 132 246 157 78 196 194 226
	     10 189 122 129 12 45 38 70 50 76 156 155 192 138 33 103 212 81 80 94 110 220 128 95 46 219 248 207 110 139 239 158 243 144 9 129 192 227 178 22 70 12 222 103 240 12 67 122 236 102 115 120 227 55 221 238 233 7 15 15 155 123 73 154 177 164 243 218 108 13 145 210 227 12 6 89 23 57 210 56 6 73 30
	     74 143 237 91 244 201 14 97 195 246 65 197 46 222 231 83 145 112 148 3 110 141 246 253 187 235 143 220 56 253 221 166 63 199 70 28 71 198 3 242 22 136 99 140 139 146 250 29 88 176 253 102 156 251 241 243 169 64 166 40 42 0 40 138 242 82 97 173 197 134 193 122 177 162 70 171 73 165 84 165 184
	     86 224 230 205 235 180 171 107 68 173 10 25 235 153 26 121 155 163 135 70 201 230 242 24 238 175 240 173 40 47 3 187 9 93 7 207 18 111 78 18 216 122 202 216 236 219 207 232 119 249 25 53 49 95 121 217 36 138 190 20 103 211 255 199 64 169 220 161 184 90 162 89 41 66 179 74 100 193 135 185 164
	     241 135 1 35 22 183 126 28 64 231 141 162 40 42 0 40 138 242 140 3 23 1 188 49 73 16 239 33 138 34 156 115 148 202 53 150 87 215 88 152 191 199 234 226 2 68 45 174 249 54 214 199 156 152 206 240 179 15 95 101 234 104 22 147 228 62 235 81 0 229 197 114 238 119 217 159 110 83 24 191 205 67 94 132
	     61 181 221 214 69 208 249 175 188 176 54 115 235 145 160 212 136 122 217 208 244 58 177 231 230 90 141 79 191 187 195 55 223 222 96 101 165 128 111 55 136 194 12 248 0 130 180 59 70 32 88 147 116 204 240 206 227 69 210 19 1 178 254 156 219 26 234 65 213 65 81 20 69 5 0 69 81 30 39 192 177 198
	     34 214 224 141 165 213 106 209 110 52 41 150 203 180 154 29 86 138 5 10 197 18 133 210 26 174 209 6 215 227 78 189 74 189 88 230 244 137 67 76 206 30 229 181 35 73 107 36 117 254 149 151 126 62 61 94 84 49 56 33 95 156 207 165 40 47 225 220 111 69 49 223 92 157 227 183 127 250 154 111 191 191
	     74 173 23 39 127 112 49 68 61 188 115 224 98 92 28 33 54 72 126 210 99 58 253 149 192 233 172 83 20 69 5 0 69 121 73 220 7 255 112 151 219 179 101 87 242 17 91 8 245 119 232 215 119 50 140 89 239 19 238 60 52 91 109 214 138 69 230 22 22 168 86 235 212 235 117 58 81 132 136 69 70 198 32 238 226
	     27 17 157 118 151 197 98 141 249 181 22 229 86 132 12 101 200 24 61 61 168 60 39 118 211 211 111 191 6 199 162 142 254 238 43 157 201 179 254 118 148 131 56 118 182 86 188 219 163 97 176 109 70 144 108 30 177 213 86 135 219 11 203 92 189 117 139 98 169 76 48 62 137 207 231 192 6 73 104 239 128
	     40 198 199 22 23 196 216 192 35 65 0 198 32 166 95 223 99 224 51 200 67 166 196 78 75 162 236 193 165 212 44 3 69 81 1 64 81 148 125 31 74 236 46 216 16 176 98 241 222 19 123 71 163 221 166 222 108 211 106 181 89 94 94 165 88 46 179 178 186 70 171 217 132 110 4 214 64 54 139 13 50 96 13 113
	     59 67 171 219 227 226 173 21 130 191 92 98 246 208 8 31 188 62 203 217 209 44 86 253 109 69 81 246 100 253 115 123 180 62 234 162 164 182 243 233 98 128 200 123 154 49 156 191 181 204 167 223 93 227 198 157 69 162 106 19 25 155 134 76 54 121 143 206 131 68 248 200 3 17 196 49 206 57 196 133
	     72 144 100 2 96 45 6 193 227 64 204 253 93 122 244 203 86 20 69 5 0 69 121 65 221 153 129 157 6 191 101 151 223 251 71 119 1 124 191 26 184 128 177 150 108 152 193 123 104 118 219 212 27 77 230 151 150 41 151 42 20 10 69 58 221 136 40 142 193 90 200 154 84 52 48 56 239 147 186 197 153 28 30 67
	     165 209 230 194 229 235 156 63 61 206 153 217 28 126 116 6 16 109 34 164 188 204 177 192 254 193 235 181 209 75 160 236 233 120 218 218 182 79 54 198 83 207 57 110 47 87 249 225 234 34 203 171 85 140 205 36 237 62 0 227 125 114 214 95 182 182 253 115 248 184 151 90 104 7 38 196 136 65 44 152
	     52 29 192 249 129 199 13 148 217 245 42 5 40 138 162 2 128 162 40 15 80 19 16 145 52 171 80 104 117 123 180 58 93 154 173 54 149 90 149 213 194 26 119 231 23 40 23 75 196 245 22 132 33 132 201 142 4 150 245 86 69 222 251 164 131 113 118 8 23 228 41 213 26 148 230 87 248 243 120 192 177 195 35
	     156 24 29 230 232 196 240 198 49 3 117 182 21 69 81 148 23 89 20 72 237 220 82 165 205 31 191 189 193 239 62 249 129 27 183 150 233 5 57 24 206 226 55 185 224 91 130 118 31 65 4 62 142 147 26 1 198 225 93 140 88 11 214 225 197 96 36 57 30 232 141 217 176 197 122 217 21 69 81 1 64 81 94 64 167
	     194 251 39 121 112 26 247 11 136 96 131 128 76 54 131 23 33 118 142 102 185 76 169 82 102 121 117 141 98 169 66 179 213 162 94 111 18 71 14 31 216 245 190 225 27 142 198 214 50 196 6 49 14 231 60 244 122 20 170 117 110 205 23 89 46 183 153 26 31 38 148 13 1 64 69 0 229 153 32 59 59 231 15 185
	     203 99 184 251 187 124 241 253 120 77 252 193 120 235 9 230 33 223 160 127 232 7 215 181 231 32 134 211 60 249 28 147 189 120 237 251 159 164 159 153 231 184 191 129 103 59 22 238 44 150 184 125 251 46 149 82 149 236 212 20 38 35 73 117 127 250 21 254 7 45 162 79 55 244 83 107 25 71 73 160 239
	     29 46 54 136 13 240 54 196 4 6 49 118 160 243 64 242 28 126 151 198 181 255 184 93 249 20 170 44 40 138 10 0 138 162 28 228 128 72 112 36 105 130 113 20 225 4 122 189 136 118 167 195 194 242 50 119 22 23 88 94 88 164 83 107 224 109 128 51 6 31 132 152 48 76 154 20 251 237 19 12 251 59 16 24 147
	     100 10 12 13 81 172 183 248 236 187 27 28 155 158 34 50 175 243 198 209 9 70 67 139 35 233 139 172 40 47 110 144 162 101 47 159 189 138 49 248 183 189 170 19 160 236 95 17 192 60 135 215 150 93 221 211 0 117 231 169 182 133 47 47 46 240 205 133 235 44 46 175 225 187 49 145 9 145 48 216 38 85
	     127 7 161 193 57 240 93 124 44 120 49 201 17 188 32 66 124 8 65 128 96 147 251 122 73 69 122 205 6 80 20 69 5 0 69 121 233 29 229 164 67 0 4 214 18 164 85 133 35 231 104 182 219 52 202 85 74 149 10 213 90 141 165 181 2 75 133 2 205 90 3 186 221 164 47 113 102 163 27 192 122 111 227 29 221 163
	     100 103 78 76 136 207 231 169 180 186 92 186 116 141 147 83 67 156 58 125 148 55 142 77 111 114 161 52 11 64 217 143 225 227 227 197 7 233 110 157 60 122 192 160 40 202 139 33 79 120 54 196 237 78 236 185 124 103 137 143 191 56 207 181 219 115 116 61 144 201 17 99 16 145 164 238 223 96 86 221
	     224 78 188 31 92 67 124 250 228 14 140 131 200 1 14 231 99 140 11 241 65 8 54 192 27 155 212 242 65 112 226 31 104 175 239 123 61 69 81 84 0 80 20 229 5 114 74 140 199 249 141 80 196 59 71 20 69 180 187 93 10 197 34 197 66 145 165 149 85 202 149 26 205 86 139 94 212 75 118 21 194 76 178 171
	     159 30 23 112 238 225 206 66 95 4 48 54 131 24 75 179 91 163 177 184 204 183 223 95 230 228 217 87 121 243 204 17 206 205 228 240 30 178 26 23 41 47 28 134 141 157 103 149 183 20 229 101 36 246 30 43 194 157 197 34 191 251 248 11 254 240 241 103 44 173 214 176 35 19 196 62 131 247 102 151 187
	     243 59 221 43 134 216 227 99 135 51 17 62 142 145 48 131 4 97 146 129 39 62 237 22 144 30 9 0 156 174 69 138 162 168 0 160 40 7 147 221 159 217 243 32 6 99 4 177 22 19 4 56 239 137 163 152 106 179 73 169 82 161 82 173 177 86 40 82 46 87 40 87 42 116 154 45 136 99 8 44 146 201 36 197 134 252
	     131 95 235 254 142 4 105 208 35 22 49 134 216 91 240 194 220 90 133 143 191 249 145 87 95 153 97 250 239 222 100 58 8 214 5 9 69 81 246 195 226 178 127 222 202 19 151 35 216 182 28 131 174 54 7 127 128 250 167 48 96 183 19 234 182 222 54 248 218 242 192 119 104 128 174 8 141 8 46 220 90 227
	     203 75 119 184 123 111 145 200 103 8 199 115 224 195 77 31 99 55 50 161 244 91 10 136 108 28 27 240 46 57 142 231 125 114 60 192 187 180 88 96 0 214 174 215 6 16 107 214 109 120 98 161 183 121 197 173 54 126 96 174 108 239 115 236 230 154 41 138 162 2 128 162 40 207 208 123 78 219 10 165 149
	     128 76 154 9 24 57 79 181 94 103 105 101 133 197 133 37 10 165 50 141 122 131 40 138 137 113 27 213 253 197 0 6 231 252 99 154 243 180 12 146 247 72 144 197 79 31 161 27 10 23 174 222 228 95 126 151 229 212 161 28 127 243 206 89 66 107 241 62 201 156 214 211 210 202 139 131 121 72 36 170 60 251
	     239 65 209 239 244 97 54 139 135 136 11 187 123 109 239 97 165 218 225 202 92 137 79 207 223 230 238 106 19 50 195 64 64 236 97 215 21 250 118 35 134 172 119 12 140 161 151 100 4 120 19 33 65 128 177 65 106 207 19 1 65 240 233 41 37 1 217 139 247 160 53 54 20 69 5 0 69 81 246 7 34 24 147 86 9
	     22 112 206 209 108 181 104 85 187 84 27 13 214 10 69 86 86 10 172 173 173 209 170 214 32 118 201 217 254 76 136 4 225 134 63 225 253 227 135 47 30 28 30 131 71 130 16 63 62 77 47 110 211 93 94 228 171 239 46 243 222 235 199 57 53 59 205 219 179 147 184 245 84 69 117 31 148 131 62 247 118 125
	     163 162 40 7 111 50 239 250 161 119 86 171 252 233 235 43 124 250 229 5 230 87 203 196 249 17 240 1 222 25 68 250 123 248 27 149 251 253 99 191 199 180 216 165 39 41 20 24 199 32 6 239 34 188 9 146 108 131 216 130 13 192 8 130 89 63 210 135 223 106 223 55 247 247 121 166 215 76 81 20 21 0 20
	     69 121 212 128 219 39 1 187 181 136 17 48 22 27 4 196 120 186 221 30 165 74 133 229 181 85 150 11 5 202 149 42 157 86 151 78 47 74 42 9 167 142 1 98 118 85 16 104 107 58 224 131 30 226 251 14 138 88 188 55 32 150 70 163 195 197 235 11 124 251 227 28 19 195 57 198 242 33 35 54 72 187 18 232 158
	     157 242 44 230 139 250 174 138 162 236 205 50 210 183 91 30 232 121 104 116 61 55 231 139 124 127 249 6 119 111 222 162 238 12 50 60 6 222 62 89 160 189 126 2 193 63 96 45 75 78 251 19 11 222 165 199 2 140 69 194 24 9 66 140 21 196 164 25 130 36 66 191 247 38 181 235 218 57 64 81 84 0 80 20 101
	     159 198 250 247 155 103 49 6 99 76 18 196 227 105 119 186 244 90 109 154 173 54 149 106 133 181 194 26 139 75 75 172 21 139 248 118 55 9 250 195 12 100 50 27 103 253 30 123 199 223 63 252 47 94 64 2 24 26 161 229 28 231 47 221 98 52 147 97 98 124 152 247 207 157 96 100 36 73 38 212 224 95 81
	     20 69 57 8 108 109 52 25 121 152 111 244 184 113 167 204 39 95 254 200 197 107 183 169 86 106 48 60 14 65 6 241 6 226 56 177 225 143 88 143 98 87 57 2 155 158 50 198 59 159 212 9 192 224 189 195 56 135 4 49 184 0 108 146 5 96 188 193 139 79 15 8 236 208 221 71 59 5 40 138 10 0 138 162 236 11
	     21 32 117 32 18 139 111 130 128 32 204 0 66 171 215 165 209 108 179 90 44 82 40 149 40 86 74 180 154 45 106 141 58 62 118 105 133 96 147 60 199 30 24 246 65 63 102 163 56 145 220 239 149 136 64 118 136 110 220 228 238 157 57 190 246 17 111 190 121 150 83 39 78 113 124 68 203 7 41 202 254 91 103
	     30 20 96 60 189 151 65 215 2 229 153 142 38 121 162 209 215 191 119 228 28 183 23 214 248 248 179 243 124 254 205 5 86 75 117 36 55 132 15 178 169 82 32 248 199 145 185 183 38 12 248 45 190 192 86 67 60 152 219 239 73 100 138 168 135 247 49 46 142 192 134 16 152 228 200 159 177 216 180 29 161
	     247 46 125 45 217 254 146 138 206 80 69 81 1 64 81 148 231 71 63 248 23 73 82 231 99 71 47 106 211 141 34 106 245 58 171 133 34 115 139 75 20 10 69 106 245 90 98 193 141 193 132 25 200 216 196 23 121 204 224 127 219 221 0 121 144 255 229 193 199 32 130 205 231 241 29 71 175 184 202 173 185 37
	     190 190 112 139 147 39 207 112 100 250 40 129 55 140 91 117 43 148 103 49 127 244 18 40 202 203 33 2 236 118 178 63 222 162 32 64 76 146 189 86 106 180 249 230 210 109 62 253 250 2 87 175 223 193 12 141 34 99 83 136 216 228 152 190 248 39 91 123 214 133 0 217 157 253 222 164 206 59 124 20 227
	     137 193 38 89 0 214 11 18 144 30 77 144 129 56 95 240 98 30 166 0 232 66 170 40 42 0 40 138 242 172 92 26 1 172 181 88 107 49 214 18 227 105 182 218 148 203 53 138 197 34 165 106 149 74 173 206 90 169 68 179 209 132 94 55 217 245 239 27 117 185 191 153 210 67 34 254 251 157 137 29 157 173 7 249
	     34 201 235 123 177 96 179 116 59 158 75 55 230 153 253 230 34 39 14 9 231 78 30 101 220 170 67 161 40 138 162 28 28 123 44 64 165 231 185 54 95 229 226 245 37 238 46 149 232 214 219 72 56 4 67 22 193 226 253 179 183 109 235 39 250 251 173 2 7 21 11 15 14 1 23 35 54 192 25 11 198 32 98 214 247
	     23 250 53 2 54 50 10 68 99 126 69 81 1 64 81 148 103 233 108 244 219 250 9 130 136 96 188 167 23 59 122 46 166 92 171 50 183 184 196 242 226 18 165 106 149 158 115 116 123 61 196 26 200 229 19 219 109 204 83 123 111 15 215 0 124 114 226 32 138 49 198 194 196 20 130 103 181 80 226 203 111 47 242
	     202 236 48 35 185 17 142 28 31 195 165 14 70 191 168 146 250 27 138 162 40 202 190 178 199 3 182 169 19 57 110 46 87 249 230 234 34 55 238 174 210 138 13 126 120 4 177 25 72 122 225 176 231 241 255 35 214 16 184 239 136 128 115 248 94 143 56 142 33 112 73 1 225 48 147 156 46 244 73 167 130 228
	     33 30 215 239 89 144 182 47 244 106 148 21 69 5 0 69 121 25 140 253 186 13 221 171 231 76 213 120 121 136 17 247 169 155 33 198 98 173 96 131 0 68 232 246 98 106 205 38 213 90 141 90 179 197 90 177 200 226 242 10 149 82 137 110 163 133 183 105 171 159 48 68 118 8 252 119 159 5 32 91 254 239
	     119 190 64 59 94 164 65 119 201 32 217 17 34 215 165 88 170 210 105 54 248 242 232 52 83 19 147 28 27 57 203 212 68 158 204 192 35 29 27 187 44 79 122 189 119 115 205 159 237 72 80 20 69 81 14 154 63 48 104 85 235 221 136 239 174 45 242 241 23 23 184 116 241 6 45 1 159 201 227 77 144 4 255 79
	     108 193 118 97 158 253 195 108 214 192 109 30 32 78 90 0 199 146 20 10 140 77 210 70 80 12 222 218 164 62 128 13 176 233 174 191 31 240 25 30 41 131 80 81 20 21 0 20 229 192 25 123 217 98 232 252 51 12 253 124 170 188 139 36 5 123 141 33 8 18 135 162 93 111 177 86 40 50 55 191 192 106 169 76
	     163 217 164 213 233 36 59 19 185 100 215 33 241 57 100 160 18 191 223 246 189 63 212 144 203 118 123 241 15 8 134 119 172 193 148 58 30 235 61 136 13 49 134 78 20 115 111 121 149 111 47 221 228 228 204 48 239 100 143 112 56 159 37 117 81 30 232 58 61 187 226 97 158 103 86 17 77 81 246 11 114
	     128 95 70 167 231 11 29 128 63 143 175 120 208 10 8 208 35 17 168 231 74 17 23 174 220 229 242 181 155 20 214 10 4 211 211 152 204 16 24 131 247 3 246 111 47 62 244 78 127 148 7 61 76 238 255 139 12 40 7 177 3 23 225 93 148 248 12 65 136 233 223 199 88 44 201 102 196 122 230 131 151 245 19 1 138
	     162 168 0 160 40 202 94 56 54 169 81 181 54 32 176 22 140 208 139 34 26 205 54 229 106 141 78 183 199 202 90 129 181 149 53 230 22 23 105 214 170 184 40 6 107 144 92 14 194 96 163 10 255 158 181 239 49 236 133 230 47 125 65 69 4 145 164 21 97 207 117 184 126 111 153 102 163 205 228 104 150 236
	     200 48 83 103 50 100 140 108 234 175 252 124 253 13 221 239 80 20 69 81 54 236 80 219 193 157 114 155 223 125 254 61 127 252 252 59 238 46 44 227 123 49 145 183 152 48 139 243 110 31 155 142 129 78 1 196 224 98 146 243 119 2 206 227 28 24 79 210 50 88 12 88 131 193 37 237 124 17 196 123 181
	     138 138 162 2 128 162 40 143 22 8 111 47 215 59 241 72 42 173 27 107 25 202 231 112 64 187 211 161 88 42 177 180 178 66 163 81 103 181 88 161 211 233 210 234 116 112 98 32 4 140 197 175 111 81 236 95 211 188 222 157 72 12 18 230 32 22 214 202 117 170 165 50 39 143 78 115 234 244 89 94 63 126
	     136 169 108 114 111 131 108 234 181 188 103 215 91 81 20 69 81 30 17 7 88 160 231 225 219 31 239 242 219 255 248 51 23 174 92 3 147 135 177 9 188 88 92 63 245 127 191 154 158 173 126 194 96 70 128 115 184 168 155 180 5 12 66 196 90 68 178 136 53 152 52 171 80 252 224 209 58 89 255 175 214 7 80
	     20 21 0 20 69 121 148 32 213 10 129 181 73 154 93 236 233 246 122 244 162 30 173 118 135 165 181 53 86 86 86 185 59 63 79 171 209 160 211 104 35 65 144 236 246 103 66 176 253 146 189 236 88 57 239 201 236 178 99 47 60 25 63 248 116 8 18 100 177 214 210 107 183 104 53 90 252 112 245 46 35 19 63
	     112 104 106 132 159 190 117 132 153 204 253 239 194 232 80 81 20 69 81 158 181 141 78 127 58 64 39 142 249 234 242 50 255 246 241 55 124 119 254 71 122 165 42 246 216 52 50 60 188 185 234 254 129 249 112 131 45 3 61 196 17 222 197 201 255 109 144 108 76 4 22 177 27 85 121 140 12 94 21 158 88
	     168 87 20 69 5 0 69 217 55 152 45 14 192 158 154 117 239 241 233 153 120 27 4 100 195 12 94 132 78 175 75 169 92 102 109 173 192 90 161 200 106 177 72 187 221 166 82 171 225 163 228 100 252 166 4 188 93 90 94 247 88 162 128 219 18 190 203 35 95 55 247 0 167 195 97 33 204 35 89 199 220 90 141
	     127 255 243 231 76 140 101 152 153 250 39 102 79 230 214 31 111 247 205 40 232 95 11 247 128 191 43 138 162 40 207 127 189 126 114 139 189 213 242 197 192 165 185 101 254 191 191 253 140 143 191 186 68 185 237 33 51 146 216 50 49 201 206 249 129 166 223 250 207 67 220 111 35 8 174 39 72 16 130
	     177 16 4 136 13 16 35 27 167 9 252 192 195 53 19 64 81 84 0 80 148 71 225 177 10 213 61 173 247 226 239 15 88 5 246 68 221 23 17 48 73 74 29 34 120 15 157 110 151 78 167 71 173 221 96 113 121 133 59 119 231 40 20 214 104 215 27 216 76 8 34 152 76 14 159 77 36 128 245 94 190 254 225 23 204 239
	     217 117 245 143 252 29 174 23 13 218 242 28 222 37 2 136 25 26 193 228 134 113 205 42 107 119 230 249 203 23 223 114 246 196 113 142 230 223 224 212 161 92 210 250 144 251 219 47 61 255 206 0 168 199 163 40 138 242 28 253 131 135 88 159 135 155 176 71 88 186 189 135 185 213 18 127 248 252 50
	     127 252 228 27 150 230 138 200 200 52 140 4 24 19 226 98 247 156 189 22 158 60 15 95 182 92 20 239 161 215 77 10 1 198 113 226 183 248 108 114 123 191 70 128 128 193 172 139 1 94 7 228 243 119 96 21 69 5 0 69 217 31 12 6 176 214 90 140 181 88 107 65 132 106 163 73 165 92 102 105 101 133 74 189
	     78 161 84 97 173 80 32 110 183 32 138 136 76 82 145 215 91 135 136 193 191 72 70 69 2 176 16 19 64 108 185 113 103 137 255 254 219 79 152 176 109 254 239 255 249 61 14 13 13 111 186 126 70 195 109 69 81 20 229 41 219 235 193 24 175 135 167 82 111 243 217 247 183 248 243 183 215 185 115 119 149
	     110 61 130 252 36 146 201 18 187 3 110 151 54 165 56 14 56 24 222 177 94 96 40 2 210 2 189 196 17 62 200 38 71 3 76 128 145 196 187 233 119 79 74 155 29 247 229 126 29 80 138 162 2 128 162 28 80 135 224 73 162 110 3 62 221 201 22 4 135 199 57 71 47 138 241 8 197 82 137 133 197 37 238 221 187
	     71 173 222 36 138 98 188 115 216 220 16 177 108 221 63 127 49 118 156 147 180 65 15 222 17 3 228 242 48 123 140 200 180 185 124 249 10 255 115 76 120 229 149 67 252 234 141 179 228 3 139 147 141 174 0 79 250 233 181 48 160 162 40 138 242 48 1 0 192 121 88 169 181 184 114 107 137 207 190 187
	     193 221 133 2 228 134 146 142 187 54 196 59 1 28 219 53 219 29 180 53 251 183 54 128 60 224 211 179 209 190 55 221 226 247 113 4 113 156 214 29 10 193 130 4 54 189 171 73 219 14 27 156 200 222 31 157 84 20 69 5 0 69 57 8 78 132 164 6 52 176 22 27 4 56 231 104 183 219 52 154 45 138 229 164 162
	     255 242 202 42 133 82 137 98 177 136 111 119 19 99 27 4 96 12 24 217 56 100 183 241 132 219 27 234 125 232 60 237 238 190 130 24 139 88 67 179 222 164 89 92 227 147 239 110 112 226 244 143 216 32 207 79 206 206 146 205 6 105 79 226 253 232 48 41 138 162 40 47 10 125 177 185 7 52 186 142 239
	     174 175 242 233 215 87 248 195 95 126 224 206 82 137 14 33 100 114 120 73 206 254 239 135 180 188 39 10 182 119 243 192 126 38 128 75 55 34 186 73 215 0 130 8 31 39 215 65 130 32 17 1 140 217 212 198 215 223 103 55 85 22 80 20 21 0 20 229 5 49 9 125 133 95 6 218 234 120 35 201 89 127 99 48 198
	     226 60 52 91 109 10 165 18 247 230 230 169 55 26 84 203 85 122 206 99 195 144 72 210 146 119 125 213 125 203 177 66 25 104 47 180 31 55 20 252 227 62 66 64 188 71 130 16 63 54 78 199 91 126 184 182 192 225 233 41 14 79 142 240 202 225 241 141 207 189 11 103 71 30 231 205 238 234 65 26 252 43
	     138 162 28 68 127 226 81 146 191 60 208 136 61 75 213 152 43 119 138 92 185 185 196 218 90 137 110 20 99 134 134 241 38 220 200 100 123 136 79 176 249 61 200 142 127 123 184 249 25 76 207 151 77 130 197 174 109 240 214 2 71 126 23 54 206 247 141 116 250 143 254 166 68 28 225 137 113 145 5 177
	     136 3 201 132 201 251 241 14 17 33 30 180 241 200 190 245 93 94 58 135 85 81 1 64 81 148 61 68 18 47 67 68 8 131 0 39 158 94 28 209 170 213 105 119 58 52 154 77 86 214 214 168 84 42 204 47 46 209 105 181 240 173 14 132 89 200 102 193 152 245 172 1 255 210 93 55 3 65 6 178 195 20 107 17 127 254
	     230 6 221 94 204 225 67 99 100 50 175 241 202 100 158 120 96 225 122 180 222 4 138 162 40 138 242 224 120 174 111 79 186 177 231 198 82 147 175 47 221 225 95 63 249 142 75 215 110 80 46 55 137 195 28 198 102 48 65 72 28 63 164 236 93 63 210 125 145 142 157 249 190 0 16 39 71 1 98 210 142 70 22
	     239 99 140 139 240 97 140 23 3 54 192 24 89 207 92 124 169 138 4 42 138 10 0 138 242 2 58 11 131 149 228 7 13 188 36 198 46 8 44 185 124 14 231 61 81 171 69 181 81 103 121 105 153 82 185 76 161 84 193 57 71 28 59 48 1 228 44 216 52 221 159 29 2 255 129 221 239 23 171 10 96 250 169 210 143 100
	     172 197 201 16 190 219 161 209 168 51 191 184 194 237 249 53 222 56 123 130 147 147 249 251 118 254 53 248 87 20 69 81 158 52 248 223 90 95 198 138 176 90 110 113 241 199 155 92 190 126 147 106 189 133 27 30 5 155 193 35 120 247 120 45 255 252 65 182 223 155 50 1 182 26 224 52 35 160 95 215
	     199 6 136 181 88 250 53 4 146 250 71 222 251 205 25 141 60 121 243 2 69 81 84 0 80 148 103 207 64 91 63 159 198 231 173 110 68 167 91 163 214 106 82 169 214 152 91 90 100 110 126 158 102 185 66 212 106 67 46 139 55 22 111 44 98 109 90 220 111 135 167 79 203 7 174 219 223 23 84 67 119 128 152
	     0 9 44 62 246 208 141 153 95 88 225 119 159 254 128 115 96 229 3 78 30 158 224 112 222 172 59 30 234 55 40 138 162 40 79 100 194 83 251 99 72 206 253 87 98 199 181 187 5 254 245 143 231 249 248 139 239 89 188 51 79 156 31 65 134 199 16 250 169 255 59 215 226 217 254 180 251 211 171 221 243 124
	     61 2 159 56 61 2 184 24 31 75 210 61 192 6 73 231 30 99 16 107 240 198 2 178 238 39 33 50 168 253 191 64 35 105 127 124 43 138 162 2 128 162 60 112 145 126 188 133 90 54 5 227 66 24 134 132 97 22 143 16 251 152 82 169 76 165 92 102 110 121 137 114 173 70 189 222 160 214 104 17 247 251 231 246
	     85 113 73 90 231 236 244 22 4 65 252 253 209 174 127 216 123 222 225 172 224 211 191 180 91 207 23 238 226 181 189 223 228 16 224 73 68 145 225 97 218 116 185 120 229 38 184 136 51 199 143 48 61 59 133 149 1 193 96 47 135 129 162 40 138 242 66 90 249 135 5 208 253 251 135 64 177 19 243 201 55
	     63 242 231 47 207 179 84 168 16 5 57 196 102 241 18 36 169 237 222 239 24 240 201 224 173 253 243 254 155 111 125 252 0 113 7 123 186 155 186 56 15 181 201 143 115 92 193 111 17 54 250 143 245 14 92 4 157 54 206 38 71 1 48 1 88 139 9 2 172 8 94 36 41 113 228 119 184 156 143 27 83 239 193 101
	     126 236 17 183 245 218 138 138 0 138 10 0 138 242 2 121 22 73 224 110 210 198 244 14 232 68 17 157 200 209 110 119 137 226 136 249 197 69 22 150 22 89 154 159 167 211 106 227 3 139 195 32 65 54 241 48 82 139 237 145 93 165 244 203 128 145 117 47 176 178 236 1 156 67 172 37 28 27 199 183 234
	     148 151 151 248 190 94 231 95 142 28 195 228 199 8 222 159 102 114 56 199 144 217 187 214 128 138 162 40 202 203 43 22 68 169 45 89 40 55 248 183 47 175 242 127 252 251 231 92 60 127 133 120 100 12 59 58 145 20 253 19 155 218 235 193 128 254 193 161 183 172 11 0 236 234 254 79 100 59 247 139
	     127 228 147 227 0 248 8 23 75 18 252 155 16 201 132 32 62 201 244 51 6 151 94 75 25 184 62 254 64 143 34 69 81 1 64 81 94 188 192 20 146 30 183 34 24 107 9 173 37 8 3 34 160 92 173 81 45 85 88 90 45 208 235 245 88 46 20 41 85 74 52 155 45 136 226 196 56 4 73 173 94 35 230 225 59 248 15 122 19
	     47 154 157 145 109 36 123 1 140 197 219 16 31 230 168 118 98 62 59 255 35 177 243 228 237 79 249 135 95 188 206 216 150 75 35 42 6 40 138 162 40 187 36 6 210 190 59 132 64 169 219 229 63 190 185 204 255 248 253 215 92 189 189 72 187 211 131 33 176 153 12 24 179 243 78 126 191 69 222 131 118
	     207 247 187 253 222 197 206 255 3 59 24 248 65 75 156 214 71 112 164 215 38 6 231 241 120 156 243 16 56 36 8 147 130 201 198 32 34 105 109 65 143 248 7 52 38 120 58 218 137 162 168 0 160 40 202 78 150 47 173 116 235 55 218 216 116 163 152 158 247 180 123 93 150 150 87 88 92 88 96 110 126 137
	     94 175 71 183 215 75 210 253 51 57 200 110 54 176 206 251 71 182 99 254 37 179 122 14 159 8 39 38 196 76 207 34 81 151 229 249 101 254 88 88 101 56 112 76 140 140 243 87 231 102 24 206 38 93 19 76 234 204 25 29 169 138 162 40 202 67 109 76 18 79 246 69 128 90 167 199 39 23 110 240 191 255 243
	     95 248 226 203 43 180 196 194 212 20 38 200 225 68 210 160 215 237 96 101 252 46 94 205 188 68 87 54 165 223 1 160 47 2 68 30 23 59 124 28 37 153 126 65 144 196 246 169 8 32 206 175 219 255 228 55 181 232 138 162 2 128 162 60 7 60 62 73 80 51 6 107 45 65 144 193 123 71 47 138 169 86 171 148
	     171 53 202 213 42 11 75 75 148 75 101 170 229 10 68 81 98 248 130 16 66 155 252 190 69 49 247 143 241 62 94 42 33 32 221 5 16 177 216 48 4 12 189 78 145 98 181 206 159 191 189 204 216 248 52 121 251 62 63 125 235 40 195 3 5 18 117 247 95 81 20 69 121 136 121 217 180 151 223 241 240 221 173 101
	     126 251 151 75 124 249 195 77 74 139 5 152 57 12 249 225 52 8 125 152 100 191 243 223 253 125 175 186 223 121 10 219 236 222 165 71 3 28 184 46 222 89 112 14 98 11 54 4 155 20 67 22 73 186 33 217 84 70 112 7 74 56 81 15 68 81 1 64 81 30 219 236 236 108 60 31 115 73 30 108 215 39 242 224 20 182
	     29 112 146 152 32 151 170 211 189 40 166 222 104 178 180 178 198 221 185 121 138 197 34 205 122 13 39 6 201 102 240 97 152 164 180 109 188 137 39 18 32 30 203 166 60 141 194 127 187 41 174 179 155 215 125 192 243 200 125 191 121 92 28 39 206 195 248 4 226 71 88 171 54 248 195 167 159 51 50 20
	     51 60 150 231 189 163 147 132 186 81 160 40 138 242 146 135 245 187 241 42 54 218 254 25 160 222 139 185 182 84 228 183 159 94 228 171 243 55 233 68 14 198 71 33 204 98 140 29 120 218 157 170 248 251 245 62 247 59 252 53 125 184 223 67 207 230 249 120 99 15 244 155 182 181 235 3 249 252 210
	     151 92 28 248 24 34 7 177 224 130 8 140 197 4 25 36 8 64 76 146 17 224 73 10 32 139 195 123 243 160 175 243 241 157 198 199 41 124 248 160 23 22 14 208 119 172 168 0 160 40 47 131 184 240 136 11 124 114 206 223 96 172 37 118 142 216 121 26 141 6 157 82 153 98 185 66 165 90 99 173 80 100 97 121
	     137 168 90 131 56 134 252 16 100 50 72 144 22 181 241 126 79 118 236 95 182 244 255 173 229 128 156 23 188 49 72 110 8 139 163 86 41 241 99 233 54 38 107 201 140 141 99 255 246 93 222 61 58 134 49 102 147 217 85 45 94 81 20 229 101 21 1 118 14 254 13 208 73 99 242 203 75 85 254 240 229 85 254
	     229 227 243 124 127 229 14 145 177 144 31 5 155 1 9 184 191 87 157 127 164 119 241 248 209 233 243 188 134 230 233 189 111 239 211 76 0 143 199 36 191 27 139 119 49 46 14 48 46 192 7 73 193 69 65 210 230 64 73 46 166 247 7 105 252 41 138 10 0 138 242 232 166 123 189 157 204 147 45 168 253 231
	     217 205 206 191 239 247 178 21 147 166 252 7 4 97 128 235 70 196 174 75 185 82 101 101 109 149 197 197 101 234 205 38 81 236 146 172 128 92 46 121 243 65 210 222 175 255 18 106 10 158 92 10 240 155 191 76 188 3 194 44 88 97 121 181 194 199 127 254 134 233 44 28 250 135 15 56 62 57 154 8 6 176
	     109 169 38 69 81 20 69 125 12 15 68 177 99 173 30 113 254 199 5 206 95 184 205 252 226 10 221 110 23 134 199 144 32 135 55 6 239 210 194 126 242 228 190 200 75 111 205 7 118 219 215 27 38 174 103 5 120 136 123 120 23 19 123 151 156 24 8 5 49 201 223 7 115 43 252 96 70 134 26 121 69 81 1 64 81
	     30 36 0 236 6 99 44 62 61 238 23 251 152 118 179 75 20 197 84 170 117 90 157 22 243 75 75 44 47 175 80 90 91 131 94 47 41 240 23 134 152 48 76 42 4 59 191 222 238 71 93 133 189 113 214 54 11 0 6 39 2 217 44 56 203 90 169 201 103 95 93 38 4 14 77 79 240 155 159 191 193 84 214 34 198 36 71 54 208
	     18 66 138 162 40 106 75 54 98 197 136 228 56 223 141 213 26 223 95 91 226 159 255 227 91 190 186 112 133 149 98 13 36 64 130 44 38 200 36 129 168 247 155 90 212 41 123 241 77 172 59 103 169 0 224 211 108 128 56 185 61 118 16 123 188 115 136 13 16 107 210 99 1 130 200 70 39 6 191 23 126 150 232
	     119 171 168 0 160 40 251 204 78 244 213 94 255 196 129 253 198 83 238 96 46 36 49 4 65 24 96 108 82 180 175 221 233 80 109 214 40 151 74 44 175 20 104 181 91 84 170 53 26 205 54 98 2 124 104 192 90 16 73 118 156 253 70 153 190 109 141 157 178 171 203 178 227 159 124 186 107 32 36 61 133 69 64
	     44 221 184 195 189 229 2 95 126 119 157 217 137 49 126 241 230 113 198 50 27 141 136 30 69 4 216 253 9 82 69 81 20 101 127 33 219 254 219 111 17 1 140 135 166 243 204 45 55 248 225 202 29 46 93 187 206 114 161 132 11 178 16 100 65 2 188 23 72 207 157 123 255 50 218 114 183 229 122 238 226 243
	     63 228 46 146 102 88 110 42 138 232 183 17 5 0 92 4 61 143 115 17 184 0 177 1 120 139 177 146 108 182 164 89 4 206 109 221 36 120 212 248 255 209 107 66 41 138 10 0 138 242 124 98 196 189 9 250 215 141 69 146 70 230 60 116 123 17 81 187 67 167 215 163 218 104 176 176 188 204 234 242 42 171 107
	     5 186 221 14 62 6 143 96 194 112 211 121 115 175 6 228 217 126 247 54 64 8 240 217 8 31 193 220 74 141 223 255 229 18 206 9 98 61 31 190 126 156 113 43 120 99 117 145 83 20 69 121 105 69 128 228 150 40 253 189 23 57 238 86 219 220 91 170 241 187 207 46 241 151 175 46 112 231 246 60 221 88 48
	     19 211 216 76 30 231 146 86 189 123 239 141 188 172 94 216 131 158 114 112 31 63 109 232 235 61 196 81 250 35 56 19 164 153 0 33 4 1 98 28 98 13 46 169 16 176 158 117 169 187 249 138 162 2 128 114 80 77 141 108 249 183 223 56 203 253 48 83 52 152 17 240 224 160 95 214 91 251 217 192 98 196 16
	     102 50 68 177 163 213 108 81 40 85 40 20 11 148 107 53 214 74 101 106 181 58 237 78 39 41 242 135 36 197 106 68 116 159 255 185 249 117 105 250 159 247 96 50 16 120 26 221 14 119 23 87 249 238 199 155 204 30 30 37 23 134 188 123 106 134 137 156 221 244 253 168 123 160 40 138 242 242 248 20 253
	     53 223 164 63 77 49 220 89 170 241 229 249 203 124 250 213 183 92 187 179 76 199 27 200 228 240 38 196 121 155 182 158 83 171 190 247 95 136 223 176 195 235 233 255 155 141 124 226 187 13 20 93 116 0 17 62 237 28 224 124 136 152 16 188 77 54 2 36 105 25 136 145 141 6 68 126 240 120 128 126 143
	     138 162 2 128 178 239 227 59 183 203 0 255 201 156 2 143 19 16 151 156 49 243 196 196 29 104 182 218 172 21 138 220 155 159 103 126 121 153 122 189 65 28 117 113 146 116 2 144 32 72 138 215 2 94 149 230 231 239 217 121 32 8 49 4 120 7 181 118 131 139 55 230 136 189 167 81 239 17 253 237 219
	     124 112 238 24 99 214 128 108 156 226 212 111 78 81 20 229 197 55 17 0 49 96 129 200 67 177 227 184 118 175 194 255 252 243 15 252 229 203 111 249 238 135 203 116 157 197 12 79 225 51 57 28 105 209 63 13 26 159 10 131 199 241 54 55 84 220 230 168 193 160 224 239 129 56 198 59 71 28 199 136 36
	     199 2 76 16 34 65 152 212 7 160 127 100 67 182 29 7 59 107 18 250 93 43 42 0 40 202 115 55 216 242 24 127 123 232 243 166 231 206 36 13 228 77 96 49 214 226 98 71 47 142 168 215 234 52 234 69 214 74 37 10 197 34 107 133 2 165 74 21 223 233 36 79 16 134 16 6 235 106 245 70 1 218 129 46 5 125
	     101 59 85 181 95 88 163 242 84 62 150 236 254 133 182 222 44 38 185 230 65 22 23 117 41 85 154 92 252 241 14 153 32 96 246 200 4 51 135 167 25 153 30 34 220 162 27 200 35 188 147 221 189 55 149 21 20 69 81 246 147 153 146 52 248 7 176 2 133 150 227 147 111 127 228 223 63 254 130 219 119 230
	     104 55 186 144 27 37 8 115 120 155 73 138 207 109 179 13 241 8 22 234 233 155 66 121 218 111 98 191 185 16 253 108 128 244 176 191 164 173 149 189 195 57 135 241 49 152 0 33 196 90 73 10 5 15 202 11 254 209 94 83 107 2 40 42 0 40 202 51 70 118 176 14 187 93 134 253 96 16 190 5 231 60 98 61 206
	     57 108 108 0 79 187 219 165 222 104 178 188 188 194 194 226 50 203 43 43 180 219 77 34 159 4 247 38 155 77 143 37 152 109 251 207 30 112 59 188 31 191 253 71 8 254 211 239 186 159 46 104 3 236 208 24 174 213 164 218 168 115 245 206 2 159 125 119 131 209 145 81 120 255 52 103 166 242 12 25 179
	     46 0 216 61 117 99 52 248 87 20 69 217 79 184 116 157 239 58 176 6 138 17 124 117 113 142 223 253 233 11 46 125 127 137 200 230 177 19 179 248 48 139 23 131 119 241 147 90 40 229 225 209 245 22 51 190 155 43 185 209 58 112 83 57 71 23 225 123 14 23 69 73 38 160 247 224 195 212 184 203 122 97
	     231 39 219 62 82 20 21 0 20 229 57 218 12 121 36 131 235 156 91 223 137 23 32 8 3 196 88 188 120 186 189 152 70 163 73 171 211 161 92 173 80 171 213 89 93 43 176 176 188 74 167 92 74 74 202 230 179 72 38 151 84 9 144 1 37 88 100 115 97 130 1 163 166 60 71 71 207 123 196 88 196 132 72 236 240
	     157 54 171 165 26 95 125 119 25 31 199 120 31 147 249 249 27 156 27 203 220 87 75 66 93 3 69 81 148 23 131 254 122 158 150 146 75 110 51 176 214 115 124 118 254 54 255 253 183 159 242 221 165 27 244 106 93 152 156 64 134 198 147 29 227 56 222 126 199 119 208 246 43 207 240 139 244 247 9 7 233
	     47 201 223 250 187 69 46 205 6 32 233 196 68 236 193 198 73 119 38 107 18 191 64 100 125 3 167 223 167 73 245 123 69 81 1 64 121 65 157 0 159 230 125 25 17 140 9 176 161 37 138 99 58 237 6 203 107 171 44 175 22 40 20 10 52 154 45 218 221 30 157 110 23 201 100 19 251 98 237 186 51 112 95 128
	     104 184 223 128 40 207 245 187 238 127 67 177 243 120 27 98 70 70 113 113 135 187 115 139 244 186 45 50 129 97 124 100 156 145 247 78 50 51 36 4 60 252 40 192 195 49 247 189 11 69 81 20 229 249 210 63 103 30 57 8 13 212 29 124 241 195 60 255 239 255 246 239 252 238 147 243 84 218 96 102 142
	     227 50 57 98 159 4 148 186 130 31 24 99 191 241 143 190 210 147 86 143 242 81 132 139 28 4 22 130 0 124 136 9 4 177 38 237 20 224 113 248 1 161 71 52 250 87 84 0 80 148 253 206 110 151 105 17 193 26 147 168 191 64 236 29 237 110 151 110 179 71 189 222 160 80 42 178 176 180 204 242 234 42 181
	     106 13 223 139 192 6 16 132 72 46 11 38 233 7 56 184 27 176 147 115 176 221 142 65 146 32 160 238 196 51 247 13 250 153 25 54 64 194 97 76 207 208 171 85 185 183 176 198 167 95 94 34 19 14 17 123 207 175 222 61 201 233 17 195 150 100 194 71 116 3 228 49 71 167 162 40 138 178 103 1 161 220 255
	     207 254 186 30 25 168 244 98 254 114 113 153 255 207 191 125 206 239 255 124 158 210 220 50 204 156 36 156 152 193 57 151 22 252 83 14 174 87 152 14 0 231 193 199 120 34 112 22 92 156 100 115 186 24 31 90 4 3 198 96 250 45 3 7 203 55 237 194 175 83 20 21 0 20 101 159 138 1 190 191 112 27 33 8
	     2 76 96 241 64 167 221 166 82 173 177 182 86 96 101 109 149 98 165 66 189 209 160 213 106 37 65 163 13 16 99 214 23 126 241 253 115 229 59 4 254 254 129 17 232 83 74 21 124 102 37 136 158 179 55 247 164 215 164 239 11 8 72 128 12 143 225 93 196 157 197 53 126 247 233 151 244 226 46 89 107 25
	     121 255 4 83 217 141 61 252 152 228 119 13 227 21 69 81 14 158 185 24 172 219 223 255 127 203 193 87 87 150 248 223 255 219 239 249 159 159 127 207 106 45 198 140 205 64 152 197 121 135 172 167 132 63 70 233 215 199 49 201 47 131 25 127 166 99 96 160 207 131 31 44 250 231 147 150 205 62 198
	     197 6 98 139 88 11 54 131 9 2 140 216 68 4 128 180 221 35 233 191 213 3 80 84 0 80 148 3 37 7 36 199 253 147 58 1 14 79 47 138 136 58 93 218 157 14 229 90 141 149 181 85 150 151 86 89 43 22 104 183 91 233 195 12 38 155 133 45 213 98 113 155 155 210 60 122 193 154 103 33 123 188 236 193 255 78
	     30 149 75 210 57 61 120 9 48 99 83 88 98 186 43 203 220 185 51 207 31 61 140 228 135 8 3 195 71 111 204 114 116 200 106 224 175 40 138 114 16 77 133 220 127 179 7 154 64 175 219 227 235 27 85 254 199 239 207 243 251 63 127 205 242 252 42 76 205 18 140 76 224 98 135 143 227 205 173 2 30 217 66
	     61 165 78 48 42 8 164 151 82 118 121 157 182 124 137 253 199 185 56 217 253 71 32 182 248 192 34 65 154 217 105 29 136 77 235 4 202 186 16 228 100 143 190 67 69 81 1 64 81 246 60 212 191 207 66 138 8 54 72 138 189 96 12 157 94 143 122 163 73 185 84 97 173 84 160 88 46 83 174 84 168 53 90 116
	     219 157 164 205 143 24 176 146 116 6 144 93 152 238 29 11 210 108 126 31 106 191 247 153 159 232 133 158 55 144 201 67 215 115 111 126 133 223 127 252 25 184 46 248 95 146 127 247 4 19 153 141 76 128 193 30 197 187 242 58 21 69 81 148 231 142 25 88 165 235 61 56 255 227 93 254 219 111 191 228
	     247 159 95 98 185 208 64 108 30 124 72 228 250 199 191 182 30 24 216 101 251 183 193 191 169 41 216 39 126 225 253 158 215 166 170 14 206 145 182 118 194 199 14 111 45 38 200 64 96 17 19 172 127 175 150 100 3 105 227 217 244 11 86 84 0 80 148 125 180 210 75 98 160 83 245 214 139 16 121 143 139
	     122 244 98 71 179 217 102 173 88 98 117 101 149 165 213 85 42 181 50 189 78 55 105 19 151 201 224 201 164 235 125 82 20 102 207 66 59 145 237 197 2 229 185 9 0 235 231 59 71 39 8 237 56 189 226 18 183 238 205 241 231 47 67 198 71 198 25 29 30 225 141 211 99 28 206 153 117 7 242 254 77 161 237
	     111 85 20 69 81 158 241 162 190 197 88 187 129 48 190 5 116 187 49 23 111 214 248 253 167 63 242 187 79 190 228 214 194 26 50 58 141 100 70 113 222 128 243 105 210 183 12 20 144 219 133 93 87 246 245 176 48 3 54 218 111 250 222 54 252 50 223 139 240 164 29 2 60 24 201 172 119 118 146 244 126
	     155 242 44 37 121 102 69 81 1 64 121 161 172 231 67 3 95 217 230 144 221 67 140 229 174 20 244 39 122 247 30 17 65 196 96 3 139 49 1 177 115 180 218 45 202 213 26 229 90 141 90 173 78 161 84 166 90 173 81 169 86 137 59 173 68 1 246 16 139 89 111 13 248 160 171 179 255 191 63 101 251 107 34 219
	     222 38 38 105 17 36 18 210 237 192 143 55 23 8 130 175 241 70 104 255 250 109 126 254 198 81 38 251 237 131 83 167 114 99 180 171 3 168 40 138 174 181 15 176 252 79 113 61 223 250 247 193 70 127 27 191 121 160 212 137 249 246 194 93 254 253 211 75 124 252 197 119 220 158 47 18 181 29 146 179
	     136 4 253 56 112 7 59 161 28 84 54 127 155 254 254 49 227 251 99 198 245 119 6 240 56 156 143 33 14 17 12 98 3 196 90 140 73 182 2 124 234 7 108 174 17 33 219 236 5 188 24 227 168 223 42 81 81 1 64 121 225 112 247 157 151 243 91 110 144 93 136 6 251 224 83 36 6 223 123 60 130 19 161 211 139
	     40 215 26 44 175 174 177 184 188 66 173 94 167 222 104 174 171 192 38 151 3 7 78 204 134 24 188 195 194 237 119 94 29 31 238 186 60 213 157 127 117 86 30 239 154 164 247 113 169 25 31 25 39 28 25 38 110 214 184 126 231 14 67 95 101 24 27 27 226 240 212 4 254 112 158 169 96 115 237 7 217 71 99
	     95 81 20 229 249 173 181 143 83 225 110 47 94 99 115 237 27 191 222 228 55 169 232 222 247 9 186 192 173 197 46 127 252 242 50 127 248 244 75 238 44 23 48 195 19 4 35 33 206 102 240 206 61 52 192 217 149 13 23 121 124 179 236 247 240 235 80 182 191 28 219 37 235 109 253 93 192 199 113 146 33
	     24 59 48 22 147 212 143 78 54 177 36 169 35 180 169 14 212 125 25 5 15 116 156 159 142 202 241 172 198 128 142 47 21 0 20 229 73 87 183 190 65 149 199 76 163 91 15 226 211 214 126 98 147 116 172 40 138 169 55 155 52 90 45 138 229 42 133 98 137 98 169 196 234 106 145 94 167 149 180 246 11 67 176
	     54 169 13 96 211 103 211 133 237 165 118 18 36 204 18 75 150 184 209 166 90 42 241 205 197 107 136 24 140 120 126 242 206 105 126 114 238 24 135 178 178 158 244 215 119 73 205 174 44 164 138 4 138 162 40 79 111 13 151 117 127 98 48 101 187 16 71 124 127 121 145 127 249 248 50 255 254 241 55 92
	     185 118 151 40 2 51 57 139 100 242 169 0 172 235 243 203 61 120 6 108 182 119 27 255 142 29 88 131 119 14 231 45 38 12 65 44 222 216 52 219 84 112 235 57 6 178 158 110 224 95 212 235 35 131 158 143 58 204 42 0 40 251 48 148 129 199 233 94 254 104 47 243 232 207 189 151 187 224 110 80 130 197
	     164 173 253 2 156 115 116 162 136 98 165 194 210 210 50 43 171 107 84 234 13 226 56 38 138 99 8 2 48 54 249 145 164 70 192 186 90 171 188 220 51 166 159 219 159 27 198 134 150 78 220 226 199 43 215 25 201 11 46 142 56 60 53 197 208 177 60 67 253 49 200 214 132 211 157 68 0 117 46 21 69 81 158
	     230 26 238 211 52 229 193 206 45 6 184 187 18 241 187 79 190 227 223 255 227 11 110 46 151 97 104 12 241 1 206 102 82 63 70 83 254 149 45 54 123 189 250 179 7 231 240 116 241 206 224 93 12 38 192 135 217 180 101 96 186 1 224 210 227 0 235 195 233 1 173 162 15 100 252 239 239 187 78 90 254 66
	     5 0 101 159 225 188 199 185 56 45 132 231 119 17 168 63 101 161 224 41 44 209 2 24 155 244 110 21 73 22 167 102 183 75 220 108 82 173 55 168 214 27 44 44 45 178 184 180 76 181 84 38 238 118 145 76 38 81 109 173 69 140 224 55 237 227 42 202 134 209 150 108 14 76 22 95 141 41 172 174 242 231 111
	     47 83 109 198 96 66 22 223 61 205 251 167 166 153 29 203 18 240 204 228 54 69 81 148 125 140 60 215 215 24 20 98 5 104 57 40 183 59 220 89 174 241 175 159 92 231 255 252 195 55 92 190 120 157 200 230 9 102 142 226 37 147 202 3 123 23 252 191 200 141 120 95 206 225 44 137 79 32 30 226 52 160
	     247 49 136 75 178 70 226 0 130 0 49 6 143 36 217 164 253 135 109 26 4 59 141 140 189 246 26 118 122 190 189 26 227 105 123 68 239 33 138 112 113 148 92 15 69 5 0 101 159 16 251 164 149 201 122 37 252 135 25 79 185 127 93 122 70 145 204 163 166 254 123 159 84 232 53 214 146 201 100 176 65 0 70
	     232 116 187 84 42 85 202 197 18 139 203 171 84 27 13 42 213 42 205 102 147 24 15 129 77 90 251 49 120 190 223 233 88 81 182 49 160 105 7 8 231 241 153 44 126 100 156 122 207 115 241 218 109 108 96 88 92 45 224 255 230 67 126 241 193 9 14 153 245 210 65 184 77 139 165 60 7 231 88 81 20 229 0 7
	     255 15 172 241 247 224 224 127 235 81 172 114 23 190 186 186 202 31 63 187 192 127 124 118 145 155 75 37 92 126 28 108 14 143 73 58 4 249 193 71 63 249 21 120 150 199 176 21 158 194 152 219 174 126 195 22 137 223 123 240 17 244 28 62 238 226 162 16 9 3 8 66 68 204 122 49 108 211 247 48 125 226
	     132 111 42 13 225 159 66 231 160 173 207 41 3 159 201 203 158 140 72 33 201 178 1 15 81 143 168 215 77 50 34 20 21 0 148 253 65 38 8 200 4 1 86 34 252 122 144 123 128 190 198 109 139 180 36 39 250 140 49 24 35 120 49 244 162 136 118 167 67 179 211 161 222 106 177 184 184 204 218 218 26 43 75
	     203 116 59 93 226 244 236 150 100 50 128 172 55 45 240 106 158 149 135 25 58 239 146 243 0 97 14 51 153 199 116 154 84 203 69 190 254 225 10 243 203 37 156 131 122 212 229 23 175 29 230 196 196 48 86 100 155 58 0 26 244 43 138 162 60 11 250 235 111 7 88 172 116 248 226 210 2 255 242 31 223 240
	     199 191 124 203 194 194 50 81 102 8 51 117 4 92 63 136 83 251 255 82 227 182 154 105 243 96 117 64 250 213 1 1 98 136 35 136 60 206 68 136 11 49 62 61 16 232 13 24 147 214 14 50 56 239 19 177 233 190 231 29 232 60 176 39 173 4 119 83 132 211 63 249 107 196 113 210 17 32 159 101 104 120 136 108
	     152 209 177 164 2 128 178 95 200 229 115 12 141 228 201 182 123 68 221 30 206 111 180 47 59 72 42 128 27 200 163 18 17 140 181 132 97 72 152 201 210 137 122 148 75 101 10 133 53 22 87 215 168 183 218 148 138 37 90 237 54 173 118 59 41 220 210 151 92 189 172 47 179 26 146 41 187 247 15 76 90 72
	     202 16 145 129 32 79 163 211 227 198 220 50 127 250 242 60 197 74 137 198 175 222 225 55 191 124 131 19 227 195 235 99 203 61 192 157 80 20 69 81 246 134 56 181 233 131 107 109 177 11 95 254 56 207 127 255 221 167 252 225 211 243 204 45 149 65 2 144 44 198 91 60 50 176 49 162 40 143 234 154
	     186 141 96 216 167 245 1 162 30 206 59 36 142 1 139 132 33 98 3 140 77 11 4 248 141 2 149 126 48 246 63 120 110 57 196 17 161 49 68 19 99 204 204 206 48 54 58 172 99 66 5 0 101 223 8 0 185 12 195 249 44 97 96 160 237 210 14 127 46 61 243 190 151 5 111 158 78 194 155 31 120 30 177 137 121 23 132
	     216 123 226 110 151 174 243 212 234 13 22 150 150 152 95 156 103 97 97 137 94 55 34 234 244 144 76 144 156 245 23 195 122 159 22 191 57 137 75 81 118 99 231 18 99 157 28 167 193 134 200 196 52 1 93 162 122 153 59 119 23 40 174 22 233 182 58 216 108 192 63 126 248 42 199 199 134 215 167 132 10
	     77 138 162 40 79 119 125 30 252 119 59 114 44 55 123 156 191 190 198 255 252 228 60 127 254 252 60 75 115 11 216 161 113 204 248 97 98 103 180 218 191 114 223 40 146 52 63 127 187 58 208 146 214 1 216 40 128 55 88 9 95 210 99 165 2 177 75 218 72 70 113 210 89 202 123 76 16 35 233 230 149 23 65
	     72 138 78 175 215 25 242 130 91 207 204 31 232 32 176 175 181 15 15 113 68 38 180 100 198 71 57 116 232 16 163 195 35 58 148 84 0 80 246 11 214 8 129 21 140 248 68 173 116 240 56 105 70 207 109 45 18 210 214 126 134 32 19 18 134 89 122 81 68 179 213 164 88 42 80 107 52 41 148 170 172 22 86 169
	     84 170 52 171 53 112 62 253 136 2 129 128 241 3 135 174 52 236 87 158 116 76 10 98 45 81 28 227 9 169 53 91 212 10 107 252 89 174 98 194 16 215 137 249 205 47 222 230 208 68 150 172 94 45 69 81 148 167 70 63 155 175 159 217 216 1 174 23 90 124 126 225 14 255 241 249 5 62 249 252 123 238 204
	     173 65 28 128 201 34 36 45 219 220 83 78 251 87 79 227 224 11 2 143 245 56 239 210 135 39 237 3 189 7 23 91 136 99 188 49 72 16 96 44 105 247 169 221 156 64 121 156 205 53 121 202 35 211 3 49 248 8 99 12 97 152 97 56 151 35 27 134 58 116 84 0 80 246 77 172 98 64 36 73 116 147 126 170 219 35 206
	     127 241 187 93 16 246 24 35 24 4 151 158 183 242 233 238 125 171 211 161 82 173 50 191 184 196 210 202 10 149 74 157 78 167 3 24 36 151 79 20 92 239 215 11 253 37 111 79 205 177 178 119 142 129 119 49 130 65 70 198 48 12 19 133 21 26 237 46 223 95 186 77 214 102 8 134 70 248 233 59 39 56 59 154
	     33 180 6 35 242 96 147 220 223 9 120 148 66 152 254 17 108 190 162 40 202 129 114 94 118 191 4 122 146 142 71 205 40 230 110 181 195 215 63 206 241 135 191 124 207 231 223 94 100 121 105 149 96 120 28 127 104 24 143 197 251 24 239 37 61 210 229 159 74 160 174 222 198 65 27 107 178 241 189 237
	     224 43 238 232 66 250 45 142 178 217 82 229 223 197 224 28 177 143 129 0 241 96 145 244 37 77 234 171 38 117 169 252 214 10 129 59 52 21 190 63 61 97 155 201 227 183 187 187 127 140 75 35 3 79 147 168 21 146 214 45 240 233 239 65 50 179 54 127 116 69 5 0 229 249 50 58 156 97 108 52 79 46 180
	     136 143 192 153 131 17 39 136 96 3 139 216 0 188 39 238 245 168 84 43 116 218 93 150 87 215 168 86 171 44 173 172 80 40 150 160 211 78 214 181 76 14 130 164 21 160 24 163 49 191 242 84 117 0 143 193 152 144 152 8 76 142 122 171 195 213 59 43 212 58 17 213 94 151 155 115 167 249 191 252 226 117
	     206 28 157 97 54 31 110 239 51 232 149 84 20 69 121 228 0 187 95 233 191 191 243 191 218 232 240 253 237 37 254 124 254 54 223 93 186 203 167 223 94 102 121 105 5 186 14 166 38 176 225 16 18 59 173 84 174 60 187 65 138 7 23 165 9 1 2 196 120 28 206 69 72 20 164 29 169 44 152 32 9 180 141 108
	     58 166 186 175 93 116 60 62 238 17 74 200 120 62 195 228 216 8 249 172 22 1 84 1 64 217 55 188 62 105 229 214 112 214 103 66 155 156 75 74 5 0 89 215 240 246 79 16 226 7 34 34 17 1 177 136 53 16 197 116 227 152 66 177 68 177 80 100 126 97 145 78 167 75 187 215 195 4 1 222 14 165 193 190 73 133
	     79 81 9 94 121 250 99 21 112 222 37 191 231 134 176 46 139 68 109 154 157 22 151 47 95 167 94 88 101 196 120 194 95 15 49 121 116 148 192 164 226 212 192 115 244 127 239 171 236 143 149 9 160 40 138 242 162 174 181 3 107 226 166 29 255 254 218 233 161 29 59 110 44 149 249 243 87 215 249 248
	     171 139 220 91 42 208 104 52 8 70 199 136 36 132 32 139 139 227 228 65 253 221 127 93 98 149 71 9 120 183 216 232 29 157 130 205 131 183 31 45 179 94 229 223 69 248 94 156 8 81 46 76 162 42 49 24 107 6 202 2 248 141 13 44 25 112 140 183 237 138 53 240 6 118 106 99 184 7 243 111 176 102 152 8 136
	     247 224 99 2 113 12 229 51 12 15 231 201 170 0 160 2 128 178 191 152 28 11 200 101 73 22 30 183 79 237 158 200 186 2 42 34 56 231 105 52 91 52 59 109 106 141 58 173 118 135 249 249 5 214 10 5 106 107 5 156 243 16 132 96 3 196 26 196 136 198 252 202 115 112 78 1 146 115 125 248 24 231 98 42 245
	     38 149 213 18 115 119 22 17 27 210 140 13 242 171 55 56 60 61 197 212 72 134 172 217 92 126 83 30 232 77 168 151 170 40 138 50 184 50 246 75 24 119 156 167 222 236 112 225 214 34 255 252 233 37 62 254 226 10 223 94 186 78 167 23 129 55 216 177 41 108 54 143 75 143 102 227 117 69 85 158 215 192
	     77 171 85 196 113 154 17 16 39 29 170 156 195 56 7 177 69 172 5 49 169 216 181 158 104 159 62 129 217 63 254 128 247 72 220 131 168 67 54 24 230 240 196 24 39 143 78 51 49 54 164 223 179 10 0 202 126 34 27 58 68 34 92 28 225 98 51 80 248 191 111 74 31 20 128 236 114 61 216 166 78 201 110 151
	     42 79 162 174 218 192 98 131 128 48 147 165 221 233 82 170 214 89 90 89 97 121 109 141 110 183 75 165 82 165 221 233 226 131 48 125 144 1 147 84 85 189 111 113 74 69 133 71 255 36 187 212 43 246 228 170 41 47 148 18 224 61 216 0 67 30 31 123 34 98 22 86 75 252 229 219 75 140 231 2 62 252 96 152
	     169 145 204 125 51 238 254 76 0 191 195 72 146 221 13 66 69 81 148 253 30 197 63 108 45 243 131 107 226 198 221 100 224 247 88 132 75 11 69 126 247 249 37 62 63 127 133 165 66 153 158 183 152 108 22 71 128 183 22 113 126 147 158 186 233 104 180 223 218 219 93 81 182 223 237 223 154 157 231 119
	     115 198 116 176 248 244 96 250 95 127 32 58 7 113 132 115 62 217 200 10 67 36 8 16 177 235 34 128 27 124 45 241 105 131 128 129 247 224 239 159 68 178 101 142 249 61 28 218 66 186 251 159 30 111 8 68 24 202 229 24 27 27 34 155 215 12 0 21 0 148 125 197 72 70 24 206 10 25 35 116 240 136 119 105
	     239 219 189 53 120 254 113 98 19 73 138 161 56 15 46 138 104 182 219 120 26 84 107 117 238 205 47 50 191 184 192 218 202 10 0 46 114 120 107 33 8 210 181 80 192 152 129 215 245 247 57 9 79 51 32 127 58 141 15 149 3 233 201 250 180 165 84 144 1 19 130 88 162 168 203 205 197 50 119 23 139 84 170
	     93 174 46 247 104 255 195 187 156 59 49 206 161 188 101 196 154 245 113 180 243 126 255 160 250 175 40 138 242 242 173 176 131 235 98 15 232 246 28 45 60 95 221 90 226 255 247 219 175 249 221 127 124 205 220 221 21 162 48 135 51 25 108 110 152 192 218 196 175 240 219 183 10 84 148 103 40 41 108
	     63 2 157 3 31 39 217 251 198 224 93 132 196 1 38 204 32 198 166 66 64 223 199 245 200 160 103 235 159 223 39 17 60 248 30 116 219 228 140 227 216 161 97 206 30 30 226 205 156 110 75 168 0 160 236 43 94 29 31 146 207 2 235 131 208 96 227 254 233 255 231 104 208 189 199 88 131 53 1 65 24 16 134
	     33 157 168 71 171 217 164 80 42 81 173 86 41 150 42 44 175 21 169 55 26 68 145 219 112 3 68 214 171 251 123 217 186 184 74 218 107 85 191 115 229 185 200 0 201 160 20 131 183 73 3 192 110 228 232 118 123 220 156 91 165 220 252 146 156 105 211 253 171 247 249 187 183 143 221 103 84 99 250 73 126
	     219 201 87 251 169 90 135 162 40 202 211 143 52 250 150 223 14 220 28 2 197 8 126 184 181 192 111 63 253 142 207 191 189 204 82 161 74 187 231 33 19 64 24 226 141 197 139 197 247 107 180 236 54 46 83 20 30 188 187 191 254 183 126 245 254 109 50 2 118 204 18 240 155 109 185 193 173 39 252 57 231
	     32 138 192 37 231 255 189 177 72 16 98 108 136 24 155 132 221 178 241 210 27 89 1 242 204 231 37 146 108 216 209 108 226 122 13 198 135 29 135 243 58 153 84 0 80 246 37 227 195 57 38 70 135 233 250 40 173 222 25 39 21 246 159 71 160 100 12 14 193 199 49 189 56 166 219 235 81 107 52 40 85 42 220
	     190 119 143 197 229 21 154 149 10 81 47 194 135 89 200 12 164 21 221 183 216 233 162 163 236 51 17 0 64 44 38 204 34 86 240 65 134 181 106 139 181 187 115 244 170 5 138 165 6 33 127 203 123 231 14 51 108 29 67 129 193 203 198 226 234 119 20 1 20 69 81 94 158 181 180 159 29 21 145 28 151 110
	     197 49 245 182 225 227 31 238 240 219 143 191 226 143 159 127 203 194 74 133 56 200 194 200 24 146 25 2 73 252 11 156 219 101 52 163 40 143 164 14 236 181 183 144 110 108 121 136 93 90 172 219 129 49 136 139 177 129 199 4 97 178 177 144 120 239 12 156 143 25 200 123 125 54 209 191 79 133 13 107
	     128 192 50 158 11 56 50 97 121 117 44 171 147 73 5 0 101 63 50 148 201 48 146 207 82 110 122 162 245 254 157 236 42 200 120 216 217 39 89 239 97 186 97 82 101 96 177 236 159 199 23 35 100 178 89 108 152 161 215 139 104 181 219 20 75 37 90 237 22 43 133 18 245 122 157 213 66 129 82 169 12 237
	     118 210 18 197 102 192 222 191 174 200 14 231 251 61 126 189 29 235 211 12 159 182 219 143 213 80 77 217 200 84 1 140 1 66 144 128 94 187 7 61 199 205 249 53 58 127 249 150 32 12 89 173 189 195 7 175 30 229 221 217 205 133 115 54 14 231 200 3 71 149 118 12 80 20 229 64 242 144 34 58 158 141
	     35 211 253 221 255 158 129 107 139 117 46 94 91 226 95 254 248 53 95 95 184 202 157 249 34 113 228 96 100 8 194 44 98 109 114 20 203 13 158 237 223 186 11 43 59 188 17 255 208 53 119 167 85 249 225 143 82 94 188 49 188 115 45 0 191 75 145 96 195 143 28 232 111 225 72 10 6 166 117 133 188 115
	     208 223 176 51 1 98 12 98 88 175 125 21 227 211 49 237 55 215 189 146 237 68 11 25 40 16 32 15 246 106 253 150 131 137 166 127 115 242 222 178 65 128 31 25 225 208 228 40 19 35 89 29 15 42 0 40 251 149 241 145 33 166 38 70 40 52 29 213 142 195 185 24 67 184 167 175 241 160 114 130 62 61 191
	     228 28 248 200 81 111 180 40 85 43 220 185 59 71 161 92 160 184 86 34 238 69 68 222 35 18 192 208 112 162 110 202 195 206 62 187 93 220 242 116 112 58 172 148 109 231 129 91 31 32 62 61 182 98 178 121 228 200 81 156 235 50 127 103 129 255 243 95 255 192 205 249 101 254 215 127 248 37 217 191
	     126 157 217 225 128 177 140 37 242 172 119 180 144 7 206 42 69 81 148 23 143 254 218 39 64 236 33 246 158 114 199 115 183 218 225 95 63 185 194 199 159 125 197 119 223 94 162 26 121 36 63 130 96 144 32 139 23 155 238 250 63 170 32 42 143 28 198 155 237 117 11 229 37 10 252 247 106 172 251 173
	     131 200 164 227 208 123 124 236 112 113 4 38 66 194 76 146 9 16 132 24 17 124 234 105 24 1 143 195 63 242 184 119 59 204 131 7 205 19 159 136 17 113 143 209 161 28 227 19 121 206 157 62 193 212 200 152 142 11 21 0 148 253 202 79 95 57 36 171 149 200 47 148 123 84 154 53 162 200 17 100 242 79
	     121 157 20 130 48 81 44 17 161 211 139 40 215 106 212 235 13 86 214 138 84 235 13 22 150 151 40 87 203 184 70 35 89 0 51 57 8 66 36 72 187 21 56 53 173 202 193 116 96 7 141 170 216 12 38 155 163 215 105 226 122 21 22 239 174 178 214 190 132 195 18 117 91 188 125 122 146 95 157 59 193 200 248
	     16 170 165 43 138 242 50 174 155 131 59 255 144 36 255 221 45 54 249 226 218 18 23 111 174 240 111 127 252 154 11 87 174 209 92 42 39 41 255 227 185 100 215 95 76 114 108 234 57 249 11 234 165 40 123 139 91 175 23 224 93 226 7 123 60 248 24 113 17 206 90 176 65 114 76 192 216 164 250 149 200
	     186 56 225 30 154 129 240 4 57 43 113 4 81 151 145 252 40 39 14 79 240 202 169 83 76 143 143 235 87 166 2 128 178 159 153 153 26 101 52 95 1 95 193 197 105 138 145 184 52 93 73 30 42 108 122 239 147 116 255 7 40 133 14 146 148 59 159 222 203 216 36 59 73 12 173 118 155 249 197 69 22 23 151 88
	     90 89 37 142 29 173 94 47 201 52 202 229 146 69 201 216 164 67 138 223 221 177 4 61 194 167 236 87 71 118 235 141 62 74 179 91 166 102 33 238 210 235 246 248 254 194 101 26 165 101 126 60 123 132 168 251 75 222 125 231 44 167 198 242 201 73 63 145 245 157 38 97 203 209 26 52 245 95 81 148 131
	     191 86 10 27 197 254 252 64 218 127 207 121 150 203 77 254 242 253 109 254 199 31 191 230 242 237 57 174 223 88 160 131 197 28 58 130 15 50 32 1 222 155 129 53 119 107 171 212 199 234 77 164 40 207 111 70 108 242 125 77 50 25 124 82 211 194 245 186 72 20 129 53 201 70 153 13 17 43 136 5 99 210
	     226 216 105 157 128 68 48 72 55 210 30 199 87 144 29 222 95 28 97 162 136 124 198 114 100 106 130 99 135 167 153 24 25 210 175 78 5 0 101 63 243 211 211 195 242 195 205 192 27 233 215 0 136 241 155 234 235 62 201 194 144 44 50 214 8 222 8 70 44 81 20 209 236 116 169 53 234 180 218 29 138 165
	     50 243 115 115 44 47 175 210 169 84 18 5 51 19 66 24 32 97 6 250 5 78 6 142 67 41 202 139 130 243 96 36 64 134 135 240 190 139 175 148 88 91 46 176 182 186 202 189 197 53 124 16 114 123 173 198 63 125 244 26 211 135 38 153 204 75 218 21 64 93 87 69 81 94 108 17 160 239 90 196 64 189 29 113 229
	     238 50 31 95 184 195 87 231 111 240 187 207 206 179 186 86 132 86 12 211 51 216 209 49 240 22 31 187 1 95 65 119 255 149 23 145 126 74 76 12 49 120 34 112 38 57 31 99 61 132 30 113 22 156 77 54 208 140 193 208 79 134 241 143 113 52 96 39 71 95 18 113 162 219 133 86 131 124 102 134 211 199 38
	     57 119 124 146 183 166 181 5 128 10 0 202 190 39 151 129 32 48 88 34 12 14 239 13 236 208 24 112 112 135 113 211 142 188 108 105 80 150 254 195 24 131 177 73 186 127 16 132 116 162 136 74 163 198 194 252 34 107 133 34 213 90 141 106 181 78 207 69 144 207 129 216 68 201 196 164 207 177 205 187
	     120 96 1 31 181 190 202 227 153 178 231 53 124 60 130 119 113 82 28 51 155 7 3 62 110 83 108 116 249 242 135 155 220 91 44 210 109 118 248 232 195 247 249 249 217 113 194 236 253 165 58 229 17 94 237 201 174 142 162 40 202 179 139 164 141 64 61 114 124 117 107 141 127 254 221 151 252 229 251
	     235 172 149 235 148 106 29 200 142 32 161 5 27 226 99 151 238 116 238 230 121 229 17 214 72 255 208 229 113 219 206 110 138 250 20 123 61 30 124 154 215 226 13 155 82 1 251 175 236 92 34 6 248 152 216 6 136 13 48 97 0 132 136 17 172 248 52 179 102 167 26 23 15 235 168 37 155 212 57 73 183 34
	     124 20 33 221 14 25 235 152 158 202 243 222 209 33 117 32 84 0 80 14 2 147 99 57 102 38 71 105 199 77 140 244 136 34 143 9 236 3 191 218 173 169 198 155 83 156 147 234 254 24 131 119 142 78 39 162 211 237 16 121 79 161 82 166 88 40 50 63 191 192 106 161 132 107 119 146 135 100 67 36 159 79 98
	     123 239 183 79 153 86 148 167 108 176 159 125 17 71 159 110 84 197 128 96 115 57 76 46 67 220 203 210 238 117 249 241 206 10 87 239 44 211 234 9 115 197 136 248 31 222 230 204 137 9 102 242 33 227 161 197 63 214 2 252 176 153 165 69 6 21 69 121 126 196 233 90 220 232 198 68 174 199 23 87 151
	     248 63 254 248 3 191 251 228 60 55 174 207 35 217 12 158 128 96 120 4 130 76 210 38 205 175 175 166 79 16 252 63 126 200 166 254 138 242 236 124 10 191 229 5 251 57 129 14 34 151 252 213 198 120 27 131 119 152 192 131 181 96 64 196 36 97 255 182 71 0 228 225 47 187 126 210 214 131 239 33 46 70
	     194 128 236 232 8 199 14 141 115 124 102 68 7 129 10 0 202 65 97 124 108 140 233 201 136 82 195 211 234 117 137 93 23 241 89 16 151 6 3 219 247 31 23 145 141 96 189 223 126 204 88 140 49 132 97 128 177 1 157 118 151 118 187 201 106 161 72 185 94 99 117 181 64 173 94 167 222 172 227 92 156 86
	     55 77 85 68 239 55 181 252 217 188 240 232 249 126 229 5 242 10 252 246 247 113 94 240 222 224 124 114 252 197 121 143 139 123 220 156 95 166 222 108 34 174 194 79 223 121 131 191 250 224 12 19 147 67 201 244 73 159 206 177 101 83 64 81 20 101 31 211 95 183 250 155 138 118 224 255 214 195 74
	     185 197 215 23 174 240 111 127 254 142 47 47 47 176 90 106 128 100 240 146 129 32 36 194 96 188 224 189 60 65 90 179 162 60 149 208 124 221 22 239 185 56 116 223 147 250 251 127 119 2 68 56 146 150 129 4 1 132 73 125 0 35 126 125 51 127 195 237 150 29 62 140 223 34 50 12 72 27 113 15 227 99 178
	     249 44 211 249 33 142 28 62 196 196 80 94 7 129 10 0 202 65 225 208 248 40 39 143 66 185 222 102 121 173 77 35 238 34 97 0 216 251 147 225 118 232 51 222 175 56 234 129 94 28 19 197 14 31 183 169 54 26 148 42 85 230 23 23 89 45 20 40 23 138 73 224 31 4 72 218 190 100 176 229 201 67 23 202 71
	     207 121 86 148 3 227 57 120 124 162 117 217 16 177 153 164 30 134 143 40 84 27 172 44 46 208 172 149 89 90 109 224 36 164 251 222 41 142 141 24 198 51 33 109 73 22 98 175 34 128 162 40 7 40 88 26 252 137 60 224 29 165 174 163 25 5 252 233 251 57 254 249 183 95 241 199 79 191 162 220 136 8 166
	     102 48 19 19 96 44 78 44 224 211 234 230 186 218 41 251 47 248 223 115 100 23 71 87 250 193 186 120 240 17 68 130 35 78 42 245 187 24 27 132 72 96 211 98 128 66 127 147 207 203 118 94 195 206 199 95 12 142 184 219 194 74 204 204 204 4 175 157 156 229 173 87 78 49 57 162 2 128 10 0 202 129 225
	     181 9 164 214 206 250 219 35 134 149 213 94 82 85 52 147 5 187 57 181 95 182 8 1 146 46 72 201 142 127 136 177 1 177 247 52 154 45 202 213 10 149 114 149 66 169 68 181 217 164 84 169 80 173 86 137 187 221 228 9 108 176 181 55 218 67 214 189 45 231 158 253 22 23 66 88 239 68 224 53 23 79 217
	     15 198 250 73 222 84 42 166 225 147 130 156 189 30 208 113 220 91 170 16 203 117 108 16 176 178 182 194 251 175 28 225 231 111 159 102 60 23 220 87 186 115 251 233 181 155 190 190 138 162 40 79 159 193 93 127 128 88 96 174 210 225 235 43 115 204 175 214 248 227 103 23 249 242 210 109 202 229
	     14 222 4 244 98 129 48 0 49 201 143 119 244 11 162 9 15 232 20 180 169 94 145 60 120 185 219 93 17 129 7 175 155 143 253 188 138 178 71 142 132 223 82 57 219 1 81 210 14 80 124 144 28 9 176 54 77 194 181 120 145 36 27 199 111 39 38 108 126 118 35 32 206 67 167 9 190 203 80 102 154 147 199 142
	     112 250 228 17 198 71 181 105 177 10 0 202 129 226 163 35 25 185 114 199 248 161 44 132 6 12 73 87 128 228 80 190 108 99 79 251 167 237 146 109 123 227 33 118 49 221 94 76 165 90 227 238 220 2 11 139 75 20 74 69 98 239 215 207 65 153 124 62 109 237 35 143 22 107 12 26 109 191 67 145 158 65 5 83
	     141 173 178 159 68 128 71 174 189 151 244 252 77 218 248 10 146 27 66 50 25 98 23 115 119 185 64 237 211 175 249 241 218 45 110 188 255 58 113 152 227 163 215 143 115 52 11 221 212 161 30 124 170 71 23 1 20 69 81 158 254 146 216 79 255 239 59 145 215 138 77 190 255 113 129 255 254 135 111 184
	     114 251 46 87 110 206 81 239 120 130 67 71 240 18 224 173 37 150 52 255 217 187 13 211 175 75 154 162 108 239 80 244 39 135 79 218 245 121 231 240 206 129 181 72 16 224 109 144 20 234 78 55 245 18 191 159 237 39 150 248 245 51 3 130 135 184 135 149 30 135 199 114 156 59 62 205 169 217 17 94 31
	     214 217 168 2 128 114 224 24 31 14 25 206 101 200 4 17 34 16 19 39 59 144 91 170 238 139 49 132 65 144 236 202 11 180 187 61 26 205 38 181 122 147 74 181 70 161 92 98 113 121 153 194 106 129 168 209 128 64 32 147 65 108 128 88 187 67 16 255 36 11 220 214 243 79 186 254 40 47 138 147 44 8 137
	     82 239 195 28 190 211 194 53 90 172 213 138 148 86 235 180 58 14 147 9 88 94 93 227 239 222 62 197 248 212 36 135 50 219 59 219 162 179 67 81 148 231 20 236 247 255 63 120 68 201 146 20 252 91 109 196 220 190 59 199 31 46 222 230 202 205 85 62 254 230 10 243 139 75 244 170 13 24 30 71 70 134
	     193 4 184 40 222 241 249 183 45 105 182 83 215 34 69 121 74 241 246 182 3 255 121 206 60 223 183 252 125 193 204 37 253 0 93 140 247 105 209 192 192 37 199 113 141 65 76 114 156 87 210 13 53 239 7 253 117 73 69 2 135 37 166 231 34 194 140 231 232 100 150 87 143 14 241 182 6 255 42 0 40 7 84 0
	     200 231 152 30 31 165 82 247 180 99 67 51 114 96 98 4 139 247 27 106 189 241 62 217 149 52 134 216 59 90 157 14 133 181 34 243 11 11 172 20 138 52 218 29 58 157 14 145 119 72 62 109 107 38 102 189 70 192 99 45 99 15 52 222 91 82 255 213 206 43 47 16 142 84 120 119 128 201 32 195 227 152 56 143
	     143 35 230 87 139 252 235 127 124 206 181 107 55 168 22 126 201 79 62 120 135 159 189 62 65 142 245 154 192 244 93 102 147 254 168 8 160 40 202 179 12 254 7 119 251 221 22 167 177 20 193 31 191 191 203 167 159 127 201 239 191 186 68 179 19 179 88 172 19 5 89 100 114 24 31 102 136 188 32 206
	     179 125 103 96 255 240 250 65 26 151 40 47 181 7 177 213 93 118 201 205 221 30 142 8 226 0 162 24 31 6 72 16 96 3 11 94 146 174 26 126 208 255 78 102 179 143 35 48 17 67 67 89 142 76 100 56 123 116 148 227 147 26 10 170 0 160 28 88 142 140 13 209 58 62 77 163 29 115 111 165 74 187 229 176 57
	     33 147 77 42 146 99 4 47 134 56 142 105 180 218 180 218 45 154 237 14 197 114 153 149 149 85 22 151 150 169 85 170 137 186 24 216 164 226 104 16 12 40 136 30 156 91 55 200 247 159 235 247 155 148 198 205 81 202 46 122 149 170 194 175 188 48 46 243 230 113 190 238 248 90 139 132 67 72 156 129
	     168 77 163 213 164 86 88 99 121 97 141 94 28 114 111 173 73 181 249 38 71 14 141 112 118 102 130 201 172 172 23 7 148 7 5 254 222 111 126 101 117 152 21 69 217 35 250 187 253 131 25 0 11 141 30 203 165 26 63 220 88 225 127 252 225 27 190 187 112 153 171 87 111 99 114 57 156 205 97 114 195 248
	     220 112 178 131 233 92 26 132 236 162 166 122 186 118 233 10 166 188 56 179 231 17 107 91 60 116 158 108 248 226 62 45 188 73 28 131 15 241 46 2 31 130 9 232 239 248 139 152 164 75 81 191 91 87 171 137 183 29 166 38 70 120 247 141 83 124 248 250 25 142 142 231 244 171 82 1 64 57 168 188 50 51
	     34 62 200 248 213 82 147 197 213 34 221 78 155 108 144 65 114 2 198 98 2 11 98 104 119 187 172 150 74 172 44 175 80 170 84 168 212 234 212 26 13 58 157 14 98 77 98 233 77 90 84 196 251 52 67 223 63 222 206 252 35 21 211 81 147 175 60 5 219 187 171 177 183 135 184 7 15 231 196 110 75 98 160 195
	     44 38 63 70 215 59 190 187 122 155 187 203 171 220 153 159 227 220 153 147 252 211 95 127 196 135 111 77 51 189 197 29 208 70 26 138 162 60 11 6 43 252 15 22 251 43 121 248 244 135 121 254 244 197 15 124 123 233 58 23 174 223 163 27 59 36 63 2 54 196 4 57 188 4 72 236 241 59 44 186 91 5 77 207
	     179 76 254 211 213 243 101 48 253 207 103 124 109 243 202 143 85 84 210 108 63 27 7 54 225 144 244 62 62 61 22 16 197 224 12 46 142 32 204 32 146 100 4 200 192 91 115 36 197 255 196 118 153 157 158 229 39 239 190 193 59 175 159 230 236 120 70 39 133 10 0 202 65 230 213 201 140 220 59 52 234
	     239 46 13 83 168 123 76 104 1 71 183 23 211 107 199 180 187 61 10 165 50 139 75 203 44 47 175 80 173 84 232 118 122 128 71 194 0 201 102 147 133 37 93 156 54 138 5 62 110 244 228 247 228 46 138 178 239 61 229 221 220 41 21 211 60 130 177 33 198 90 36 63 132 68 17 149 74 145 202 242 42 107 107
	     101 46 223 41 208 118 194 74 237 53 126 118 122 156 227 83 99 216 208 144 221 230 101 69 167 144 162 40 123 184 148 201 54 161 114 199 67 212 233 114 179 84 227 242 92 149 127 254 211 247 252 246 227 111 88 188 123 15 215 233 18 204 30 38 152 152 70 188 224 8 210 30 229 79 190 50 61 240 57 252
	     19 124 72 69 121 42 227 66 246 240 181 228 1 119 30 44 158 157 158 49 140 1 39 248 56 6 231 146 86 196 222 131 53 96 12 136 39 16 71 228 34 194 140 112 250 232 20 31 158 59 202 219 19 26 252 171 0 160 188 16 28 154 26 229 216 145 195 52 163 33 26 61 79 179 19 81 171 54 40 148 43 172 21 203 20
	     202 101 202 149 42 173 118 135 168 219 75 22 8 17 60 130 247 114 159 238 168 40 202 147 184 3 105 141 139 45 82 90 236 5 143 73 148 123 111 192 230 32 128 90 51 226 218 220 10 238 79 95 112 241 210 69 174 189 247 10 255 248 235 159 243 206 107 179 100 195 205 46 129 3 157 175 138 162 60 49 110
	     75 168 49 184 227 47 192 66 197 115 253 250 29 254 253 47 223 240 227 189 2 23 111 21 152 95 41 37 233 198 185 28 145 207 128 179 136 239 87 46 215 40 91 81 69 225 209 238 190 211 17 218 135 221 127 32 191 161 127 36 160 23 225 99 143 143 29 98 12 146 49 120 99 9 67 33 206 88 198 199 178 156
	     153 157 224 204 140 182 253 83 1 64 121 97 120 247 112 78 42 205 195 190 217 53 92 187 189 200 242 226 10 203 197 6 171 229 42 139 171 5 154 205 6 113 236 145 76 136 100 51 120 49 3 193 202 131 50 244 101 203 218 227 31 122 31 69 121 249 34 254 29 122 74 111 51 93 156 7 193 32 129 96 198 39 147
	     51 182 174 77 28 245 184 113 243 46 183 174 52 41 172 20 105 199 121 218 30 222 63 53 78 38 180 140 101 66 188 12 204 215 244 53 85 12 80 20 229 73 195 20 79 178 153 24 57 40 183 187 52 186 93 62 249 110 145 47 190 249 158 223 254 233 43 22 215 42 116 201 16 228 242 200 248 36 206 132 224 92
	     162 101 62 105 240 191 165 158 137 162 188 112 2 192 122 154 141 60 228 113 114 255 109 34 59 60 255 96 203 192 129 186 27 206 39 221 1 4 124 167 139 25 182 76 140 13 241 230 171 199 121 227 244 33 222 158 25 81 167 93 5 0 229 69 226 175 207 228 101 97 57 242 75 115 215 56 255 237 85 106 93 67
	     71 66 170 181 6 68 17 136 197 71 113 146 26 36 27 202 161 31 88 115 68 207 201 41 202 211 115 2 210 89 150 164 202 10 130 32 98 136 99 129 158 39 106 57 232 196 92 184 181 76 203 127 206 237 229 101 62 122 251 12 175 157 158 229 231 111 158 102 118 36 216 229 226 237 183 125 221 205 62 183 31
	     208 47 100 27 159 252 193 127 63 120 223 131 174 109 202 75 48 30 253 142 203 206 125 177 200 214 176 162 6 220 91 107 243 197 133 27 220 158 91 224 211 111 175 115 251 222 18 55 23 42 184 118 15 50 33 228 12 226 44 198 24 220 142 167 253 31 111 101 84 148 167 105 121 159 233 171 62 118 225
	     30 191 101 150 110 177 195 155 196 178 126 17 238 141 219 241 105 163 78 239 240 237 30 172 46 18 141 133 156 121 227 45 254 246 103 111 241 243 247 207 232 32 81 1 64 121 17 25 10 122 116 154 69 214 86 150 168 71 33 225 232 36 18 4 144 205 226 251 189 69 101 96 161 145 173 78 255 94 172 133
	     234 104 43 47 157 7 144 90 232 173 59 89 242 224 56 220 123 240 49 198 134 144 183 152 92 14 203 33 76 220 225 230 189 121 10 197 53 238 206 45 243 179 247 223 36 204 230 120 251 220 12 71 173 193 90 75 96 100 221 61 48 251 41 216 120 70 47 37 187 122 132 127 54 111 238 201 223 172 242 2 126
	     21 126 203 191 228 89 189 155 135 188 204 224 159 29 224 157 167 30 197 220 168 69 92 186 60 207 239 254 124 129 31 175 222 224 234 237 57 28 1 217 145 41 226 113 139 199 224 189 193 137 35 142 163 3 181 52 171 50 161 166 255 249 188 242 67 148 0 121 196 178 133 50 208 65 107 253 238 169 47 47
	     102 224 239 14 226 46 180 170 100 70 134 57 125 120 140 247 94 59 198 71 83 186 251 175 2 128 242 66 114 242 208 40 231 78 31 227 194 143 243 92 153 47 208 170 20 33 51 140 140 140 165 98 162 215 10 98 138 178 239 28 22 3 8 14 139 19 240 189 30 190 210 161 93 174 83 104 196 148 91 17 133 122
	     149 183 206 30 225 253 211 51 156 60 113 140 87 103 199 25 9 100 211 105 131 65 87 67 173 188 162 40 91 195 19 97 179 96 88 143 224 222 106 133 243 87 111 243 213 213 69 238 206 149 248 242 252 53 238 205 47 65 181 6 67 35 200 216 40 98 50 73 108 33 162 238 131 162 236 67 18 215 222 33 46 198
	     119 219 132 38 194 12 101 56 123 108 134 159 190 117 146 15 143 141 233 69 82 84 0 120 81 121 255 244 81 185 252 222 187 254 214 82 155 181 206 121 86 87 202 16 245 16 121 178 186 254 138 162 60 101 231 220 111 152 113 159 203 65 112 24 33 34 12 132 149 66 145 79 191 40 113 243 218 13 150 222
	     122 133 95 126 100 152 26 31 101 100 196 174 63 79 196 70 210 160 65 176 15 145 0 30 150 214 47 90 219 67 81 14 102 20 176 101 234 186 129 229 101 171 243 87 105 70 124 119 101 129 255 249 201 215 124 113 225 38 221 200 80 109 70 100 71 70 232 12 141 37 173 75 131 76 154 191 160 103 245 21 101
	     119 243 112 239 103 201 125 53 184 6 108 180 89 63 14 0 226 122 248 94 155 204 144 97 124 246 16 111 188 250 10 103 142 78 112 118 50 171 70 93 81 1 224 69 230 191 254 205 27 82 169 119 252 205 133 69 214 86 75 248 184 135 241 49 177 23 68 213 123 69 217 7 30 250 125 81 127 18 248 147 182 227
	     52 25 76 54 196 187 136 118 183 77 167 86 163 216 40 115 207 90 22 87 27 44 151 99 10 213 58 111 190 114 136 179 135 167 56 52 61 70 62 100 189 101 160 112 127 107 175 103 32 97 176 255 242 14 212 223 81 116 60 218 129 245 160 5 180 219 49 183 150 138 148 26 29 126 184 182 204 31 191 188 192
	     23 223 92 96 249 246 2 228 135 113 185 49 200 228 177 217 60 46 237 20 164 97 191 162 236 39 127 97 59 92 114 26 192 69 208 172 51 60 58 202 91 175 159 229 63 255 245 7 252 250 237 19 122 41 21 21 0 94 6 206 28 31 103 102 114 132 48 176 116 35 159 164 4 121 65 140 69 48 169 146 184 71 206 136
	     60 32 30 216 203 199 40 202 126 231 161 245 47 204 206 1 180 12 252 190 126 147 224 131 0 159 27 194 217 228 177 171 245 22 95 95 190 206 90 185 200 197 27 135 249 171 15 222 227 87 63 127 155 115 227 219 187 10 155 222 145 223 156 9 244 196 187 252 242 236 206 217 203 51 120 132 234 14 207
	     114 174 60 155 235 246 60 191 10 121 196 119 178 93 225 205 254 109 79 58 87 251 143 238 1 119 43 61 254 240 245 85 46 223 154 231 202 173 37 110 207 175 80 109 3 227 135 112 54 68 108 14 108 0 94 6 246 252 213 72 43 202 222 249 2 187 193 236 114 225 76 110 79 94 210 32 56 232 118 9 4 142 31
	     153 230 221 115 199 121 115 118 74 173 146 162 2 192 203 192 111 222 59 45 63 254 213 187 190 214 232 114 254 218 61 170 205 106 210 175 119 120 20 214 75 17 169 170 175 40 251 17 193 167 177 186 32 38 3 153 16 147 205 131 115 52 91 117 238 220 90 98 225 214 60 63 92 157 224 246 74 135 197 186
	     231 103 111 29 230 212 84 192 248 80 142 201 124 158 140 81 157 77 81 94 154 120 99 7 137 33 6 154 177 167 88 107 210 108 181 248 97 174 201 15 215 22 248 247 63 125 195 213 43 183 105 149 42 68 24 204 232 4 102 108 44 233 83 74 82 76 204 233 138 161 40 251 223 95 72 138 115 32 81 7 223 237
	     16 102 13 35 71 103 248 232 189 215 249 155 159 189 205 175 207 29 213 224 95 81 1 224 101 226 63 253 245 123 148 28 204 175 173 82 190 55 7 65 30 59 58 66 228 101 215 229 254 183 238 66 40 138 242 108 156 249 13 41 32 193 98 240 98 112 65 14 23 25 162 168 75 183 225 248 238 242 77 202 149 10
	     215 126 60 204 59 175 29 226 131 55 95 229 167 111 159 89 63 14 48 248 156 46 157 207 253 99 194 73 1 225 189 217 97 84 20 101 47 28 249 135 223 118 255 58 145 4 250 219 57 119 22 40 180 60 159 253 112 139 235 183 238 240 249 165 121 230 86 42 220 93 170 82 110 57 176 89 176 1 206 132 88 2 48
	     201 179 58 175 130 161 162 28 4 111 65 68 176 198 16 53 154 248 82 1 57 60 205 171 231 206 241 215 191 250 21 239 188 121 90 47 145 162 2 192 203 198 187 135 199 165 249 203 55 253 173 235 183 41 46 172 82 110 116 113 189 54 222 199 24 155 193 75 122 230 88 205 188 162 60 11 247 254 137 30 235
	     124 114 36 64 178 67 16 14 129 119 8 49 197 213 2 149 187 55 185 254 67 150 111 207 156 224 206 47 170 84 90 49 239 191 114 152 137 108 64 38 19 146 205 88 2 17 236 54 129 131 162 40 7 31 147 206 235 24 104 59 79 175 219 163 222 234 49 95 105 115 254 218 34 191 251 248 43 206 255 112 153 249
	     91 247 232 249 0 55 118 24 59 60 66 108 44 34 6 124 26 244 247 69 127 93 37 20 229 96 120 21 46 2 231 48 113 68 16 192 185 227 211 252 211 175 222 227 55 127 253 58 63 59 146 83 101 95 81 1 224 101 228 23 39 14 201 197 95 126 232 23 23 43 124 126 254 10 149 74 9 8 49 227 51 152 76 72 236 156
	     238 238 43 202 51 195 61 166 40 32 235 167 112 5 65 12 224 45 145 115 16 27 162 174 208 233 182 104 220 89 33 146 75 220 91 43 241 206 185 19 188 122 100 154 115 103 79 241 234 107 51 28 221 242 170 27 207 247 164 231 164 7 207 41 234 90 162 40 207 60 0 216 50 135 87 219 112 233 202 18 151 174
	     223 226 194 173 101 230 151 138 92 187 181 192 189 133 18 174 233 32 148 116 41 50 24 177 32 6 143 199 173 215 6 210 121 172 40 251 222 95 48 22 196 227 154 45 92 167 129 149 152 195 179 135 248 201 187 175 241 243 119 79 106 240 175 168 0 240 178 243 243 55 207 82 249 135 46 237 110 196 151
	     223 93 166 211 232 66 220 195 59 139 12 20 3 220 100 242 253 35 180 251 121 28 95 65 253 11 229 69 241 188 119 61 174 253 19 76 4 127 223 220 196 131 49 2 163 227 248 209 81 76 220 3 98 238 204 173 49 127 119 129 243 223 95 227 228 137 227 252 250 231 13 126 217 137 249 224 228 24 83 185 128
	     140 177 4 129 197 74 250 17 68 246 240 34 60 103 127 99 63 55 36 80 246 213 80 121 148 153 42 207 234 133 30 227 197 98 160 23 59 196 57 218 113 76 185 29 243 217 229 2 255 254 241 247 124 249 237 119 44 221 155 167 231 45 81 144 37 200 143 19 13 79 226 141 69 196 2 6 188 3 239 210 108 64 118
	     125 60 80 81 148 231 179 50 173 31 225 243 46 169 23 20 117 177 113 143 99 199 166 248 229 59 175 242 247 63 123 155 115 39 198 245 114 41 42 0 188 236 188 123 100 88 162 95 190 229 215 74 101 214 42 45 238 220 89 162 209 109 66 175 139 205 229 48 97 22 231 52 225 79 81 14 148 27 144 250 235
	     198 6 136 24 60 1 157 110 155 78 171 3 181 38 165 82 135 59 165 46 213 142 227 234 157 121 190 123 253 48 111 157 60 196 171 199 142 240 218 169 89 38 182 177 2 110 32 6 209 248 89 81 246 7 253 121 105 118 208 10 22 106 93 74 203 43 92 91 92 229 242 66 133 243 151 151 249 234 210 109 230 110
	     205 67 185 10 217 28 140 133 144 203 99 195 76 178 94 56 135 247 131 85 70 20 69 57 40 8 30 223 235 226 137 193 199 140 141 13 243 193 91 103 249 205 223 127 196 255 235 55 31 168 249 86 84 0 80 18 62 60 154 151 171 111 156 242 243 43 53 4 195 141 123 243 116 26 117 36 180 72 16 14 100 253 165
	     235 134 22 4 83 148 103 107 208 119 89 112 115 243 95 13 177 75 66 4 65 32 204 65 152 129 145 49 16 135 193 115 111 126 137 197 59 55 185 250 67 142 215 78 31 231 215 63 255 128 32 200 240 202 204 48 185 208 34 34 136 217 104 25 176 207 246 244 21 229 165 196 111 243 111 71 122 78 223 123 156
	     115 244 156 163 218 142 184 120 109 137 111 127 184 204 87 63 92 230 214 220 10 197 134 163 214 5 59 58 134 27 157 72 82 252 109 176 177 94 136 67 252 224 126 162 162 40 7 33 236 79 138 254 129 224 240 221 22 134 152 225 124 134 179 167 143 242 211 119 94 229 253 115 71 245 50 41 42 0 40 155
	     249 175 191 126 77 194 76 198 143 14 91 92 220 230 198 157 5 122 189 86 58 34 50 136 205 104 61 0 69 57 112 14 65 26 32 136 128 24 16 143 4 130 119 93 162 78 155 66 189 10 165 2 203 198 113 125 161 202 106 61 102 165 90 231 173 51 135 121 243 228 12 19 163 99 76 206 76 50 150 133 161 45 225
	     192 96 157 0 69 81 158 189 8 32 108 236 252 199 64 197 65 161 212 162 176 86 224 110 177 204 237 249 50 151 174 45 240 253 149 91 92 186 118 135 110 161 4 65 6 70 39 144 252 40 146 25 74 158 203 251 77 199 135 250 57 127 106 241 21 229 96 9 0 46 118 88 98 104 215 201 132 158 215 142 159 225
	     55 127 253 46 255 229 31 62 224 103 167 166 213 92 43 42 0 40 247 243 230 233 73 214 10 71 185 117 235 48 197 98 133 181 74 131 56 246 144 15 48 161 69 92 140 247 254 1 221 1 228 1 174 202 131 214 173 190 227 33 59 60 151 186 33 202 65 243 206 31 115 46 236 244 168 29 197 183 237 139 13 108
	     78 210 241 169 111 239 210 168 221 35 94 240 97 8 102 4 194 16 35 14 172 225 206 210 26 205 79 26 252 112 33 207 59 175 191 194 235 175 188 202 207 62 26 33 63 109 136 3 73 138 12 202 150 246 99 254 33 211 255 65 31 255 89 186 35 234 250 28 172 232 118 159 126 127 242 188 94 200 111 92 23 145
	     141 196 60 231 147 249 237 188 167 214 240 124 119 163 196 183 223 93 228 242 173 155 44 175 85 41 215 187 148 170 13 108 54 135 28 154 197 75 0 65 22 76 144 156 239 247 79 190 62 41 138 242 180 215 3 191 101 121 48 169 111 192 198 162 224 5 226 24 71 15 211 235 145 207 90 78 30 153 228 253
	     55 79 106 240 175 168 0 160 236 204 91 51 163 18 126 240 138 247 221 46 163 35 89 190 184 112 139 187 203 21 122 113 23 223 51 136 8 70 236 122 186 225 246 94 155 217 147 128 71 69 0 229 5 176 216 123 56 23 158 100 158 200 230 232 1 146 214 94 18 128 177 216 76 14 239 29 237 78 155 185 165 50
	     115 183 23 176 214 112 113 174 202 91 119 106 44 214 218 188 122 114 130 215 143 12 51 158 11 25 202 229 24 29 29 102 36 52 132 219 124 76 205 10 80 148 189 215 65 182 158 188 235 1 141 158 163 89 111 82 110 183 88 44 183 185 112 171 204 231 223 223 230 139 243 23 185 115 235 14 81 189 5 97 22
	     50 25 200 15 99 243 25 4 193 139 193 33 154 213 167 40 47 132 167 225 240 206 97 36 198 245 218 228 178 194 196 201 25 126 242 198 49 254 111 255 240 62 255 207 191 121 75 77 178 162 2 128 242 96 94 59 50 41 229 247 206 250 122 207 49 191 214 96 110 181 14 141 38 190 215 133 108 30 147 205 39
	     11 142 215 144 92 81 246 109 224 224 119 22 28 54 110 77 218 123 197 72 114 68 32 200 36 202 158 24 188 8 181 102 135 27 119 239 225 93 155 203 87 44 215 142 77 114 116 122 130 55 94 57 205 187 111 14 37 193 255 67 2 23 217 73 171 208 197 67 81 118 45 0 108 231 189 135 64 20 27 174 222 91 227
	     135 171 55 184 114 119 137 91 75 117 230 86 27 20 75 85 98 155 129 161 32 153 215 54 0 27 224 196 222 247 108 58 21 21 229 32 174 13 73 46 174 17 192 121 124 28 227 92 4 213 10 241 112 200 177 87 206 240 183 127 243 1 127 245 209 235 122 177 20 21 0 148 221 241 179 51 71 100 36 151 247 189 8 172
	     49 92 185 126 151 213 106 157 216 117 193 5 120 146 54 65 234 56 40 202 193 14 44 192 164 98 65 42 0 216 16 241 121 16 79 163 211 165 113 111 153 249 185 57 140 235 113 228 240 4 71 15 79 241 179 119 75 44 150 186 188 253 218 44 199 15 13 99 61 100 194 16 43 66 96 147 28 32 131 102 1 40 202
	     147 205 205 141 127 119 129 78 236 137 123 17 46 138 232 56 199 74 181 205 245 187 69 62 249 234 71 62 251 230 60 215 111 204 209 108 71 196 153 33 98 19 64 118 24 201 133 169 160 103 6 66 6 181 220 138 114 176 233 23 5 118 8 14 235 99 136 59 140 100 12 246 240 48 111 158 61 194 255 250 79 63
	     231 127 251 219 159 240 234 204 152 154 98 69 5 0 101 247 188 121 100 92 138 63 125 205 119 186 29 90 205 6 43 165 50 174 209 198 117 35 200 141 96 178 153 100 255 112 189 71 176 127 128 251 226 55 242 23 253 206 139 217 253 187 131 59 61 167 162 28 52 55 254 105 141 227 109 230 155 60 202 75
	     15 238 49 38 7 139 189 4 128 35 242 2 78 136 226 24 122 142 197 66 147 122 7 28 55 89 46 84 185 116 125 134 183 94 61 202 201 35 71 121 227 213 163 140 103 32 243 104 254 203 99 93 71 63 208 145 228 89 54 36 121 158 229 11 94 82 255 246 137 190 35 121 1 62 122 255 119 11 212 173 112 107 174
	     197 237 219 119 88 41 23 185 179 88 98 165 208 228 202 237 37 174 207 23 41 54 186 16 11 88 15 214 34 38 0 9 18 251 172 113 191 162 236 35 247 96 160 152 199 118 107 64 191 235 207 192 125 197 15 250 201 105 214 158 119 184 94 132 235 54 161 82 194 79 14 113 230 149 147 252 231 127 252 144 127
	     250 229 155 26 252 43 42 0 40 143 199 175 95 157 149 209 172 245 62 234 225 162 136 27 115 43 148 90 49 16 167 137 195 201 217 163 36 149 248 1 1 201 158 5 80 138 114 208 69 128 253 250 58 131 53 2 82 135 35 200 34 67 1 248 60 226 61 17 158 98 43 166 113 125 129 75 63 222 100 100 40 195 217
	     87 206 240 225 59 111 243 183 117 203 209 35 35 188 50 147 37 23 8 121 73 130 22 177 134 164 193 216 246 21 17 228 177 62 159 250 52 202 193 94 21 6 227 241 173 21 60 98 32 242 126 163 165 159 17 214 154 17 23 110 85 248 250 251 155 124 250 229 183 220 158 159 163 180 84 32 146 144 174 177 116
	     189 193 140 205 32 88 48 6 111 146 99 60 233 153 30 53 167 138 114 128 145 193 117 194 111 244 232 16 31 131 68 12 231 12 161 205 243 214 217 35 252 230 31 127 194 127 253 167 159 243 246 145 41 53 148 138 10 0 202 227 243 222 137 67 82 251 213 219 62 242 158 63 124 113 149 175 46 221 161 83
	     171 66 189 142 207 228 176 195 195 136 181 105 191 241 141 32 66 16 252 3 124 245 193 42 226 253 229 108 176 13 81 122 39 253 2 20 229 153 234 21 3 59 15 98 144 192 38 38 193 11 177 139 240 221 30 205 86 19 234 77 170 165 38 197 222 60 181 174 165 220 104 49 62 150 231 221 87 198 152 30 31 226
	     141 227 71 57 50 59 195 97 187 247 225 186 46 11 202 35 13 107 239 183 181 59 207 19 183 213 169 31 112 244 3 160 39 194 114 185 195 194 194 34 203 213 42 247 138 45 190 191 178 198 141 59 139 124 119 249 46 149 66 1 42 13 200 101 33 63 4 249 97 76 38 75 34 181 37 89 64 254 65 6 88 81 148 231
	     24 209 203 174 214 172 117 63 58 181 201 198 36 157 120 226 94 23 218 45 124 167 5 174 71 110 118 130 183 94 127 141 223 252 213 219 252 231 95 189 171 193 191 162 2 128 178 55 252 250 205 147 18 14 15 249 76 126 148 94 44 92 189 113 155 74 169 10 78 48 228 193 36 237 197 54 10 143 137 110 56
	     40 202 193 243 74 238 83 4 220 122 16 97 64 66 8 45 24 139 100 243 128 167 235 225 250 189 121 22 230 110 99 163 54 127 57 50 193 236 161 73 254 238 151 63 225 157 55 223 228 189 87 103 57 60 97 201 144 100 4 196 144 62 103 82 188 104 107 16 244 240 218 1 162 65 141 114 112 196 135 109 110 139
	     7 110 119 128 120 143 17 65 72 207 250 247 224 198 98 147 11 87 111 241 213 183 223 243 227 205 187 44 151 26 44 151 90 116 177 212 218 14 25 26 135 252 68 186 219 111 193 4 184 193 157 126 143 42 101 138 242 2 172 32 38 221 34 235 123 213 70 4 232 129 116 9 50 48 156 205 243 222 185 147 252
	     47 127 255 19 254 203 223 188 205 91 71 38 117 226 43 42 0 40 123 199 207 79 78 139 255 245 219 94 188 231 155 195 163 124 115 241 38 203 133 10 237 114 1 49 22 242 35 248 48 139 17 3 98 19 15 196 111 31 84 40 138 114 16 245 1 3 214 64 96 16 147 28 11 112 189 22 205 122 157 102 165 0 205 58 203
	     43 69 70 39 38 104 69 33 87 238 149 185 114 247 12 167 143 141 49 51 26 114 116 114 130 145 241 97 166 135 130 117 65 96 235 202 112 127 125 114 93 47 148 3 62 109 182 113 176 250 99 61 2 202 78 40 149 26 180 218 45 22 138 53 86 43 49 23 175 205 113 237 198 93 126 188 114 131 235 119 23 233
	     53 90 137 114 54 58 6 185 97 76 38 15 97 22 239 250 118 118 224 255 106 103 21 229 133 88 57 252 186 72 46 64 76 220 108 224 91 13 28 17 35 227 35 188 118 226 24 111 156 157 229 111 126 242 6 127 255 211 119 121 235 136 158 249 87 158 112 212 105 111 88 101 39 190 91 40 249 31 111 173 241 251
	     63 95 224 235 31 174 240 227 165 107 180 187 17 102 124 18 201 143 130 132 120 73 42 139 123 47 73 191 192 77 254 72 226 212 139 108 184 70 27 227 77 143 0 40 47 18 102 155 16 247 105 175 173 253 29 242 109 94 75 6 254 237 229 145 222 189 219 82 161 83 196 32 222 129 143 240 81 23 186 109 36
	     142 112 6 194 32 100 124 36 75 24 88 38 70 135 24 27 201 112 230 216 97 62 122 251 77 222 56 119 154 143 222 152 101 60 35 140 4 155 207 53 34 50 144 1 224 210 148 34 159 8 15 247 125 190 109 46 237 131 162 46 229 165 229 113 142 0 236 213 177 1 183 205 16 77 243 105 112 64 161 227 184 178 212
	     228 252 197 219 44 175 172 112 241 250 77 22 215 202 44 173 86 104 54 123 52 187 142 102 187 139 115 46 17 214 195 16 76 8 54 4 19 108 122 159 172 103 214 248 117 133 193 61 158 7 184 205 5 209 9 165 40 155 142 174 62 141 56 105 112 173 73 231 176 197 35 70 16 241 68 133 53 124 173 64 110 52
	     207 187 111 189 206 111 254 246 3 254 246 231 231 248 95 62 120 69 39 168 178 39 104 6 128 178 35 31 30 155 148 15 143 77 50 146 205 249 83 179 35 140 141 228 184 185 180 74 161 214 161 211 174 227 8 240 18 66 16 128 205 236 24 239 108 223 167 92 212 121 87 94 20 87 225 128 191 123 127 223 167
	     241 91 34 110 17 192 4 136 181 248 92 30 35 6 19 71 184 40 102 173 84 135 70 141 197 56 6 3 151 142 172 114 119 173 195 219 243 21 22 86 207 48 49 30 114 118 54 71 46 99 153 26 25 97 116 104 136 145 96 80 116 232 87 46 23 180 132 185 178 87 78 251 211 192 13 204 145 237 206 244 247 71 110 199
	     67 189 27 81 169 215 233 181 59 148 154 93 126 92 168 113 253 118 129 111 47 221 101 121 117 141 43 55 239 208 174 148 161 211 133 236 16 140 76 16 228 70 9 172 193 25 131 119 233 179 250 164 5 216 118 177 131 108 220 69 103 142 162 28 64 175 33 113 143 29 196 17 46 238 33 81 15 107 132 32 23
	     48 57 115 146 247 95 61 206 223 255 244 45 254 233 215 239 241 87 231 102 213 99 86 246 110 12 106 6 128 178 27 190 187 187 236 63 251 113 141 47 47 222 228 15 127 249 150 187 183 231 113 145 195 219 12 50 60 132 100 135 211 214 37 6 143 224 214 75 31 233 248 82 94 6 83 190 181 190 55 60 155
	     12 0 182 127 173 71 200 0 144 180 185 231 64 184 191 185 197 154 200 122 37 226 141 87 21 188 139 147 84 229 110 7 122 61 112 201 137 103 147 15 153 28 27 230 208 72 142 217 169 60 67 89 195 153 35 163 76 77 140 242 193 91 111 112 238 213 87 120 101 118 152 209 1 17 96 243 21 243 3 229 69 55
	     62 165 236 240 81 85 68 84 158 132 135 101 0 248 109 126 250 59 251 91 87 0 159 138 4 11 53 199 237 133 2 23 126 188 196 245 91 247 88 46 214 184 91 168 81 107 121 150 74 109 90 157 30 149 106 11 162 94 242 160 32 3 217 44 152 32 137 238 141 128 151 251 187 229 166 239 207 108 188 249 77 57 64
	     143 188 226 104 6 128 162 108 63 53 158 82 6 128 12 204 229 245 12 184 56 194 119 91 72 175 131 171 215 49 1 156 120 245 12 127 247 179 143 248 135 95 188 206 135 231 166 249 233 169 25 157 152 202 158 162 25 0 202 174 248 240 212 172 124 120 106 150 19 71 14 249 32 110 243 205 72 134 229 98
	     141 82 189 69 228 29 174 219 192 139 197 73 128 24 139 136 209 208 95 121 9 113 207 240 181 158 205 12 219 234 252 172 139 1 98 147 195 253 67 97 114 76 0 15 226 144 168 67 177 92 163 176 178 194 149 171 45 44 158 195 211 163 76 77 142 51 191 218 229 205 197 54 239 191 115 154 147 179 195 12
	     91 199 72 24 224 130 128 161 76 128 53 66 40 178 41 160 50 247 57 78 168 174 168 60 21 71 127 167 89 230 183 252 238 128 30 208 243 208 139 60 221 110 23 31 199 148 219 17 205 40 224 210 181 21 174 221 188 197 55 223 255 192 15 87 110 81 44 213 104 52 90 144 207 67 144 199 4 57 108 110 8 111
	     131 164 141 95 191 148 255 122 36 239 119 61 195 117 42 40 202 211 183 123 123 21 252 175 203 235 46 57 86 103 226 46 130 35 8 28 67 195 67 100 167 179 28 154 204 243 235 143 222 229 55 255 240 43 254 183 159 30 214 192 95 81 1 64 121 254 252 151 15 102 69 186 31 250 55 94 57 202 133 107 139
	     124 123 225 6 247 22 22 41 148 203 201 49 128 204 48 100 178 152 76 30 17 131 243 178 141 155 178 221 174 131 239 123 99 122 145 149 131 232 46 236 96 241 183 235 0 254 12 60 119 63 144 35 188 245 172 225 253 9 254 143 248 182 228 190 207 225 113 201 190 189 243 169 6 98 0 11 46 32 246 158 213
	     90 68 51 170 195 197 91 220 90 42 243 195 181 107 76 79 228 56 52 58 196 177 153 105 102 14 31 226 181 51 39 153 26 15 56 28 238 162 67 128 12 172 27 143 80 71 196 15 172 53 131 59 49 202 11 54 5 247 240 43 29 220 233 31 44 102 217 1 170 61 207 194 114 139 107 215 111 81 46 87 184 189 184 66
	     179 227 152 91 173 178 90 40 51 191 188 202 82 181 75 175 11 144 1 111 1 131 115 244 219 2 192 118 38 114 251 27 31 61 218 120 216 154 163 187 253 138 242 36 42 193 67 109 200 96 123 63 36 41 246 135 139 241 81 7 218 13 92 163 134 9 133 177 233 9 206 30 61 196 251 111 30 231 237 215 142 240
	     225 43 103 248 167 143 52 248 87 84 0 80 246 17 255 215 159 159 147 215 95 59 229 143 29 158 35 23 88 70 179 158 139 190 75 207 91 218 8 222 122 32 74 23 71 251 76 247 68 21 101 223 4 255 251 130 157 142 39 60 201 39 240 108 163 0 108 4 76 54 68 242 22 147 203 167 174 143 199 226 232 225 185
	     179 82 230 246 210 26 223 95 22 114 153 128 195 211 19 156 57 113 148 179 167 142 83 110 133 28 157 157 230 220 169 60 35 57 24 29 120 53 217 144 20 182 237 40 240 160 152 79 119 72 149 199 193 13 252 120 146 150 126 150 164 125 95 23 40 180 60 215 110 53 184 117 119 158 47 190 190 204 210 202
	     10 215 239 220 163 209 238 209 238 69 196 222 128 9 8 115 99 216 156 36 197 53 197 227 48 120 76 242 127 233 239 252 239 114 148 166 247 115 108 62 134 160 99 92 81 246 171 245 237 75 236 131 25 62 49 129 1 147 13 176 65 142 201 209 28 175 157 58 202 187 111 188 198 127 250 245 59 124 244 206
	     41 206 142 230 52 248 87 84 0 80 246 31 231 38 179 114 238 111 95 37 31 70 254 244 209 97 102 143 31 102 165 212 224 234 189 53 10 229 58 189 74 53 73 17 206 13 67 152 69 172 197 24 139 247 62 241 119 246 96 131 67 81 246 175 229 127 86 3 219 239 224 118 60 63 151 199 33 8 130 19 131 33 57 209
	     223 139 35 136 29 116 187 248 118 11 233 69 84 68 40 86 123 172 214 34 230 11 13 150 139 45 102 38 71 56 115 52 199 216 80 192 145 177 60 99 35 195 28 158 57 196 236 161 113 70 131 251 131 255 141 115 148 219 159 129 150 45 34 194 142 65 149 102 1 188 52 12 142 19 121 192 184 48 233 79 195 67
	     179 29 179 84 44 81 169 212 88 45 215 40 54 155 172 86 186 220 154 111 178 180 86 225 199 171 119 41 150 43 148 87 139 184 110 4 38 173 226 159 53 144 73 143 197 25 11 196 73 183 239 245 186 26 58 238 20 229 69 13 255 69 60 38 245 121 99 239 160 221 132 102 19 240 200 72 158 227 71 166 57 119
	     106 146 87 143 79 241 230 137 195 156 58 121 140 255 199 175 94 215 69 65 121 70 110 170 22 1 84 158 144 75 43 101 255 221 221 50 87 111 44 241 199 207 47 112 243 214 29 238 222 155 3 111 144 161 49 108 38 143 216 12 24 131 115 62 17 1 36 213 69 117 248 41 47 133 0 240 148 142 0 60 172 136 151
	     108 9 113 252 179 104 79 184 125 144 45 66 114 238 49 118 137 76 224 29 54 16 194 208 144 181 144 15 33 103 13 227 57 195 232 80 200 169 35 83 156 56 58 195 59 111 188 206 91 175 190 198 233 19 67 76 239 32 89 199 233 207 78 5 218 182 13 246 246 168 253 155 178 79 162 250 135 76 181 173 63 253
	     204 180 126 86 201 118 35 160 7 220 90 139 41 20 203 92 184 126 131 123 243 139 220 188 183 200 221 229 85 74 181 14 197 134 195 17 210 108 199 68 206 19 69 158 216 39 199 106 156 49 73 91 75 145 129 121 152 142 80 121 242 181 96 107 6 192 125 51 123 55 71 0 20 69 121 90 225 63 70 146 92 159
	     190 189 235 212 171 80 173 64 24 112 236 196 49 126 241 209 91 252 167 191 125 143 247 95 63 198 223 159 153 86 35 164 168 0 160 28 76 62 155 107 250 191 124 117 145 59 115 115 124 247 227 29 86 202 53 86 138 117 138 149 6 190 23 39 34 64 46 143 15 178 73 118 128 49 247 7 36 58 28 21 21 0 246
	     88 0 216 252 154 130 127 224 219 232 7 195 143 106 27 238 63 104 32 91 159 56 173 110 158 190 7 231 144 56 130 184 139 239 181 161 89 131 168 135 33 198 132 33 51 51 227 28 157 157 230 245 87 206 240 218 153 211 156 58 118 136 227 135 115 140 230 3 198 135 242 100 243 121 134 114 121 114 185
	     128 177 16 50 108 164 70 239 244 254 54 29 23 24 252 124 79 77 0 120 74 7 211 149 45 151 121 119 223 229 214 74 52 253 176 188 238 160 214 245 180 91 109 26 245 6 237 118 135 149 122 147 70 203 113 235 94 153 66 185 194 181 219 119 152 95 90 227 206 194 10 133 149 2 113 183 135 199 34 217 17
	     200 143 64 144 193 132 89 188 49 56 145 77 197 252 118 158 44 254 177 214 130 77 162 150 247 235 98 134 31 252 236 187 20 0 228 41 44 75 138 242 178 132 249 247 223 148 30 235 113 49 210 107 65 175 139 247 73 107 191 177 225 12 211 163 35 156 62 58 205 91 175 29 231 163 247 222 224 239 126 246
	     6 175 77 132 106 28 20 21 0 148 131 205 197 149 170 111 118 219 124 243 99 145 43 55 230 248 243 151 223 242 253 143 87 105 151 170 64 8 211 179 200 208 40 34 22 47 38 9 50 188 27 112 132 116 29 84 148 39 241 63 30 228 193 203 14 14 191 127 144 0 176 139 215 216 174 210 128 127 80 212 226 147
	     192 5 231 193 199 224 34 36 234 64 28 99 188 67 12 100 50 150 124 46 203 200 112 150 225 92 142 209 161 28 83 19 57 142 76 141 115 250 216 81 142 29 159 229 232 225 195 76 78 140 241 218 169 44 135 119 17 138 123 30 156 246 189 247 193 191 127 200 213 87 158 165 0 176 211 183 116 165 12 115
	     203 85 86 139 5 110 221 186 199 210 202 42 55 23 86 104 182 122 20 171 45 58 81 143 70 179 67 167 221 163 222 234 210 237 116 193 123 60 22 130 44 222 102 146 180 127 27 164 38 108 115 235 204 251 99 132 199 19 217 118 112 226 238 107 19 248 40 203 199 214 71 184 173 162 162 218 100 69 121 136
	     1 238 103 246 164 89 63 56 112 93 168 151 160 213 0 215 35 147 203 240 193 219 175 241 171 159 124 200 175 62 124 141 55 206 142 51 49 60 204 171 83 67 58 193 20 21 0 148 23 139 63 95 43 250 223 125 242 21 95 94 184 204 181 59 203 44 174 213 233 216 12 157 94 218 225 91 2 124 16 32 214 110 44
	     162 94 219 7 42 202 139 41 0 108 190 197 244 131 139 126 195 2 241 73 81 116 159 150 94 139 122 16 199 184 110 11 223 110 35 206 17 100 2 70 38 39 57 121 226 40 39 143 207 114 252 200 97 166 39 71 121 237 212 36 103 143 100 57 148 181 100 130 12 97 54 67 46 12 201 100 67 178 54 36 19 64 200
	     67 106 1 236 240 17 31 223 59 115 187 184 250 10 143 248 125 60 206 119 210 241 208 233 70 52 187 93 162 40 166 213 237 225 123 93 234 221 30 75 45 199 143 55 171 204 45 85 88 41 20 185 122 227 14 75 171 171 172 45 172 16 117 35 156 247 96 45 38 155 71 130 16 130 12 62 176 105 54 75 122 120
	     192 111 232 16 222 108 110 78 177 57 240 223 252 9 246 196 255 122 2 241 67 5 0 69 121 210 85 41 181 97 222 39 117 110 226 24 226 46 136 35 99 61 67 25 195 137 169 97 142 30 26 225 239 126 250 30 255 240 235 159 241 55 111 104 186 191 162 2 128 242 130 243 205 157 85 127 115 185 198 183 151
	     151 248 203 249 43 92 191 115 143 123 55 239 165 133 183 66 24 25 33 200 15 35 98 240 206 227 189 224 208 52 68 69 121 94 2 192 227 188 198 227 8 0 108 169 1 34 253 212 201 254 222 105 148 100 6 208 235 66 47 2 23 39 47 146 205 48 58 154 99 108 40 207 240 112 150 145 108 192 112 22 198 71 12
	     135 199 243 28 63 52 205 209 217 25 102 15 77 49 123 104 154 233 201 73 102 167 115 76 218 221 135 237 187 13 221 31 28 210 171 0 240 168 129 253 214 219 118 106 30 107 30 225 106 246 128 185 98 151 181 98 133 249 181 85 42 149 58 139 171 69 10 107 107 204 23 203 20 27 49 149 186 163 222 241
	     52 90 61 10 149 6 141 86 155 184 217 74 207 148 152 228 184 90 152 1 155 236 242 99 77 90 128 82 54 189 7 129 245 2 127 219 249 86 123 185 243 191 87 203 135 10 0 138 242 120 243 198 75 82 225 95 140 193 71 17 174 221 74 118 252 187 109 200 6 156 62 115 146 87 78 30 227 111 126 114 142 115 103
	     39 248 201 201 89 222 57 173 173 253 20 21 0 148 151 136 175 231 187 254 211 31 110 243 237 249 243 252 229 252 69 106 245 14 133 82 157 158 24 240 54 57 18 96 66 188 13 193 216 228 12 37 253 118 1 58 70 21 229 69 23 0 6 211 41 197 152 180 107 82 127 135 37 173 168 236 60 214 245 32 238 64 28
	     129 235 98 92 143 184 217 64 122 29 242 35 121 142 28 159 229 236 137 99 28 59 50 195 241 35 135 153 157 57 196 137 35 135 56 62 155 103 58 103 9 173 193 6 1 65 96 9 109 242 127 49 130 53 27 149 223 229 17 66 119 21 0 246 94 0 216 205 216 116 164 197 31 125 242 159 216 57 162 56 38 138 98 226
	     94 68 228 34 154 61 207 92 177 205 205 187 5 86 214 10 220 93 88 164 80 174 50 183 184 194 189 133 37 202 171 69 122 61 135 201 141 32 217 60 78 50 248 32 3 54 196 153 32 61 207 111 7 90 245 249 77 245 35 60 96 216 108 163 92 218 153 226 160 10 0 94 252 230 107 174 2 128 162 108 153 55 130 16
	     227 93 34 82 27 23 225 157 195 136 39 31 192 200 112 134 233 137 17 126 245 193 59 188 241 218 43 252 227 47 94 227 167 199 134 117 34 41 42 0 40 47 39 55 75 145 191 59 55 199 151 215 238 114 119 190 204 159 190 188 196 221 185 69 202 11 203 32 1 140 78 32 195 163 144 205 131 132 248 56 222
	     82 36 112 231 222 129 253 134 99 73 27 50 183 251 55 101 118 240 213 21 229 5 21 0 252 46 110 123 28 1 192 63 236 57 119 45 0 176 81 53 221 15 86 77 79 131 176 184 155 100 5 196 61 136 82 33 160 221 78 110 11 3 204 248 8 135 198 71 25 27 25 98 108 116 152 145 225 33 198 71 135 200 103 45 83 227
	     25 38 134 243 28 158 153 230 208 244 36 135 38 39 153 28 159 96 116 56 199 228 184 97 216 194 216 83 11 211 61 42 0 236 44 147 152 71 124 92 19 168 120 168 84 161 222 104 83 173 215 168 214 26 172 22 75 20 86 87 89 45 85 40 212 218 212 170 61 42 141 14 213 122 147 74 173 78 163 221 161 92 107
	     208 168 214 161 209 74 190 150 92 30 194 44 4 25 8 114 16 4 201 239 253 42 254 12 230 244 251 7 79 136 3 38 0 220 95 4 84 5 0 69 217 126 182 8 152 116 21 119 93 124 175 7 173 26 52 146 202 254 135 15 31 226 173 87 79 242 209 187 175 114 234 232 20 63 121 227 4 83 211 211 188 55 171 231 252 21
	     21 0 20 133 107 133 134 191 185 84 225 95 126 255 21 23 46 93 227 135 11 87 104 69 158 110 152 167 43 89 176 25 48 1 190 191 210 122 64 204 250 241 198 173 99 86 16 100 192 73 241 120 252 67 251 176 251 254 198 226 122 32 226 31 86 184 221 239 106 70 109 121 140 174 251 138 178 167 46 152 184
	     100 250 74 210 204 77 124 50 239 76 98 208 176 62 194 224 192 121 146 102 163 30 241 142 168 221 34 19 4 12 143 13 115 250 244 9 78 28 155 229 248 209 35 28 157 153 102 114 124 140 217 195 19 76 140 26 14 15 11 163 22 178 70 146 198 5 198 98 141 193 26 131 49 146 182 119 74 130 57 123 80 167
	     247 122 125 7 121 174 207 51 40 239 26 146 29 125 231 124 178 134 247 245 30 231 136 157 195 57 135 243 158 200 57 106 49 172 245 96 173 216 163 176 86 167 88 110 80 40 151 88 43 148 152 91 88 230 206 220 28 171 11 43 52 155 45 196 6 72 152 37 22 131 55 6 47 130 195 224 49 56 49 184 117 27 32
	     120 73 114 64 124 42 60 249 251 122 102 40 138 242 98 176 101 237 218 205 68 247 2 196 136 139 193 71 224 99 178 190 75 208 107 49 61 53 204 59 175 157 229 151 31 189 195 63 254 213 123 28 159 30 229 149 233 156 58 128 138 10 0 138 178 149 63 254 120 207 207 45 44 241 217 197 59 44 174 53 248
	     241 246 50 151 111 47 224 202 85 48 1 140 79 64 152 197 136 65 140 93 247 53 183 22 88 218 16 0 164 31 254 171 0 160 40 47 176 8 208 159 235 210 15 33 197 32 34 196 177 131 168 155 20 16 236 69 16 69 73 134 64 20 65 171 157 76 248 124 150 204 161 9 166 39 71 153 158 24 99 114 108 152 225 124
	     150 137 145 60 67 67 25 166 70 66 242 89 207 212 80 134 92 104 153 24 27 99 98 124 140 201 177 81 70 135 242 132 129 33 159 205 16 218 128 201 17 75 102 15 221 209 167 101 141 253 14 129 187 60 70 224 62 152 143 229 189 199 238 81 11 69 7 148 123 158 122 163 67 47 142 232 116 35 58 189 152 114
	     189 65 169 94 163 92 169 81 107 182 168 182 58 84 155 158 90 3 202 245 38 245 70 139 122 179 71 189 222 162 82 111 82 40 85 41 21 75 80 169 65 55 130 76 8 185 92 82 165 63 12 33 176 96 67 8 2 36 8 54 106 79 120 216 92 189 95 131 127 69 121 153 5 0 89 255 115 210 182 214 69 49 180 155 208 110
	     64 198 144 27 202 243 250 153 99 156 58 54 195 251 175 205 240 193 107 71 120 229 228 73 126 118 118 70 29 63 101 223 19 232 37 80 158 23 127 255 214 73 225 173 147 28 59 121 218 223 94 170 146 253 228 123 42 213 26 133 90 137 168 215 195 51 140 243 6 193 34 105 129 64 17 51 16 232 111 23 165
	     111 118 112 119 220 153 146 193 187 121 13 212 21 229 64 185 109 91 14 28 120 143 247 233 249 236 48 196 135 25 200 13 220 175 127 148 200 123 140 241 4 22 154 205 54 221 78 155 213 229 24 35 158 76 178 39 76 38 52 88 137 25 27 25 98 56 159 229 196 209 89 142 205 206 114 116 246 48 135 38 199
	     200 101 44 163 35 195 255 255 246 254 243 61 142 44 203 243 60 191 215 204 21 220 161 181 214 146 0 101 144 12 6 35 50 50 34 43 43 171 171 122 102 122 158 153 238 125 158 125 189 127 221 62 189 59 179 47 102 118 68 247 84 85 86 102 134 22 100 80 43 80 107 128 208 112 101 102 103 94 152 67 18
	     212 10 36 127 159 39 35 1 56 220 29 160 59 236 218 61 199 206 61 151 76 58 77 87 75 45 205 89 71 194 95 75 75 184 74 98 209 109 124 94 25 135 54 55 128 119 56 182 111 217 190 214 124 240 173 140 68 107 165 232 175 144 76 88 251 119 69 79 24 126 109 211 56 108 107 91 213 85 254 207 214 250 59
	     84 190 142 12 150 74 198 205 217 85 30 45 44 81 42 151 88 89 46 176 82 40 113 247 225 35 238 205 204 114 227 206 125 102 30 205 179 188 178 74 62 95 38 52 159 82 100 152 231 17 70 30 161 57 130 200 17 68 70 186 182 150 82 77 45 102 149 173 185 54 175 118 119 110 163 178 204 182 87 148 89 101
	     149 191 206 7 34 31 154 205 9 207 231 29 251 156 69 241 86 213 97 128 103 33 206 202 56 43 145 78 103 105 105 170 230 192 196 16 71 15 78 114 96 172 133 207 251 26 52 112 200 251 115 60 168 2 64 118 139 255 252 195 180 157 56 125 158 51 23 110 112 229 250 125 230 242 5 238 63 90 34 8 0 124 72
	     103 240 18 105 112 241 214 75 209 166 73 218 198 18 128 181 240 32 122 70 2 192 182 158 5 204 109 172 245 220 150 36 120 161 51 198 14 21 0 238 5 159 226 229 126 176 200 71 121 10 123 254 219 189 74 64 26 133 149 157 5 74 113 15 129 114 49 222 109 32 40 199 213 2 102 241 132 175 42 77 34 157
	     162 189 185 129 230 166 70 154 27 27 104 168 203 145 74 250 228 50 25 82 201 20 45 13 213 212 215 167 105 202 37 241 60 135 159 76 146 78 165 201 86 101 72 167 146 36 252 4 233 116 146 132 239 147 72 248 24 70 38 149 34 155 73 145 74 57 162 40 142 79 171 252 56 95 241 190 101 228 13 40 1 5 35
	     222 222 213 135 200 226 130 139 66 161 76 185 28 80 14 2 10 229 18 97 24 82 44 150 137 194 144 98 169 68 41 12 41 23 75 68 81 192 226 106 153 7 115 121 102 231 150 89 88 90 165 108 33 249 213 18 249 66 192 236 194 34 179 179 11 220 155 153 101 97 113 25 86 11 241 15 240 252 184 27 127 42 29 239
	     40 83 185 170 79 34 9 201 20 46 145 2 207 143 3 250 205 101 99 110 83 150 226 169 41 14 17 217 125 227 252 203 31 159 91 19 0 182 195 97 239 182 220 215 89 64 84 204 67 80 196 35 36 155 74 210 210 84 67 117 38 205 158 225 110 250 186 154 56 126 96 130 255 112 116 80 129 191 188 119 84 1 32 187
	     198 222 193 22 122 218 170 25 29 232 231 111 63 93 228 151 211 103 184 119 231 65 92 198 25 250 224 121 88 34 21 23 102 110 43 219 218 90 242 255 28 205 182 204 237 48 9 92 187 242 19 109 61 207 184 23 216 17 124 91 37 129 123 225 83 215 147 174 62 105 82 42 242 252 199 197 78 13 7 43 93 220
	     61 226 82 112 223 7 82 16 101 193 34 156 69 56 171 244 21 0 124 47 190 178 159 143 60 30 46 172 176 152 47 146 188 239 227 251 142 132 231 227 59 71 58 153 32 145 128 76 42 78 244 85 87 231 104 168 173 163 185 161 129 186 218 26 50 153 20 117 213 213 164 51 41 170 50 41 192 168 175 173 166 161
	     161 129 234 106 135 133 149 56 54 7 217 247 116 90 94 6 150 3 88 92 141 99 240 48 130 66 193 88 92 40 176 184 180 202 106 33 207 194 210 50 133 82 153 197 197 101 202 165 50 139 75 75 172 22 10 44 44 46 179 180 186 194 74 190 72 161 24 18 134 80 10 2 66 7 97 96 4 145 81 42 135 20 75 1 230 87
	     145 169 73 16 84 69 241 91 89 169 186 48 231 129 243 49 124 226 230 12 94 188 36 164 82 182 107 26 74 69 222 243 224 255 245 92 20 121 242 5 207 109 155 121 58 195 243 60 44 140 226 45 253 242 203 68 73 71 38 151 96 184 183 157 190 238 46 142 31 28 165 167 163 150 129 230 26 189 69 242 126 30
	     89 170 0 144 221 232 159 207 60 176 111 190 255 145 111 78 93 98 110 161 196 181 123 243 20 34 88 42 4 241 182 79 94 2 92 2 231 251 224 220 166 129 253 5 19 177 182 169 5 213 122 118 56 218 126 148 236 24 220 191 204 169 43 122 225 71 172 157 236 116 156 138 188 226 217 110 253 216 114 219 58
	     186 175 173 246 118 182 81 61 100 81 92 148 239 194 50 4 1 46 12 32 92 75 18 88 220 100 48 8 33 12 88 43 168 119 213 89 82 181 181 180 55 54 208 80 91 77 58 157 162 190 54 71 58 157 166 170 42 9 102 52 214 85 83 223 80 71 77 46 139 133 134 231 27 77 141 105 26 106 146 228 82 149 70 134 149 161
	     201 195 225 60 35 233 39 73 165 146 248 190 95 73 81 174 253 190 182 62 90 60 61 209 184 253 187 143 223 219 109 31 119 42 57 147 200 66 74 229 144 114 57 32 138 226 224 219 28 4 158 35 8 225 209 82 192 194 98 137 197 149 16 47 225 19 89 68 62 95 98 113 97 137 197 165 60 43 133 34 11 75 203
	     228 75 37 22 22 86 40 149 131 248 235 124 158 213 165 101 130 213 85 172 16 196 63 47 157 136 51 34 206 85 2 122 15 124 31 243 18 152 239 87 190 23 55 99 100 243 70 17 149 134 125 155 127 249 181 127 143 54 120 17 121 223 19 0 107 203 120 162 55 50 31 90 91 235 31 89 156 52 36 10 160 92 194
	     247 141 116 194 163 169 38 195 80 119 61 189 173 245 124 126 96 15 253 3 125 252 105 111 135 174 250 139 18 0 34 111 194 223 206 221 176 51 183 230 184 121 47 207 95 127 189 192 229 235 55 185 117 229 70 92 166 155 170 130 170 106 188 108 22 231 249 68 97 180 101 98 251 226 127 213 222 166 132
	     192 166 41 163 115 74 0 136 124 240 83 204 199 143 57 179 144 181 230 79 132 81 252 209 194 202 129 92 57 30 195 202 250 208 181 177 35 229 147 76 165 200 101 210 100 82 73 18 158 163 42 227 147 72 120 36 18 241 126 242 217 84 130 116 85 154 116 50 1 81 188 155 65 182 202 35 155 242 72 37 42
	     85 10 22 85 66 90 71 210 243 168 171 169 165 161 161 158 108 117 22 28 68 229 114 229 66 213 243 38 0 214 238 97 59 36 5 108 83 82 196 173 127 203 243 125 130 114 72 169 92 98 126 113 137 229 229 21 86 139 69 202 97 132 243 61 34 231 19 26 20 138 70 177 24 80 40 129 249 30 102 142 48 8 41 20
	     203 20 74 33 65 24 176 90 10 8 34 163 80 12 226 165 0 165 128 114 16 81 44 151 43 21 94 149 170 174 132 191 105 220 93 219 118 171 146 8 88 187 186 239 185 199 222 175 237 253 96 214 155 187 174 125 95 243 28 17 37 0 118 24 253 0 156 231 240 60 71 84 42 19 149 11 176 188 8 115 143 32 155 161
	     97 160 143 99 251 198 249 234 211 49 250 154 211 236 235 110 101 162 175 85 193 191 40 1 32 242 166 157 158 205 219 95 127 190 193 111 103 206 242 195 175 103 226 117 162 171 101 86 203 70 232 39 9 157 143 185 120 146 232 17 111 243 244 226 127 214 94 101 171 241 141 4 128 41 1 32 242 17 77 50
	     221 182 160 56 218 248 222 230 138 1 183 105 249 80 229 210 145 51 171 172 48 8 240 162 8 23 173 45 41 136 155 70 173 5 245 88 229 123 68 149 175 227 231 113 132 120 81 229 62 84 122 16 84 158 223 249 9 114 117 117 180 180 54 83 91 91 141 57 71 80 42 198 241 240 166 113 225 169 9 128 181 93 82
	     220 90 231 187 181 175 43 163 146 177 105 39 149 74 220 157 240 41 151 67 10 197 34 179 115 243 44 207 47 18 228 243 88 16 197 129 186 243 227 151 198 115 241 246 122 235 27 100 199 235 238 205 121 88 229 106 126 228 18 241 18 46 23 223 111 237 234 126 228 121 149 158 46 107 91 190 186 173 175
	     251 90 82 119 203 50 172 39 45 241 218 244 90 108 235 253 162 121 142 200 135 48 54 219 107 152 15 185 245 109 99 177 8 179 40 238 11 19 134 36 9 240 253 136 234 148 135 43 174 210 218 210 196 193 131 7 248 253 241 3 252 191 126 63 164 160 95 62 40 234 1 32 187 222 84 83 149 243 246 119 219
	     72 91 146 222 174 6 46 93 125 192 79 191 93 225 244 229 107 68 115 75 224 37 161 161 17 170 178 88 34 19 111 25 184 94 17 240 196 41 241 182 83 194 218 174 1 155 202 132 215 30 245 10 59 4 216 107 121 132 38 175 34 111 199 78 87 200 29 91 91 248 87 190 142 108 211 62 81 149 222 2 230 199 29 4
	     34 54 2 213 168 50 146 68 128 121 241 227 182 21 26 17 86 190 94 239 77 226 111 220 193 131 149 197 34 43 182 64 102 161 128 195 8 163 160 50 92 61 231 216 176 61 1 176 37 217 17 109 189 207 90 2 192 121 132 81 68 185 28 144 207 23 40 230 35 8 60 8 189 77 77 83 137 215 226 175 93 160 91 251
	     25 230 226 43 246 62 149 43 247 149 159 233 121 149 53 250 126 229 117 244 113 149 178 126 91 123 141 214 170 177 182 191 7 216 99 159 111 105 234 245 132 151 194 44 222 253 193 185 141 223 121 237 182 202 147 232 207 94 100 215 143 201 182 243 124 232 153 45 147 54 18 136 107 155 199 58 23 143
	     175 22 69 88 57 132 229 57 152 155 161 148 78 144 105 170 103 116 124 148 190 206 86 38 135 218 57 48 222 79 111 119 135 222 6 249 224 168 2 64 222 59 255 114 238 174 253 31 255 250 43 127 249 241 87 174 94 189 201 210 170 65 117 29 121 75 16 122 9 220 250 149 168 237 235 66 159 150 0 208 117
	     119 17 217 62 42 236 176 154 126 115 16 185 137 231 54 130 109 171 92 201 119 88 165 167 64 28 244 123 149 43 220 230 214 74 253 55 102 176 182 173 31 193 218 207 247 48 220 90 178 193 192 89 136 121 241 247 157 61 225 215 126 82 2 128 109 9 0 247 132 4 192 230 121 180 89 229 42 190 195 42 65
	     244 182 197 3 155 154 177 86 110 181 56 35 176 245 41 215 178 4 222 166 60 131 171 172 247 223 186 109 224 147 255 81 182 227 123 177 253 253 216 114 123 20 109 220 166 4 128 200 135 55 76 63 53 1 192 122 2 32 30 54 189 120 219 216 40 174 208 242 45 36 85 94 33 90 122 68 75 91 29 125 125 61 252
	     211 223 125 206 103 135 199 249 253 80 179 6 7 249 96 169 2 64 222 59 95 79 116 184 132 5 54 216 87 203 137 43 119 57 115 233 1 183 238 45 50 125 245 46 20 242 113 208 95 91 143 171 202 224 57 127 99 130 105 79 154 210 139 200 7 63 79 116 47 178 38 124 115 160 252 172 217 229 198 173 110 45 124
	     119 155 3 108 191 146 12 32 222 151 30 219 182 137 137 219 8 252 221 227 51 218 40 50 66 2 8 195 184 15 193 142 171 254 55 63 224 41 179 228 245 0 125 243 99 189 157 159 207 44 190 98 15 224 249 56 223 199 121 222 150 235 243 155 239 186 37 121 17 151 67 84 110 223 148 134 181 181 164 172 109
	     123 237 236 57 222 139 167 252 155 119 120 143 55 221 248 164 59 235 160 16 249 192 115 3 134 225 185 248 163 115 96 65 137 104 121 25 242 121 204 115 80 147 165 187 183 147 230 250 97 142 31 232 102 160 171 141 35 147 227 28 238 107 212 0 33 31 246 241 161 10 0 121 159 253 120 123 214 126 56
	     251 128 191 125 119 154 191 124 119 146 165 153 135 172 230 139 120 117 141 88 42 131 57 175 114 229 202 171 76 62 61 158 116 209 76 21 0 34 74 0 108 141 104 159 127 14 248 198 146 139 182 105 52 178 181 238 247 79 249 73 79 92 178 180 125 251 212 157 130 106 219 250 60 110 231 128 217 61 53
	     21 242 162 201 22 158 239 189 216 233 253 216 246 189 215 250 115 69 228 253 136 242 119 28 51 215 106 64 215 170 177 34 156 139 240 194 16 91 89 198 43 151 200 213 84 211 220 209 204 215 159 29 100 255 228 8 95 78 54 51 217 222 160 192 95 62 10 170 0 144 247 218 145 174 38 215 216 216 100 237
	     213 9 6 219 115 76 223 153 229 244 165 27 204 204 45 242 112 246 17 65 57 132 68 18 50 57 92 42 183 245 108 177 222 220 111 227 131 70 126 17 121 233 56 253 133 102 169 47 50 193 93 187 18 255 146 3 149 247 92 191 228 227 143 177 157 255 149 207 174 159 112 47 252 10 137 136 188 214 172 128
	     239 176 32 196 138 171 16 20 160 88 32 147 77 211 208 90 75 111 123 43 123 135 123 232 238 104 224 243 131 19 252 113 170 83 211 63 81 2 64 228 125 50 84 133 27 250 108 132 241 158 6 187 243 168 200 191 254 116 158 191 253 120 130 226 194 28 171 197 60 65 41 32 74 164 177 148 197 165 166 6 120
	     94 92 14 6 64 180 190 151 244 235 158 174 62 215 52 216 105 158 44 242 166 39 131 102 238 249 15 176 23 185 242 255 132 158 0 79 63 168 221 147 7 11 123 202 227 215 251 96 217 139 141 58 246 18 99 203 171 140 67 102 175 240 68 238 201 175 203 246 228 135 186 253 139 236 174 160 251 77 76 102
	     220 182 202 164 39 254 8 183 105 92 136 42 125 63 34 92 88 38 17 150 112 229 60 141 153 44 7 70 6 248 226 232 62 62 63 48 64 67 46 201 222 110 149 251 139 18 0 34 239 173 201 238 102 55 217 13 77 117 57 235 168 245 25 232 172 227 214 236 42 215 239 47 114 123 102 145 124 126 49 238 200 157 74
	     131 159 196 37 42 141 170 54 205 42 223 196 244 241 197 182 1 20 145 183 51 57 125 151 118 104 46 184 173 25 224 235 124 238 247 47 169 184 67 86 84 83 116 145 247 235 152 125 219 191 129 139 183 80 181 48 130 176 76 84 46 146 76 56 210 185 12 253 109 237 180 212 166 25 239 109 225 248 193 41
	     14 31 28 103 188 181 74 163 138 40 1 32 242 161 56 212 87 239 18 140 217 208 112 39 215 30 148 249 230 228 53 254 229 187 31 41 221 187 70 20 25 212 212 98 169 12 206 207 84 154 85 109 61 121 233 26 146 136 108 157 88 110 91 91 110 182 181 163 252 11 60 254 73 143 217 117 87 175 95 166 75 254
	     27 236 172 239 182 53 72 124 238 215 107 251 253 212 252 79 228 45 36 1 236 45 253 164 141 45 65 157 139 136 194 0 87 42 226 138 121 88 152 131 218 26 154 91 186 249 244 224 62 14 78 116 49 214 85 205 64 107 19 67 10 254 69 9 0 145 15 207 190 190 14 183 175 47 222 187 181 173 165 197 106 252
	     2 63 213 120 60 92 88 165 24 120 44 174 22 41 151 87 9 137 187 91 27 201 74 50 192 83 2 64 68 68 68 228 133 188 221 217 211 90 205 148 35 194 202 1 88 153 148 51 50 85 62 181 77 117 88 107 134 225 222 14 38 71 71 248 211 151 159 240 223 29 106 87 208 47 162 4 128 124 44 246 246 214 144 254 221
	     94 6 122 26 56 127 229 1 39 47 221 98 233 202 117 74 15 23 226 59 212 212 65 58 7 201 116 101 51 111 183 181 243 246 219 60 29 174 237 87 184 126 134 211 249 74 228 245 78 74 95 252 152 182 87 188 138 252 178 87 247 221 187 156 102 191 204 216 243 90 198 171 157 223 47 179 151 252 151 107 12
	     21 121 11 162 167 182 58 121 174 177 236 73 115 31 219 188 141 233 218 231 94 188 181 159 69 68 97 25 91 156 131 165 5 194 76 154 154 142 102 38 6 250 232 106 111 96 255 120 15 3 157 109 140 245 213 235 45 18 217 124 120 170 105 142 124 76 254 175 179 119 237 159 255 118 146 239 126 61 205 197
	     171 183 89 92 41 18 165 170 8 44 73 209 37 48 231 19 183 191 246 120 107 217 108 167 4 128 136 236 60 52 104 123 82 17 121 47 60 35 81 234 61 107 44 123 142 185 143 171 244 108 50 192 185 136 132 11 73 89 72 80 88 198 15 11 116 183 52 48 62 216 199 223 255 238 32 83 123 6 249 106 172 77 147
	     40 145 29 168 2 64 62 42 127 183 167 195 133 229 130 181 55 101 248 237 106 15 151 111 206 48 125 99 134 27 183 103 96 105 5 124 63 174 8 200 230 192 37 54 206 65 22 241 86 250 4 184 55 253 3 68 68 68 68 118 9 23 183 64 181 29 166 66 91 43 1 12 135 35 138 2 88 94 193 138 43 148 203 69 172 38
	     71 91 103 11 19 131 237 124 50 209 205 96 123 3 7 199 7 56 50 164 224 95 228 137 135 157 42 0 228 99 245 221 221 121 59 113 246 54 255 250 183 83 252 124 226 28 183 111 221 37 95 46 147 172 169 197 207 214 18 145 32 50 135 153 85 74 120 227 235 113 175 253 10 156 182 1 20 145 39 12 13 170 0 16
	     145 15 193 19 43 0 54 39 0 42 49 137 183 54 2 186 184 187 191 51 195 97 120 24 142 144 96 121 17 47 44 226 162 144 174 206 54 190 56 126 132 191 255 250 32 199 71 155 25 172 207 41 240 23 121 6 85 0 200 71 235 88 71 189 171 207 228 44 227 160 183 189 154 179 23 239 112 229 214 125 238 205 206
	     51 63 247 16 66 192 203 64 58 133 75 87 225 156 87 57 253 108 143 210 95 113 58 110 59 204 248 215 155 105 63 127 167 113 17 217 109 17 252 182 227 214 220 11 15 13 207 122 132 123 169 17 104 167 71 189 220 51 137 136 236 60 196 56 182 166 44 221 19 167 62 246 216 131 227 249 143 225 136 130
	     18 86 92 133 82 1 10 121 72 37 168 171 203 50 220 215 77 87 75 61 195 125 109 28 251 100 138 255 116 180 79 129 191 200 115 79 79 20 88 136 112 225 225 130 93 186 189 194 15 39 46 243 231 111 127 224 196 217 75 44 45 21 49 47 141 203 102 73 100 235 48 231 19 153 87 89 166 31 189 190 4 192 83
	     230 230 74 0 136 124 188 9 128 39 13 15 143 181 13 121 229 103 121 249 103 18 17 217 121 136 169 76 102 204 214 46 245 63 229 206 107 195 80 132 115 14 15 135 243 92 252 20 65 137 96 117 9 87 94 37 90 94 162 182 62 199 129 125 19 252 227 215 159 115 228 64 63 61 141 105 70 91 235 21 252 139
	     188 0 85 0 136 0 99 45 117 110 172 165 142 142 134 156 53 100 2 218 91 170 153 190 179 200 245 7 75 44 44 175 82 94 156 7 60 44 145 130 100 18 252 4 206 115 188 108 99 234 167 210 28 92 68 68 68 62 10 113 143 37 231 42 215 63 162 136 48 10 161 84 194 43 23 49 223 145 205 101 232 104 108 162
	     46 3 163 93 13 28 59 48 201 215 95 78 177 183 67 229 254 34 47 67 21 0 34 219 92 121 48 103 211 179 203 156 157 94 228 95 127 56 207 111 103 207 51 125 121 58 94 18 144 201 224 165 171 240 211 57 44 145 32 50 91 59 119 197 167 177 215 93 12 160 10 0 145 247 249 12 187 245 107 85 0 136 200 71
	     49 246 177 181 2 224 9 227 223 230 206 74 206 115 120 230 176 40 136 175 250 47 46 192 234 10 169 134 90 198 199 71 57 118 96 140 253 99 109 76 246 53 240 251 9 149 251 139 188 10 85 0 136 108 51 212 218 224 134 90 27 24 234 194 106 115 57 122 26 146 124 87 3 243 75 121 30 45 21 88 41 4 132
	     133 69 204 121 224 167 33 145 4 23 111 29 24 159 238 214 86 238 190 250 100 90 129 191 136 136 136 188 87 182 148 71 186 29 51 4 27 105 72 3 139 176 124 9 11 75 64 68 58 229 83 223 82 77 117 182 137 145 222 14 14 239 223 195 167 7 39 249 15 7 91 21 248 139 188 6 170 0 16 121 138 171 243 129
	     205 220 187 207 169 27 183 185 122 107 150 111 126 190 196 249 107 183 184 119 251 1 81 57 130 154 122 200 214 224 146 41 156 75 98 81 4 102 152 219 222 252 102 251 137 145 245 172 184 115 79 110 140 35 34 239 245 25 118 219 177 255 122 42 0 158 52 164 188 218 179 104 244 17 145 55 49 14 110
	     31 94 28 14 135 231 197 23 77 162 40 192 130 18 182 248 8 86 23 32 225 209 214 209 202 39 83 35 28 57 48 198 190 209 30 6 218 235 56 216 223 162 224 95 228 53 81 5 128 200 83 12 212 39 220 64 125 23 71 198 187 248 241 218 172 165 253 12 45 181 25 78 100 124 238 47 172 82 178 20 69 11 161 92 196
	     44 196 121 14 60 143 205 133 109 207 58 47 58 77 191 69 222 143 9 236 11 199 202 175 127 190 106 187 232 89 68 68 94 116 184 113 24 206 34 8 2 204 192 89 72 194 25 100 211 164 171 27 104 171 171 98 207 112 31 95 29 223 203 223 125 126 128 125 90 231 47 242 250 167 53 170 0 16 121 126 223 93 186
	     107 15 31 60 228 212 245 251 156 189 62 195 201 11 119 184 48 125 155 242 242 10 132 6 185 28 174 42 7 158 135 243 18 27 205 111 119 58 25 154 85 150 201 185 173 55 235 101 22 249 48 18 0 78 113 183 136 136 219 244 209 195 8 131 50 182 186 2 65 25 28 228 170 179 244 117 183 50 54 216 205 190
	     225 38 70 123 154 152 26 238 99 95 79 147 130 127 145 55 64 21 0 34 47 224 216 72 135 99 164 131 193 241 85 235 191 242 128 68 226 23 242 203 203 220 141 74 228 243 171 224 71 36 8 129 8 51 195 204 199 240 136 118 60 35 186 151 138 41 68 68 68 68 222 167 4 128 179 8 71 132 79 132 163 76 224
	     5 120 105 71 46 147 164 171 181 142 35 123 71 56 126 244 0 135 39 219 56 212 154 81 224 47 162 4 128 200 238 50 217 148 117 147 77 253 164 162 192 218 106 51 92 190 126 143 243 87 111 179 176 146 231 193 220 18 229 82 0 120 144 172 130 116 22 252 4 235 5 255 155 170 110 12 83 240 47 34 111 105
	     10 174 209 70 68 222 222 120 19 111 237 231 176 176 72 84 42 66 41 79 16 20 73 164 147 244 182 53 210 211 209 194 64 119 51 189 109 13 124 50 57 206 212 222 78 70 170 147 10 254 69 148 0 16 217 189 254 227 177 97 215 213 209 104 151 175 207 242 205 143 231 56 59 125 141 149 197 101 22 173 28
	     55 9 116 30 46 83 133 121 110 163 1 152 57 216 84 19 96 207 51 103 215 124 93 228 221 177 183 252 184 55 50 25 223 37 235 17 222 64 99 68 17 217 77 227 165 1 222 250 144 227 57 135 97 132 81 9 202 121 40 173 82 83 211 192 228 112 15 71 247 79 240 201 84 63 109 77 25 142 244 170 201 159 200 219
	     59 21 171 7 128 200 107 241 95 126 187 107 103 207 95 230 219 223 46 112 127 110 137 203 55 103 153 95 41 178 90 12 137 34 23 111 23 232 39 193 243 193 247 112 246 28 83 112 37 0 68 228 181 39 0 76 9 0 17 121 109 163 203 218 168 18 111 128 100 88 104 64 4 165 34 174 92 6 31 170 50 9 90 235 210
	     116 53 103 24 233 110 227 247 71 14 48 181 103 136 195 253 13 26 4 68 148 0 16 121 127 93 184 53 99 39 111 63 226 246 189 21 254 252 227 69 206 94 190 202 165 203 87 97 165 8 217 28 84 101 241 50 25 188 100 10 11 141 168 50 31 222 50 29 127 61 251 124 137 136 40 1 32 34 111 48 240 183 181 98
	     127 204 129 231 57 156 65 24 148 176 160 8 139 139 176 180 12 181 213 244 244 116 113 252 192 40 199 143 13 50 209 219 200 223 79 14 233 224 23 81 2 64 228 195 113 101 177 100 127 249 249 38 103 46 92 230 219 95 79 113 247 222 28 75 249 50 243 171 37 34 28 230 249 152 151 196 252 36 158 231
	     99 206 35 62 22 221 227 19 100 37 0 68 68 9 0 17 217 109 9 0 87 25 79 12 136 2 8 74 184 48 0 103 36 124 168 77 249 228 82 30 3 61 109 76 12 15 243 187 79 167 248 127 126 49 168 131 94 68 9 0 145 15 211 197 185 162 205 207 47 112 242 226 29 206 95 189 199 201 51 87 248 229 244 37 230 30 45 64
	     161 4 181 245 80 85 139 75 165 33 145 194 34 163 178 41 110 101 98 252 244 99 211 109 219 69 224 149 143 229 39 244 8 219 28 58 188 195 176 65 68 68 68 222 89 184 239 30 187 201 115 14 92 4 97 72 84 200 195 194 44 148 242 144 73 209 212 208 192 145 3 163 236 217 51 192 209 177 78 122 218 154
	     104 107 111 102 168 46 165 4 128 200 59 166 38 128 34 111 200 104 67 218 209 208 202 209 129 86 126 186 62 111 157 77 181 84 167 29 211 215 239 112 243 238 28 65 186 138 213 114 136 5 5 8 131 248 112 244 189 74 132 237 118 94 10 32 34 34 34 242 142 211 1 102 17 22 6 96 33 206 66 146 158 145
	     170 169 34 237 165 233 108 111 96 160 179 157 127 250 234 16 159 29 30 99 127 87 157 102 52 34 187 233 24 86 5 128 200 219 113 230 246 156 157 191 121 135 75 55 102 249 238 183 219 220 121 240 144 83 23 174 81 88 93 129 66 8 85 213 184 234 90 156 159 88 63 195 218 83 26 5 170 2 64 68 68 68 222
	     70 200 239 85 46 76 56 51 156 115 4 165 60 172 46 65 169 0 9 143 218 250 122 70 251 187 232 233 104 230 232 158 30 122 219 107 57 182 167 159 193 182 90 5 255 34 187 140 42 0 68 222 146 201 174 6 55 217 213 192 153 225 85 235 232 234 231 212 233 75 4 133 2 183 103 102 88 122 56 71 152 8 137
	     162 18 145 5 224 57 156 75 96 206 195 225 97 59 132 221 235 1 191 89 165 245 174 136 136 136 124 20 33 249 235 190 8 240 212 240 31 176 48 158 111 68 17 88 68 194 74 56 23 144 170 74 144 171 203 49 220 215 193 151 159 30 100 98 168 159 35 227 205 76 180 101 52 49 17 217 173 227 135 42 0 68 222
	     141 111 46 60 176 239 126 187 204 157 217 121 126 56 117 153 219 247 102 184 125 119 134 98 161 12 137 52 164 178 120 85 89 156 151 36 140 162 202 41 120 135 107 240 107 199 240 171 38 1 158 80 1 240 140 111 137 136 136 200 91 79 0 108 62 41 187 29 47 20 188 26 111 253 7 56 44 238 234 95 14 32
	     200 67 169 64 117 117 154 166 134 90 198 6 186 217 55 218 205 72 95 43 135 39 199 56 212 95 175 192 95 100 151 83 5 128 200 59 114 124 172 213 213 214 164 109 110 185 76 67 93 61 63 157 60 195 234 210 60 11 165 2 1 33 65 88 142 187 234 226 197 91 5 122 27 39 250 45 161 184 91 91 43 176 233 107
	     247 28 161 250 246 238 219 79 185 187 130 126 17 17 145 119 29 245 219 214 243 114 180 249 123 175 229 7 60 126 230 183 16 44 194 133 1 46 44 147 176 0 143 18 173 117 117 76 142 244 243 229 209 253 28 59 208 75 123 67 154 225 22 5 255 34 74 0 136 200 83 77 117 198 141 113 26 114 105 27 237 168
	     162 191 45 203 244 253 69 174 223 91 97 250 214 44 249 252 50 65 217 32 147 6 63 137 243 147 224 109 218 50 240 241 116 128 136 136 136 200 75 132 255 209 198 172 34 10 226 38 127 65 17 194 128 116 38 69 85 46 203 64 71 23 205 181 73 246 143 118 176 127 116 152 67 83 163 76 180 231 20 248 139
	     40 1 32 34 47 148 8 232 170 113 85 94 175 213 212 215 112 229 126 158 239 78 92 103 102 225 87 86 102 239 195 210 42 212 55 66 186 10 151 118 120 126 138 136 184 3 239 122 137 158 231 112 184 56 9 176 86 13 160 211 177 136 136 200 135 201 94 255 110 65 206 25 158 115 88 20 17 134 65 188 165
	     95 126 25 202 101 18 85 205 52 212 86 179 119 207 8 227 67 237 28 24 106 162 167 165 94 193 191 136 18 0 34 242 178 134 58 154 220 80 71 19 0 109 77 205 86 147 12 56 213 156 224 250 157 25 92 50 195 163 229 2 229 96 149 82 161 8 126 2 231 37 42 45 250 61 88 11 254 95 254 180 143 106 8 68 68 68
	     62 116 219 235 6 227 243 127 188 114 48 34 40 23 241 162 50 25 207 168 170 78 82 219 210 70 85 38 193 158 145 30 58 219 219 249 250 216 1 38 199 91 25 171 78 42 240 23 81 2 64 68 94 151 201 254 6 178 222 94 198 6 155 57 113 254 54 183 239 61 226 199 223 206 179 252 112 6 242 101 168 107 192
	     234 155 32 145 192 115 46 78 2 68 209 214 147 251 51 227 121 183 237 227 115 61 72 68 68 68 94 36 224 222 41 84 126 153 38 220 246 132 152 123 243 115 61 181 33 176 219 118 238 55 112 62 152 97 158 97 133 50 204 205 16 21 151 41 100 83 52 117 119 178 111 207 8 189 29 173 28 217 223 69 125 77
	     53 99 125 141 10 254 69 222 247 81 73 187 0 136 236 110 223 76 63 178 19 167 175 240 127 254 219 15 92 190 122 157 155 119 102 33 93 67 144 174 161 24 57 34 3 240 226 94 128 235 93 123 159 39 148 119 59 4 255 26 15 68 68 68 94 239 108 219 219 30 177 191 92 2 224 137 137 129 231 79 0 184 202
	     121 223 214 206 249 22 119 249 199 69 164 45 192 86 23 168 77 67 119 71 19 123 199 135 249 135 223 31 99 164 191 139 35 125 42 245 23 249 80 168 2 64 100 151 59 62 216 232 50 9 179 170 42 227 234 189 33 126 56 125 147 27 119 230 185 120 237 1 225 220 124 28 195 103 114 88 77 13 158 239 97 24
	     206 121 113 70 255 249 103 15 10 254 69 68 68 222 203 4 131 219 72 4 152 109 250 186 242 127 235 69 8 222 90 30 0 223 57 194 82 17 86 86 176 114 1 10 5 202 13 117 116 180 183 115 104 188 143 195 83 125 12 119 55 242 233 158 30 6 155 171 20 252 139 124 72 67 134 42 0 68 222 47 255 249 167 219
	     246 221 175 23 249 231 191 254 204 205 235 55 201 231 139 148 253 36 126 174 150 200 124 34 28 145 231 192 92 101 247 222 39 30 254 108 84 0 68 122 97 69 68 68 222 200 108 251 13 87 0 172 63 173 109 75 8 84 206 239 206 225 109 132 255 64 20 55 252 11 202 88 97 149 140 31 225 194 18 253 131 189
	     28 61 124 136 63 125 177 143 255 120 184 75 65 191 200 7 74 21 0 34 239 153 255 116 184 203 53 231 146 214 82 235 113 225 90 31 23 175 222 225 226 213 219 44 44 204 81 94 45 65 85 22 146 105 92 58 139 231 39 177 181 240 126 203 100 99 243 231 219 130 255 77 251 12 63 113 189 225 203 207 130
	     120 188 210 96 135 219 220 14 19 35 211 92 68 68 68 222 67 246 204 27 94 211 41 118 91 111 31 7 224 227 188 184 42 48 10 138 68 197 85 88 93 134 82 17 191 38 75 99 125 13 123 71 122 104 110 202 113 104 180 155 131 147 147 252 105 127 167 78 184 34 31 48 85 0 136 188 199 190 191 58 107 223 159
	     188 197 255 249 231 239 56 121 246 28 51 15 230 176 76 150 192 101 240 178 213 68 126 26 136 251 4 196 219 6 218 166 128 251 9 157 255 223 120 2 192 237 48 17 82 2 64 68 68 228 245 157 107 13 240 226 242 127 231 225 8 241 130 60 174 180 138 183 178 0 197 60 157 253 93 76 140 13 243 239 255 112
	     148 169 145 14 190 28 83 224 47 242 49 80 5 128 200 123 236 211 129 38 215 82 91 103 141 85 1 3 61 53 156 186 114 151 7 115 5 110 220 95 32 191 186 68 84 94 132 84 6 151 78 227 60 15 231 197 61 2 108 109 93 224 91 103 188 246 141 139 69 68 68 100 157 231 12 51 195 8 33 8 177 213 21 44 40 64 38
	     65 75 67 45 61 35 29 84 103 125 14 79 244 50 62 56 192 87 159 78 49 212 152 214 201 89 68 9 0 17 121 31 12 54 37 220 224 63 124 194 240 80 155 253 50 253 136 159 126 187 14 191 156 229 198 245 27 228 87 150 112 86 19 31 233 94 10 231 226 158 0 102 107 29 128 189 245 176 188 178 9 176 94 80 17
	     17 145 93 206 109 238 246 111 113 192 239 32 94 219 239 192 136 48 3 207 74 132 43 143 112 229 60 185 92 27 163 125 93 252 221 241 125 12 244 52 50 217 83 71 125 46 171 224 95 228 99 27 63 180 4 64 228 195 242 63 253 120 211 126 58 113 134 179 87 174 113 249 214 3 150 87 3 230 150 139 228 87
	     139 68 230 176 100 10 18 233 202 90 65 111 163 81 224 78 9 128 55 82 118 191 67 51 36 45 1 16 17 17 121 201 4 64 84 217 206 15 136 2 92 80 196 179 16 92 68 77 46 77 210 69 180 212 103 153 26 233 227 200 222 61 252 225 139 131 28 104 87 208 47 162 4 128 136 124 16 174 60 202 219 131 135 179 220
	     124 180 200 197 233 135 156 190 112 141 111 79 92 228 246 213 155 132 197 34 212 52 224 234 155 192 75 224 156 71 228 188 77 241 183 189 254 34 128 237 93 137 89 207 54 108 74 0 136 136 136 200 243 207 224 97 45 161 238 48 204 66 188 40 194 74 69 108 121 1 47 42 226 60 163 127 176 139 125 99
	     195 28 217 55 204 254 209 118 58 154 26 56 216 215 172 224 95 228 35 166 37 0 34 31 152 161 198 42 55 212 216 205 103 192 197 177 130 245 181 53 144 75 70 252 148 115 220 120 176 72 41 242 113 137 136 82 88 34 138 28 206 37 48 175 178 65 208 91 139 197 21 244 139 136 136 188 218 105 52 110 238
	     235 162 16 207 69 248 206 72 101 124 162 68 53 173 117 205 212 103 29 135 247 12 242 229 177 163 124 126 100 140 193 186 132 2 127 17 81 2 64 228 67 54 218 152 113 197 137 110 171 74 133 244 15 245 242 235 197 123 252 118 238 42 55 110 222 163 188 180 2 126 2 210 85 144 171 198 79 36 1 127 203
	     166 128 91 42 132 156 171 148 28 26 42 28 18 17 17 121 61 182 148 243 111 63 247 110 190 223 150 199 196 247 179 98 101 107 191 160 68 68 72 174 181 137 246 142 78 142 76 14 49 208 145 101 178 191 153 169 145 94 5 255 34 162 4 128 200 199 98 111 87 163 219 219 213 8 192 127 62 113 223 234 171
	     255 198 223 172 200 221 251 70 41 52 34 103 36 252 8 35 32 196 192 121 88 101 189 253 147 167 32 47 144 1 112 154 115 136 136 136 188 82 146 0 214 58 246 196 167 85 103 36 8 49 63 196 75 57 50 217 20 233 148 199 158 225 14 166 198 199 249 227 23 71 24 29 200 50 81 155 210 73 88 68 148 0 16 249
	     88 253 167 3 109 142 194 148 181 212 250 220 186 59 207 181 59 115 92 187 117 143 59 15 31 65 177 12 169 28 100 114 184 84 21 206 79 196 235 10 55 109 221 103 59 110 225 183 189 113 96 101 130 226 85 118 24 80 185 128 136 136 200 142 231 202 199 147 228 182 41 228 223 148 0 240 60 204 34 44 8
	     32 40 192 242 18 97 57 15 85 105 186 91 155 24 27 232 160 167 179 142 3 163 125 140 14 12 242 143 251 235 21 248 139 200 142 212 4 80 228 35 116 126 110 201 238 207 148 248 254 196 52 223 252 240 11 223 254 244 27 15 31 45 96 233 28 126 85 13 94 58 135 249 105 162 40 34 178 168 210 129 127 45
	     17 176 125 78 17 41 1 32 34 34 242 90 18 0 91 166 233 149 173 253 0 207 199 57 131 160 4 229 2 225 252 67 8 243 116 117 180 113 248 192 36 127 248 124 63 251 39 122 248 253 104 135 2 127 17 121 42 85 0 136 124 132 198 27 106 220 120 3 212 231 170 172 53 107 52 215 38 184 120 235 33 55 31 174
	     114 103 161 64 105 113 14 23 56 44 157 130 84 6 252 4 46 222 88 56 158 179 104 122 33 34 34 242 70 184 181 255 171 108 239 23 149 203 184 124 158 40 44 67 194 167 166 190 134 166 145 94 122 90 178 236 237 239 228 147 169 81 62 61 52 206 100 123 173 206 206 34 242 236 49 70 87 231 68 228 187
	     233 59 118 238 250 44 255 215 183 23 249 246 228 69 166 167 175 194 226 10 212 212 226 213 212 225 37 82 56 63 133 69 16 70 128 179 77 133 255 26 67 68 68 68 94 204 19 74 253 49 60 7 158 7 152 225 162 136 160 148 39 154 153 133 114 1 87 95 207 222 201 113 190 56 50 206 167 135 6 152 234 105
	     228 80 87 147 2 127 17 121 110 170 0 16 17 142 13 118 186 99 131 157 100 82 57 107 173 203 112 178 45 195 244 237 7 44 174 4 44 175 22 41 23 86 240 72 98 137 36 36 51 241 182 129 94 101 57 128 185 29 38 52 34 34 34 242 100 222 142 9 1 195 136 130 50 148 11 16 148 49 15 178 41 159 100 123 61 45
	     141 181 12 116 181 240 201 190 9 126 255 197 62 254 52 218 172 192 95 68 94 152 42 0 68 100 139 223 110 60 180 107 247 231 56 113 249 14 63 252 116 142 239 126 185 192 236 204 12 148 66 200 214 66 93 35 46 149 2 151 192 240 33 138 54 5 254 26 79 68 68 228 227 9 219 163 151 159 130 111 251 220
	     192 129 115 134 229 151 96 105 22 138 121 92 42 65 127 79 39 251 167 198 248 236 147 3 236 27 108 160 163 181 150 253 221 186 234 47 34 47 71 21 0 34 178 197 190 222 22 183 175 183 133 145 254 30 107 174 202 144 176 128 107 183 115 92 127 176 72 209 18 20 93 128 149 34 48 15 188 36 248 190 182
	     250 19 17 145 15 158 123 194 109 47 151 250 222 244 40 139 32 12 33 44 3 134 71 68 85 67 29 141 185 38 218 235 171 152 24 234 227 235 227 135 249 242 240 94 6 27 117 194 21 145 87 28 203 84 1 32 34 79 114 254 254 162 157 185 114 147 219 15 23 248 225 204 61 46 221 188 195 217 203 215 88 158
	     91 130 192 32 149 134 92 45 126 50 21 55 8 172 76 143 34 189 116 34 34 242 1 38 0 118 218 180 207 94 234 57 108 189 156 32 42 22 161 84 128 229 101 8 3 170 59 154 57 178 111 156 163 83 3 12 247 228 232 110 170 227 223 29 26 83 224 47 34 175 133 42 0 68 228 137 198 219 106 221 120 219 36 87 150
	     2 107 105 159 225 228 153 243 120 81 137 155 119 31 50 63 191 76 49 2 179 34 46 136 0 15 115 62 56 15 231 60 45 6 16 17 17 217 18 252 59 28 22 95 241 39 196 5 33 46 2 44 192 79 122 36 107 211 164 147 25 166 70 187 249 227 241 3 252 254 232 4 159 247 86 41 240 23 145 215 59 22 169 2 64 68 158
	     215 119 151 31 218 47 103 47 113 123 102 145 211 23 111 113 238 218 29 110 222 190 79 97 41 15 169 42 72 87 65 50 131 75 164 217 24 90 158 103 140 121 118 35 65 181 26 20 17 145 119 27 192 239 236 217 231 164 248 82 191 231 28 16 17 5 249 248 138 127 97 5 202 1 217 218 28 189 93 237 140 15 180
	     50 212 211 196 222 161 30 62 217 59 198 84 103 141 130 127 17 121 237 84 1 32 34 207 237 216 112 139 107 172 75 219 252 106 72 91 75 43 233 76 146 252 242 60 119 150 151 192 133 68 22 224 8 43 255 121 68 184 39 237 116 180 109 74 229 158 58 157 122 246 61 68 68 68 222 172 151 59 239 108 62 131
	     25 68 33 206 66 176 8 23 5 224 149 105 109 200 50 57 216 201 223 29 223 203 39 123 123 57 218 215 162 192 95 68 148 0 16 145 221 97 180 165 214 1 212 101 146 214 89 151 164 167 49 195 233 233 59 220 157 93 229 250 189 69 86 11 121 130 213 21 72 164 32 145 6 223 195 243 124 192 91 239 13 240
	     242 77 147 68 68 68 118 177 141 134 254 149 144 223 192 66 40 151 137 138 171 16 149 113 105 143 166 186 42 186 134 91 104 107 172 230 224 112 55 83 227 67 124 126 112 132 129 198 156 130 127 17 81 2 64 68 118 159 177 182 106 55 214 182 151 142 182 58 235 191 62 203 143 191 76 179 184 114 134
	     194 202 50 44 44 64 54 7 85 134 243 50 120 36 226 10 72 131 181 101 71 241 28 73 243 28 17 17 249 80 130 255 202 89 205 92 92 238 239 140 184 45 174 17 150 243 176 244 8 194 0 191 169 145 214 134 6 62 253 100 130 189 19 125 28 238 107 164 169 190 70 193 191 136 188 165 161 74 61 0 68 228 53 248
	     159 127 186 97 255 242 205 9 174 221 188 195 197 233 219 20 195 136 153 165 60 197 114 68 24 122 152 151 192 82 41 60 47 1 206 97 56 204 214 230 58 155 202 35 183 124 220 250 221 205 222 228 200 165 126 3 34 34 242 194 103 14 103 56 12 23 129 69 33 148 139 113 131 63 7 85 41 143 154 180 163
	     177 46 199 232 64 55 163 3 61 252 225 248 126 254 126 178 77 65 191 136 40 1 32 34 239 159 233 249 130 93 189 251 144 123 179 139 124 247 203 45 110 221 185 195 143 39 207 112 251 254 12 44 23 32 153 133 134 38 92 182 26 60 31 204 197 141 144 137 182 37 0 12 183 105 155 227 29 199 168 205 183
	     189 202 150 200 79 136 244 55 175 216 212 150 134 34 242 17 207 18 159 50 104 62 62 118 190 205 88 251 177 31 110 238 45 191 38 110 235 207 118 46 206 1 16 225 34 71 180 186 12 75 243 80 90 129 164 79 79 95 39 135 246 77 48 53 222 207 39 123 58 104 168 206 241 213 120 167 130 127 17 121 235
	     180 4 64 68 94 139 193 250 140 27 172 239 1 96 168 171 199 174 92 185 73 109 198 184 116 253 46 87 111 60 100 185 24 17 164 28 133 114 1 240 192 37 192 243 42 115 40 205 129 68 68 228 125 99 149 243 87 4 161 1 33 22 6 16 65 210 55 82 13 57 26 115 245 52 55 100 56 188 103 152 191 255 253 113
	     38 199 58 217 211 162 173 253 68 228 221 81 5 128 136 188 49 255 223 239 206 217 237 135 121 254 118 226 26 23 166 111 115 229 198 77 150 31 62 2 231 197 219 6 230 170 241 83 41 204 192 57 135 153 197 59 7 188 201 65 111 91 197 192 78 99 160 42 0 68 68 80 5 192 142 63 186 18 244 59 3 103 120
	     248 88 24 197 13 254 74 121 200 175 64 49 32 211 222 194 224 64 47 199 15 140 48 57 208 192 68 87 3 255 112 120 76 129 191 136 40 1 32 34 31 190 255 249 215 25 251 245 204 52 127 253 254 71 46 92 186 202 106 190 204 74 41 132 116 21 161 151 192 195 35 114 126 156 24 112 222 27 13 186 95 52 1 96
	     168 15 128 136 40 1 160 4 192 218 143 94 219 199 38 4 11 113 22 65 100 36 162 34 190 133 84 121 17 9 103 76 76 140 113 244 200 97 254 225 248 56 127 55 214 160 192 95 68 148 0 16 145 143 203 201 155 203 118 226 220 5 78 92 190 205 133 43 247 57 121 126 154 133 197 69 86 22 87 32 153 142 123
	     4 164 170 240 210 85 24 30 102 59 165 1 94 116 188 242 54 125 30 85 18 0 108 233 53 184 211 156 209 237 130 249 173 136 136 18 0 79 78 0 196 137 218 141 31 30 189 177 4 192 70 179 90 231 192 57 15 179 0 11 74 80 88 129 213 69 32 162 166 190 134 182 230 6 246 142 246 208 217 81 199 103 99 131
	     12 141 12 115 108 160 78 193 191 136 236 42 234 1 32 34 111 197 254 158 106 183 191 231 19 246 140 246 217 79 167 111 147 241 61 174 92 155 230 106 57 79 148 112 20 49 140 16 139 202 56 151 136 119 8 120 165 105 147 219 225 107 139 175 248 219 51 38 180 10 254 69 68 30 207 144 238 150 80 214
	     214 126 21 183 109 132 127 131 63 16 171 252 207 192 66 60 11 73 120 144 72 66 38 149 96 160 183 133 177 129 126 254 225 203 3 76 14 182 240 201 64 187 2 127 17 217 149 84 1 32 34 111 221 244 163 178 253 116 234 60 151 111 220 226 199 243 55 153 91 42 114 225 198 44 143 230 151 41 173 22 193
	     79 64 186 10 151 72 226 124 63 158 126 69 134 189 208 236 211 241 120 155 255 141 73 220 250 189 54 239 56 160 183 70 68 228 233 195 234 78 177 241 59 224 237 28 162 191 246 127 174 115 96 22 130 25 86 46 65 62 15 132 184 84 138 174 150 6 250 59 235 233 107 175 231 200 100 15 221 237 237 252
	     143 199 199 21 248 139 200 174 166 10 0 17 121 235 6 27 147 206 237 237 179 161 193 86 218 251 251 185 122 99 150 144 179 92 10 175 51 191 184 64 24 122 88 210 199 34 240 156 85 250 2 24 134 255 122 166 116 110 231 20 129 146 0 34 34 178 118 134 112 68 56 139 112 86 38 2 252 176 136 173 46 146
	     72 122 84 213 102 24 238 111 231 171 99 7 216 51 208 202 84 127 13 233 68 82 47 155 136 236 254 209 77 21 0 34 242 174 253 112 115 197 190 253 245 28 211 55 110 114 242 220 117 238 62 92 224 209 226 50 243 203 5 204 124 34 63 129 151 76 19 121 169 74 21 192 243 20 123 62 169 2 224 69 238 33 34
	     34 91 6 205 237 62 208 10 0 135 225 130 2 22 22 241 93 132 231 28 245 185 12 73 223 209 223 217 204 88 127 7 135 166 70 249 221 167 251 216 215 146 212 85 127 17 121 111 168 2 64 68 222 185 163 61 57 231 130 62 155 24 106 161 189 165 131 95 206 92 225 199 19 167 152 93 124 4 145 195 18 85 132
	     117 77 144 170 132 236 206 3 219 62 221 179 167 207 74 183 223 223 185 199 31 225 118 152 62 154 230 117 34 162 128 255 245 5 251 110 219 231 239 58 245 234 182 156 23 214 127 159 48 34 42 20 32 191 76 232 135 68 158 71 115 123 19 3 189 93 28 59 48 202 196 112 59 125 45 181 10 254 69 68 9 0 17
	     145 151 113 100 160 197 1 12 182 117 218 64 123 3 141 153 128 147 13 25 102 22 139 60 88 40 66 194 99 37 40 86 150 3 56 192 199 121 91 39 112 143 79 33 237 153 51 87 93 241 23 17 121 215 153 133 119 201 112 113 107 63 136 44 46 251 143 34 124 23 146 174 78 145 168 169 167 167 185 154 218 108
	     154 207 246 143 49 57 49 206 177 3 125 140 55 103 21 248 139 136 18 0 34 34 175 106 184 57 233 130 209 14 75 248 135 232 29 232 231 220 213 89 190 253 237 18 247 238 63 32 186 55 7 169 36 36 83 144 171 193 75 167 193 92 220 217 127 189 153 159 197 23 251 215 190 222 178 204 233 25 59 11 172
	     93 237 119 74 11 136 136 188 141 224 251 93 164 97 31 219 35 198 243 176 48 128 66 1 43 22 176 194 10 145 15 213 237 173 244 180 119 240 217 190 1 186 218 106 56 50 210 69 79 87 187 130 127 17 81 2 64 68 228 117 26 239 168 117 227 29 123 1 248 95 207 204 88 83 67 29 191 157 61 197 133 164 17
	     226 88 46 134 68 137 50 33 14 195 195 195 17 57 15 51 175 50 153 116 207 55 235 19 17 145 119 156 0 120 55 63 215 85 126 188 115 17 22 69 164 93 136 75 25 169 100 146 84 77 53 181 53 105 246 79 141 50 57 50 194 215 159 77 209 215 158 98 168 174 74 103 17 17 81 2 64 68 228 77 250 247 147 205
	     46 25 142 219 104 71 154 95 123 218 120 240 104 149 147 231 175 113 227 246 125 88 92 134 84 6 106 234 112 153 28 46 145 1 124 140 136 245 217 221 78 9 128 103 205 57 55 175 251 127 194 99 220 46 152 194 138 136 188 127 241 249 19 158 116 123 229 213 51 250 175 216 11 255 170 107 21 94 30 206
	     115 88 24 96 81 0 133 21 88 94 160 232 12 63 155 161 183 187 141 177 129 78 122 187 27 57 186 119 136 206 182 118 254 48 86 167 192 95 68 148 0 16 17 121 91 254 180 175 203 253 105 95 23 191 220 154 181 75 215 102 105 170 169 226 91 47 224 250 244 10 81 194 240 211 142 192 51 66 103 152 185
	     77 19 73 123 99 87 253 159 55 151 32 34 34 175 63 179 96 47 253 136 248 163 239 71 64 72 34 13 65 17 106 171 51 244 116 181 242 217 193 9 190 58 126 136 225 190 38 62 233 174 87 224 47 34 74 0 136 136 188 43 135 186 155 220 161 238 38 146 46 176 174 246 106 126 185 208 197 221 153 85 110 207
	     44 243 240 238 44 20 202 144 204 64 109 13 36 19 56 23 239 24 16 183 1 48 32 194 225 0 15 28 113 219 39 91 11 231 141 231 219 94 80 68 68 94 171 55 210 119 37 142 221 227 198 254 149 94 3 145 97 197 60 81 97 149 200 5 224 160 161 181 142 166 206 33 246 143 118 48 53 220 193 254 145 1 254 219
	     163 67 10 252 69 228 3 30 114 77 147 93 17 121 255 92 120 48 103 23 103 86 56 121 238 62 255 250 205 73 126 252 233 87 22 239 63 132 100 21 169 150 54 44 145 192 60 159 8 15 34 35 138 214 166 132 149 109 4 31 75 0 60 97 59 170 39 92 234 247 54 221 172 81 84 68 228 53 39 0 94 195 22 172 14 112
	     158 195 35 196 69 224 44 34 202 47 19 44 47 144 78 251 164 210 41 62 57 184 135 35 159 236 227 15 71 6 25 107 203 49 208 164 114 127 17 249 176 169 2 64 68 222 75 99 173 13 110 172 181 129 238 214 54 171 207 56 218 234 124 206 93 185 205 221 217 5 10 65 196 210 210 66 28 244 123 73 72 103 112
	     94 18 240 48 231 226 202 128 157 162 122 17 17 121 223 179 9 0 120 14 204 34 172 88 32 12 10 184 114 9 223 115 212 212 164 201 54 183 50 218 215 65 75 125 53 199 14 140 115 244 240 62 62 239 173 86 224 47 34 31 199 40 169 10 0 17 121 223 93 122 184 100 247 30 45 114 122 122 150 111 127 58 203
	     175 103 206 113 113 250 54 65 41 36 114 9 188 186 6 92 58 7 230 136 28 149 221 2 42 9 0 219 180 107 128 173 149 9 60 123 30 168 20 130 136 200 107 155 141 86 6 212 231 24 123 183 141 207 27 243 88 183 254 209 173 21 122 133 1 209 234 34 20 86 112 229 60 85 85 73 38 246 12 49 57 54 204 151 71
	     167 232 108 173 102 176 185 134 209 246 6 5 255 34 162 4 128 136 200 251 232 255 247 237 85 251 235 143 63 114 226 226 77 238 60 202 115 123 118 137 124 41 34 10 193 156 143 249 62 230 37 192 249 143 63 120 109 60 116 154 11 138 136 236 202 137 235 19 18 0 241 34 46 195 89 4 81 4 229 34 190
	     133 56 31 26 107 171 104 173 77 209 209 88 197 231 135 38 216 63 181 135 255 112 100 80 3 189 136 40 1 32 34 242 33 248 215 51 211 118 245 193 34 231 111 44 243 221 201 243 252 122 234 2 203 119 31 96 126 18 151 173 134 116 22 151 202 196 87 239 55 87 0 240 228 43 250 107 147 78 141 153 34 34
	     239 112 226 138 219 40 218 34 174 218 242 12 60 231 17 69 101 44 40 67 41 143 205 61 194 249 142 186 174 14 142 29 216 203 177 131 3 12 118 84 177 183 171 153 3 195 61 10 254 69 228 163 165 30 0 34 242 193 249 106 114 208 125 53 9 223 220 46 91 99 117 21 89 10 156 73 27 171 197 136 178 121 20
	     195 0 11 11 132 120 241 46 1 149 106 0 67 115 66 17 145 221 204 182 165 105 61 12 103 33 132 1 9 34 252 68 68 54 155 166 148 170 161 185 190 154 189 99 195 124 253 197 126 254 240 249 36 251 26 85 222 37 34 162 4 128 136 124 176 142 119 37 93 242 64 159 53 101 3 38 135 59 185 124 125 142 115
	     211 119 185 118 243 14 165 149 60 36 210 80 93 11 137 20 94 50 69 188 53 192 246 245 164 186 226 47 34 242 58 60 119 37 213 230 239 187 141 181 253 241 176 108 27 183 89 68 20 6 176 186 2 139 143 32 1 213 117 181 12 246 246 208 217 58 204 216 64 43 19 3 61 76 142 245 40 248 23 17 81 2 64 68 62
	     6 71 134 154 221 145 161 102 126 186 245 200 126 60 113 131 148 127 138 226 202 60 55 138 203 152 31 225 251 14 156 97 46 222 18 208 61 118 125 137 231 155 176 138 136 200 27 100 155 62 86 26 253 1 120 142 200 139 128 128 76 38 73 119 115 13 135 38 134 56 114 96 130 67 147 93 28 236 212 182
	     126 34 34 74 0 136 200 71 231 112 119 163 171 78 166 44 151 114 116 183 166 56 125 237 62 183 103 242 220 153 93 102 126 97 9 230 31 129 151 128 108 14 146 41 156 231 131 115 241 178 0 219 60 249 20 17 145 23 177 165 113 159 217 11 55 92 117 46 78 194 58 92 252 208 194 42 86 200 99 81 136 151
	     205 208 214 92 79 203 64 43 163 189 141 140 244 180 113 116 255 30 254 135 227 227 10 252 69 68 118 26 83 117 85 75 68 62 54 63 223 156 177 211 183 22 248 229 228 53 254 237 251 211 156 191 114 141 194 131 123 224 39 112 13 173 36 179 57 204 121 24 30 145 57 34 141 147 34 34 175 156 0 176 205
	     193 255 83 19 0 149 171 252 149 206 44 206 85 62 119 30 30 33 197 165 5 88 94 4 7 117 173 205 28 222 55 198 209 3 99 28 217 215 79 95 115 154 67 93 205 10 254 69 68 148 0 16 17 217 234 159 47 205 217 191 254 237 4 23 175 76 115 110 250 14 179 243 75 204 47 151 200 151 2 48 48 63 13 169 44 150
	     76 111 76 74 109 251 36 85 68 228 35 158 72 62 199 136 248 196 4 128 231 85 30 104 59 62 163 231 28 68 33 22 150 33 40 225 138 121 204 51 18 73 143 150 250 106 122 59 154 25 238 105 229 232 129 9 142 29 156 228 72 119 70 129 191 136 136 18 0 34 34 79 246 203 173 89 91 92 90 230 215 11 11 156
	     60 115 158 63 127 251 19 215 174 223 130 82 8 233 28 212 183 224 114 117 96 22 207 81 183 76 96 53 126 138 200 199 29 252 111 79 0 188 208 168 232 28 142 237 61 86 188 245 219 61 223 195 133 101 130 252 50 20 150 97 126 6 124 71 247 80 31 95 29 63 194 151 159 78 49 210 83 71 103 83 53 163 205
	     181 10 254 69 68 158 131 122 0 136 200 71 237 80 119 147 131 38 190 154 128 255 165 179 214 210 228 57 213 92 197 221 71 171 204 46 135 172 6 1 209 210 124 220 31 192 79 196 87 172 60 47 158 180 234 229 19 17 121 105 222 166 113 212 97 241 182 172 22 65 104 16 5 88 62 192 44 196 119 33 53 13
	     53 100 155 210 180 52 100 56 182 111 15 255 244 199 195 252 119 71 6 20 244 139 136 188 32 85 0 136 136 108 242 47 167 166 237 238 252 18 103 166 231 249 235 175 87 248 233 228 89 86 111 223 135 76 22 114 213 144 78 227 167 210 56 7 81 4 22 79 91 69 68 62 190 73 36 175 86 1 224 57 195 112 56
	     51 60 231 112 190 79 20 5 132 197 2 172 174 194 226 2 36 61 106 91 155 217 59 62 200 129 137 110 246 141 181 176 175 167 157 99 227 125 10 254 69 68 94 130 42 0 68 68 54 249 122 239 160 3 248 105 168 104 117 53 141 36 194 21 78 123 69 74 97 130 213 200 8 163 34 20 3 204 121 56 207 199 121 62
	     230 18 68 170 9 16 17 121 129 228 129 91 223 122 21 34 44 140 160 156 7 11 73 96 164 114 73 210 85 181 212 212 87 49 62 56 192 177 79 246 243 245 177 81 190 26 110 82 224 47 34 242 42 227 175 42 0 68 68 118 118 254 65 201 78 159 61 199 247 23 175 50 125 245 33 39 206 223 228 254 236 28 43 115
	     75 241 114 128 92 45 126 58 131 75 164 137 92 34 222 45 96 125 203 64 141 173 34 242 161 7 241 143 123 246 200 23 55 254 115 94 124 229 31 2 176 144 104 121 1 22 231 192 115 52 182 53 51 54 208 197 248 80 55 131 125 45 140 119 183 210 215 215 195 145 222 58 5 255 34 34 175 72 21 0 34 34 79 48
	     222 154 114 227 173 251 25 24 234 180 159 126 187 6 6 87 174 195 181 176 76 57 114 148 61 136 162 16 43 151 193 55 112 126 101 74 172 224 95 68 62 124 47 63 210 57 44 138 192 66 28 1 16 145 112 17 126 210 145 171 201 48 214 215 204 231 251 71 249 253 241 3 12 246 52 177 167 37 171 192 95 68 228
	     53 81 5 128 136 200 115 250 127 255 249 132 221 187 247 144 19 87 239 115 247 193 18 23 174 222 231 246 131 121 202 249 34 120 62 228 106 32 153 89 111 102 5 86 217 197 90 68 228 35 159 112 110 250 104 102 88 161 0 165 60 68 101 188 180 79 71 107 61 131 61 173 76 14 180 114 112 184 141 241 129
	     1 190 156 234 213 0 42 34 242 154 169 2 64 68 228 57 29 153 26 164 60 214 67 247 200 18 231 167 239 177 90 248 153 185 133 101 150 23 23 226 9 109 38 133 75 38 214 39 186 91 23 2 104 30 43 34 31 111 240 239 85 214 250 59 226 173 84 195 160 128 43 229 113 46 32 229 178 12 245 118 240 247 95 126
	     202 209 169 46 6 154 83 140 52 53 104 208 20 17 121 19 99 178 42 0 68 68 94 220 111 247 150 237 191 254 245 55 206 93 190 206 133 107 119 185 125 255 17 139 249 34 115 43 37 34 243 48 151 128 132 143 75 164 49 60 214 214 189 126 40 203 3 182 119 254 22 17 121 124 132 48 192 225 44 132 176 132
	     133 101 8 139 36 112 212 85 103 104 169 175 161 167 173 150 214 166 26 142 30 156 226 143 95 236 101 79 99 70 129 191 136 136 18 0 34 34 187 207 119 211 247 109 110 185 192 169 139 247 249 254 228 5 78 158 62 199 149 203 55 227 201 175 159 134 92 53 94 182 22 115 137 74 18 96 83 77 128 189 161
	     208 217 109 122 78 123 51 243 232 87 221 250 75 68 94 224 56 126 210 177 252 170 199 250 203 117 240 123 129 39 117 224 28 158 3 11 202 88 113 9 86 151 227 255 18 30 99 227 195 28 218 183 135 207 63 25 161 171 45 71 79 75 61 159 244 181 40 248 23 17 81 2 64 68 100 247 251 159 190 157 182 127
	     251 246 123 190 63 117 153 185 213 144 187 51 43 132 56 86 35 48 75 128 75 128 23 239 115 189 54 209 126 35 163 175 18 0 34 74 0 188 163 4 192 70 11 212 202 0 23 5 16 134 120 68 164 124 163 58 13 205 89 143 198 154 12 95 126 178 143 79 63 61 204 127 127 180 71 65 191 136 200 91 164 30 0 34 34
	     175 193 255 240 217 160 171 73 151 173 107 160 159 107 183 151 249 243 207 231 184 115 231 30 43 183 238 196 187 3 84 101 33 83 5 85 57 156 243 193 162 167 207 187 55 39 103 157 230 199 34 178 155 25 14 135 231 28 206 57 130 40 132 160 8 43 75 176 184 64 148 72 66 103 11 189 61 157 28 219 215
	     199 112 119 61 199 6 186 105 239 105 209 75 39 34 242 150 169 2 64 68 228 53 251 219 245 121 251 223 255 237 60 103 46 92 224 215 19 103 40 148 2 86 202 17 101 243 40 185 20 230 37 112 206 195 156 135 195 97 206 241 216 80 252 178 9 0 85 0 136 124 8 179 179 109 227 193 110 170 0 88 187 206 95
	     249 232 192 153 225 204 128 16 162 8 143 0 207 34 210 4 164 44 160 177 177 142 209 177 33 62 217 59 198 191 251 98 146 207 122 235 148 213 20 17 81 2 64 68 228 3 74 2 92 126 100 183 238 222 225 155 19 211 220 123 248 136 19 231 175 113 245 246 3 202 243 203 113 69 64 109 3 100 170 113 126 2 231
	     39 176 48 194 182 204 190 119 247 216 236 109 250 60 210 219 45 242 110 147 4 219 19 0 206 118 14 238 173 18 192 191 104 248 109 182 233 113 222 70 240 239 197 87 252 45 12 226 114 255 229 121 88 156 7 23 225 114 89 38 134 123 152 24 237 101 106 184 139 169 129 78 218 58 219 248 221 96 147 130
	     127 17 145 119 72 75 0 68 68 222 128 207 135 27 29 195 141 140 14 116 217 181 91 115 52 212 84 83 159 59 207 181 171 183 88 94 13 176 164 71 137 144 40 114 235 107 102 29 14 123 79 182 11 84 208 47 242 81 102 29 54 125 102 88 37 49 224 185 8 207 51 252 164 131 180 71 77 77 134 142 182 22 190
	     62 58 201 63 252 225 48 255 180 191 87 65 191 136 200 110 25 201 85 1 32 34 242 230 253 255 127 185 98 87 110 221 226 151 243 119 56 55 253 128 219 247 23 184 117 231 33 4 33 152 7 217 42 200 84 225 156 135 115 30 152 219 84 90 175 113 90 68 30 155 193 109 124 254 22 42 0 92 165 171 191 171
	     60 133 5 1 150 95 129 160 4 132 144 78 209 211 214 64 99 93 53 159 140 119 48 210 221 196 225 61 35 252 241 192 128 130 127 17 17 37 0 68 68 62 62 87 231 151 236 242 189 85 126 56 123 143 111 191 255 149 239 126 57 67 126 105 145 98 190 140 87 83 11 233 12 230 249 68 46 17 39 5 240 42 87 218
	     109 99 226 13 104 220 22 145 23 79 0 184 39 6 247 27 143 123 210 125 192 119 113 6 193 25 224 34 44 44 227 86 151 240 202 37 210 85 9 50 181 53 124 113 100 63 251 38 246 240 213 193 78 58 155 210 140 54 107 173 191 136 200 110 163 37 0 34 34 111 201 64 125 141 27 168 175 161 179 181 205 186
	     107 61 122 90 170 185 122 231 33 231 174 221 161 28 4 204 46 44 19 5 70 68 2 151 204 64 50 19 247 11 48 205 161 69 228 157 100 25 0 240 60 48 11 160 92 198 130 2 86 46 146 72 122 212 183 84 211 217 88 207 248 64 59 45 13 57 190 56 180 151 177 241 113 14 180 160 65 75 68 68 9 0 17 17 1 152 108
	     196 165 246 246 89 87 123 3 211 183 230 248 235 207 231 152 190 121 131 229 133 5 138 229 34 22 198 45 246 44 145 138 103 222 149 210 91 51 214 155 113 109 190 80 247 220 21 1 111 96 223 111 17 121 71 158 146 24 116 219 14 246 167 14 17 143 93 245 119 219 190 23 197 125 255 130 8 11 75 120 197
	     85 188 252 18 185 134 26 198 122 219 57 186 119 156 47 143 140 210 144 75 242 229 120 143 2 127 17 145 93 78 75 0 68 68 222 177 255 229 135 107 118 113 122 154 239 126 187 200 221 71 75 76 223 91 96 113 165 76 49 52 202 145 3 47 25 87 2 120 149 109 3 177 184 79 128 18 0 34 178 99 76 191 61 1 240
	     98 7 122 220 227 63 138 51 7 81 9 162 144 164 103 36 61 104 173 203 208 144 243 25 234 110 230 171 35 7 216 63 53 202 23 35 173 10 252 69 68 222 19 170 0 16 17 121 199 246 12 52 211 94 239 211 208 82 207 245 123 75 164 127 185 204 169 75 55 200 223 189 135 43 4 144 171 198 210 89 92 58 141 231
	     28 81 100 96 209 70 83 46 183 169 43 191 2 122 145 143 222 139 196 251 219 82 5 120 158 3 51 194 32 128 160 132 203 175 192 234 50 65 174 138 108 67 61 99 131 253 28 218 219 195 222 222 102 246 247 119 178 167 95 193 191 136 200 251 68 21 0 34 34 187 200 175 247 11 246 231 31 206 243 243 111
	     231 248 237 236 101 238 207 45 82 54 159 149 66 136 121 30 1 62 206 121 152 139 155 4 226 124 96 115 2 192 158 119 166 175 132 129 136 224 214 135 134 8 71 132 179 8 44 34 65 136 71 68 85 18 8 3 250 58 154 233 237 238 228 235 99 251 248 250 139 73 246 54 102 20 248 139 136 188 135 84 1 32 34
	     178 139 28 108 203 184 194 84 143 117 52 38 232 237 106 224 194 244 125 46 94 189 195 169 115 211 176 188 2 248 208 216 8 233 28 206 143 123 4 24 174 18 248 219 211 35 122 5 251 34 178 30 246 87 62 58 135 17 130 65 84 42 195 242 2 20 86 9 82 142 92 77 13 125 125 221 116 52 53 115 112 170 135
	     190 206 102 38 135 123 20 252 139 136 188 207 103 0 85 0 136 136 236 78 151 102 87 237 244 244 12 127 249 246 87 254 203 191 125 207 141 59 247 88 204 7 100 27 155 8 189 12 161 151 34 36 129 225 131 69 155 146 0 34 34 207 59 19 116 120 46 194 199 72 132 37 194 252 18 86 90 165 179 185 150 238
	     142 86 190 252 236 0 83 163 19 28 157 108 101 184 57 171 192 95 68 228 61 167 10 0 17 145 93 106 164 41 235 70 154 122 73 81 180 108 206 113 238 218 125 78 95 185 199 194 82 129 251 51 11 80 8 226 97 60 91 3 233 42 156 231 192 171 204 207 205 148 10 16 249 104 99 250 141 56 125 253 66 79 229
	     54 135 97 102 56 7 22 4 144 207 19 149 11 68 81 68 148 171 162 173 185 137 246 166 1 62 25 239 161 175 189 142 207 246 141 240 135 3 253 10 252 69 68 62 148 115 132 42 0 68 68 118 191 203 143 22 237 210 220 42 127 249 238 10 191 254 118 158 95 126 187 192 252 220 2 165 66 72 34 87 75 50 87 67
	     232 60 34 7 81 228 129 217 70 95 0 17 249 232 19 0 206 57 60 23 39 0 32 196 115 14 23 150 41 46 47 226 133 37 82 158 71 103 87 59 71 15 76 177 127 114 140 227 7 187 105 173 243 25 111 172 81 240 47 34 242 1 81 5 128 136 200 123 96 184 177 214 13 55 214 82 151 170 181 206 134 20 157 77 57 110
	     222 157 227 202 205 7 60 120 180 72 126 126 134 40 52 72 103 176 116 6 151 76 227 225 19 61 150 228 125 122 210 215 237 112 15 135 22 22 136 188 179 96 254 185 142 201 181 91 226 143 182 229 112 95 219 45 196 97 97 137 168 92 196 74 5 92 185 64 34 149 32 147 246 233 107 239 166 175 189 137 61
	     131 157 124 118 104 47 35 195 125 28 108 79 40 240 23 17 249 16 207 43 170 0 16 17 121 191 76 207 175 216 253 133 85 110 220 201 243 237 207 231 248 235 15 191 114 238 252 37 86 87 138 144 173 197 101 115 120 217 106 32 17 39 5 112 152 69 207 157 0 216 41 172 208 153 66 228 221 37 0 158 125
	     76 186 77 255 217 70 63 16 23 95 249 119 158 135 115 134 43 23 9 243 43 184 242 42 209 202 18 205 205 117 244 245 244 240 187 99 7 56 118 104 148 241 174 58 246 247 53 43 240 23 17 249 128 169 2 64 68 228 61 51 88 159 115 131 245 57 62 235 131 182 218 180 53 103 141 142 198 12 211 15 22 121
	     184 20 48 179 176 130 45 206 129 249 88 50 13 126 2 252 196 218 18 224 103 238 17 238 109 250 92 193 191 200 187 247 98 199 164 91 223 214 207 48 8 35 172 80 132 82 145 200 65 34 157 160 171 173 157 116 178 141 253 67 109 76 14 13 240 249 209 131 252 221 222 118 5 254 34 34 31 1 85 0 136 136
	     188 231 46 220 126 104 23 238 45 112 234 202 28 223 156 188 204 183 63 157 98 238 214 77 8 13 234 235 113 169 42 252 116 14 124 15 51 35 138 136 183 14 220 49 116 120 60 216 80 47 1 145 183 56 49 171 100 234 12 192 236 249 142 73 91 43 255 175 172 243 119 14 71 136 89 136 5 37 162 133 71 176
	     184 128 87 87 75 103 79 15 191 59 186 151 161 190 86 142 76 182 209 215 82 199 254 174 22 5 255 34 34 31 9 85 0 136 136 188 231 198 186 90 220 88 87 11 3 253 145 213 213 214 144 166 200 233 26 199 204 226 10 158 159 98 165 24 16 22 151 48 231 97 126 10 231 87 182 14 92 79 2 108 77 4 43 45 44
	     178 187 216 115 222 203 1 22 25 46 42 67 84 196 35 36 145 112 36 234 171 72 54 164 25 234 235 98 98 120 136 63 124 113 128 61 99 93 28 105 75 41 240 23 17 249 200 168 2 64 68 228 3 114 230 97 193 174 76 95 231 252 205 7 92 190 126 159 233 155 247 57 125 225 42 247 111 221 135 0 168 111 130 92
	     45 184 36 56 63 14 45 54 247 7 176 181 46 225 107 103 9 247 204 0 100 253 138 165 206 39 34 175 62 49 219 161 2 224 201 9 1 183 233 99 188 181 31 65 9 91 154 135 194 18 248 17 45 173 77 76 142 12 50 49 220 195 161 201 94 186 90 234 25 233 239 102 184 65 193 191 136 200 199 72 21 0 34 34 31 144
	     201 150 140 155 108 25 99 207 196 176 93 188 118 143 31 79 94 32 73 192 175 65 145 71 11 121 44 233 48 66 44 114 24 134 57 7 206 182 132 22 10 227 69 222 157 237 137 180 167 31 143 182 246 32 28 17 94 100 120 94 68 152 130 170 76 21 245 217 36 99 3 29 124 245 233 94 62 59 60 197 31 247 168 193
	     159 136 200 199 78 21 0 34 34 31 176 127 59 127 199 174 92 187 206 175 23 239 114 122 250 30 103 175 221 227 254 189 57 40 134 144 72 65 58 131 203 100 226 45 194 88 187 146 191 41 184 112 192 19 250 5 172 197 30 206 185 199 238 162 115 139 200 235 154 169 109 58 6 43 199 149 183 126 83 68 20
	     132 80 40 64 88 134 114 137 116 77 134 230 198 58 38 135 186 216 211 223 196 104 79 19 135 246 140 241 233 72 155 130 127 17 17 81 5 128 136 200 135 236 203 241 78 247 229 120 39 253 35 11 214 121 234 42 225 191 124 199 210 220 2 171 197 60 132 33 46 242 72 145 194 128 16 15 240 48 183 214 100
	     236 89 241 130 109 252 191 109 148 46 139 200 235 205 0 108 62 178 60 172 146 0 136 0 195 179 50 129 21 193 133 224 202 52 230 106 153 26 233 231 235 207 15 115 116 111 55 61 13 62 195 13 213 58 56 69 68 68 9 0 17 145 143 197 215 67 117 174 165 102 204 170 92 129 129 246 28 183 238 45 112 227
	     222 35 238 62 156 99 101 254 33 56 15 75 101 32 153 196 37 170 192 243 54 199 248 91 2 126 20 74 136 188 181 224 127 173 43 135 115 14 207 25 22 148 9 130 18 148 86 160 84 192 165 19 52 213 228 232 235 104 166 185 174 138 209 254 54 246 79 238 225 200 161 65 246 183 84 233 104 21 17 145 173
	     103 22 149 105 138 136 124 60 206 221 159 179 7 203 5 174 220 88 224 223 126 56 195 95 190 255 149 233 179 87 226 102 127 217 90 200 86 225 87 213 18 249 169 184 218 56 220 188 235 120 252 209 173 231 6 172 178 41 185 98 12 145 55 151 0 240 0 195 249 62 190 51 172 92 32 44 44 193 226 28 172
	     44 145 106 110 96 239 248 16 191 59 178 143 125 19 61 140 245 54 113 124 164 75 7 165 136 136 236 72 21 0 34 34 31 145 137 182 6 55 209 6 191 31 234 160 181 190 218 154 171 34 190 169 77 50 183 82 230 209 74 196 98 190 68 105 101 49 222 38 48 145 130 68 18 60 15 87 137 250 149 51 22 121 211
	     42 221 56 156 171 244 210 8 193 12 91 93 37 44 23 48 103 228 114 41 26 154 58 169 77 59 134 123 219 56 60 57 194 23 159 30 224 235 61 29 10 252 69 68 228 169 84 1 32 34 242 17 251 249 226 13 251 245 198 3 166 111 46 242 253 111 87 57 125 233 26 15 174 222 128 98 0 117 245 80 83 139 159 78 227
	     249 9 194 48 194 162 184 88 192 182 172 255 87 204 33 242 106 179 177 205 193 191 225 204 225 124 15 71 68 132 17 149 67 152 125 0 11 143 32 155 163 111 207 8 199 14 142 51 57 218 201 68 127 19 67 205 181 28 236 111 215 129 40 34 34 74 0 136 136 200 179 253 122 127 201 254 229 219 203 156 56
	     115 129 95 78 158 229 209 252 34 171 161 199 106 232 8 35 112 206 35 242 83 224 37 113 184 56 230 119 174 178 12 192 3 109 30 40 242 242 209 255 122 232 30 225 136 112 145 97 97 128 179 0 44 192 247 60 146 229 60 217 4 116 117 181 241 233 39 251 249 250 203 67 28 30 109 103 184 54 169 192 95
	     68 68 148 0 16 17 145 23 115 242 206 146 61 154 153 225 196 149 187 92 190 121 159 223 206 94 229 196 185 235 44 223 123 8 145 65 83 11 174 166 30 231 124 112 126 124 173 210 162 141 109 0 68 228 197 131 127 136 203 106 92 220 238 207 185 8 74 37 162 197 121 40 174 64 88 34 89 91 205 248 80 47
	     135 15 238 229 216 84 15 99 253 45 252 126 188 71 129 191 136 136 188 48 245 0 16 17 17 0 246 119 214 56 58 107 248 122 223 0 223 94 153 177 255 90 87 67 194 66 46 38 66 230 231 86 8 147 80 142 74 152 121 224 146 128 183 30 184 136 200 203 176 56 9 96 17 68 17 68 33 102 17 206 2 82 25 159 76
	     182 134 108 26 186 90 26 248 195 231 7 248 111 254 112 156 47 199 27 117 196 137 136 200 75 83 5 128 136 136 236 232 167 107 15 236 226 244 117 78 95 125 192 183 103 239 114 245 250 45 174 223 120 0 65 24 39 0 210 25 92 85 14 231 123 149 32 166 178 41 128 94 58 145 39 79 188 42 199 136 135 197
	     13 254 241 136 202 101 40 174 66 126 21 74 69 168 205 50 60 208 197 216 96 47 83 125 117 244 182 212 112 120 98 132 163 163 106 242 39 34 34 175 70 21 0 34 34 178 163 195 253 173 238 112 127 43 39 238 46 88 123 239 61 254 229 207 223 179 50 191 68 177 80 160 84 12 8 93 137 40 74 224 240 226
	     211 137 243 48 87 217 182 204 85 82 1 106 16 40 178 37 248 119 56 214 58 251 19 70 56 192 143 74 56 2 18 73 35 153 112 212 53 103 57 182 127 140 207 14 31 224 211 177 6 26 115 73 6 234 115 58 152 68 68 68 9 0 17 17 121 179 14 116 212 185 3 29 117 116 100 34 235 107 173 102 102 62 207 217 233
	     219 220 159 91 224 254 131 57 194 32 132 100 22 151 74 227 146 105 240 60 214 171 203 214 66 22 123 60 16 218 78 149 3 242 97 132 248 59 253 85 187 77 31 12 44 36 10 202 80 88 133 82 158 100 38 69 123 115 3 125 157 253 244 119 214 49 216 211 204 103 7 166 24 29 27 96 48 171 69 54 34 34 162 4 128
	     136 136 188 101 255 233 119 19 174 185 185 214 30 60 202 83 87 123 142 83 23 46 179 124 255 33 171 165 60 145 231 97 161 135 37 18 120 248 132 149 34 103 156 219 20 7 217 206 97 82 229 62 111 100 73 154 219 246 156 59 85 36 60 207 125 100 247 196 212 91 255 148 222 126 44 31 255 177 110 249
	     219 221 120 128 219 246 0 183 237 105 226 202 24 11 67 92 20 224 74 171 120 171 75 228 178 245 244 181 55 241 197 39 147 28 63 52 64 87 83 150 67 253 157 250 67 20 17 17 37 0 68 68 228 221 249 122 162 203 1 212 231 210 54 209 89 67 123 109 146 155 51 139 220 153 47 49 179 148 167 88 42 16 150
	     10 224 39 192 79 226 60 15 231 124 12 195 182 133 66 238 45 199 115 34 111 147 195 197 235 252 137 42 65 127 68 20 22 177 176 140 159 240 168 206 166 104 110 237 166 62 235 49 214 219 194 225 169 9 142 30 158 228 243 225 22 5 254 34 34 162 4 128 136 136 236 30 131 93 13 116 228 70 168 110 202
	     113 225 214 2 127 253 121 154 135 231 174 16 206 61 130 66 9 106 235 32 155 195 37 83 120 9 159 200 185 245 40 127 243 170 128 184 34 90 225 191 188 111 209 253 51 202 18 172 82 15 80 41 10 136 162 136 168 92 130 249 89 88 93 34 172 173 33 145 237 96 124 100 144 201 177 46 14 14 52 51 216 217
	     68 75 75 181 94 91 17 17 121 179 167 48 237 2 32 34 34 175 226 244 76 193 254 183 191 158 229 251 95 78 51 61 125 149 219 15 30 17 122 73 86 74 17 17 30 101 75 224 60 15 188 36 224 111 73 1 216 206 225 211 235 60 203 109 139 209 180 4 224 253 155 169 60 61 214 126 107 63 215 158 239 65 113 204
	     111 56 11 33 10 112 22 145 240 66 146 24 190 5 164 189 136 222 238 86 70 6 251 249 227 151 71 57 182 191 135 137 134 140 254 232 68 68 68 9 0 17 17 121 63 124 115 245 145 221 185 125 151 203 55 239 241 195 185 27 92 190 122 155 83 231 175 195 234 42 4 17 212 52 64 117 35 46 153 198 185 120 219
	     192 136 224 197 2 172 205 231 171 205 87 96 183 159 199 156 98 41 121 75 121 8 219 252 55 231 192 57 28 14 231 140 168 184 10 75 115 144 95 1 23 145 107 172 103 207 88 63 195 189 93 28 157 236 160 163 189 153 201 161 126 166 218 213 221 95 68 68 148 0 16 17 145 247 212 255 250 219 109 251 183
	     191 253 204 127 249 203 207 204 60 154 99 230 209 10 84 213 16 36 170 137 188 4 145 197 9 0 188 104 107 220 255 172 43 239 74 0 200 59 230 61 246 39 89 169 98 89 255 155 243 128 8 231 25 201 176 136 87 88 38 109 33 245 181 41 6 122 59 248 167 175 143 115 248 192 36 95 143 55 232 143 84 68 68
	     222 9 245 0 16 17 145 215 234 223 239 235 114 105 74 86 83 95 197 189 71 75 252 124 246 46 247 30 46 112 237 230 12 172 230 193 121 144 174 130 92 21 126 50 65 100 113 131 64 199 75 86 118 43 224 151 55 204 85 254 206 214 254 210 34 91 235 240 111 27 235 252 203 101 40 151 33 191 138 21 11 148
	     106 50 180 183 55 177 167 175 131 253 35 109 244 119 212 241 213 129 113 246 13 42 248 23 17 17 37 0 68 68 228 3 242 199 125 3 110 176 187 217 230 138 1 163 195 51 156 60 117 158 63 7 191 50 251 176 204 106 177 76 228 149 241 92 170 210 8 208 48 139 123 3 132 143 93 99 21 217 61 73 128 141 36
	     149 225 92 132 71 132 231 192 204 145 112 101 112 69 252 116 0 22 210 209 94 199 209 195 251 248 253 177 73 190 152 108 99 170 189 78 129 191 136 136 40 1 32 34 34 31 166 193 198 26 7 80 157 109 176 225 230 52 109 181 62 215 238 61 226 252 213 187 92 187 245 144 149 165 5 202 165 34 46 157 133
	     100 22 146 41 60 63 81 185 186 186 221 179 107 3 94 186 130 64 228 153 127 89 96 56 34 192 185 120 123 191 48 44 67 185 68 88 92 197 74 101 18 153 4 85 153 36 67 131 157 180 55 215 114 112 180 159 79 15 236 99 207 158 94 70 106 60 5 255 34 34 178 59 206 106 234 1 32 34 34 111 195 233 91 51 118
	     127 169 196 95 126 184 194 191 126 251 43 231 206 95 96 118 102 14 47 87 71 148 204 65 186 10 75 164 48 115 149 101 253 198 198 102 129 207 151 0 88 143 178 156 139 31 189 246 60 238 133 114 9 175 51 110 124 251 63 247 61 10 171 119 122 137 108 87 254 166 172 55 250 115 14 60 66 92 169 0 229
	     2 94 126 17 43 21 105 108 107 164 171 173 133 63 253 110 63 159 30 30 101 188 173 129 241 158 86 5 254 34 34 178 171 168 2 64 68 68 222 138 169 238 102 55 5 52 100 171 173 185 198 231 187 142 44 167 174 220 99 181 96 220 121 184 68 169 156 39 44 172 226 252 20 248 41 240 29 206 115 96 238 185
	     130 66 99 231 78 237 34 175 22 254 27 70 20 55 169 12 66 172 84 32 10 75 36 18 80 93 149 166 171 167 151 234 108 138 131 195 29 116 119 180 241 213 103 123 57 62 214 165 63 69 17 17 81 2 64 68 68 228 80 95 173 171 74 141 91 79 127 11 67 23 31 114 225 226 45 10 63 157 101 118 238 17 209 226 50
	     100 114 184 76 22 92 10 207 247 49 108 163 219 250 122 57 246 243 164 3 68 94 38 226 175 52 248 179 184 212 223 185 56 1 96 17 16 20 176 165 57 92 185 136 95 95 67 107 67 11 191 251 116 47 35 3 109 28 25 106 161 54 151 101 223 64 187 130 127 17 17 217 197 167 57 45 1 16 17 145 119 228 228 108
	     104 191 157 154 230 207 63 156 224 246 221 7 92 184 118 143 98 100 44 173 148 40 5 33 129 121 224 18 144 72 98 206 175 132 246 79 174 8 240 54 133 255 91 238 243 46 150 0 200 211 39 32 236 210 37 0 46 254 13 60 115 120 97 8 148 112 22 224 204 72 39 60 146 46 162 190 38 195 120 111 59 195 253
	     61 252 187 175 15 51 62 210 197 64 86 5 40 34 34 178 251 169 2 64 68 68 222 153 253 77 190 75 142 183 91 109 110 63 247 102 151 248 229 204 45 174 223 185 207 201 179 151 88 153 155 35 42 148 33 157 131 218 70 188 164 23 111 33 232 188 202 226 126 123 44 168 183 45 95 186 199 191 241 156 129
	     233 78 148 55 120 189 236 117 189 198 110 219 35 205 61 231 187 106 79 248 158 3 34 0 130 160 4 43 243 184 168 8 22 210 208 222 202 228 200 32 251 198 250 217 63 209 69 107 67 53 255 184 95 229 254 34 34 162 4 128 136 136 200 115 217 211 94 227 246 180 215 0 240 95 186 123 236 244 185 75 164
	     173 200 133 42 159 59 51 75 148 44 65 50 233 40 18 17 97 88 100 235 101 218 219 3 188 141 48 208 123 165 176 114 123 68 23 233 109 122 107 73 128 55 231 73 101 32 91 127 11 103 17 158 139 112 64 38 9 165 108 138 250 76 21 213 25 199 190 145 94 126 255 217 33 142 29 158 224 248 128 182 245 19
	     17 17 37 0 68 68 68 94 218 223 79 181 186 218 116 104 233 52 12 92 239 227 183 75 119 185 124 235 1 51 179 243 148 23 86 32 153 132 84 26 50 89 188 68 2 162 8 28 152 171 4 252 22 39 6 204 109 138 205 222 193 82 55 247 206 131 93 121 122 218 193 54 189 71 134 115 142 200 128 82 1 43 23 9 75 5 40
	     151 241 235 171 105 109 106 230 224 68 47 3 29 53 236 239 111 229 208 212 16 135 20 252 139 136 200 123 74 61 0 68 68 100 87 250 230 230 170 253 120 234 54 223 253 114 138 19 167 206 114 253 214 29 202 230 8 92 130 116 174 26 243 146 88 100 149 158 0 113 179 192 56 202 118 235 9 129 248 182
	     23 187 126 191 211 218 244 23 173 0 240 118 12 57 229 205 204 100 224 249 150 0 184 77 193 255 70 2 192 57 112 158 195 183 8 202 5 130 160 64 34 10 8 75 69 70 135 250 216 51 62 206 191 251 253 81 246 142 53 113 180 35 167 192 95 68 68 222 107 170 0 16 17 145 93 233 120 79 214 213 102 6 172 189
	     198 209 219 146 226 244 165 102 110 222 157 229 242 141 251 228 31 61 196 149 35 44 93 5 153 28 94 42 131 243 227 83 90 100 182 115 228 189 41 116 115 155 42 4 118 74 132 219 14 225 227 139 4 240 10 246 95 83 108 191 249 125 130 184 226 99 235 29 54 190 185 126 95 219 250 6 184 199 151 138 56
	     47 238 35 17 69 33 20 242 80 88 33 136 2 252 180 79 67 109 142 193 238 78 106 178 105 142 78 13 49 62 50 202 241 3 157 12 215 39 20 252 139 136 136 18 0 34 34 34 111 202 84 75 194 77 181 12 51 57 220 108 103 174 206 240 253 47 151 241 194 31 185 116 101 154 213 252 50 36 60 60 203 224 59 195
	     60 7 17 120 182 182 111 251 90 112 255 164 102 111 111 46 120 87 2 224 45 218 94 94 97 79 190 163 91 203 7 56 135 231 0 51 204 133 88 105 9 44 160 181 185 149 177 129 78 190 62 126 128 254 158 54 14 141 183 49 213 222 168 192 95 68 68 148 0 16 17 17 121 107 137 128 142 122 55 213 81 79 115 77
	     206 170 83 33 167 186 106 185 120 107 150 213 32 193 253 249 85 242 139 115 120 33 88 42 131 165 171 112 190 135 3 60 183 86 17 240 132 24 206 108 163 71 128 83 156 247 110 3 249 109 239 131 217 214 247 100 237 235 23 90 186 88 185 226 79 132 153 197 185 130 32 192 149 74 132 81 25 195 168 174
	     169 162 190 177 155 206 198 44 251 71 187 25 29 232 229 247 71 247 114 100 160 73 127 16 34 34 242 193 81 15 0 17 17 121 175 156 186 53 99 215 231 150 56 123 101 150 243 151 239 243 151 31 79 115 249 194 121 88 88 134 218 70 252 198 102 92 34 185 30 60 154 25 209 150 85 223 219 170 197 149 0 216
	     181 9 128 45 125 251 55 191 105 219 2 252 29 159 135 120 9 129 115 113 2 0 34 156 65 80 42 194 252 35 8 75 144 73 51 57 49 194 145 3 19 28 156 236 227 208 120 11 141 217 52 123 90 27 244 199 32 34 34 74 0 136 136 136 236 22 151 150 35 59 121 254 30 127 254 230 23 190 63 113 154 27 183 238 145
	     47 65 224 146 20 138 65 28 72 38 82 144 76 97 46 177 17 64 110 63 239 41 1 176 107 19 0 91 103 44 16 183 87 124 210 188 165 210 169 97 211 251 232 204 32 44 227 130 34 88 25 231 28 153 148 143 149 139 52 213 229 232 106 109 224 248 161 41 126 119 252 19 246 142 180 49 148 67 127 4 34 34 162
	     4 128 136 136 200 110 245 221 149 123 118 229 230 60 191 156 187 201 47 167 207 114 230 194 52 15 239 206 198 193 98 166 26 234 26 113 137 116 37 1 224 136 247 123 91 59 247 173 53 140 179 87 74 0 108 127 164 206 172 111 50 1 176 227 131 55 222 5 231 85 174 250 59 136 2 162 252 50 172 204 131
	     43 67 194 99 168 187 157 174 246 118 142 76 141 178 103 164 131 61 3 173 28 27 110 87 224 47 34 34 31 5 245 0 16 17 145 247 218 177 161 118 119 108 168 157 225 190 30 107 169 75 145 241 3 206 101 18 204 45 150 200 135 142 40 10 177 114 1 240 226 237 1 125 127 135 192 242 213 227 63 167 4 192
	     43 190 128 238 233 95 175 191 178 59 109 178 184 41 9 96 17 46 138 32 10 193 2 124 63 34 153 203 208 80 91 71 99 109 154 3 99 3 236 29 31 227 243 67 123 248 98 76 13 254 68 68 228 35 59 221 170 2 64 68 68 62 20 39 111 62 178 211 87 174 113 225 218 44 167 47 207 112 118 250 6 215 110 63 160 184
	     184 2 206 135 84 18 151 171 198 75 164 32 178 245 93 225 95 53 104 119 219 18 0 145 222 138 55 200 219 242 186 175 109 3 224 121 96 24 81 169 12 229 34 172 174 128 103 212 55 215 209 223 217 198 39 19 253 12 118 213 177 119 168 157 193 206 118 38 123 20 252 139 136 200 199 71 21 0 34 34 242
	     193 216 223 211 232 246 247 52 242 195 173 21 107 235 188 71 46 151 193 133 121 110 185 50 165 82 68 72 8 97 49 222 54 16 143 200 60 240 188 74 24 169 120 240 125 18 39 93 42 203 57 44 196 133 134 71 136 69 37 124 23 226 165 29 217 108 138 137 222 54 14 238 221 195 239 142 236 97 180 167 142
	     67 93 181 122 163 69 68 68 9 0 17 17 145 15 197 209 238 156 171 175 238 183 222 90 199 72 119 134 27 183 231 184 122 115 150 43 119 238 115 251 222 44 165 249 34 164 171 112 85 53 120 46 13 222 166 211 161 109 4 152 241 151 246 196 0 116 243 231 246 148 175 229 117 170 44 3 112 128 69 152 133
	     88 80 34 90 89 128 160 132 151 78 210 215 213 202 96 247 16 253 221 77 236 29 233 101 108 160 143 63 237 239 82 224 47 34 34 74 0 232 37 16 17 145 15 209 104 189 239 70 143 13 210 209 89 109 247 102 86 249 225 212 85 188 159 224 225 253 7 4 43 75 113 0 153 174 2 75 130 3 103 107 193 190 139
	     175 46 187 74 140 105 143 151 244 111 47 249 55 183 67 154 192 20 111 190 148 39 118 84 220 182 200 194 85 118 4 48 3 43 195 234 18 4 69 170 170 26 24 234 108 225 119 159 238 103 223 68 47 195 157 245 236 105 211 85 127 17 17 17 37 0 68 68 228 131 119 184 183 213 209 11 237 245 213 214 85 159
	     166 181 46 205 133 27 247 152 93 42 51 179 88 100 121 117 41 142 240 83 105 72 167 241 240 113 110 167 150 126 138 33 223 77 54 192 182 172 245 7 195 202 33 86 46 98 132 224 67 99 117 138 170 154 46 58 155 107 24 235 109 229 179 131 123 248 226 211 41 246 117 214 233 77 19 17 17 81 2 64 68 68
	     62 186 68 192 96 179 171 173 194 218 186 90 56 117 109 150 159 79 92 225 155 159 207 179 124 239 62 228 87 161 182 9 18 13 120 9 7 158 23 135 157 22 135 160 30 16 109 222 106 78 94 79 120 191 41 209 178 181 41 177 219 182 196 194 225 156 197 247 143 34 130 114 30 22 231 33 42 67 85 134 186 182
	     110 246 140 13 114 236 224 56 251 6 27 232 111 173 85 240 47 34 34 178 211 185 87 187 0 136 136 200 199 102 122 185 100 127 57 113 139 127 249 243 143 156 187 116 133 91 119 30 176 26 64 222 124 130 48 34 50 31 252 4 206 79 225 42 201 128 8 183 101 113 191 219 122 54 213 18 128 215 149 0 112
	     0 30 142 141 128 223 162 0 194 50 132 1 158 139 72 123 80 149 128 166 250 44 237 45 13 236 27 27 224 232 209 131 124 190 167 139 193 250 164 94 120 17 17 17 37 0 68 68 68 54 156 155 45 216 213 91 119 184 113 103 150 111 78 222 230 220 197 11 156 58 123 133 226 194 50 68 30 84 229 240 26 154
	     240 210 85 68 6 145 109 138 254 13 182 180 249 115 59 156 75 149 0 120 153 105 73 229 131 23 95 241 247 226 117 254 81 126 17 150 23 97 105 9 60 104 234 106 99 239 158 17 62 153 26 98 172 191 133 129 206 122 134 186 58 25 104 72 233 69 23 17 17 81 2 64 68 68 228 201 254 229 210 172 253 245 111
	     191 242 95 255 250 61 119 31 206 51 191 80 98 181 236 40 37 83 132 46 65 228 60 240 124 112 126 220 29 80 9 128 55 52 43 113 113 83 191 74 115 63 103 33 16 225 133 37 210 132 84 123 33 245 53 105 246 78 12 242 199 207 63 229 232 193 17 14 117 87 235 133 22 17 17 121 78 234 1 32 34 34 31 189
	     175 71 154 92 189 183 215 218 91 115 204 46 21 248 245 194 12 167 46 222 228 220 133 43 176 176 8 217 44 228 170 33 147 197 75 166 33 50 204 92 101 215 0 37 210 95 94 165 175 66 101 23 134 181 21 1 81 185 4 197 34 182 188 0 165 2 97 67 3 61 195 253 124 50 209 203 158 193 70 246 244 181 112 96
	     176 159 129 54 5 255 34 34 34 74 0 136 136 136 188 160 131 67 109 238 224 80 27 0 255 159 31 239 91 107 243 105 162 213 121 238 187 34 65 194 167 228 69 132 81 9 43 27 230 60 192 91 95 195 174 20 192 75 114 241 171 231 0 103 17 4 33 88 68 34 42 147 240 35 188 180 35 145 78 209 211 223 202 239
	     62 221 207 63 124 49 197 127 127 160 77 65 191 136 136 136 18 0 34 34 34 175 199 127 60 210 230 186 234 60 235 174 143 56 123 253 30 215 110 205 113 225 234 93 102 102 231 136 86 138 80 149 131 170 106 72 166 113 137 100 220 27 112 125 73 221 235 171 10 216 30 233 238 190 68 195 179 182 75 124
	     202 111 236 109 236 175 64 20 17 21 243 176 60 15 97 153 68 117 142 182 150 70 122 187 250 232 238 104 228 200 120 31 251 247 78 240 135 241 22 5 255 34 34 34 74 0 136 136 136 188 94 159 141 182 184 150 218 79 236 216 92 158 191 253 122 13 23 253 196 165 226 50 143 150 23 49 82 4 22 18 69 33
	     46 242 137 119 12 116 56 219 216 181 254 133 163 251 109 241 178 123 194 67 118 79 18 96 219 111 184 214 243 96 189 179 191 237 252 239 115 107 255 144 181 134 138 17 70 136 111 1 94 88 32 229 34 154 235 171 152 24 236 224 235 227 7 57 56 222 195 96 91 53 67 173 218 214 79 68 68 228 149 207
	     222 106 2 40 34 34 242 116 167 238 46 219 183 63 158 226 252 229 107 252 60 125 151 197 149 144 27 247 151 89 88 201 19 230 75 241 150 129 153 42 92 194 195 240 112 184 103 215 1 60 71 2 96 167 10 128 221 149 0 216 244 27 174 111 227 231 118 252 109 221 218 125 42 13 19 45 8 160 92 132 160 12
	     9 143 250 218 12 93 77 57 250 219 26 216 63 220 206 96 95 47 159 31 153 98 188 57 163 192 95 68 68 228 53 81 5 128 136 136 200 51 236 237 168 118 222 225 81 27 29 234 160 235 218 35 46 93 189 79 254 219 51 172 174 46 194 226 12 150 174 130 132 195 249 105 156 51 112 126 92 9 96 59 92 179 127
	     44 80 222 125 220 182 223 237 185 46 22 56 247 148 20 69 37 37 226 108 61 53 98 229 2 172 44 225 5 37 188 170 52 173 117 45 124 121 236 32 135 39 250 153 236 169 38 155 173 82 240 47 34 34 242 186 207 241 170 0 16 17 17 121 49 255 251 217 7 246 95 255 122 130 235 55 111 113 242 252 85 86 242
	     101 86 139 17 133 114 64 96 30 161 75 226 18 41 204 37 42 59 5 236 144 0 240 118 136 109 119 73 5 192 243 37 0 158 231 55 140 147 2 14 195 69 1 46 10 113 81 9 103 33 153 164 79 77 54 77 107 67 53 157 205 181 76 141 14 240 143 127 56 202 87 163 205 10 250 69 68 68 222 16 85 0 136 136 136 188
	     160 145 142 58 202 71 70 153 29 237 164 169 177 133 139 211 55 57 113 246 18 133 135 51 128 15 233 44 86 91 135 75 37 43 235 222 189 141 253 237 215 174 148 219 246 181 242 219 27 0 184 29 162 253 231 137 141 95 61 69 240 124 23 7 108 135 47 55 39 55 188 248 247 245 34 136 194 184 201 95 41 15
	     43 203 80 42 146 235 106 99 164 127 136 227 7 71 25 233 107 161 179 169 90 193 191 136 136 136 18 0 34 34 34 187 203 80 67 218 13 53 244 199 201 128 238 110 59 113 230 18 245 105 227 226 213 42 30 45 151 152 47 68 152 15 197 168 136 135 35 50 31 156 219 214 31 223 158 18 84 63 45 14 126 86 140
	     252 54 43 251 172 242 27 109 186 242 239 92 37 191 17 197 55 133 101 28 33 85 25 143 68 85 150 234 198 52 41 23 114 96 98 132 191 251 234 8 127 248 116 130 61 109 57 5 254 34 34 34 74 0 136 136 136 236 110 159 15 215 187 154 196 128 101 146 33 35 183 135 56 59 253 144 31 207 77 243 224 222 67
	     108 126 25 75 167 33 149 129 116 21 100 50 56 207 109 186 250 207 150 94 0 91 147 2 6 236 194 184 120 189 135 65 188 178 127 203 190 7 206 129 231 136 194 16 74 69 88 45 194 202 34 145 11 41 55 53 210 218 218 196 193 209 78 58 59 106 248 116 184 139 189 19 3 10 254 69 68 68 148 0 16 17 17 121
	     127 236 235 111 118 251 250 155 57 63 183 98 63 93 124 68 67 93 13 39 78 158 226 234 181 50 94 58 69 41 114 120 137 144 136 50 134 35 114 30 145 185 202 50 122 63 190 98 206 110 234 240 255 108 174 18 248 187 245 198 126 14 71 136 25 36 93 128 243 67 168 50 156 159 160 42 149 98 108 188 135
	     177 225 65 254 241 247 159 176 119 176 150 137 150 90 5 254 34 34 34 74 0 136 136 136 188 159 198 27 114 206 159 204 88 54 42 49 214 153 225 215 203 29 44 174 148 184 48 125 143 249 133 69 22 31 204 64 20 66 34 5 201 52 164 115 144 206 224 60 63 78 4 176 209 23 192 112 155 190 172 108 157 247
	     216 79 92 171 18 88 187 99 244 146 209 252 246 245 252 110 61 204 127 252 190 14 231 226 70 129 81 24 66 24 64 177 16 111 231 87 42 66 33 79 144 242 72 215 87 211 221 214 200 64 247 48 173 13 53 28 158 26 160 179 163 139 255 199 167 221 10 252 69 68 68 222 17 237 2 32 34 34 242 134 252 117 250
	     158 93 190 58 195 63 127 115 146 203 211 55 56 119 238 50 133 82 145 200 37 177 68 6 210 213 144 202 16 122 62 230 37 214 43 1 112 241 39 107 93 3 204 108 83 244 191 189 203 254 246 4 192 75 156 215 159 148 0 168 172 231 95 95 166 224 54 250 19 130 195 139 202 56 11 160 84 192 5 37 92 57 79 184
	     188 76 77 93 142 193 161 30 142 236 31 227 15 159 31 162 187 189 129 227 131 45 10 252 69 68 68 148 0 16 17 17 249 176 253 231 191 156 177 155 55 110 243 203 165 107 204 45 149 120 176 80 226 209 82 145 185 229 2 115 11 43 80 42 65 16 130 159 4 223 3 223 7 47 1 158 31 119 212 247 214 58 234
	     123 108 237 13 176 22 252 175 221 254 26 19 0 22 197 149 7 97 8 97 229 243 40 140 255 11 130 248 191 116 18 87 149 166 177 46 75 54 153 160 185 54 69 77 198 49 208 86 199 212 64 55 227 227 3 252 55 71 199 21 248 139 136 136 40 1 32 34 34 242 113 249 219 229 155 54 187 108 156 185 50 207 165
	     235 119 57 119 249 42 231 46 93 37 191 176 64 105 105 5 151 78 99 158 15 137 20 46 145 194 156 95 73 6 120 184 181 143 149 213 247 246 166 19 0 81 0 81 132 11 131 56 1 16 6 241 109 65 128 21 86 161 92 34 221 88 79 109 75 19 123 70 7 105 174 175 99 114 184 147 137 145 102 134 27 51 28 30 82 169
	     191 136 136 136 18 0 34 34 34 31 185 83 51 216 229 27 247 185 112 233 10 23 46 93 225 193 252 2 247 231 87 8 73 176 92 44 19 134 80 44 199 113 119 41 136 40 135 17 65 229 191 200 226 139 241 230 60 182 150 255 195 75 183 18 92 79 0 108 84 23 164 42 5 7 217 100 130 100 210 39 149 244 72 37 28
	     73 103 164 188 0 207 51 250 90 27 104 109 106 102 98 108 144 198 250 6 198 71 58 249 180 179 74 129 191 136 136 136 18 0 34 34 34 178 37 17 112 235 145 45 46 46 178 84 40 113 111 169 204 163 197 144 219 51 11 44 44 46 243 96 110 153 213 66 153 185 197 2 115 203 43 44 46 229 89 90 205 19 68 33
	     22 130 249 107 125 124 29 175 188 127 128 3 136 192 34 124 231 129 131 154 76 154 76 42 65 123 99 61 13 117 213 180 52 85 211 88 157 165 166 42 65 119 107 150 150 218 20 157 53 85 164 50 25 234 234 107 73 166 50 140 52 101 20 252 139 136 136 236 98 218 5 64 68 68 228 29 217 219 221 232 160 113
	     253 235 19 115 216 197 27 115 220 191 255 144 235 119 30 50 183 84 32 153 94 196 156 163 88 10 88 206 23 54 26 5 174 123 77 137 124 139 11 1 92 165 26 32 157 246 201 85 101 104 105 108 160 179 173 145 254 174 102 58 154 235 105 174 203 178 119 184 137 209 90 167 96 95 68 68 228 61 227 233 37
	     16 17 17 217 29 82 73 35 153 72 144 240 125 60 231 112 158 23 127 172 252 247 182 56 168 236 4 224 240 60 240 156 195 247 125 252 132 79 34 233 43 248 23 17 17 121 79 105 9 128 136 136 136 136 136 136 200 71 64 21 0 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 136 18 0 34 34 34 34 34
	     34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 136 18 0 34 34 34 34 34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 34 74 0 136 136 136 136 136
	     136 136 136 18 0 34 34 34 34 34 34 34 162 4 128 136 136 136 136 136 136 136 40 1 32 34 34 34 34 34 34 34 74 0 136 136 136 136 136 136 136 200 78 254 111 176 186 140 93 188 94 147 134 0 0 0 0 73 69 78 68 174 66 96 130 ]
]

{ #category : #sass }
CPPSLibrary >> dashboardSass [
	^ '@import "variables"

.dashboard
  display: flex
  flex-flow: row wrap
  height: 100%

  .metrics
    +flex(1 100%)
    +displayFlex
    background-color: $grey200
    height: 110px
    overflow:
      x: auto
      y: hidden

    .metricComponent
      +border-radius(4px)
      +flex(1)
      background-color: $white
      height: 80px
      cursor: pointer
      min-width: 220px
      margin: 10px

      .icon
        +border-radius(4px 0 0 4px)
        +box(35%, 100%)
        float: left
        display: table

        i
          +font-size(24)
          color: #FFF
          display: table-cell
          vertical-align: middle

      .value
        width: 65%
        color: $blueGrey200
        display: inline-block
        position: relative

        .metricVal
          +font-size(16)
          font-weight: 300
          display: block

        .label
          +abs-pos(0, 0, 0, 0)
          +font-size(12)
          +line-height(20)
          width: 100%


      .icon, .value
        text-align: center

      &:hover
        .danger
          @extend .dangerHighlight

        .warning
          @extend .warningHighlight

        .healthy
          @extend .healthyHighlight

        .highAttention
          @extend .highAttentionHighlight

        .attention
          @extend .attentionHighlight

        .lowAttention
          @extend .lowAttentionHighlight

    .metricComponent.mdl-shadow--4dp
      height: 90px

  #dashboard_graphs
    +box(100%, calc(100% - 110px))
    +displayFlex
    flex-wrap: wrap
    justify-content: space-around
    overflow-y: auto

    .chartJsChart
      margin:
        top: 10px
      width: 44%
      text-align: center

      .mdl-alert
        margin-top: 50px !important

    .ChartBoxPlot .chartJsGraph
      width: 55%

    .ChartBoxPlot .chartJsLegend, .ChartPie .chartJsLegend
      width: 45%

  #dashboard_graphs.numberOfLinesOfCode
    .ChartBoxPlot
      width: 30%

      .chartJsGraph
        width: 80%

    .ChartBoxPlot
      .chartJsLegend
        display: none


// TODO: This should be removed and we should use mixins to manage media queries
@media screen and (max-width: 1500px)
  .metricComponent .label
    //+font-size(10)mponent .label
    +font-size(10)'
]

{ #category : #sass }
CPPSLibrary >> duplicationSass [
	^ '@import "variables"

.duplication
  +box
  +displayFlex

  .titledComponent
    border-bottom: 2px solid $borderColor

  .duplicated, .containers
    +box(100%, 50%)

  .containers
    overflow-x: auto

    table
      width: 100%
      max-height: calc( 100% - 36px )
      border: 0
      overflow: hidden

      &:hover
        overflow: auto

  .duplication-actionButtons
    +displayFlex
    justify-content: space-around

  #duplication-content
    .code-container
      .code-container-panel
        +box(97%, 100%)

        .code-container-panel__content
          height: 100%

      .duplicated
        color: $red

        .token
          color: $red

    .duplication-content__clones
      +box(100%)
      padding: 0
      display: flex
      justify-content: space-between

    .duplication-content__visu-fragment
      +box(100%)
      +displayFlex

      .chartJsChart
        width: 50%
        margin: auto

      .chartJsGraph
        width: 100%

  .message
    +border-radius(10px)
    +font-size(18)
    padding:
      top: 50px
      bottom: 50px
    background: rgb(237, 237, 237) none repeat scroll 0 0
    min-width: 200px
    margin: auto
    width: 50%
'
]

{ #category : #sass }
CPPSLibrary >> libraryAdaptorSass [
	^ '@import "variables"

// MDL

.mdl-list__item-secondary-info
  white-space: nowrap
  width: 120px
  overflow: hidden
  text:
    overflow: ellipsis
    align: right

.mdl-layout__header
  background: $primaryColorMuchDarker

.mdl-checkbox, .mdl-radio
  margin-bottom: 20px

table .mdl-checkbox, table .mdl-radio
  margin-bottom: initial

.mdl-snackbar
  z-index: 99999999

.mdl-button--accent.mdl-button--raised, .mdl-button--accent.mdl-button--fab
  color: white !important

.mdl-button.mdl-button-small
  height: 28px
  padding: 0 8px
  line-height: 28px

.mdl-data-table th
  color: $primaryColor
  background-color: $headerBackgroundColor

.mdl-badge[data-badge]:after
  +border-radius(2px)
  font-size: 10px
  height: 16px
  color: $white
  top: -8px

.mdl-badge-medium[data-badge]:after
  width: 34px
  right: -36px

.mdl-badge-large[data-badge]:after
  width: 44px
  right: -46px

.mdl-tabs__tab:hover
  color: #000

.mdl-layout__header-row .mdl-navigation__link
  text-align: center
  line-height: initial

.mdl-slider-container label
  color: $primaryColor

.mdl-button.mdl-button--accent.mdl-button--raised.mdl-button-danger,.mdl-button.mdl-button--accent.mdl-button-danger
  color: $white
  background-color: $red

.mdl-card__title
  text-transform: capitalize

.mdl-tooltip
  width: initial
  max-width: initial
  text-align: justify

.mdl-textfield__input[type="number"]
  appearance: initial
  -moz-appearance: initial // Firefox
  -webkit-appearance: initial // Safari and Chrome

.mdl-textfield.compact
  padding: 0

.mdl-textfield--expandable
  text-align: center

.mdl-tabs__panel
  position: relative

.mdl-chip
  +css3(user-select, none)


i.list-tag-icon
  vertical-align: middle
  cursor: pointer
  padding-right: 0
  margin: 0
  text-shadow: 1px 1px 1px rgba(0,0,0,0.2), -1px -1px 1px rgba(0,0,0,0.1)
  color: $white

i.list-tag-icon.rainbow
  color: transparent
  -webkit-background-clip: text
  background-clip: text


.chartJsChart
  h3
    font-size: 16px
    font-weight: 300
    letter-spacing: 0.5px
    line-height: 20px


// Nested list

.expList
  .itemContener.isSelected
    background-color: $accentColorMuchLighter !important

    &:hover
      background-color: $accentColorLighter !important

  li:hover
    z-index: 1000

  li:nth-child(2n)
    background-color: #F5F5F5

    &:hover
      background-color: #E0E0E0

  .mdl-chip__contact
    width: 24px
    height: 24px
    font-size: 12px
    line-height: 24px
    margin-left: 5px
    border-radius: 3px

.nestedList.altCompact
  .listContainer
    a
      font-size: 13px
      font-weight: inherit

  .expList
    li
      .item
        line-height: 24px

    .icon
      height: 24px

    img
      height: 20px
      width: 20px

  .mdl-chip__contact
    width: 16px
    height: 16px
    font-size: 9px
    line-height: 16px
    margin-left: 5px
    border-radius: 2px

.mdl-table-compact tbody tr
  height: 38px

  td
    height: 38px
    padding: 3px 6px

// Telescope
.telescopeVisu
  .tlLegend
    background-color: $white
    right: 5px
    left: initial
    border: 1px solid $borderColor
    padding: 10px

  .fitButton
    left: 5px

    a
      +border-radius(2px)
      min-width: 64px
      padding: 0 16px
      text-transform: uppercase
      will-change: box-shadow
      transition: box-shadow .2s cubic-bezier(.4,0,1,1),background-color .2s cubic-bezier(.4,0,.2,1),color .2s cubic-bezier(.4,0,.2,1)
      text-align: center

      &:hover
        background-color: rgba(158,158,158,.2)

    img
      +box(24px)
      +border-radius(10px)
      padding: 5px

      &:hover
        background-color: rgba(158,158,158,.2)

  .tlLegendIcon
    width: 30px

// Prism
.prismComponent
  min-height: 100px

  a
    color: $red
    text-decoration: none
    font-weight: bold
'
]

{ #category : #mdl }
CPPSLibrary >> materialindigoorangeminCss [

	^ '/**
 * material-design-lite - Material Design Components in CSS, JS and HTML
 * @version v1.3.0
 * @license Apache-2.0
 * @copyright 2015 Google, Inc.
 * @link https://github.com/google/material-design-lite
 */
@charset "UTF-8";html{color:rgba(0,0,0,.87)}::-moz-selection{background:#b3d4fc;text-shadow:none}::selection{background:#b3d4fc;text-shadow:none}hr{display:block;height:1px;border:0;border-top:1px solid #ccc;margin:1em 0;padding:0}audio,canvas,iframe,img,svg,video{vertical-align:middle}fieldset{border:0;margin:0;padding:0}textarea{resize:vertical}.browserupgrade{margin:.2em 0;background:#ccc;color:#000;padding:.2em 0}.hidden{display:none!important}.visuallyhidden{border:0;clip:rect(0 0 0 0);height:1px;margin:-1px;overflow:hidden;padding:0;position:absolute;width:1px}.visuallyhidden.focusable:active,.visuallyhidden.focusable:focus{clip:auto;height:auto;margin:0;overflow:visible;position:static;width:auto}.invisible{visibility:hidden}.clearfix:before,.clearfix:after{content:" ";display:table}.clearfix:after{clear:both}@media print{*,*:before,*:after,*:first-letter{background:transparent!important;color:#000!important;box-shadow:none!important}a,a:visited{text-decoration:underline}a[href]:after{content:" (" attr(href)")"}abbr[title]:after{content:" (" attr(title)")"}a[href^="#"]:after,a[href^="javascript:"]:after{content:""}pre,blockquote{border:1px solid #999;page-break-inside:avoid}thead{display:table-header-group}tr,img{page-break-inside:avoid}img{max-width:100%!important}p,h2,h3{orphans:3;widows:3}h2,h3{page-break-after:avoid}}a,.mdl-accordion,.mdl-button,.mdl-card,.mdl-checkbox,.mdl-dropdown-menu,.mdl-icon-toggle,.mdl-item,.mdl-radio,.mdl-slider,.mdl-switch,.mdl-tabs__tab{-webkit-tap-highlight-color:transparent;-webkit-tap-highlight-color:rgba(255,255,255,0)}html{width:100%;height:100%;-ms-touch-action:manipulation;touch-action:manipulation}body{width:100%;min-height:100%}main{display:block}*[hidden]{display:none!important}html,body{font-family:"Helvetica","Arial",sans-serif;font-size:14px;font-weight:400;line-height:20px}h1,h2,h3,h4,h5,h6,p{padding:0}h1 small,h2 small,h3 small,h4 small,h5 small,h6 small{font-family:"Roboto","Helvetica","Arial",sans-serif;font-weight:400;line-height:1.35;letter-spacing:-.02em;opacity:.54;font-size:.6em}h1{font-size:56px;line-height:1.35;letter-spacing:-.02em;margin:24px 0}h1,h2{font-family:"Roboto","Helvetica","Arial",sans-serif;font-weight:400}h2{font-size:45px;line-height:48px}h2,h3{margin:24px 0}h3{font-size:34px;line-height:40px}h3,h4{font-family:"Roboto","Helvetica","Arial",sans-serif;font-weight:400}h4{font-size:24px;line-height:32px;-moz-osx-font-smoothing:grayscale;margin:24px 0 16px}h5{font-size:20px;font-weight:500;line-height:1;letter-spacing:.02em}h5,h6{font-family:"Roboto","Helvetica","Arial",sans-serif;margin:24px 0 16px}h6{font-size:16px;letter-spacing:.04em}h6,p{font-weight:400;line-height:24px}p{font-size:14px;letter-spacing:0;margin:0 0 16px}a{color:rgb(255,171,64);font-weight:500}blockquote{font-family:"Roboto","Helvetica","Arial",sans-serif;position:relative;font-size:24px;font-weight:300;font-style:italic;line-height:1.35;letter-spacing:.08em}blockquote:before{position:absolute;left:-.5em;content:''“''}blockquote:after{content:''”'';margin-left:-.05em}mark{background-color:#f4ff81}dt{font-weight:700}address{font-size:12px;line-height:1;font-style:normal}address,ul,ol{font-weight:400;letter-spacing:0}ul,ol{font-size:14px;line-height:24px}.mdl-typography--display-4,.mdl-typography--display-4-color-contrast{font-family:"Roboto","Helvetica","Arial",sans-serif;font-size:112px;font-weight:300;line-height:1;letter-spacing:-.04em}.mdl-typography--display-4-color-contrast{opacity:.54}.mdl-typography--display-3,.mdl-typography--display-3-color-contrast{font-family:"Roboto","Helvetica","Arial",sans-serif;font-size:56px;font-weight:400;line-height:1.35;letter-spacing:-.02em}.mdl-typography--display-3-color-contrast{opacity:.54}.mdl-typography--display-2,.mdl-typography--display-2-color-contrast{font-family:"Roboto","Helvetica","Arial",sans-serif;font-size:45px;font-weight:400;line-height:48px}.mdl-typography--display-2-color-contrast{opacity:.54}.mdl-typography--display-1,.mdl-typography--display-1-color-contrast{font-family:"Roboto","Helvetica","Arial",sans-serif;font-size:34px;font-weight:400;line-height:40px}.mdl-typography--display-1-color-contrast{opacity:.54}.mdl-typography--headline,.mdl-typography--headline-color-contrast{font-family:"Roboto","Helvetica","Arial",sans-serif;font-size:24px;font-weight:400;line-height:32px;-moz-osx-font-smoothing:grayscale}.mdl-typography--headline-color-contrast{opacity:.87}.mdl-typography--title,.mdl-typography--title-color-contrast{font-family:"Roboto","Helvetica","Arial",sans-serif;font-size:20px;font-weight:500;line-height:1;letter-spacing:.02em}.mdl-typography--title-color-contrast{opacity:.87}.mdl-typography--subhead,.mdl-typography--subhead-color-contrast{font-family:"Roboto","Helvetica","Arial",sans-serif;font-size:16px;font-weight:400;line-height:24px;letter-spacing:.04em}.mdl-typography--subhead-color-contrast{opacity:.87}.mdl-typography--body-2,.mdl-typography--body-2-color-contrast{font-size:14px;font-weight:700;line-height:24px;letter-spacing:0}.mdl-typography--body-2-color-contrast{opacity:.87}.mdl-typography--body-1,.mdl-typography--body-1-color-contrast{font-size:14px;font-weight:400;line-height:24px;letter-spacing:0}.mdl-typography--body-1-color-contrast{opacity:.87}.mdl-typography--body-2-force-preferred-font,.mdl-typography--body-2-force-preferred-font-color-contrast{font-family:"Roboto","Helvetica","Arial",sans-serif;font-size:14px;font-weight:500;line-height:24px;letter-spacing:0}.mdl-typography--body-2-force-preferred-font-color-contrast{opacity:.87}.mdl-typography--body-1-force-preferred-font,.mdl-typography--body-1-force-preferred-font-color-contrast{font-family:"Roboto","Helvetica","Arial",sans-serif;font-size:14px;font-weight:400;line-height:24px;letter-spacing:0}.mdl-typography--body-1-force-preferred-font-color-contrast{opacity:.87}.mdl-typography--caption,.mdl-typography--caption-force-preferred-font{font-size:12px;font-weight:400;line-height:1;letter-spacing:0}.mdl-typography--caption-force-preferred-font{font-family:"Roboto","Helvetica","Arial",sans-serif}.mdl-typography--caption-color-contrast,.mdl-typography--caption-force-preferred-font-color-contrast{font-size:12px;font-weight:400;line-height:1;letter-spacing:0;opacity:.54}.mdl-typography--caption-force-preferred-font-color-contrast,.mdl-typography--menu{font-family:"Roboto","Helvetica","Arial",sans-serif}.mdl-typography--menu{font-size:14px;font-weight:500;line-height:1;letter-spacing:0}.mdl-typography--menu-color-contrast{opacity:.87}.mdl-typography--menu-color-contrast,.mdl-typography--button,.mdl-typography--button-color-contrast{font-family:"Roboto","Helvetica","Arial",sans-serif;font-size:14px;font-weight:500;line-height:1;letter-spacing:0}.mdl-typography--button,.mdl-typography--button-color-contrast{text-transform:uppercase}.mdl-typography--button-color-contrast{opacity:.87}.mdl-typography--text-left{text-align:left}.mdl-typography--text-right{text-align:right}.mdl-typography--text-center{text-align:center}.mdl-typography--text-justify{text-align:justify}.mdl-typography--text-nowrap{white-space:nowrap}.mdl-typography--text-lowercase{text-transform:lowercase}.mdl-typography--text-uppercase{text-transform:uppercase}.mdl-typography--text-capitalize{text-transform:capitalize}.mdl-typography--font-thin{font-weight:200!important}.mdl-typography--font-light{font-weight:300!important}.mdl-typography--font-regular{font-weight:400!important}.mdl-typography--font-medium{font-weight:500!important}.mdl-typography--font-bold{font-weight:700!important}.mdl-typography--font-black{font-weight:900!important}.material-icons{font-family:''Material Icons'';font-weight:400;font-style:normal;font-size:24px;line-height:1;letter-spacing:normal;text-transform:none;display:inline-block;word-wrap:normal;-moz-font-feature-settings:''liga'';font-feature-settings:''liga'';-webkit-font-feature-settings:''liga'';-webkit-font-smoothing:antialiased}.mdl-color-text--red{color:#f44336 !important}.mdl-color--red{background-color:#f44336 !important}.mdl-color-text--red-50{color:#ffebee !important}.mdl-color--red-50{background-color:#ffebee !important}.mdl-color-text--red-100{color:#ffcdd2 !important}.mdl-color--red-100{background-color:#ffcdd2 !important}.mdl-color-text--red-200{color:#ef9a9a !important}.mdl-color--red-200{background-color:#ef9a9a !important}.mdl-color-text--red-300{color:#e57373 !important}.mdl-color--red-300{background-color:#e57373 !important}.mdl-color-text--red-400{color:#ef5350 !important}.mdl-color--red-400{background-color:#ef5350 !important}.mdl-color-text--red-500{color:#f44336 !important}.mdl-color--red-500{background-color:#f44336 !important}.mdl-color-text--red-600{color:#e53935 !important}.mdl-color--red-600{background-color:#e53935 !important}.mdl-color-text--red-700{color:#d32f2f !important}.mdl-color--red-700{background-color:#d32f2f !important}.mdl-color-text--red-800{color:#c62828 !important}.mdl-color--red-800{background-color:#c62828 !important}.mdl-color-text--red-900{color:#b71c1c !important}.mdl-color--red-900{background-color:#b71c1c !important}.mdl-color-text--red-A100{color:#ff8a80 !important}.mdl-color--red-A100{background-color:#ff8a80 !important}.mdl-color-text--red-A200{color:#ff5252 !important}.mdl-color--red-A200{background-color:#ff5252 !important}.mdl-color-text--red-A400{color:#ff1744 !important}.mdl-color--red-A400{background-color:#ff1744 !important}.mdl-color-text--red-A700{color:#d50000 !important}.mdl-color--red-A700{background-color:#d50000 !important}.mdl-color-text--pink{color:#e91e63 !important}.mdl-color--pink{background-color:#e91e63 !important}.mdl-color-text--pink-50{color:#fce4ec !important}.mdl-color--pink-50{background-color:#fce4ec !important}.mdl-color-text--pink-100{color:#f8bbd0 !important}.mdl-color--pink-100{background-color:#f8bbd0 !important}.mdl-color-text--pink-200{color:#f48fb1 !important}.mdl-color--pink-200{background-color:#f48fb1 !important}.mdl-color-text--pink-300{color:#f06292 !important}.mdl-color--pink-300{background-color:#f06292 !important}.mdl-color-text--pink-400{color:#ec407a !important}.mdl-color--pink-400{background-color:#ec407a !important}.mdl-color-text--pink-500{color:#e91e63 !important}.mdl-color--pink-500{background-color:#e91e63 !important}.mdl-color-text--pink-600{color:#d81b60 !important}.mdl-color--pink-600{background-color:#d81b60 !important}.mdl-color-text--pink-700{color:#c2185b !important}.mdl-color--pink-700{background-color:#c2185b !important}.mdl-color-text--pink-800{color:#ad1457 !important}.mdl-color--pink-800{background-color:#ad1457 !important}.mdl-color-text--pink-900{color:#880e4f !important}.mdl-color--pink-900{background-color:#880e4f !important}.mdl-color-text--pink-A100{color:#ff80ab !important}.mdl-color--pink-A100{background-color:#ff80ab !important}.mdl-color-text--pink-A200{color:#ff4081 !important}.mdl-color--pink-A200{background-color:#ff4081 !important}.mdl-color-text--pink-A400{color:#f50057 !important}.mdl-color--pink-A400{background-color:#f50057 !important}.mdl-color-text--pink-A700{color:#c51162 !important}.mdl-color--pink-A700{background-color:#c51162 !important}.mdl-color-text--purple{color:#9c27b0 !important}.mdl-color--purple{background-color:#9c27b0 !important}.mdl-color-text--purple-50{color:#f3e5f5 !important}.mdl-color--purple-50{background-color:#f3e5f5 !important}.mdl-color-text--purple-100{color:#e1bee7 !important}.mdl-color--purple-100{background-color:#e1bee7 !important}.mdl-color-text--purple-200{color:#ce93d8 !important}.mdl-color--purple-200{background-color:#ce93d8 !important}.mdl-color-text--purple-300{color:#ba68c8 !important}.mdl-color--purple-300{background-color:#ba68c8 !important}.mdl-color-text--purple-400{color:#ab47bc !important}.mdl-color--purple-400{background-color:#ab47bc !important}.mdl-color-text--purple-500{color:#9c27b0 !important}.mdl-color--purple-500{background-color:#9c27b0 !important}.mdl-color-text--purple-600{color:#8e24aa !important}.mdl-color--purple-600{background-color:#8e24aa !important}.mdl-color-text--purple-700{color:#7b1fa2 !important}.mdl-color--purple-700{background-color:#7b1fa2 !important}.mdl-color-text--purple-800{color:#6a1b9a !important}.mdl-color--purple-800{background-color:#6a1b9a !important}.mdl-color-text--purple-900{color:#4a148c !important}.mdl-color--purple-900{background-color:#4a148c !important}.mdl-color-text--purple-A100{color:#ea80fc !important}.mdl-color--purple-A100{background-color:#ea80fc !important}.mdl-color-text--purple-A200{color:#e040fb !important}.mdl-color--purple-A200{background-color:#e040fb !important}.mdl-color-text--purple-A400{color:#d500f9 !important}.mdl-color--purple-A400{background-color:#d500f9 !important}.mdl-color-text--purple-A700{color:#a0f !important}.mdl-color--purple-A700{background-color:#a0f !important}.mdl-color-text--deep-purple{color:#673ab7 !important}.mdl-color--deep-purple{background-color:#673ab7 !important}.mdl-color-text--deep-purple-50{color:#ede7f6 !important}.mdl-color--deep-purple-50{background-color:#ede7f6 !important}.mdl-color-text--deep-purple-100{color:#d1c4e9 !important}.mdl-color--deep-purple-100{background-color:#d1c4e9 !important}.mdl-color-text--deep-purple-200{color:#b39ddb !important}.mdl-color--deep-purple-200{background-color:#b39ddb !important}.mdl-color-text--deep-purple-300{color:#9575cd !important}.mdl-color--deep-purple-300{background-color:#9575cd !important}.mdl-color-text--deep-purple-400{color:#7e57c2 !important}.mdl-color--deep-purple-400{background-color:#7e57c2 !important}.mdl-color-text--deep-purple-500{color:#673ab7 !important}.mdl-color--deep-purple-500{background-color:#673ab7 !important}.mdl-color-text--deep-purple-600{color:#5e35b1 !important}.mdl-color--deep-purple-600{background-color:#5e35b1 !important}.mdl-color-text--deep-purple-700{color:#512da8 !important}.mdl-color--deep-purple-700{background-color:#512da8 !important}.mdl-color-text--deep-purple-800{color:#4527a0 !important}.mdl-color--deep-purple-800{background-color:#4527a0 !important}.mdl-color-text--deep-purple-900{color:#311b92 !important}.mdl-color--deep-purple-900{background-color:#311b92 !important}.mdl-color-text--deep-purple-A100{color:#b388ff !important}.mdl-color--deep-purple-A100{background-color:#b388ff !important}.mdl-color-text--deep-purple-A200{color:#7c4dff !important}.mdl-color--deep-purple-A200{background-color:#7c4dff !important}.mdl-color-text--deep-purple-A400{color:#651fff !important}.mdl-color--deep-purple-A400{background-color:#651fff !important}.mdl-color-text--deep-purple-A700{color:#6200ea !important}.mdl-color--deep-purple-A700{background-color:#6200ea !important}.mdl-color-text--indigo{color:#3f51b5 !important}.mdl-color--indigo{background-color:#3f51b5 !important}.mdl-color-text--indigo-50{color:#e8eaf6 !important}.mdl-color--indigo-50{background-color:#e8eaf6 !important}.mdl-color-text--indigo-100{color:#c5cae9 !important}.mdl-color--indigo-100{background-color:#c5cae9 !important}.mdl-color-text--indigo-200{color:#9fa8da !important}.mdl-color--indigo-200{background-color:#9fa8da !important}.mdl-color-text--indigo-300{color:#7986cb !important}.mdl-color--indigo-300{background-color:#7986cb !important}.mdl-color-text--indigo-400{color:#5c6bc0 !important}.mdl-color--indigo-400{background-color:#5c6bc0 !important}.mdl-color-text--indigo-500{color:#3f51b5 !important}.mdl-color--indigo-500{background-color:#3f51b5 !important}.mdl-color-text--indigo-600{color:#3949ab !important}.mdl-color--indigo-600{background-color:#3949ab !important}.mdl-color-text--indigo-700{color:#303f9f !important}.mdl-color--indigo-700{background-color:#303f9f !important}.mdl-color-text--indigo-800{color:#283593 !important}.mdl-color--indigo-800{background-color:#283593 !important}.mdl-color-text--indigo-900{color:#1a237e !important}.mdl-color--indigo-900{background-color:#1a237e !important}.mdl-color-text--indigo-A100{color:#8c9eff !important}.mdl-color--indigo-A100{background-color:#8c9eff !important}.mdl-color-text--indigo-A200{color:#536dfe !important}.mdl-color--indigo-A200{background-color:#536dfe !important}.mdl-color-text--indigo-A400{color:#3d5afe !important}.mdl-color--indigo-A400{background-color:#3d5afe !important}.mdl-color-text--indigo-A700{color:#304ffe !important}.mdl-color--indigo-A700{background-color:#304ffe !important}.mdl-color-text--blue{color:#2196f3 !important}.mdl-color--blue{background-color:#2196f3 !important}.mdl-color-text--blue-50{color:#e3f2fd !important}.mdl-color--blue-50{background-color:#e3f2fd !important}.mdl-color-text--blue-100{color:#bbdefb !important}.mdl-color--blue-100{background-color:#bbdefb !important}.mdl-color-text--blue-200{color:#90caf9 !important}.mdl-color--blue-200{background-color:#90caf9 !important}.mdl-color-text--blue-300{color:#64b5f6 !important}.mdl-color--blue-300{background-color:#64b5f6 !important}.mdl-color-text--blue-400{color:#42a5f5 !important}.mdl-color--blue-400{background-color:#42a5f5 !important}.mdl-color-text--blue-500{color:#2196f3 !important}.mdl-color--blue-500{background-color:#2196f3 !important}.mdl-color-text--blue-600{color:#1e88e5 !important}.mdl-color--blue-600{background-color:#1e88e5 !important}.mdl-color-text--blue-700{color:#1976d2 !important}.mdl-color--blue-700{background-color:#1976d2 !important}.mdl-color-text--blue-800{color:#1565c0 !important}.mdl-color--blue-800{background-color:#1565c0 !important}.mdl-color-text--blue-900{color:#0d47a1 !important}.mdl-color--blue-900{background-color:#0d47a1 !important}.mdl-color-text--blue-A100{color:#82b1ff !important}.mdl-color--blue-A100{background-color:#82b1ff !important}.mdl-color-text--blue-A200{color:#448aff !important}.mdl-color--blue-A200{background-color:#448aff !important}.mdl-color-text--blue-A400{color:#2979ff !important}.mdl-color--blue-A400{background-color:#2979ff !important}.mdl-color-text--blue-A700{color:#2962ff !important}.mdl-color--blue-A700{background-color:#2962ff !important}.mdl-color-text--light-blue{color:#03a9f4 !important}.mdl-color--light-blue{background-color:#03a9f4 !important}.mdl-color-text--light-blue-50{color:#e1f5fe !important}.mdl-color--light-blue-50{background-color:#e1f5fe !important}.mdl-color-text--light-blue-100{color:#b3e5fc !important}.mdl-color--light-blue-100{background-color:#b3e5fc !important}.mdl-color-text--light-blue-200{color:#81d4fa !important}.mdl-color--light-blue-200{background-color:#81d4fa !important}.mdl-color-text--light-blue-300{color:#4fc3f7 !important}.mdl-color--light-blue-300{background-color:#4fc3f7 !important}.mdl-color-text--light-blue-400{color:#29b6f6 !important}.mdl-color--light-blue-400{background-color:#29b6f6 !important}.mdl-color-text--light-blue-500{color:#03a9f4 !important}.mdl-color--light-blue-500{background-color:#03a9f4 !important}.mdl-color-text--light-blue-600{color:#039be5 !important}.mdl-color--light-blue-600{background-color:#039be5 !important}.mdl-color-text--light-blue-700{color:#0288d1 !important}.mdl-color--light-blue-700{background-color:#0288d1 !important}.mdl-color-text--light-blue-800{color:#0277bd !important}.mdl-color--light-blue-800{background-color:#0277bd !important}.mdl-color-text--light-blue-900{color:#01579b !important}.mdl-color--light-blue-900{background-color:#01579b !important}.mdl-color-text--light-blue-A100{color:#80d8ff !important}.mdl-color--light-blue-A100{background-color:#80d8ff !important}.mdl-color-text--light-blue-A200{color:#40c4ff !important}.mdl-color--light-blue-A200{background-color:#40c4ff !important}.mdl-color-text--light-blue-A400{color:#00b0ff !important}.mdl-color--light-blue-A400{background-color:#00b0ff !important}.mdl-color-text--light-blue-A700{color:#0091ea !important}.mdl-color--light-blue-A700{background-color:#0091ea !important}.mdl-color-text--cyan{color:#00bcd4 !important}.mdl-color--cyan{background-color:#00bcd4 !important}.mdl-color-text--cyan-50{color:#e0f7fa !important}.mdl-color--cyan-50{background-color:#e0f7fa !important}.mdl-color-text--cyan-100{color:#b2ebf2 !important}.mdl-color--cyan-100{background-color:#b2ebf2 !important}.mdl-color-text--cyan-200{color:#80deea !important}.mdl-color--cyan-200{background-color:#80deea !important}.mdl-color-text--cyan-300{color:#4dd0e1 !important}.mdl-color--cyan-300{background-color:#4dd0e1 !important}.mdl-color-text--cyan-400{color:#26c6da !important}.mdl-color--cyan-400{background-color:#26c6da !important}.mdl-color-text--cyan-500{color:#00bcd4 !important}.mdl-color--cyan-500{background-color:#00bcd4 !important}.mdl-color-text--cyan-600{color:#00acc1 !important}.mdl-color--cyan-600{background-color:#00acc1 !important}.mdl-color-text--cyan-700{color:#0097a7 !important}.mdl-color--cyan-700{background-color:#0097a7 !important}.mdl-color-text--cyan-800{color:#00838f !important}.mdl-color--cyan-800{background-color:#00838f !important}.mdl-color-text--cyan-900{color:#006064 !important}.mdl-color--cyan-900{background-color:#006064 !important}.mdl-color-text--cyan-A100{color:#84ffff !important}.mdl-color--cyan-A100{background-color:#84ffff !important}.mdl-color-text--cyan-A200{color:#18ffff !important}.mdl-color--cyan-A200{background-color:#18ffff !important}.mdl-color-text--cyan-A400{color:#00e5ff !important}.mdl-color--cyan-A400{background-color:#00e5ff !important}.mdl-color-text--cyan-A700{color:#00b8d4 !important}.mdl-color--cyan-A700{background-color:#00b8d4 !important}.mdl-color-text--teal{color:#009688 !important}.mdl-color--teal{background-color:#009688 !important}.mdl-color-text--teal-50{color:#e0f2f1 !important}.mdl-color--teal-50{background-color:#e0f2f1 !important}.mdl-color-text--teal-100{color:#b2dfdb !important}.mdl-color--teal-100{background-color:#b2dfdb !important}.mdl-color-text--teal-200{color:#80cbc4 !important}.mdl-color--teal-200{background-color:#80cbc4 !important}.mdl-color-text--teal-300{color:#4db6ac !important}.mdl-color--teal-300{background-color:#4db6ac !important}.mdl-color-text--teal-400{color:#26a69a !important}.mdl-color--teal-400{background-color:#26a69a !important}.mdl-color-text--teal-500{color:#009688 !important}.mdl-color--teal-500{background-color:#009688 !important}.mdl-color-text--teal-600{color:#00897b !important}.mdl-color--teal-600{background-color:#00897b !important}.mdl-color-text--teal-700{color:#00796b !important}.mdl-color--teal-700{background-color:#00796b !important}.mdl-color-text--teal-800{color:#00695c !important}.mdl-color--teal-800{background-color:#00695c !important}.mdl-color-text--teal-900{color:#004d40 !important}.mdl-color--teal-900{background-color:#004d40 !important}.mdl-color-text--teal-A100{color:#a7ffeb !important}.mdl-color--teal-A100{background-color:#a7ffeb !important}.mdl-color-text--teal-A200{color:#64ffda !important}.mdl-color--teal-A200{background-color:#64ffda !important}.mdl-color-text--teal-A400{color:#1de9b6 !important}.mdl-color--teal-A400{background-color:#1de9b6 !important}.mdl-color-text--teal-A700{color:#00bfa5 !important}.mdl-color--teal-A700{background-color:#00bfa5 !important}.mdl-color-text--green{color:#4caf50 !important}.mdl-color--green{background-color:#4caf50 !important}.mdl-color-text--green-50{color:#e8f5e9 !important}.mdl-color--green-50{background-color:#e8f5e9 !important}.mdl-color-text--green-100{color:#c8e6c9 !important}.mdl-color--green-100{background-color:#c8e6c9 !important}.mdl-color-text--green-200{color:#a5d6a7 !important}.mdl-color--green-200{background-color:#a5d6a7 !important}.mdl-color-text--green-300{color:#81c784 !important}.mdl-color--green-300{background-color:#81c784 !important}.mdl-color-text--green-400{color:#66bb6a !important}.mdl-color--green-400{background-color:#66bb6a !important}.mdl-color-text--green-500{color:#4caf50 !important}.mdl-color--green-500{background-color:#4caf50 !important}.mdl-color-text--green-600{color:#43a047 !important}.mdl-color--green-600{background-color:#43a047 !important}.mdl-color-text--green-700{color:#388e3c !important}.mdl-color--green-700{background-color:#388e3c !important}.mdl-color-text--green-800{color:#2e7d32 !important}.mdl-color--green-800{background-color:#2e7d32 !important}.mdl-color-text--green-900{color:#1b5e20 !important}.mdl-color--green-900{background-color:#1b5e20 !important}.mdl-color-text--green-A100{color:#b9f6ca !important}.mdl-color--green-A100{background-color:#b9f6ca !important}.mdl-color-text--green-A200{color:#69f0ae !important}.mdl-color--green-A200{background-color:#69f0ae !important}.mdl-color-text--green-A400{color:#00e676 !important}.mdl-color--green-A400{background-color:#00e676 !important}.mdl-color-text--green-A700{color:#00c853 !important}.mdl-color--green-A700{background-color:#00c853 !important}.mdl-color-text--light-green{color:#8bc34a !important}.mdl-color--light-green{background-color:#8bc34a !important}.mdl-color-text--light-green-50{color:#f1f8e9 !important}.mdl-color--light-green-50{background-color:#f1f8e9 !important}.mdl-color-text--light-green-100{color:#dcedc8 !important}.mdl-color--light-green-100{background-color:#dcedc8 !important}.mdl-color-text--light-green-200{color:#c5e1a5 !important}.mdl-color--light-green-200{background-color:#c5e1a5 !important}.mdl-color-text--light-green-300{color:#aed581 !important}.mdl-color--light-green-300{background-color:#aed581 !important}.mdl-color-text--light-green-400{color:#9ccc65 !important}.mdl-color--light-green-400{background-color:#9ccc65 !important}.mdl-color-text--light-green-500{color:#8bc34a !important}.mdl-color--light-green-500{background-color:#8bc34a !important}.mdl-color-text--light-green-600{color:#7cb342 !important}.mdl-color--light-green-600{background-color:#7cb342 !important}.mdl-color-text--light-green-700{color:#689f38 !important}.mdl-color--light-green-700{background-color:#689f38 !important}.mdl-color-text--light-green-800{color:#558b2f !important}.mdl-color--light-green-800{background-color:#558b2f !important}.mdl-color-text--light-green-900{color:#33691e !important}.mdl-color--light-green-900{background-color:#33691e !important}.mdl-color-text--light-green-A100{color:#ccff90 !important}.mdl-color--light-green-A100{background-color:#ccff90 !important}.mdl-color-text--light-green-A200{color:#b2ff59 !important}.mdl-color--light-green-A200{background-color:#b2ff59 !important}.mdl-color-text--light-green-A400{color:#76ff03 !important}.mdl-color--light-green-A400{background-color:#76ff03 !important}.mdl-color-text--light-green-A700{color:#64dd17 !important}.mdl-color--light-green-A700{background-color:#64dd17 !important}.mdl-color-text--lime{color:#cddc39 !important}.mdl-color--lime{background-color:#cddc39 !important}.mdl-color-text--lime-50{color:#f9fbe7 !important}.mdl-color--lime-50{background-color:#f9fbe7 !important}.mdl-color-text--lime-100{color:#f0f4c3 !important}.mdl-color--lime-100{background-color:#f0f4c3 !important}.mdl-color-text--lime-200{color:#e6ee9c !important}.mdl-color--lime-200{background-color:#e6ee9c !important}.mdl-color-text--lime-300{color:#dce775 !important}.mdl-color--lime-300{background-color:#dce775 !important}.mdl-color-text--lime-400{color:#d4e157 !important}.mdl-color--lime-400{background-color:#d4e157 !important}.mdl-color-text--lime-500{color:#cddc39 !important}.mdl-color--lime-500{background-color:#cddc39 !important}.mdl-color-text--lime-600{color:#c0ca33 !important}.mdl-color--lime-600{background-color:#c0ca33 !important}.mdl-color-text--lime-700{color:#afb42b !important}.mdl-color--lime-700{background-color:#afb42b !important}.mdl-color-text--lime-800{color:#9e9d24 !important}.mdl-color--lime-800{background-color:#9e9d24 !important}.mdl-color-text--lime-900{color:#827717 !important}.mdl-color--lime-900{background-color:#827717 !important}.mdl-color-text--lime-A100{color:#f4ff81 !important}.mdl-color--lime-A100{background-color:#f4ff81 !important}.mdl-color-text--lime-A200{color:#eeff41 !important}.mdl-color--lime-A200{background-color:#eeff41 !important}.mdl-color-text--lime-A400{color:#c6ff00 !important}.mdl-color--lime-A400{background-color:#c6ff00 !important}.mdl-color-text--lime-A700{color:#aeea00 !important}.mdl-color--lime-A700{background-color:#aeea00 !important}.mdl-color-text--yellow{color:#ffeb3b !important}.mdl-color--yellow{background-color:#ffeb3b !important}.mdl-color-text--yellow-50{color:#fffde7 !important}.mdl-color--yellow-50{background-color:#fffde7 !important}.mdl-color-text--yellow-100{color:#fff9c4 !important}.mdl-color--yellow-100{background-color:#fff9c4 !important}.mdl-color-text--yellow-200{color:#fff59d !important}.mdl-color--yellow-200{background-color:#fff59d !important}.mdl-color-text--yellow-300{color:#fff176 !important}.mdl-color--yellow-300{background-color:#fff176 !important}.mdl-color-text--yellow-400{color:#ffee58 !important}.mdl-color--yellow-400{background-color:#ffee58 !important}.mdl-color-text--yellow-500{color:#ffeb3b !important}.mdl-color--yellow-500{background-color:#ffeb3b !important}.mdl-color-text--yellow-600{color:#fdd835 !important}.mdl-color--yellow-600{background-color:#fdd835 !important}.mdl-color-text--yellow-700{color:#fbc02d !important}.mdl-color--yellow-700{background-color:#fbc02d !important}.mdl-color-text--yellow-800{color:#f9a825 !important}.mdl-color--yellow-800{background-color:#f9a825 !important}.mdl-color-text--yellow-900{color:#f57f17 !important}.mdl-color--yellow-900{background-color:#f57f17 !important}.mdl-color-text--yellow-A100{color:#ffff8d !important}.mdl-color--yellow-A100{background-color:#ffff8d !important}.mdl-color-text--yellow-A200{color:#ff0 !important}.mdl-color--yellow-A200{background-color:#ff0 !important}.mdl-color-text--yellow-A400{color:#ffea00 !important}.mdl-color--yellow-A400{background-color:#ffea00 !important}.mdl-color-text--yellow-A700{color:#ffd600 !important}.mdl-color--yellow-A700{background-color:#ffd600 !important}.mdl-color-text--amber{color:#ffc107 !important}.mdl-color--amber{background-color:#ffc107 !important}.mdl-color-text--amber-50{color:#fff8e1 !important}.mdl-color--amber-50{background-color:#fff8e1 !important}.mdl-color-text--amber-100{color:#ffecb3 !important}.mdl-color--amber-100{background-color:#ffecb3 !important}.mdl-color-text--amber-200{color:#ffe082 !important}.mdl-color--amber-200{background-color:#ffe082 !important}.mdl-color-text--amber-300{color:#ffd54f !important}.mdl-color--amber-300{background-color:#ffd54f !important}.mdl-color-text--amber-400{color:#ffca28 !important}.mdl-color--amber-400{background-color:#ffca28 !important}.mdl-color-text--amber-500{color:#ffc107 !important}.mdl-color--amber-500{background-color:#ffc107 !important}.mdl-color-text--amber-600{color:#ffb300 !important}.mdl-color--amber-600{background-color:#ffb300 !important}.mdl-color-text--amber-700{color:#ffa000 !important}.mdl-color--amber-700{background-color:#ffa000 !important}.mdl-color-text--amber-800{color:#ff8f00 !important}.mdl-color--amber-800{background-color:#ff8f00 !important}.mdl-color-text--amber-900{color:#ff6f00 !important}.mdl-color--amber-900{background-color:#ff6f00 !important}.mdl-color-text--amber-A100{color:#ffe57f !important}.mdl-color--amber-A100{background-color:#ffe57f !important}.mdl-color-text--amber-A200{color:#ffd740 !important}.mdl-color--amber-A200{background-color:#ffd740 !important}.mdl-color-text--amber-A400{color:#ffc400 !important}.mdl-color--amber-A400{background-color:#ffc400 !important}.mdl-color-text--amber-A700{color:#ffab00 !important}.mdl-color--amber-A700{background-color:#ffab00 !important}.mdl-color-text--orange{color:#ff9800 !important}.mdl-color--orange{background-color:#ff9800 !important}.mdl-color-text--orange-50{color:#fff3e0 !important}.mdl-color--orange-50{background-color:#fff3e0 !important}.mdl-color-text--orange-100{color:#ffe0b2 !important}.mdl-color--orange-100{background-color:#ffe0b2 !important}.mdl-color-text--orange-200{color:#ffcc80 !important}.mdl-color--orange-200{background-color:#ffcc80 !important}.mdl-color-text--orange-300{color:#ffb74d !important}.mdl-color--orange-300{background-color:#ffb74d !important}.mdl-color-text--orange-400{color:#ffa726 !important}.mdl-color--orange-400{background-color:#ffa726 !important}.mdl-color-text--orange-500{color:#ff9800 !important}.mdl-color--orange-500{background-color:#ff9800 !important}.mdl-color-text--orange-600{color:#fb8c00 !important}.mdl-color--orange-600{background-color:#fb8c00 !important}.mdl-color-text--orange-700{color:#f57c00 !important}.mdl-color--orange-700{background-color:#f57c00 !important}.mdl-color-text--orange-800{color:#ef6c00 !important}.mdl-color--orange-800{background-color:#ef6c00 !important}.mdl-color-text--orange-900{color:#e65100 !important}.mdl-color--orange-900{background-color:#e65100 !important}.mdl-color-text--orange-A100{color:#ffd180 !important}.mdl-color--orange-A100{background-color:#ffd180 !important}.mdl-color-text--orange-A200{color:#ffab40 !important}.mdl-color--orange-A200{background-color:#ffab40 !important}.mdl-color-text--orange-A400{color:#ff9100 !important}.mdl-color--orange-A400{background-color:#ff9100 !important}.mdl-color-text--orange-A700{color:#ff6d00 !important}.mdl-color--orange-A700{background-color:#ff6d00 !important}.mdl-color-text--deep-orange{color:#ff5722 !important}.mdl-color--deep-orange{background-color:#ff5722 !important}.mdl-color-text--deep-orange-50{color:#fbe9e7 !important}.mdl-color--deep-orange-50{background-color:#fbe9e7 !important}.mdl-color-text--deep-orange-100{color:#ffccbc !important}.mdl-color--deep-orange-100{background-color:#ffccbc !important}.mdl-color-text--deep-orange-200{color:#ffab91 !important}.mdl-color--deep-orange-200{background-color:#ffab91 !important}.mdl-color-text--deep-orange-300{color:#ff8a65 !important}.mdl-color--deep-orange-300{background-color:#ff8a65 !important}.mdl-color-text--deep-orange-400{color:#ff7043 !important}.mdl-color--deep-orange-400{background-color:#ff7043 !important}.mdl-color-text--deep-orange-500{color:#ff5722 !important}.mdl-color--deep-orange-500{background-color:#ff5722 !important}.mdl-color-text--deep-orange-600{color:#f4511e !important}.mdl-color--deep-orange-600{background-color:#f4511e !important}.mdl-color-text--deep-orange-700{color:#e64a19 !important}.mdl-color--deep-orange-700{background-color:#e64a19 !important}.mdl-color-text--deep-orange-800{color:#d84315 !important}.mdl-color--deep-orange-800{background-color:#d84315 !important}.mdl-color-text--deep-orange-900{color:#bf360c !important}.mdl-color--deep-orange-900{background-color:#bf360c !important}.mdl-color-text--deep-orange-A100{color:#ff9e80 !important}.mdl-color--deep-orange-A100{background-color:#ff9e80 !important}.mdl-color-text--deep-orange-A200{color:#ff6e40 !important}.mdl-color--deep-orange-A200{background-color:#ff6e40 !important}.mdl-color-text--deep-orange-A400{color:#ff3d00 !important}.mdl-color--deep-orange-A400{background-color:#ff3d00 !important}.mdl-color-text--deep-orange-A700{color:#dd2c00 !important}.mdl-color--deep-orange-A700{background-color:#dd2c00 !important}.mdl-color-text--brown{color:#795548 !important}.mdl-color--brown{background-color:#795548 !important}.mdl-color-text--brown-50{color:#efebe9 !important}.mdl-color--brown-50{background-color:#efebe9 !important}.mdl-color-text--brown-100{color:#d7ccc8 !important}.mdl-color--brown-100{background-color:#d7ccc8 !important}.mdl-color-text--brown-200{color:#bcaaa4 !important}.mdl-color--brown-200{background-color:#bcaaa4 !important}.mdl-color-text--brown-300{color:#a1887f !important}.mdl-color--brown-300{background-color:#a1887f !important}.mdl-color-text--brown-400{color:#8d6e63 !important}.mdl-color--brown-400{background-color:#8d6e63 !important}.mdl-color-text--brown-500{color:#795548 !important}.mdl-color--brown-500{background-color:#795548 !important}.mdl-color-text--brown-600{color:#6d4c41 !important}.mdl-color--brown-600{background-color:#6d4c41 !important}.mdl-color-text--brown-700{color:#5d4037 !important}.mdl-color--brown-700{background-color:#5d4037 !important}.mdl-color-text--brown-800{color:#4e342e !important}.mdl-color--brown-800{background-color:#4e342e !important}.mdl-color-text--brown-900{color:#3e2723 !important}.mdl-color--brown-900{background-color:#3e2723 !important}.mdl-color-text--grey{color:#9e9e9e !important}.mdl-color--grey{background-color:#9e9e9e !important}.mdl-color-text--grey-50{color:#fafafa !important}.mdl-color--grey-50{background-color:#fafafa !important}.mdl-color-text--grey-100{color:#f5f5f5 !important}.mdl-color--grey-100{background-color:#f5f5f5 !important}.mdl-color-text--grey-200{color:#eee !important}.mdl-color--grey-200{background-color:#eee !important}.mdl-color-text--grey-300{color:#e0e0e0 !important}.mdl-color--grey-300{background-color:#e0e0e0 !important}.mdl-color-text--grey-400{color:#bdbdbd !important}.mdl-color--grey-400{background-color:#bdbdbd !important}.mdl-color-text--grey-500{color:#9e9e9e !important}.mdl-color--grey-500{background-color:#9e9e9e !important}.mdl-color-text--grey-600{color:#757575 !important}.mdl-color--grey-600{background-color:#757575 !important}.mdl-color-text--grey-700{color:#616161 !important}.mdl-color--grey-700{background-color:#616161 !important}.mdl-color-text--grey-800{color:#424242 !important}.mdl-color--grey-800{background-color:#424242 !important}.mdl-color-text--grey-900{color:#212121 !important}.mdl-color--grey-900{background-color:#212121 !important}.mdl-color-text--blue-grey{color:#607d8b !important}.mdl-color--blue-grey{background-color:#607d8b !important}.mdl-color-text--blue-grey-50{color:#eceff1 !important}.mdl-color--blue-grey-50{background-color:#eceff1 !important}.mdl-color-text--blue-grey-100{color:#cfd8dc !important}.mdl-color--blue-grey-100{background-color:#cfd8dc !important}.mdl-color-text--blue-grey-200{color:#b0bec5 !important}.mdl-color--blue-grey-200{background-color:#b0bec5 !important}.mdl-color-text--blue-grey-300{color:#90a4ae !important}.mdl-color--blue-grey-300{background-color:#90a4ae !important}.mdl-color-text--blue-grey-400{color:#78909c !important}.mdl-color--blue-grey-400{background-color:#78909c !important}.mdl-color-text--blue-grey-500{color:#607d8b !important}.mdl-color--blue-grey-500{background-color:#607d8b !important}.mdl-color-text--blue-grey-600{color:#546e7a !important}.mdl-color--blue-grey-600{background-color:#546e7a !important}.mdl-color-text--blue-grey-700{color:#455a64 !important}.mdl-color--blue-grey-700{background-color:#455a64 !important}.mdl-color-text--blue-grey-800{color:#37474f !important}.mdl-color--blue-grey-800{background-color:#37474f !important}.mdl-color-text--blue-grey-900{color:#263238 !important}.mdl-color--blue-grey-900{background-color:#263238 !important}.mdl-color--black{background-color:#000 !important}.mdl-color-text--black{color:#000 !important}.mdl-color--white{background-color:#fff !important}.mdl-color-text--white{color:#fff !important}.mdl-color--primary{background-color:rgb(63,81,181)!important}.mdl-color--primary-contrast{background-color:rgb(255,255,255)!important}.mdl-color--primary-dark{background-color:rgb(48,63,159)!important}.mdl-color--accent{background-color:rgb(255,171,64)!important}.mdl-color--accent-contrast{background-color:rgb(66,66,66)!important}.mdl-color-text--primary{color:rgb(63,81,181)!important}.mdl-color-text--primary-contrast{color:rgb(255,255,255)!important}.mdl-color-text--primary-dark{color:rgb(48,63,159)!important}.mdl-color-text--accent{color:rgb(255,171,64)!important}.mdl-color-text--accent-contrast{color:rgb(66,66,66)!important}.mdl-ripple{background:#000;border-radius:50%;height:50px;left:0;opacity:0;pointer-events:none;position:absolute;top:0;-webkit-transform:translate(-50%,-50%);transform:translate(-50%,-50%);width:50px;overflow:hidden}.mdl-ripple.is-animating{transition:transform .3s cubic-bezier(0,0,.2,1),width .3s cubic-bezier(0,0,.2,1),height .3s cubic-bezier(0,0,.2,1),opacity .6s cubic-bezier(0,0,.2,1);transition:transform .3s cubic-bezier(0,0,.2,1),width .3s cubic-bezier(0,0,.2,1),height .3s cubic-bezier(0,0,.2,1),opacity .6s cubic-bezier(0,0,.2,1),-webkit-transform .3s cubic-bezier(0,0,.2,1)}.mdl-ripple.is-visible{opacity:.3}.mdl-animation--default,.mdl-animation--fast-out-slow-in{transition-timing-function:cubic-bezier(.4,0,.2,1)}.mdl-animation--linear-out-slow-in{transition-timing-function:cubic-bezier(0,0,.2,1)}.mdl-animation--fast-out-linear-in{transition-timing-function:cubic-bezier(.4,0,1,1)}.mdl-badge{position:relative;white-space:nowrap;margin-right:24px}.mdl-badge:not([data-badge]){margin-right:auto}.mdl-badge[data-badge]:after{content:attr(data-badge);display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-flex-direction:row;-ms-flex-direction:row;flex-direction:row;-webkit-flex-wrap:wrap;-ms-flex-wrap:wrap;flex-wrap:wrap;-webkit-justify-content:center;-ms-flex-pack:center;justify-content:center;-webkit-align-content:center;-ms-flex-line-pack:center;align-content:center;-webkit-align-items:center;-ms-flex-align:center;align-items:center;position:absolute;top:-11px;right:-24px;font-family:"Roboto","Helvetica","Arial",sans-serif;font-weight:600;font-size:12px;width:22px;height:22px;border-radius:50%;background:rgb(255,171,64);color:rgb(66,66,66)}.mdl-button .mdl-badge[data-badge]:after{top:-10px;right:-5px}.mdl-badge.mdl-badge--no-background[data-badge]:after{color:rgb(255,171,64);background:rgba(66,66,66,.2);box-shadow:0 0 1px gray}.mdl-badge.mdl-badge--overlap{margin-right:10px}.mdl-badge.mdl-badge--overlap:after{right:-10px}.mdl-button{background:0 0;border:none;border-radius:2px;color:#000;position:relative;height:36px;margin:0;min-width:64px;padding:0 16px;display:inline-block;font-family:"Roboto","Helvetica","Arial",sans-serif;font-size:14px;font-weight:500;text-transform:uppercase;letter-spacing:0;overflow:hidden;will-change:box-shadow;transition:box-shadow .2s cubic-bezier(.4,0,1,1),background-color .2s cubic-bezier(.4,0,.2,1),color .2s cubic-bezier(.4,0,.2,1);outline:none;cursor:pointer;text-decoration:none;text-align:center;line-height:36px;vertical-align:middle}.mdl-button::-moz-focus-inner{border:0}.mdl-button:hover{background-color:rgba(158,158,158,.2)}.mdl-button:focus:not(:active){background-color:rgba(0,0,0,.12)}.mdl-button:active{background-color:rgba(158,158,158,.4)}.mdl-button.mdl-button--colored{color:rgb(63,81,181)}.mdl-button.mdl-button--colored:focus:not(:active){background-color:rgba(0,0,0,.12)}input.mdl-button[type="submit"]{-webkit-appearance:none}.mdl-button--raised{background:rgba(158,158,158,.2);box-shadow:0 2px 2px 0 rgba(0,0,0,.14),0 3px 1px -2px rgba(0,0,0,.2),0 1px 5px 0 rgba(0,0,0,.12)}.mdl-button--raised:active{box-shadow:0 4px 5px 0 rgba(0,0,0,.14),0 1px 10px 0 rgba(0,0,0,.12),0 2px 4px -1px rgba(0,0,0,.2);background-color:rgba(158,158,158,.4)}.mdl-button--raised:focus:not(:active){box-shadow:0 0 8px rgba(0,0,0,.18),0 8px 16px rgba(0,0,0,.36);background-color:rgba(158,158,158,.4)}.mdl-button--raised.mdl-button--colored{background:rgb(63,81,181);color:rgb(255,255,255)}.mdl-button--raised.mdl-button--colored:hover{background-color:rgb(63,81,181)}.mdl-button--raised.mdl-button--colored:active{background-color:rgb(63,81,181)}.mdl-button--raised.mdl-button--colored:focus:not(:active){background-color:rgb(63,81,181)}.mdl-button--raised.mdl-button--colored .mdl-ripple{background:rgb(255,255,255)}.mdl-button--fab{border-radius:50%;font-size:24px;height:56px;margin:auto;min-width:56px;width:56px;padding:0;overflow:hidden;background:rgba(158,158,158,.2);box-shadow:0 1px 1.5px 0 rgba(0,0,0,.12),0 1px 1px 0 rgba(0,0,0,.24);position:relative;line-height:normal}.mdl-button--fab .material-icons{position:absolute;top:50%;left:50%;-webkit-transform:translate(-12px,-12px);transform:translate(-12px,-12px);line-height:24px;width:24px}.mdl-button--fab.mdl-button--mini-fab{height:40px;min-width:40px;width:40px}.mdl-button--fab .mdl-button__ripple-container{border-radius:50%;-webkit-mask-image:-webkit-radial-gradient(circle,#fff,#000)}.mdl-button--fab:active{box-shadow:0 4px 5px 0 rgba(0,0,0,.14),0 1px 10px 0 rgba(0,0,0,.12),0 2px 4px -1px rgba(0,0,0,.2);background-color:rgba(158,158,158,.4)}.mdl-button--fab:focus:not(:active){box-shadow:0 0 8px rgba(0,0,0,.18),0 8px 16px rgba(0,0,0,.36);background-color:rgba(158,158,158,.4)}.mdl-button--fab.mdl-button--colored{background:rgb(255,171,64);color:rgb(66,66,66)}.mdl-button--fab.mdl-button--colored:hover{background-color:rgb(255,171,64)}.mdl-button--fab.mdl-button--colored:focus:not(:active){background-color:rgb(255,171,64)}.mdl-button--fab.mdl-button--colored:active{background-color:rgb(255,171,64)}.mdl-button--fab.mdl-button--colored .mdl-ripple{background:rgb(66,66,66)}.mdl-button--icon{border-radius:50%;font-size:24px;height:32px;margin-left:0;margin-right:0;min-width:32px;width:32px;padding:0;overflow:hidden;color:inherit;line-height:normal}.mdl-button--icon .material-icons{position:absolute;top:50%;left:50%;-webkit-transform:translate(-12px,-12px);transform:translate(-12px,-12px);line-height:24px;width:24px}.mdl-button--icon.mdl-button--mini-icon{height:24px;min-width:24px;width:24px}.mdl-button--icon.mdl-button--mini-icon .material-icons{top:0;left:0}.mdl-button--icon .mdl-button__ripple-container{border-radius:50%;-webkit-mask-image:-webkit-radial-gradient(circle,#fff,#000)}.mdl-button__ripple-container{display:block;height:100%;left:0;position:absolute;top:0;width:100%;z-index:0;overflow:hidden}.mdl-button[disabled] .mdl-button__ripple-container .mdl-ripple,.mdl-button.mdl-button--disabled .mdl-button__ripple-container .mdl-ripple{background-color:transparent}.mdl-button--primary.mdl-button--primary{color:rgb(63,81,181)}.mdl-button--primary.mdl-button--primary .mdl-ripple{background:rgb(255,255,255)}.mdl-button--primary.mdl-button--primary.mdl-button--raised,.mdl-button--primary.mdl-button--primary.mdl-button--fab{color:rgb(255,255,255);background-color:rgb(63,81,181)}.mdl-button--accent.mdl-button--accent{color:rgb(255,171,64)}.mdl-button--accent.mdl-button--accent .mdl-ripple{background:rgb(66,66,66)}.mdl-button--accent.mdl-button--accent.mdl-button--raised,.mdl-button--accent.mdl-button--accent.mdl-button--fab{color:rgb(66,66,66);background-color:rgb(255,171,64)}.mdl-button[disabled][disabled],.mdl-button.mdl-button--disabled.mdl-button--disabled{color:rgba(0,0,0,.26);cursor:default;background-color:transparent}.mdl-button--fab[disabled][disabled],.mdl-button--fab.mdl-button--disabled.mdl-button--disabled{background-color:rgba(0,0,0,.12);color:rgba(0,0,0,.26)}.mdl-button--raised[disabled][disabled],.mdl-button--raised.mdl-button--disabled.mdl-button--disabled{background-color:rgba(0,0,0,.12);color:rgba(0,0,0,.26);box-shadow:none}.mdl-button--colored[disabled][disabled],.mdl-button--colored.mdl-button--disabled.mdl-button--disabled{color:rgba(0,0,0,.26)}.mdl-button .material-icons{vertical-align:middle}.mdl-card{display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-flex-direction:column;-ms-flex-direction:column;flex-direction:column;font-size:16px;font-weight:400;min-height:200px;overflow:hidden;width:330px;z-index:1;position:relative;background:#fff;border-radius:2px;box-sizing:border-box}.mdl-card__media{background-color:rgb(255,171,64);background-repeat:repeat;background-position:50% 50%;background-size:cover;background-origin:padding-box;background-attachment:scroll;box-sizing:border-box}.mdl-card__title{-webkit-align-items:center;-ms-flex-align:center;align-items:center;color:#000;display:block;display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-justify-content:stretch;-ms-flex-pack:stretch;justify-content:stretch;line-height:normal;padding:16px;-webkit-perspective-origin:165px 56px;perspective-origin:165px 56px;-webkit-transform-origin:165px 56px;transform-origin:165px 56px;box-sizing:border-box}.mdl-card__title.mdl-card--border{border-bottom:1px solid rgba(0,0,0,.1)}.mdl-card__title-text{-webkit-align-self:flex-end;-ms-flex-item-align:end;align-self:flex-end;color:inherit;display:block;display:-webkit-flex;display:-ms-flexbox;display:flex;font-size:24px;font-weight:300;line-height:normal;overflow:hidden;-webkit-transform-origin:149px 48px;transform-origin:149px 48px;margin:0}.mdl-card__subtitle-text{font-size:14px;color:rgba(0,0,0,.54);margin:0}.mdl-card__supporting-text{color:rgba(0,0,0,.54);font-size:1rem;line-height:18px;overflow:hidden;padding:16px;width:90%}.mdl-card__supporting-text.mdl-card--border{border-bottom:1px solid rgba(0,0,0,.1)}.mdl-card__actions{font-size:16px;line-height:normal;width:100%;background-color:transparent;padding:8px;box-sizing:border-box}.mdl-card__actions.mdl-card--border{border-top:1px solid rgba(0,0,0,.1)}.mdl-card--expand{-webkit-flex-grow:1;-ms-flex-positive:1;flex-grow:1}.mdl-card__menu{position:absolute;right:16px;top:16px}.mdl-checkbox{position:relative;z-index:1;vertical-align:middle;display:inline-block;box-sizing:border-box;width:100%;height:24px;margin:0;padding:0}.mdl-checkbox.is-upgraded{padding-left:24px}.mdl-checkbox__input{line-height:24px}.mdl-checkbox.is-upgraded .mdl-checkbox__input{position:absolute;width:0;height:0;margin:0;padding:0;opacity:0;-ms-appearance:none;-moz-appearance:none;-webkit-appearance:none;appearance:none;border:none}.mdl-checkbox__box-outline{position:absolute;top:3px;left:0;display:inline-block;box-sizing:border-box;width:16px;height:16px;margin:0;cursor:pointer;overflow:hidden;border:2px solid rgba(0,0,0,.54);border-radius:2px;z-index:2}.mdl-checkbox.is-checked .mdl-checkbox__box-outline{border:2px solid rgb(63,81,181)}fieldset[disabled] .mdl-checkbox .mdl-checkbox__box-outline,.mdl-checkbox.is-disabled .mdl-checkbox__box-outline{border:2px solid rgba(0,0,0,.26);cursor:auto}.mdl-checkbox__focus-helper{position:absolute;top:3px;left:0;display:inline-block;box-sizing:border-box;width:16px;height:16px;border-radius:50%;background-color:transparent}.mdl-checkbox.is-focused .mdl-checkbox__focus-helper{box-shadow:0 0 0 8px rgba(0,0,0,.1);background-color:rgba(0,0,0,.1)}.mdl-checkbox.is-focused.is-checked .mdl-checkbox__focus-helper{box-shadow:0 0 0 8px rgba(63,81,181,.26);background-color:rgba(63,81,181,.26)}.mdl-checkbox__tick-outline{position:absolute;top:0;left:0;height:100%;width:100%;-webkit-mask:url("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjxzdmcKICAgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIgogICB4bWxuczpjYz0iaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbnMjIgogICB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiCiAgIHhtbG5zOnN2Zz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciCiAgIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIKICAgdmVyc2lvbj0iMS4xIgogICB2aWV3Qm94PSIwIDAgMSAxIgogICBwcmVzZXJ2ZUFzcGVjdFJhdGlvPSJ4TWluWU1pbiBtZWV0Ij4KICA8ZGVmcz4KICAgIDxjbGlwUGF0aCBpZD0iY2xpcCI+CiAgICAgIDxwYXRoCiAgICAgICAgIGQ9Ik0gMCwwIDAsMSAxLDEgMSwwIDAsMCB6IE0gMC44NTM0Mzc1LDAuMTY3MTg3NSAwLjk1OTY4NzUsMC4yNzMxMjUgMC40MjkzNzUsMC44MDM0Mzc1IDAuMzIzMTI1LDAuOTA5Njg3NSAwLjIxNzE4NzUsMC44MDM0Mzc1IDAuMDQwMzEyNSwwLjYyNjg3NSAwLjE0NjU2MjUsMC41MjA2MjUgMC4zMjMxMjUsMC42OTc1IDAuODUzNDM3NSwwLjE2NzE4NzUgeiIKICAgICAgICAgc3R5bGU9ImZpbGw6I2ZmZmZmZjtmaWxsLW9wYWNpdHk6MTtzdHJva2U6bm9uZSIgLz4KICAgIDwvY2xpcFBhdGg+CiAgICA8bWFzayBpZD0ibWFzayIgbWFza1VuaXRzPSJvYmplY3RCb3VuZGluZ0JveCIgbWFza0NvbnRlbnRVbml0cz0ib2JqZWN0Qm91bmRpbmdCb3giPgogICAgICA8cGF0aAogICAgICAgICBkPSJNIDAsMCAwLDEgMSwxIDEsMCAwLDAgeiBNIDAuODUzNDM3NSwwLjE2NzE4NzUgMC45NTk2ODc1LDAuMjczMTI1IDAuNDI5Mzc1LDAuODAzNDM3NSAwLjMyMzEyNSwwLjkwOTY4NzUgMC4yMTcxODc1LDAuODAzNDM3NSAwLjA0MDMxMjUsMC42MjY4NzUgMC4xNDY1NjI1LDAuNTIwNjI1IDAuMzIzMTI1LDAuNjk3NSAwLjg1MzQzNzUsMC4xNjcxODc1IHoiCiAgICAgICAgIHN0eWxlPSJmaWxsOiNmZmZmZmY7ZmlsbC1vcGFjaXR5OjE7c3Ryb2tlOm5vbmUiIC8+CiAgICA8L21hc2s+CiAgPC9kZWZzPgogIDxyZWN0CiAgICAgd2lkdGg9IjEiCiAgICAgaGVpZ2h0PSIxIgogICAgIHg9IjAiCiAgICAgeT0iMCIKICAgICBjbGlwLXBhdGg9InVybCgjY2xpcCkiCiAgICAgc3R5bGU9ImZpbGw6IzAwMDAwMDtmaWxsLW9wYWNpdHk6MTtzdHJva2U6bm9uZSIgLz4KPC9zdmc+Cg==");mask:url("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjxzdmcKICAgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIgogICB4bWxuczpjYz0iaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbnMjIgogICB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiCiAgIHhtbG5zOnN2Zz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciCiAgIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIKICAgdmVyc2lvbj0iMS4xIgogICB2aWV3Qm94PSIwIDAgMSAxIgogICBwcmVzZXJ2ZUFzcGVjdFJhdGlvPSJ4TWluWU1pbiBtZWV0Ij4KICA8ZGVmcz4KICAgIDxjbGlwUGF0aCBpZD0iY2xpcCI+CiAgICAgIDxwYXRoCiAgICAgICAgIGQ9Ik0gMCwwIDAsMSAxLDEgMSwwIDAsMCB6IE0gMC44NTM0Mzc1LDAuMTY3MTg3NSAwLjk1OTY4NzUsMC4yNzMxMjUgMC40MjkzNzUsMC44MDM0Mzc1IDAuMzIzMTI1LDAuOTA5Njg3NSAwLjIxNzE4NzUsMC44MDM0Mzc1IDAuMDQwMzEyNSwwLjYyNjg3NSAwLjE0NjU2MjUsMC41MjA2MjUgMC4zMjMxMjUsMC42OTc1IDAuODUzNDM3NSwwLjE2NzE4NzUgeiIKICAgICAgICAgc3R5bGU9ImZpbGw6I2ZmZmZmZjtmaWxsLW9wYWNpdHk6MTtzdHJva2U6bm9uZSIgLz4KICAgIDwvY2xpcFBhdGg+CiAgICA8bWFzayBpZD0ibWFzayIgbWFza1VuaXRzPSJvYmplY3RCb3VuZGluZ0JveCIgbWFza0NvbnRlbnRVbml0cz0ib2JqZWN0Qm91bmRpbmdCb3giPgogICAgICA8cGF0aAogICAgICAgICBkPSJNIDAsMCAwLDEgMSwxIDEsMCAwLDAgeiBNIDAuODUzNDM3NSwwLjE2NzE4NzUgMC45NTk2ODc1LDAuMjczMTI1IDAuNDI5Mzc1LDAuODAzNDM3NSAwLjMyMzEyNSwwLjkwOTY4NzUgMC4yMTcxODc1LDAuODAzNDM3NSAwLjA0MDMxMjUsMC42MjY4NzUgMC4xNDY1NjI1LDAuNTIwNjI1IDAuMzIzMTI1LDAuNjk3NSAwLjg1MzQzNzUsMC4xNjcxODc1IHoiCiAgICAgICAgIHN0eWxlPSJmaWxsOiNmZmZmZmY7ZmlsbC1vcGFjaXR5OjE7c3Ryb2tlOm5vbmUiIC8+CiAgICA8L21hc2s+CiAgPC9kZWZzPgogIDxyZWN0CiAgICAgd2lkdGg9IjEiCiAgICAgaGVpZ2h0PSIxIgogICAgIHg9IjAiCiAgICAgeT0iMCIKICAgICBjbGlwLXBhdGg9InVybCgjY2xpcCkiCiAgICAgc3R5bGU9ImZpbGw6IzAwMDAwMDtmaWxsLW9wYWNpdHk6MTtzdHJva2U6bm9uZSIgLz4KPC9zdmc+Cg==");background:0 0;transition-duration:.28s;transition-timing-function:cubic-bezier(.4,0,.2,1);transition-property:background}.mdl-checkbox.is-checked .mdl-checkbox__tick-outline{background:rgb(63,81,181)url("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjxzdmcKICAgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIgogICB4bWxuczpjYz0iaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbnMjIgogICB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiCiAgIHhtbG5zOnN2Zz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciCiAgIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIKICAgdmVyc2lvbj0iMS4xIgogICB2aWV3Qm94PSIwIDAgMSAxIgogICBwcmVzZXJ2ZUFzcGVjdFJhdGlvPSJ4TWluWU1pbiBtZWV0Ij4KICA8cGF0aAogICAgIGQ9Ik0gMC4wNDAzODA1OSwwLjYyNjc3NjcgMC4xNDY0NDY2MSwwLjUyMDcxMDY4IDAuNDI5Mjg5MzIsMC44MDM1NTMzOSAwLjMyMzIyMzMsMC45MDk2MTk0MSB6IE0gMC4yMTcxNTcyOSwwLjgwMzU1MzM5IDAuODUzNTUzMzksMC4xNjcxNTcyOSAwLjk1OTYxOTQxLDAuMjczMjIzMyAwLjMyMzIyMzMsMC45MDk2MTk0MSB6IgogICAgIGlkPSJyZWN0Mzc4MCIKICAgICBzdHlsZT0iZmlsbDojZmZmZmZmO2ZpbGwtb3BhY2l0eToxO3N0cm9rZTpub25lIiAvPgo8L3N2Zz4K")}fieldset[disabled] .mdl-checkbox.is-checked .mdl-checkbox__tick-outline,.mdl-checkbox.is-checked.is-disabled .mdl-checkbox__tick-outline{background:rgba(0,0,0,.26)url("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjxzdmcKICAgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIgogICB4bWxuczpjYz0iaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbnMjIgogICB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiCiAgIHhtbG5zOnN2Zz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciCiAgIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIKICAgdmVyc2lvbj0iMS4xIgogICB2aWV3Qm94PSIwIDAgMSAxIgogICBwcmVzZXJ2ZUFzcGVjdFJhdGlvPSJ4TWluWU1pbiBtZWV0Ij4KICA8cGF0aAogICAgIGQ9Ik0gMC4wNDAzODA1OSwwLjYyNjc3NjcgMC4xNDY0NDY2MSwwLjUyMDcxMDY4IDAuNDI5Mjg5MzIsMC44MDM1NTMzOSAwLjMyMzIyMzMsMC45MDk2MTk0MSB6IE0gMC4yMTcxNTcyOSwwLjgwMzU1MzM5IDAuODUzNTUzMzksMC4xNjcxNTcyOSAwLjk1OTYxOTQxLDAuMjczMjIzMyAwLjMyMzIyMzMsMC45MDk2MTk0MSB6IgogICAgIGlkPSJyZWN0Mzc4MCIKICAgICBzdHlsZT0iZmlsbDojZmZmZmZmO2ZpbGwtb3BhY2l0eToxO3N0cm9rZTpub25lIiAvPgo8L3N2Zz4K")}.mdl-checkbox__label{position:relative;cursor:pointer;font-size:16px;line-height:24px;margin:0}fieldset[disabled] .mdl-checkbox .mdl-checkbox__label,.mdl-checkbox.is-disabled .mdl-checkbox__label{color:rgba(0,0,0,.26);cursor:auto}.mdl-checkbox__ripple-container{position:absolute;z-index:2;top:-6px;left:-10px;box-sizing:border-box;width:36px;height:36px;border-radius:50%;cursor:pointer;overflow:hidden;-webkit-mask-image:-webkit-radial-gradient(circle,#fff,#000)}.mdl-checkbox__ripple-container .mdl-ripple{background:rgb(63,81,181)}fieldset[disabled] .mdl-checkbox .mdl-checkbox__ripple-container,.mdl-checkbox.is-disabled .mdl-checkbox__ripple-container{cursor:auto}fieldset[disabled] .mdl-checkbox .mdl-checkbox__ripple-container .mdl-ripple,.mdl-checkbox.is-disabled .mdl-checkbox__ripple-container .mdl-ripple{background:0 0}.mdl-chip{height:32px;font-family:"Roboto","Helvetica","Arial",sans-serif;line-height:32px;padding:0 12px;border:0;border-radius:16px;background-color:#dedede;display:inline-block;color:rgba(0,0,0,.87);margin:2px 0;font-size:0;white-space:nowrap}.mdl-chip__text{font-size:13px;vertical-align:middle;display:inline-block}.mdl-chip__action{height:24px;width:24px;background:0 0;opacity:.54;cursor:pointer;padding:0;margin:0 0 0 4px;font-size:13px;text-decoration:none;color:rgba(0,0,0,.87);border:none;outline:none}.mdl-chip__action,.mdl-chip__contact{display:inline-block;vertical-align:middle;overflow:hidden;text-align:center}.mdl-chip__contact{height:32px;width:32px;border-radius:16px;margin-right:8px;font-size:18px;line-height:32px}.mdl-chip:focus{outline:0;box-shadow:0 2px 2px 0 rgba(0,0,0,.14),0 3px 1px -2px rgba(0,0,0,.2),0 1px 5px 0 rgba(0,0,0,.12)}.mdl-chip:active{background-color:#d6d6d6}.mdl-chip--deletable{padding-right:4px}.mdl-chip--contact{padding-left:0}.mdl-data-table{position:relative;border:1px solid rgba(0,0,0,.12);border-collapse:collapse;white-space:nowrap;font-size:13px;background-color:#fff}.mdl-data-table thead{padding-bottom:3px}.mdl-data-table thead .mdl-data-table__select{margin-top:0}.mdl-data-table tbody tr{position:relative;height:48px;transition-duration:.28s;transition-timing-function:cubic-bezier(.4,0,.2,1);transition-property:background-color}.mdl-data-table tbody tr.is-selected{background-color:#e0e0e0}.mdl-data-table tbody tr:hover{background-color:#eee}.mdl-data-table td{text-align:right}.mdl-data-table th{padding:0 18px 12px 18px;text-align:right}.mdl-data-table td:first-of-type,.mdl-data-table th:first-of-type{padding-left:24px}.mdl-data-table td:last-of-type,.mdl-data-table th:last-of-type{padding-right:24px}.mdl-data-table td{position:relative;height:48px;border-top:1px solid rgba(0,0,0,.12);border-bottom:1px solid rgba(0,0,0,.12);padding:12px 18px;box-sizing:border-box}.mdl-data-table td,.mdl-data-table td .mdl-data-table__select{vertical-align:middle}.mdl-data-table th{position:relative;vertical-align:bottom;text-overflow:ellipsis;font-weight:700;line-height:24px;letter-spacing:0;height:48px;font-size:12px;color:rgba(0,0,0,.54);padding-bottom:8px;box-sizing:border-box}.mdl-data-table th.mdl-data-table__header--sorted-ascending,.mdl-data-table th.mdl-data-table__header--sorted-descending{color:rgba(0,0,0,.87)}.mdl-data-table th.mdl-data-table__header--sorted-ascending:before,.mdl-data-table th.mdl-data-table__header--sorted-descending:before{font-family:''Material Icons'';font-weight:400;font-style:normal;line-height:1;letter-spacing:normal;text-transform:none;display:inline-block;word-wrap:normal;-moz-font-feature-settings:''liga'';font-feature-settings:''liga'';-webkit-font-feature-settings:''liga'';-webkit-font-smoothing:antialiased;font-size:16px;content:"\e5d8";margin-right:5px;vertical-align:sub}.mdl-data-table th.mdl-data-table__header--sorted-ascending:hover,.mdl-data-table th.mdl-data-table__header--sorted-descending:hover{cursor:pointer}.mdl-data-table th.mdl-data-table__header--sorted-ascending:hover:before,.mdl-data-table th.mdl-data-table__header--sorted-descending:hover:before{color:rgba(0,0,0,.26)}.mdl-data-table th.mdl-data-table__header--sorted-descending:before{content:"\e5db"}.mdl-data-table__select{width:16px}.mdl-data-table__cell--non-numeric.mdl-data-table__cell--non-numeric{text-align:left}.mdl-dialog{border:none;box-shadow:0 9px 46px 8px rgba(0,0,0,.14),0 11px 15px -7px rgba(0,0,0,.12),0 24px 38px 3px rgba(0,0,0,.2);width:280px}.mdl-dialog__title{padding:24px 24px 0;margin:0;font-size:2.5rem}.mdl-dialog__actions{padding:8px 8px 8px 24px;display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-flex-direction:row-reverse;-ms-flex-direction:row-reverse;flex-direction:row-reverse;-webkit-flex-wrap:wrap;-ms-flex-wrap:wrap;flex-wrap:wrap}.mdl-dialog__actions>*{margin-right:8px;height:36px}.mdl-dialog__actions>*:first-child{margin-right:0}.mdl-dialog__actions--full-width{padding:0 0 8px}.mdl-dialog__actions--full-width>*{height:48px;-webkit-flex:0 0 100%;-ms-flex:0 0 100%;flex:0 0 100%;padding-right:16px;margin-right:0;text-align:right}.mdl-dialog__content{padding:20px 24px 24px;color:rgba(0,0,0,.54)}.mdl-mega-footer{padding:16px 40px;color:#9e9e9e;background-color:#424242}.mdl-mega-footer--top-section:after,.mdl-mega-footer--middle-section:after,.mdl-mega-footer--bottom-section:after,.mdl-mega-footer__top-section:after,.mdl-mega-footer__middle-section:after,.mdl-mega-footer__bottom-section:after{content:'''';display:block;clear:both}.mdl-mega-footer--left-section,.mdl-mega-footer__left-section,.mdl-mega-footer--right-section,.mdl-mega-footer__right-section{margin-bottom:16px}.mdl-mega-footer--right-section a,.mdl-mega-footer__right-section a{display:block;margin-bottom:16px;color:inherit;text-decoration:none}@media screen and (min-width:760px){.mdl-mega-footer--left-section,.mdl-mega-footer__left-section{float:left}.mdl-mega-footer--right-section,.mdl-mega-footer__right-section{float:right}.mdl-mega-footer--right-section a,.mdl-mega-footer__right-section a{display:inline-block;margin-left:16px;line-height:36px;vertical-align:middle}}.mdl-mega-footer--social-btn,.mdl-mega-footer__social-btn{width:36px;height:36px;padding:0;margin:0;background-color:#9e9e9e;border:none}.mdl-mega-footer--drop-down-section,.mdl-mega-footer__drop-down-section{display:block;position:relative}@media screen and (min-width:760px){.mdl-mega-footer--drop-down-section,.mdl-mega-footer__drop-down-section{width:33%}.mdl-mega-footer--drop-down-section:nth-child(1),.mdl-mega-footer--drop-down-section:nth-child(2),.mdl-mega-footer__drop-down-section:nth-child(1),.mdl-mega-footer__drop-down-section:nth-child(2){float:left}.mdl-mega-footer--drop-down-section:nth-child(3),.mdl-mega-footer__drop-down-section:nth-child(3){float:right}.mdl-mega-footer--drop-down-section:nth-child(3):after,.mdl-mega-footer__drop-down-section:nth-child(3):after{clear:right}.mdl-mega-footer--drop-down-section:nth-child(4),.mdl-mega-footer__drop-down-section:nth-child(4){clear:right;float:right}.mdl-mega-footer--middle-section:after,.mdl-mega-footer__middle-section:after{content:'''';display:block;clear:both}.mdl-mega-footer--bottom-section,.mdl-mega-footer__bottom-section{padding-top:0}}@media screen and (min-width:1024px){.mdl-mega-footer--drop-down-section,.mdl-mega-footer--drop-down-section:nth-child(3),.mdl-mega-footer--drop-down-section:nth-child(4),.mdl-mega-footer__drop-down-section,.mdl-mega-footer__drop-down-section:nth-child(3),.mdl-mega-footer__drop-down-section:nth-child(4){width:24%;float:left}}.mdl-mega-footer--heading-checkbox,.mdl-mega-footer__heading-checkbox{position:absolute;width:100%;height:55.8px;padding:32px;margin:-16px 0 0;cursor:pointer;z-index:1;opacity:0}.mdl-mega-footer--heading-checkbox+.mdl-mega-footer--heading:after,.mdl-mega-footer--heading-checkbox+.mdl-mega-footer__heading:after,.mdl-mega-footer__heading-checkbox+.mdl-mega-footer--heading:after,.mdl-mega-footer__heading-checkbox+.mdl-mega-footer__heading:after{font-family:''Material Icons'';content:''\E5CE''}.mdl-mega-footer--heading-checkbox:checked~.mdl-mega-footer--link-list,.mdl-mega-footer--heading-checkbox:checked~.mdl-mega-footer__link-list,.mdl-mega-footer--heading-checkbox:checked+.mdl-mega-footer--heading+.mdl-mega-footer--link-list,.mdl-mega-footer--heading-checkbox:checked+.mdl-mega-footer__heading+.mdl-mega-footer__link-list,.mdl-mega-footer__heading-checkbox:checked~.mdl-mega-footer--link-list,.mdl-mega-footer__heading-checkbox:checked~.mdl-mega-footer__link-list,.mdl-mega-footer__heading-checkbox:checked+.mdl-mega-footer--heading+.mdl-mega-footer--link-list,.mdl-mega-footer__heading-checkbox:checked+.mdl-mega-footer__heading+.mdl-mega-footer__link-list{display:none}.mdl-mega-footer--heading-checkbox:checked+.mdl-mega-footer--heading:after,.mdl-mega-footer--heading-checkbox:checked+.mdl-mega-footer__heading:after,.mdl-mega-footer__heading-checkbox:checked+.mdl-mega-footer--heading:after,.mdl-mega-footer__heading-checkbox:checked+.mdl-mega-footer__heading:after{font-family:''Material Icons'';content:''\E5CF''}.mdl-mega-footer--heading,.mdl-mega-footer__heading{position:relative;width:100%;padding-right:39.8px;margin-bottom:16px;box-sizing:border-box;font-size:14px;line-height:23.8px;font-weight:500;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;color:#e0e0e0}.mdl-mega-footer--heading:after,.mdl-mega-footer__heading:after{content:'''';position:absolute;top:0;right:0;display:block;width:23.8px;height:23.8px;background-size:cover}.mdl-mega-footer--link-list,.mdl-mega-footer__link-list{list-style:none;padding:0;margin:0 0 32px}.mdl-mega-footer--link-list:after,.mdl-mega-footer__link-list:after{clear:both;display:block;content:''''}.mdl-mega-footer--link-list li,.mdl-mega-footer__link-list li{font-size:14px;font-weight:400;letter-spacing:0;line-height:20px}.mdl-mega-footer--link-list a,.mdl-mega-footer__link-list a{color:inherit;text-decoration:none;white-space:nowrap}@media screen and (min-width:760px){.mdl-mega-footer--heading-checkbox,.mdl-mega-footer__heading-checkbox{display:none}.mdl-mega-footer--heading-checkbox+.mdl-mega-footer--heading:after,.mdl-mega-footer--heading-checkbox+.mdl-mega-footer__heading:after,.mdl-mega-footer__heading-checkbox+.mdl-mega-footer--heading:after,.mdl-mega-footer__heading-checkbox+.mdl-mega-footer__heading:after{content:''''}.mdl-mega-footer--heading-checkbox:checked~.mdl-mega-footer--link-list,.mdl-mega-footer--heading-checkbox:checked~.mdl-mega-footer__link-list,.mdl-mega-footer--heading-checkbox:checked+.mdl-mega-footer__heading+.mdl-mega-footer__link-list,.mdl-mega-footer--heading-checkbox:checked+.mdl-mega-footer--heading+.mdl-mega-footer--link-list,.mdl-mega-footer__heading-checkbox:checked~.mdl-mega-footer--link-list,.mdl-mega-footer__heading-checkbox:checked~.mdl-mega-footer__link-list,.mdl-mega-footer__heading-checkbox:checked+.mdl-mega-footer__heading+.mdl-mega-footer__link-list,.mdl-mega-footer__heading-checkbox:checked+.mdl-mega-footer--heading+.mdl-mega-footer--link-list{display:block}.mdl-mega-footer--heading-checkbox:checked+.mdl-mega-footer--heading:after,.mdl-mega-footer--heading-checkbox:checked+.mdl-mega-footer__heading:after,.mdl-mega-footer__heading-checkbox:checked+.mdl-mega-footer--heading:after,.mdl-mega-footer__heading-checkbox:checked+.mdl-mega-footer__heading:after{content:''''}}.mdl-mega-footer--bottom-section,.mdl-mega-footer__bottom-section{padding-top:16px;margin-bottom:16px}.mdl-logo{margin-bottom:16px;color:#fff}.mdl-mega-footer--bottom-section .mdl-mega-footer--link-list li,.mdl-mega-footer__bottom-section .mdl-mega-footer__link-list li{float:left;margin-bottom:0;margin-right:16px}@media screen and (min-width:760px){.mdl-logo{float:left;margin-bottom:0;margin-right:16px}}.mdl-mini-footer{display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-flex-flow:row wrap;-ms-flex-flow:row wrap;flex-flow:row wrap;-webkit-justify-content:space-between;-ms-flex-pack:justify;justify-content:space-between;padding:32px 16px;color:#9e9e9e;background-color:#424242}.mdl-mini-footer:after{content:'''';display:block}.mdl-mini-footer .mdl-logo{line-height:36px}.mdl-mini-footer--link-list,.mdl-mini-footer__link-list{display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-flex-flow:row nowrap;-ms-flex-flow:row nowrap;flex-flow:row nowrap;list-style:none;margin:0;padding:0}.mdl-mini-footer--link-list li,.mdl-mini-footer__link-list li{margin-bottom:0;margin-right:16px}@media screen and (min-width:760px){.mdl-mini-footer--link-list li,.mdl-mini-footer__link-list li{line-height:36px}}.mdl-mini-footer--link-list a,.mdl-mini-footer__link-list a{color:inherit;text-decoration:none;white-space:nowrap}.mdl-mini-footer--left-section,.mdl-mini-footer__left-section{display:inline-block;-webkit-order:0;-ms-flex-order:0;order:0}.mdl-mini-footer--right-section,.mdl-mini-footer__right-section{display:inline-block;-webkit-order:1;-ms-flex-order:1;order:1}.mdl-mini-footer--social-btn,.mdl-mini-footer__social-btn{width:36px;height:36px;padding:0;margin:0;background-color:#9e9e9e;border:none}.mdl-icon-toggle{position:relative;z-index:1;vertical-align:middle;display:inline-block;height:32px;margin:0;padding:0}.mdl-icon-toggle__input{line-height:32px}.mdl-icon-toggle.is-upgraded .mdl-icon-toggle__input{position:absolute;width:0;height:0;margin:0;padding:0;opacity:0;-ms-appearance:none;-moz-appearance:none;-webkit-appearance:none;appearance:none;border:none}.mdl-icon-toggle__label{display:inline-block;position:relative;cursor:pointer;height:32px;width:32px;min-width:32px;color:#616161;border-radius:50%;padding:0;margin-left:0;margin-right:0;text-align:center;background-color:transparent;will-change:background-color;transition:background-color .2s cubic-bezier(.4,0,.2,1),color .2s cubic-bezier(.4,0,.2,1)}.mdl-icon-toggle__label.material-icons{line-height:32px;font-size:24px}.mdl-icon-toggle.is-checked .mdl-icon-toggle__label{color:rgb(63,81,181)}.mdl-icon-toggle.is-disabled .mdl-icon-toggle__label{color:rgba(0,0,0,.26);cursor:auto;transition:none}.mdl-icon-toggle.is-focused .mdl-icon-toggle__label{background-color:rgba(0,0,0,.12)}.mdl-icon-toggle.is-focused.is-checked .mdl-icon-toggle__label{background-color:rgba(63,81,181,.26)}.mdl-icon-toggle__ripple-container{position:absolute;z-index:2;top:-2px;left:-2px;box-sizing:border-box;width:36px;height:36px;border-radius:50%;cursor:pointer;overflow:hidden;-webkit-mask-image:-webkit-radial-gradient(circle,#fff,#000)}.mdl-icon-toggle__ripple-container .mdl-ripple{background:#616161}.mdl-icon-toggle.is-disabled .mdl-icon-toggle__ripple-container{cursor:auto}.mdl-icon-toggle.is-disabled .mdl-icon-toggle__ripple-container .mdl-ripple{background:0 0}.mdl-list{display:block;padding:8px 0;list-style:none}.mdl-list__item{font-family:"Roboto","Helvetica","Arial",sans-serif;font-size:16px;font-weight:400;letter-spacing:.04em;line-height:1;min-height:48px;-webkit-flex-direction:row;-ms-flex-direction:row;flex-direction:row;-webkit-flex-wrap:nowrap;-ms-flex-wrap:nowrap;flex-wrap:nowrap;padding:16px;cursor:default;color:rgba(0,0,0,.87);overflow:hidden}.mdl-list__item,.mdl-list__item .mdl-list__item-primary-content{box-sizing:border-box;display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-align-items:center;-ms-flex-align:center;align-items:center}.mdl-list__item .mdl-list__item-primary-content{-webkit-order:0;-ms-flex-order:0;order:0;-webkit-flex-grow:2;-ms-flex-positive:2;flex-grow:2;text-decoration:none}.mdl-list__item .mdl-list__item-primary-content .mdl-list__item-icon{margin-right:32px}.mdl-list__item .mdl-list__item-primary-content .mdl-list__item-avatar{margin-right:16px}.mdl-list__item .mdl-list__item-secondary-content{display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-flex-flow:column;-ms-flex-flow:column;flex-flow:column;-webkit-align-items:flex-end;-ms-flex-align:end;align-items:flex-end;margin-left:16px}.mdl-list__item .mdl-list__item-secondary-content .mdl-list__item-secondary-action label{display:inline}.mdl-list__item .mdl-list__item-secondary-content .mdl-list__item-secondary-info{font-size:12px;font-weight:400;line-height:1;letter-spacing:0;color:rgba(0,0,0,.54)}.mdl-list__item .mdl-list__item-secondary-content .mdl-list__item-sub-header{padding:0 0 0 16px}.mdl-list__item-icon,.mdl-list__item-icon.material-icons{height:24px;width:24px;font-size:24px;box-sizing:border-box;color:#757575}.mdl-list__item-avatar,.mdl-list__item-avatar.material-icons{height:40px;width:40px;box-sizing:border-box;border-radius:50%;background-color:#757575;font-size:40px;color:#fff}.mdl-list__item--two-line{height:72px}.mdl-list__item--two-line .mdl-list__item-primary-content{height:36px;line-height:20px;display:block}.mdl-list__item--two-line .mdl-list__item-primary-content .mdl-list__item-avatar{float:left}.mdl-list__item--two-line .mdl-list__item-primary-content .mdl-list__item-icon{float:left;margin-top:6px}.mdl-list__item--two-line .mdl-list__item-primary-content .mdl-list__item-secondary-content{height:36px}.mdl-list__item--two-line .mdl-list__item-primary-content .mdl-list__item-sub-title{font-size:14px;font-weight:400;letter-spacing:0;line-height:18px;color:rgba(0,0,0,.54);display:block;padding:0}.mdl-list__item--three-line{height:88px}.mdl-list__item--three-line .mdl-list__item-primary-content{height:52px;line-height:20px;display:block}.mdl-list__item--three-line .mdl-list__item-primary-content .mdl-list__item-avatar,.mdl-list__item--three-line .mdl-list__item-primary-content .mdl-list__item-icon{float:left}.mdl-list__item--three-line .mdl-list__item-secondary-content{height:52px}.mdl-list__item--three-line .mdl-list__item-text-body{font-size:14px;font-weight:400;letter-spacing:0;line-height:18px;height:52px;color:rgba(0,0,0,.54);display:block;padding:0}.mdl-menu__container{display:block;margin:0;padding:0;border:none;position:absolute;overflow:visible;height:0;width:0;visibility:hidden;z-index:-1}.mdl-menu__container.is-visible,.mdl-menu__container.is-animating{z-index:999;visibility:visible}.mdl-menu__outline{display:block;background:#fff;margin:0;padding:0;border:none;border-radius:2px;position:absolute;top:0;left:0;overflow:hidden;opacity:0;-webkit-transform:scale(0);transform:scale(0);-webkit-transform-origin:0 0;transform-origin:0 0;box-shadow:0 2px 2px 0 rgba(0,0,0,.14),0 3px 1px -2px rgba(0,0,0,.2),0 1px 5px 0 rgba(0,0,0,.12);will-change:transform;transition:transform .3s cubic-bezier(.4,0,.2,1),opacity .2s cubic-bezier(.4,0,.2,1);transition:transform .3s cubic-bezier(.4,0,.2,1),opacity .2s cubic-bezier(.4,0,.2,1),-webkit-transform .3s cubic-bezier(.4,0,.2,1);z-index:-1}.mdl-menu__container.is-visible .mdl-menu__outline{opacity:1;-webkit-transform:scale(1);transform:scale(1);z-index:999}.mdl-menu__outline.mdl-menu--bottom-right{-webkit-transform-origin:100% 0;transform-origin:100% 0}.mdl-menu__outline.mdl-menu--top-left{-webkit-transform-origin:0 100%;transform-origin:0 100%}.mdl-menu__outline.mdl-menu--top-right{-webkit-transform-origin:100% 100%;transform-origin:100% 100%}.mdl-menu{position:absolute;list-style:none;top:0;left:0;height:auto;width:auto;min-width:124px;padding:8px 0;margin:0;opacity:0;clip:rect(0 0 0 0);z-index:-1}.mdl-menu__container.is-visible .mdl-menu{opacity:1;z-index:999}.mdl-menu.is-animating{transition:opacity .2s cubic-bezier(.4,0,.2,1),clip .3s cubic-bezier(.4,0,.2,1)}.mdl-menu.mdl-menu--bottom-right{left:auto;right:0}.mdl-menu.mdl-menu--top-left{top:auto;bottom:0}.mdl-menu.mdl-menu--top-right{top:auto;left:auto;bottom:0;right:0}.mdl-menu.mdl-menu--unaligned{top:auto;left:auto}.mdl-menu__item{display:block;border:none;color:rgba(0,0,0,.87);background-color:transparent;text-align:left;margin:0;padding:0 16px;outline-color:#bdbdbd;position:relative;overflow:hidden;font-size:14px;font-weight:400;letter-spacing:0;text-decoration:none;cursor:pointer;height:48px;line-height:48px;white-space:nowrap;opacity:0;transition:opacity .2s cubic-bezier(.4,0,.2,1);-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none}.mdl-menu__container.is-visible .mdl-menu__item{opacity:1}.mdl-menu__item::-moz-focus-inner{border:0}.mdl-menu__item--full-bleed-divider{border-bottom:1px solid rgba(0,0,0,.12)}.mdl-menu__item[disabled],.mdl-menu__item[data-mdl-disabled]{color:#bdbdbd;background-color:transparent;cursor:auto}.mdl-menu__item[disabled]:hover,.mdl-menu__item[data-mdl-disabled]:hover{background-color:transparent}.mdl-menu__item[disabled]:focus,.mdl-menu__item[data-mdl-disabled]:focus{background-color:transparent}.mdl-menu__item[disabled] .mdl-ripple,.mdl-menu__item[data-mdl-disabled] .mdl-ripple{background:0 0}.mdl-menu__item:hover{background-color:#eee}.mdl-menu__item:focus{outline:none;background-color:#eee}.mdl-menu__item:active{background-color:#e0e0e0}.mdl-menu__item--ripple-container{display:block;height:100%;left:0;position:absolute;top:0;width:100%;z-index:0;overflow:hidden}.mdl-progress{display:block;position:relative;height:4px;width:500px;max-width:100%}.mdl-progress>.bar{display:block;position:absolute;top:0;bottom:0;width:0%;transition:width .2s cubic-bezier(.4,0,.2,1)}.mdl-progress>.progressbar{background-color:rgb(63,81,181);z-index:1;left:0}.mdl-progress>.bufferbar{background-image:linear-gradient(to right,rgba(255,255,255,.7),rgba(255,255,255,.7)),linear-gradient(to right,rgb(63,81,181),rgb(63,81,181));z-index:0;left:0}.mdl-progress>.auxbar{right:0}@supports (-webkit-appearance:none){.mdl-progress:not(.mdl-progress--indeterminate):not(.mdl-progress--indeterminate)>.auxbar,.mdl-progress:not(.mdl-progress__indeterminate):not(.mdl-progress__indeterminate)>.auxbar{background-image:linear-gradient(to right,rgba(255,255,255,.7),rgba(255,255,255,.7)),linear-gradient(to right,rgb(63,81,181),rgb(63,81,181));-webkit-mask:url("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+Cjxzdmcgd2lkdGg9IjEyIiBoZWlnaHQ9IjQiIHZpZXdQb3J0PSIwIDAgMTIgNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxlbGxpcHNlIGN4PSIyIiBjeT0iMiIgcng9IjIiIHJ5PSIyIj4KICAgIDxhbmltYXRlIGF0dHJpYnV0ZU5hbWU9ImN4IiBmcm9tPSIyIiB0bz0iLTEwIiBkdXI9IjAuNnMiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiAvPgogIDwvZWxsaXBzZT4KICA8ZWxsaXBzZSBjeD0iMTQiIGN5PSIyIiByeD0iMiIgcnk9IjIiIGNsYXNzPSJsb2FkZXIiPgogICAgPGFuaW1hdGUgYXR0cmlidXRlTmFtZT0iY3giIGZyb209IjE0IiB0bz0iMiIgZHVyPSIwLjZzIiByZXBlYXRDb3VudD0iaW5kZWZpbml0ZSIgLz4KICA8L2VsbGlwc2U+Cjwvc3ZnPgo=");mask:url("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+Cjxzdmcgd2lkdGg9IjEyIiBoZWlnaHQ9IjQiIHZpZXdQb3J0PSIwIDAgMTIgNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxlbGxpcHNlIGN4PSIyIiBjeT0iMiIgcng9IjIiIHJ5PSIyIj4KICAgIDxhbmltYXRlIGF0dHJpYnV0ZU5hbWU9ImN4IiBmcm9tPSIyIiB0bz0iLTEwIiBkdXI9IjAuNnMiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiAvPgogIDwvZWxsaXBzZT4KICA8ZWxsaXBzZSBjeD0iMTQiIGN5PSIyIiByeD0iMiIgcnk9IjIiIGNsYXNzPSJsb2FkZXIiPgogICAgPGFuaW1hdGUgYXR0cmlidXRlTmFtZT0iY3giIGZyb209IjE0IiB0bz0iMiIgZHVyPSIwLjZzIiByZXBlYXRDb3VudD0iaW5kZWZpbml0ZSIgLz4KICA8L2VsbGlwc2U+Cjwvc3ZnPgo=")}}.mdl-progress:not(.mdl-progress--indeterminate)>.auxbar,.mdl-progress:not(.mdl-progress__indeterminate)>.auxbar{background-image:linear-gradient(to right,rgba(255,255,255,.9),rgba(255,255,255,.9)),linear-gradient(to right,rgb(63,81,181),rgb(63,81,181))}.mdl-progress.mdl-progress--indeterminate>.bar1,.mdl-progress.mdl-progress__indeterminate>.bar1{-webkit-animation-name:indeterminate1;animation-name:indeterminate1}.mdl-progress.mdl-progress--indeterminate>.bar1,.mdl-progress.mdl-progress__indeterminate>.bar1,.mdl-progress.mdl-progress--indeterminate>.bar3,.mdl-progress.mdl-progress__indeterminate>.bar3{background-color:rgb(63,81,181);-webkit-animation-duration:2s;animation-duration:2s;-webkit-animation-iteration-count:infinite;animation-iteration-count:infinite;-webkit-animation-timing-function:linear;animation-timing-function:linear}.mdl-progress.mdl-progress--indeterminate>.bar3,.mdl-progress.mdl-progress__indeterminate>.bar3{background-image:none;-webkit-animation-name:indeterminate2;animation-name:indeterminate2}@-webkit-keyframes indeterminate1{0%{left:0%;width:0%}50%{left:25%;width:75%}75%{left:100%;width:0%}}@keyframes indeterminate1{0%{left:0%;width:0%}50%{left:25%;width:75%}75%{left:100%;width:0%}}@-webkit-keyframes indeterminate2{0%,50%{left:0%;width:0%}75%{left:0%;width:25%}100%{left:100%;width:0%}}@keyframes indeterminate2{0%,50%{left:0%;width:0%}75%{left:0%;width:25%}100%{left:100%;width:0%}}.mdl-navigation{display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-flex-wrap:nowrap;-ms-flex-wrap:nowrap;flex-wrap:nowrap;box-sizing:border-box}.mdl-navigation__link{color:#424242;text-decoration:none;margin:0;font-size:14px;font-weight:400;line-height:24px;letter-spacing:0;opacity:.87}.mdl-navigation__link .material-icons{vertical-align:middle}.mdl-layout{width:100%;height:100%;display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-flex-direction:column;-ms-flex-direction:column;flex-direction:column;overflow-y:auto;overflow-x:hidden;position:relative;-webkit-overflow-scrolling:touch}.mdl-layout.is-small-screen .mdl-layout--large-screen-only{display:none}.mdl-layout:not(.is-small-screen) .mdl-layout--small-screen-only{display:none}.mdl-layout__container{position:absolute;width:100%;height:100%}.mdl-layout__title,.mdl-layout-title{display:block;position:relative;font-family:"Roboto","Helvetica","Arial",sans-serif;font-size:20px;line-height:1;letter-spacing:.02em;font-weight:400;box-sizing:border-box}.mdl-layout-spacer{-webkit-flex-grow:1;-ms-flex-positive:1;flex-grow:1}.mdl-layout__drawer{display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-flex-direction:column;-ms-flex-direction:column;flex-direction:column;-webkit-flex-wrap:nowrap;-ms-flex-wrap:nowrap;flex-wrap:nowrap;width:240px;height:100%;max-height:100%;position:absolute;top:0;left:0;box-shadow:0 2px 2px 0 rgba(0,0,0,.14),0 3px 1px -2px rgba(0,0,0,.2),0 1px 5px 0 rgba(0,0,0,.12);box-sizing:border-box;border-right:1px solid #e0e0e0;background:#fafafa;-webkit-transform:translateX(-250px);transform:translateX(-250px);-webkit-transform-style:preserve-3d;transform-style:preserve-3d;will-change:transform;transition-duration:.2s;transition-timing-function:cubic-bezier(.4,0,.2,1);transition-property:transform;transition-property:transform,-webkit-transform;color:#424242;overflow:visible;overflow-y:auto;z-index:5}.mdl-layout__drawer.is-visible{-webkit-transform:translateX(0);transform:translateX(0)}.mdl-layout__drawer.is-visible~.mdl-layout__content.mdl-layout__content{overflow:hidden}.mdl-layout__drawer>*{-webkit-flex-shrink:0;-ms-flex-negative:0;flex-shrink:0}.mdl-layout__drawer>.mdl-layout__title,.mdl-layout__drawer>.mdl-layout-title{line-height:64px;padding-left:40px}@media screen and (max-width:1024px){.mdl-layout__drawer>.mdl-layout__title,.mdl-layout__drawer>.mdl-layout-title{line-height:56px;padding-left:16px}}.mdl-layout__drawer .mdl-navigation{-webkit-flex-direction:column;-ms-flex-direction:column;flex-direction:column;-webkit-align-items:stretch;-ms-flex-align:stretch;align-items:stretch;padding-top:16px}.mdl-layout__drawer .mdl-navigation .mdl-navigation__link{display:block;-webkit-flex-shrink:0;-ms-flex-negative:0;flex-shrink:0;padding:16px 40px;margin:0;color:#757575}@media screen and (max-width:1024px){.mdl-layout__drawer .mdl-navigation .mdl-navigation__link{padding:16px}}.mdl-layout__drawer .mdl-navigation .mdl-navigation__link:hover{background-color:#e0e0e0}.mdl-layout__drawer .mdl-navigation .mdl-navigation__link--current{background-color:#e0e0e0;color:#000}@media screen and (min-width:1025px){.mdl-layout--fixed-drawer>.mdl-layout__drawer{-webkit-transform:translateX(0);transform:translateX(0)}}.mdl-layout__drawer-button{display:block;position:absolute;height:48px;width:48px;border:0;-webkit-flex-shrink:0;-ms-flex-negative:0;flex-shrink:0;overflow:hidden;text-align:center;cursor:pointer;font-size:26px;line-height:56px;font-family:Helvetica,Arial,sans-serif;margin:8px 12px;top:0;left:0;color:rgb(255,255,255);z-index:4}.mdl-layout__header .mdl-layout__drawer-button{position:absolute;color:rgb(255,255,255);background-color:inherit}@media screen and (max-width:1024px){.mdl-layout__header .mdl-layout__drawer-button{margin:4px}}@media screen and (max-width:1024px){.mdl-layout__drawer-button{margin:4px;color:rgba(0,0,0,.5)}}@media screen and (min-width:1025px){.mdl-layout__drawer-button{line-height:54px}.mdl-layout--no-desktop-drawer-button .mdl-layout__drawer-button,.mdl-layout--fixed-drawer>.mdl-layout__drawer-button,.mdl-layout--no-drawer-button .mdl-layout__drawer-button{display:none}}.mdl-layout__header{display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-flex-direction:column;-ms-flex-direction:column;flex-direction:column;-webkit-flex-wrap:nowrap;-ms-flex-wrap:nowrap;flex-wrap:nowrap;-webkit-justify-content:flex-start;-ms-flex-pack:start;justify-content:flex-start;box-sizing:border-box;-webkit-flex-shrink:0;-ms-flex-negative:0;flex-shrink:0;width:100%;margin:0;padding:0;border:none;min-height:64px;max-height:1000px;z-index:3;background-color:rgb(63,81,181);color:rgb(255,255,255);box-shadow:0 2px 2px 0 rgba(0,0,0,.14),0 3px 1px -2px rgba(0,0,0,.2),0 1px 5px 0 rgba(0,0,0,.12);transition-duration:.2s;transition-timing-function:cubic-bezier(.4,0,.2,1);transition-property:max-height,box-shadow}@media screen and (max-width:1024px){.mdl-layout__header{min-height:56px}}.mdl-layout--fixed-drawer.is-upgraded:not(.is-small-screen)>.mdl-layout__header{margin-left:240px;width:calc(100% - 240px)}@media screen and (min-width:1025px){.mdl-layout--fixed-drawer>.mdl-layout__header .mdl-layout__header-row{padding-left:40px}}.mdl-layout__header>.mdl-layout-icon{position:absolute;left:40px;top:16px;height:32px;width:32px;overflow:hidden;z-index:3;display:block}@media screen and (max-width:1024px){.mdl-layout__header>.mdl-layout-icon{left:16px;top:12px}}.mdl-layout.has-drawer .mdl-layout__header>.mdl-layout-icon{display:none}.mdl-layout__header.is-compact{max-height:64px}@media screen and (max-width:1024px){.mdl-layout__header.is-compact{max-height:56px}}.mdl-layout__header.is-compact.has-tabs{height:112px}@media screen and (max-width:1024px){.mdl-layout__header.is-compact.has-tabs{min-height:104px}}@media screen and (max-width:1024px){.mdl-layout__header{display:none}.mdl-layout--fixed-header>.mdl-layout__header{display:-webkit-flex;display:-ms-flexbox;display:flex}}.mdl-layout__header--transparent.mdl-layout__header--transparent{background-color:transparent;box-shadow:none}.mdl-layout__header--seamed,.mdl-layout__header--scroll{box-shadow:none}.mdl-layout__header--waterfall{box-shadow:none;overflow:hidden}.mdl-layout__header--waterfall.is-casting-shadow{box-shadow:0 2px 2px 0 rgba(0,0,0,.14),0 3px 1px -2px rgba(0,0,0,.2),0 1px 5px 0 rgba(0,0,0,.12)}.mdl-layout__header--waterfall.mdl-layout__header--waterfall-hide-top{-webkit-justify-content:flex-end;-ms-flex-pack:end;justify-content:flex-end}.mdl-layout__header-row{display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-flex-direction:row;-ms-flex-direction:row;flex-direction:row;-webkit-flex-wrap:nowrap;-ms-flex-wrap:nowrap;flex-wrap:nowrap;-webkit-flex-shrink:0;-ms-flex-negative:0;flex-shrink:0;box-sizing:border-box;-webkit-align-self:stretch;-ms-flex-item-align:stretch;align-self:stretch;-webkit-align-items:center;-ms-flex-align:center;align-items:center;height:64px;margin:0;padding:0 40px 0 80px}.mdl-layout--no-drawer-button .mdl-layout__header-row{padding-left:40px}@media screen and (min-width:1025px){.mdl-layout--no-desktop-drawer-button .mdl-layout__header-row{padding-left:40px}}@media screen and (max-width:1024px){.mdl-layout__header-row{height:56px;padding:0 16px 0 72px}.mdl-layout--no-drawer-button .mdl-layout__header-row{padding-left:16px}}.mdl-layout__header-row>*{-webkit-flex-shrink:0;-ms-flex-negative:0;flex-shrink:0}.mdl-layout__header--scroll .mdl-layout__header-row{width:100%}.mdl-layout__header-row .mdl-navigation{margin:0;padding:0;height:64px;-webkit-flex-direction:row;-ms-flex-direction:row;flex-direction:row;-webkit-align-items:center;-ms-flex-align:center;align-items:center}@media screen and (max-width:1024px){.mdl-layout__header-row .mdl-navigation{height:56px}}.mdl-layout__header-row .mdl-navigation__link{display:block;color:rgb(255,255,255);line-height:64px;padding:0 24px}@media screen and (max-width:1024px){.mdl-layout__header-row .mdl-navigation__link{line-height:56px;padding:0 16px}}.mdl-layout__obfuscator{background-color:transparent;position:absolute;top:0;left:0;height:100%;width:100%;z-index:4;visibility:hidden;transition-property:background-color;transition-duration:.2s;transition-timing-function:cubic-bezier(.4,0,.2,1)}.mdl-layout__obfuscator.is-visible{background-color:rgba(0,0,0,.5);visibility:visible}@supports (pointer-events:auto){.mdl-layout__obfuscator{background-color:rgba(0,0,0,.5);opacity:0;transition-property:opacity;visibility:visible;pointer-events:none}.mdl-layout__obfuscator.is-visible{pointer-events:auto;opacity:1}}.mdl-layout__content{-ms-flex:0 1 auto;position:relative;display:inline-block;overflow-y:auto;overflow-x:hidden;-webkit-flex-grow:1;-ms-flex-positive:1;flex-grow:1;z-index:1;-webkit-overflow-scrolling:touch}.mdl-layout--fixed-drawer>.mdl-layout__content{margin-left:240px}.mdl-layout__container.has-scrolling-header .mdl-layout__content{overflow:visible}@media screen and (max-width:1024px){.mdl-layout--fixed-drawer>.mdl-layout__content{margin-left:0}.mdl-layout__container.has-scrolling-header .mdl-layout__content{overflow-y:auto;overflow-x:hidden}}.mdl-layout__tab-bar{height:96px;margin:0;width:calc(100% - 112px);padding:0 0 0 56px;display:-webkit-flex;display:-ms-flexbox;display:flex;background-color:rgb(63,81,181);overflow-y:hidden;overflow-x:scroll}.mdl-layout__tab-bar::-webkit-scrollbar{display:none}.mdl-layout--no-drawer-button .mdl-layout__tab-bar{padding-left:16px;width:calc(100% - 32px)}@media screen and (min-width:1025px){.mdl-layout--no-desktop-drawer-button .mdl-layout__tab-bar{padding-left:16px;width:calc(100% - 32px)}}@media screen and (max-width:1024px){.mdl-layout__tab-bar{width:calc(100% - 60px);padding:0 0 0 60px}.mdl-layout--no-drawer-button .mdl-layout__tab-bar{width:calc(100% - 8px);padding-left:4px}}.mdl-layout--fixed-tabs .mdl-layout__tab-bar{padding:0;overflow:hidden;width:100%}.mdl-layout__tab-bar-container{position:relative;height:48px;width:100%;border:none;margin:0;z-index:2;-webkit-flex-grow:0;-ms-flex-positive:0;flex-grow:0;-webkit-flex-shrink:0;-ms-flex-negative:0;flex-shrink:0;overflow:hidden}.mdl-layout__container>.mdl-layout__tab-bar-container{position:absolute;top:0;left:0}.mdl-layout__tab-bar-button{display:inline-block;position:absolute;top:0;height:48px;width:56px;z-index:4;text-align:center;background-color:rgb(63,81,181);color:transparent;cursor:pointer;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none}.mdl-layout--no-desktop-drawer-button .mdl-layout__tab-bar-button,.mdl-layout--no-drawer-button .mdl-layout__tab-bar-button{width:16px}.mdl-layout--no-desktop-drawer-button .mdl-layout__tab-bar-button .material-icons,.mdl-layout--no-drawer-button .mdl-layout__tab-bar-button .material-icons{position:relative;left:-4px}@media screen and (max-width:1024px){.mdl-layout__tab-bar-button{width:60px}}.mdl-layout--fixed-tabs .mdl-layout__tab-bar-button{display:none}.mdl-layout__tab-bar-button .material-icons{line-height:48px}.mdl-layout__tab-bar-button.is-active{color:rgb(255,255,255)}.mdl-layout__tab-bar-left-button{left:0}.mdl-layout__tab-bar-right-button{right:0}.mdl-layout__tab{margin:0;border:none;padding:0 24px;float:left;position:relative;display:block;-webkit-flex-grow:0;-ms-flex-positive:0;flex-grow:0;-webkit-flex-shrink:0;-ms-flex-negative:0;flex-shrink:0;text-decoration:none;height:48px;line-height:48px;text-align:center;font-weight:500;font-size:14px;text-transform:uppercase;color:rgba(255,255,255,.6);overflow:hidden}@media screen and (max-width:1024px){.mdl-layout__tab{padding:0 12px}}.mdl-layout--fixed-tabs .mdl-layout__tab{float:none;-webkit-flex-grow:1;-ms-flex-positive:1;flex-grow:1;padding:0}.mdl-layout.is-upgraded .mdl-layout__tab.is-active{color:rgb(255,255,255)}.mdl-layout.is-upgraded .mdl-layout__tab.is-active::after{height:2px;width:100%;display:block;content:" ";bottom:0;left:0;position:absolute;background:rgb(255,171,64);-webkit-animation:border-expand .2s cubic-bezier(.4,0,.4,1).01s alternate forwards;animation:border-expand .2s cubic-bezier(.4,0,.4,1).01s alternate forwards;transition:all 1s cubic-bezier(.4,0,1,1)}.mdl-layout__tab .mdl-layout__tab-ripple-container{display:block;position:absolute;height:100%;width:100%;left:0;top:0;z-index:1;overflow:hidden}.mdl-layout__tab .mdl-layout__tab-ripple-container .mdl-ripple{background-color:rgb(255,255,255)}.mdl-layout__tab-panel{display:block}.mdl-layout.is-upgraded .mdl-layout__tab-panel{display:none}.mdl-layout.is-upgraded .mdl-layout__tab-panel.is-active{display:block}.mdl-radio{position:relative;font-size:16px;line-height:24px;display:inline-block;vertical-align:middle;box-sizing:border-box;height:24px;margin:0;padding-left:0}.mdl-radio.is-upgraded{padding-left:24px}.mdl-radio__button{line-height:24px}.mdl-radio.is-upgraded .mdl-radio__button{position:absolute;width:0;height:0;margin:0;padding:0;opacity:0;-ms-appearance:none;-moz-appearance:none;-webkit-appearance:none;appearance:none;border:none}.mdl-radio__outer-circle{position:absolute;top:4px;left:0;display:inline-block;box-sizing:border-box;width:16px;height:16px;margin:0;cursor:pointer;border:2px solid rgba(0,0,0,.54);border-radius:50%;z-index:2}.mdl-radio.is-checked .mdl-radio__outer-circle{border:2px solid rgb(63,81,181)}.mdl-radio__outer-circle fieldset[disabled] .mdl-radio,.mdl-radio.is-disabled .mdl-radio__outer-circle{border:2px solid rgba(0,0,0,.26);cursor:auto}.mdl-radio__inner-circle{position:absolute;z-index:1;margin:0;top:8px;left:4px;box-sizing:border-box;width:8px;height:8px;cursor:pointer;transition-duration:.28s;transition-timing-function:cubic-bezier(.4,0,.2,1);transition-property:transform;transition-property:transform,-webkit-transform;-webkit-transform:scale(0,0);transform:scale(0,0);border-radius:50%;background:rgb(63,81,181)}.mdl-radio.is-checked .mdl-radio__inner-circle{-webkit-transform:scale(1,1);transform:scale(1,1)}fieldset[disabled] .mdl-radio .mdl-radio__inner-circle,.mdl-radio.is-disabled .mdl-radio__inner-circle{background:rgba(0,0,0,.26);cursor:auto}.mdl-radio.is-focused .mdl-radio__inner-circle{box-shadow:0 0 0 10px rgba(0,0,0,.1)}.mdl-radio__label{cursor:pointer}fieldset[disabled] .mdl-radio .mdl-radio__label,.mdl-radio.is-disabled .mdl-radio__label{color:rgba(0,0,0,.26);cursor:auto}.mdl-radio__ripple-container{position:absolute;z-index:2;top:-9px;left:-13px;box-sizing:border-box;width:42px;height:42px;border-radius:50%;cursor:pointer;overflow:hidden;-webkit-mask-image:-webkit-radial-gradient(circle,#fff,#000)}.mdl-radio__ripple-container .mdl-ripple{background:rgb(63,81,181)}fieldset[disabled] .mdl-radio .mdl-radio__ripple-container,.mdl-radio.is-disabled .mdl-radio__ripple-container{cursor:auto}fieldset[disabled] .mdl-radio .mdl-radio__ripple-container .mdl-ripple,.mdl-radio.is-disabled .mdl-radio__ripple-container .mdl-ripple{background:0 0}_:-ms-input-placeholder,:root .mdl-slider.mdl-slider.is-upgraded{-ms-appearance:none;height:32px;margin:0}.mdl-slider{width:calc(100% - 40px);margin:0 20px}.mdl-slider.is-upgraded{-webkit-appearance:none;-moz-appearance:none;appearance:none;height:2px;background:0 0;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;outline:0;padding:0;color:rgb(63,81,181);-webkit-align-self:center;-ms-flex-item-align:center;-ms-grid-row-align:center;align-self:center;z-index:1;cursor:pointer}.mdl-slider.is-upgraded::-moz-focus-outer{border:0}.mdl-slider.is-upgraded::-ms-tooltip{display:none}.mdl-slider.is-upgraded::-webkit-slider-runnable-track{background:0 0}.mdl-slider.is-upgraded::-moz-range-track{background:0 0;border:none}.mdl-slider.is-upgraded::-ms-track{background:0 0;color:transparent;height:2px;width:100%;border:none}.mdl-slider.is-upgraded::-ms-fill-lower{padding:0;background:linear-gradient(to right,transparent,transparent 16px,rgb(63,81,181)16px,rgb(63,81,181)0)}.mdl-slider.is-upgraded::-ms-fill-upper{padding:0;background:linear-gradient(to left,transparent,transparent 16px,rgba(0,0,0,.26)16px,rgba(0,0,0,.26)0)}.mdl-slider.is-upgraded::-webkit-slider-thumb{-webkit-appearance:none;width:12px;height:12px;box-sizing:border-box;border-radius:50%;background:rgb(63,81,181);border:none;transition:transform .18s cubic-bezier(.4,0,.2,1),border .18s cubic-bezier(.4,0,.2,1),box-shadow .18s cubic-bezier(.4,0,.2,1),background .28s cubic-bezier(.4,0,.2,1);transition:transform .18s cubic-bezier(.4,0,.2,1),border .18s cubic-bezier(.4,0,.2,1),box-shadow .18s cubic-bezier(.4,0,.2,1),background .28s cubic-bezier(.4,0,.2,1),-webkit-transform .18s cubic-bezier(.4,0,.2,1)}.mdl-slider.is-upgraded::-moz-range-thumb{-moz-appearance:none;width:12px;height:12px;box-sizing:border-box;border-radius:50%;background-image:none;background:rgb(63,81,181);border:none}.mdl-slider.is-upgraded:focus:not(:active)::-webkit-slider-thumb{box-shadow:0 0 0 10px rgba(63,81,181,.26)}.mdl-slider.is-upgraded:focus:not(:active)::-moz-range-thumb{box-shadow:0 0 0 10px rgba(63,81,181,.26)}.mdl-slider.is-upgraded:active::-webkit-slider-thumb{background-image:none;background:rgb(63,81,181);-webkit-transform:scale(1.5);transform:scale(1.5)}.mdl-slider.is-upgraded:active::-moz-range-thumb{background-image:none;background:rgb(63,81,181);transform:scale(1.5)}.mdl-slider.is-upgraded::-ms-thumb{width:32px;height:32px;border:none;border-radius:50%;background:rgb(63,81,181);transform:scale(.375);transition:transform .18s cubic-bezier(.4,0,.2,1),background .28s cubic-bezier(.4,0,.2,1);transition:transform .18s cubic-bezier(.4,0,.2,1),background .28s cubic-bezier(.4,0,.2,1),-webkit-transform .18s cubic-bezier(.4,0,.2,1)}.mdl-slider.is-upgraded:focus:not(:active)::-ms-thumb{background:radial-gradient(circle closest-side,rgb(63,81,181)0%,rgb(63,81,181)37.5%,rgba(63,81,181,.26)37.5%,rgba(63,81,181,.26)100%);transform:scale(1)}.mdl-slider.is-upgraded:active::-ms-thumb{background:rgb(63,81,181);transform:scale(.5625)}.mdl-slider.is-upgraded.is-lowest-value::-webkit-slider-thumb{border:2px solid rgba(0,0,0,.26);background:0 0}.mdl-slider.is-upgraded.is-lowest-value::-moz-range-thumb{border:2px solid rgba(0,0,0,.26);background:0 0}.mdl-slider.is-upgraded.is-lowest-value+.mdl-slider__background-flex>.mdl-slider__background-upper{left:6px}.mdl-slider.is-upgraded.is-lowest-value:focus:not(:active)::-webkit-slider-thumb{box-shadow:0 0 0 10px rgba(0,0,0,.12);background:rgba(0,0,0,.12)}.mdl-slider.is-upgraded.is-lowest-value:focus:not(:active)::-moz-range-thumb{box-shadow:0 0 0 10px rgba(0,0,0,.12);background:rgba(0,0,0,.12)}.mdl-slider.is-upgraded.is-lowest-value:active::-webkit-slider-thumb{border:1.6px solid rgba(0,0,0,.26);-webkit-transform:scale(1.5);transform:scale(1.5)}.mdl-slider.is-upgraded.is-lowest-value:active+.mdl-slider__background-flex>.mdl-slider__background-upper{left:9px}.mdl-slider.is-upgraded.is-lowest-value:active::-moz-range-thumb{border:1.5px solid rgba(0,0,0,.26);transform:scale(1.5)}.mdl-slider.is-upgraded.is-lowest-value::-ms-thumb{background:radial-gradient(circle closest-side,transparent 0%,transparent 66.67%,rgba(0,0,0,.26)66.67%,rgba(0,0,0,.26)100%)}.mdl-slider.is-upgraded.is-lowest-value:focus:not(:active)::-ms-thumb{background:radial-gradient(circle closest-side,rgba(0,0,0,.12)0%,rgba(0,0,0,.12)25%,rgba(0,0,0,.26)25%,rgba(0,0,0,.26)37.5%,rgba(0,0,0,.12)37.5%,rgba(0,0,0,.12)100%);transform:scale(1)}.mdl-slider.is-upgraded.is-lowest-value:active::-ms-thumb{transform:scale(.5625);background:radial-gradient(circle closest-side,transparent 0%,transparent 77.78%,rgba(0,0,0,.26)77.78%,rgba(0,0,0,.26)100%)}.mdl-slider.is-upgraded.is-lowest-value::-ms-fill-lower{background:0 0}.mdl-slider.is-upgraded.is-lowest-value::-ms-fill-upper{margin-left:6px}.mdl-slider.is-upgraded.is-lowest-value:active::-ms-fill-upper{margin-left:9px}.mdl-slider.is-upgraded:disabled:focus::-webkit-slider-thumb,.mdl-slider.is-upgraded:disabled:active::-webkit-slider-thumb,.mdl-slider.is-upgraded:disabled::-webkit-slider-thumb{-webkit-transform:scale(.667);transform:scale(.667);background:rgba(0,0,0,.26)}.mdl-slider.is-upgraded:disabled:focus::-moz-range-thumb,.mdl-slider.is-upgraded:disabled:active::-moz-range-thumb,.mdl-slider.is-upgraded:disabled::-moz-range-thumb{transform:scale(.667);background:rgba(0,0,0,.26)}.mdl-slider.is-upgraded:disabled+.mdl-slider__background-flex>.mdl-slider__background-lower{background-color:rgba(0,0,0,.26);left:-6px}.mdl-slider.is-upgraded:disabled+.mdl-slider__background-flex>.mdl-slider__background-upper{left:6px}.mdl-slider.is-upgraded.is-lowest-value:disabled:focus::-webkit-slider-thumb,.mdl-slider.is-upgraded.is-lowest-value:disabled:active::-webkit-slider-thumb,.mdl-slider.is-upgraded.is-lowest-value:disabled::-webkit-slider-thumb{border:3px solid rgba(0,0,0,.26);background:0 0;-webkit-transform:scale(.667);transform:scale(.667)}.mdl-slider.is-upgraded.is-lowest-value:disabled:focus::-moz-range-thumb,.mdl-slider.is-upgraded.is-lowest-value:disabled:active::-moz-range-thumb,.mdl-slider.is-upgraded.is-lowest-value:disabled::-moz-range-thumb{border:3px solid rgba(0,0,0,.26);background:0 0;transform:scale(.667)}.mdl-slider.is-upgraded.is-lowest-value:disabled:active+.mdl-slider__background-flex>.mdl-slider__background-upper{left:6px}.mdl-slider.is-upgraded:disabled:focus::-ms-thumb,.mdl-slider.is-upgraded:disabled:active::-ms-thumb,.mdl-slider.is-upgraded:disabled::-ms-thumb{transform:scale(.25);background:rgba(0,0,0,.26)}.mdl-slider.is-upgraded.is-lowest-value:disabled:focus::-ms-thumb,.mdl-slider.is-upgraded.is-lowest-value:disabled:active::-ms-thumb,.mdl-slider.is-upgraded.is-lowest-value:disabled::-ms-thumb{transform:scale(.25);background:radial-gradient(circle closest-side,transparent 0%,transparent 50%,rgba(0,0,0,.26)50%,rgba(0,0,0,.26)100%)}.mdl-slider.is-upgraded:disabled::-ms-fill-lower{margin-right:6px;background:linear-gradient(to right,transparent,transparent 25px,rgba(0,0,0,.26)25px,rgba(0,0,0,.26)0)}.mdl-slider.is-upgraded:disabled::-ms-fill-upper{margin-left:6px}.mdl-slider.is-upgraded.is-lowest-value:disabled:active::-ms-fill-upper{margin-left:6px}.mdl-slider__ie-container{height:18px;overflow:visible;border:none;margin:none;padding:none}.mdl-slider__container{height:18px;position:relative;-webkit-flex-direction:row;-ms-flex-direction:row;flex-direction:row}.mdl-slider__container,.mdl-slider__background-flex{background:0 0;display:-webkit-flex;display:-ms-flexbox;display:flex}.mdl-slider__background-flex{position:absolute;height:2px;width:calc(100% - 52px);top:50%;left:0;margin:0 26px;overflow:hidden;border:0;padding:0;-webkit-transform:translate(0,-1px);transform:translate(0,-1px)}.mdl-slider__background-lower{background:rgb(63,81,181)}.mdl-slider__background-lower,.mdl-slider__background-upper{-webkit-flex:0;-ms-flex:0;flex:0;position:relative;border:0;padding:0}.mdl-slider__background-upper{background:rgba(0,0,0,.26);transition:left .18s cubic-bezier(.4,0,.2,1)}.mdl-snackbar{position:fixed;bottom:0;left:50%;cursor:default;background-color:#323232;z-index:3;display:block;display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-justify-content:space-between;-ms-flex-pack:justify;justify-content:space-between;font-family:"Roboto","Helvetica","Arial",sans-serif;will-change:transform;-webkit-transform:translate(0,80px);transform:translate(0,80px);transition:transform .25s cubic-bezier(.4,0,1,1);transition:transform .25s cubic-bezier(.4,0,1,1),-webkit-transform .25s cubic-bezier(.4,0,1,1);pointer-events:none}@media (max-width:479px){.mdl-snackbar{width:100%;left:0;min-height:48px;max-height:80px}}@media (min-width:480px){.mdl-snackbar{min-width:288px;max-width:568px;border-radius:2px;-webkit-transform:translate(-50%,80px);transform:translate(-50%,80px)}}.mdl-snackbar--active{-webkit-transform:translate(0,0);transform:translate(0,0);pointer-events:auto;transition:transform .25s cubic-bezier(0,0,.2,1);transition:transform .25s cubic-bezier(0,0,.2,1),-webkit-transform .25s cubic-bezier(0,0,.2,1)}@media (min-width:480px){.mdl-snackbar--active{-webkit-transform:translate(-50%,0);transform:translate(-50%,0)}}.mdl-snackbar__text{padding:14px 12px 14px 24px;vertical-align:middle;color:#fff;float:left}.mdl-snackbar__action{background:0 0;border:none;color:rgb(255,171,64);float:right;padding:14px 24px 14px 12px;font-family:"Roboto","Helvetica","Arial",sans-serif;font-size:14px;font-weight:500;text-transform:uppercase;line-height:1;letter-spacing:0;overflow:hidden;outline:none;opacity:0;pointer-events:none;cursor:pointer;text-decoration:none;text-align:center;-webkit-align-self:center;-ms-flex-item-align:center;-ms-grid-row-align:center;align-self:center}.mdl-snackbar__action::-moz-focus-inner{border:0}.mdl-snackbar__action:not([aria-hidden]){opacity:1;pointer-events:auto}.mdl-spinner{display:inline-block;position:relative;width:28px;height:28px}.mdl-spinner:not(.is-upgraded).is-active:after{content:"Loading..."}.mdl-spinner.is-upgraded.is-active{-webkit-animation:mdl-spinner__container-rotate 1568.23529412ms linear infinite;animation:mdl-spinner__container-rotate 1568.23529412ms linear infinite}@-webkit-keyframes mdl-spinner__container-rotate{to{-webkit-transform:rotate(360deg);transform:rotate(360deg)}}@keyframes mdl-spinner__container-rotate{to{-webkit-transform:rotate(360deg);transform:rotate(360deg)}}.mdl-spinner__layer{position:absolute;width:100%;height:100%;opacity:0}.mdl-spinner__layer-1{border-color:#42a5f5}.mdl-spinner--single-color .mdl-spinner__layer-1{border-color:rgb(63,81,181)}.mdl-spinner.is-active .mdl-spinner__layer-1{-webkit-animation:mdl-spinner__fill-unfill-rotate 5332ms cubic-bezier(.4,0,.2,1)infinite both,mdl-spinner__layer-1-fade-in-out 5332ms cubic-bezier(.4,0,.2,1)infinite both;animation:mdl-spinner__fill-unfill-rotate 5332ms cubic-bezier(.4,0,.2,1)infinite both,mdl-spinner__layer-1-fade-in-out 5332ms cubic-bezier(.4,0,.2,1)infinite both}.mdl-spinner__layer-2{border-color:#f44336}.mdl-spinner--single-color .mdl-spinner__layer-2{border-color:rgb(63,81,181)}.mdl-spinner.is-active .mdl-spinner__layer-2{-webkit-animation:mdl-spinner__fill-unfill-rotate 5332ms cubic-bezier(.4,0,.2,1)infinite both,mdl-spinner__layer-2-fade-in-out 5332ms cubic-bezier(.4,0,.2,1)infinite both;animation:mdl-spinner__fill-unfill-rotate 5332ms cubic-bezier(.4,0,.2,1)infinite both,mdl-spinner__layer-2-fade-in-out 5332ms cubic-bezier(.4,0,.2,1)infinite both}.mdl-spinner__layer-3{border-color:#fdd835}.mdl-spinner--single-color .mdl-spinner__layer-3{border-color:rgb(63,81,181)}.mdl-spinner.is-active .mdl-spinner__layer-3{-webkit-animation:mdl-spinner__fill-unfill-rotate 5332ms cubic-bezier(.4,0,.2,1)infinite both,mdl-spinner__layer-3-fade-in-out 5332ms cubic-bezier(.4,0,.2,1)infinite both;animation:mdl-spinner__fill-unfill-rotate 5332ms cubic-bezier(.4,0,.2,1)infinite both,mdl-spinner__layer-3-fade-in-out 5332ms cubic-bezier(.4,0,.2,1)infinite both}.mdl-spinner__layer-4{border-color:#4caf50}.mdl-spinner--single-color .mdl-spinner__layer-4{border-color:rgb(63,81,181)}.mdl-spinner.is-active .mdl-spinner__layer-4{-webkit-animation:mdl-spinner__fill-unfill-rotate 5332ms cubic-bezier(.4,0,.2,1)infinite both,mdl-spinner__layer-4-fade-in-out 5332ms cubic-bezier(.4,0,.2,1)infinite both;animation:mdl-spinner__fill-unfill-rotate 5332ms cubic-bezier(.4,0,.2,1)infinite both,mdl-spinner__layer-4-fade-in-out 5332ms cubic-bezier(.4,0,.2,1)infinite both}@-webkit-keyframes mdl-spinner__fill-unfill-rotate{12.5%{-webkit-transform:rotate(135deg);transform:rotate(135deg)}25%{-webkit-transform:rotate(270deg);transform:rotate(270deg)}37.5%{-webkit-transform:rotate(405deg);transform:rotate(405deg)}50%{-webkit-transform:rotate(540deg);transform:rotate(540deg)}62.5%{-webkit-transform:rotate(675deg);transform:rotate(675deg)}75%{-webkit-transform:rotate(810deg);transform:rotate(810deg)}87.5%{-webkit-transform:rotate(945deg);transform:rotate(945deg)}to{-webkit-transform:rotate(1080deg);transform:rotate(1080deg)}}@keyframes mdl-spinner__fill-unfill-rotate{12.5%{-webkit-transform:rotate(135deg);transform:rotate(135deg)}25%{-webkit-transform:rotate(270deg);transform:rotate(270deg)}37.5%{-webkit-transform:rotate(405deg);transform:rotate(405deg)}50%{-webkit-transform:rotate(540deg);transform:rotate(540deg)}62.5%{-webkit-transform:rotate(675deg);transform:rotate(675deg)}75%{-webkit-transform:rotate(810deg);transform:rotate(810deg)}87.5%{-webkit-transform:rotate(945deg);transform:rotate(945deg)}to{-webkit-transform:rotate(1080deg);transform:rotate(1080deg)}}@-webkit-keyframes mdl-spinner__layer-1-fade-in-out{from,25%{opacity:.99}26%,89%{opacity:0}90%,100%{opacity:.99}}@keyframes mdl-spinner__layer-1-fade-in-out{from,25%{opacity:.99}26%,89%{opacity:0}90%,100%{opacity:.99}}@-webkit-keyframes mdl-spinner__layer-2-fade-in-out{from,15%{opacity:0}25%,50%{opacity:.99}51%{opacity:0}}@keyframes mdl-spinner__layer-2-fade-in-out{from,15%{opacity:0}25%,50%{opacity:.99}51%{opacity:0}}@-webkit-keyframes mdl-spinner__layer-3-fade-in-out{from,40%{opacity:0}50%,75%{opacity:.99}76%{opacity:0}}@keyframes mdl-spinner__layer-3-fade-in-out{from,40%{opacity:0}50%,75%{opacity:.99}76%{opacity:0}}@-webkit-keyframes mdl-spinner__layer-4-fade-in-out{from,65%{opacity:0}75%,90%{opacity:.99}100%{opacity:0}}@keyframes mdl-spinner__layer-4-fade-in-out{from,65%{opacity:0}75%,90%{opacity:.99}100%{opacity:0}}.mdl-spinner__gap-patch{position:absolute;box-sizing:border-box;top:0;left:45%;width:10%;height:100%;overflow:hidden;border-color:inherit}.mdl-spinner__gap-patch .mdl-spinner__circle{width:1000%;left:-450%}.mdl-spinner__circle-clipper{display:inline-block;position:relative;width:50%;height:100%;overflow:hidden;border-color:inherit}.mdl-spinner__circle-clipper.mdl-spinner__left{float:left}.mdl-spinner__circle-clipper.mdl-spinner__right{float:right}.mdl-spinner__circle-clipper .mdl-spinner__circle{width:200%}.mdl-spinner__circle{box-sizing:border-box;height:100%;border-width:3px;border-style:solid;border-color:inherit;border-bottom-color:transparent!important;border-radius:50%;-webkit-animation:none;animation:none;position:absolute;top:0;right:0;bottom:0;left:0}.mdl-spinner__left .mdl-spinner__circle{border-right-color:transparent!important;-webkit-transform:rotate(129deg);transform:rotate(129deg)}.mdl-spinner.is-active .mdl-spinner__left .mdl-spinner__circle{-webkit-animation:mdl-spinner__left-spin 1333ms cubic-bezier(.4,0,.2,1)infinite both;animation:mdl-spinner__left-spin 1333ms cubic-bezier(.4,0,.2,1)infinite both}.mdl-spinner__right .mdl-spinner__circle{left:-100%;border-left-color:transparent!important;-webkit-transform:rotate(-129deg);transform:rotate(-129deg)}.mdl-spinner.is-active .mdl-spinner__right .mdl-spinner__circle{-webkit-animation:mdl-spinner__right-spin 1333ms cubic-bezier(.4,0,.2,1)infinite both;animation:mdl-spinner__right-spin 1333ms cubic-bezier(.4,0,.2,1)infinite both}@-webkit-keyframes mdl-spinner__left-spin{from{-webkit-transform:rotate(130deg);transform:rotate(130deg)}50%{-webkit-transform:rotate(-5deg);transform:rotate(-5deg)}to{-webkit-transform:rotate(130deg);transform:rotate(130deg)}}@keyframes mdl-spinner__left-spin{from{-webkit-transform:rotate(130deg);transform:rotate(130deg)}50%{-webkit-transform:rotate(-5deg);transform:rotate(-5deg)}to{-webkit-transform:rotate(130deg);transform:rotate(130deg)}}@-webkit-keyframes mdl-spinner__right-spin{from{-webkit-transform:rotate(-130deg);transform:rotate(-130deg)}50%{-webkit-transform:rotate(5deg);transform:rotate(5deg)}to{-webkit-transform:rotate(-130deg);transform:rotate(-130deg)}}@keyframes mdl-spinner__right-spin{from{-webkit-transform:rotate(-130deg);transform:rotate(-130deg)}50%{-webkit-transform:rotate(5deg);transform:rotate(5deg)}to{-webkit-transform:rotate(-130deg);transform:rotate(-130deg)}}.mdl-switch{position:relative;z-index:1;vertical-align:middle;display:inline-block;box-sizing:border-box;width:100%;height:24px;margin:0;padding:0;overflow:visible;-webkit-touch-callout:none;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none}.mdl-switch.is-upgraded{padding-left:28px}.mdl-switch__input{line-height:24px}.mdl-switch.is-upgraded .mdl-switch__input{position:absolute;width:0;height:0;margin:0;padding:0;opacity:0;-ms-appearance:none;-moz-appearance:none;-webkit-appearance:none;appearance:none;border:none}.mdl-switch__track{background:rgba(0,0,0,.26);position:absolute;left:0;top:5px;height:14px;width:36px;border-radius:14px;cursor:pointer}.mdl-switch.is-checked .mdl-switch__track{background:rgba(63,81,181,.5)}.mdl-switch__track fieldset[disabled] .mdl-switch,.mdl-switch.is-disabled .mdl-switch__track{background:rgba(0,0,0,.12);cursor:auto}.mdl-switch__thumb{background:#fafafa;position:absolute;left:0;top:2px;height:20px;width:20px;border-radius:50%;cursor:pointer;box-shadow:0 2px 2px 0 rgba(0,0,0,.14),0 3px 1px -2px rgba(0,0,0,.2),0 1px 5px 0 rgba(0,0,0,.12);transition-duration:.28s;transition-timing-function:cubic-bezier(.4,0,.2,1);transition-property:left}.mdl-switch.is-checked .mdl-switch__thumb{background:rgb(63,81,181);left:16px;box-shadow:0 3px 4px 0 rgba(0,0,0,.14),0 3px 3px -2px rgba(0,0,0,.2),0 1px 8px 0 rgba(0,0,0,.12)}.mdl-switch__thumb fieldset[disabled] .mdl-switch,.mdl-switch.is-disabled .mdl-switch__thumb{background:#bdbdbd;cursor:auto}.mdl-switch__focus-helper{position:absolute;top:50%;left:50%;-webkit-transform:translate(-4px,-4px);transform:translate(-4px,-4px);display:inline-block;box-sizing:border-box;width:8px;height:8px;border-radius:50%;background-color:transparent}.mdl-switch.is-focused .mdl-switch__focus-helper{box-shadow:0 0 0 20px rgba(0,0,0,.1);background-color:rgba(0,0,0,.1)}.mdl-switch.is-focused.is-checked .mdl-switch__focus-helper{box-shadow:0 0 0 20px rgba(63,81,181,.26);background-color:rgba(63,81,181,.26)}.mdl-switch__label{position:relative;cursor:pointer;font-size:16px;line-height:24px;margin:0;left:24px}.mdl-switch__label fieldset[disabled] .mdl-switch,.mdl-switch.is-disabled .mdl-switch__label{color:#bdbdbd;cursor:auto}.mdl-switch__ripple-container{position:absolute;z-index:2;top:-12px;left:-14px;box-sizing:border-box;width:48px;height:48px;border-radius:50%;cursor:pointer;overflow:hidden;-webkit-mask-image:-webkit-radial-gradient(circle,#fff,#000);transition-duration:.4s;transition-timing-function:step-end;transition-property:left}.mdl-switch__ripple-container .mdl-ripple{background:rgb(63,81,181)}.mdl-switch__ripple-container fieldset[disabled] .mdl-switch,.mdl-switch.is-disabled .mdl-switch__ripple-container{cursor:auto}fieldset[disabled] .mdl-switch .mdl-switch__ripple-container .mdl-ripple,.mdl-switch.is-disabled .mdl-switch__ripple-container .mdl-ripple{background:0 0}.mdl-switch.is-checked .mdl-switch__ripple-container{left:2px}.mdl-tabs{display:block;width:100%}.mdl-tabs__tab-bar{display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-flex-direction:row;-ms-flex-direction:row;flex-direction:row;-webkit-justify-content:center;-ms-flex-pack:center;justify-content:center;-webkit-align-content:space-between;-ms-flex-line-pack:justify;align-content:space-between;-webkit-align-items:flex-start;-ms-flex-align:start;align-items:flex-start;height:48px;padding:0;margin:0;border-bottom:1px solid #e0e0e0}.mdl-tabs__tab{margin:0;border:none;padding:0 24px;float:left;position:relative;display:block;text-decoration:none;height:48px;line-height:48px;text-align:center;font-weight:500;font-size:14px;text-transform:uppercase;color:rgba(0,0,0,.54);overflow:hidden}.mdl-tabs.is-upgraded .mdl-tabs__tab.is-active{color:rgba(0,0,0,.87)}.mdl-tabs.is-upgraded .mdl-tabs__tab.is-active:after{height:2px;width:100%;display:block;content:" ";bottom:0;left:0;position:absolute;background:rgb(63,81,181);-webkit-animation:border-expand .2s cubic-bezier(.4,0,.4,1).01s alternate forwards;animation:border-expand .2s cubic-bezier(.4,0,.4,1).01s alternate forwards;transition:all 1s cubic-bezier(.4,0,1,1)}.mdl-tabs__tab .mdl-tabs__ripple-container{display:block;position:absolute;height:100%;width:100%;left:0;top:0;z-index:1;overflow:hidden}.mdl-tabs__tab .mdl-tabs__ripple-container .mdl-ripple{background:rgb(63,81,181)}.mdl-tabs__panel{display:block}.mdl-tabs.is-upgraded .mdl-tabs__panel{display:none}.mdl-tabs.is-upgraded .mdl-tabs__panel.is-active{display:block}@-webkit-keyframes border-expand{0%{opacity:0;width:0}100%{opacity:1;width:100%}}@keyframes border-expand{0%{opacity:0;width:0}100%{opacity:1;width:100%}}.mdl-textfield{position:relative;font-size:16px;display:inline-block;box-sizing:border-box;width:300px;max-width:100%;margin:0;padding:20px 0}.mdl-textfield .mdl-button{position:absolute;bottom:20px}.mdl-textfield--align-right{text-align:right}.mdl-textfield--full-width{width:100%}.mdl-textfield--expandable{min-width:32px;width:auto;min-height:32px}.mdl-textfield--expandable .mdl-button--icon{top:16px}.mdl-textfield__input{border:none;border-bottom:1px solid rgba(0,0,0,.12);display:block;font-size:16px;font-family:"Helvetica","Arial",sans-serif;margin:0;padding:4px 0;width:100%;background:0 0;text-align:left;color:inherit}.mdl-textfield__input[type="number"]{-moz-appearance:textfield}.mdl-textfield__input[type="number"]::-webkit-inner-spin-button,.mdl-textfield__input[type="number"]::-webkit-outer-spin-button{-webkit-appearance:none;margin:0}.mdl-textfield.is-focused .mdl-textfield__input{outline:none}.mdl-textfield.is-invalid .mdl-textfield__input{border-color:#d50000;box-shadow:none}fieldset[disabled] .mdl-textfield .mdl-textfield__input,.mdl-textfield.is-disabled .mdl-textfield__input{background-color:transparent;border-bottom:1px dotted rgba(0,0,0,.12);color:rgba(0,0,0,.26)}.mdl-textfield textarea.mdl-textfield__input{display:block}.mdl-textfield__label{bottom:0;color:rgba(0,0,0,.26);font-size:16px;left:0;right:0;pointer-events:none;position:absolute;display:block;top:24px;width:100%;overflow:hidden;white-space:nowrap;text-align:left}.mdl-textfield.is-dirty .mdl-textfield__label,.mdl-textfield.has-placeholder .mdl-textfield__label{visibility:hidden}.mdl-textfield--floating-label .mdl-textfield__label{transition-duration:.2s;transition-timing-function:cubic-bezier(.4,0,.2,1)}.mdl-textfield--floating-label.has-placeholder .mdl-textfield__label{transition:none}fieldset[disabled] .mdl-textfield .mdl-textfield__label,.mdl-textfield.is-disabled.is-disabled .mdl-textfield__label{color:rgba(0,0,0,.26)}.mdl-textfield--floating-label.is-focused .mdl-textfield__label,.mdl-textfield--floating-label.is-dirty .mdl-textfield__label,.mdl-textfield--floating-label.has-placeholder .mdl-textfield__label{color:rgb(63,81,181);font-size:12px;top:4px;visibility:visible}.mdl-textfield--floating-label.is-focused .mdl-textfield__expandable-holder .mdl-textfield__label,.mdl-textfield--floating-label.is-dirty .mdl-textfield__expandable-holder .mdl-textfield__label,.mdl-textfield--floating-label.has-placeholder .mdl-textfield__expandable-holder .mdl-textfield__label{top:-16px}.mdl-textfield--floating-label.is-invalid .mdl-textfield__label{color:#d50000;font-size:12px}.mdl-textfield__label:after{background-color:rgb(63,81,181);bottom:20px;content:'''';height:2px;left:45%;position:absolute;transition-duration:.2s;transition-timing-function:cubic-bezier(.4,0,.2,1);visibility:hidden;width:10px}.mdl-textfield.is-focused .mdl-textfield__label:after{left:0;visibility:visible;width:100%}.mdl-textfield.is-invalid .mdl-textfield__label:after{background-color:#d50000}.mdl-textfield__error{color:#d50000;position:absolute;font-size:12px;margin-top:3px;visibility:hidden;display:block}.mdl-textfield.is-invalid .mdl-textfield__error{visibility:visible}.mdl-textfield__expandable-holder{display:inline-block;position:relative;margin-left:32px;transition-duration:.2s;transition-timing-function:cubic-bezier(.4,0,.2,1);display:inline-block;max-width:.1px}.mdl-textfield.is-focused .mdl-textfield__expandable-holder,.mdl-textfield.is-dirty .mdl-textfield__expandable-holder{max-width:600px}.mdl-textfield__expandable-holder .mdl-textfield__label:after{bottom:0}.mdl-tooltip{-webkit-transform:scale(0);transform:scale(0);-webkit-transform-origin:top center;transform-origin:top center;z-index:999;background:rgba(97,97,97,.9);border-radius:2px;color:#fff;display:inline-block;font-size:10px;font-weight:500;line-height:14px;max-width:170px;position:fixed;top:-500px;left:-500px;padding:8px;text-align:center}.mdl-tooltip.is-active{-webkit-animation:pulse 200ms cubic-bezier(0,0,.2,1)forwards;animation:pulse 200ms cubic-bezier(0,0,.2,1)forwards}.mdl-tooltip--large{line-height:14px;font-size:14px;padding:16px}@-webkit-keyframes pulse{0%{-webkit-transform:scale(0);transform:scale(0);opacity:0}50%{-webkit-transform:scale(.99);transform:scale(.99)}100%{-webkit-transform:scale(1);transform:scale(1);opacity:1;visibility:visible}}@keyframes pulse{0%{-webkit-transform:scale(0);transform:scale(0);opacity:0}50%{-webkit-transform:scale(.99);transform:scale(.99)}100%{-webkit-transform:scale(1);transform:scale(1);opacity:1;visibility:visible}}.mdl-shadow--2dp{box-shadow:0 2px 2px 0 rgba(0,0,0,.14),0 3px 1px -2px rgba(0,0,0,.2),0 1px 5px 0 rgba(0,0,0,.12)}.mdl-shadow--3dp{box-shadow:0 3px 4px 0 rgba(0,0,0,.14),0 3px 3px -2px rgba(0,0,0,.2),0 1px 8px 0 rgba(0,0,0,.12)}.mdl-shadow--4dp{box-shadow:0 4px 5px 0 rgba(0,0,0,.14),0 1px 10px 0 rgba(0,0,0,.12),0 2px 4px -1px rgba(0,0,0,.2)}.mdl-shadow--6dp{box-shadow:0 6px 10px 0 rgba(0,0,0,.14),0 1px 18px 0 rgba(0,0,0,.12),0 3px 5px -1px rgba(0,0,0,.2)}.mdl-shadow--8dp{box-shadow:0 8px 10px 1px rgba(0,0,0,.14),0 3px 14px 2px rgba(0,0,0,.12),0 5px 5px -3px rgba(0,0,0,.2)}.mdl-shadow--16dp{box-shadow:0 16px 24px 2px rgba(0,0,0,.14),0 6px 30px 5px rgba(0,0,0,.12),0 8px 10px -5px rgba(0,0,0,.2)}.mdl-shadow--24dp{box-shadow:0 9px 46px 8px rgba(0,0,0,.14),0 11px 15px -7px rgba(0,0,0,.12),0 24px 38px 3px rgba(0,0,0,.2)}.mdl-grid{display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-flex-flow:row wrap;-ms-flex-flow:row wrap;flex-flow:row wrap;margin:0 auto;-webkit-align-items:stretch;-ms-flex-align:stretch;align-items:stretch}.mdl-grid.mdl-grid--no-spacing{padding:0}.mdl-cell{box-sizing:border-box}.mdl-cell--top{-webkit-align-self:flex-start;-ms-flex-item-align:start;align-self:flex-start}.mdl-cell--middle{-webkit-align-self:center;-ms-flex-item-align:center;-ms-grid-row-align:center;align-self:center}.mdl-cell--bottom{-webkit-align-self:flex-end;-ms-flex-item-align:end;align-self:flex-end}.mdl-cell--stretch{-webkit-align-self:stretch;-ms-flex-item-align:stretch;-ms-grid-row-align:stretch;align-self:stretch}.mdl-grid.mdl-grid--no-spacing>.mdl-cell{margin:0}.mdl-cell--order-1{-webkit-order:1;-ms-flex-order:1;order:1}.mdl-cell--order-2{-webkit-order:2;-ms-flex-order:2;order:2}.mdl-cell--order-3{-webkit-order:3;-ms-flex-order:3;order:3}.mdl-cell--order-4{-webkit-order:4;-ms-flex-order:4;order:4}.mdl-cell--order-5{-webkit-order:5;-ms-flex-order:5;order:5}.mdl-cell--order-6{-webkit-order:6;-ms-flex-order:6;order:6}.mdl-cell--order-7{-webkit-order:7;-ms-flex-order:7;order:7}.mdl-cell--order-8{-webkit-order:8;-ms-flex-order:8;order:8}.mdl-cell--order-9{-webkit-order:9;-ms-flex-order:9;order:9}.mdl-cell--order-10{-webkit-order:10;-ms-flex-order:10;order:10}.mdl-cell--order-11{-webkit-order:11;-ms-flex-order:11;order:11}.mdl-cell--order-12{-webkit-order:12;-ms-flex-order:12;order:12}@media (max-width:479px){.mdl-grid{padding:8px}.mdl-cell{margin:8px;width:calc(100% - 16px)}.mdl-grid--no-spacing>.mdl-cell{width:100%}.mdl-cell--hide-phone{display:none!important}.mdl-cell--order-1-phone.mdl-cell--order-1-phone{-webkit-order:1;-ms-flex-order:1;order:1}.mdl-cell--order-2-phone.mdl-cell--order-2-phone{-webkit-order:2;-ms-flex-order:2;order:2}.mdl-cell--order-3-phone.mdl-cell--order-3-phone{-webkit-order:3;-ms-flex-order:3;order:3}.mdl-cell--order-4-phone.mdl-cell--order-4-phone{-webkit-order:4;-ms-flex-order:4;order:4}.mdl-cell--order-5-phone.mdl-cell--order-5-phone{-webkit-order:5;-ms-flex-order:5;order:5}.mdl-cell--order-6-phone.mdl-cell--order-6-phone{-webkit-order:6;-ms-flex-order:6;order:6}.mdl-cell--order-7-phone.mdl-cell--order-7-phone{-webkit-order:7;-ms-flex-order:7;order:7}.mdl-cell--order-8-phone.mdl-cell--order-8-phone{-webkit-order:8;-ms-flex-order:8;order:8}.mdl-cell--order-9-phone.mdl-cell--order-9-phone{-webkit-order:9;-ms-flex-order:9;order:9}.mdl-cell--order-10-phone.mdl-cell--order-10-phone{-webkit-order:10;-ms-flex-order:10;order:10}.mdl-cell--order-11-phone.mdl-cell--order-11-phone{-webkit-order:11;-ms-flex-order:11;order:11}.mdl-cell--order-12-phone.mdl-cell--order-12-phone{-webkit-order:12;-ms-flex-order:12;order:12}.mdl-cell--1-col,.mdl-cell--1-col-phone.mdl-cell--1-col-phone{width:calc(25% - 16px)}.mdl-grid--no-spacing>.mdl-cell--1-col,.mdl-grid--no-spacing>.mdl-cell--1-col-phone.mdl-cell--1-col-phone{width:25%}.mdl-cell--2-col,.mdl-cell--2-col-phone.mdl-cell--2-col-phone{width:calc(50% - 16px)}.mdl-grid--no-spacing>.mdl-cell--2-col,.mdl-grid--no-spacing>.mdl-cell--2-col-phone.mdl-cell--2-col-phone{width:50%}.mdl-cell--3-col,.mdl-cell--3-col-phone.mdl-cell--3-col-phone{width:calc(75% - 16px)}.mdl-grid--no-spacing>.mdl-cell--3-col,.mdl-grid--no-spacing>.mdl-cell--3-col-phone.mdl-cell--3-col-phone{width:75%}.mdl-cell--4-col,.mdl-cell--4-col-phone.mdl-cell--4-col-phone{width:calc(100% - 16px)}.mdl-grid--no-spacing>.mdl-cell--4-col,.mdl-grid--no-spacing>.mdl-cell--4-col-phone.mdl-cell--4-col-phone{width:100%}.mdl-cell--5-col,.mdl-cell--5-col-phone.mdl-cell--5-col-phone{width:calc(100% - 16px)}.mdl-grid--no-spacing>.mdl-cell--5-col,.mdl-grid--no-spacing>.mdl-cell--5-col-phone.mdl-cell--5-col-phone{width:100%}.mdl-cell--6-col,.mdl-cell--6-col-phone.mdl-cell--6-col-phone{width:calc(100% - 16px)}.mdl-grid--no-spacing>.mdl-cell--6-col,.mdl-grid--no-spacing>.mdl-cell--6-col-phone.mdl-cell--6-col-phone{width:100%}.mdl-cell--7-col,.mdl-cell--7-col-phone.mdl-cell--7-col-phone{width:calc(100% - 16px)}.mdl-grid--no-spacing>.mdl-cell--7-col,.mdl-grid--no-spacing>.mdl-cell--7-col-phone.mdl-cell--7-col-phone{width:100%}.mdl-cell--8-col,.mdl-cell--8-col-phone.mdl-cell--8-col-phone{width:calc(100% - 16px)}.mdl-grid--no-spacing>.mdl-cell--8-col,.mdl-grid--no-spacing>.mdl-cell--8-col-phone.mdl-cell--8-col-phone{width:100%}.mdl-cell--9-col,.mdl-cell--9-col-phone.mdl-cell--9-col-phone{width:calc(100% - 16px)}.mdl-grid--no-spacing>.mdl-cell--9-col,.mdl-grid--no-spacing>.mdl-cell--9-col-phone.mdl-cell--9-col-phone{width:100%}.mdl-cell--10-col,.mdl-cell--10-col-phone.mdl-cell--10-col-phone{width:calc(100% - 16px)}.mdl-grid--no-spacing>.mdl-cell--10-col,.mdl-grid--no-spacing>.mdl-cell--10-col-phone.mdl-cell--10-col-phone{width:100%}.mdl-cell--11-col,.mdl-cell--11-col-phone.mdl-cell--11-col-phone{width:calc(100% - 16px)}.mdl-grid--no-spacing>.mdl-cell--11-col,.mdl-grid--no-spacing>.mdl-cell--11-col-phone.mdl-cell--11-col-phone{width:100%}.mdl-cell--12-col,.mdl-cell--12-col-phone.mdl-cell--12-col-phone{width:calc(100% - 16px)}.mdl-grid--no-spacing>.mdl-cell--12-col,.mdl-grid--no-spacing>.mdl-cell--12-col-phone.mdl-cell--12-col-phone{width:100%}.mdl-cell--1-offset,.mdl-cell--1-offset-phone.mdl-cell--1-offset-phone{margin-left:calc(25% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--1-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--1-offset-phone.mdl-cell--1-offset-phone{margin-left:25%}.mdl-cell--2-offset,.mdl-cell--2-offset-phone.mdl-cell--2-offset-phone{margin-left:calc(50% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--2-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--2-offset-phone.mdl-cell--2-offset-phone{margin-left:50%}.mdl-cell--3-offset,.mdl-cell--3-offset-phone.mdl-cell--3-offset-phone{margin-left:calc(75% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--3-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--3-offset-phone.mdl-cell--3-offset-phone{margin-left:75%}}@media (min-width:480px) and (max-width:839px){.mdl-grid{padding:8px}.mdl-cell{margin:8px;width:calc(50% - 16px)}.mdl-grid--no-spacing>.mdl-cell{width:50%}.mdl-cell--hide-tablet{display:none!important}.mdl-cell--order-1-tablet.mdl-cell--order-1-tablet{-webkit-order:1;-ms-flex-order:1;order:1}.mdl-cell--order-2-tablet.mdl-cell--order-2-tablet{-webkit-order:2;-ms-flex-order:2;order:2}.mdl-cell--order-3-tablet.mdl-cell--order-3-tablet{-webkit-order:3;-ms-flex-order:3;order:3}.mdl-cell--order-4-tablet.mdl-cell--order-4-tablet{-webkit-order:4;-ms-flex-order:4;order:4}.mdl-cell--order-5-tablet.mdl-cell--order-5-tablet{-webkit-order:5;-ms-flex-order:5;order:5}.mdl-cell--order-6-tablet.mdl-cell--order-6-tablet{-webkit-order:6;-ms-flex-order:6;order:6}.mdl-cell--order-7-tablet.mdl-cell--order-7-tablet{-webkit-order:7;-ms-flex-order:7;order:7}.mdl-cell--order-8-tablet.mdl-cell--order-8-tablet{-webkit-order:8;-ms-flex-order:8;order:8}.mdl-cell--order-9-tablet.mdl-cell--order-9-tablet{-webkit-order:9;-ms-flex-order:9;order:9}.mdl-cell--order-10-tablet.mdl-cell--order-10-tablet{-webkit-order:10;-ms-flex-order:10;order:10}.mdl-cell--order-11-tablet.mdl-cell--order-11-tablet{-webkit-order:11;-ms-flex-order:11;order:11}.mdl-cell--order-12-tablet.mdl-cell--order-12-tablet{-webkit-order:12;-ms-flex-order:12;order:12}.mdl-cell--1-col,.mdl-cell--1-col-tablet.mdl-cell--1-col-tablet{width:calc(12.5% - 16px)}.mdl-grid--no-spacing>.mdl-cell--1-col,.mdl-grid--no-spacing>.mdl-cell--1-col-tablet.mdl-cell--1-col-tablet{width:12.5%}.mdl-cell--2-col,.mdl-cell--2-col-tablet.mdl-cell--2-col-tablet{width:calc(25% - 16px)}.mdl-grid--no-spacing>.mdl-cell--2-col,.mdl-grid--no-spacing>.mdl-cell--2-col-tablet.mdl-cell--2-col-tablet{width:25%}.mdl-cell--3-col,.mdl-cell--3-col-tablet.mdl-cell--3-col-tablet{width:calc(37.5% - 16px)}.mdl-grid--no-spacing>.mdl-cell--3-col,.mdl-grid--no-spacing>.mdl-cell--3-col-tablet.mdl-cell--3-col-tablet{width:37.5%}.mdl-cell--4-col,.mdl-cell--4-col-tablet.mdl-cell--4-col-tablet{width:calc(50% - 16px)}.mdl-grid--no-spacing>.mdl-cell--4-col,.mdl-grid--no-spacing>.mdl-cell--4-col-tablet.mdl-cell--4-col-tablet{width:50%}.mdl-cell--5-col,.mdl-cell--5-col-tablet.mdl-cell--5-col-tablet{width:calc(62.5% - 16px)}.mdl-grid--no-spacing>.mdl-cell--5-col,.mdl-grid--no-spacing>.mdl-cell--5-col-tablet.mdl-cell--5-col-tablet{width:62.5%}.mdl-cell--6-col,.mdl-cell--6-col-tablet.mdl-cell--6-col-tablet{width:calc(75% - 16px)}.mdl-grid--no-spacing>.mdl-cell--6-col,.mdl-grid--no-spacing>.mdl-cell--6-col-tablet.mdl-cell--6-col-tablet{width:75%}.mdl-cell--7-col,.mdl-cell--7-col-tablet.mdl-cell--7-col-tablet{width:calc(87.5% - 16px)}.mdl-grid--no-spacing>.mdl-cell--7-col,.mdl-grid--no-spacing>.mdl-cell--7-col-tablet.mdl-cell--7-col-tablet{width:87.5%}.mdl-cell--8-col,.mdl-cell--8-col-tablet.mdl-cell--8-col-tablet{width:calc(100% - 16px)}.mdl-grid--no-spacing>.mdl-cell--8-col,.mdl-grid--no-spacing>.mdl-cell--8-col-tablet.mdl-cell--8-col-tablet{width:100%}.mdl-cell--9-col,.mdl-cell--9-col-tablet.mdl-cell--9-col-tablet{width:calc(100% - 16px)}.mdl-grid--no-spacing>.mdl-cell--9-col,.mdl-grid--no-spacing>.mdl-cell--9-col-tablet.mdl-cell--9-col-tablet{width:100%}.mdl-cell--10-col,.mdl-cell--10-col-tablet.mdl-cell--10-col-tablet{width:calc(100% - 16px)}.mdl-grid--no-spacing>.mdl-cell--10-col,.mdl-grid--no-spacing>.mdl-cell--10-col-tablet.mdl-cell--10-col-tablet{width:100%}.mdl-cell--11-col,.mdl-cell--11-col-tablet.mdl-cell--11-col-tablet{width:calc(100% - 16px)}.mdl-grid--no-spacing>.mdl-cell--11-col,.mdl-grid--no-spacing>.mdl-cell--11-col-tablet.mdl-cell--11-col-tablet{width:100%}.mdl-cell--12-col,.mdl-cell--12-col-tablet.mdl-cell--12-col-tablet{width:calc(100% - 16px)}.mdl-grid--no-spacing>.mdl-cell--12-col,.mdl-grid--no-spacing>.mdl-cell--12-col-tablet.mdl-cell--12-col-tablet{width:100%}.mdl-cell--1-offset,.mdl-cell--1-offset-tablet.mdl-cell--1-offset-tablet{margin-left:calc(12.5% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--1-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--1-offset-tablet.mdl-cell--1-offset-tablet{margin-left:12.5%}.mdl-cell--2-offset,.mdl-cell--2-offset-tablet.mdl-cell--2-offset-tablet{margin-left:calc(25% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--2-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--2-offset-tablet.mdl-cell--2-offset-tablet{margin-left:25%}.mdl-cell--3-offset,.mdl-cell--3-offset-tablet.mdl-cell--3-offset-tablet{margin-left:calc(37.5% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--3-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--3-offset-tablet.mdl-cell--3-offset-tablet{margin-left:37.5%}.mdl-cell--4-offset,.mdl-cell--4-offset-tablet.mdl-cell--4-offset-tablet{margin-left:calc(50% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--4-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--4-offset-tablet.mdl-cell--4-offset-tablet{margin-left:50%}.mdl-cell--5-offset,.mdl-cell--5-offset-tablet.mdl-cell--5-offset-tablet{margin-left:calc(62.5% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--5-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--5-offset-tablet.mdl-cell--5-offset-tablet{margin-left:62.5%}.mdl-cell--6-offset,.mdl-cell--6-offset-tablet.mdl-cell--6-offset-tablet{margin-left:calc(75% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--6-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--6-offset-tablet.mdl-cell--6-offset-tablet{margin-left:75%}.mdl-cell--7-offset,.mdl-cell--7-offset-tablet.mdl-cell--7-offset-tablet{margin-left:calc(87.5% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--7-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--7-offset-tablet.mdl-cell--7-offset-tablet{margin-left:87.5%}}@media (min-width:840px){.mdl-grid{padding:8px}.mdl-cell{margin:8px;width:calc(33.3333333333% - 16px)}.mdl-grid--no-spacing>.mdl-cell{width:33.3333333333%}.mdl-cell--hide-desktop{display:none!important}.mdl-cell--order-1-desktop.mdl-cell--order-1-desktop{-webkit-order:1;-ms-flex-order:1;order:1}.mdl-cell--order-2-desktop.mdl-cell--order-2-desktop{-webkit-order:2;-ms-flex-order:2;order:2}.mdl-cell--order-3-desktop.mdl-cell--order-3-desktop{-webkit-order:3;-ms-flex-order:3;order:3}.mdl-cell--order-4-desktop.mdl-cell--order-4-desktop{-webkit-order:4;-ms-flex-order:4;order:4}.mdl-cell--order-5-desktop.mdl-cell--order-5-desktop{-webkit-order:5;-ms-flex-order:5;order:5}.mdl-cell--order-6-desktop.mdl-cell--order-6-desktop{-webkit-order:6;-ms-flex-order:6;order:6}.mdl-cell--order-7-desktop.mdl-cell--order-7-desktop{-webkit-order:7;-ms-flex-order:7;order:7}.mdl-cell--order-8-desktop.mdl-cell--order-8-desktop{-webkit-order:8;-ms-flex-order:8;order:8}.mdl-cell--order-9-desktop.mdl-cell--order-9-desktop{-webkit-order:9;-ms-flex-order:9;order:9}.mdl-cell--order-10-desktop.mdl-cell--order-10-desktop{-webkit-order:10;-ms-flex-order:10;order:10}.mdl-cell--order-11-desktop.mdl-cell--order-11-desktop{-webkit-order:11;-ms-flex-order:11;order:11}.mdl-cell--order-12-desktop.mdl-cell--order-12-desktop{-webkit-order:12;-ms-flex-order:12;order:12}.mdl-cell--1-col,.mdl-cell--1-col-desktop.mdl-cell--1-col-desktop{width:calc(8.3333333333% - 16px)}.mdl-grid--no-spacing>.mdl-cell--1-col,.mdl-grid--no-spacing>.mdl-cell--1-col-desktop.mdl-cell--1-col-desktop{width:8.3333333333%}.mdl-cell--2-col,.mdl-cell--2-col-desktop.mdl-cell--2-col-desktop{width:calc(16.6666666667% - 16px)}.mdl-grid--no-spacing>.mdl-cell--2-col,.mdl-grid--no-spacing>.mdl-cell--2-col-desktop.mdl-cell--2-col-desktop{width:16.6666666667%}.mdl-cell--3-col,.mdl-cell--3-col-desktop.mdl-cell--3-col-desktop{width:calc(25% - 16px)}.mdl-grid--no-spacing>.mdl-cell--3-col,.mdl-grid--no-spacing>.mdl-cell--3-col-desktop.mdl-cell--3-col-desktop{width:25%}.mdl-cell--4-col,.mdl-cell--4-col-desktop.mdl-cell--4-col-desktop{width:calc(33.3333333333% - 16px)}.mdl-grid--no-spacing>.mdl-cell--4-col,.mdl-grid--no-spacing>.mdl-cell--4-col-desktop.mdl-cell--4-col-desktop{width:33.3333333333%}.mdl-cell--5-col,.mdl-cell--5-col-desktop.mdl-cell--5-col-desktop{width:calc(41.6666666667% - 16px)}.mdl-grid--no-spacing>.mdl-cell--5-col,.mdl-grid--no-spacing>.mdl-cell--5-col-desktop.mdl-cell--5-col-desktop{width:41.6666666667%}.mdl-cell--6-col,.mdl-cell--6-col-desktop.mdl-cell--6-col-desktop{width:calc(50% - 16px)}.mdl-grid--no-spacing>.mdl-cell--6-col,.mdl-grid--no-spacing>.mdl-cell--6-col-desktop.mdl-cell--6-col-desktop{width:50%}.mdl-cell--7-col,.mdl-cell--7-col-desktop.mdl-cell--7-col-desktop{width:calc(58.3333333333% - 16px)}.mdl-grid--no-spacing>.mdl-cell--7-col,.mdl-grid--no-spacing>.mdl-cell--7-col-desktop.mdl-cell--7-col-desktop{width:58.3333333333%}.mdl-cell--8-col,.mdl-cell--8-col-desktop.mdl-cell--8-col-desktop{width:calc(66.6666666667% - 16px)}.mdl-grid--no-spacing>.mdl-cell--8-col,.mdl-grid--no-spacing>.mdl-cell--8-col-desktop.mdl-cell--8-col-desktop{width:66.6666666667%}.mdl-cell--9-col,.mdl-cell--9-col-desktop.mdl-cell--9-col-desktop{width:calc(75% - 16px)}.mdl-grid--no-spacing>.mdl-cell--9-col,.mdl-grid--no-spacing>.mdl-cell--9-col-desktop.mdl-cell--9-col-desktop{width:75%}.mdl-cell--10-col,.mdl-cell--10-col-desktop.mdl-cell--10-col-desktop{width:calc(83.3333333333% - 16px)}.mdl-grid--no-spacing>.mdl-cell--10-col,.mdl-grid--no-spacing>.mdl-cell--10-col-desktop.mdl-cell--10-col-desktop{width:83.3333333333%}.mdl-cell--11-col,.mdl-cell--11-col-desktop.mdl-cell--11-col-desktop{width:calc(91.6666666667% - 16px)}.mdl-grid--no-spacing>.mdl-cell--11-col,.mdl-grid--no-spacing>.mdl-cell--11-col-desktop.mdl-cell--11-col-desktop{width:91.6666666667%}.mdl-cell--12-col,.mdl-cell--12-col-desktop.mdl-cell--12-col-desktop{width:calc(100% - 16px)}.mdl-grid--no-spacing>.mdl-cell--12-col,.mdl-grid--no-spacing>.mdl-cell--12-col-desktop.mdl-cell--12-col-desktop{width:100%}.mdl-cell--1-offset,.mdl-cell--1-offset-desktop.mdl-cell--1-offset-desktop{margin-left:calc(8.3333333333% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--1-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--1-offset-desktop.mdl-cell--1-offset-desktop{margin-left:8.3333333333%}.mdl-cell--2-offset,.mdl-cell--2-offset-desktop.mdl-cell--2-offset-desktop{margin-left:calc(16.6666666667% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--2-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--2-offset-desktop.mdl-cell--2-offset-desktop{margin-left:16.6666666667%}.mdl-cell--3-offset,.mdl-cell--3-offset-desktop.mdl-cell--3-offset-desktop{margin-left:calc(25% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--3-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--3-offset-desktop.mdl-cell--3-offset-desktop{margin-left:25%}.mdl-cell--4-offset,.mdl-cell--4-offset-desktop.mdl-cell--4-offset-desktop{margin-left:calc(33.3333333333% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--4-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--4-offset-desktop.mdl-cell--4-offset-desktop{margin-left:33.3333333333%}.mdl-cell--5-offset,.mdl-cell--5-offset-desktop.mdl-cell--5-offset-desktop{margin-left:calc(41.6666666667% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--5-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--5-offset-desktop.mdl-cell--5-offset-desktop{margin-left:41.6666666667%}.mdl-cell--6-offset,.mdl-cell--6-offset-desktop.mdl-cell--6-offset-desktop{margin-left:calc(50% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--6-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--6-offset-desktop.mdl-cell--6-offset-desktop{margin-left:50%}.mdl-cell--7-offset,.mdl-cell--7-offset-desktop.mdl-cell--7-offset-desktop{margin-left:calc(58.3333333333% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--7-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--7-offset-desktop.mdl-cell--7-offset-desktop{margin-left:58.3333333333%}.mdl-cell--8-offset,.mdl-cell--8-offset-desktop.mdl-cell--8-offset-desktop{margin-left:calc(66.6666666667% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--8-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--8-offset-desktop.mdl-cell--8-offset-desktop{margin-left:66.6666666667%}.mdl-cell--9-offset,.mdl-cell--9-offset-desktop.mdl-cell--9-offset-desktop{margin-left:calc(75% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--9-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--9-offset-desktop.mdl-cell--9-offset-desktop{margin-left:75%}.mdl-cell--10-offset,.mdl-cell--10-offset-desktop.mdl-cell--10-offset-desktop{margin-left:calc(83.3333333333% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--10-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--10-offset-desktop.mdl-cell--10-offset-desktop{margin-left:83.3333333333%}.mdl-cell--11-offset,.mdl-cell--11-offset-desktop.mdl-cell--11-offset-desktop{margin-left:calc(91.6666666667% + 8px)}.mdl-grid.mdl-grid--no-spacing>.mdl-cell--11-offset,.mdl-grid.mdl-grid--no-spacing>.mdl-cell--11-offset-desktop.mdl-cell--11-offset-desktop{margin-left:91.6666666667%}}body{margin:0}.styleguide-demo h1{margin:48px 24px 0}.styleguide-demo h1:after{content:'''';display:block;width:100%;border-bottom:1px solid rgba(0,0,0,.5);margin-top:24px}.styleguide-demo{opacity:0;transition:opacity .6s ease}.styleguide-masthead{height:256px;background:#212121;padding:115px 16px 0}.styleguide-container{position:relative;max-width:960px;width:100%}.styleguide-title{color:#fff;bottom:auto;position:relative;font-size:56px;font-weight:300;line-height:1;letter-spacing:-.02em}.styleguide-title:after{border-bottom:0}.styleguide-title span{font-weight:300}.mdl-styleguide .mdl-layout__drawer .mdl-navigation__link{padding:10px 24px}.demosLoaded .styleguide-demo{opacity:1}iframe{display:block;width:100%;border:none}iframe.heightSet{overflow:hidden}.demo-wrapper{margin:24px}.demo-wrapper iframe{border:1px solid rgba(0,0,0,.5)}'
]

{ #category : #sass }
CPPSLibrary >> querySass [
	^ '@import "variables"

.query
  +box
  +displayFlex
  +flexDirection(column)

  .query-path
    +displayFlex
    width: 100%
    min-height: 44px
    font-size: 12px
    overflow: visible
    z-index: 4
    position: relative
    white-space: nowrap

    .line-query-path
      +displayFlex
      +flexGrow
      position: relative
      height: 44px
      overflow: hidden

      &:hover
        z-index: 10
        overflow: visible

    a
      color: rgba(0,0,0,.54)
      text-decoration: none
      display: block
      padding: 0 25px

    .query-path__segment
      +query-path__segment_color($white)
      line-height: 44px
      height: 43px
      border-bottom: rgba(0, 0, 0, 0.41) solid 1px
      text-transform: uppercase
      position: relative
      left: 0

      &:after
        +abs-pos(0, -32px)
        +box(30px)
        +css3(transform, rotate(45deg))
        content: ""
        transform-origin: 0 0
        border:
          top: 2px dotted rgba(0, 0, 0, 0.41)
          right: 2px dotted rgba(0, 0, 0, 0.41)
        z-index: 2

      .on-hover
        display: none
        border-left: rgba(0, 0, 0, 0.41) solid 1px
        background-color: $white

        .on-hover
          position: absolute
          left: 100%
          top: 0px

    .query-path__segment.current.combinator
      +query-path__segment_current($orange200, $orange300)

      & > a
        color: $secondary-black-text

    .query-path__segment.current
      +query-path__segment_current($orange, $orange600)

      & ~ .query-path__segment
        +query-path__segment_color($grey300)

      & > a
        color: $white

    i
      vertical-align: middle
      font-size: 18px
      padding-right: 5px

    .query-path__save
      height: 44px
      background-color: $blueGrey50

  .query-browser-seed
    +box
    overflow: auto

    .mdl-card
      min-height: 130px
      cursor: pointer
      background-color: $blueGrey50

      &:hover
        background-color: $orange300

      .mdl-card__supporting-text
        font-size: 20px

  .query-content
    +displayFlex
    +flexGrow
    height: 100px

    .query-left-panel
      +box(350px, 100%)

    .query-content-main
      +box(1px, 100%)
      +flex(1 1 auto)
      overflow: hidden

  #queries
    .query-list__toolbar
      +displayFlex
      width: 100%
      justify-content: space-around
      flex-wrap: wrap

      button
        margin-top: 20px

    .mdl-list__item-avatar
      +box(36px)
      padding: 8px
      font-size: 20px
      background-color: $grey400

    .telescopeVisu
      +box(100%, 70vh)

      canvas
        left: 0

    h3
      text-transform: uppercase
      color: rgba(0,0,0,.54)
      font-size: 16px

  .query-manager
    +box
    +displayFlex

    .material-design-left-panel
      +flex(1 1 auto)

    .query-manager-result
      +box(300px, 100%)
      +flex(1 1 auto)
      position: relative

      .query-by-step-list
        height: 100%

        .titledComponent
          display: inline-block
          width: 300px
          margin-left: 10px

    .query-manager-content
      +flex(4 1 calc(100% - 701px))
      +transition(all 2s)

      .query-manager-content__panel
        +box(95%, 100%)
        +displayFlex
        +flexDirection(column)
        margin: auto
        background-color: $white
        overflow: hidden

        &:hover
          overflow: auto

        .query-manager-content__queries
          +displayFlex
          +flexDirection(column)
          +flexGrow
          width: 90%
          margin: auto

    .right-panel
      .helpIcon
        top: 5px
        right: auto

      .component
        +displayFlex
        +flexDirection(column)

        .nestedList
          +flexGrow
          height: 100px

          .listContainer a
            width: 30px
            margin-right: 5px

      .query-manager-right-panel__options
        +displayFlex
        justify-content: space-around

        .mdl-button
          margin-top: 4px

      .query-query-list__actions
        display: flex
        justify-content: space-around

      .query-tagger
        +box
        +displayFlex
        +flexDirection(column)
        overflow: hidden

        .query-tagger-list
          +flexGrow
          height: 1px
          overflow: auto
          width: 90%
          max-width: 700px
          margin: auto

        .query-tagger-legend
          +displayFlex
          padding:
            bottom: 20px
            top: 10px


          &> div
            +flex(1)
            font-size: 16px
            line-height: 16px
            text-align: center

            i
              vertical-align: middle
              margin-right: 5px
              color: $accentColor

  .query-manager.right-panel__extended
    .query-manager-content
      display: none

    .right-panel
      +flexGrow(5)

    .vertical-toolbar
      margin-left: 20px

  thead
    th
      font-size: 14px !important

  .mdl-list__item
    padding: 5px 16px

  .mdl-list__item--three-line
    height: 70px

  .errorMessage
    color: #a94442
    background-color: #f2dede
    padding: 15px
    margin-bottom: 20px
    border: 1px solid #ebccd1
    +border-radius(4px)

  //TODO Check if still used
  .newTag
    text-align: center
    margin-top: 20px
    display: inline-flex

  .retractable
    position: relative
    margin-top: 30px
    min-height: 15px

  .mdl-tabs__tab-bar .mdl-tabs__tab
    max-width: 100px !important

  .buttons button
    margin: 5px 15px

  #query-create-simple

    h3
      text-align: center

    .query-create-simple__content
      text-align: center
      display: flex

      .query-create-simple__selection
        cursor: pointer
        padding: 20px
        flex: 1
        text-align: center

      form
        width: 100%

    .query-create-simple__buttons
      margin-top: 20px



//NEED REVIEW:
.formGroup
  border: 1px solid $borderColor
  padding: 20px 0
  position: relative
  margin: 35px 10px 10px

  .choices
    +displayFlex
    width: 100%
    flex-wrap: wrap

    label
      text-align: left
      display: initial

    &> div
      +flex(1)
      min-width: 200px

  h3
    +abs-pos(-20px, auto, auto, 20px)
    margin-top: 0
    background-color: $white
    padding: 0 10px
    text-transform: uppercase
    color: rgba(0,0,0,.54)
    font-size: 16px
'
]

{ #category : #sass }
CPPSLibrary >> rulesBrowserSass [
	^ '@import "variables"

.rules-browser
  +box
  +displayFlex

  .rules
    +box(100%, 30%)

  .entities
    +box(100%, 70%)

  .titledComponent
    +box(100%)
    border-bottom: 2px solid $borderColor

  .rules-browser-content
    +flex(1 1 auto)
'
]

{ #category : #sass }
CPPSLibrary >> sasslintYml [
	^ 'options:
  formatter: stylish
files:
  include: ''**/*.sass''
rules:
  # Extends
  extends-before-mixins: 1
  extends-before-declarations: 1
  placeholder-in-extend: 1

  # Mixins
  mixins-before-declarations: 1

  # Line Spacing
  one-declaration-per-line: 1
  empty-line-between-blocks: 1
  single-line-per-selector: 1

  # Disallows
  no-attribute-selectors: 0
  no-color-hex: 0
  no-color-keywords: 1
  no-color-literals: 1
  no-combinators: 0
  no-css-comments: 1
  no-debug: 1
  no-disallowed-properties: 0
  no-duplicate-properties: 1
  no-empty-rulesets: 1
  no-extends: 0
  no-ids: 1
  no-important: 1
  no-invalid-hex: 1
  no-mergeable-selectors: 1
  no-misspelled-properties: 1
  no-qualifying-elements: 1
  no-trailing-whitespace: 1
  no-trailing-zero: 1
  no-transition-all: 1
  no-universal-selectors: 0
  no-url-domains: 1
  no-url-protocols: 1
  no-vendor-prefixes: 1
  no-warn: 1
  property-units: 0

  # Nesting
  declarations-before-nesting: 1
  force-attribute-nesting: 1
  force-element-nesting: 1
  force-pseudo-nesting: 1

  # Name Formats
  class-name-format: 1
  function-name-format: 1
  id-name-format: 0
  mixin-name-format: 1
  placeholder-name-format: 1
  variable-name-format: 1

  # Style Guide
  attribute-quotes: 1
  bem-depth: 0
  border-zero: 1
  brace-style: 1
  clean-import-paths: 1
  empty-args: 1
  hex-length: 1
  hex-notation: 1
  indentation: 1
  leading-zero: 1
  max-line-length: 0
  max-file-line-count: 0
  nesting-depth: 1
  property-sort-order: 1
  pseudo-element: 1
  quotes:
    - 1
    - style: double # We want double quote because the files will be FileLibrary and it''s better not to have too many single quotes in Pharo.
  shorthand-values: 1
  url-quotes: 1
  variable-for-property: 1
  zero-unit: 1

  # Inner Spacing
  space-after-comma: 1
  space-before-colon: 1
  space-after-colon: 1
  space-before-brace: 1
  space-before-bang: 1
  space-after-bang: 1
  space-between-parens: 1
  space-around-operator:
    - 1
    - include: true # We force the space around for readability

  # Final Items
  trailing-semicolon: 1
  final-newline:
    - 1
    - include: false # New line at the end of the file is useless
'
]

{ #category : #accessing }
CPPSLibrary >> selectorsToInclude [

	self flag: #clean. "This class have some unused images that should be remove at the end of the developemnt."
	^ #( #materialindigoorangeminCss #siemensToolkitCss #siemensToolkitJs #FileSaverMinJs )
]

{ #category : #css }
CPPSLibrary >> siemensToolkitCss [
	^ 'html,body{width:100%;height:100%;font-size:14px;font-family:"Roboto","Helvetica","Arial",sans-serif;overflow:hidden}body{margin-bottom:0 !important}input:disabled{cursor:not-allowed}input[type=color]{cursor:pointer}input .material-icons{vertical-align:middle;padding-bottom:6px}.title-container{width:80%;margin:auto auto 10px auto;text-align:center;border-bottom:1px solid #bdbdbd}.title-container div{margin:8px 0}.title-container i{vertical-align:middle}.delete,.query-query-list__actions .delete,.remove,.unmatched{color:#f44336}.add,.matched{color:#4caf50}.defaultIconColor{color:#607d8b}.dangerHighlight,.dashboard .metrics .metricComponent:hover .danger,.danger:hover{background-color:#d32f2f}.warningHighlight,.dashboard .metrics .metricComponent:hover .warning,.warning:hover{background-color:#f57c00}.healthyHighlight,.dashboard .metrics .metricComponent:hover .healthy,.healthy:hover{background-color:#388e3c}.highAttentionHighlight,.dashboard .metrics .metricComponent:hover .highAttention,.highAttention:hover{background-color:#7b1fa2}.attentionHighlight,.dashboard .metrics .metricComponent:hover .attention,.attention:hover{background-color:#1976d2}.lowAttentionHighlight,.dashboard .metrics .metricComponent:hover .lowAttention,.lowAttention:hover{background-color:#0097a7}.danger{background-color:#f44336}.warning{background-color:#ff9800}.healthy{background-color:#4caf50}.highAttention{background-color:#9c27b0}.attention{background-color:#2196f3}.lowAttention{background-color:#00bcd4}.unavailable{background-color:#9c27b0}.unavailable:hover{background-color:#7b1fa2}.mdl-alert{display:inline-block;border:0;border-left:2px solid transparent;text-align:justify;max-width:600px;margin-top:10px;margin-bottom:10px;padding:10px}.mdl-alert__default{background-color:transparent;border-color:#607d8b;color:#607d8b}.mdl-alert__default a{color:#607d8b;text-decoration:none;font-style:italic;font-weight:bold}.mdl-alert__success{background-color:transparent;border-color:#009688;color:#009688}.mdl-alert__success a{color:#009688;text-decoration:none;font-style:italic;font-weight:bold}.mdl-alert__danger{background-color:transparent;border-color:#f44336;color:#f44336}.mdl-alert__danger a{color:#f44336;text-decoration:none;font-style:italic;font-weight:bold}.mdl-alert__warning{background-color:transparent;border-color:#ff9800;color:#ff9800}.mdl-alert__warning a{color:#ff9800;text-decoration:none;font-style:italic;font-weight:bold}.mdl-alert__primary{background-color:transparent;border-color:#3f51b5;color:#3f51b5}.mdl-alert__primary a{color:#3f51b5;text-decoration:none;font-style:italic;font-weight:bold}.mdl-alert__info{background-color:transparent;border-color:#2196f3;color:#2196f3}.mdl-alert__info a{color:#2196f3;text-decoration:none;font-style:italic;font-weight:bold}.error-message{-webkit-border-radius:4px;-moz-border-radius:4px;-ms-border-radius:4px;-o-border-radius:4px;border-radius:4px;background-clip:padding-box;color:#a94442;background-color:#f2dede;padding:15px;margin-bottom:20px;border:1px solid #e0e0e0}.text-center{text-align:center}.text-left{text-align:left}.text-right{text-align:right}.pull-right{float:right}.pull-right:before,.pull-right:after{content:"";display:table}.pull-right:after{clear:both}.pull-left{float:left}.auto-margin{margin:auto}.grey-background,.loginPage,.progressComponent{background:#eceff1}.spacer{-webkit-flex-grow:1;flex-grow:1}.form-control{width:100%;font-size:14px;color:#616161}.description{width:90%;margin:auto;padding-bottom:20px;padding-top:10px}.form-flex{display:-webkit-flex;display:flex;flex-wrap:wrap;justify-content:space-around;align-items:center}.form-flex .mdl-button{margin:5px}header .logo{height:48px !important;margin-left:15px}header .browser-name{-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;-o-user-select:none;user-select:none;margin-left:10px;font-size:18px}.browser{-webkit-flex-grow:1;flex-grow:1;height:1px}.loading-container{width:100%;height:100%;display:-webkit-flex;display:flex;align-items:center;justify-content:center}.loading-container .mdl-spinner{width:60px;height:60px}.mdl-navigation__link--current{font-weight:bold;background:#9fa8da !important;color:#fff !important}.mdl-navigation__link--current:hover{background:#7986cb !important}.table-cell a{text-decoration:none;color:initial}.table-cell i{cursor:pointer}input.toHide{top:0;right:auto;bottom:auto;left:0;position:absolute;opacity:0;filter:alpha(opacity=0);width:100px;height:40px;cursor:pointer}.uploadContainer{width:100px;height:40px;position:relative;display:block;margin:auto}.right-panel .title-container .mdl-typography--headline{font-size:18px}.right-panel .mdl-radio,.right-panel .mdl-checkbox__label{font-size:14px}.adminTools{width:100%;height:100%;background:#eee;overflow:auto}.adminTools .mdl-tabs__panel table{margin-left:auto;margin-right:auto;margin-bottom:auto;margin-top:30px}.adminTools .mdl-tabs__panel table .mdl-data-table__cell--non-numeric{width:150px}.adminTools .mdl-tabs__tab-bar{background:#fff}.adminTools .smallComponent{top:10%}.filter-component{width:100%;z-index:2}.filter-component .title{float:left;height:100%;display:inline-flex}.filter-component .title .mdl-button{color:#ff9800;margin:auto}.filter-component .mdl-chip{margin:5px;cursor:pointer}.filter-component .isActive{background-color:#ffcc80}.filter-component .isActive:active{background-color:#ffb74d}.filter-component .isActive .mdl-chip__contact{background-color:rgba(251,140,0,.5)}.filter-component .isActive .mdl-chip__action{color:#e65100}.versionCreator .dateAndTime{display:-webkit-flex;display:flex;align-items:center;-webkit-flex-direction:column;flex-direction:column;width:50%;margin:auto}.projectManager{width:100%;height:100%;background:#eee;top:0;left:0;right:0;bottom:0;overflow:auto}.loginPage,.progressComponent{width:100%;height:100%;overflow:auto}.tabPanel{width:100%;height:100%}.tabPanel .mdl-tabs__tab-bar,.tabPanel .mdl-tabs__ripple-container,.tabPanel .mdl-tabs__tab{height:58px;min-height:58px;line-height:initial}.tabPanel .mdl-tabs__tab-bar i{font-size:20px;margin:7px 0 0 0}.tabPanel .mdl-tabs__tab-bar .mdl-tabs__tab{font-size:12px;width:15%;max-width:90px;color:#9e9e9e}.tabPanel .mdl-tabs__tab-bar p{margin:0}.tabPanel .mdl-tabs__panel{overflow:auto;-webkit-flex:1 1 auto;-ms-flex:1 1 auto;flex:1 1 auto;height:1px}.tabPanel .mdl-tabs{width:100%;height:100%;display:-webkit-flex;display:flex;-webkit-flex-direction:column;flex-direction:column}.tabPanel .mdl-checkbox,.tabPanel .mdl-switch{text-align:initial}.tabPanel .submit{margin-top:20px}.tabPanel .colorTag{position:relative}.tabPanel .colorTag form{top:15px;right:auto;bottom:auto;left:auto;position:absolute;opacity:0;filter:alpha(opacity=0);cursor:pointer;padding-top:0}.tabPanel .colorTag i{font-size:40px !important}.save-component__path-input{display:inline-flex}.save-component__path-input i{line-height:66px}.create-version__persist-sources{text-align:left;width:300px;margin-bottom:20px}.toFold{-webkit-transition:width 1s;transition:width 1s}.table-toolbar{padding:8px}.table-toolbar:before,.table-toolbar:after{content:"";display:table}.table-toolbar:after{clear:both}.button-bar{display:-webkit-flex;display:flex;padding:20px;justify-content:flex-end}.flex-bar{display:-webkit-flex;display:flex;padding:8px}.flex-bar .text-center{-webkit-flex-grow:1;flex-grow:1}.flex-bar *{align-self:center;margin-left:8px}#root-dialog{min-width:800px}.infoComponent{overflow:hidden}.infoComponent:hover{overflow-y:auto}.infoComponent .mdl-data-table{width:100%}.material-design-left-panel{width:300px;height:100%;min-width:250px}.growing{-webkit-flex:1 1 auto;-ms-flex:1 1 auto;flex:1 1 auto;width:1px}.filter-browser{width:100%;height:100%;display:-webkit-flex;display:flex;-webkit-flex-direction:column;flex-direction:column}.filter-browser:target .toFold{width:0}.filter-browser .filter-browser-core{-webkit-flex-grow:1;flex-grow:1;height:100px;min-height:100px}.smallComponent{max-width:500px;position:relative;top:20%;margin:auto auto 10%;font-size:16px}.smallComponent h2{-webkit-border-radius:7px 7px 0 0;-moz-border-radius:7px 7px 0 0;-ms-border-radius:7px 7px 0 0;-o-border-radius:7px 7px 0 0;border-radius:7px 7px 0 0;background-clip:padding-box;font-size:14px;margin:0;text-align:center;text-transform:uppercase;background:#ff9800;color:#fff;font-weight:300}.smallComponent .form-wrap{width:100%;height:100%;display:-webkit-flex;display:flex;-webkit-flex-direction:column;flex-direction:column;align-items:center;position:initial;background-size:contain;text-align:center}.smallComponent .paddedForm{-webkit-border-radius:0 0 7px 7px;-moz-border-radius:0 0 7px 7px;-ms-border-radius:0 0 7px 7px;-o-border-radius:0 0 7px 7px;border-radius:0 0 7px 7px;background-clip:padding-box;padding:20px;background-color:#fff}.smallComponent .paddedForm .mdl-button--accent{max-width:200px;height:40px;bottom:0;color:#fff !important}.smallComponent button,.smallComponent .submit{display:block;margin:auto}.helpIcon{margin:0 10px}#code-container{height:100%}.code-container{width:200px;height:calc(100% - 40px);-webkit-flex:1 1 auto;-ms-flex:1 1 auto;flex:1 1 auto;margin:auto}.code-container .code-container-panel{width:90%;height:100%;box-shadow:0 4px 5px 0 rgba(0,0,0,.14),0 1px 10px 0 rgba(0,0,0,.12),0 2px 4px -1px rgba(0,0,0,.2);margin:auto}.code-container .code-container-panel .code-container-panel__content{height:calc(100% - 49px);display:-webkit-flex;display:flex;-webkit-flex-direction:column;flex-direction:column}.code-container .code-container-panel .code-container-panel__content .code-container-panel__options{display:-webkit-flex;display:flex;width:100%;justify-content:space-around;z-index:3}.code-container .code-container-panel .code-container-panel__content .code-container-panel__options .mdl-checkbox{margin-bottom:3px;margin-top:3px;width:initial}.code-container .code-container-panel .code-container-panel__content .minimap-container{overflow:hidden}.code-container .code-container-panel .code-container-panel__content pre{height:100%;margin-top:0;margin-bottom:0;padding-top:0;padding-bottom:0;overflow:hidden}.code-container .code-container-panel .code-container-panel__content pre:hover{overflow:auto}.titledComponent{width:100%;height:100%;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;-ms-box-sizing:border-box;-o-box-sizing:border-box;box-sizing:border-box}.titledComponent .title{border-bottom:1px solid #e0e0e0;height:40px;line-height:40px;background-color:#f5f5f5;color:#3f51b5}.titledComponent .component{height:calc(100% - 41px)}.yesNo{width:50%;min-width:200px;top:20%;position:relative;margin:auto auto 10%;padding:20px;background-color:#fff;border-radius:7px;-webkit-border-radius:7px;text-align:center}.yesNo h3{position:initial;font-family:"Open Sans",arial,serif;font-size:18px;margin-bottom:20px;margin-top:0}.yesNo .dialog-buttons{display:-webkit-flex;display:flex;justify-content:space-around}.yesNo .mdl-button--accent{margin-left:5%;margin-right:5%}.yesNo div{position:initial !important}.chip-selector{-webkit-border-radius:16px;-moz-border-radius:16px;-ms-border-radius:16px;-o-border-radius:16px;border-radius:16px;background-clip:padding-box;display:-webkit-flex;display:flex;width:90%;margin:20px auto;border:solid 1px #e0e0e0}.chip-selector .chip-selector__title{font-size:14px;font-size:1rem;font-size:12px;font-size:.8571428571rem;border-right:1px solid #e0e0e0;color:#9e9e9e;padding:0 3px}.chip-selector .chip-selector__content{-webkit-flex:1 1 auto;-ms-flex:1 1 auto;flex:1 1 auto}.chip-selector .chip-selector__content .mdl-chip{margin:5px}.chip-selector .chip-selector__add{color:#4caf50;border-left:solid 1px #e0e0e0}.chip-selector .chip-selector__add .mdl-button{-webkit-border-radius:0 16px 16px 0;-moz-border-radius:0 16px 16px 0;-ms-border-radius:0 16px 16px 0;-o-border-radius:0 16px 16px 0;border-radius:0 16px 16px 0;background-clip:padding-box;height:100%}.chip-selector .chip-selector__title,.chip-selector .chip-selector__content,.chip-selector .chip-selector__add{display:-webkit-flex;display:flex;flex-wrap:wrap}.chip-selector .chip-selector__title,.chip-selector .chip-selector__add{-webkit-flex-direction:column;flex-direction:column;justify-content:center}.chip-selector .mdl-dialog{width:480px}.chip-selector .mdl-dialog .mdl-dialog__content{text-align:center}.chip-selector .mdl-dialog .mdl-textfield{width:100%}.mdl-list__item-secondary-info{white-space:nowrap;width:120px;overflow:hidden;text-overflow:ellipsis;text-align:right}.mdl-layout__header{background:#283593}.mdl-checkbox,.mdl-radio{margin-bottom:20px}table .mdl-checkbox,table .mdl-radio{margin-bottom:initial}.mdl-snackbar{z-index:99999999}.mdl-button--accent.mdl-button--raised,.mdl-button--accent.mdl-button--fab{color:#fff !important}.mdl-button.mdl-button-small{height:28px;padding:0 8px;line-height:28px}.mdl-data-table th{color:#3f51b5;background-color:#f5f5f5}.mdl-badge[data-badge]:after{-webkit-border-radius:2px;-moz-border-radius:2px;-ms-border-radius:2px;-o-border-radius:2px;border-radius:2px;background-clip:padding-box;font-size:10px;height:16px;color:#fff;top:-8px}.mdl-badge-medium[data-badge]:after{width:34px;right:-36px}.mdl-badge-large[data-badge]:after{width:44px;right:-46px}.mdl-tabs__tab:hover{color:#000}.mdl-layout__header-row .mdl-navigation__link{text-align:center;line-height:initial}.mdl-slider-container label{color:#3f51b5}.mdl-button.mdl-button--accent.mdl-button--raised.mdl-button-danger,.mdl-button.mdl-button--accent.mdl-button-danger{color:#fff;background-color:#f44336}.mdl-card__title{text-transform:capitalize}.mdl-tooltip{width:initial;max-width:initial;text-align:justify}.mdl-textfield__input[type=number]{appearance:initial;-moz-appearance:initial;-webkit-appearance:initial}.mdl-textfield.compact{padding:0}.mdl-textfield--expandable{text-align:center}.mdl-tabs__panel{position:relative}.mdl-chip{-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;-o-user-select:none;user-select:none}i.list-tag-icon{vertical-align:middle;cursor:pointer;padding-right:0;margin:0;text-shadow:1px 1px 1px rgba(0,0,0,.2),-1px -1px 1px rgba(0,0,0,.1);color:#fff}i.list-tag-icon.rainbow{color:transparent;-webkit-background-clip:text;background-clip:text}.chartJsChart h3{font-size:16px;font-weight:300;letter-spacing:.5px;line-height:20px}.expList .itemContener.isSelected{background-color:#ffcc80 !important}.expList .itemContener.isSelected:hover{background-color:#ffb74d !important}.expList li:hover{z-index:1000}.expList li:nth-child(2n){background-color:#f5f5f5}.expList li:nth-child(2n):hover{background-color:#e0e0e0}.expList .mdl-chip__contact{width:24px;height:24px;font-size:12px;line-height:24px;margin-left:5px;border-radius:3px}.nestedList.altCompact .listContainer a{font-size:13px;font-weight:inherit}.nestedList.altCompact .expList li .item{line-height:24px}.nestedList.altCompact .expList .icon{height:24px}.nestedList.altCompact .expList img{height:20px;width:20px}.nestedList.altCompact .mdl-chip__contact{width:16px;height:16px;font-size:9px;line-height:16px;margin-left:5px;border-radius:2px}.mdl-table-compact tbody tr{height:38px}.mdl-table-compact tbody tr td{height:38px;padding:3px 6px}.telescopeVisu .tlLegend{background-color:#fff;right:5px;left:initial;border:1px solid #e0e0e0;padding:10px}.telescopeVisu .fitButton{left:5px}.telescopeVisu .fitButton a{-webkit-border-radius:2px;-moz-border-radius:2px;-ms-border-radius:2px;-o-border-radius:2px;border-radius:2px;background-clip:padding-box;min-width:64px;padding:0 16px;text-transform:uppercase;will-change:box-shadow;transition:box-shadow .2s cubic-bezier(0.4, 0, 1, 1),background-color .2s cubic-bezier(0.4, 0, 0.2, 1),color .2s cubic-bezier(0.4, 0, 0.2, 1);text-align:center}.telescopeVisu .fitButton a:hover{background-color:rgba(158,158,158,.2)}.telescopeVisu .fitButton img{width:24px;height:24px;-webkit-border-radius:10px;-moz-border-radius:10px;-ms-border-radius:10px;-o-border-radius:10px;border-radius:10px;background-clip:padding-box;padding:5px}.telescopeVisu .fitButton img:hover{background-color:rgba(158,158,158,.2)}.telescopeVisu .tlLegendIcon{width:30px}.prismComponent{min-height:100px}.prismComponent a{color:#f44336;text-decoration:none;font-weight:bold}.dashboard{display:flex;flex-flow:row wrap;height:100%}.dashboard .metrics{-webkit-flex:1 100%;-ms-flex:1 100%;flex:1 100%;display:-webkit-flex;display:flex;background-color:#eee;height:110px;overflow-x:auto;overflow-y:hidden}.dashboard .metrics .metricComponent{-webkit-border-radius:4px;-moz-border-radius:4px;-ms-border-radius:4px;-o-border-radius:4px;border-radius:4px;background-clip:padding-box;-webkit-flex:1;-ms-flex:1;flex:1;background-color:#fff;height:80px;cursor:pointer;min-width:220px;margin:10px}.dashboard .metrics .metricComponent .icon{-webkit-border-radius:4px 0 0 4px;-moz-border-radius:4px 0 0 4px;-ms-border-radius:4px 0 0 4px;-o-border-radius:4px 0 0 4px;border-radius:4px 0 0 4px;background-clip:padding-box;width:35%;height:100%;float:left;display:table}.dashboard .metrics .metricComponent .icon i{font-size:24px;font-size:1.7142857143rem;color:#fff;display:table-cell;vertical-align:middle}.dashboard .metrics .metricComponent .value{width:65%;color:#b0bec5;display:inline-block;position:relative}.dashboard .metrics .metricComponent .value .metricVal{font-size:16px;font-size:1.1428571429rem;font-weight:300;display:block}.dashboard .metrics .metricComponent .value .label{top:0;right:0;bottom:0;left:0;position:absolute;font-size:12px;font-size:.8571428571rem;line-height:20px;line-height:1.6666666667rem;width:100%}.dashboard .metrics .metricComponent .icon,.dashboard .metrics .metricComponent .value{text-align:center}.dashboard .metrics .metricComponent.mdl-shadow--4dp{height:90px}.dashboard #dashboard_graphs{width:100%;height:calc(100% - 110px);display:-webkit-flex;display:flex;flex-wrap:wrap;justify-content:space-around;overflow-y:auto}.dashboard #dashboard_graphs .chartJsChart{margin-top:10px;width:44%;text-align:center}.dashboard #dashboard_graphs .chartJsChart .mdl-alert{margin-top:50px !important}.dashboard #dashboard_graphs .ChartBoxPlot .chartJsGraph{width:55%}.dashboard #dashboard_graphs .ChartBoxPlot .chartJsLegend,.dashboard #dashboard_graphs .ChartPie .chartJsLegend{width:45%}.dashboard #dashboard_graphs.numberOfLinesOfCode .ChartBoxPlot{width:30%}.dashboard #dashboard_graphs.numberOfLinesOfCode .ChartBoxPlot .chartJsGraph{width:80%}.dashboard #dashboard_graphs.numberOfLinesOfCode .ChartBoxPlot .chartJsLegend{display:none}@media screen and (max-width: 1500px){.metricComponent .label{font-size:10px;font-size:.7142857143rem}}.code-analyzer-block-panel{width:100%;height:100%;display:-webkit-flex;display:flex;flex-direction:column}.code-analyzer-block-panel .search{text-align:center}.code-analyzer-block-panel .code-analyzer-right-panel_code{-webkit-flex-grow:1;flex-grow:1;overflow:hidden}.toFoldContainer{display:-webkit-flex;display:flex;flex-wrap:nowrap}.activeByHand::after{width:100%;height:2px;top:auto;right:auto;bottom:0;left:0;position:absolute;-webkit-transition:all 1s cubic-bezier(0.4, 0, 1, 1);transition:all 1s cubic-bezier(0.4, 0, 1, 1);-webkit-animation:border-expand .2s cubic-bezier(0.4, 0, 0.4, 1) .01s alternate forwards;animation:border-expand .2s cubic-bezier(0.4, 0, 0.4, 1) .01s alternate forwards;display:block;content:" ";background:#3f51b5}.code-analyzer .withSelect.mdl-tabs__tab{max-width:200px;overflow:visible;padding:0}.code-analyzer .withSelect.mdl-tabs__tab .mdl-textfield{line-height:initial}.code-analyzer .withSelect.mdl-tabs__tab .mdl-select .mdl-menu__container .mdl-menu .mdl-menu__item{font-size:12px}.code-analyzer .code-analyzer-content #code-container{-webkit-flex-grow:1;flex-grow:1;height:1px}.code-analyzer .code-analyzer-content .export-button{top:5px;right:auto;bottom:auto;left:150px;position:absolute;z-index:2}.code-analyzer .code-analyzer-info{width:100%;height:100%}.code-analyzer .code-analyzer-info .infoComponent{border-bottom:1px solid #ff9800;box-sizing:border-box}.code-analyzer .code-analyzer-info table{border-right:0;border-left:0}.code-analyzer .code-analyzer-info table td{max-width:200px;overflow:hidden;text-overflow:ellipsis}.code-analyzer .code-analyzer-info .attributes .mdl-grid{padding:0}.code-analyzer .code-analyzer-info .attributes .mdl-grid .mdl-card{box-shadow:none}.code-analyzer .tag-categories .mdl-dialog{left:unset;right:20px}.code-analyzer #code-analyzer__tag-modal dialog{min-width:600px}.code-analyzer .prismSelectionMenu{-webkit-border-radius:2px;-moz-border-radius:2px;-ms-border-radius:2px;-o-border-radius:2px;border-radius:2px;background-clip:padding-box;line-height:24px;line-height:2rem;background:#fff;margin:0;padding:8px 0;box-shadow:0 1px 6px rgba(0,0,0,.12),0 1px 4px rgba(0,0,0,.12);z-index:1000;white-space:nowrap;border:none}.code-analyzer .prismSelectionMenu>div{border-bottom:1px solid #e0e0e0;cursor:pointer;position:relative;margin-left:0;padding:5px 24px;transition:all 450ms cubic-bezier(0.23, 1, 0.32, 1) 0ms}.code-analyzer .prismSelectionMenu>div:hover{background:rgba(0,0,0,.1) none repeat scroll 0 0}.duplication{width:100%;height:100%;display:-webkit-flex;display:flex}.duplication .titledComponent{border-bottom:2px solid #e0e0e0}.duplication .duplicated,.duplication .containers{width:100%;height:50%}.duplication .containers{overflow-x:auto}.duplication .containers table{width:100%;max-height:calc( 100% - 36px );border:0;overflow:hidden}.duplication .containers table:hover{overflow:auto}.duplication .duplication-actionButtons{display:-webkit-flex;display:flex;justify-content:space-around}.duplication #duplication-content .code-container .code-container-panel{width:97%;height:100%}.duplication #duplication-content .code-container .code-container-panel .code-container-panel__content{height:100%}.duplication #duplication-content .code-container .duplicated{color:#f44336}.duplication #duplication-content .code-container .duplicated .token{color:#f44336}.duplication #duplication-content .duplication-content__clones{width:100%;height:100%;padding:0;display:flex;justify-content:space-between}.duplication #duplication-content .duplication-content__visu-fragment{width:100%;height:100%;display:-webkit-flex;display:flex}.duplication #duplication-content .duplication-content__visu-fragment .chartJsChart{width:50%;margin:auto}.duplication #duplication-content .duplication-content__visu-fragment .chartJsGraph{width:100%}.duplication .message{-webkit-border-radius:10px;-moz-border-radius:10px;-ms-border-radius:10px;-o-border-radius:10px;border-radius:10px;background-clip:padding-box;font-size:18px;font-size:1.2857142857rem;padding-top:50px;padding-bottom:50px;background:#ededed none repeat scroll 0 0;min-width:200px;margin:auto;width:50%}.treeExplorer{width:100%;height:100%;display:-webkit-flex;display:flex}.treeExplorer .content{width:1px;height:100%;-webkit-flex:1 1 auto;-ms-flex:1 1 auto;flex:1 1 auto}.architectural-vision{width:100%;height:100%;display:-webkit-flex;display:flex;flex-wrap:nowrap}.architectural-vision .architectural-vision__visualization{height:calc(100% - 69px);margin-bottom:20px;position:relative}.architectural-vision .architectural-vision__visualization .architecture-drill-down{top:5px;right:auto;bottom:auto;left:155px;position:absolute;z-index:2}.rules-browser{width:100%;height:100%;display:-webkit-flex;display:flex}.rules-browser .rules{width:100%;height:30%}.rules-browser .entities{width:100%;height:70%}.rules-browser .titledComponent{width:100%;height:100%;border-bottom:2px solid #e0e0e0}.rules-browser .rules-browser-content{-webkit-flex:1 1 auto;-ms-flex:1 1 auto;flex:1 1 auto}.query{width:100%;height:100%;display:-webkit-flex;display:flex;-webkit-flex-direction:column;flex-direction:column}.query .query-path{display:-webkit-flex;display:flex;width:100%;min-height:44px;font-size:12px;overflow:visible;z-index:4;position:relative;white-space:nowrap}.query .query-path .line-query-path{display:-webkit-flex;display:flex;-webkit-flex-grow:1;flex-grow:1;position:relative;height:44px;overflow:hidden}.query .query-path .line-query-path:hover{z-index:10;overflow:visible}.query .query-path a{color:rgba(0,0,0,.54);text-decoration:none;display:block;padding:0 25px}.query .query-path .query-path__segment{background-color:#fff;line-height:44px;height:43px;border-bottom:rgba(0,0,0,.41) solid 1px;text-transform:uppercase;position:relative;left:0}.query .query-path .query-path__segment:after{background-color:#fff}.query .query-path .query-path__segment:hover{background-color:#eceff1}.query .query-path .query-path__segment:hover>.on-hover{display:inherit}.query .query-path .query-path__segment:hover:after{background-color:#eceff1;background-clip:content-box}.query .query-path .query-path__segment:after{top:0;right:-32px;bottom:auto;left:auto;position:absolute;width:30px;height:30px;-webkit-transform:rotate(45deg);-moz-transform:rotate(45deg);-ms-transform:rotate(45deg);-o-transform:rotate(45deg);transform:rotate(45deg);content:"";transform-origin:0 0;border-top:2px dotted rgba(0,0,0,.41);border-right:2px dotted rgba(0,0,0,.41);z-index:2}.query .query-path .query-path__segment .on-hover{display:none;border-left:rgba(0,0,0,.41) solid 1px;background-color:#fff}.query .query-path .query-path__segment .on-hover .on-hover{position:absolute;left:100%;top:0px}.query .query-path .query-path__segment.current.combinator{background-color:#ffcc80}.query .query-path .query-path__segment.current.combinator:after{background-color:#ffcc80;background-clip:content-box}.query .query-path .query-path__segment.current.combinator:hover{background-color:#ffb74d}.query .query-path .query-path__segment.current.combinator:hover:after{background-color:#ffb74d;background-clip:content-box}.query .query-path .query-path__segment.current.combinator>a{color:rgba(0,0,0,.54)}.query .query-path .query-path__segment.current{background-color:#ff9800}.query .query-path .query-path__segment.current:after{background-color:#ff9800;background-clip:content-box}.query .query-path .query-path__segment.current:hover{background-color:#fb8c00}.query .query-path .query-path__segment.current:hover:after{background-color:#fb8c00;background-clip:content-box}.query .query-path .query-path__segment.current~.query-path__segment{background-color:#e0e0e0}.query .query-path .query-path__segment.current~.query-path__segment:after{background-color:#e0e0e0}.query .query-path .query-path__segment.current~.query-path__segment:hover{background-color:#eceff1}.query .query-path .query-path__segment.current~.query-path__segment:hover>.on-hover{display:inherit}.query .query-path .query-path__segment.current~.query-path__segment:hover:after{background-color:#eceff1;background-clip:content-box}.query .query-path .query-path__segment.current>a{color:#fff}.query .query-path i{vertical-align:middle;font-size:18px;padding-right:5px}.query .query-path .query-path__save{height:44px;background-color:#eceff1}.query .query-browser-seed{width:100%;height:100%;overflow:auto}.query .query-browser-seed .mdl-card{min-height:130px;cursor:pointer;background-color:#eceff1}.query .query-browser-seed .mdl-card:hover{background-color:#ffb74d}.query .query-browser-seed .mdl-card .mdl-card__supporting-text{font-size:20px}.query .query-content{display:-webkit-flex;display:flex;-webkit-flex-grow:1;flex-grow:1;height:100px}.query .query-content .query-left-panel{width:350px;height:100%}.query .query-content .query-content-main{width:1px;height:100%;-webkit-flex:1 1 auto;-ms-flex:1 1 auto;flex:1 1 auto;overflow:hidden}.query #queries .query-list__toolbar{display:-webkit-flex;display:flex;width:100%;justify-content:space-around;flex-wrap:wrap}.query #queries .query-list__toolbar button{margin-top:20px}.query #queries .mdl-list__item-avatar{width:36px;height:36px;padding:8px;font-size:20px;background-color:#bdbdbd}.query #queries .telescopeVisu{width:100%;height:70vh}.query #queries .telescopeVisu canvas{left:0}.query #queries h3{text-transform:uppercase;color:rgba(0,0,0,.54);font-size:16px}.query .query-manager{width:100%;height:100%;display:-webkit-flex;display:flex}.query .query-manager .material-design-left-panel{-webkit-flex:1 1 auto;-ms-flex:1 1 auto;flex:1 1 auto}.query .query-manager .query-manager-result{width:300px;height:100%;-webkit-flex:1 1 auto;-ms-flex:1 1 auto;flex:1 1 auto;position:relative}.query .query-manager .query-manager-result .query-by-step-list{height:100%}.query .query-manager .query-manager-result .query-by-step-list .titledComponent{display:inline-block;width:300px;margin-left:10px}.query .query-manager .query-manager-content{-webkit-flex:4 1 calc(100% - 701px);-ms-flex:4 1 calc(100% - 701px);flex:4 1 calc(100% - 701px);-webkit-transition:all 2s;transition:all 2s}.query .query-manager .query-manager-content .query-manager-content__panel{width:95%;height:100%;display:-webkit-flex;display:flex;-webkit-flex-direction:column;flex-direction:column;margin:auto;background-color:#fff;overflow:hidden}.query .query-manager .query-manager-content .query-manager-content__panel:hover{overflow:auto}.query .query-manager .query-manager-content .query-manager-content__panel .query-manager-content__queries{display:-webkit-flex;display:flex;-webkit-flex-direction:column;flex-direction:column;-webkit-flex-grow:1;flex-grow:1;width:90%;margin:auto}.query .query-manager .right-panel .helpIcon{top:5px;right:auto}.query .query-manager .right-panel .component{display:-webkit-flex;display:flex;-webkit-flex-direction:column;flex-direction:column}.query .query-manager .right-panel .component .nestedList{-webkit-flex-grow:1;flex-grow:1;height:100px}.query .query-manager .right-panel .component .nestedList .listContainer a{width:30px;margin-right:5px}.query .query-manager .right-panel .query-manager-right-panel__options{display:-webkit-flex;display:flex;justify-content:space-around}.query .query-manager .right-panel .query-manager-right-panel__options .mdl-button{margin-top:4px}.query .query-manager .right-panel .query-query-list__actions{display:flex;justify-content:space-around}.query .query-manager .right-panel .query-tagger{width:100%;height:100%;display:-webkit-flex;display:flex;-webkit-flex-direction:column;flex-direction:column;overflow:hidden}.query .query-manager .right-panel .query-tagger .query-tagger-list{-webkit-flex-grow:1;flex-grow:1;height:1px;overflow:auto;width:90%;max-width:700px;margin:auto}.query .query-manager .right-panel .query-tagger .query-tagger-legend{display:-webkit-flex;display:flex;padding-bottom:20px;padding-top:10px}.query .query-manager .right-panel .query-tagger .query-tagger-legend>div{-webkit-flex:1;-ms-flex:1;flex:1;font-size:16px;line-height:16px;text-align:center}.query .query-manager .right-panel .query-tagger .query-tagger-legend>div i{vertical-align:middle;margin-right:5px;color:#ff9800}.query .query-manager.right-panel__extended .query-manager-content{display:none}.query .query-manager.right-panel__extended .right-panel{-webkit-flex-grow:5;flex-grow:5}.query .query-manager.right-panel__extended .vertical-toolbar{margin-left:20px}.query thead th{font-size:14px !important}.query .mdl-list__item{padding:5px 16px}.query .mdl-list__item--three-line{height:70px}.query .errorMessage{color:#a94442;background-color:#f2dede;padding:15px;margin-bottom:20px;border:1px solid #ebccd1;-webkit-border-radius:4px;-moz-border-radius:4px;-ms-border-radius:4px;-o-border-radius:4px;border-radius:4px;background-clip:padding-box}.query .newTag{text-align:center;margin-top:20px;display:inline-flex}.query .retractable{position:relative;margin-top:30px;min-height:15px}.query .mdl-tabs__tab-bar .mdl-tabs__tab{max-width:100px !important}.query .buttons button{margin:5px 15px}.query #query-create-simple h3{text-align:center}.query #query-create-simple .query-create-simple__content{text-align:center;display:flex}.query #query-create-simple .query-create-simple__content .query-create-simple__selection{cursor:pointer;padding:20px;flex:1;text-align:center}.query #query-create-simple .query-create-simple__content form{width:100%}.query #query-create-simple .query-create-simple__buttons{margin-top:20px}.formGroup{border:1px solid #e0e0e0;padding:20px 0;position:relative;margin:35px 10px 10px}.formGroup .choices{display:-webkit-flex;display:flex;width:100%;flex-wrap:wrap}.formGroup .choices label{text-align:left;display:initial}.formGroup .choices>div{-webkit-flex:1;-ms-flex:1;flex:1;min-width:200px}.formGroup h3{top:-20px;right:auto;bottom:auto;left:20px;position:absolute;margin-top:0;background-color:#fff;padding:0 10px;text-transform:uppercase;color:rgba(0,0,0,.54);font-size:16px}.tag-manager{width:100%;height:100%;display:-webkit-flex;display:flex;flex-wrap:nowrap}.tag-manager .telescopeVisu{width:95%;margin:auto}.tag-manager #delete{text-align:center}.tag-manager #delete .mdl-card{display:inline-block;margin:30px}.tag-manager .tag-manager-content .mdl-tabs__panel{background-color:#e0e0e0}.tag-manager .tag-manager-content .mdl-tabs__panel .panel{-webkit-border-radius:10px;-moz-border-radius:10px;-ms-border-radius:10px;-o-border-radius:10px;border-radius:10px;background-clip:padding-box;width:80%;min-width:300px;background-color:#fff;padding:20px;overflow:visible;margin:50px auto}.tag-manager .tag-manager-content #vizualization{width:100%;height:100%}.tag-manager .right-panel .panel{overflow:auto;height:100%}.tag-manager .tag-categories{width:70%}.tag-manager .exportButtons{text-align:center}.tag-manager .exportButtons button{font-size:12px;margin:0 5px}.tag-manager .tree{height:calc(100% - 36px)}.tag-manager .deleteButton{margin-bottom:20px !important;background-color:#ef5350 !important;color:#fff !important}.tag-manager .splitNewTags .mdl-textfield{margin-right:20px}.tag-manager #edit .mdl-dialog:first-of-type{min-width:600px}.tag-table td:nth-child(3),.query-browser__table td:nth-child(2){white-space:nowrap;max-width:300px;overflow:hidden;text-overflow:ellipsis}.new-simple-tag{width:100%;text-align:center}.new-simple-tag>div{display:inline-flex}.new-simple-tag i{color:#4caf50;line-height:66px;margin-left:20px;cursor:pointer}#tag-list-decorator{display:-webkit-flex;display:flex;-webkit-flex-direction:column;flex-direction:column;height:100%}#tag-list-decorator #toolTagList{text-align:center;display:flex;flex-wrap:wrap;justify-content:space-around;align-items:center;padding-top:10px}#tag-list-decorator #toolTagList .tag-categories{width:100%;margin:0 10px}#tag-list-decorator #tagListContainer{-webkit-flex-grow:1;flex-grow:1;height:300px;box-sizing:border-box;overflow:hidden}#tag-list-decorator #tagListContainer:hover{overflow:auto}.mdl-dialog__content .tagList{height:60vh}.architecture{display:-webkit-flex;display:flex;width:100%;height:100%;-webkit-flex-direction:column;flex-direction:column}.architecture .architecture-menu{display:-webkit-flex;display:flex;align-items:center;justify-content:space-between;background-color:#fff;z-index:2}.architecture .architecture-menu .architecture-menu__selection-item{display:-webkit-flex;display:flex;align-items:center}.architecture .architecture-menu .architecture-menu__selection-item form{margin-left:10px}.architecture .architecture-menu .mdl-textfield{padding:20px 0 0 0}.architecture .architecture-menu .mdl-textfield .mdl-textfield__label::after{bottom:0}.architecture .architecture-menu .architecture-menu__mode{width:150px}.architecture .architecture-menu i:not(.mdl-icon-toggle__label){cursor:pointer}.architecture .architecture-menu .architecture-menu__right{display:-webkit-flex;display:flex;padding-left:10px;border-left:1px solid #e0e0e0;align-items:center}.architecture .architecture-menu .architecture-menu__right>*{padding-right:30px}.architecture .architecture-content{display:-webkit-flex;display:flex;-webkit-flex-grow:1;flex-grow:1;height:100px;min-height:100px;z-index:1}.architecture .architecture-content .architecture-drill-down{top:5px;right:auto;bottom:auto;left:155px;position:absolute;z-index:2}.architecture .architecture-new__form button{display:inline-block}.architecture .architecture-new__form .architecture-new__radio label{display:block;text-align:left}.architecture .architecture-new__form .architecture-new__option-duplication{text-align:center;width:100%}.architecture .architecture-new__form .cancel{align-self:end}.architecture #architecture-grid{padding:0;position:relative}.architecture #architecture-grid .mdl-cell{margin:0;box-shadow:-2px 0px 3px 0 #e0e0e0;position:relative}.architecture #architecture-grid .architecture-grid__fab{top:auto;right:-23px;bottom:0;left:auto;position:absolute}.architecture #architecture-right-panel{width:30%;height:100%;overflow:hidden;max-width:400px}.architecture #architecture-right-panel:hover{overflow-y:auto}.architecture #architecture-right-panel .mdl-textfield{width:100%}.architecture #architecture-right-panel .new-simple-tag>div>form{-webkit-flex-grow:1;flex-grow:1}.correlations{width:100%;height:100%;display:-webkit-flex;display:flex;flex-wrap:nowrap}.correlations .right-panel .panel{overflow:auto;height:100%}.correlations .correlations-content .mdl-sorted-table td i{width:100%;text-align:center}/*# sourceMappingURL=siemensToolkit.css.map */
'
]

{ #category : #javascript }
CPPSLibrary >> siemensToolkitJs [
	^ 'SiemensToolkit = {};

SiemensToolkit.bindNestedListWith= function(nestedList, callback) {

  function getSelectedLi(){
    return $(nestedList).find(".itemContener.isSelected").closest("li");
  }

  function nextElement (){
    callback(getSelectedLi().next())
  };

  function prevElement (){
    callback(getSelectedLi().prev())
  };

  bindings = {};

  bindings[40] = nextElement;
  bindings[38] = prevElement;

  $(document).keydown(function(event) {
	  if(bindings[event.keyCode]) {
			bindings[event.keyCode](event.target);
			event.preventDefault();
  		}
	});

}

function initQueryBrowserFilter() {
    var input = $(''.right-panel .listResearchField .mdl-textfield__input'');
    input.change(function () {
        $(''.query-manager-right-panel__options button'').prop(''disabled'', (input.val() === ''''));
    });

    input.change();
}

function extendQueryRightPanel() {
    $(".query-manager").addClass("right-panel__extended");
}

function shrinkQueryRightPanel() {
    $(".query-manager").removeClass("right-panel__extended");
}

function setNestedListFilterWithContentOfEntry(filterId, entry) {
    var filter = document.getElementById(filterId);
    var content = entry.getElementsByClassName("item")[0].innerHTML;
    //Escape the : because they can make regex
    content = content.split(":").join("\\:");
    filter.parentNode.MaterialTextfield.change(content);
    $(filter).change();
}

function replaceContentBySpinner(aNode){
    aNode.innerHTML = ''<div class="loading-container"><div class="mdl-spinner mdl-spinner--single-color mdl-js-spinner is-active"></div></div>'';
    componentHandler.upgradeDom();
}

function initDashboard() {
    var list = document.getElementsByClassName("metricComponent");
    for (var i = 0; i < list.length; i++) {
        list[i].addEventListener("click", function () {
            replaceContentBySpinner(document.getElementById("dashboard_graphs"));
        });
    }
}

function initFiltersChipsToAddSpinnerIn(anId){
    var list = document.getElementById("filter-component").getElementsByClassName("mdl-chip");
    for (var i = 0; i < list.length; i++) {
        list[i].addEventListener("click", function () {
            replaceContentBySpinner(document.getElementById(anId));
        });
    }
}

function initArchitectureSearchSpinner() {
    var input = $(''.architecture-search__input'');
    var spinner = $(''.architecture-search__spinner'');
    input.change(function () {
        spinner.addClass(''is-active'');
    });
}

function stopArchitectureSearchSpinner() {
    $(''.architecture-search__spinner'').removeClass(''is-active'');
}

function showRootSnackbar(text="Hello world", timeout=3000) {
    var data= {message: text, timeout: timeout};
    document.getElementById("rootSnackbar").MaterialSnackbar.showSnackbar(data);
}

// We change the default position of qtip tooltip to place well the legend tooltip of Cytoscape
function updateDefaultQTipOptions() {
    $.fn.qtip.defaults.position.my = ''top right'';
    $.fn.qtip.defaults.position.at = ''bottom left'';
}'
]

{ #category : #sass }
CPPSLibrary >> siemensToolkitSass [
	^ '// Imports
@import "core"
@import "components"
@import "libraryAdaptor"
@import "dashboard"
@import "codeAnalyzer"
@import "duplication"
@import "treeExplorer"
@import "architecturalVision"
@import "rulesBrowser"
@import "query"
@import "tagManager"
@import "architecture"
@import "correlations"
'
]

{ #category : #logos }
CPPSLibrary >> tabLogoPng [

	^ #[ 137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 40 0 0 0 61 8 6 0 0 0 223 229 43 69 0 0 0 6 98 75 71 68 0 255 0 255 0 255 160 189 167 147 0 0 0 9 112 72 89 115 0 15 190 200 0 15 190 200 1 42 52 50 38 0 0 0 7 116 73 77 69 7 224 4 15 13 17 47 135 163 138 174 0 0 5 201 73 68 65 84 104 222 205
	     154 123 136 21 85 28 199 63 51 174 154 143 242 213 102 84 70 143 197 82 51 52 133 146 30 19 149 134 157 40 231 15 173 8 13 209 196 40 180 183 21 37 106 209 3 31 24 165 16 98 37 168 69 81 39 172 129 30 22 30 168 204 74 42 204 7 105 91 105 146 69 249 74 119 213 93 239 246 199 253 205 114 152 102
	     230 206 204 221 117 253 193 133 123 231 156 57 243 189 223 243 123 159 113 168 32 158 31 96 180 106 253 14 96 180 194 243 131 62 192 213 192 181 192 101 192 0 160 63 208 67 110 221 15 212 3 91 129 245 192 90 224 103 160 57 92 35 186 102 156 56 105 192 98 22 234 14 92 9 204 0 70 3 93 201 39 63
	     2 43 128 215 128 125 64 201 94 63 14 164 147 145 181 30 192 245 192 51 192 80 170 151 195 192 139 192 34 96 159 209 170 148 4 210 169 0 174 19 112 177 44 52 134 182 151 95 129 123 129 79 141 86 71 227 38 184 41 224 122 2 147 128 13 41 224 90 68 167 142 2 141 192 17 249 222 156 17 224 121 64 0
	     204 145 231 181 170 214 255 24 140 128 235 7 60 4 60 30 179 104 73 192 52 2 187 68 175 182 3 123 129 206 64 63 96 32 112 169 24 77 247 140 186 186 10 152 110 180 58 100 99 113 98 192 213 2 207 1 83 98 128 237 23 64 171 1 109 180 250 171 130 7 24 2 220 5 140 3 206 205 0 116 21 48 205 104 213
	     16 98 114 98 152 123 30 152 42 219 231 88 46 99 61 176 192 104 245 89 146 90 36 93 243 252 160 23 240 4 112 39 112 118 5 144 243 129 89 70 171 150 232 22 247 4 230 2 15 70 88 219 2 44 52 90 189 158 6 42 163 31 189 81 118 103 120 133 219 70 27 173 214 122 126 208 186 197 157 128 105 192 82 107
	     82 35 240 33 112 191 209 106 103 94 96 73 62 213 243 131 58 96 37 112 121 202 45 155 129 225 70 171 166 16 224 40 224 75 107 194 1 96 133 209 106 102 53 192 146 216 20 144 239 139 11 75 242 14 147 141 86 43 92 209 59 155 185 125 192 162 182 6 103 49 136 209 106 7 48 75 158 149 36 83 67 63 56
	     1 24 102 121 248 197 70 171 121 109 13 46 6 228 26 97 177 148 16 130 71 120 126 80 235 138 233 31 19 75 93 214 158 224 98 100 174 60 55 41 79 184 198 149 192 189 0 120 214 104 245 192 137 0 103 177 88 15 124 145 192 162 11 92 148 26 139 79 132 120 126 48 17 88 46 81 200 150 102 96 137 27 247
	     239 78 176 124 158 192 32 128 235 210 193 98 180 250 69 220 74 156 171 105 232 80 128 86 230 146 4 112 151 219 193 236 165 37 206 37 96 83 135 111 177 231 7 189 83 178 238 111 58 28 160 4 9 55 134 189 13 70 171 70 247 36 208 191 171 98 0 58 82 92 113 50 48 120 51 208 41 114 109 135 132 193 234
	     0 70 235 135 164 107 41 209 100 24 112 73 140 145 44 54 90 53 122 126 80 12 96 76 205 124 150 231 7 167 217 97 44 13 168 53 54 3 56 37 50 188 45 220 94 163 21 53 85 228 116 14 160 36 45 58 3 56 238 249 193 38 249 247 63 37 1 180 238 31 4 140 141 217 222 71 140 86 135 91 107 146 42 24 156 32 245
	     114 180 198 248 88 178 240 173 49 181 137 205 250 106 224 182 136 154 45 147 202 174 20 91 23 231 144 65 192 61 9 5 208 24 96 188 231 7 221 146 226 186 231 7 51 129 155 34 207 255 1 152 109 180 42 217 236 23 5 120 62 112 69 202 248 168 40 120 207 15 28 217 218 91 164 230 238 101 13 255 3 76 49
	     90 237 137 178 94 20 96 215 24 229 182 165 27 208 37 178 181 45 158 31 12 149 254 206 128 200 252 201 70 171 141 113 217 84 81 128 127 3 59 83 198 235 101 142 109 20 61 164 97 20 109 62 221 33 213 35 21 123 51 57 228 59 224 237 132 177 70 32 8 187 14 22 35 11 37 106 216 242 48 240 158 209 170
	     41 201 135 22 2 104 180 58 4 44 6 94 138 164 74 123 128 233 192 26 251 129 158 31 76 146 246 135 157 53 191 2 44 55 90 29 73 203 228 221 162 78 26 248 29 120 12 24 12 220 10 92 7 140 4 222 48 90 53 89 91 219 79 44 190 191 181 204 70 224 105 163 213 254 74 101 70 77 1 246 236 5 27 128 109 158
	     31 108 7 90 236 70 164 37 211 129 33 214 239 227 192 125 192 238 44 53 144 67 21 82 169 113 228 249 65 95 224 3 113 59 161 204 1 230 27 173 26 178 60 163 170 100 33 238 159 135 12 139 140 3 46 136 88 255 202 16 92 150 196 194 205 202 84 214 44 37 2 124 108 68 247 150 138 33 101 46 111 157 156
	     91 58 24 184 27 232 45 186 68 74 243 167 27 112 67 4 224 200 208 33 103 149 154 28 224 46 20 6 188 130 26 177 30 248 51 239 77 121 116 176 123 76 136 202 35 235 128 131 237 9 112 119 232 128 165 45 145 245 83 162 220 96 127 215 104 149 27 96 77 14 119 178 215 243 131 89 192 155 64 29 217 142
	     26 28 202 71 19 95 229 53 142 204 0 173 136 16 50 247 45 240 117 14 18 156 106 122 62 78 14 35 233 77 249 156 110 48 217 15 106 144 148 190 30 88 103 180 218 219 46 0 229 4 224 81 224 169 42 140 100 9 240 100 24 127 219 218 72 206 148 250 181 26 81 64 223 246 178 226 127 129 239 45 39 156 247
	     3 176 73 146 139 118 211 193 129 148 79 139 206 201 169 131 46 229 110 254 60 163 213 230 118 233 161 228 137 195 69 186 17 85 251 65 113 51 53 194 94 159 2 184 74 192 111 192 129 240 12 174 205 0 90 254 107 184 20 61 35 44 93 204 186 197 71 128 151 129 23 40 159 98 181 121 36 233 5 220 30 73
	     60 243 72 103 202 103 207 171 243 2 204 19 139 155 171 84 191 82 145 53 178 234 224 1 207 15 222 162 252 250 73 45 201 199 6 73 158 194 1 222 1 254 104 115 55 19 169 49 78 165 124 220 223 148 131 141 46 192 49 163 213 150 34 201 66 214 80 23 237 82 157 78 249 133 136 52 99 113 36 235 222 18 190
	     209 81 228 20 203 41 224 199 234 128 217 82 3 151 42 0 108 1 94 149 2 253 96 17 197 173 41 112 79 29 48 49 199 252 241 146 232 22 2 88 164 236 172 7 62 201 97 185 31 133 141 164 34 242 31 101 156 149 93 198 164 151 55 0 0 0 0 73 69 78 68 174 66 96 130 ]
]

{ #category : #sass }
CPPSLibrary >> tagManagerSass [
	^ '@import "variables"

.tag-manager
  +box
  +displayFlex
  flex-wrap: nowrap

  .telescopeVisu
    width: 95%
    margin: auto

  #delete
    text-align: center

    .mdl-card
      display: inline-block
      margin: 30px

  .tag-manager-content
    .mdl-tabs__panel
      background-color: $borderColor

      .panel
        +border-radius(10px)
        width: 80%
        min-width: 300px
        background-color: $white
        padding: 20px
        overflow: visible
        margin: 50px auto

    #vizualization
      +box

  .right-panel
    .panel
      overflow: auto
      height: 100%

  .tag-categories
    width: 70%

  .exportButtons
    text-align: center

    button
      font-size: 12px
      margin: 0 5px

  .tree
    height: calc(100% - 36px)

  //TODO Check if the next is still used, not sure
  .deleteButton
    margin-bottom: 20px !important
    background-color: $red400 !important
    color: $white !important

  .splitNewTags .mdl-textfield
    margin-right: 20px

  #edit .mdl-dialog:first-of-type
    min-width: 600px

.tag-table td:nth-child(3), .query-browser__table td:nth-child(2)
  white-space: nowrap
  max-width: 300px
  overflow: hidden
  text-overflow: ellipsis

// New Simple Tag Component
.new-simple-tag
  width: 100%
  text-align: center

  &> div
    display: inline-flex

  i
    color: $green
    line-height: 66px
    margin-left: 20px
    cursor: pointer

//Tag List Component
#tag-list-decorator
  +displayFlex
  +flexDirection(column)
  height: 100%

  #toolTagList
    text-align: center
    display: flex
    flex-wrap: wrap
    justify-content: space-around
    align-items: center
    padding-top: 10px

    .tag-categories
      width: 100%
      margin: 0 10px

  #tagListContainer
    +flexGrow
    height: 300px
    box-sizing: border-box
    overflow: hidden

    &:hover
      overflow: auto

.mdl-dialog__content .tagList
  height: 60vh
'
]

{ #category : #sass }
CPPSLibrary >> treeExplorerSass [
	^ '@import "variables"

.treeExplorer
  +box()
  +displayFlex

  .content
    +box(1px, 100%)
    +flex(1 1 auto)
'
]

{ #category : #sass }
CPPSLibrary >> variablesSass [
	^ '// Colors
$red50: #ffebee
$red400: #ef5350
$red: #f44336
$red500: $red
$red700: #d32f2f
$red800: #c62828
$purple: #9C27B0
$purple500: $purple
$purple700: #7B1FA2
$deepPurple: #673AB7
$deepPurple500: $deepPurple
$indigo: #3F51B5
$indigo500: $indigo
$indigo800: #283593
$blue: #2196F3
$blue500: $blue
$blue700: #1976D2
$cyan: #00BCD4
$cyan500: $cyan
$cyan700: #0097A7
$teal: #009688
$teal500: $teal
$green: #4CAF50
$green500: $green
$green700: #388E3C
$yellow: #FFEB3B
$yellow500: $yellow
$amber: #FFC107
$amber500: $amber
$orange100: #FFE0B2
$orange200: #FFCC80
$orange300: #FFB74D
$orange400: #FFA726
$orange: #FF9800
$orange500: $orange
$orange600: #FB8C00
$orange700: #F57C00
$orange800: #EF6C00
$deepOrange100: #FFCCBC
$deepOrange200: #FFAB91
$deepOrangeA100: #FF9E80
$deepOrangeA200: #FF6E40
$deepOrangeA: $deepOrangeA200
$deepOrangeA400: #FF3D00
$deepOrangeA700: #DD2C00
$grey100: #F5F5F5
$grey200: #EEEEEE
$grey300: #E0E0E0
$grey400: #BDBDBD
$grey: #9E9E9E
$grey500: $grey
$grey700: #616161
$grey800: #424242
$grey900: #212121
$blueGrey50: #ECEFF1
$blueGrey100: #CFD8DC
$blueGrey200: #B0BEC5
$blueGrey: #607D8B
$blueGrey500: $blueGrey

$white: #FFF
$primary-black-text: rgba(0,0,0,0.87)
$secondary-black-text: rgba(0,0,0,0.54)

$primaryColor: $indigo
$primaryColorMuchDarker: $indigo800
$accentColorLighter: $orange300
$accentColorMuchLighter: $orange200
$accentColor: $orange
$accentColorDarker: $orange700
$accentColorMuchDarker: $orange800
$borderColor: $grey300
$headerBackgroundColor: $grey100

$success-shade1: $teal
$danger-shade1: $red
$warning-shade1: $orange
$primary-shade1: $primaryColor
$info-shade1: $blue
$default-shade1: $blueGrey

// Fonts
$mainFonts: "Roboto", "Helvetica", "Arial", sans-serif

//Other

$main-border-thickness: 2px

// Mixins

=box($width: 100%, $height: $width)
  width: $width
  height: $height

=css3($property, $value)
  @each $prefix in -webkit-, -moz-, -ms-, -o-, ''''
    #{$prefix}#{$property}: $value

=border-radius($radius)  // Always a handy mixin. Set border radius without worrying about all those prefixes.
  +css3(border-radius, $radius)
  background-clip: padding-box  // stops bg color from leaking outside the border

=box-sizing($box-model) // Reset your elements box model with ease.
  +css3(box-sizing, $box-model)

=opacity($opacity) // Set the opacity for all browsers and provide a filter fallback for IE8.
  opacity: $opacity
  $opacity-ie: $opacity * 100
  filter: alpha(opacity=$opacity-ie) //IE8

=transition($options)
  -webkit-transition: $options // Safari
  transition: $options

=animation($options)
  -webkit-animation: $options // Safari
  animation: $options

=center-block // Quickly center any element within its parent. Requires width or max-width to be set.
  display: block
  margin:
    left: auto
    right: auto

=text-truncate // An easy way to truncate text with an ellipsis. Requires the element to be block or inline-block.
  overflow: hidden
  text-overflow: ellipsis
  white-space: nowrap

=abs-pos ($top: auto, $right: auto, $bottom: auto, $left: auto) // Pass in the desired location of your target element to produce all the necessary positioning code.
  top: $top
  right: $right
  bottom: $bottom
  left: $left
  position: absolute

=font-size($size: 14, $base: 14 ) //  This mixin sets the font size in rem''s with a px fallback.
  font-size: $size + px //fallback for old browsers
  font-size: ($size / $base) * 1rem

=line-height($height: 12, $base: 12 ) // This mixin sets the line height in rem''s with a px fallback.
  line-height: $height + px //fallback for old browsers
  line-height: ($height / $base) * 1rem

=centered
  position: absolute
  top: 50%
  left: 50%
  transform: translate(-50%, -50%)

=flex($args...)
  -webkit-flex: $args // Safari 6.1+
  -ms-flex: $args // IE 10
  flex: $args

=displayFlex
  display: -webkit-flex // Safari
  display: flex

=flexDirection($dir: row)
  -webkit-flex-direction: $dir // Safari 6.1+
  flex-direction: $dir

=flexGrow($ratio: 1)
  -webkit-flex-grow: $ratio
  flex-grow: $ratio

=clearfix
  &:before, &:after
    content: ""
    display: table
  &:after
    clear: both

=mdl-alert($color)
  background-color: transparent
  border-color: $color
  color: $color

  a
    color: $color
    text-decoration: none
    font-style: italic
    font-weight: bold

=query-path__segment_current($color, $colorHover)
  background-color: $color

  &:after
    background-color: $color
    background-clip: content-box

  &:hover
    background-color: $colorHover

    &:after
      background-color: $colorHover
      background-clip: content-box

=query-path__segment_color($color)
  background-color: $color

  &:after
    background-color: $color

  &:hover
    background-color: $blueGrey50

    &>.on-hover
      display: inherit

    &:after
      background-color: $blueGrey50
      background-clip: content-box
'
]
