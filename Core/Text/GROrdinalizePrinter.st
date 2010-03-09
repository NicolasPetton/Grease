Eval [
    'From PharoCore1.0rc1 of 19 October 2009 [Latest update: #10505] on 9 March 2010 at 6:38:04 pm'
]



GRPrinter subclass: GROrdinalizePrinter [
    
    <comment: nil>
    <category: 'Grease-Core-Text'>

    print: anObject on: aStream [
	<category: 'printing'>
	aStream nextPutAll: (self ordinalize: anObject integerPart)
    ]

    ordinalize: anInteger [
	<category: 'private'>
	^(anInteger \\ 100 between: 11 and: 13) 
	    ifTrue: ['th']
	    ifFalse: [#('st' 'nd' 'rd') at: anInteger \\ 10 ifAbsent: ['th']]
    ]
]

