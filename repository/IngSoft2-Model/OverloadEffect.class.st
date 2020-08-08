"
This effect reduces the rollSum of a given player by 2
"
Class {
	#name : #OverloadEffect,
	#superclass : #CardPermanentEffect,
	#category : #'IngSoft2-Model'
}

{ #category : #effect }
OverloadEffect >> applyOn: target on: aGame triggeredBy: aPlayer [
	| card |
	card := Card newWith: self.
	super applyOn: target on: aGame triggeredBy: aPlayer.
	self
		assert: target size = 1
		description: 'The overload card can only be played on a single player'.
	self
		assert: (aGame playerHasNotFinished: target first)
		description:
			'The overload card cant be played on a player that has already finished'.
	aGame addPermanentEffectCard: card to: target by: aPlayer.
	aGame addPlayedCard: card to: target by: aPlayer
]

{ #category : #evaluating }
OverloadEffect >> value [
	^ -2
]
