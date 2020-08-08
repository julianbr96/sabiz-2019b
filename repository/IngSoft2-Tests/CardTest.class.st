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
	^ self newCardTestingGameWith: (Deck newWith: {cardEffect})
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
		newPlayedBy: {player1. player2}
		throwing: {SequentialDice newWithSequence: {10}}
		on: (testResource effectlessBoardWithSpots: 10)
		using: (GimmickDeck newWithSequence: {Card newWith: RepeatEffect new}).
	game throwDicesFor: player1.
	card := (game cardsInHandOf: player2) first.
	self
		should: [game play: card for: player2 on: {player1}]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'The repeat card cant be played on a player that has already finished'
]

{ #category : #tests }
CardTest >> testASpeedCardCantBePlayedOnAPlayerThatFinished [
	| game card |
	game := Game
		newPlayedBy: {player1. player2}
		throwing: {SequentialDice newWithSequence: {10}}
		on: (testResource effectlessBoardWithSpots: 10)
		using: (GimmickDeck newWithSequence: {Card newWith: SpeedEffect new}).
	game throwDicesFor: player1.
	card := (game cardsInHandOf: player2) first.
	self
		should: [game play: card for: player2 on: {player1}]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'The speed card cant be played on a player that has already finished'
]

{ #category : #tests }
CardTest >> testAccelerationEffectIncreasesByOneRollResults [
	| game cardToPlay |
	game := self newCardTestingGameFor: AccelerationEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay for: player1 on: game players.
	game throwDicesFor: player1.
	game play: cardToPlay for: player2 on: game players.
	game throwDicesFor: player2.
	self assert: (game positionOf: player1) equals: 3.
	self assert: (game positionOf: player2) equals: 4
]

{ #category : #tests }
CardTest >> testAccelerationMustBeTargetedToAllPlayers [
	| game cardToPlay |
	game := self newCardTestingGameFor: AccelerationEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay for: player1 on: { player1. player2 }.
	game throwDicesFor: player1.
	self
		should: [game play: cardToPlay for: player2 on: { player1 }]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Tried to play acceleration card on a specific set of players instead of all of them'
]

{ #category : #tests }
CardTest >> testAnOverloadCardCantBePlayedOnAPlayerThatFinished [
	| game card |
	game := Game
		newPlayedBy: {player1. player2}
		throwing: {SequentialDice newWithSequence: {10}}
		on: (testResource effectlessBoardWithSpots: 10)
		using: (GimmickDeck newWithSequence: {Card newWith: OverloadEffect new}).
	game throwDicesFor: player1.
	card := (game cardsInHandOf: player2) first.
	self
		should: [game play: card for: player2 on: {player1}]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'The overload card cant be played on a player that has already finished'
]

{ #category : #tests }
CardTest >> testCancellationCardAffectingAllPlayersRemovesOnlyOneGlobalEffect [
	| game deck |
	deck := GimmickDeck newWithSequence:
			{(Card newWith: AccelerationEffect new).
			(Card newWith: CancellationEffect new)}.
	game := self newCardTestingGameWith: deck.
	game play: (Card newWith: AccelerationEffect new) for: player1 on: game players.
	game throwDicesFor: player1.
	game play: (Card newWith: AccelerationEffect new) for: player2 on: game players.
	game throwDicesFor: player2.
	game play: (Card newWith: CancellationEffect new) for: player2
		  on: (PlayedCard newOf: AccelerationEffect new to: game players).
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 5.
	self assert: (game positionOf: player2) equals: 4
]

{ #category : #tests }
CardTest >> testCancellationCardAffectingOnePlayersRemovesOnlyOneOfHisLocalEffects [
	| game deck |
	deck := (GimmickDeck newWithSequence:
			{(Card newWith: SpeedEffect new).
			(Card newWith: CancellationEffect new)}).
	game := self	 newCardTestingGameWith: deck.
	game play: (Card newWith: SpeedEffect new) for: player1 on: {player1}.
	game throwDicesFor: player1.
	game play: (Card newWith: SpeedEffect new) for: player2 on: {player1}.
	game throwDicesFor: player2.
	game play: (Card newWith: CancellationEffect new) for: player2 on: (PlayedCard newOf: SpeedEffect new to: {player1}).
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 5.
	self assert: (game positionOf: player2) equals: 2.
]

{ #category : #tests }
CardTest >> testCantPlayAPermanentCardIfItsNotTheTurnOfThePlayer [
	| game cardToPlay |
	game := self newCardTestingGameFor: AccelerationEffect new.
	cardToPlay := (game cardsInHandOf: player2) first.
	self
		should: [ game play: cardToPlay for: player2 on: { player1. player2 } ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Cant play a permanent card out of turn'
]

{ #category : #tests }
CardTest >> testInstantCardCanBePlayedEvenIfItIsNotTheTurnOfThePlayer [
	| game cardToPlay board deck |
	deck := Deck newWith: {RepeatEffect new}.
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
	game play: cardToPlay for: player1 on: {player1}.
	
]

{ #category : #tests }
CardTest >> testOverloadEffectDecreasesByTwoTheRollResultOfOnlyOnePlayer [
	| game cardToPlay |
	game := self newCardTestingGameFor: OverloadEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay for: player1 on: {player2}.
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
	game play: cardToPlay for: player1 on: {player1}.
	game throwDicesFor: player1.
	cardToPlay := (game cardsInHandOf: player2) first.
	game play: cardToPlay for: player2 on: {player1}.
	game throwDicesFor: player2.
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 7.
	self assert: (game lapOf: player1) equals: -1.
	self assert: (game positionOf: player2) equals: 2
]

{ #category : #tests }
CardTest >> testRedoCardActsAsAPermanentIfLastPlayedCardIsPermanent [
	| game deck |
	deck := (GimmickDeck newWithSequence:
			{(Card newWith: AccelerationEffect new).
			(Card newWith: RedoEffect new)}).
	game := self newCardTestingGameWith: deck.
	game play: (Card newWith: AccelerationEffect new) for: player1 on: game players.
	game throwDicesFor: player1.
	game play: (Card newWith: RedoEffect new) for: player2 on: game players.
	game throwDicesFor: player2.
	self assert: (game positionOf: player1) equals: 3.
	self assert: (game positionOf: player2) equals: 4
]

{ #category : #tests }
CardTest >> testRedoCardActsAsAnInstantIfLastPlayedCardIsInstant [
	| game deck |
	deck := GimmickDeck
		newWithSequence:
			{(Card newWith: RepeatEffect new).
			(Card newWith: RedoEffect new)}.
	game := self newCardTestingGameWith: deck.
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	game
		play: (Card newWith: RepeatEffect new)
		for: player1
		on: {player1}.
	game throwDicesFor: player1.
	game play: (Card newWith: RedoEffect new) for: player2 on: {player2}.
	game throwDicesFor: player2.
	self assert: (game positionOf: player1) equals: 3.
	self assert: (game positionOf: player2) equals: 3
]

{ #category : #tests }
CardTest >> testRedoCardActsAsThePreviousOneOfThePreviousOneCardIsThePreviousOneIsAnotherRedo [
	| game deck |
	deck := (GimmickDeck newWithSequence:
			{(Card newWith: AccelerationEffect new).
			(Card newWith: RedoEffect new)}).
	game := self newCardTestingGameWith: deck.
	game play: (Card newWith: AccelerationEffect new) for: player1 on: game players.
	game play: (Card newWith: RedoEffect new) for: player1 on: game players.
	game throwDicesFor: player1.
	game play: (Card newWith: RedoEffect new) for: player2 on: game players.
	game throwDicesFor: player2.
	self assert: (game positionOf: player1) equals: 4.
	self assert: (game positionOf: player2) equals: 5
]

{ #category : #tests }
CardTest >> testRedoCardCannotBePlayedIfAnotherCardsWereNeverPlayed [
	| game deck |
	deck := GimmickDeck
		newWithSequence:
			{(Card newWith: AccelerationEffect new).
			(Card newWith: RedoEffect new)}.
	game := self newCardTestingGameWith: deck.
	self
		should: [ game
				play: (Card newWith: RedoEffect new)
				for: player1
				on: game players ]
		raise: AssertionFailure
		whoseDescriptionIncludes:
			'Cannot play redo card as there are no active played cards on the pile'
]

{ #category : #tests }
CardTest >> testRepeatCardCannotBePlayedIfDicesNeverRolled [
	| game cardToPlay |
	game := self newCardTestingGameFor: RepeatEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	self
		should: [ game play: cardToPlay for: player1 on: {player2} ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Cant play repeat card on a player that hasnt triggered an effect yet'
]

{ #category : #tests }
CardTest >> testRepeatCardRepeatesTheEffectOfTheSpotReachedAfterRollingDices [
	| game cardToPlay board deck |
	deck := Deck newWith: {RepeatEffect new}.
	board := testResource
		effectTestingBoardWithSpots: 5
		and: SpeedUpEffect new
		at: 2.
	game := self newCardTestingGameWith: deck on: board.
	cardToPlay := (game cardsInHandOf: player1) first.
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 1.
	self assert: (game lapOf: player1) equals: 1.
	game play: cardToPlay for: player1 on: {player1}.
	self assert: (game positionOf: player1) equals: 5.
	self assert: (game lapOf: player1) equals: 1
]

{ #category : #tests }
CardTest >> testSpeedEffectIncreasesByOneTheRollResulOfOnlyOnePlayerAndIsAcumulative [
	| game cardToPlay |
	game := self newCardTestingGameFor: SpeedEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay for: player1 on: {player1}.
	game throwDicesFor: player1.
	cardToPlay := (game cardsInHandOf: player2) first.
	game play: cardToPlay for: player2 on: {player1}.
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
	game play: cardToPlay for: player1 on: {player1}.
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
