"
An abstract superclass to model card effects
"
Class {
	#name : #CardEffect,
	#superclass : #Object,
	#instVars : [
		'value'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #effect }
CardEffect >> applyOn: target on: aGame triggeredBy: aPlayer [
	self subclassResponsibility
]
