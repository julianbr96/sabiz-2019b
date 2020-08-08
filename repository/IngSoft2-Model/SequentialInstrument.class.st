"
Object that represents an instrument that return values in a sequential order
"
Class {
	#name : #SequentialInstrument,
	#superclass : #Object,
	#instVars : [
		'lastGeneratedIndex',
		'generatingSequence'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
SequentialInstrument class >> newWithSequence: sequence [
	self
		assert: sequence isNotEmpty
		description: 'Tried to create a sequence dice with an empty sequence'.
	^ self new initializeWithSequence: sequence
]

{ #category : #validation }
SequentialInstrument >> checkIfSizeOfSequenceAllowsForRemovalOfAnElement [
	self assert: generatingSequence size > 1 description: 'The last element of a sequence cannot be removed'
]

{ #category : #validation }
SequentialInstrument >> checkPresenceOf: element [
	(generatingSequence includes: element)
		ifFalse: [ AssertionFailure
				signal: 'This element is not present in the sequence' ]
]

{ #category : #generating }
SequentialInstrument >> generateNext [
	lastGeneratedIndex := (lastGeneratedIndex + 1)
		% generatingSequence size.
	^ generatingSequence at: lastGeneratedIndex + 1
]

{ #category : #initialization }
SequentialInstrument >> initializeWithSequence: sequence [
	generatingSequence := sequence asOrderedCollection copy.
	lastGeneratedIndex := sequence size - 1
]

{ #category : #removing }
SequentialInstrument >> removeFromSequence: element [
	self checkPresenceOf: element.
	self checkIfSizeOfSequenceAllowsForRemovalOfAnElement.
	(generatingSequence indexOf: element) <= lastGeneratedIndex
		ifTrue: [ lastGeneratedIndex := lastGeneratedIndex - 1 ].
	generatingSequence remove: element.
	lastGeneratedIndex = -1
		ifTrue: [ lastGeneratedIndex := generatingSequence size - 1 ]
]
