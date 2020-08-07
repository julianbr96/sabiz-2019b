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
		playedBy: {player1. player2}
		throwing: {(RandomDice withFaces: 6)}
		on: (testResource effectlessBoardWithSpots: 10)
		using: (Deck newWith: {RepeatEffect new}).
	cardToPlay := Card newWith: OverloadEffect new.
	self
		should: [ game play: cardToPlay for: player1 on: player2 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'That card is not in the hand of the player'
]

{ #category : #tests }
PlayerTest >> testCardsInHandOfReturnsEmptyColectionIfThePlayerHasNoCards [
	| game |
	game := Game
		playedBy: {player1. player2}
		throwing: {SequentialDice withSequence: {10. 1}}
		on: (testResource effectlessBoardWithSpots: 10)
		using: (GimmickDeck withSequence: {Card newWith: AccelerationEffect new}).
	game play: (Card newWith: AccelerationEffect new) for: player1 on: game players.
	game play: (Card newWith: AccelerationEffect new) for: player1 on: game players.
	self assert: (game cardsInHandOf: player1) asArray equals: {  }
]

{ #category : #tests }
PlayerTest >> testPlayerThatFinishedCantPlayACard [
	| game card |
	game := Game
		playedBy: {player1. player2}
		throwing: {SequentialDice withSequence: {10. 1}}
		on: (testResource effectlessBoardWithSpots: 10)
		using: (GimmickDeck withSequence: {Card newWith: RepeatEffect new}).
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	card := (game cardsInHandOf: player1) first.
	self
		should: [ game play: card for: player1 on: {player2} ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Trying to play a card for a player that has already finished'
]

{ #category : #tests }
PlayerTest >> testPlayingACardRemovesItFromHand [
	| game cardToPlay |
	game := Game
		playedBy: {player1. player2}
		throwing: {(RandomDice withFaces: 6)}
		on: (testResource effectlessBoardWithSpots: 10)
		using: (Deck newWith: {AccelerationEffect new}).
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay for: player1 on: game players. 
	self assert: (game cardsInHandOf: player1) size equals: 1
]

{ #category : #tests }
PlayerTest >> testTwoPlayersWithTheDifferentNamesAreTheDifferentPlayers [
	self deny: (Player named: #player1) equals: (Player named: #player2)
]

{ #category : #tests }
PlayerTest >> testTwoPlayersWithTheSameNameAreTheSamePlayer [
	self assert: (Player named: #player1) equals: (Player named: #player1)
]
