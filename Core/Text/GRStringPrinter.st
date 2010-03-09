GRPrinter subclass: GRStringPrinter [
    | trim length pad character |
    
    <comment: nil>
    <category: 'Grease-Core-Text'>

    character: aCharacter [
	"The character to pad the string with."

	<category: 'accessing'>
	character := aCharacter
    ]

    length: anInteger [
	"The maximal size of the string, or the size to pad to."

	<category: 'accessing'>
	length := anInteger
    ]

    initialize [
	<category: 'initialization'>
	super initialize.
	self
	    character: $ ;
	    length: nil.
	self
	    trimNone;
	    padNone
    ]

    padCenter [
	"Pad to the center."

	<category: 'padding'>
	pad := #pad:center:to:
    ]

    padLeft [
	"Pad to the left."

	<category: 'padding'>
	pad := #pad:left:to:
    ]

    padNone [
	"Do not pad the input."

	<category: 'padding'>
	pad := nil
    ]

    padRight [
	"Pad to the right."

	<category: 'padding'>
	pad := #pad:right:to:
    ]

    print: anObject on: aStream [
	<category: 'printing'>
	| string |
	string := anObject greaseString.
	trim isNil ifFalse: [string := string perform: trim].
	length isNil 
	    ifFalse: [
		length < string size ifTrue: [string := string copyFrom: 1 to: length].
		(pad isNil or: [character isNil]) 
		    ifFalse: [
			string := self 
			    perform: pad
			    with: string
			    with: character
			    with: length]].
	aStream nextPutAll: string
    ]

    trimBoth [
	"Trim to the left and to the right."

	<category: 'trimming'>
	trim := #trimBoth
    ]

    trimLeft [
	"Trim to the left and to the right."

	<category: 'trimming'>
	trim := #trimLeft
    ]

    trimNone [
	"Do not trim the input."

	<category: 'trimming'>
	trim := nil
    ]

    trimRight [
	"Trim to the left and to the right."

	<category: 'trimming'>
	trim := #trimRight
    ]
]

