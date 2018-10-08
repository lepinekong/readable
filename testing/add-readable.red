Red [
    Title: ""
    Note: {when adding block remove first bracket}
    GUID: #2bd32f1e-d70e-44fa-ae16-3950347dbd12
    Description: [
        1 {Rechercher si la clé existe}

    ]
    Release: 1

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
        0.0.0.3.2 {support for favorites/bookmarks/documentaries/Finance key}
        0.0.0.2.10 {support for block value}
    ]

    if _build [
        unless silent [
            ?? >builds
        ]
        return >builds
    ]

    if error? try [
        .key: to-word form .key ; case .key: 0.0.0.1
    ][
        .key: form .key
    ]

    is-source-file?: false
    
    either not block? .readable-source [
        readable-block: .read-readable .readable-source
        is-source-file?: true
    ][
        readable-block: .readable-source
    ]

    repetition: func [data-block key .value][ ; [a: [b: [c: [http://google.com]]]] 'a [b: [http://yahoo.com]]
        either not duplicate [
            key-value: select data-block key ; [b: [c: [http://google.com]]]

            either key-value [ ; 1: [b: [c: [http://google.com]]] ; 2: [c: [http://google.com]]

                if error? try [
                    key2: to-word form first key-value ; 'b ; 'c

                    value2: select .value key2 ; [https://yahoo.com]

                    either none? value2 [
                        append key-value .value
                    ][
                        repetition key-value key2 value2 ; [b: [c: [http://google.com]]]
                    ]
                    
                ][
                    append key-value .value
                ]

            ][
                append key-value .value
            ]
        ][
            append key-value .value
        ]         
    ]

    repetition readable-block .key .value


    ;=== 0.0.0.1.6: save to file
    if is-source-file? [
        save (.readable-source) (readable-block)
    ]
]

add-ReAdABLE: :.add-ReAdABLE
