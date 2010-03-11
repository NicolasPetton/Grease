TestCase subclass: GRObjectTest [
    
    <comment: nil>
    <category: 'Grease-Tests-Core'>

    testError [
	"Make sure #error: signals a subclass of WAPlatformError."

	<category: 'testing'>
	self should: [GRObject new error: 'oh dear'] raise: GRError.
	self should: [GRObject error: 'oh dear'] raise: GRError
    ]

    testInitialize [
	"Make sure #initialize is called on #new and that calling 
	'super initialize' doesn't error."

	<category: 'testing'>
	self assert: GRObjectStub new foo
    ]
]

