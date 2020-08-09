"
This class models cards that can be held and played
"
Class {
	#name : #Card,
	#superclass : #Object,
	#instVars : [
		'effect'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Card class >> newWith: anEffect [
	^ self new initializeWith: anEffect
]

{ #category : #comparing }
Card >> = aCard [
	^ aCard class = self class and: [self effect class = aCard effect class]
]

{ #category : #accessing }
Card >> effect [
	^ effect
]

{ #category : #comparing }
Card >> hash [
	^ self effect className hash
]

{ #category : #initialization }
Card >> initializeWith: anEffect [
	effect := anEffect
]

{ #category : #effect }
Card >> isPlayedBy: aPlayer on: aGame affecting: target [
	effect checkTurnOf: aPlayer in: aGame.
	effect applyOn: target on: aGame triggeredBy: aPlayer.
	effect discardOrApplyPermanentEffectTo: target on: aGame
]
