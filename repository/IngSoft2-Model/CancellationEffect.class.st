"
Object that represents a Cancellation effect triggered by playing a card with this effect
"
Class {
	#name : #CancellationEffect,
	#superclass : #CardInstantEffect,
	#instVars : [
		'effectToEliminate'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #effect }
CancellationEffect >> applyOn: target on: aGame triggeredBy: aPlayer [
	self
		assert:
			(target class = PlayedCard
				and: [ target effect class superclass = CardPermanentEffect ])
		description:
			'The target of a cancelation card must be a played permanent effect card'.
	aGame removePlayedCard: target
]
