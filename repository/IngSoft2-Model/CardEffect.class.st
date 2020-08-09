"
An abstract superclass to model card effects
"
Class {
	#name : #CardEffect,
	#superclass : #Object,
	#instVars : [
		'permanentEffect'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #effect }
CardEffect >> applyOn: target on: aGame triggeredBy: aPlayer [
	self subclassResponsibility
]

{ #category : #validation }
CardEffect >> checkTurnOf: aPlayer in: aGame [
	self subclassResponsibility
]

{ #category : #effect }
CardEffect >> discardOrApplyPermanentEffectTo: target on: aGame [
	self subclassResponsibility
]

{ #category : #evaluating }
CardEffect >> permanentEffect [
	self subclassResponsibility
]
