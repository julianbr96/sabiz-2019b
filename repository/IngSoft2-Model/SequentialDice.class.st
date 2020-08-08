"
This is a dice that continuously rolls a predetermined sequence of values
"
Class {
	#name : #SequentialDice,
	#superclass : #Dice,
	#instVars : [
		'rollingSequence'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
SequentialDice class >> newWithSequence: sequence [
	self
		assert: sequence isNotEmpty
		description: 'Tried to create a sequence dice with an empty sequence'.
	^ self new initializeWithSequence: sequence
]

{ #category : #initialization }
SequentialDice >> initializeWithSequence: sequence [
	rollingSequence := SequentialInstrument newWithSequence: sequence
]

{ #category : #updatingSequence }
SequentialDice >> removeFromSequence: element [
	rollingSequence removeFromSequence: element
]

{ #category : #roll }
SequentialDice >> roll [
	^ rollingSequence generateNext
]
