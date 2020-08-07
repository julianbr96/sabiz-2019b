"
This class contains tests about player state, especifically, the position
"
Class {
	#name : #PositionTest,
	#superclass : #StandardModelTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
PositionTest >> testCantCreateAPositionWithAnInvalidSpotNumber [
	self
		should: [ Position newOn: 0 and: 1 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'The spot number must be a positive integer'.
	self
		should: [ Position newOn: -1 and: 1 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'The spot number must be a positive integer'
]

{ #category : #tests }
PositionTest >> testPositionHasGivenLapNumber [
	| position |
	position := Position newOn: 5 and: 2.
	self assert: position lapNumber equals: 2
]

{ #category : #tests }
PositionTest >> testPositionHasGivenSpotNumber [
	| position |
	position := Position newOn: 5 and: 2.
	self assert: position spotNumber equals: 5
]
