Object subclass: GRObject [
    
    <category: 'Grease-Core'>
    <comment: 'A common superclass that ensures consistent initialization behaviour on all platforms and provides #error: methods that signal an instance of WAPlatformError.
    Packages that are using Seaside-Platform should normally subclass WAPlatformObject instead of Object.'>

    GRObject class >> defaultErrorClass [
	<category: 'error handling'>
	^GRError
    ]

    GRObject class >> error: aString [
	<category: 'error handling'>
	^self defaultErrorClass signal: aString
    ]

    GRObject class >> new [
	<category: 'instance creation'>
	^self basicNew initialize
    ]

    error: aString [
	<category: 'error handling'>
	^self class error: aString
    ]

    initialize [
	<category: 'initialization'>
	
    ]
]

