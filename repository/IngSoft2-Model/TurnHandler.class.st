"
This class represents the turn handler of the game. It can give the game the information about which player has to play next
"
Class {
	#name : #TurnHandler,
	#superclass : #Object,
	#instVars : [
		'turnWheel',
		'currentRound',
		'currentIndex'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
TurnHandler class >> newFor: participants [
	self
		assert: participants isNotEmpty
		description: 'Cant create TurnAllocator for an empty group'.
	^ self new initializeFor: participants
]

{ #category : #advancing }
TurnHandler >> advanceTurnWheel [
	currentIndex = (turnWheel size - 1)
		ifTrue: [ currentRound := currentRound + 1 ].
	turnWheel isNotEmpty
		ifTrue: [ currentIndex := (currentIndex + 1) % turnWheel size ]
]

{ #category : #'private - validation' }
TurnHandler >> checkPresenceOf: player [
	self
		assert: (turnWheel includes: player)
		description: 'Tried to remove a player that is not in the Turn Wheel'
]

{ #category : #accesing }
TurnHandler >> currentRoundNumber [
	^ currentRound
]

{ #category : #initialization }
TurnHandler >> initializeFor: participants [
	turnWheel := participants asOrderedCollection copy.
	currentIndex := 0.
	currentRound := 1
]

{ #category : #updating }
TurnHandler >> playerHasFinished: player [
	| index |
	self checkPresenceOf: player.
	index := (turnWheel indexOf: player) - 1.
	self
		assert: index = currentIndex
		description: 'Cannot remove a player from the Turn Wheel unless its his turn'.
	turnWheel remove: player.
	currentIndex = turnWheel size
		ifFalse: [ ^ self ].
	currentIndex := 0.
	currentRound := currentRound + 1
]

{ #category : #accesing }
TurnHandler >> playerWhoseTurnItIsToPlay [
	turnWheel isEmpty ifTrue: [ ^ nil ].
	^ turnWheel at: currentIndex + 1
]
