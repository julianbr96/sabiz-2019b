"
This class contains tests about boards
"
Class {
	#name : #BoardTest,
	#superclass : #StandardModelTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #'test -  support' }
BoardTest >> allSpotTypes [
	^ (SpotEffect allSubclasses collect: [ :each | Spot newWith: each new ])
		asArray
]

{ #category : #'test - accessing' }
BoardTest >> testBoardHasGivenNumberOfLaps [
	| board |
	board := Board with: { Spot newWith: NullEffect new } andLaps: 2.
	self assert: board numberOfLaps equals: 2
]

{ #category : #'test - accessing' }
BoardTest >> testBoardHasGivenNumberOfSpots [
	| board |
	board := testResource standardBoardWithSpots: 20.
	self assert: board numberOfSpots equals: 20
]

{ #category : #'test - instance creation' }
BoardTest >> testCreatingACustomBoardRequiresCollectionOfSpotsToUse [
	self
		should: [ Board with: {} andLaps: 2]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Invalid number of spots'
]

{ #category : #'test - accessing' }
BoardTest >> testCustomBoardHasGivenEffectsInTheCorrespondingPosition [
	| board spots |
	spots := self allSpotTypes.
	board := Board with: spots andLaps: 2.
	spots
		withIndexDo: [ :spot :index | self assert: (board effectAt: index) equals: spot effect ]
]

{ #category : #'test - accessing' }
BoardTest >> testEffectTestingBoardHasGivenEffectAtDesiredPositionAndNoEffectsElsewhere [
	| effect board |
	effect := MoonWalkEffect new.
	board := testResource
		effectTestingBoardWithSpots: testResource standardNumberOfSpots
		and: effect
		at: 1.
	1 to: board numberOfSpots do: [ :index | 
		index == 1
			ifTrue: [ self assert: (board effectAt: index) equals: effect ]
			ifFalse: [ self assert: (board effectAt: index) class equals: NullEffect ] ]
]

{ #category : #'test - instance creation' }
BoardTest >> testProhibitsCreatingBoardWithInvalidNumberOfLaps [
	self
		should: [ Board with: {(Spot newWith: NullEffect new)} andLaps: 0 ]
		raise: AssertionFailure	
		whoseDescriptionIncludes: 'Invalid number of laps';
		should: [ Board with: {(Spot newWith: NullEffect new)} andLaps: -1 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Invalid number of laps'
]

{ #category : #'test - instance creation' }
BoardTest >> testProhibitsCreatingBoardWithInvalidNumberOfSpots [
	self
		should: [ testResource standardBoardWithSpots: 0 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Invalid number of spots';
		should: [ testResource standardBoardWithSpots: -1 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Invalid number of spots'
]
