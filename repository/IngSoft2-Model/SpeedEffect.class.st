"
This effect adds 1 to the rollSum of a given player
"
Class {
	#name : #SpeedEffect,
	#superclass : #CardEffect,
	#category : #'IngSoft2-Model'
}

{ #category : #effect }
SpeedEffect >> applyOn: target on: aGame triggeredBy: aPlayer [
	super applyOn: target on: aGame triggeredBy: aPlayer.
	self
		assert: target size = 1
		description: 'The speedup card can only be played on a single player'.
	self
		assert: (aGame playerHasNotFinished: target first)
		description: 'The speed card cant be played on a player that has already finished'.
	aGame addPlayedCard: (Card newWith: self) to: target
]

{ #category : #validation }
SpeedEffect >> checkTurnOf: aPlayer in: aGame [
	self
		assert: aGame playerWhoseTurnItIsToPlay = aPlayer
		description: 'Cant play a permanent card out of turn'
]

{ #category : #effect }
SpeedEffect >> discardOrApplyPermanentEffectTo: target on: aGame [
	aGame addPermanentEffectCard: (Card newWith: self) to: target
]

{ #category : #evaluating }
SpeedEffect >> permanentEffect [
	^ 1
]
