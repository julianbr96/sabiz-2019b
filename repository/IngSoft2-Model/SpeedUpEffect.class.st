"
Move forwards 4 spots
"
Class {
	#name : #SpeedUpEffect,
	#superclass : #SpotEffect,
	#category : #'IngSoft2-Model'
}

{ #category : #standardValues }
SpeedUpEffect >> applyOn: game triggeredBy: player [
	game displace: player by: self numberOfSpotsToGoForward
]

{ #category : #standardValues }
SpeedUpEffect >> numberOfSpotsToGoForward [
	^ 4
]
