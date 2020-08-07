"
This class generates standard elements with a specific set of characteristics that are going to be needed in order to test each aspect of the model
"
Class {
	#name : #StandardModelTestResource,
	#superclass : #TestResource,
	#category : #'IngSoft2-Tests'
}

{ #category : #boardCreation }
StandardModelTestResource >> effectTestingBoardWithSpots: spotsNumber and: effect at: spotNumber [
	| spots |
	spots := OrderedCollection
		new: spotsNumber
		withAll: (Spot newWith: NullEffect new).
	spots at: spotNumber put: (Spot newWith: effect).
	^ Board newWith: spots andLaps: self standardNumberOfLaps
]

{ #category : #boardCreation }
StandardModelTestResource >> effectlessBoardWithSpots: spotsNumber [
	^ Board
		newWith:
			(OrderedCollection
				new: spotsNumber
				withAll: (Spot newWith: NullEffect new))
		andLaps: self standardNumberOfLaps - 1
]

{ #category : #gameCreation }
StandardModelTestResource >> simplisticTestingGame [
	^ Game
		newPlayedBy: {Player newNamed: #Player1 . Player newNamed: #Player2}
		throwing: { SequentialDice newWithSequence: { 4 } }
		on: (self effectlessBoardWithSpots: 10)
		using: (GimmickDeck newWithSequence: {Card newWith: AccelerationEffect new})
]

{ #category : #boardCreation }
StandardModelTestResource >> standardBoard [
	^ self standardBoardWithSpots: self standardNumberOfSpots
]

{ #category : #boardCreation }
StandardModelTestResource >> standardBoardWithSpots: spots [
	^ Board newWith: self standardEffectDistribution andSpots: spots andLaps: self standardNumberOfLaps
]

{ #category : #standardValues }
StandardModelTestResource >> standardDeckOfCards [
	| cardTypes |
	cardTypes := OrderedCollection new.
	cardTypes
		addAll: (CardInstantEffect subclasses collect: [ :each | each new ]).
	cardTypes
		addAll: (CardPermanentEffect subclasses collect: [ :each | each new ]).
	^ Deck newWith: cardTypes asArray
]

{ #category : #standardValues }
StandardModelTestResource >> standardEffectDistribution [
	^ OverallOccurrenceDistribution
		newWith:
			{(IndividualOccurrenceProbability
				of: AtomicBombEffect new
				withProbability: 2).
			(IndividualOccurrenceProbability
				of: NullEffect new
				withProbability: 45).
			(IndividualOccurrenceProbability
				of: MoonWalkEffect new
				withProbability: 5).
			(IndividualOccurrenceProbability
				of: SpeedUpEffect new
				withProbability: 15).
			(IndividualOccurrenceProbability
				of: TimeMachineEffect new
				withProbability: 8).
			(IndividualOccurrenceProbability
				of: WormHoleEffect new
				withProbability: 15).
			(IndividualOccurrenceProbability
				of: CardGivingEffect new
				withProbability: 10)}
]

{ #category : #gameCreation }
StandardModelTestResource >> standardGame [
	^ Game
		newPlayedBy: self standardSetOfPlayers
		throwing: self standardSetOfDices
		on: self standardBoard
		using: self standardDeckOfCards
]

{ #category : #standardValues }
StandardModelTestResource >> standardNumberOfLaps [
	^ 2
]

{ #category : #standardValues }
StandardModelTestResource >> standardNumberOfSpots [
	^ 10
]

{ #category : #standardValues }
StandardModelTestResource >> standardSetOfDices [
	^ {(RandomDice newWithFaces: 6)}
]

{ #category : #standardValues }
StandardModelTestResource >> standardSetOfPlayers [
	^ {(Player newNamed: #Player1).
	(Player newNamed: #Player2).
	(Player newNamed: #Player3)}
]
