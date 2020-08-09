"
Object that represents a Cancellation effect triggered by playing a card with this effect
"
Class {
	#name : #CancellationEffect,
	#superclass : #CardEffect,
	#category : #'IngSoft2-Model'
}

{ #category : #effect }
CancellationEffect >> applyOn: target on: aGame triggeredBy: aPlayer [
	self
		assert:
			(target class = PlayedCard
				and: [ target effect permanentEffect isNotNil ])
		description:
			'The target of a cancelation card must be a played permanent effect card'.
	aGame removePlayedCard: target.
	aGame addPlayedCard: (Card newWith: self) to: target
]

{ #category : #validation }
CancellationEffect >> checkTurnOf: aPlayer in: aGame [
	self assert: true
]

{ #category : #effect }
CancellationEffect >> discardOrApplyPermanentEffectTo: target on: aGame [
	aGame discardCard: (Card newWith: self)
]

{ #category : #evaluating }
CancellationEffect >> permanentEffect [
	^ nil
]
