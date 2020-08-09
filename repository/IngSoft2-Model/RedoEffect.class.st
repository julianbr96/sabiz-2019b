"
This Object represents a instant redo effect triggered by using a card
"
Class {
	#name : #RedoEffect,
	#superclass : #CardEffect,
	#category : #'IngSoft2-Model'
}

{ #category : #effect }
RedoEffect >> applyOn: target on: aGame triggeredBy: aPlayer [
	| cardToRedo |
	cardToRedo := aGame lastPlayedCard.
	permanentEffect := cardToRedo effect permanentEffect.
	permanentEffect checkTurnOf: aPlayer in: aGame.
	cardToRedo effect applyOn: target on: aGame triggeredBy: aPlayer
]

{ #category : #validation }
RedoEffect >> checkTurnOf: aPlayer in: aGame [
	
]

{ #category : #effect }
RedoEffect >> discardOrApplyPermanentEffectTo: target on: aGame [
	self permanentEffect isNotNil
		ifTrue: [ aGame addPermanentEffectCard: (Card newWith: self) to: target ]
		ifFalse: [ aGame discardCard: (Card newWith: self) ]
]

{ #category : #evaluating }
RedoEffect >> permanentEffect [
	^ permanentEffect
]
