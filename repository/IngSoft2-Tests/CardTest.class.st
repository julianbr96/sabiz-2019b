"
This class contains tests about cards and playerEffects in general
"
Class {
	#name : #CardTest,
	#superclass : #StandardModelTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #resources }
CardTest >> newCardTestingGameFor: cardEffect [
	^ self
		newCardTestingGameWith:
			(SequentialDeck
				newWithSequence: {(Card newWith: cardEffect)}
				and: testResource standardNumberOfCards)
]

{ #category : #resources }
CardTest >> newCardTestingGameWith: deck [
	^ self
		newCardTestingGameWith: deck
		on: (testResource effectlessBoardWithSpots: 10)
]

{ #category : #resources }
CardTest >> newCardTestingGameWith: deck on: board [
	^ Game
		newPlayedBy: {player1. player2}
		throwing: {(SequentialDice newWithSequence: {1})}
		on: board
		using: deck
]

{ #category : #tests }
CardTest >> testARepeatCardCantBePlayedOnAPlayerThatFinished [
	| game card |
	game := Game
		newPlayedBy:
			{player1.
			player2}
		throwing: {(SequentialDice newWithSequence: {10})}
		on: (testResource effectlessBoardWithSpots: 10)
		using:
			(SequentialDeck
				newWithSequence: {(Card newWith: RepeatEffect new)}
				and: testResource standardNumberOfCards).
	game throwDicesFor: player1.
	card := (game cardsInHandOf: player2) first.
	self
		should: [ game play: card by: player2 on: {player1} ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'The repeat card cant be played on a player that has already finished'
]

{ #category : #tests }
CardTest >> testASpeedCardCantBePlayedOnAPlayerThatFinished [
	| game card |
	game := Game
		newPlayedBy:
			{player1.
			player2}
		throwing: {(SequentialDice newWithSequence: {10})}
		on: (testResource effectlessBoardWithSpots: 10)
		using:
			(SequentialDeck
				newWithSequence: {(Card newWith: SpeedEffect new)}
				and: testResource standardNumberOfCards).
	game throwDicesFor: player1.
	card := (game cardsInHandOf: player2) first.
	self
		should: [ game play: card by: player2 on: {player1} ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'The speed card cant be played on a player that has already finished'
]

{ #category : #tests }
CardTest >> testAccelerationEffectIncreasesByOneRollResults [
	| game cardToPlay |
	game := self newCardTestingGameFor: AccelerationEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay by: player1 on: game players.
	game throwDicesFor: player1.
	game play: cardToPlay by: player2 on: game players.
	game throwDicesFor: player2.
	self assert: (game positionOf: player1) equals: 3.
	self assert: (game positionOf: player2) equals: 4
]

{ #category : #tests }
CardTest >> testAccelerationMustBeTargetedToAllPlayers [
	| game cardToPlay |
	game := self newCardTestingGameFor: AccelerationEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay by: player1 on: { player1. player2 }.
	game throwDicesFor: player1.
	self
		should: [game play: cardToPlay by: player2 on: { player1 }]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Tried to play acceleration card on a specific set of players instead of all of them'
]

{ #category : #tests }
CardTest >> testAnOverloadCardCantBePlayedOnAPlayerThatFinished [
	| game card |
	game := Game
		newPlayedBy:
			{player1.
			player2}
		throwing: {(SequentialDice newWithSequence: {10})}
		on: (testResource effectlessBoardWithSpots: 10)
		using:
			(SequentialDeck
				newWithSequence: {(Card newWith: OverloadEffect new)}
				and: testResource standardNumberOfCards).
	game throwDicesFor: player1.
	card := (game cardsInHandOf: player2) first.
	self
		should: [ game play: card by: player2 on: {player1} ]
		raise: AssertionFailure
		whoseDescriptionIncludes:
			'The overload card cant be played on a player that has already finished'
]

{ #category : #'tests - deck' }
CardTest >> testCancellatingAPermanentCardDiscardItToTheDiscardDeck [
	| game amountOfCards cardToPlay |
	amountOfCards := 12.
	game := self
		newCardTestingGameWith:
			(SequentialDeck
				newWithSequence:
					{(Card newWith: AccelerationEffect new).
					(Card newWith: CancellationEffect new)}
				and: amountOfCards).
	self assert: game discardDeckIsEmpty.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay by: player1 on: game players.
	game throwDicesFor: player1.
	cardToPlay := (game cardsInHandOf: player2) last.
	game
		play: cardToPlay
		by: player2
		on: (PlayedCard newOf: AccelerationEffect new to: game players).
	self assert: game primaryDeck size equals: 8.
	self assert: game discardDeck size equals: 2
]

{ #category : #tests }
CardTest >> testCancellationCardAffectingAllPlayersRemovesOnlyOneGlobalEffect [
	| game deck |
	deck := SequentialDeck
		newWithSequence:
			{(Card newWith: AccelerationEffect new).
			(Card newWith: CancellationEffect new)}
		and: testResource standardNumberOfCards.
	game := self newCardTestingGameWith: deck.
	game
		play: (Card newWith: AccelerationEffect new)
		by: player1
		on: game players.
	game throwDicesFor: player1.
	game
		play: (Card newWith: AccelerationEffect new)
		by: player2
		on: game players.
	game throwDicesFor: player2.
	game
		play: (Card newWith: CancellationEffect new)
		by: player2
		on: (PlayedCard newOf: AccelerationEffect new to: game players).
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 5.
	self assert: (game positionOf: player2) equals: 4
]

{ #category : #tests }
CardTest >> testCancellationCardAffectingOnePlayersRemovesOnlyOneOfHisLocalEffects [
	| game deck |
	deck := SequentialDeck
		newWithSequence:
			{(Card newWith: SpeedEffect new).
			(Card newWith: CancellationEffect new)}
		and: testResource standardNumberOfCards.
	game := self newCardTestingGameWith: deck.
	game play: (Card newWith: SpeedEffect new) by: player1 on: {player1}.
	game throwDicesFor: player1.
	game play: (Card newWith: SpeedEffect new) by: player2 on: {player1}.
	game throwDicesFor: player2.
	game
		play: (Card newWith: CancellationEffect new)
		by: player2
		on: (PlayedCard newOf: SpeedEffect new to: {player1}).
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 5.
	self assert: (game positionOf: player2) equals: 2
]

{ #category : #'tests - deck' }
CardTest >> testCannotGetAnotherCardIfTheDeckIsEmpty [
	| game amountOfCards board |
	board := testResource
		effectTestingBoardWithSpots: 10
		and: CardGivingEffect new
		at: 2.
	amountOfCards := 6.
	game := Game
		newPlayedBy: testResource standardSetOfPlayers
		throwing: {(SequentialDice newWithSequence: {1})}
		on: board
		using:
			(SequentialDeck
				newWithSequence:
					{(Card newWith: AccelerationEffect new).
					(Card newWith: RedoEffect new)}
				and: amountOfCards).
	self assert: game primaryDeckIsEmpty.
	game throwDicesFor: player1.
	self assert: (game cardsInHandOf: player1) size equals: 2
]

{ #category : #tests }
CardTest >> testCantPlayAPermanentCardIfItsNotTheTurnOfThePlayer [
	| game cardToPlay |
	game := self newCardTestingGameFor: AccelerationEffect new.
	cardToPlay := (game cardsInHandOf: player2) first.
	self
		should: [ game play: cardToPlay by: player2 on: { player1. player2 } ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Cant play a permanent card out of turn'
]

{ #category : #'tests - deck' }
CardTest >> testDeckHasGivenDistributionOfCardEffects [
	| game amountOfCards |
	amountOfCards := 12.
	game := self
		newCardTestingGameWith:
			(SequentialDeck
				newWithSequence:
					{(Card newWith: AccelerationEffect new).
					(Card newWith: RedoEffect new)}
				and: amountOfCards).
	self assert: game primaryDeck size equals: 8
]

{ #category : #'tests - deck' }
CardTest >> testGettingACardFromDeckRemovesItFromDeck [
	| game amountOfCards |
	amountOfCards := 12.
	game := self
		newCardTestingGameWith:
			(SequentialDeck
				newWithSequence:
					{(Card newWith: AccelerationEffect new).
					(Card newWith: RedoEffect new)}
				and: amountOfCards).
	self assert: game primaryDeck size equals: 8
]

{ #category : #tests }
CardTest >> testInstantCardCanBePlayedEvenIfItIsNotTheTurnOfThePlayer [
	| game cardToPlay board deck |
	deck := SequentialDeck
		newWithSequence: {(Card newWith: RepeatEffect new)}
		and: testResource standardNumberOfCards.
	board := testResource
		effectTestingBoardWithSpots: 5
		and: SpeedUpEffect new
		at: 2.
	game := self newCardTestingGameWith: deck on: board.
	cardToPlay := (game cardsInHandOf: player1) first.
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 1.
	self assert: (game lapOf: player1) equals: 1.
	self assert: game playerWhoseTurnItIsToPlay equals: player2.
	game play: cardToPlay by: player1 on: {player1}
]

{ #category : #tests }
CardTest >> testOverloadEffectDecreasesByTwoTheRollResultOfOnlyOnePlayer [
	| game cardToPlay |
	game := self newCardTestingGameFor: OverloadEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay by: player1 on: {player2}.
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	self assert: (game positionOf: player1) equals: 2.
	self assert: (game positionOf: player2) equals: 10.
	self assert: (game lapOf: player2) equals: -1
]

{ #category : #tests }
CardTest >> testOverloadEffectDecreasesByTwoTheRollResultOfOnlyOnePlayerAndIsAcumulative [
	| game cardToPlay |
	game := self newCardTestingGameFor: OverloadEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay by: player1 on: {player1}.
	game throwDicesFor: player1.
	cardToPlay := (game cardsInHandOf: player2) first.
	game play: cardToPlay by: player2 on: {player1}.
	game throwDicesFor: player2.
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 7.
	self assert: (game lapOf: player1) equals: -1.
	self assert: (game positionOf: player2) equals: 2
]

{ #category : #'tests - deck' }
CardTest >> testPlayingAPermanentCardDoesNotDiscardItToTheDiscardDeck [
	| game amountOfCards cardToPlay |
	amountOfCards := 12.
	game := self
		newCardTestingGameWith:
			(SequentialDeck
				newWithSequence: {(Card newWith: AccelerationEffect new)}
				and: amountOfCards).
	game playOneRoundWithoutPlayingCards.
	self assert: game discardDeckIsEmpty.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay by: player1 on: game players.
	self assert: game primaryDeck size equals: 8.
	self assert: game discardDeckIsEmpty
]

{ #category : #'tests - deck' }
CardTest >> testPlayingAnInstantCardDiscardItToTheDiscardDeck [
	| game amountOfCards cardToPlay |
	amountOfCards := 12.
	game := self
		newCardTestingGameWith:
			(SequentialDeck
				newWithSequence: {(Card newWith: RepeatEffect new)}
				and: amountOfCards).
	game playOneRoundWithoutPlayingCards.
	self assert: game discardDeckIsEmpty.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay by: player1 on: {player1}.
	self assert: game primaryDeck size equals: 8.
	self assert: game discardDeck size equals: 1
]

{ #category : #tests }
CardTest >> testRedoCardActsAsAPermanentIfLastPlayedCardIsPermanent [
	| game deck |
	deck := SequentialDeck
		newWithSequence:
			{(Card newWith: AccelerationEffect new).
			(Card newWith: RedoEffect new)}
		and: testResource standardNumberOfCards.
	game := self newCardTestingGameWith: deck.
	game
		play: (Card newWith: AccelerationEffect new)
		by: player1
		on: game players.
	game throwDicesFor: player1.
	game
		play: (Card newWith: RedoEffect new)
		by: player2
		on: game players.
	game throwDicesFor: player2.
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 6.
	self assert: (game positionOf: player2) equals: 4
]

{ #category : #tests }
CardTest >> testRedoCardActsAsAnInstantIfLastPlayedCardIsInstant [
	| game deck |
	deck := SequentialDeck
		newWithSequence:
			{(Card newWith: RepeatEffect new).
			(Card newWith: RedoEffect new)}
		and: testResource standardNumberOfCards.
	game := self newCardTestingGameWith: deck.
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	game
		play: (Card newWith: RepeatEffect new)
		by: player1
		on: {player1}.
	game throwDicesFor: player1.
	game play: (Card newWith: RedoEffect new) by: player2 on: {player2}.
	game throwDicesFor: player2.
	self assert: (game positionOf: player1) equals: 3.
	self assert: (game positionOf: player2) equals: 3
]

{ #category : #tests }
CardTest >> testRedoCardActsAsThePreviousOneOfThePreviousOneCardIsThePreviousOneIsAnotherRedo [
	| game deck |
	deck := SequentialDeck
		newWithSequence:
			{(Card newWith: AccelerationEffect new).
			(Card newWith: RedoEffect new)}
		and: testResource standardNumberOfCards.
	game := self newCardTestingGameWith: deck.
	game
		play: (Card newWith: AccelerationEffect new)
		by: player1
		on: game players.
	game
		play: (Card newWith: RedoEffect new)
		by: player1
		on: game players.
	game throwDicesFor: player1.
	game
		play: (Card newWith: RedoEffect new)
		by: player2
		on: game players.
	game throwDicesFor: player2.
	self assert: (game positionOf: player1) equals: 4.
	self assert: (game positionOf: player2) equals: 5
]

{ #category : #tests }
CardTest >> testRedoCardCannotBePlayedIfAnotherCardsWereNeverPlayed [
	| game deck |
	deck := SequentialDeck
		newWithSequence:
			{(Card newWith: AccelerationEffect new).
			(Card newWith: RedoEffect new)}
		and: testResource standardNumberOfCards.
	game := self newCardTestingGameWith: deck.
	self
		should: [ game
				play: (Card newWith: RedoEffect new)
				by: player1
				on: game players ]
		raise: AssertionFailure
		whoseDescriptionIncludes:
			'Cannot play redo card as there are no active played cards on the pile'
]

{ #category : #tests }
CardTest >> testRedoCardIsDiscardedAfterBeingCancelledIfItActsAsAPermanent [
	| game deck |
	deck := SequentialDeck
		newWithSequence:
			{(Card newWith: AccelerationEffect new).
			(Card newWith: CancellationEffect new).
			(Card newWith: RedoEffect new)}
		and: testResource standardNumberOfCards.
	game := self newCardTestingGameWith: deck.
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	game
		play: (Card newWith: AccelerationEffect new)
		by: player1
		on: game players.
	game throwDicesFor: player1.
	game
		play: (Card newWith: RedoEffect new)
		by: player2
		on: game players.
	game throwDicesFor: player2.
	self assert: game discardDeckIsEmpty.
	game
		play: (Card newWith: CancellationEffect new)
		by: player1
		on: (PlayedCard newOf: RedoEffect new to: game players).
	self assert: game discardDeck size equals: 2
]

{ #category : #tests }
CardTest >> testRedoCardIsDiscardedAfterBeingPlayedIfItActsAsAnInstant [
	| game deck |
	deck := SequentialDeck
		newWithSequence:
			{(Card newWith: RepeatEffect new).
			(Card newWith: RedoEffect new)}
		and: testResource standardNumberOfCards.
	game := self newCardTestingGameWith: deck.
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	game play: (Card newWith: RepeatEffect new) by: player1 on: {player1}.
	game throwDicesFor: player1.
	game play: (Card newWith: RedoEffect new) by: player2 on: {player2}.
	game throwDicesFor: player2.
	self assert: game discardDeck size equals: 2
]

{ #category : #tests }
CardTest >> testRepeatCardCannotBePlayedIfDicesNeverRolled [
	| game cardToPlay |
	game := self newCardTestingGameFor: RepeatEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	self
		should: [ game play: cardToPlay by: player1 on: {player2} ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Cant play repeat card on a player that hasnt triggered an effect yet'
]

{ #category : #tests }
CardTest >> testRepeatCardRepeatesTheEffectOfTheSpotReachedAfterRollingDices [
	| game cardToPlay board deck |
	deck := SequentialDeck
		newWithSequence: {(Card newWith: RepeatEffect new)}
		and: testResource standardNumberOfCards.
	board := testResource
		effectTestingBoardWithSpots: 5
		and: SpeedUpEffect new
		at: 2.
	game := self newCardTestingGameWith: deck on: board.
	cardToPlay := (game cardsInHandOf: player1) first.
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 1.
	self assert: (game lapOf: player1) equals: 1.
	game play: cardToPlay by: player1 on: {player1}.
	self assert: (game positionOf: player1) equals: 5.
	self assert: (game lapOf: player1) equals: 1
]

{ #category : #tests }
CardTest >> testSpeedEffectIncreasesByOneTheRollResulOfOnlyOnePlayerAndIsAcumulative [
	| game cardToPlay |
	game := self newCardTestingGameFor: SpeedEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay by: player1 on: {player1}.
	game throwDicesFor: player1.
	cardToPlay := (game cardsInHandOf: player2) first.
	game play: cardToPlay by: player2 on: {player1}.
	game throwDicesFor: player2.
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 6.
	self assert: (game positionOf: player2) equals: 2
]

{ #category : #tests }
CardTest >> testSpeedEffectIncreasesByOneTheRollResultOfOnlyOnePlayer [
	| game cardToPlay |
	game := self newCardTestingGameFor: SpeedEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay by: player1 on: {player1}.
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	self assert: (game positionOf: player1) equals: 3.
	self assert: (game positionOf: player2) equals: 2
]

{ #category : #tests }
CardTest >> testTwoIdenticalCardsYieldSameHash [
	| card1 card2 |
	card1 := Card newWith: AccelerationEffect new.
	card2 := Card newWith: AccelerationEffect new.
	self assert: card1 equals: card2.
	self assert: card1 hash equals: card2 hash
]

{ #category : #tests }
CardTest >> testTwoIdenticalPlayedCardsYieldSameHash [
	| card1 card2 |
	card1 := PlayedCard newOf: AccelerationEffect new to: testResource standardSetOfPlayers.
	card2 := PlayedCard newOf: AccelerationEffect new to: testResource standardSetOfPlayers.
	self assert: card1 equals: card2.
	self assert: card1 hash equals: card2 hash
]
