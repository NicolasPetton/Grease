Object extend [

    greaseDeprecatedApi: apiString details: detailsString [
	<category: '*Grease-Core'>
	GRDeprecatedApiNotification new
	    details: detailsString;
	    signal: apiString
    ]

    isCollection [
	<category: '*Grease-Core'>
	^false
    ]

    greaseString [
	<category: '*Grease-Core'>
	^self printString
    ]
]

String extend [

    greaseString [
	<category: '*Grease-Core'>
	^self
    ]

    excerpt: aString [
	<category: '*Grease-Core'>
	"Answer an excerpt of the receiver that matches the first occurence of aString. If aString isn't found, nil is answered."
	
	^self excerpt: aString radius: 100
    ]

    excerpt: aString radius: anInteger [
	<category: '*Grease-Core'>
	"Answer an excerpt of the receiver that matches the first occurence of aString. 
	The radius anInteger expands the excerpt on each side of the first occurrence by the number of characters defined in radius. 
	If aString isn't found, nil is answered."
	
	^self excerpt: aString radius: anInteger ellipsis: '...'
    ]

    excerpt: aString radius: anInteger ellipsis: anEllipsisString [
	<category: '*Grease-Core'>
	"Answer an excerpt of the receiver that matches the first occurence of aString. 
	The radius anInteger expands the excerpt on each side of the first occurrence by the number of characters defined in radius. 
	If aString isn't found, nil is answered."

	| index start stop |
	(aString isEmpty or: [ (index := self indexOfSubCollection: aString) = 0 ])
	    ifTrue: [ ^ nil ].
	start := index - anInteger max: 1.
	stop := index + anInteger + aString size - 1 min: self size.
	^(start > 1 ifTrue: [ anEllipsisString ] ifFalse: [ '' ]) ,
		(self copyFrom: start to: stop) ,
		(stop < self size ifTrue: [ anEllipsisString ] ifFalse: [ '' ])
    ]

    greaseInteger [
	<category: '*Grease-Core'>
	"Convert the receiver to an integer, answer nil if this is not a number."

	| number stream negated char |
	number := nil.
	stream := self readStream.
	negated := stream peek = $-.
	negated ifTrue: [ stream next ].
	[ stream atEnd not and: [ (char := stream next) isDigit ] ] whileTrue: 
	    [ number := (number isNil 
		ifTrue: [ 0 ]
		ifFalse: [ 10 * number ]) + (char greaseInteger - $0 greaseInteger) ].
	^(number isNil or: [ negated not ]) 
	    ifFalse: [ number negated ]
	    ifTrue: [ number ]
    ]

    pluralize [
	<category: '*Grease-Core'>
	^ GRInflector pluralize: self
    ]

    print: anObject on: aStream [
	<category: '*Grease-Core'>
	aStream nextPutAll: self
    ]

    trimBoth [
	<category: '*Grease-Core'>
	"Trim separators from both sides of the receiving string."
	
	^ self trimBoth: [ :char | char isSeparator ]
    ]

    trimBoth: aBlock [
	<category: '*Grease-Core'>
	"Trim characters satisfying the condition given in aBlock from both sides of the receiving string."

	^ self trimLeft: aBlock right: aBlock
    ]

    trimLeft [
	<category: '*Grease-Core'>
	"Trim separators from the left side of the receiving string."
	    
	^ self trimLeft: [ :char | char isSeparator ]
    ]

    trimLeft: aBlock [
	<category: '*Grease-Core'>
	"Trim characters satisfying the condition given in aBlock from the left side of the receiving string."
	
	^ self trimLeft: aBlock right: [ :char | false ]
    ]

    trimLeft: aLeftBlock right: aRightBlock [
	<category: '*Grease-Core'>
	"Trim characters satisfying the condition given in aLeftBlock from the left side and aRightBlock from the right sides of the receiving string."

	| left right |
	left := 1.
	right := self size.
	[ left <= right and: [ aLeftBlock value: (self at: left) ] ]
		whileTrue: [ left := left + 1 ].
	[ left <= right and: [ aRightBlock value: (self at: right) ] ]
		whileTrue: [ right := right - 1 ].
	^ self copyFrom: left to: right
    ]

    trimRight [
	<category: '*Grease-Core'>
	"Trim separators from the right side of the receiving string."
	
	^ self trimRight: [ :char | char isSeparator ]
    ]

    trimRight: aBlock [
	<category: '*Grease-Core'>
	"Trim characters satisfying the condition given in aBlock from the right side of the receiving string."

	^ self trimLeft: [ :char | false ] right: aBlock
    ]

    truncate [
	<category: '*Grease-Core'>
	"Truncate the receiver to 30 characters."
	
	^ self truncate: 30
    ]

    truncate: anInteger [
	<category: '*Grease-Core'>
	"Truncate the receiver to anInteger characters."
	
	^ self truncate: anInteger ellipsis: '...'
    ]

    truncate: anInteger ellipsis: aString [
	<category: '*Grease-Core'>
	"Truncate the receiver to anInteger characters and append aString as ellipsis if necessary."

	^ anInteger < self size
		ifTrue: [ (self copyFrom: 1 to: anInteger) , aString ]
		ifFalse: [ self copy ]
    ]
]

Symbol extend [
    
    greaseString [
	<category: '*Grease-Core'>
	^self asString
    ]
]

Number extend [
    
    greaseInteger [
	<category: '*Grease-Core'>
	"Answer an integer of the receiver, in our case we simply truncate the number."
	^ self truncated
    ]
]

Integer extend [
    
    greaseInteger [
	<category: '*Grease-Core'>
	^ self
    ]

    pluralize: aSingularString [
	<category: '*Grease-Core'>
	^ self 
	    pluralize: aSingularString
	    with: (GRInflector pluralize: aSingularString)
    ]

    pluralize: aSingularString with: aPluralString [
	<category: '*Grease-Core'>
	^ self printString , ' ' , (self abs = 1 ifTrue: [ aSingularString ] ifFalse: [ aPluralString ])
    ]
]

Character extend [

    print: anObject on: aStream [
	<category: '*Grease-Core'>
	aStream nextPut: self
    ]

    greaseString [
	<category: '*Grease-Core'>
	^self asString
    ]
]

UndefinedObject extend [
    print: anObject on:	aStream [
	<category: '*Grease-Core'>
    ]
]
