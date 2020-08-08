"
A deck that deals cards in an expected sequence
"
Class {
	#name : #SequentialDeck,
	#superclass : #Deck,
	#instVars : [
		'dealingSequence'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
SequentialDeck class >> newWithSequence: dealingSequence [
	self assert: dealingSequence isNotEmpty description: 'Cant create a Gimmick Deck with an empty dealing sequence'.
	^ self new initializeWithSequence: dealingSequence
]

{ #category : #initialization }
SequentialDeck >> initializeWithSequence: sequence [
	dealingSequence := SequentialInstrument newWithSequence: sequence
]

{ #category : #accessing }
SequentialDeck >> nextCard [
	^ dealingSequence generateNext
]
