"
This class represents a Deck of cards
"
Class {
	#name : #Deck,
	#superclass : #Object,
	#instVars : [
		'cards'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Deck class >> newWith: effectDistribution and: amountOfCards [
	| cards |
	cards := OrderedCollection new.
	amountOfCards 
		timesRepeat: [ cards add: (Card newWith: effectDistribution random) ].
	^ self new initializeWith: cards
]

{ #category : #adding }
Deck >> add: aCard [
	cards add: aCard
]

{ #category : #initialization }
Deck >> initializeWith: cardsCollection [
	cards := cardsCollection 
]

{ #category : #testing }
Deck >> isEmpty [
	^ cards isEmpty
]

{ #category : #accessing }
Deck >> nextCard [
	| nextCard |
	self isEmpty
		ifTrue: [ AssertionFailure signal: 'The Deck is Empty' ].
	nextCard := cards first.
	cards remove: cards first.
	^ nextCard
]

{ #category : #accessing }
Deck >> size [
	^ cards size
]
