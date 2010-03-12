TestCase subclass: GRGstPlatformTest [
    
    <comment: nil>
    <category: 'Grease-Tests-Gst-Core'>

    testCompileIntoClassified [
	<category: 'tests'>
	| source protocol selectors selector |
	source := 'aMethod
	^ ''a result'''.
	protocol := 'a-protocol'.
	selector := #aMethod.
	GRPlatform current 
	    compile: source
	    into: self class
	    classified: protocol.
	[self assert: (self class selectors includes: selector).
	selectors := self class organization listAtCategoryNamed: protocol.
	self assert: selectors = (Array with: selector)] 
		ensure: [self class removeSelectorSilently: selector]
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
	euro := String with: (Character codePoint: 8364).
	self assert: (expected , euro) 
	    = (GRPlatform current convertToSmalltalkNewlines: expected , euro).
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
	character := Unicode value: 19982.
	self assert: character greaseInteger = 19982.
	LanguageEnvironment allSubclassesDo: [:each | 
	    (each class selectors includes: #leadingChar) 
		ifTrue: 
		    ["fuck me gently with a chainsaw"
		    character := Character leadingChar: each leadingChar code: 19982.
		    self assert: character greaseInteger = 19982]]
    ]

    testMessageSendValueWithPossibleArguments [
	<category: 'tests'>
	| send |
	send := MessageSend receiver: 1 selector: #+.
	self assert: (send valueWithPossibleArguments: (Array with: 2)) = 3.
	self assert: (send valueWithArguments: (Array with: 2)) = 3.
	self assert: (send value: 2) = 3.
	send := MessageSend receiver: false selector: #not.
	self assert: (send valueWithPossibleArguments: (Array with: 3)).
	send := MessageSend 
	    receiver: 1
	    selector: #+
	    arguments: #(2).
	self assert: (send valueWithPossibleArguments: (Array with: 4)) = 3.
	self assert: send value = 3.
	send := MessageSend 
	    receiver: Array
	    selector: #with:with:
	    arguments: #(1).
	self assert: (send valueWithPossibleArguments: (Array with: 2)) size = 2.
	send := MessageSend receiver: Array selector: #with:with:.
	self assert: (send value: 1 value: 2) size = 2.
	send := MessageSend receiver: 1 selector: #+.
	self assert: send argumentCount = 1.
	self assert: send arguments size = 0.
	self assert: send fixCallbackTemps == send.
	send := MessageSend 
	    receiver: 1
	    selector: #+
	    argument: 2.
	self assert: send argumentCount isZero.
	self assert: send arguments size = 1.
	self assert: send fixCallbackTemps == send
    ]
]

