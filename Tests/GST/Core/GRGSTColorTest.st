TestCase subclass: GRGSTColorTest [
    
    <comment: nil>
    <category: 'Grease-Tests-Pharo-Core'>

    expectedFailures [
	<category: 'testing'>
	^#(#testFromStringThreeDigit)
    ]
"
    testAllColors [
	<category: 'testing'>
	| toTest |
	toTest := #(0 1 257 65793 65792 65536 4097 1052673 4386 3359829 6715272
	10070715 13426158 16711697 1193046 7903932 14614236 16711407 16711423
	16711422 16776958 16777214 16777215).
	toTest do: [:int | 
	    | hex |
	    hex := int 
		printPaddedWith: $0
		    to: 6
		    base: 16.
	    self assert: (Color fromString: hex) asHTMLColor asLowercase 
		= ('#' , hex) asLowercase]
    ]
"
    testColorAsHtmlColor [
	"test for:
	 Color >> #hex
	 | aStream |
	 aStream := (String new: 6) writeStream.
	 aStream nextPutAll: (((self red * 255) asInteger printStringBase: 16)
	 padded: #left to: 2 with: $0).
	 aStream nextPutAll: (((self green * 255) asInteger printStringBase: 16)
	 padded: #left to: 2 with: $0).
	 aStream nextPutAll: (((self blue * 255) asInteger printStringBase: 16)
	 padded: #left to: 2 with: $0).
	 ^ aStream contents
	 
	 Color >> #asHTMLColor
	 ^ '#', self hex"
"
	<category: 'testing'>
	self assert: (#('#ffffff' '#FFFFFF') includes: Color white asHTMLColor).
	self assert: Color black asHTMLColor = '#000000'.
	self assert: (#('#ff0000' '#FF0000') includes: Color red asHTMLColor)
"    ]
"
    testFromSixDigit [
	<category: 'testing'>
	self assert: (Color fromString: 'ff0000') = Color red.
	self assert: (Color fromString: 'FF0000') = Color red.
	self assert: (Color fromString: '#ff0000') = Color red.
	self assert: (Color fromString: '#FF0000') = Color red
    ]

    testFromStringName [
	<category: 'testing'>
	self assert: (Color fromString: 'red') = Color red.
	self assert: (Color fromString: 'RED') = Color red.
	self assert: (Color fromString: '#red') = Color red.
	self assert: (Color fromString: '#RED') = Color red
    ]

    testFromStringSixDigit [
	<category: 'testing'>
	self assert: (Color fromString: 'ff0000') = Color red.
	self assert: (Color fromString: 'FF0000') = Color red.
	self assert: (Color fromString: '#ff0000') = Color red.
	self assert: (Color fromString: '#FF0000') = Color red
    ]

    testFromStringThreeDigit [
	<category: 'testing'>
	self assert: (Color fromString: 'f00') = Color red.
	self assert: (Color fromString: 'F00') = Color red.
	self assert: (Color fromString: '#f00') = Color red.
	self assert: (Color fromString: '#F00') = Color red
    ]
"
]

