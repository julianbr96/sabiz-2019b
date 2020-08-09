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
	value := cardToRedo effect value.
	cardToRedo applyEffectOn: target on: aGame triggeredBy: aPlayer
]

{ #category : #evaluating }
RedoEffect >> value [
	^ value
]
