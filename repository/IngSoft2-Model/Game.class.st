"
A game with a given number of spots
"
Class {
	#name : #Game,
	#superclass : #Object,
	#instVars : [
		'numberOfSpots',
		'winner',
		'players'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Game class >> withSpots: numberOfSpots [
	self assert: numberOfSpots > 0 description: 'Number of spots invalid'.
	^self new
		initializeWith: numberOfSpots 

]

{ #category : #setting }
Game >> addPlayer: player [ 
	players add: player
]

{ #category : #initialization }
Game >> initializeWith: spotAmount [
	numberOfSpots := spotAmount.
	players := OrderedCollection new.
]

{ #category : #playing }
Game >> makeMoveByPlayer: player advancing: rollResult [ 
	player advance: rollResult.
	player position >= self numberOfSpots 
		ifTrue: [ self setWinner: player ]
]

{ #category : #accessing }
Game >> numberOfSpots [
	^numberOfSpots
]

{ #category : #accessing }
Game >> players [
	^ players
]

{ #category : #setting }
Game >> setWinner: player [ 
	winner := player
]

{ #category : #accessing }
Game >> theWinnerIs [
	^ winner
]