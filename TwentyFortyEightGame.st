Object subclass: #GBoard
	instanceVariableNames: 'matrix score'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TwentyFortyEightGame'!
!GBoard commentStamp: 'BrandonHaas 4/11/2017 23:34' prior: 0!
Responsible for the board mechanics.!


!GBoard methodsFor: 'initialization' stamp: 'BrandonHaas 4/12/2017 08:23'!
initialize
	"resets"
	super initialize.
	self reset.
	score := 0.! !


!GBoard methodsFor: 'setters' stamp: 'BrandonHaas 4/11/2017 23:17'!
reset
	"resets matrix"
	matrix := { { 0 . 0 . 0 . 0 }.
				 	{ 0 . 0 . 0 . 0 }. 
					{ 0 . 0 . 0 . 0 }.
					{ 0 . 0 . 0 . 0 }. }.
	self addRandomTile.! !

!GBoard methodsFor: 'setters' stamp: 'BrandonHaas 4/12/2017 07:05'!
copyBoardFrom: aMatrix
	"copies values from an altered matrix"
	| array x |
	1 to: 4 do: [ :i |
					  1 to: 4 do: [ :j |
										 array := aMatrix at: i.
										 array size < j
										 	ifTrue: [ x := 0 ]
											ifFalse: [ x := array at: j ].
										 (matrix at: i) at: j put: x ] ].! !

!GBoard methodsFor: 'setters' stamp: 'BrandonHaas 4/12/2017 07:46'!
setScore: addScore
	"keeps track of your current score"
	score := score + addScore.! !

!GBoard methodsFor: 'setters' stamp: 'BrandonHaas 4/12/2017 00:02'!
addRandomTile
	"adds random tile to open spots on board"
	| spot freeSpots i j |
	i := 0.
	freeSpots := matrix collect: [ :line | i := i + 1. j := 0.
											 line collect: [ :e | j := j + 1.
																  e = 0
																  	ifTrue: [ i@j ]  
																	ifFalse: [ {} ] ] ].
	freeSpots := freeSpots flattened.
	freeSpots size = 0
		ifTrue: [ ^nil ].
	spot := freeSpots atRandom.
	i := spot x. j := spot y.
	^(matrix at: i) at: j put: 2.
! !


!GBoard methodsFor: 'getters' stamp: 'BrandonHaas 4/11/2017 23:15'!
maxValue
	"max value of matrix"
	^matrix flattened max.! !

!GBoard methodsFor: 'getters' stamp: 'BrandonHaas 4/12/2017 08:20'!
showScore
	"gets your current score"
	Transcript show: 'Your current score is: ' , score asString , '!!'; cr.! !

!GBoard methodsFor: 'getters' stamp: 'BrandonHaas 4/11/2017 23:04'!
at: row at: column
	"locates spot"
	^(matrix at: row) at: column.! !

!GBoard methodsFor: 'getters' stamp: 'BrandonHaas 4/11/2017 23:14'!
matrix
	"returns matrix"
	^matrix.! !


!GBoard methodsFor: 'boolean' stamp: 'BrandonHaas 4/12/2017 07:01'!
isCollidable
	"checks whether there are free spots to drag"
	^((self collideMatrix: matrix) flattened size < 16 or:
	 (self collideMatrix: self rotateMatrix) flattened size < 16).! !

!GBoard methodsFor: 'boolean' stamp: 'BrandonHaas 4/12/2017 07:12'!
isFinished
	"checks whether game should end because no free spots"
	Transcript show: 'Game is over.'; cr.	
	^self isCollidable not and: matrix flattened min > 0.! !


!GBoard methodsFor: 'actions' stamp: 'BrandonHaas 4/12/2017 08:34'!
dragLeft
	"drags tiles to the left"
	| draggedMatrix |
	draggedMatrix := matrix collect: [ :array | array select: [ :e | e > 1 ] ].
	self copyBoardFrom: (self collideMatrix: draggedMatrix).! !

!GBoard methodsFor: 'actions' stamp: 'BrandonHaas 4/12/2017 06:59'!
collideMatrix: aMatrix
	"responsible for piecing together the individual rows/columns after collideTiles"
	^aMatrix collect: [ :array | self collideTiles: array ].! !

!GBoard methodsFor: 'actions' stamp: 'BrandonHaas 4/11/2017 23:26'!
dragUp
	"drag the tiles up"
	self rotate.
	self dragLeft.
	self rotate; rotate; rotate.! !

!GBoard methodsFor: 'actions' stamp: 'BrandonHaas 4/12/2017 07:03'!
rotate
	"updates matrix to the rotated matrix for dragging in a certain direction"
	matrix := self rotateMatrix.! !

!GBoard methodsFor: 'actions' stamp: 'BrandonHaas 4/11/2017 23:23'!
dragDown
	"drags tiles down"
	self rotate; rotate; rotate.
	self dragLeft.
	self rotate.! !

!GBoard methodsFor: 'actions' stamp: 'BrandonHaas 4/11/2017 23:25'!
dragRight
	"drags tiles to the right"
	self rotate; rotate.
	self dragLeft.
	self rotate; rotate.! !

!GBoard methodsFor: 'actions' stamp: 'BrandonHaas 4/12/2017 08:32'!
collideTiles: array
	"responsible for determining whether tiles merge or not when colliding"
	| collision |
	array size < 2
		ifTrue: [ ^array ]
		ifFalse: [ collision := array fold: [ :a :b | | sub |
													  sub := OrderedCollection newFrom: { a } flattened.
													  sub last = b
													  	ifTrue: [ self setScore: (0 - sub last - b) abs.
																	 sub at: sub size put: 0 - sub last - b; yourself ]
														ifFalse: [ sub add: b; yourself ] ].
					  ^collision collect: [ :e | e abs ] ]. ! !

!GBoard methodsFor: 'actions' stamp: 'BrandonHaas 4/11/2017 23:23'!
rotateMatrix
	"rotates matrix"
	| rotatedMatrix |
	rotatedMatrix := Array new: 4.
	4 to: 1 by: -1 do: [ :i |
								rotatedMatrix at: 5 - i
								put: (matrix collect: [ :e | e at: i]) ].
	^rotatedMatrix.! !


Morph subclass: #GTile
	instanceVariableNames: 'label colors'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TwentyFortyEightGame'!
!GTile commentStamp: 'BrandonHaas 4/11/2017 23:34' prior: 0!
Responsible for the game tiles.!


!GTile methodsFor: 'initialization' stamp: 'BrandonHaas 4/12/2017 02:34'!
initialize
	"initializes a tile"
	super initialize.
	self borderWidth: 5.
	bounds := 0@0 corner: 100@100.
	self borderColor: (Color r:0.64 g:0.57 b:0.52).
	label := StringMorph new.
	self setValue: 0.
	self addMorph: label.
	colors := { Color r:0.99 g:0.95 b:0.87. 	"2"
	 				Color r:0.92 g:0.82 b:0.53. 	"4"
					Color r:0.95 g:0.64 b:0.25. 	"8"
					Color r:0.95 g:0.50 b:0.23. 	"16"
					Color r:0.92 g:0.36 b:0.09. 	"32"
					Color r:0.96 g:0.30 b:0.06. 	"64"
					Color r:0.94 g:0.85 b:0.40. 	"128"
					Color r:0.84 g:0.76 b:0.03. 	"256"
					Color 	r:0.84 g:0.76 b:0.03. 	"512"
					Color r:0.84 g:0.76 b:0.03. 	"1024"
					Color r:0.84 g:0.76 b:0.03. 	"2048" }.! !


!GTile methodsFor: 'setters' stamp: 'BrandonHaas 4/12/2017 02:07'!
setValue: aNumber
	"sets value for tile"
	label acceptValue: aNumber.
	label position: self center - (label extent / 2).
	aNumber > 1
		ifTrue: [ self color: (colors at: (aNumber log: 2)) ]
		ifFalse: [ self color: (Color r:0.81 g:0.78 b:0.71).
					  label acceptValue: ''].! !


BorderedMorph subclass: #TheGameClass
	instanceVariableNames: 'board tiles'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TwentyFortyEightGame'!
!TheGameClass commentStamp: 'BrandonHaas 4/12/2017 07:18' prior: 0!
Run game by typing 'TheGameClass playGame' in Playground. Open Transcript to show the current score of your game.!


!TheGameClass methodsFor: 'event handler' stamp: 'BrandonHaas 4/11/2017 22:36'!
handlesMouseOver: anEvent
	"handles mouse over events"
	^true.! !

!TheGameClass methodsFor: 'event handler' stamp: 'BrandonHaas 4/12/2017 08:34'!
handleKeystroke: anEvent
	"handles keyboard events"
	| keyValue drag |
	keyValue := anEvent keyValue.
	keyValue = 30 	"up arrow"
		ifTrue: [ drag := #dragUp ].
	keyValue = 31 	"down arrow"
		ifTrue: [ drag := #dragDown ].
	keyValue = 29 	"right arrow"
		ifTrue: [ drag := #dragRight].
	keyValue = 28 	"left arrow"
		ifTrue: [ drag := #dragLeft ].
	(keyValue between: 28 and: 31)
		ifTrue: [ board perform: drag.
					 board perform: #showScore.
					 board addRandomTile.
					 self updateBoard.
					 board maxValue = 2048
					 	ifTrue: [ board isFinished ]. ].! !

!TheGameClass methodsFor: 'event handler' stamp: 'BrandonHaas 4/11/2017 22:37'!
mouseEnter: anEvent
	"gets the keyboard focus when the mouse enters the morph"
	anEvent hand newKeyboardFocus: self.! !

!TheGameClass methodsFor: 'event handler' stamp: 'BrandonHaas 4/11/2017 22:38'!
mouseLeave: anEvent
	"hands back the focus when the pointer leaves the morph"
	anEvent hand newKeyboardFocus: nil.! !


!TheGameClass methodsFor: 'initialization' stamp: 'BrandonHaas 4/12/2017 07:48'!
initialize
	"initializes the board"
	| n proto width height |
	super initialize.
	self color: (Color r:0.81 g:0.78 b:0.71).
	self borderColor: (Color r:0.64 g:0.57 b:0.52).
	n := self nbCells.
	proto := GTile new.
	width := proto width.
	height := proto height.
	self borderWidth: 5.
	self bounds: (10@10 extent: ((n * width)@(n * height)) + (2 * self borderWidth)).
	tiles := Matrix new: n tabulate: [ :i :j | (self newTileAt: i and: j withValue: 0) show ].
	board := GBoard new.
	self updateBoard.! !

!TheGameClass methodsFor: 'initialization' stamp: 'BrandonHaas 4/11/2017 23:45'!
nbCells
	"number of colles on each side of board"
	^4.! !


!TheGameClass methodsFor: 'setters' stamp: 'BrandonHaas 4/12/2017 02:16'!
updateBoard
	"updates the board"
	tiles withIndicesDo: [ :e :i :j | | x |
								x := board at: j at: i.
								x > 0
									ifTrue: [ e setValue: x. e show ]
									ifFalse: [ e setValue: 0. e show ]. ].! !

!TheGameClass methodsFor: 'setters' stamp: 'BrandonHaas 4/11/2017 22:50'!
newTileAt: i and: j withValue: x
	"Updates the tiles for the current board"
	| tile origin |
	tile := GTile new.
	tile setValue: x.
	origin := self innerBounds origin.
	self addMorph: tile.
	tile position: ((i - 1) * tile width)@((j - 1) * tile height) + origin.
	^tile.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

TheGameClass class
	instanceVariableNames: ''!

!TheGameClass class methodsFor: 'constructor' stamp: 'BrandonHaas 4/12/2017 08:22'!
playGame
	"start game"
	Transcript show: 'Welcome to TwentyFortyEightGame!!'; cr.	
	TheGameClass new initialize openInWorld.! !
  
