Red [
    Title: "to-readable.red"
]

.to-reAdABLE: function['.source [string! file! url! unset!]][

    if not value? 'load-json [

        do https://redlang.red/altjson.red

        bind json-loader/object-name: [
		string space #":" space (
			emit either is-flat [
				to set-word! current-value
			][
				any [
					to-word current-value
					current-value
				]
			]
		    )
	    ]  json-loader
        
    ]

    switch type?/word get/any '.source [
        unset! [
            ask "copy json to clipboard then enter..."
            source: read-clipboard
            readable: load-json/flat source
            ask "ReAdable will be copied to clipboard..."
            write-clipboard mold readable
        ]
        file! [
            source: .read .source
        ]
        url![
            .source: form .source
            source: .read .source
        ]
        string! [
            source: .source
        ]
    ]
    
    return load-json/flat source

] 

to-readable: :.to-reAdABLE
