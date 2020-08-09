"
This effect adds 1 to the rollSum of a given player
"
Class {
	#name : #SpeedEffect,
	#superclass : #CardPermanentEffect,
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
		description: 'The speed card cant be played on a player that has already finished'
]

{ #category : #evaluating }
SpeedEffect >> value [
	^ 1
]
