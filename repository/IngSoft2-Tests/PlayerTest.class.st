"
This class contains tests about players
"
Class {
	#name : #PlayerTest,
	#superclass : #StandardModelTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
PlayerTest >> testCantPlayACardThatIsNotInTheHand [
	| game cardToPlay |
	game := Game
		newPlayedBy:
			{player1.
			player2}
		throwing: {(RandomDice newWithFaces: 6)}
		on: (testResource effectlessBoardWithSpots: 10)
		using:
			(SequentialDeck
				newWithSequence: {(Card newWith: RepeatEffect new)}
				and: testResource standardNumberOfCards).
	cardToPlay := Card newWith: OverloadEffect new.
	self
		should: [ game play: cardToPlay by: player1 on: player2 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'That card is not in the hand of the player'
]

{ #category : #tests }
PlayerTest >> testCardsInHandOfReturnsEmptyColectionIfThePlayerHasNoCards [
	| game |
	game := Game
		newPlayedBy:
			{player1.
			player2}
		throwing: {(SequentialDice newWithSequence: {10 . 1})}
		on: (testResource effectlessBoardWithSpots: 10)
		using:
			(SequentialDeck
				newWithSequence: {(Card newWith: AccelerationEffect new)}
				and: testResource standardNumberOfCards).
	game
		play: (Card newWith: AccelerationEffect new)
		by: player1
		on: game players.
	game
		play: (Card newWith: AccelerationEffect new)
		by: player1
		on: game players.
	self assert: [ (game cardsInHandOf: player1) size isZero ]
]

{ #category : #tests }
PlayerTest >> testPlayerThatFinishedCantPlayACard [
	| game card |
	game := Game
		newPlayedBy:
			{player1.
			player2}
		throwing: {(SequentialDice newWithSequence: {10 . 1})}
		on: (testResource effectlessBoardWithSpots: 10)
		using:
			(SequentialDeck
				newWithSequence: {(Card newWith: RepeatEffect new)}
				and: testResource standardNumberOfCards).
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	card := (game cardsInHandOf: player1) first.
	self
		should: [ game play: card by: player1 on: {player2} ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Trying to play a card for a player that has already finished'
]

{ #category : #tests }
PlayerTest >> testPlayingACardRemovesItFromHand [
	| game cardToPlay |
	game := Game
		newPlayedBy:
			{player1.
			player2}
		throwing: {(RandomDice newWithFaces: 6)}
		on: (testResource effectlessBoardWithSpots: 10)
		using:
			(SequentialDeck
				newWithSequence:
					{(Card newWith: AccelerationEffect new).
					(Card newWith: RedoEffect new)}
				and: testResource standardNumberOfCards).
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay by: player1 on: game players.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay by: player1 on: game players.
	self assert: (game cardsInHandOf: player1) size equals: 0
]

{ #category : #tests }
PlayerTest >> testTwoIdenticalPlayerStatesYieldSameHash [
	| state1 state2 |
	state1 := PlayerState on: 1 andLap: 1 holding: {  }.
	state2 := PlayerState on: 1 andLap: 1 holding: {  }.
	self assert: state1 equals: state2.
	self assert: state1 hash equals: state2 hash
]

{ #category : #tests }
PlayerTest >> testTwoPlayersWithTheDifferentNamesAreTheDifferentPlayers [
	self deny: (Player newNamed: #player1) equals: (Player newNamed: #player2)
]

{ #category : #tests }
PlayerTest >> testTwoPlayersWithTheSameNameAreTheSamePlayer [
	self assert: (Player newNamed: #player1) equals: (Player newNamed: #player1)
]
