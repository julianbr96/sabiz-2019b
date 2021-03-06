"
This class represents a cards that has been played on a target, to maintain state of played cards
"
Class {
	#name : #PlayedCard,
	#superclass : #Card,
	#instVars : [
		'target'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
PlayedCard class >> newOf: effect to: target [
	^ self new initializeWith: effect to: target
]

{ #category : #comparing }
PlayedCard >> = playedCard [
	^ playedCard class = self class
		and: [ self effect class = playedCard effect class
				and: target = playedCard target ]
]

{ #category : #comparing }
PlayedCard >> hash [
	^ (self effect className hash + target hash) asString hash
]

{ #category : #'instance creation' }
PlayedCard >> initializeWith: anEffect to: aTarget [
	effect := anEffect.
	target := aTarget
]

{ #category : #accessing }
PlayedCard >> target [
	^ target copy
]
