"
Class that represents a game board with spots
"
Class {
	#name : #Board,
	#superclass : #Object,
	#instVars : [
		'spots',
		'laps'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #validation }
Board class >> checkNumberOfLaps: laps [
	self assert: laps > 0 description: 'Invalid number of laps'
]

{ #category : #validation }
Board class >> checkNumberOfSpots: spotsAmmount [
	self assert: spotsAmmount > 0 description: 'Invalid number of spots'
]

{ #category : #'instance creation' }
Board class >> newWith: effectDistribution andSpots: spotsAmount andLaps: laps [
	| spots |
	spots := OrderedCollection new.
	spotsAmount
		timesRepeat: [ spots add: (Spot newWith: effectDistribution random) ].
	^ self with: spots andLaps: laps
]

{ #category : #'instance creation' }
Board class >> with: spotCollection andLaps: laps [
	self checkNumberOfSpots: spotCollection size.
	self checkNumberOfLaps: laps.
	^ self new initializeWith: spotCollection andLaps: laps
]

{ #category : #accessing }
Board >> effectAt: position [
	self assert: (position > 0 and: position <= self numberOfSpots).
	^ (spots at: position) effect
]

{ #category : #initialization }
Board >> initializeWith: spotsCollection andLaps: numberOfLaps [
	spots := spotsCollection.
	laps := numberOfLaps
]

{ #category : #'private - moving' }
Board >> nextStateFor: state afterMoving: rollSum onRoundNumber: roundNumber [
	| newLapNumber netNewPosition grossNewPosition |
	grossNewPosition := state spotNumber + rollSum.
	newLapNumber := state lapNumber
		+ (grossNewPosition // self numberOfSpots).
	netNewPosition := grossNewPosition % self numberOfSpots.
	netNewPosition isZero
		ifTrue: [ netNewPosition := self numberOfSpots.
			newLapNumber := newLapNumber - 1 ].
	^ PlayerState
		on: netNewPosition
		andLap: newLapNumber
		andRound: roundNumber
		holding: state cardsInHand
]

{ #category : #accessing }
Board >> numberOfLaps [
	^ laps
]

{ #category : #accessing }
Board >> numberOfSpots [
	^ spots size
]
