Extension { #name : #FamixTIndexedFileNavigation }

{ #category : #'*CPPS-Entities' }
FamixTIndexedFileNavigation >> isWithin: aFileAnchor [
	"Test whether aSourceAnchor is contained within receiver. We test the positions before the file name because it is faster."

	^ startPos >= aFileAnchor startPos and: [ endPos <= aFileAnchor endPos and: [ fileName = aFileAnchor fileName ] ]
]
