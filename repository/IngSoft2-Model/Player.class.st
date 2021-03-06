"
This class models a player consisting of a list of states, the last one being its current, a name, and a set of cards to be played
"
Class {
	#name : #Player,
	#superclass : #Object,
	#instVars : [
		'playerName'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Player class >> newNamed: playerName [
	^ self new initializeNamed: playerName
]

{ #category : #comparing }
Player >> = player [
	^ (self class = player class) and: [(self name = player name)]
]

{ #category : #comparing }
Player >> hash [
	^ self name hash
]

{ #category : #initialization }
Player >> initializeNamed: aName [
	playerName := aName.
]

{ #category : #accessing }
Player >> name [
	^ playerName
]
