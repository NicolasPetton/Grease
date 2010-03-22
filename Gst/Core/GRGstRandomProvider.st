GRObject subclass: GRGstRandomProvider [
    
    <comment: nil>
    <category: 'Grease-Pharo-Core'>

    GRGstRandomProvider class [
	| mutex generator |
	
    ]

    GRGstRandomProvider class >> initialize [
	<category: 'private'>
	Smalltalk addToStartUpList: self.
	self startUp
    ]

    GRGstRandomProvider class >> randomClass [
	<category: 'private'>
	^Random
    ]

    GRGstRandomProvider class >> unload [
	<category: 'private'>
	GRPlatform current removeFromStartUpList: self
    ]

    GRGstRandomProvider class >> nextInt: anInteger [
	"Answer a random integer in the interval [1, anInteger]"

	<category: 'public'>
	^mutex critical: [generator nextInt: anInteger]
    ]

    GRGstRandomProvider class >> randomFrom: aCollection [
	<category: 'public'>
	| random count |
	random := self nextInt: aCollection size.
	^aCollection isSequenceable 
	    ifTrue: [aCollection at: random]
	    ifFalse: 
		[count := 1.
		aCollection do: 
			[:ea | 
			count = random ifTrue: [^ea].
			count := count + 1]]
    ]

    GRGstRandomProvider class >> startUp [
	<category: 'class initialization'>
	generator := self randomClass new.
	mutex := Semaphore forMutualExclusion
    ]
]



Eval [
    GRGstRandomProvider initialize
]

