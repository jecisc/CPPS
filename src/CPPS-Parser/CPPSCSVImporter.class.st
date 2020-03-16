"
Description
--------------------

I am an importer for CPPS CSVs.

I'll read each sections of the CSV and fill a model given in parameter.

Examples
--------------------

	CPPSCSVImporter runOn: 'sources' asFileReference withRefFile: 'model.ref' asFileReference withModel: CPPSModel new
"
Class {
	#name : #CPPSCSVImporter,
	#superclass : #Object,
	#category : #'CPPS-Parser'
}

{ #category : #accessing }
CPPSCSVImporter class >> declarationMap [
	^ Dictionary new
		at: #fileLocation
			put:
			'#Files
fileId,path';
		at: #namespace
			put:
			'#Namespaces
id,name,parentId,file,line,column';
		at: #package
			put:
			'#Packages
id,name,parentId';
		at: #type
			put:
			'#Types
id,name';
		at: #classe
			put:
			'#Classes
id,name,typeId,parentId,file,line,column,abstract,trivial,kind,packageId';
		at: #enum
			put:
			'#Enums
id,name,typeId,parentId,file,line,column,packageId';
		at: #function
			put:
			'#Funcs
id,name,typeId,parentId,file,line,column,lineE,vindex';
		at: #variable
			put:
			'#Vars
id,name,typeId,parentId,file,line,column';
		at: #edge
			put:
			'#Edges
sourceId,targetId,file,line,column,edgeType';
		yourself
]

{ #category : #'instance creation' }
CPPSCSVImporter class >> runOn: aSourceFolder withRefFile: aFile withModel: aModel [
	^ self new runOn: aSourceFolder withRefFile: aFile readStream withModel: aModel
]

{ #category : #'instance creation' }
CPPSCSVImporter >> declarationFor: aSymbol [
	^ self class declarationMap at: aSymbol
]

{ #category : #parsing }
CPPSCSVImporter >> parse: stream forDeclaration: aSymbol with: parser [
	| securedPosition declaration |
	('Running sub-parser ' , aSymbol) record.
	securedPosition := stream position.
	declaration := self declarationFor: aSymbol.
	declaration lines
		do: [ :aLine | 
			('Checking if the stream is positioned at "' , aLine , '"') record.
			self
				assert: (aLine asPParser parse: stream nextLine) isPetit2Failure not
				description: 'Unable to find declaration: ' , declaration , ' at position: ' , securedPosition asString ].
	[ securedPosition := stream position.
	(parser parse: (stream nextLine ifNil: [ '' ])) isPetit2Failure ] whileFalse.
	stream position: securedPosition
]

{ #category : #'instance creation' }
CPPSCSVImporter >> runOn: aSourceFolder withRefFile: aReadStream withModel: aModel [
	self
		execute: [ | parser |
			parser := CPPSCSVParser new
				optimize;
				model: aModel;
				yourself.

			[ #(#fileLocation #namespace #package #type #classe #enum #function #variable #edge)
				do: [ :symbol | self parse: aReadStream forDeclaration: symbol with: (parser perform: symbol) ] ]
				ensure: [ aReadStream close ].
			parser doReportedOperations.
			(aModel allWithSubTypesOf: CPPSSourcedEntity) do: [ :entity | entity sourceAnchor ifNil: [ entity isStub ] ].
			self setMethodsModifiersIn: aModel.
			self setUnknowPackageToOrphanTypesIn: aModel ]
		recordedAs: 'Import CPP model'.
	^ aModel
]

{ #category : #'instance creation' }
CPPSCSVImporter >> setMethodsModifiersIn: aModel [
	"With this parser we do not have the public/private informations. To improve user experience we try to find the best suited modifier here."

	self
		execute: [ (aModel allUsing: FamixTMethod) do: [ :method | method addModifier: (method clientTypes ifEmpty: [ #private ] ifNotEmpty: [ #public ]) ] ]
		recordedAs: 'Init modifier of methods'
]

{ #category : #'instance creation' }
CPPSCSVImporter >> setUnknowPackageToOrphanTypesIn: aModel [
	"To improve user experiance while using the tools, we group potential orphan classes into an unknow package."

	self
		execute: [ | unknowPackage |
			unknowPackage := CPPSPackage new
				name: 'unknowPackage';
				mooseModel: aModel;
				isStub;
				yourself.
			(aModel allUsing: FamixTType) do: [ :type | type parentPackage ifNil: [ type parentPackage: unknowPackage ] ] ]
		recordedAs: 'Set unknow package'
]
