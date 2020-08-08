"
This class contains tests about dices
"
Class {
	#name : #DiceTest,
	#superclass : #StandardModelTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #'test - sequentialDice' }
DiceTest >> testCantCreateSequentialDiceWithEmptySequence [
	self
		should: [ SequentialDice newWithSequence: {} ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Tried to create a sequence dice with an empty sequence'
]

{ #category : #'test - sequentialDice' }
DiceTest >> testCantRemoveLastElementFromSequentialDice [
	| dice |
	dice := SequentialDice newWithSequence: {1 . 2 . 3}.
	dice removeFromSequence: 1.
	dice removeFromSequence: 2.
	self
		should: [ dice removeFromSequence: 3 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'The last element of a sequence cannot be removed'
]

{ #category : #'test - sequentialDice' }
DiceTest >> testCantRemoveUnexistingElementFromSequentialDice [
	| dice |
	dice := SequentialDice newWithSequence: {1 . 2}.
	dice removeFromSequence: 1.
	self
		should: [ dice removeFromSequence: 1 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'This element is not present in the sequence'
]

{ #category : #'test - randomDice' }
DiceTest >> testRandomDiceCreationFailsWhenGivenNumberOfFacesIsLessThanFour [
	self
		should: [ RandomDice newWithFaces: 2 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Number of Faces should be greater than three'
]

{ #category : #'test - randomDice' }
DiceTest >> testRandomDiceRollsValidNumber [
	| dice faces result |
	faces := 6.
	dice := RandomDice newWithFaces: faces.
	result := dice roll.
	self assert: (result > 0 and: result <= faces)
]

{ #category : #'test - sequentialDice' }
DiceTest >> testRemovingElementFromSequentialDiceYieldsExpectedSequence [
	| list  dice |
	list := OrderedCollection new.
	dice := SequentialDice newWithSequence: { 1. 2. 3 }.
	list add: dice roll.
	list add: dice roll.
	list add: dice roll.
	dice removeFromSequence: 2.
	list add: dice roll.
	list add: dice roll.
	self assert: list asArray equals: { 1. 2. 3. 1. 3 }
]

{ #category : #'test - sequentialDice' }
DiceTest >> testSequentialDiceRollsExpectedSequence [
	| dice rolledSequence |
	rolledSequence := OrderedCollection new.
	dice := SequentialDice newWithSequence: {1 . 2 . 3}.
	4 timesRepeat: [ rolledSequence add: dice roll ].
	self assert: rolledSequence asArray equals: {1 . 2 . 3 . 1}
]

{ #category : #'test - sequentialDice' }
DiceTest >> testSequentialDiceRollsExpectedSequenceAfterRemovingElement [
	| dice rolledSequence |
	rolledSequence := OrderedCollection new.
	dice := SequentialDice newWithSequence: {1 . 2 . 3}.
	3 timesRepeat: [rolledSequence add: dice roll].
	dice removeFromSequence: 1.
	rolledSequence add: dice roll.
	self assert: rolledSequence asArray equals: {1 . 2 . 3 . 2}
]
