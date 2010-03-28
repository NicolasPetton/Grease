TestCase subclass: GRGSTPlatformTest [
    
    <comment: nil>
    <category: 'Grease-Tests-Gst-Core'>

    testCompileIntoClassified [
	<category: 'tests'>
	| source protocol selectors selector |
	source := 'aMethod
	[^ ''a result'']'.
	protocol := 'a-protocol'.
	selector := #aMethod.
	GRPlatform current 
	    compile: source
	    into: self class
	    classified: protocol.
	[self assert: (self class selectors includes: selector).
	self assert: (self class whichCategoryIncludesSelector: selector) = protocol]
		ensure: [self class removeSelector: selector]
    ]

    testConvertToSmalltalkNewlines [
	<category: 'tests'>
	| expected euro |
	expected := 'selector' , (String with: Character cr) , '"comment"'.
	self assert: expected 
	    = (GRPlatform current convertToSmalltalkNewlines: expected).
	self assert: expected = (GRPlatform current 
	    convertToSmalltalkNewlines: 'selector' , (String with: Character lf) 
		, '"comment"').
	self assert: expected = (GRPlatform current 
	    convertToSmalltalkNewlines: 'selector' 
		, (String with: Character cr with: Character lf) , '"comment"').
	euro := UnicodeString with: (UnicodeCharacter codePoint: 8364).
	self assert: (expected asUnicodeString, euro) 
	    = (GRPlatform current convertToSmalltalkNewlines: expected asUnicodeString, euro).
	self assert: (GRPlatform current convertToSmalltalkNewlines: nil) isNil
    ]

    testFullName [
	<category: 'tests'>
	self assert: Object fullName = 'Object'
    ]

    testGreaseIntegerOnCharacter [
	<category: 'tests'>
	| character |
	character := Character codePoint: 19982.
	self assert: character greaseInteger = 19982.
	character := UnicodeCharacter value: 19982.
	self assert: character greaseInteger = 19982.
    ]

    testDirectedMessageValueWithPossibleArguments [
	<category: 'tests'>
	| send |
	send := DirectedMessage receiver: 1 selector: #+.
	self assert: (send valueWithPossibleArguments: (Array with: 2)) = 3.
	self assert: (send valueWithArguments: (Array with: 2)) = 3.
	self assert: (send value: 2) = 3.
	send := DirectedMessage receiver: false selector: #not.
	self assert: (send valueWithPossibleArguments: (Array with: 3)).
	send := DirectedMessage 
	    receiver: 1
	    selector: #+
	    arguments: #(2).
	self assert: (send valueWithPossibleArguments: (Array with: 4)) = 3.
	self assert: send value = 3.
	send := DirectedMessage 
	    receiver: Array
	    selector: #with:with:
	    arguments: #(1).
	self assert: (send valueWithPossibleArguments: (Array with: 2)) size = 2.
	send := DirectedMessage receiver: Array selector: #with:with:.
	self assert: (send value: 1 value: 2) size = 2.
	send := DirectedMessage receiver: 1 selector: #+.
	self assert: send argumentCount = 1.
	self assert: send arguments size = 0.
	self assert: send fixCallbackTemps == send.
	send := DirectedMessage 
	    receiver: 1
	    selector: #+
	    argument: 2.
	self assert: send argumentCount isZero.
	self assert: send arguments size = 1.
	self assert: send fixCallbackTemps == send
    ]
]

