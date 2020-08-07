"
This class contains information about the current state of a player, consisting of a lap number, the position of the player in the board, and the list of effects that are applied to him
"
Class {
	#name : #PlayerState,
	#superclass : #Object,
	#instVars : [
		'position',
		'roundNumber',
		'cards'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
PlayerState class >> on: spotNumber andLap: lapNumber andRound: roundNumber holding: cards [
	^ self new
		initializeOn: (Position newOn: spotNumber and: lapNumber)
		and: roundNumber
		holding: cards asOrderedCollection
]

{ #category : #'instance creation' }
PlayerState class >> on: spotNumber andLap: lapNumber holding: cards [
	"Used to create the first state"
	^ self on: spotNumber andLap: lapNumber andRound: 0 holding: cards
]

{ #category : #comparing }
PlayerState >> = aPlayerState [
	^ aPlayerState class = self class
		and: [ (self spotNumber = aPlayerState spotNumber
				and: self lapNumber = aPlayerState lapNumber)
				and:
					(self roundNumber = aPlayerState roundNumber
						and: self cardsInHand = aPlayerState cardsInHand) ]
]

{ #category : #comparing }
PlayerState >> > aState [
	self lapNumber == aState lapNumber
		ifTrue: [ ^ self position > aState position ]
		ifFalse: [ ^ self lapNumber > aState lapNumber ]
]

{ #category : #accessing }
PlayerState >> cardsInHand [
	^ cards copy
]

{ #category : #validation }
PlayerState >> checkAvailabilityOf: aCard [
	self
		assert: (cards includes: aCard)
		description: 'That card is not in the hand of the player'
]

{ #category : #comparing }
PlayerState >> hash [
	^ (self spotNumber asString , self lapNumber asString
		, self roundNumber asString , self cardsInHand asString) hash
]

{ #category : #initialization }
PlayerState >> initializeOn: currentPosition and: currentRoundNumber holding: heldCards [
	position := currentPosition.
	roundNumber := currentRoundNumber.
	cards := heldCards
]

{ #category : #accessing }
PlayerState >> lapNumber [
	^ position lapNumber
]

{ #category : #accessing }
PlayerState >> position [
	^ position copy
]

{ #category : #accessing }
PlayerState >> roundNumber [
	^ roundNumber
]

{ #category : #accessing }
PlayerState >> spotNumber [
	^ position spotNumber
]
