Error subclass: GRError [

    <category: 'Grease-Core-Exceptions'>
    <comment: 'This class provides consistent initialization and exception signaling behaviour across platforms. All platforms must provide the ANSI-standard signaling protocol on this class. #signal: can therefore be safely called on any subclass.
    
    Packages that are using Seaside-Platform should usually subclass WAPlatformError instead of Error.'>
]

Notification subclass: GRNotification [
    
    <category: 'Grease-Core-Exceptions'>
    <comment: 'This class provides consistent initialization and exception signaling behaviour across platforms. All platforms must provide the ANSI-standard signaling protocol on this class. #signal: can therefore be safely called on any subclass.
    
    Packages that are using Seaside-Platform should usually subclass WAPlatformNotification instead of Notification.'>
]

GRNotification subclass: GRDeprecatedApiNotification [
    | details |

    <category: 'Grease-Core-Exceptions'>
    <comment: 'This notification is signaled whenever a deprecated message is sent.
    
    see WAObject>>#seasideDeprecatedApi:details: '>

    details [
	<category: 'accessing'>
	^details
    ]

    details: anObject [
	<category: 'accessing'>
	details := anObject
    ]
]
