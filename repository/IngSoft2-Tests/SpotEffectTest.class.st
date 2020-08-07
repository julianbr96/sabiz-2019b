"
This class contains tests about spots.
"
Class {
	#name : #SpotEffectTest,
	#superclass : #StandardModelTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #'test - atomicbomb' }
SpotEffectTest >> testAtomicBombDoesNotAffectPlayersThatHaveAlreadyFinished [
	| game |
	game := Game
		newPlayedBy: {player1. player2}
		throwing: {(SequentialDice newWithSequence: {13 . 1})}
		on:
			(testResource
				effectTestingBoardWithSpots: 10
				and: AtomicBombEffect new
				at: 3)
		using: testResource standardDeckOfCards.
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	self assert: (game playerHasFinished: player1).
	self assert: (game positionOf: player1) equals: 7.
	self assert: (game positionOf: player2) equals: 1
]

{ #category : #'test - cardGiving' }
SpotEffectTest >> testCardGivingSpotGivesOneCardToPlayerWhoTriggersIt [
	| game board |
	board := testResource
		effectTestingBoardWithSpots: 5
		and: CardGivingEffect new
		at: 5.
	game := Game
		newPlayedBy: {player1}
		throwing: {(SequentialDice newWithSequence: {4})}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game cardsInHandOf: player1) size equals: 3
]

{ #category : #'test - moonwalk' }
SpotEffectTest >> testMoonWalkDoesNotAffectPlayersThatHaveAlreadyFinished [
	| game |
	game := Game
		newPlayedBy: {player1. player2}
		throwing: {(SequentialDice newWithSequence: {10 . 2})}
		on:
			(testResource
				effectTestingBoardWithSpots: 10
				and: MoonWalkEffect new
				at: 5)
		using: testResource standardDeckOfCards.
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	self assert: (game playerHasFinished: player1).
	self assert: (game positionOf: player1) equals: 1.
	self assert: (game positionOf: player2) equals: 5
]

{ #category : #'test - moonwalk' }
SpotEffectTest >> testMoonWalkReducesThePositionOfAllPlayerWhoDidNotTriggerIt [
	| board game |
	board := testResource effectTestingBoardWithSpots: 8 and: (MoonWalkEffect goingBack: 3) at: 7.
	game := Game
		newPlayedBy: {player1. player2. player3}
		throwing: {(SequentialDice newWithSequence: {1. 2. 3})}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 2.
	self assert: (game positionOf: player2) equals: 3.
	self assert: (game positionOf: player3) equals: 4.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 8.
	self assert: (game lapOf: player1) equals: -1.
	self assert: (game positionOf: player2) equals: 2.
	self assert: (game positionOf: player3) equals: 7
]

{ #category : #'test - atomicbomb' }
SpotEffectTest >> testPlayerTriggersAtomicBombAndEveryoneThatHasNotFinishedGoesBackToFirstSpotMaintainingLaps [
	| game board |
	board := testResource effectTestingBoardWithSpots: 5 and: AtomicBombEffect new at: 3.
	game := Game
		newPlayedBy: {player1. player2. player3}
		throwing: {(SequentialDice newWithSequence: {8. 3. 1})}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 4.
	self assert: (game lapOf: player1) equals: 1.
	self assert: (game positionOf: player2) equals: 4.
	self assert: (game lapOf: player2) equals: 0.
	self assert: (game positionOf: player3) equals: 2.
	self assert: (game lapOf: player3) equals: 0.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 2.
	self assert: (game lapOf: player1) equals: 3.
	self assert: (game positionOf: player2) equals: 1.
	self assert: (game lapOf: player2) equals: 1.
	self assert: (game positionOf: player3) equals: 1.
	self assert: (game lapOf: player3) equals: 0
]

{ #category : #'test - speedUp' }
SpotEffectTest >> testPlayerTriggersSpeedUpAndGoesForwardsFourSpots [
	| game board |
	board := testResource effectTestingBoardWithSpots: 9 and: SpeedUpEffect new at: 5.
	game := Game
		newPlayedBy: {player1}
		throwing: {(SequentialDice newWithSequence: {4})}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 9
]

{ #category : #'test - speedUp' }
SpotEffectTest >> testPlayerTriggersSpeedUpAtPositionFiveAndGainsALapAfterGoingForwardFourPositions [
	| game board |
	board := testResource effectTestingBoardWithSpots: 6 and: SpeedUpEffect new at: 5.
	game := Game
		newPlayedBy: {player1}
		throwing: {(SequentialDice newWithSequence: {4})}
		on: board
		using: testResource standardDeckOfCards.
	self assert: (game lapOf: player1) equals: 0.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 3.
	self assert: (game lapOf: player1) equals: 1
]

{ #category : #'test - wormhole' }
SpotEffectTest >> testPlayerTriggersWormHoleAndGoesBackFourSpots [
	| game board |
	board := testResource effectTestingBoardWithSpots: 6 and: WormHoleEffect new at: 6.
	game := Game
		newPlayedBy: {player1}
		throwing: {(SequentialDice newWithSequence: {5})}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 2
]

{ #category : #'test - wormhole' }
SpotEffectTest >> testPlayerTriggersWormHoleAtPositionTwoAndLosesALapAfterGoingBackFourPositions [
	| game board |
	board := testResource effectTestingBoardWithSpots: 6 and: WormHoleEffect new at: 2.
	game := Game
		newPlayedBy: {player1}
		throwing: {(SequentialDice newWithSequence: {6. 1})}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 1.
	self assert: (game lapOf: player1) equals: 1.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 4.
	self assert: (game lapOf: player1) equals: 0
]

{ #category : #'test - regular' }
SpotEffectTest >> testSpotWithRegularEffectDoesNothing [
	| game board |
	board := testResource effectlessBoardWithSpots: 5.
	game := Game
		newPlayedBy: {player1}
		throwing: {(SequentialDice newWithSequence: {4})}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 5
]

{ #category : #'test - timeMachine' }
SpotEffectTest >> testTimeMachineAtFirstMovementOfPlayerReturnsHimToFirstPositionAndZeroNumberOfLaps [
	| game board |
	board := testResource effectTestingBoardWithSpots: 6 and: TimeMachineEffect new at: 5.
	game := Game
		newPlayedBy: {player1}
		throwing: {(SequentialDice newWithSequence: {4})}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 1.
	self assert: (game lapOf: player1) equals: 0
]

{ #category : #'test - timeMachine' }
SpotEffectTest >> testTimeMachineReturnsPlayerToPositionAtPreviousRound [
	| game board |
	board := testResource effectTestingBoardWithSpots: 6 and: TimeMachineEffect new at: 5.
	game := Game
		newPlayedBy: {player1}
		throwing: {(SequentialDice newWithSequence: {2. 8})}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 1.
	self assert: (game lapOf: player1) equals: 0
]
