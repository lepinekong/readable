Red [
    Title: ""
    Note: {revert to 0.0.0.1.7}
]

Add-ReAdABLE: function[
    .readable-source [file! url! block!] 
    .key [string! word! path!] 
    .value
    /duplicate ; duplicate key authorized
][

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

            ; append/only .block new-line (to-set-word .key) true
            ; append/only .block .value
            ; append/only .block new-line reduce [(to-set-word .key) .value] true ; 0.0.0.2.6
            append .block new-line reduce [(to-set-word .key) .value] true ; 0.0.0.2.7
            return .block
    ] 

    key-value: false
    unless duplicate [
        key-value: select readable-block .key
    ]

    either key-value [ ; 0.0.0.1.2: if key exists do not create duplicate key unless specified
        append key-value new-line .value true
    ][
        .append-key-value readable-block .key .value
    ]

    ;=== 0.0.0.1.6: save to file
    if is-source-file? [
        save (.readable-source) (readable-block)
    ]
]
