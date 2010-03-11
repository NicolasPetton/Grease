GRCollectionTest subclass: GRStringTest [

    <category: 'Grease-Tests-Core'>
    <comment: nil>

    allowDuplicateValues [
	<category: 'configuration'>
	^true
    ]

    arbitraryCollection [
	<category: 'configuration'>
	^ 'fadbbc' copy   "String literals are immutable"
    ]

    collectionClass [
	<category: 'configuration'>
	^String
    ]

    duplicateElement [
	<category: 'configuration'>
	^$b
    ]

    excludedElement [
	<category: 'configuration'>
	^$Q
    ]

    includedElement [
	<category: 'configuration'>
	^$d
    ]

    isExtensible [
	<category: 'testing-ansi'>
	^false
    ]

    isInitializable [
	<category: 'testing-ansi'>
	^true
    ]

    isSequenced [
	<category: 'testing-ansi'>
	^true
    ]

    isSequencedReadable [
	<category: 'testing-ansi'>
	^true
    ]

    testAsUppercase [
	<category: 'tests'>
	self assert: 'abc' asUppercase = 'ABC'.
	self assert: 'ABC' asUppercase = 'ABC'
    ]

    testCapitalized [
	<category: 'tests'>
	self assert: 'capitalized' capitalized = 'Capitalized'.
	self assert: 'Capitalized' capitalized = 'Capitalized'.
	self assert: 'CAPITALIZED' capitalized = 'CAPITALIZED'.
	self assert: #'capitalized' capitalized = #'Capitalized'.
	self assert: #'Capitalized' capitalized = #'Capitalized'.
	self assert: #'CAPITALIZED' capitalized = #'CAPITALIZED'.
    ]

    testCapitalizedUmlauts [
	<category: 'tests'>
	self assert: 'äöü' capitalized = 'Äöü'.
	self assert: 'Äöü' capitalized = 'Äöü'.
	self assert: 'ÄÖÜ' capitalized = 'ÄÖÜ'.
	self assert: #'äöü' capitalized = #'Äöü'.
	self assert: #'Äöü' capitalized = #'Äöü'.
	self assert: #'ÄÖÜ' capitalized = #'ÄÖÜ'
    ]

    testCopyAfter [
	<category: 'tests'>
	self assert: ('de_CH' copyAfter: $_) = 'CH'
    ]

    testCopyAfterLast [
	<category: 'tests'>
	self assert: ('britney.sex.tape.mkv' copyAfterLast: $.) = 'mkv'.
	self assert: ('britney.sex.tape.mkv' copyAfterLast: $$) = ''
    ]

    testCopyUpTo [
	<category: 'tests'>
	self assert: ('britney.sex.tape.mkv' copyUpTo: $.) = 'britney'.
	self assert: ('britney.sex.tape.mkv' copyUpTo: $$) = 'britney.sex.tape.mkv'
    ]

    testCopyUpToLast [
	<category: 'tests'>
	self assert: ('britney.sex.tape.mkv' copyUpToLast: $.) = 'britney.sex.tape'
    ]

    testIncludesSubString [
	<category: 'tests'>
	self assert: ('britney.sex.tape.mkv' beginsWith: 'britney').
	self deny: ('britney.sex.tape.mkv' beginsWith: 'sex')
    ]

    testSubStrings [
	<category: 'tests'>
	"#subStrings: is defined by ANSI 5.7.10.15:
	Answer an array containing the substrings in the receiver separated by the elements of separators."
	| mimeType tokens |
	mimeType := 'application/xhtml+xml'.
	tokens := mimeType subStrings: '/'.
	self assert: tokens size = 2.
	self assert: tokens first = 'application'.
	self assert: tokens second = 'xhtml+xml'.
	
	"ANSI is a bit unclear on how multiple sequential delimiters should be treated.
	Make sure behaviour is consistent for several delimiters in a row (taken from
	Squeak's behaviour)"
	tokens := 'abc,.def.ghi' subStrings: '.,'.
	self assert: tokens size = 3.
	self assert: tokens first = 'abc'.
	self assert: tokens second = 'def'.
	self assert: tokens third = 'ghi'.
    ]

    testExcerpt [
	<category: 'tests-excerpt'>
	self assert: ('abcde' excerpt: 'c' radius: 0) = '...c...'.
	self assert: ('abcde' excerpt: 'c' radius: 1) = '...bcd...'.
	self assert: ('abcde' excerpt: 'c' radius: 2) = 'abcde'.
	self assert: ('abcde' excerpt: 'c' radius: 3) = 'abcde'.
	
	self assert: ('abcde' excerpt: 'c' radius: 0 ellipsis: 'x') = 'xcx'.
	self assert: ('abcde' excerpt: 'c' radius: 1 ellipsis: 'x') = 'xbcdx'.
	self assert: ('abcde' excerpt: 'c' radius: 2 ellipsis: 'x') = 'abcde'
    ]

    testExcerptEmpty [
	<category: 'tests-excerpt'>
	self assert: ('' excerpt: '') isNil.
	self assert: ('' excerpt: 'x') isNil.
	self assert: ('x' excerpt: '') isNil
    ]

    testExcerptLeft [
	<category: 'tests-excerpt'>
	self assert: ('abcde' excerpt: 'd' radius: 0 ellipsis: 'x') = 'xdx'.
	self assert: ('abcde' excerpt: 'd' radius: 1 ellipsis: 'x') = 'xcde'.
	self assert: ('abcde' excerpt: 'd' radius: 2 ellipsis: 'x') = 'xbcde'.
	self assert: ('abcde' excerpt: 'd' radius: 3 ellipsis: 'x') = 'abcde'
    ]

    testExcerptRight [
	<category: 'tests-excerpt'>
	self assert: ('abcde' excerpt: 'b' radius: 0 ellipsis: 'x') = 'xbx'.
	self assert: ('abcde' excerpt: 'b' radius: 1 ellipsis: 'x') = 'abcx'.
	self assert: ('abcde' excerpt: 'b' radius: 2 ellipsis: 'x') = 'abcdx'.
	self assert: ('abcde' excerpt: 'b' radius: 3 ellipsis: 'x') = 'abcde'
    ]

    testInflectorAssimilated [
	<category: 'tests-pluralize'>
	self assert: 'vertice' pluralize = 'vertices'.
	self assert: 'index' pluralize = 'indices'
    ]

    testInflectorCommonSuffixes [
	<category: 'tests-pluralize'>
	self assert: 'mouse' pluralize = 'mice'.
	self assert: 'synopse' pluralize = 'synopses'.
	self assert: 'man' pluralize = 'men'
    ]

    testInflectorFfffSuffixes [
	<category: 'tests-pluralize'>
	self assert: 'life' pluralize = 'lives'.
	self assert: 'wolf' pluralize = 'wolves'
    ]

    testInflectorIrregular [
	<category: 'tests-pluralize'>
	self assert: 'genie' pluralize = 'genies'.
	self assert: 'ox' pluralize = 'oxen'.
	self assert: 'cow' pluralize = 'kine'.
	self assert: 'child' pluralize = 'children'.
	self assert: 'woman' pluralize = 'women'
    ]

    testInflectorNotInflecting [
	<category: 'tests-pluralize'>
	self assert: 'fish' pluralize = 'fish'.
	self assert: 'travois' pluralize = 'travois'.
	self assert: 'chassis' pluralize = 'chassis'.
	self assert: 'nationalities' pluralize = 'nationalities'
    ]

    testInflectorTsssSuffixes [
	<category: 'tests-pluralize'>
	self assert: 'church' pluralize = 'churches'.
	self assert: 'class' pluralize = 'classes'
    ]

    testInflectorYyyySuffixes [
	<category: 'tests-pluralize'>
	self assert: 'story' pluralize = 'stories'.
	self assert: 'lady' pluralize = 'ladies'.
	self assert: 'stay' pluralize = 'stays'.
    ]

    testTrimBoth [
	<category: 'tests-trim'>
	self assert: '' trimBoth = ''.
	self assert: ' ' trimBoth = ''.
	self assert: '	' trimBoth = ''.
	self assert: 'foo' trimBoth = 'foo'.
	self assert: ' foo ' trimBoth = 'foo'.
	self assert: '  foo  ' trimBoth = 'foo'.
	self assert: ((String with: Character cr), '   foo  ') trimBoth = 'foo'.
	
	self assert: ('aabbaa' trimBoth: [ :each | each = $a ]) = 'bb'.
	self assert: ('bbaabb' trimBoth: [ :each | each = $a ]) = 'bbaabb'
    ]

    testTrimLeft [
	<category: 'tests-trim'>
	self assert: '' trimLeft = ''.
	self assert: ' ' trimLeft = ''.
	self assert: '	' trimLeft = ''.
	self assert: 'foo' trimLeft = 'foo'.
	self assert: ' foo ' trimLeft = 'foo '.
	self assert: '  foo  ' trimLeft = 'foo  '.
	
	self assert: ('aabbaa' trimLeft: [ :each | each = $a ]) = 'bbaa'.
	self assert: ('bbaabb' trimLeft: [ :each | each = $a ]) = 'bbaabb'
    ]

    testTrimRight [
	<category: 'tests-trim'>
	self assert: '' trimRight = ''.
	self assert: ' ' trimRight = ''.
	self assert: '	' trimRight = ''.
	self assert: 'foo' trimRight = 'foo'.
	self assert: ' foo ' trimRight = ' foo'.
	self assert: '  foo  ' trimRight = '  foo'.
	
	self assert: ('aabbaa' trimRight: [ :each | each = $a ]) = 'aabb'.
	self assert: ('bbaabb' trimRight: [ :each | each = $a ]) = 'bbaabb'
    ]

    testTruncate [
	<category: 'tests-truncate'>
	self assert: ('abc' truncate) = 'abc'.
	self assert: ('abc' truncate: 3) = 'abc'.
	self assert: ('abc' truncate: 2) = 'ab...'.
	
	self assert: ('abc' truncate: 1 ellipsis: '') = 'a'.
	self assert: ('abc' truncate: 0 ellipsis: 'none') = 'none'
    ]

    testTruncateEmpty [
	<category: 'tests-truncate'>
	self assert: '' truncate = ''
    ]
]
