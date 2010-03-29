TestCase subclass: GRPlatformTest [
    
    <comment: 'A WAPlatformTest is a test to make sure the platform (= the 
    Smalltalk dialect we are running on) implements the protocol we need for 
    system classes like Collection. An example would be to make sure Collection
    implements #count: with the sementics we need.'>
    <category: 'Grease-Tests-Core'>

    decodeUtf8Character: aCollectionOfIntegers [
	"Decodes a collection of bytes into a single character. We have this so 
	we can avoid having non-ASCII characters in the source."

	<category: 'private'>
	| codec toDecode decoded |
	codec := GRCodec forEncoding: 'utf-8'.
	toDecode := String streamContents: [:stream | 
	    aCollectionOfIntegers do: [:each | 
		stream nextPut: (Character codePoint: each)]].
	decoded := codec decode: toDecode.
	self assert: decoded size = 1.
	^decoded at: 1
    ]

    platform [
	<category: 'accessing'>
	^GRPlatform current
    ]

    testAsNumber [
	<category: 'testing'>
	self assert: 2007 asNumber = 2007.
	self assert: '2007' asNumber = 2007
    ]

    testAsSeconds [
	<category: 'testing'>
	| duration |
	duration := Duration 
	    days: 1
	    hours: 0
	    minutes: 0
	    seconds: 0.
	self assert: duration asSeconds = 86400
    ]

    testBlockContextWithPossibleArguments [
	<category: 'testing'>
	| block |
	block := [:x | 1 + x].
	self assert: (block valueWithPossibleArguments: (Array with: 2)) = 3.
	block := [false not].
	self assert: (block valueWithPossibleArguments: (Array with: 3))
    ]

    testBlockValuableProtocol [
	<category: 'testing'>
	self assert: [nil] argumentCount isZero.
	self assert: [:x | x] argumentCount = 1.
	self assert: [:a :b | a + b] argumentCount = 2.
	self shouldnt: [[nil] fixCallbackTemps] raise: Error.
	self shouldnt: [[:x | x] fixCallbackTemps] raise: Error.
	self shouldnt: [[:a :b | a + b] fixCallbackTemps] raise: Error
    ]

    testCharacterAsUnicode [
	"test for:
	 Character >> #asUnicode
	 ^self asInteger"

	<category: 'testing'>
	self assert: $S asUnicode = 83
    ]

    testCharacterTo [
	<category: 'testing'>
	| actual expected |
	actual := Array 
		    withAll: 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-'.
	actual := actual collect: [:each | each greaseInteger].
	expected := #(97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 48 49 50 51 52 53 54 55 56 57 95 45).
	self assert: actual size = expected size.
	actual with: expected do: [:first :second | self assert: first = second]
    ]

    testDateArithmetic [
	<category: 'testing'>
	| today tomorrow oneDay minusOneDay |
	today := DateTime 
	    year: 2008
	    month: 9
	    day: 13
	    hour: 14
	    minute: 32
	    second: 5
	    offset: Duration zero.
	tomorrow := DateTime 
	    year: 2008
	    month: 9
	    day: 14
	    hour: 14
	    minute: 32
	    second: 5
	    offset: Duration zero.
	oneDay := Duration 
	    days: 1
	    hours: 0
	    minutes: 0
	    seconds: 0.
	minusOneDay := Duration 
	    days: -1
	    hours: 0
	    minutes: 0
	    seconds: 0.
	self assert: tomorrow - today = oneDay.
	self assert: today - tomorrow = minusOneDay.
	self assert: today + oneDay = tomorrow.
	self assert: tomorrow - oneDay = today.
	self assert: tomorrow + minusOneDay = today.
	self assert: today - minusOneDay = tomorrow
    ]

    testDaysInMonthForYear [
	<category: 'testing'>
	(1 to: 12) with: #(31 28 31 30 31 30 31 31 30 31 30 31)
	    do: 
		[:month :days | 
		self 
		    assert: days = (Date daysInMonth: (Date nameOfMonth: month) forYear: 2007)]
    ]

    testDigitValue [
	<category: 'testing'>
	'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' with: (0 to: 35)
	    do: [:each :expected | self assert: each digitValue = expected]
    ]

    testEmptyOrNil [
	<category: 'testing'>
	self assert: '' isEmptyOrNil.
	self assert: nil isEmptyOrNil.
	self assert: Array new isEmptyOrNil.
	self deny: 'Timberwolf' isEmptyOrNil
    ]

    testFixCallbackTemps [
	"Make sure that #fixCallbackTemps is properly understood by block-contexts. Make sure that this is either a nop for Smalltalks with true block closures, or it properly fixes the context otherwise."

	<category: 'testing'>
	| array blocks values |
	array := #(1 2 3).
	blocks := array collect: [:each | [each] fixCallbackTemps].
	values := blocks collect: [:each | each value].
	self assert: values = array
    ]

    testGreaseIntegerOnCharacter [
	"ASCII (1 byte)"

	<category: 'testing'>
	| oWithStroke euro manna |
	self assert: $a greaseInteger = 97.
	self assert: $A greaseInteger = 65.

	"Latin-1 (2 byte)"
	oWithStroke := self decodeUtf8Character: #(195 152).
	self assert: oWithStroke greaseInteger = 216.

	"BMP (3 byte)"
	euro := self decodeUtf8Character: #(226 130 172).
	self assert: euro greaseInteger = 8364.

	"SMP (4 byte)"
	manna := self decodeUtf8Character: #(240 144 140 188).
	self assert: manna greaseInteger = 66364
    ]

    testGreaseIntegerOnNumber [
	<category: 'testing'>
	self assert: 2007 greaseInteger = 2007.
	self assert: 2007.0 greaseInteger = 2007.
	self assert: 2007.1 greaseInteger = 2007.
	self assert: 2007.9 greaseInteger = 2007
    ]

    testGreaseIntegerOnString [
	<category: 'testing'>
	self assert: '' greaseInteger isNil.
	self assert: 'a' greaseInteger isNil.
	self assert: ' 1' greaseInteger isNil.
	self assert: 'a1' greaseInteger isNil.
	self assert: '-' greaseInteger isNil.
	self assert: '-a' greaseInteger isNil.
	self assert: '0' greaseInteger = 0.
	self assert: '12' greaseInteger = 12.
	self assert: '123' greaseInteger = 123.
	self assert: '123456789' greaseInteger = 123456789.
	self assert: '-0' greaseInteger = 0.
	self assert: '-12' greaseInteger = -12.
	self assert: '-123.4' greaseInteger = -123.
	self assert: '-123456789' greaseInteger = -123456789
    ]

    testGreaseString [
	<category: 'testing'>
	self assert: 'Timberwolf' greaseString = 'Timberwolf'.
	self assert: #DireWolf greaseString = 'DireWolf'.
	self assert: true greaseString = 'true'.
	self assert: 666 greaseString = '666'.
	self assert: $A greaseString = 'A'.
	self assert: nil greaseString = 'nil'.
	[1 / 0] on: ZeroDivide
	    do: [:error | self assert: error greaseString isString].
	self assert: 15.25 greaseString = '15.25'.
	self assert: nil greaseString isString.
	self assert: (4 @ 2) greaseString = '4@2'.
	"#seasideString for a byte array should not do any decoding
	 this is in place to catch encoding errors early"
	self assert: #(101 97) asByteArray greaseString ~= 'ea'.
	self assert: #(101 97) asByteArray greaseString isString.
	self assert: Object new greaseString isString
    ]

    testIfNil [
	<category: 'testing'>
	self assert: (nil ifNil: [1]) = 1.
	self assert: (1 ifNil: [2]) = 1
    ]

    testIfTrueIfFalse [
	<category: 'testing'>
	self assert: (false ifFalse: [#false]) = #false.
	self assert: (false ifTrue: [#true]) isNil.
	self assert: (true ifTrue: [#true]) = #true.
	self assert: (true ifFalse: [#false]) isNil.
	self assert: (true ifTrue: [#true] ifFalse: [#false]) = #true.
	self assert: (false ifTrue: [#true] ifFalse: [#false]) = #false.
	self assert: (true ifFalse: [#false] ifTrue: [#true]) = #true.
	self assert: (false ifFalse: [#false] ifTrue: [#true]) = #false
    ]

    testIsCharacter [
	<category: 'testing'>
	self deny: 7 isCharacter.
	self assert: $7 isCharacter
    ]

    testIsCollection [
	<category: 'testing'>
	self deny: Object new isCollection
    ]

    testIsKeyword [
	<category: 'testing'>
	self deny: #isKeyword isKeyword.
	self deny: #+ isKeyword.
	self assert: #isKeyword: isKeyword.
	self assert: #isKeyword:isKeyword: isKeyword
    ]

    testIsUnary [
	<category: 'testing'>
	self assert: #isUnary isUnary.
	self deny: #+ isUnary.
	self deny: #isUnary: isUnary.
	self deny: #isUnary:isUnary: isUnary
    ]

    testLabel [
	<category: 'testing'>
	self assert: (self platform label isKindOf: String).
	self deny: self platform label isEmpty
    ]

    testNumArgs [
	<category: 'testing'>
	self assert: #not numArgs isZero.
	self assert: #+ numArgs = 1.
	self assert: #and: numArgs = 1.
	self assert: #value:value: numArgs = 2
    ]

    testPrintStringLimitedTo [
	<category: 'testing'>
	| longString shortString |
	longString := String 
		    streamContents: [:stream | 1 to: 1000 do: [:i | stream nextPutAll: i printString]].
	"Squeak implementation adds 9 characters to limited string and VA Smalltalk adds 10, so we can't do an exact count."
	self assert: longString printString size > 65.
	shortString := longString printStringLimitedTo: 50.
	self assert: shortString size < 65
    ]

    testSeconds [
	<category: 'testing'>
	self assert: Time now seconds isInteger.
	self deny: Time now seconds isFraction
    ]

    testSecureHashFor [
	"Make sure the platform class provides a #secureHashFor: method. The 
	method is called by Seaside when hashing passwords. The Squeak 
	implementation returns a SHA-1 hash but another equivalent hash method 
	could also be used."

	<category: 'testing'>
	| a b |
	a := self platform secureHashFor: 'foobar'.
	b := self platform secureHashFor: 'foobar'.
	self assert: a = b
    ]

    testStackDepth [
	<category: 'testing'>
	| stackDepth someBlock |
	stackDepth := self platform stackDepth.
	self assert: stackDepth isInteger.
	self assert: stackDepth > 0.
	someBlock := [self assert: self platform stackDepth > stackDepth].
	someBlock value.
	self assert: stackDepth = self platform stackDepth
    ]

    testSymbolAsMutator [
	"test for:
	 Symbol >> #asMutator
	 ^ (self copyWith: $:) asSymbol"

	<category: 'testing'>
	self assert: #name asMutator = #name:
    ]

    testTotalSeconds [
	"Answer the total seconds since the Squeak epoch: 1 January 1901."

	<category: 'testing'>
	| seconds |
	seconds := Time totalSeconds.
	self assert: seconds isInteger.
	self assert: seconds > 3421645167
    ]

    testVersion [
	<category: 'testing'>
	self assert: (self platform version isKindOf: GRVersion).
	self assert: (self platform versionString isKindOf: String).
	self deny: self platform versionString isEmpty
    ]

    testRandomGenerator [
	<category: 'testing-streams'>
	| generator collection |
	generator := self platform newRandom.
	self should: [generator nextInt: 0] raise: Error.
	self assert: (generator nextInt: 1) = 1.
	collection := (1 to: 200) collect: [:ea | generator nextInt: 2].
	self assert: (collection includes: 1).
	self assert: (collection includes: 2).
	self assert: collection asSet size = 2.
	collection := 1 to: 5.
	self assert: (collection includes: (generator randomFrom: collection)).
	collection := -1.5 to: 3.5.
	self assert: (collection includes: (generator randomFrom: collection)).
	collection := #(1 2 3 4 5).
	self assert: (collection includes: (generator randomFrom: collection)).
	collection := #(1 2 3 4 5) asSet.
	self assert: (collection includes: (generator randomFrom: collection))
    ]

    testReadStreamAtEnd [
	"ANSI 5.9.2.1"

	<category: 'testing-streams'>
	| stream |
	stream := '' readStream.
	self assert: stream atEnd.
	stream := 'a' readStream.
	self deny: stream atEnd
    ]

    testReadStreamContents [
	"ANSI 5.9.3.1"

	<category: 'testing-streams'>
	| stream |
	stream := 'abc' readStream.
	self assert: stream contents = 'abc'.
	stream next: 2.
	self assert: stream contents = 'abc'
    ]

    testReadStreamNegativeSkip [
	"ANSI does not mention negative values being used with #skip: but we
	 believe they work consistently. If not, we need to update our coding
	 conventions to make sure we never do this."

	<category: 'testing-streams'>
	| stream position |
	stream := 'abcd' readStream.
	stream
	    next;
	    next.
	position := stream position.
	self assert: stream peek = $c.
	stream skip: -1.
	self assert: stream position = (position - 1).
	self assert: stream peek = $b
    ]

    testReadStreamNext [
	"ANSI 5.9.2.3"

	<category: 'testing-streams'>
	| stream |
	stream := 'abcd' readStream.
	self assert: stream next = $a.
	self assert: (stream next: 0) = ''.
	self assert: (stream next: 1) = 'b'.
	self assert: (stream next: 2) = 'cd'
    ]

    testReadStreamPeek [
	"ANSI 5.9.2.7"

	<category: 'testing-streams'>
	| stream |
	stream := 'abcd' readStream.
	self assert: stream peek = $a.
	stream := '' readStream.
	self assert: stream peek isNil
    ]

    testReadStreamPosition [
	"ANSI 5.9.1.4 and 5.9.1.5"

	<category: 'testing-streams'>
	| stream |
	stream := 'abc' readStream.
	self assert: stream position = 0.
	stream next.
	self assert: stream position = 1.
	stream next.
	self assert: stream position = 2.
	stream next.
	self assert: stream position = 3.
	stream position: 1.
	self assert: stream position = 1.
	self assert: stream next = $b.
	stream position: 0.
	self assert: stream position = 0.
	self assert: stream next = $a.
	stream position: 3.
	self assert: stream atEnd
    ]

    testReadStreamReset [
	"ANSI 5.9.1.6"

	<category: 'testing-streams'>
	| stream |
	stream := 'abc' readStream.
	stream next: 2.
	stream reset.
	self assert: stream next = $a
    ]

    testReadStreamSkip [
	"ANSI 5.9.2.9"

	<category: 'testing-streams'>
	| stream |
	stream := 'abcd' readStream.
	self assert: (stream
	    skip: 2;
	    peek) = $c
    ]

    testReadStreamUpTo [
	"ANSI 5.9.2.11"

	<category: 'testing-streams'>
	| stream |
	stream := 'abcd' readStream.
	self assert: (stream upTo: $c) = 'ab'.
	self assert: stream next = $d.
	stream := 'abcd' readStream.
	self assert: (stream upTo: $x) = 'abcd'.
	self assert: stream atEnd
    ]

    testReadStreamUpToEnd [
	"Not defined by ANSI."

	<category: 'testing-streams'>
	| stream |
	stream := 'abcd' readStream.
	self assert: stream upToEnd = 'abcd'.
	self assert: stream atEnd.
	self assert: stream upToEnd = ''.
	self assert: stream atEnd.
	stream := 'abcd' readStream.
	stream upTo: $b.
	self assert: stream upToEnd = 'cd'.
	self assert: stream atEnd
    ]

    testReadWriteStreamAtEnd [
	"ANSI 5.9.2.1"

	<category: 'testing-streams'>
	| stream |
	stream := GRPlatform current readWriteCharacterStream.
	self assert: stream atEnd.
	stream
	    nextPut: $a;
	    reset.
	self deny: stream atEnd
    ]

    testReadWriteStreamContents [
	"ANSI 5.9.3.1"

	<category: 'testing-streams'>
	| stream |
	stream := GRPlatform current readWriteCharacterStream.
	stream
	    nextPutAll: 'abc';
	    reset.
	self assert: stream contents = 'abc'.
	stream next: 2.
	self assert: stream contents = 'abc'.
	stream := GRPlatform current readWriteByteStream.
	stream
	    nextPutAll: 'abc' asByteArray;
	    reset.
	self assert: stream contents = 'abc' asByteArray.
	stream next: 2.
	self assert: stream contents = 'abc' asByteArray
    ]

    testReadWriteStreamNegativeSkip [
	"ANSI does not mention negative values being used with #skip: but we
	 believe they work consistently. If not, we need to update our coding
	 conventions to make sure we never do this."

	<category: 'testing-streams'>
	| stream position |
	stream := GRPlatform current readWriteCharacterStream.
	stream
	    nextPutAll: 'abcd';
	    reset.
	stream
	    next;
	    next.
	position := stream position.
	self assert: stream peek = $c.
	stream skip: -1.
	self assert: stream position = (position - 1).
	self assert: stream peek = $b.
	stream := GRPlatform current readWriteByteStream.
	stream
	    nextPutAll: 'abcd' asByteArray;
	    reset.
	stream
	    next;
	    next.
	position := stream position.
	self assert: stream peek = 99.
	stream skip: -1.
	self assert: stream position = (position - 1).
	self assert: stream peek = 98
    ]

    testReadWriteStreamNext [
	"ANSI 5.9.2.3"

	<category: 'testing-streams'>
	| stream |
	stream := GRPlatform current readWriteCharacterStream.
	stream
	    nextPutAll: 'abcd';
	    reset.
	self assert: stream next = $a.
	self assert: (stream next: 0) = ''.
	self assert: (stream next: 1) = 'b'.
	self assert: (stream next: 2) = 'cd'.
	stream := GRPlatform current readWriteByteStream.
	stream
	    nextPutAll: 'abcd' asByteArray;
	    reset.
	self assert: stream next = 97.
	self assert: (stream next: 0) = '' asByteArray.
	self assert: (stream next: 1) = 'b' asByteArray.
	self assert: (stream next: 2) = 'cd' asByteArray
    ]

    testReadWriteStreamNextPut [
	"ANSI 5.9.4.3"

	<category: 'testing-streams'>
	| stream |
	stream := GRPlatform current readWriteCharacterStream.
	stream nextPut: $a.
	self assert: stream contents = 'a'.
	stream := GRPlatform current readWriteByteStream.
	stream nextPut: 97.
	self assert: stream contents = 'a' asByteArray
    ]

    testReadWriteStreamNextPutAll [
	"ANSI 5.9.4.4"

	<category: 'testing-streams'>
	| stream |
	stream := GRPlatform current readWriteCharacterStream.
	stream nextPutAll: 'abc'.
	self assert: stream contents = 'abc'.
	stream := GRPlatform current readWriteCharacterStream.
	stream nextPutAll: #($a $b $c).
	self assert: stream contents = 'abc'.
	stream := GRPlatform current readWriteByteStream.
	stream nextPutAll: #(97 98 99) asByteArray.
	self assert: stream contents = 'abc' asByteArray
    ]

    testReadWriteStreamPeek [
	"ANSI 5.9.2.7"

	<category: 'testing-streams'>
	| stream |
	stream := GRPlatform current readWriteCharacterStream.
	self assert: stream peek isNil.
	stream := GRPlatform current readWriteCharacterStream.
	stream
	    nextPutAll: 'abcd';
	    reset.
	self assert: stream peek = $a.
	stream := GRPlatform current readWriteByteStream.
	stream
	    nextPutAll: 'abcd' asByteArray;
	    reset.
	self assert: stream peek = 97
    ]

    testReadWriteStreamPosition [
	"ANSI 5.9.1.4 and 5.9.1.5"

	<category: 'testing-streams'>
	| stream |
	stream := GRPlatform current readWriteCharacterStream.
	stream
	    nextPutAll: 'abc';
	    reset.
	self assert: stream position = 0.
	stream next.
	self assert: stream position = 1.
	stream next.
	self assert: stream position = 2.
	stream next.
	self assert: stream position = 3.
	stream position: 1.
	self assert: stream position = 1.
	self assert: stream next = $b.
	stream position: 0.
	self assert: stream position = 0.
	self assert: stream next = $a.
	stream position: 3.
	self assert: stream atEnd.
	stream := GRPlatform current readWriteByteStream.
	stream
	    nextPutAll: 'abc' asByteArray;
	    reset.
	self assert: stream position = 0.
	stream next.
	self assert: stream position = 1.
	stream next.
	self assert: stream position = 2.
	stream next.
	self assert: stream position = 3.
	stream position: 1.
	self assert: stream position = 1.
	self assert: stream next = 98.
	stream position: 0.
	self assert: stream position = 0.
	self assert: stream next = 97.
	stream position: 3.
	self assert: stream atEnd
    ]

    testReadWriteStreamReset [
	"ANSI 5.9.1.6"

	<category: 'testing-streams'>
	| stream |
	stream := GRPlatform current readWriteCharacterStream.
	stream
	    nextPutAll: 'abc';
	    reset.
	stream next: 2.
	stream reset.
	self assert: stream next = $a.
	stream := GRPlatform current readWriteCharacterStream.
	stream
	    nextPutAll: 'abc';
	    reset.
	stream nextPutAll: 'def'.
	self assert: stream contents = 'def'.
	stream := GRPlatform current readWriteByteStream.
	stream
	    nextPutAll: 'abc' asByteArray;
	    reset.
	stream next: 2.
	stream reset.
	self assert: stream next = 97
    ]

    testReadWriteStreamSkip [
	"ANSI 5.9.2.9"

	<category: 'testing-streams'>
	| stream |
	stream := GRPlatform current readWriteCharacterStream.
	stream
	    nextPutAll: 'abcd';
	    reset.
	self assert: (stream
	    skip: 2;
	    peek) = $c.
	stream := GRPlatform current readWriteByteStream.
	stream
	    nextPutAll: 'abcd' asByteArray;
	    reset.
	self assert: (stream
	    skip: 2;
	    peek) = 99
    ]

    testReadWriteStreamTab [
	"ANSI 5.9.4.6"

	<category: 'testing-streams'>
	| stream |
	stream := GRPlatform current readWriteCharacterStream.
	stream tab.
	self assert: stream contents first = Character tab
    ]

    testReadWriteStreamUpTo [
	"ANSI 5.9.2.11"

	<category: 'testing-streams'>
	| stream |
	stream := GRPlatform current readWriteCharacterStream.
	stream
	    nextPutAll: 'abcd';
	    reset.
	self assert: (stream upTo: $c) = 'ab'.
	self assert: stream next = $d.
	stream := GRPlatform current readWriteCharacterStream.
	stream
	    nextPutAll: 'abcd';
	    reset.
	self assert: (stream upTo: $x) = 'abcd'.
	self assert: stream atEnd.
	stream := GRPlatform current readWriteByteStream.
	stream
	    nextPutAll: 'abcd' asByteArray;
	    reset.
	self assert: (stream upTo: 99) = #(97 98) asByteArray.
	self assert: stream next = 100.
	stream := GRPlatform current readWriteByteStream.
	stream
	    nextPutAll: 'abcd' asByteArray;
	    reset.
	self assert: (stream upTo: 120) = #(97 98 99 100) asByteArray.
	self assert: stream atEnd
    ]

    testReadWriteStreamUpToEnd [
	"Not defined by ANSI."

	<category: 'testing-streams'>
	| stream |
	stream := GRPlatform current readWriteCharacterStream.
	stream
	    nextPutAll: 'abcd';
	    reset.
	self assert: stream upToEnd = 'abcd'.
	self assert: stream atEnd.
	self assert: stream upToEnd = ''.
	self assert: stream atEnd.
	stream reset.
	stream upTo: $b.
	self assert: stream upToEnd = 'cd'.
	self assert: stream atEnd.
	stream := GRPlatform current readWriteByteStream.
	stream
	    nextPutAll: 'abcd' asByteArray;
	    reset.
	self assert: stream upToEnd = #(97 98 99 100) asByteArray.
	self assert: stream atEnd.
	self assert: stream upToEnd = #() asByteArray.
	self assert: stream atEnd.
	stream reset.
	stream upTo: 98.
	self assert: stream upToEnd = #(99 100) asByteArray.
	self assert: stream atEnd
    ]

    testWriteStreamContents [
	"ANSI 5.9.3.1"

	<category: 'testing-streams'>
	| stream |
	stream := WriteStream on: String new.
	stream nextPutAll: 'abc'.
	self assert: stream contents = 'abc'.
	stream nextPutAll: 'def'.
	self assert: stream contents = 'abcdef'
    ]

    testWriteStreamCrLf [
	<category: 'testing-streams'>
	| stream |
	stream := WriteStream on: String new.
	stream crlf.
	self assert: stream contents first codePoint = 13.
	self assert: stream contents second codePoint = 10
    ]

    testWriteStreamNextPut [
	"ANSI 5.9.4.3"

	<category: 'testing-streams'>
	| stream |
	stream := WriteStream on: String new.
	stream nextPut: $a.
	self assert: stream contents = 'a'
    ]

    testWriteStreamNextPutAll [
	"ANSI 5.9.4.4"

	<category: 'testing-streams'>
	| stream |
	stream := WriteStream on: String new.
	stream nextPutAll: 'abc'.
	self assert: stream contents = 'abc'.
	stream := WriteStream on: String new.
	stream nextPutAll: #($a $b $c).
	self assert: stream contents = 'abc'
    ]

    testWriteStreamReset [
	"ANSI 5.9.1.6"

	<category: 'testing-streams'>
	| stream |
	stream := WriteStream on: String new.
	stream nextPutAll: 'abc'.
	stream reset.
	stream nextPutAll: 'def'.
	self assert: stream contents = 'def'
    ]

    testWriteStreamSpace [
	"ANSI 5.9.4.5"

	<category: 'testing-streams'>
	| stream |
	stream := WriteStream on: String new.
	stream space.
	self assert: stream contents first = Character space
    ]

    testWriteStreamTab [
	"ANSI 5.9.4.6"

	<category: 'testing-streams'>
	| stream |
	stream := WriteStream on: String new.
	stream tab.
	self assert: stream contents first = Character tab
    ]

    testReadStreamSeasideUpToAll [
	<category: 'testing-streams-seaside'>
	| stream string1 string2 |
	stream := 'abc12def' readStream.
	string1 := stream greaseUpToAll: '12'.
	string2 := stream greaseUpToAll: '12'.
	self assert: string1 = 'abc'.
	self assert: string2 = 'def'.
	self assert: stream atEnd
    ]

    testShutDownList [
	"A smoke test: checks if the test-class can be added and removed to the shutdown list."

	<category: 'testing-image'>
	[self platform addToShutDownList: self class] 
	    ensure: [self platform removeFromShutDownList: self class]
    ]

    testStartUpList [
	"A smoke test: checks if the test-class can be added and removed to the startup list."

	<category: 'testing-image'>
	[self platform addToStartUpList: self class] 
	    ensure: [self platform removeFromStartUpList: self class]
    ]

    testTerminate [
	<category: 'testing-processes'>
	| ensureRun ifCurtailedRun semaphore1 semaphore2 semaphore3 semaphore4 process |
	ensureRun := false.
	ifCurtailedRun := false.
	semaphore1 := self platform semaphoreClass new.
	semaphore2 := self platform semaphoreClass new.
	semaphore3 := self platform semaphoreClass new.
	semaphore4 := self platform semaphoreClass new.
	process := [[[semaphore1 signal.
	    semaphore2 wait] ensure: 
		[ensureRun := true.
		    semaphore3 signal]] 
		ifCurtailed: 
		    [ifCurtailedRun := true.
			semaphore4 signal]] 
		    newProcess.
	self deny: (self platform isProcessTerminated: process).
	process resume.
	semaphore1 wait.
	self deny: (self platform isProcessTerminated: process).
	self platform terminateProcess: process.
	semaphore3 wait.
	self assert: ensureRun.
	semaphore4 wait.
	self assert: ifCurtailedRun.
	self assert: (self platform isProcessTerminated: process)
    ]
]

