"
This effect adds one to every rollSum
"
Class {
	#name : #AccelerationEffect,
	#superclass : #CardEffect,
	#category : #'IngSoft2-Model'
}

{ #category : #effect }
AccelerationEffect >> applyOn: target on: aGame triggeredBy: aPlayer [
	self
		assert: target = aGame players
		description:
			'Tried to play acceleration card on a specific set of players instead of all of them'.
	aGame addPlayedCard: (Card newWith: self) to: target
]

{ #category : #validation }
AccelerationEffect >> checkTurnOf: aPlayer in: aGame [
	self
		assert: aGame playerWhoseTurnItIsToPlay = aPlayer
		description: 'Cant play a permanent card out of turn'
]

{ #category : #effect }
AccelerationEffect >> discardOrApplyPermanentEffectTo: target on: aGame [
	aGame addPermanentEffectCard: (Card newWith: self) to: target
]

{ #category : #evaluating }
AccelerationEffect >> permanentEffect [
	^ 1
]
