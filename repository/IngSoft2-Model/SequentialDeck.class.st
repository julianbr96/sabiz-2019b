"
A deck that deals cards in an expected sequence
"
Class {
	#name : #SequentialDeck,
	#superclass : #Deck,
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
SequentialDeck class >> newWithSequence: dealingSequence and: amountOfCards [
	self assert: dealingSequence isNotEmpty description: 'Cant create a Sequential Deck with an empty dealing sequence'.
	^ self new initializeWithSequence: dealingSequence and: amountOfCards 
]

{ #category : #initialization }
SequentialDeck >> initializeWithSequence: sequence and: amountOfCards [
	| dealingSequence |
	cards := OrderedCollection new.
	dealingSequence := SequentialInstrument newWithSequence: sequence.
	amountOfCards timesRepeat: [ self add: dealingSequence generateNext ]
]
