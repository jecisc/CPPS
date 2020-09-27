"
Description
--------------------

The ajax file upload is expected to be handled by a parent form decoration,
so that when the user click a submit button,
the upload is triggered. 
See method #saveAjaxScriptFor: on: 

"
Class {
	#name : #CPPSMDLFileUploadComponent,
	#superclass : #MAFileUploadComponent,
	#instVars : [
		'fileSize',
		'fileSizeId'
	],
	#category : #'CPPS-Toolkit-Magritte-Components'
}

{ #category : #accessing }
CPPSMDLFileUploadComponent class >> fileUploadClass [

	^ 'magritte_file_upload'
]

{ #category : #rendering }
CPPSMDLFileUploadComponent >> ensureMaxUploadSizeCondition [

	"a bit hacky but does the job.
	we add to the magritte description a condition block based on an instance variable of this component.
	this instance variable will be assigned a value using javascript callback, as soon as the user select a file to upload.
	see method #javascript_fileUpload
	"

	(self magritteDescription conditions anySatisfy: [ :eachAssociation | eachAssociation value = self uploadLimitErrorMessage ]) ifFalse:
		[ self magritteDescription
			addEarlyCondition: [ :value | self fileSize < self maxUploadSize ]
			labelled: self uploadLimitErrorMessage
		]
]

{ #category : #accessing }
CPPSMDLFileUploadComponent >> fileSize [

	^ fileSize ifNil: [ 0 ]
]

{ #category : #accessing }
CPPSMDLFileUploadComponent >> fileSize: aNumber [

	fileSize := aNumber
]

{ #category : #private }
CPPSMDLFileUploadComponent >> fileSizeId [

	^ fileSizeId
]

{ #category : #private }
CPPSMDLFileUploadComponent >> fileSizeId: aStringId [

	fileSizeId := aStringId
]

{ #category : #rendering }
CPPSMDLFileUploadComponent >> javascript_fileUpload [

	^ '
var fileInput = document.getElementById(''' , self labelId , ''');
var textFieldContainer = $(fileInput).closest(".file-input__container").find(".mdl-textfield");
var textInput = textFieldContainer.find("input");
var hiddenInput = document.getElementById(''' , self fileSizeId , ''');

fileInput.addEventListener(''change'', changeInputText);

function changeInputText() {
	// Here we take the path of the file and we want the last part only to display in the text field.
	// To do that we get the index of the last / or \ and we copy what is after.
	var str = fileInput.value;
	var i;
	if (str.lastIndexOf(''\\'')) {
		i = str.lastIndexOf(''\\'') + 1;
	} else if (str.lastIndexOf(''/'')) {
		i = str.lastIndexOf(''/'') + 1;
	}
	textInput.val(str.slice(i, str.length));
	textFieldContainer.addClass("is-focused");

	hiddenInput.value = fileInput.files[0].size;
}'
]

{ #category : #rendering }
CPPSMDLFileUploadComponent >> maxUploadSize [

	^ CPPSServer current configuration maxUploadSizeInMo * 1024 * 1024
]

{ #category : #rendering }
CPPSMDLFileUploadComponent >> renderUploadOn: html [

	| textFieldId |

	self fileSizeId: html nextId.
	self ensureMaxUploadSizeCondition.
	html hiddenInput
		id: self fileSizeId;
		callback:
			[ :val | 
			self fileSize: (val
						 ifEmpty: [ nil ]
						 ifNotEmpty: #asNumber)
			].
	html div
		class: 'file-input__container';
		style: 'display: flex;align-items: center;';
		with:
			[ textFieldId := html nextId.
			html mdlMajorButton
				for: self labelId;
				bePush;
				miniFab;
				asLabel;
				fab;
				icon: 'file_upload'.
			html fileUpload
				id: self labelId;
				class: self class fileUploadClass;
				style: 'display: none;';
				callback: [ :value | self upload: value ].
			html space.
			html mdlTextFieldContainer:
				[ html mdlTextFieldInput
					id: textFieldId;
					class: 'is-focused'
					if: self value isNotNil;
					disabled;
					readonly: true;
					value: (self value ifNotNil: #filename). "Label is needed in order to add an underline to the text field."
				html mdlTextFieldLabel for: textFieldId
				]
			].
	html script: self javascript_fileUpload
]

{ #category : #testing }
CPPSMDLFileUploadComponent >> requiresMultipartForm [

	^ true
]

{ #category : #rendering }
CPPSMDLFileUploadComponent >> uploadLimitErrorMessage [

	^ 'Selected file is too big. Upload limit is currently set to {1}Mo. If you want to increase this limit, please adjust parameter #maxUploadSizeInMo in {2} and restart the server.' format: { 
			  CPPSServer current configuration maxUploadSizeInMo asString.
			  CPPSServer current configuration serializationFile pathString }
]
