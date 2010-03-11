TestCase subclass: GRDelayedSendTest [
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    testArgumentCount [
	"unary"

	<category: 'testing-accessing'>
	| send |
	send := GRDelayedSend receiver: 1 selector: #negated.
	self assert: send argumentCount = 0.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #negated
		    arguments: #().
	self assert: send argumentCount = 0.

	"binary"
	send := GRDelayedSend receiver: 1 selector: #+.
	self assert: send argumentCount = 1.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #+
		    argument: 2.
	self assert: send argumentCount = 0.

	"keyword"
	send := GRDelayedSend receiver: 1 selector: #between:and:.
	self assert: send argumentCount = 2.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #between:and:
		    argument: 2.
	self assert: send argumentCount = 1.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #between:and:
		    arguments: (Array with: 2 with: 3).
	self assert: send argumentCount = 0
    ]

    testFixCallbackTemps [
	<category: 'testing-evaluating'>
	| send |
	send := GRDelayedSend receiver: 1 selector: #+.
	self assert: send fixCallbackTemps == send.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #+
		    argument: 2.
	self assert: send fixCallbackTemps == send
    ]

    testValueBinary [
	<category: 'testing-evaluating'>
	| send |
	send := GRDelayedSend receiver: 1 selector: #+.
	self should: [send value] raise: GRInvalidArgumentCount.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #+
		    argument: 2.
	self assert: send value = 3
    ]

    testValueKeyword [
	<category: 'testing-evaluating'>
	| send |
	send := GRDelayedSend receiver: 1 selector: #between:and:.
	self should: [send value] raise: GRInvalidArgumentCount.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #between:and:
		    argument: 2.
	self should: [send value] raise: GRInvalidArgumentCount.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #between:and:
		    arguments: (Array with: 2 with: 3).
	self deny: send value
    ]

    testValueUnary [
	<category: 'testing-evaluating'>
	| send |
	send := GRDelayedSend receiver: 1 selector: #negated.
	self assert: send value = -1.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #negated
		    arguments: #().
	self assert: send value = -1
    ]

    testValueValueBinary [
	<category: 'testing-evaluating'>
	| send |
	send := GRDelayedSend receiver: 1 selector: #+.
	self should: [send value: 2 value: 3] raise: GRInvalidArgumentCount.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #+
		    argument: 2.
	self should: [send value: 2 value: 3] raise: GRInvalidArgumentCount
    ]

    testValueValueKeyword [
	<category: 'testing-evaluating'>
	| send |
	send := GRDelayedSend receiver: 1 selector: #between:and:.
	self deny: (send value: 2 value: 3).
	send := GRDelayedSend 
		    receiver: 1
		    selector: #between:and:
		    argument: 2.
	self should: [send value: 4 value: 5] raise: GRInvalidArgumentCount.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #between:and:
		    arguments: (Array with: 2 with: 3).
	self should: [send value: 4 value: 5] raise: GRInvalidArgumentCount
    ]

    testValueValueUnary [
	<category: 'testing-evaluating'>
	| send |
	send := GRDelayedSend receiver: 1 selector: #negated.
	self should: [send value: 2 value: 3] raise: GRInvalidArgumentCount.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #negated
		    arguments: #().
	self should: [send value: 2 value: 3] raise: GRInvalidArgumentCount
    ]

    testValueWithArgumentBinary [
	<category: 'testing-evaluating'>
	| send |
	send := GRDelayedSend receiver: 1 selector: #+.
	self assert: (send value: 2) = 3.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #+
		    argument: 2.
	self should: [send value: 2] raise: GRInvalidArgumentCount
    ]

    testValueWithArgumentKeyword [
	<category: 'testing-evaluating'>
	| send |
	send := GRDelayedSend receiver: 1 selector: #between:and:.
	self should: [send value: 2] raise: GRInvalidArgumentCount.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #between:and:
		    argument: 2.
	self deny: (send value: 3).
	send := GRDelayedSend 
		    receiver: 1
		    selector: #between:and:
		    arguments: #(2 3).
	self should: [send value: 4] raise: GRInvalidArgumentCount
    ]

    testValueWithArgumentUnary [
	<category: 'testing-evaluating'>
	| send |
	send := GRDelayedSend receiver: 1 selector: #negated.
	self should: [send value: 2] raise: GRInvalidArgumentCount.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #negated
		    arguments: #().
	self should: [send value: 2] raise: GRInvalidArgumentCount
    ]

    testValueWithArgumentsBinary [
	<category: 'testing-evaluating'>
	| send |
	send := GRDelayedSend receiver: 1 selector: #+.
	self should: [send valueWithArguments: #(2 3)]
	    raise: GRInvalidArgumentCount.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #+
		    argument: 2.
	self should: [send valueWithArguments: #(3 4)]
	    raise: GRInvalidArgumentCount
    ]

    testValueWithArgumentsKeyword [
	<category: 'testing-evaluating'>
	| send |
	send := GRDelayedSend receiver: 1 selector: #between:and:.
	self deny: (send valueWithArguments: #(2 3)).
	send := GRDelayedSend 
		    receiver: 1
		    selector: #between:and:
		    argument: 2.
	self should: [send valueWithArguments: #(3 4)]
	    raise: GRInvalidArgumentCount.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #between:and:
		    arguments: #(2 3).
	self should: [send valueWithArguments: #(4 5)]
	    raise: GRInvalidArgumentCount
    ]

    testValueWithArgumentsUnary [
	<category: 'testing-evaluating'>
	| send |
	send := GRDelayedSend receiver: 1 selector: #negated.
	self should: [send valueWithArguments: #(2 3)]
	    raise: GRInvalidArgumentCount.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #negated
		    arguments: #().
	self should: [send valueWithArguments: #(2 3)]
	    raise: GRInvalidArgumentCount
    ]

    testValueWithPossibleArgumentsBinary [
	<category: 'testing-evaluating'>
	| send |
	send := GRDelayedSend receiver: 1 selector: #+.
	self should: [send valueWithPossibleArguments: #()]
	    raise: GRInvalidArgumentCount.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #+
		    argument: 2.
	self assert: (send valueWithPossibleArguments: #()) = 3.
	send := GRDelayedSend receiver: 1 selector: #+.
	self assert: (send valueWithPossibleArguments: #(2)) = 3.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #+
		    argument: 2.
	self assert: (send valueWithPossibleArguments: #(3)) = 3.
	send := GRDelayedSend receiver: 1 selector: #+.
	self assert: (send valueWithPossibleArguments: #(2 3)) = 3.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #+
		    argument: 2.
	self assert: (send valueWithPossibleArguments: #(3 4)) = 3
    ]

    testValueWithPossibleArgumentsKeyword [
	<category: 'testing-evaluating'>
	| send |
	send := GRDelayedSend receiver: 1 selector: #between:and:.
	self should: [send valueWithPossibleArguments: #()]
	    raise: GRInvalidArgumentCount.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #between:and:
		    argument: 2.
	self should: [send valueWithPossibleArguments: #()]
	    raise: GRInvalidArgumentCount.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #between:and:
		    arguments: (Array with: 2 with: 3).
	self deny: (send valueWithPossibleArguments: #()).
	send := GRDelayedSend receiver: 1 selector: #between:and:.
	self should: [send valueWithPossibleArguments: #(2)]
	    raise: GRInvalidArgumentCount.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #between:and:
		    argument: 2.
	self deny: (send valueWithPossibleArguments: #(3)).
	send := GRDelayedSend 
		    receiver: 1
		    selector: #between:and:
		    arguments: (Array with: 2 with: 3).
	self deny: (send valueWithPossibleArguments: #(4)).
	send := GRDelayedSend receiver: 1 selector: #between:and:.
	self deny: (send valueWithPossibleArguments: #(2 3)).
	send := GRDelayedSend 
		    receiver: 1
		    selector: #between:and:
		    argument: 2.
	self deny: (send valueWithPossibleArguments: #(3 4)).
	send := GRDelayedSend 
		    receiver: 1
		    selector: #between:and:
		    arguments: (Array with: 2 with: 3).
	self deny: (send valueWithPossibleArguments: #(4 5))
    ]

    testValueWithPossibleArgumentsUnary [
	<category: 'testing-evaluating'>
	| send |
	send := GRDelayedSend receiver: 1 selector: #negated.
	self assert: (send valueWithPossibleArguments: #()) = -1.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #negated
		    arguments: #().
	self assert: (send valueWithPossibleArguments: #()) = -1.
	send := GRDelayedSend receiver: 1 selector: #negated.
	self assert: (send valueWithPossibleArguments: #(2)) = -1.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #negated
		    arguments: #().
	self assert: (send valueWithPossibleArguments: #(2)) = -1.
	send := GRDelayedSend receiver: 1 selector: #negated.
	self assert: (send valueWithPossibleArguments: #(2 3)) = -1.
	send := GRDelayedSend 
		    receiver: 1
		    selector: #negated
		    arguments: #().
	self assert: (send valueWithPossibleArguments: #(2 3)) = -1
    ]
]

