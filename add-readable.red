Red [
    Title: ""
    Note: {when adding block remove first bracket}

]

if not value? '.redlang [
    do https://redlang.red
]
.redlang [get-block-content]

.add-ReAdABLE: function[
    .readable-source [file! url! block!] 
    .key [string! word! path!] 
    .value [any-type!] ; 0.0.0.2.8
    /duplicate ; duplicate key authorized
    /_build
    /silent
][
    >builds: [
        0.0.0.2.10 {support for block value}
    ]

    if _build [
        unless silent [
            ?? >builds
        ]
        return >builds
    ]

    {Example:
        T-2017.12.08-0001: [

            .SYMBOL: AAPL
            .CURRENCY: DOLLAR
            .BROKER: GOLDMAN-SACHS         

            .ACTION-ENTRY: BOUGHT
            .QTY-ENTRY: 100
            .PRICE-ENTRY: 175.95
            .DATETIME-ENTRY: 18/12/2017

        ] 

        transactions: %db/trading-journal.read 
        add-readable transactions 'T-2017.12.08-0001 T-2017.12.08-0001
    }

    is-source-file?: false
    
    either not block? .readable-source [
        readable-block: .read-readable .readable-source
        is-source-file?: true
    ][
        readable-block: .readable-source
    ]

    .append-key-value: function[.block [block!] .key [string! word! path!] .value][
            append .block new-line reduce [(to-set-word .key) .value] true ; 0.0.0.2.7
            return .block
    ]

    key-value: false
    unless duplicate [
        key-value: select readable-block .key
    ]

    either key-value [ ; 0.0.0.1.2: if key exists do not create duplicate key unless specified
        if block? .value [
            .value: .get-block-content .value ; 0.0.0.2.8 if value block type
        ]
        append key-value new-line (to-block .value) true
    ][
        .append-key-value readable-block .key .value
    ]

    ;=== 0.0.0.1.6: save to file
    if is-source-file? [
        save (.readable-source) (readable-block)
    ]
]

add-ReAdABLE: :.add-ReAdABLE
