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

{ #category : #effect }
Card >> applyEffectOn: players on: aGame triggeredBy: aPlayer [
	effect applyEffectOn: players on: aGame triggeredBy: aPlayer
]

{ #category : #accessing }
Card >> effect [
	^ effect
]

{ #category : #initialization }
Card >> initializeWith: anEffect [
	effect := anEffect
]