GRObject subclass: GRGSTRandomProvider [
    
    <comment: nil>
    <category: 'Grease-GST-Core'>

    GRGSTRandomProvider class [
	| mutex generator |
	
    ]

    GRGSTRandomProvider class >> initialize [
	<category: 'private'>
	GRPlatform current addToStartUpList: self.
	self startUp
    ]

    GRGSTRandomProvider class >> randomClass [
	<category: 'private'>
	^Random
    ]

    GRGSTRandomProvider class >> unload [
	<category: 'private'>
	GRPlatform current removeFromStartUpList: self
    ]

    GRGSTRandomProvider class >> nextInt: anInteger [
	"Answer a random integer in the interval [1, anInteger]"

	<category: 'public'>
	^mutex critical: [generator nextInt: anInteger]
    ]

    GRGSTRandomProvider class >> randomFrom: aCollection [
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

    GRGSTRandomProvider class >> startUp [
	<category: 'class initialization'>
	generator := self randomClass new.
	mutex := Semaphore forMutualExclusion
    ]
]



Eval [
    GRGSTRandomProvider initialize
]

