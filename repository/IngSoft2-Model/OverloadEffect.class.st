"
This effect reduces the rollSum of a given player by 2
"
Class {
	#name : #OverloadEffect,
	#superclass : #CardEffect,
	#category : #'IngSoft2-Model'
}

{ #category : #effect }
OverloadEffect >> applyOn: target on: aGame triggeredBy: aPlayer [
	self
		assert: target size = 1
		description: 'The overload card can only be played on a single player'.
	self
		assert: (aGame playerHasNotFinished: target first)
		description:
			'The overload card cant be played on a player that has already finished'.
	aGame addPlayedCard: (Card newWith: self) to: target
]

{ #category : #validation }
OverloadEffect >> checkTurnOf: aPlayer in: aGame [
	self
		assert: aGame playerWhoseTurnItIsToPlay = aPlayer
		description: 'Cant play a permanent card out of turn'
]

{ #category : #effect }
OverloadEffect >> discardOrApplyPermanentEffectTo: target on: aGame [
	aGame addPermanentEffectCard: (Card newWith: self) to: target
]

{ #category : #evaluating }
OverloadEffect >> permanentEffect [
	^ -2
]
