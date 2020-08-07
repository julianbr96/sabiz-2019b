"
Tests for TurnAllocator class
"
Class {
	#name : #TurnHandlerTest,
	#superclass : #StandardModelTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
TurnHandlerTest >> testCanOnlyRemoveAPlayerFromTurnAllocatorIfItsThatPlayersTurn [
	| handler |
	handler := TurnHandler newFor: { player1. player2. player3 }.
	handler playerHasFinished: player1.
	handler advanceTurnWheel.
	self
		should: [ handler playerHasFinished: player2 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Cannot remove a player from the Turn Wheel unless its his turn'
]

{ #category : #tests }
TurnHandlerTest >> testCantCreateTurnAllocatorWithEmptyCollection [
	self
		should: [ TurnHandler newFor: {} ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Cant create TurnAllocator for an empty group'
]

{ #category : #tests }
TurnHandlerTest >> testItsThePreviousPlayersTurnUntilAdvancingTheTurnWheel [
	| turns |
	turns := TurnHandler newFor: { player1. player2 }.
	self assert: turns playerWhoseTurnItIsToPlay equals: player1.
	self assert: turns playerWhoseTurnItIsToPlay equals: player1.
	turns advanceTurnWheel.
	self assert: turns playerWhoseTurnItIsToPlay equals: player2.
]

{ #category : #tests }
TurnHandlerTest >> testRemovingAPlayerAutomaticallyAdvancesTurnWheel [
	| handler |
	handler := TurnHandler newFor: { player1. player2. player3 }.
	handler advanceTurnWheel.
	handler playerHasFinished: player2.
	self assert: handler playerWhoseTurnItIsToPlay equals: player3
]

{ #category : #tests }
TurnHandlerTest >> testTurnAllocatorRespectsExpectedOrder [
	| turns |
	turns := TurnHandler newFor: { player1. player2. player3 }.
	self assert: turns playerWhoseTurnItIsToPlay equals: player1.
	turns advanceTurnWheel.
	self assert: turns playerWhoseTurnItIsToPlay equals: player2.
	turns advanceTurnWheel.
	self assert: turns playerWhoseTurnItIsToPlay equals: player3.
	turns advanceTurnWheel.
	self assert: turns playerWhoseTurnItIsToPlay equals: player1
]

{ #category : #tests }
TurnHandlerTest >> testTurnAllocatorReturnsNilWhenAskedForTheTurnOfAFinishedGame [
	| handler |
	handler := TurnHandler newFor: { player1. player2 }.
	handler playerHasFinished: player1.
	handler playerHasFinished: player2.
	self assert: handler playerWhoseTurnItIsToPlay equals: 	nil
]

{ #category : #tests }
TurnHandlerTest >> testTurnAllocatorYieldsExpectedRoundNumber [
	| turns |
	turns := TurnHandler newFor: { player1. player2. player3 }.
	self assert: turns currentRoundNumber equals: 1.
	turns advanceTurnWheel.
	self assert: turns currentRoundNumber equals: 1.
	turns advanceTurnWheel.
	self assert: turns currentRoundNumber equals: 1.
	turns advanceTurnWheel.
	self assert: turns currentRoundNumber equals: 2
]
