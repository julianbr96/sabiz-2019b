"
This effect adds one to every rollSum
"
Class {
	#name : #AccelerationEffect,
	#superclass : #CardPermanentEffect,
	#category : #'IngSoft2-Model'
}

{ #category : #effect }
AccelerationEffect >> applyOn: target on: aGame triggeredBy: aPlayer [
	| card |
	card := Card newWith: self.
	super applyOn: target on: aGame triggeredBy: aPlayer.
	self
		assert: target = aGame players
		description:
			'Tried to play acceleration card on a specific set of players instead of all of them'.
	aGame addPermanentEffectCard: card to: target by: aPlayer.
	aGame addPlayedCard: card to: target by: aPlayer
]

{ #category : #evaluating }
AccelerationEffect >> value [
	^ 1
]
