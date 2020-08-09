"
A game
"
Class {
	#name : #Game,
	#superclass : #Object,
	#instVars : [
		'leaderBoard',
		'dices',
		'board',
		'playersStates',
		'playedCards',
		'deck',
		'turnHandler',
		'triggeredEffects',
		'activePermanentCardEffects'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #validation }
Game class >> checkDices: dices [
	self
		assert: dices isNotEmpty
		description: 'Tried to create a game with an invalid set of Dices'
]

{ #category : #validation }
Game class >> checkDuplicatePlayers: players [
	self assert: players asSet size = players size description: 'The player set contains a duplicate'
]

{ #category : #validation }
Game class >> checkNumberOfCardsOf: deck isEnoughFor: numberOfPlayers [
	| totalOfCardsForAllPlayers |
	totalOfCardsForAllPlayers := numberOfPlayers * 2.
	self
		assert: deck size >= totalOfCardsForAllPlayers
		description: 'The deck has insufficient cards for number of players'
]

{ #category : #validation }
Game class >> checkPlayerQuantity: players [
	self
		assert: players isNotEmpty
		description: 'Cant create a game with no players'
]

{ #category : #'instance creation' }
Game class >> newPlayedBy: players throwing: dices on: aBoard using: aDeck [
	self checkDuplicatePlayers: players.
	self checkPlayerQuantity: players.
	self checkDices: dices.
	self checkNumberOfCardsOf: aDeck isEnoughFor: players size.
	^ self new
		initializeWith: players
		throwing: dices
		on: aBoard
		using: aDeck
]

{ #category : #adding }
Game >> addPermanentEffectCard: card to: target by: player [
	activePermanentCardEffects
		add: (PlayedCard newOf: card effect to: target)
]

{ #category : #'private - effects' }
Game >> addPlayedCard: card to: target by: player [
	| newState newHand |
	card effect className = 'RedoEffect'
		ifFalse: [ playedCards add: (PlayedCard newOf: card effect to: target) ].
	newHand := self cardsInHandOf: player.
	newHand remove: card.
	newState := PlayerState
		on: (self positionOf: player)
		andLap: (self lapOf: player)
		andRound: turnHandler currentRoundNumber
		holding: newHand.
	self updateStateFor: player with: newState
]

{ #category : #'private - effects' }
Game >> apply: effect for: player [
	| effectsTriggeredByPlayer |
	effectsTriggeredByPlayer := triggeredEffects at: player.
	effectsTriggeredByPlayer add: effect.
	effect applyOn: self triggeredBy: player
]

{ #category : #accessingPlayer }
Game >> cardsInHandOf: player [
	^ (self stateOf: player) cardsInHand
]

{ #category : #accessingGameState }
Game >> currentRanking [
	^ (self playersCurrentStates
		sort: [ :assoc1 :assoc2 | assoc1 value position > assoc2 value position ])
		collect: [ :assoc | assoc key ]
]

{ #category : #'private - effects' }
Game >> dealCardTo: player [
	| newState hand |
	hand := self cardsInHandOf: player.
	self deckIsEmpty
		ifTrue: [ ^ self ].
	hand add: deck nextCard.
	newState := PlayerState
		on: (self positionOf: player)
		andLap: (self lapOf: player)
		andRound: (self stateOf: player) roundNumber
		holding: hand.
	self updateStateFor: player with: newState
]

{ #category : #accessingGame }
Game >> deck [
	^ deck
]

{ #category : #validation }
Game >> deckIsEmpty [
	^ deck isEmpty
]

{ #category : #accessingGame }
Game >> dices [
	^ dices copy
]

{ #category : #'private - effects' }
Game >> displace: player by: anAmount [
	| newState |
	newState := board
		nextStateFor: (self stateOf: player)
		afterMoving: anAmount
		onRoundNumber: turnHandler currentRoundNumber.
	self updateStateFor: player with: newState.
	((self playerHasFinished: player)
		and: (leaderBoard doesNotInclude: player))
		ifTrue: [ leaderBoard add: player ]
]

{ #category : #accessingGameState }
Game >> finishRanking [
	^ leaderBoard finishRanking
]

{ #category : #accessingPlayer }
Game >> historyOf: player [
	^ (playersStates at: player) copy
]

{ #category : #initialization }
Game >> initializeWith: gamePlayers throwing: gameDices on: aBoard using: aDeck [
	leaderBoard := LeaderBoard new.
	board := aBoard copy.
	deck := aDeck.
	turnHandler := TurnHandler newFor: gamePlayers.
	dices := gameDices copy.
	playedCards := OrderedCollection new.
	activePermanentCardEffects := OrderedCollection new.
	playersStates := (gamePlayers
		collect: [ :each | 
			Association
				key: each
				value:
					{(PlayerState
						on: 1
						andLap: 0
						holding:
							{deck nextCard.
							deck nextCard})} asOrderedCollection ]) asOrderedDictionary.
	triggeredEffects := (gamePlayers
		collect:
			[ :each | Association key: each value: OrderedCollection new ])
		asOrderedDictionary
]

{ #category : #accessingGameState }
Game >> isNotOver [
	^ (leaderBoard includesAll: self players) not
]

{ #category : #accessingGameState }
Game >> isOver [
	^ self isNotOver not
]

{ #category : #accessingGame }
Game >> isPlayedBy: player [
	^ self players includes: player
]

{ #category : #accessingPlayer }
Game >> lapOf: player [
	^ (self stateOf: player) lapNumber
]

{ #category : #'private - moving' }
Game >> move: player [
	| newState |
	newState := board
		nextStateFor: (self stateOf: player)
		afterMoving: (self totalDisplacementFor: player)
		onRoundNumber: turnHandler currentRoundNumber.
	self updateStateFor: player with: newState.
	self player: player triggersEffectAt: newState spotNumber.
	((self playerHasFinished: player)
		and: (leaderBoard doesNotInclude: player))
		ifTrue: [ leaderBoard add: player ]
]

{ #category : #'private - effects' }
Game >> moveEveryoneToTheFirstSpot [
	self playersStillPlaying
		do: [ :each | 
			self
				updateStateFor: each
				with:
					(PlayerState
						on: 1
						andLap: (self lapOf: each)
						andRound: turnHandler currentRoundNumber
						holding: (self cardsInHandOf: each)) ]
]

{ #category : #accessingGame }
Game >> numberOfPlayers [
	^ self players size
]

{ #category : #playing }
Game >> play: card by: player on: target [
	self
		assert: (self playerHasNotFinished: player)
		description: 'Trying to play a card for a player that has already finished'.
	(self stateOf: player) checkAvailabilityOf: card.
	card applyEffectOn: target on: self triggeredBy: player.
	self addPlayedCard: card to: target by: player
]

{ #category : #playing }
Game >> playAnEntireGameWithoutPlayingCards [
	[ self isNotOver ] whileTrue: [ self playOneRoundWithoutPlayingCards ]
]

{ #category : #playing }
Game >> playOneRoundWithoutPlayingCards [
	| roundNumber |
	self assert: self isNotOver description: 'Game is already over'.
	roundNumber := turnHandler currentRoundNumber.
	[ roundNumber = turnHandler currentRoundNumber ]
		whileTrue: [ self throwDicesFor: self playerWhoseTurnItIsToPlay ]
]

{ #category : #'private - effects' }
Game >> player: player triggersEffectAt: spotNumber [
	| effect |
	effect := board effectAt: spotNumber.
	self apply: effect for: player
]

{ #category : #'private - effects' }
Game >> player: player triggersMoonWalkEffectMoving: anAmount [
	self playersStillPlaying
		do: [ :each | 
			| newState |
			(each = player)
				ifFalse: [ newState := board
						nextStateFor: (self stateOf: each)
						afterMoving: anAmount
						onRoundNumber: turnHandler currentRoundNumber.
					self updateStateFor: each with: newState ] ]
]

{ #category : #accessingGameState }
Game >> playerHasFinished: player [
	^ (self playerHasNotFinished: player) not
]

{ #category : #accessingGameState }
Game >> playerHasNotFinished: player [
	^ (self lapOf: player) < board numberOfLaps
]

{ #category : #accessingGameState }
Game >> playerWhoseTurnItIsToPlay [
	^ turnHandler playerWhoseTurnItIsToPlay
]

{ #category : #accessingGame }
Game >> players [
	^ playersStates keys copy
]

{ #category : #accessingGameState }
Game >> playersCurrentStates [
	^ (self players
		collect: [ :player | Association key: player value: (self stateOf: player) ])
		asArray
]

{ #category : #accessingGameState }
Game >> playersStillPlaying [
	^ self players select: [ :each | self playerHasNotFinished: each ]
]

{ #category : #accessingPlayer }
Game >> positionOf: player [
	^ (self stateOf: player) spotNumber
]

{ #category : #'private - effects' }
Game >> positionsToMoveAfterCalculatingPermanentEffectsOn: player [
	| cardsTargetingPlayer |
	cardsTargetingPlayer := (activePermanentCardEffects
		select: [ :each | each target includes: player ])
		collect: [ :each | each effect value ].
	cardsTargetingPlayer isNotEmpty
		ifTrue: [ ^ cardsTargetingPlayer sum ].
	^ 0
]

{ #category : #'private - effects' }
Game >> removePlayedCard: playedCard [
	activePermanentCardEffects
		remove: playedCard
		ifAbsent: [ AssertionFailure
				signal:
					'Tried to remove a non existent played card (check that both the effect and the target are in order)' ]
]

{ #category : #'private - effects' }
Game >> repeatLastEffectTriggeredBy: player [
	| effectsTriggeredByPlayer effect |
	effectsTriggeredByPlayer := triggeredEffects at: player.
	self
		assert: effectsTriggeredByPlayer isNotEmpty
		description: 'Cant play repeat card on a player that hasnt triggered an effect yet'.
	"Steping on a null effect still counts as triggering an effect"
	effect := effectsTriggeredByPlayer last.
	self apply: effect for: player
]

{ #category : #'private - effects' }
Game >> replayLastCardOn: target for: player [
	| card |
	self
		assert: playedCards isNotEmpty
		description:
			'Cannot play redo card as there are no active played cards on the pile'.
	card := Card newWith: playedCards last effect.
	card applyEffectOn: target on: self triggeredBy: player
]

{ #category : #'private - effects' }
Game >> rewindPositionFor: player [
	| targetState round |
	round := (self stateOf: player) roundNumber.
	targetState := (self historyOf: player)
		select: [ :each | each roundNumber = (round - 1) ].
	targetState isNotEmpty
		ifTrue: [ targetState := targetState first ]
		ifFalse: [ ^ self ].
	self
		updateStateFor: player
		with:
			(PlayerState
				on: targetState spotNumber
				andLap: targetState lapNumber
				andRound: round
				holding: (self cardsInHandOf: player))
]

{ #category : #'private - moving' }
Game >> rollSum [
	^ dices inject: 0 into: [ :sum :dice | sum + dice roll ]
]

{ #category : #accessingGameState }
Game >> roundNumber [
	^ turnHandler currentRoundNumber
]

{ #category : #accessingPlayer }
Game >> stateOf: player [
	^ (playersStates
		at: player
		ifAbsent: [ AssertionFailure
				signal: 'Asked for a player that is not in the game' ]) last copy
]

{ #category : #playing }
Game >> throwDicesFor: player [
	self
		assert: (self playerHasNotFinished: player)
		description: 'Trying to move a player that has already finished'.
	self
		assert: self playerWhoseTurnItIsToPlay = player
		description: 'Trying to move a player out of turn'.
	self
		updateStateFor: player
		with:
			(PlayerState
				on: (self positionOf: player)
				andLap: (self lapOf: player)
				andRound: turnHandler currentRoundNumber
				holding: (self cardsInHandOf: player)).
	self move: player.
	(self playerHasFinished: player)
		ifTrue: [ turnHandler playerHasFinished: player ]
		ifFalse: [ turnHandler advanceTurnWheel ]
]

{ #category : #'private - moving' }
Game >> totalDisplacementFor: player [
	^ self rollSum + (self positionsToMoveAfterCalculatingPermanentEffectsOn: player)
]

{ #category : #'private - updating' }
Game >> updateStateFor: player with: aState [
	| playerStates |
	playerStates := playersStates at: player.
	playerStates add: aState
]

{ #category : #accessingGameState }
Game >> winner [
	^ leaderBoard winner
]
