Red [
    Title: "ReAdABLE.Human.Format" 
    Description: "ReAdABLE Human Format Library" 
    UUID: #e2aa0251-ed1b-416e-8442-ad7c75e30d37
] 
    unless value? '.cache [
        __OFFLINE_MODE__: false if value? in system/words '__OFFLINE_MODE__ [
            __OFFLINE_MODE__: get in system/words '__OFFLINE_MODE__
        ] 
        either __OFFLINE_MODE__ [
            if error? try [
                do-thru http://redlang.red/cache.red
            ] [
                print "error do cache.red from cache"
            ]
        ] [
            if error? try [
                do-thru/update http://redlang.red/cache.red
            ] [
                __OFFLINE_MODE__: true 
                if error? try [
                    do-thru http://redlang.red/cache.red
                ] [
                    print "error do cache.red from cache"
                ]
            ]
        ]
    ] 
    unless value? '.do-cache [
        .do-cache: func [param>urls] [either block? param>urls [
            forall param>urls [.do-cache (param>urls/1)]
        ] [either value? '.cache [.cache (param>urls)] [do (param>urls)]]] do-cache: :.do-cache
    ] 
    either value? '.cache [
        .cache https://redlang.red/section.red 
        .cache https://redlang.red/get-short-filename.red 
        .cache https://redlang.red/to-file.red 
        .cache https://redlang.red/use.red 
        .cache https://redlang.red/do-events.red
    ] [
        do https://redlang.red/section.red 
        do https://redlang.red/get-short-filename.red 
        do https://redlang.red/to-file.red 
        do https://redlang.red/use.red 
        do https://redlang.red/do-events.red
    ] 
    .emit: function [
        "Help:^/        ^/    " 
        param>line [char! string! block! none!] /_build "Build number for developer" 
        /silent "don't print message on console" 
        /_debug "debug mode"
    ] [
        if _debug [
            do https://redlang.red/do-trace
        ] 
        >builds: [
		[0.0.0.1.3.1 {u}]
		[0.0.0.1.3.1 {initial}]
		[0.0.0.1.3.1 {initial}]
            0.0.0.1.1.1 "Initial Build"
        ] 
        if _build [
            unless silent [
                print >builds
            ] 
            return >builds
        ] 
        if _debug [
            do-trace 47 [
                ?? param>line
            ] %emit.1.red
        ] 
        if none? (param>line) [exit] either block? (param>line) [~line: rejoin (param>line)] [~line: (param>line)] write/lines/append =>output-file ~line
    ] 
    emit: :.emit 
    .replace: function [
        series [series! none!] pattern 
        value 
        /all
    ] [
        if error? try [
            either all [
                replace/all series pattern value 
                return series
            ] [
                replace series pattern value 
                return series
            ]
        ] [
            return none
        ]
    ] 
    .get-full-path: function [.path [file! string! url!]] [.cases .type? '.path [
        string! url! [
            path: to-red-file to-string .path
        ]
    ] [
        path: .path
    ] 
        clean-path path
    ] 
    .to-full-path: :.get-full-path 
    .switch: function [
        {Evaluates the first block following the value found in cases} 
        value [any-type!] "The value to match" cases [block!] case [block!] "Default block to evaluate"
    ] [value: to-word value 
        switch/default value cases case
    ] 
    .cases: :.switch 
    .type?: function [
        "Returns the datatype of a value" 
        value [any-type!]
    ] [type: type?/word get/any value] 
    set to-word rejoin ["--" ">"] none 
    script-path: 
    system/options/script 
    either none? script-path [
        short-filename: "ReAdABLE.Human.Format.red"
    ] [
        short-filename: .get-short-filename/wo-extension script-path
    ] 
    if exists? %config/readable.config.red [
        do %config/readable.config.red
    ] 
    unless value? 'articles-types [
        articles-types: [
            Article 
            Tutorial 
            Memento 
            Glossary 
            Documentation 
            Doc 
            Index
        ]
    ] 
    article?: false 
    foreach article-type articles-types [
        if value? article-type [
            article?: true 
            article: get in system/words article-type 
            break
        ]
    ] 
    unless article? [
        Article: [
            Title: "Default Article to load instead"
        ]
    ] 
    .markdown-gen: function [/input <=input-file /output =>output-file [file! url! string! unset!]] [condition: (not value? 'article) and (not value? 'tutorial) either (condition) [.default-input-file: %ReAdABLE.Human.Format.data.red 
        .default-output-file: %ReAdABLE.Human.Format.html 
        unless input [
            <=input-file: .default-input-file
        ] 
        unless output [
            =>output-file: .default-output-file
        ] 
        print ["reading" <=input-file "..."] 
        do read <=input-file
    ] [] 
        if not value? 'article [
            if value? 'Tutorial [
                System/words/Article: Tutorial
            ]
        ] 
        either output [
            =>output-file: .to-file =>output-file
        ] [
            =>output-file: .to-file reduce [short-filename ".md"]
        ] 
        if exists? =>output-file [
            delete =>output-file 
            print ["deleting..." =>output-file]
        ] use ["global .emit you don't need to touch"] [
            spec: spec-of :.emit 
            body: body-of :.emit 
            bind body '=>output-file 
            emit: function spec body
        ] 
        use ["alert messages you can customize"] [
            message-processing: function [] [.do-events/no-wait 
                print "processing..." 
                .do-events/no-wait
            ] 
            refresh-screen: function [] [.do-events/no-wait]
        ] 
        use ["generic formatting functions you can customize"] [
            emit-title-level: function [.title .title-level] [title: .title 
                n: .title-level 
                title: replace/all title "    " "" 
                marker: copy "" 
                repeat i n [append marker "#"] 
                emit [newline marker " " title newline]
            ] emit-title: function [.title] [unless none? .title [
                emit-title-level .title 1
            ]] 
            .title: :emit-title 
            emit-sub-title: function [.title] [unless none? .title [
                emit-title-level .title 2
            ]] 
            .sub-title: :emit-sub-title 
            emit-paragraph-title: function [.title] [unless ((none? .title) or (.title = "")) [
                emit-title-level .title 3
            ]] 
            .paragraph-title: :emit-paragraph-title 
            emit-image: function [image] [if find image "https://imgur.com" [
                if not find image ".png" [
                    image: rejoin [image ".png"]
                ]
            ] 
                unless none? image [
                    emit [
                        "![" image "]" 
                        "(" image 
                        ")^/                    "
                    ]
                ]
            ] 
            .image: :emit-image 
            emit-content: function [content] [content-block: copy [] 
                either find content "```" [
                    use [lines flag flag_line] [lines: .read/lines content 
                        flag: false 
                        forall lines [
                            line: lines/1 i: index? lines 
                            if find line "```" [
                                .replace/all line "    " "" 
                                flag: not flag either flag [
                                    line: rejoin [newline newline line]
                                ] [append line newline 
                                    append line newline
                                ]
                            ] 
                            either flag = true [
                                .replace/all line "                " "" 
                                append line newline
                            ] [
                                .replace/all line "    " ""
                            ] 
                            append content-block line
                        ]
                    ] 
                    content: copy "" 
                    forall content-block [
                        i: index? content-block 
                        n: length? content-block 
                        append content content-block/1 unless i = n [
                            unless find content newline [
                                append content newline
                            ]
                        ]
                    ]
                ] [
                    content: .replace/all content "    " ""
                ] 
                emit content
            ] 
            .content: :emit-content 
            youtube?: function [url] [either block? url [
                foreach element url [
                    try [
                        if find element "youtube.com" [
                            return true
                        ]
                    ]
                ]
            ] [
                if find url "youtube.com" [
                    return true
                ]
            ] 
                return false
            ] 
            normalize-url-block: function [title-with-url] [first-item: title-with-url/1 either url? first-item [
                title: title-with-url/2 url: title-with-url/1
            ] [title: title-with-url/1 url: title-with-url/2 if issue? url [
                url: rejoin [(to-string url) (mold title-with-url/3)]
            ]] return reduce [title url]] emit-youtube: function [youtube-url-or-id [url! string! word! block!]] [YOUTUBE_WIDTH: 560 
                YOUTUBE_HEIGHT: 315 
                YOUTUBE_EMBED_URL_PREFIX: https://www.youtube.com/embed/ 
                unless none? youtube-url-or-id [
                    title: none 
                    either url? youtube-url-or-id [
                        youtube-url: youtube-url-or-id
                    ] [
                        either not block? youtube-url-or-id [
                            id: youtube-url-or-id 
                            youtube-url: rejoin [YOUTUBE_EMBED_URL_PREFIX id]
                        ] [set [title youtube-url] normalize-url-block youtube-url-or-id]
                    ] 
                    either find youtube-url "/embed/" [
                        youtube-embed-url: youtube-url-or-id
                    ] [
                        parse youtube-url [
                            thru "v=" copy id to end
                        ] 
                        youtube-embed-url: rejoin [YOUTUBE_EMBED_URL_PREFIX id]
                    ] unless none? title [
                        emit [title]
                    ] emit [
                        {<iframe width="} YOUTUBE_WIDTH {" height="} YOUTUBE_HEIGHT {" src="} 
                        youtube-embed-url 
                        {" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>}
                    ]
                ]
            ] 
            .youtube: :emit-youtube 
            emit-link: function [url.or.title-with-url [url! file! path! block! none!] /no-bullet 
                /screen-copy
            ] [
                if none? url.or.title-with-url [
                    return false
                ] 
                url: url.or.title-with-url 
                title: url 
                if block? url.or.title-with-url [
                    url.or.title-with-url: normalize-url-block url.or.title-with-url 
                    set [title url] url.or.title-with-url
                ] 
                unless none? url.or.title-with-url [
                    either not youtube? url [
                        bullet: "" 
                        unless no-bullet [
                            bullet: "- "
                        ] 
                        emit [
                            bullet 
                            "[" title "]" 
                            "(" url 
                            ")^/                        "
                        ]
                    ] [
                        emit-youtube url
                    ]
                ]
            ] 
            .link: :emit-link 
            emit-links: function [links-collection] [foreach [title url] links-collection [
                either not block? title [
                    either ((not url? title) and (not file? title)) [url-block: reduce [title url] emit-link url-block] [
                        emit-link title 
                        emit-link url
                    ]
                ] [
                    emit-link title 
                    emit-link url
                ]
            ]] 
            .links: :emit-links
        ] 
        {^/        Article: [^/            Title: "Title of the article"^/            Sub-Title: {Sub-title of the article}^/            Paragraphs: [^/                P1: [^/                    .title: "Title for Paragraph P1"^/                    .content: {Content for Paragraph P1}^/                    .image: http://optional.image-1.jpg^/                ]^/            ]^/        ]   ^/    } 
        title: select Article 'Title 
        Sub-title: select Article 'Sub-Title 
        Paragraphs: select Article 'Paragraphs 
        if none? Paragraphs [
            Paragraphs: copy [] 
            forall Article [
                label: Article/1 value: Article/2 if block? value [
                    if set-word? label [
                        append Paragraphs label 
                        append/only Paragraphs value
                    ]
                ]
            ]
        ] 
        Paragraphs-Blocks: extract/index Paragraphs 2 2 
        message-processing 
        .title title 
        .sub-title sub-title 
        forall Paragraphs-Blocks [
            Paragraph-Content: Paragraphs-Blocks/1 forall Paragraph-Content [
                refresh-screen 
                label: Paragraph-Content/1 value: Paragraph-Content/2 if (form label) = ".title" [
                    title: value 
                    .paragraph-title title
                ] 
                if (((form label) = ".text") or ((form label) = ".content")) [
                    content: value 
                    .content content
                ] 
                if find (form label) ".code" [code-markup: "```" 
                    if find (form label) "/" [language: (pick (split (form label) "/") 2) replace language ":" "" 
                        code-markup: rejoin [code-markup language]
                    ] content: rejoin [
                        code-markup 
                        newline 
                        value 
                        newline 
                        "```"
                    ] 
                    .content content
                ] 
                if find (form label) ".quote" [content: rejoin [
                    ">" 
                    trim/head value 
                    newline
                ] 
                    .content content
                ] 
                if (form label) = ".image" [
                    image: value 
                    .image image
                ] 
                if (((form label) = ".link") or ((form label) = ".url")) [
                    url: value 
                    either find (form label) "/" [refinements: remove (split (form label) "/") forall refinements [replace/all refinements/1 ":" ""]] [.link url]
                ] 
                if (((form label) = ".links") or ((form label) = ".urls")) [
                    links-collection: value 
                    .links links-collection
                ] 
                if (form label) = ".youtube" [
                    you-tube-url-or-id: value 
                    .youtube you-tube-url-or-id
                ] 
                Paragraph-Content: next Paragraph-Content
            ]
        ] 
        print (it: .to-full-path =>output-file) return it
    ] 
    markdown-gen: :.markdown-gen 
    .html-gen: function [
        /input <=input-file 
        /output =>output-file [file! url! string! unset!] /out =>out-file [file! url! string! unset!]
    ] [condition: (not value? 'article) and (not value? 'tutorial) either (condition) [.default-input-file: %ReAdABLE.Human.Format.data.red 
        .default-output-file: %ReAdABLE.Human.Format.html 
        unless input [
            <=input-file: .default-input-file
        ] 
        if out [
            output: true 
            =>output-file: =>out-file
        ] 
        unless output [
            =>output-file: .default-output-file
        ] 
        print ["reading" <=input-file "..."] 
        do read <=input-file
    ] [] 
        if not value? 'article [
            if value? 'Tutorial [
                System/words/Article: Tutorial
            ]
        ] 
        either output [
            =>output-file: .to-file =>output-file
        ] [
            =>output-file: .to-file reduce [short-filename ".html"]
        ] 
        if exists? =>output-file [
            delete =>output-file 
            print ["deleting..." =>output-file]
        ] use ["global .emit you don't need to touch"] [
            spec: spec-of :.emit 
            body: body-of :.emit 
            bind body '=>output-file 
            emit: function spec body
        ] 
        use ["alert messages you can customize"] [
            message-processing: function [] [.do-events/no-wait 
                print "processing..." 
                .do-events/no-wait
            ] 
            refresh-screen: function [] [.do-events/no-wait]
        ] 
        use ["generic formatting functions you can customize"] [
            emit-title-level: function [.title .title-level] [title: .title 
                n: .title-level 
                title: .replace/all title "    " "" 
                marker-start: rejoin ["<H" n ">"] 
                marker-finish: rejoin ["</H" n ">"] 
                emit [newline marker-start title marker-finish newline]
            ] emit-title: function [.title] [unless none? .title [
                emit-title-level .title 1
            ]] 
            .title: :emit-title 
            emit-sub-title: function [.title] [unless none? .title [
                emit-title-level .title 2
            ]] 
            .sub-title: :emit-sub-title 
            emit-paragraph-title: function [.title] [unless ((none? .title) or (.title = "")) [
                emit-title-level .title 3
            ]] 
            .paragraph-title: :emit-paragraph-title 
            emit-paragraph-sub-title: function [.title] [unless ((none? .title) or (.title = "")) [
                emit-title-level .title 4
            ]] 
            .paragraph-sub-title: :emit-paragraph-sub-title 
            emit-image: function [image] [if find image "https://imgur.com" [
                if not find image ".png" [
                    image: rejoin [image ".png"]
                ]
            ] 
                unless none? image [
                    emit [
                        "<a href='" image "'>" "<img src='" image "' width='100%' height='100%'>" "</a>"
                    ]
                ]
            ] 
            .image: :emit-image 
            emit-content: function [content] [rule: [
                any [
                    to "```" start: thru "```" finish: (change/part start "<pre class='code-listing'>" finish) to "```" start: thru "```" finish: (change/part start "</pre>" finish)
                ]
            ] parse content rule 
                content: rejoin ["<p>" content "</p>"] 
                emit content
            ] 
            .content: :emit-content 
            youtube?: function [url] [either block? url [
                foreach element url [
                    try [
                        if find element "youtube.com" [
                            return true
                        ]
                    ]
                ]
            ] [
                if find url "youtube.com" [
                    return true
                ]
            ] 
                return false
            ] 
            normalize-url-block: function [title-with-url] [first-item: title-with-url/1 either url? first-item [
                title: title-with-url/2 url: title-with-url/1
            ] [title: title-with-url/1 url: title-with-url/2 if issue? url [
                url: rejoin [(to-string url) (mold title-with-url/3)]
            ]] return reduce [title url]] emit-youtube: function [youtube-url-or-id [url! string! word! block!]] [YOUTUBE_WIDTH: 560 
                YOUTUBE_HEIGHT: 315 
                YOUTUBE_EMBED_URL_PREFIX: https://www.youtube.com/embed/ 
                unless none? youtube-url-or-id [
                    title: none 
                    either url? youtube-url-or-id [
                        youtube-url: youtube-url-or-id
                    ] [
                        either not block? youtube-url-or-id [
                            id: youtube-url-or-id 
                            youtube-url: rejoin [YOUTUBE_EMBED_URL_PREFIX id]
                        ] [set [title youtube-url] normalize-url-block youtube-url-or-id]
                    ] 
                    either find youtube-url "/embed/" [
                        youtube-embed-url: youtube-url-or-id
                    ] [
                        parse youtube-url [
                            thru "v=" copy id to end
                        ] 
                        youtube-embed-url: rejoin [YOUTUBE_EMBED_URL_PREFIX id]
                    ] unless none? title [
                        emit [title]
                    ] emit [
                        {<iframe width="} YOUTUBE_WIDTH {" height="} YOUTUBE_HEIGHT {" src="} 
                        youtube-embed-url 
                        {" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>}
                    ]
                ]
            ] 
            .youtube: :emit-youtube 
            emit-link: function [url.or.title-with-url [url! file! path! block! none!] /no-bullet 
                /screen-copy
            ] [
                if none? url.or.title-with-url [
                    return false
                ] 
                url: url.or.title-with-url 
                title: url 
                if block? url.or.title-with-url [
                    url.or.title-with-url: normalize-url-block url.or.title-with-url 
                    set [title url] url.or.title-with-url
                ] 
                unless none? url.or.title-with-url [
                    either not youtube? url [
                        bullet: "" 
                        unless no-bullet [
                            bullet: "- "
                        ] 
                        emit [
                            "<a href='" url "'>" title "</a>"
                        ]
                    ] [
                        emit-youtube url
                    ]
                ]
            ] 
            .link: :emit-link 
            emit-links: function [links-collection] [foreach [title url] links-collection [
                either not block? title [
                    either ((not url? title) and (not file? title)) [url-block: reduce [title url] emit-link url-block] [
                        emit-link title 
                        emit-link url
                    ]
                ] [
                    emit-link title 
                    emit-link url
                ]
            ]] 
            .links: :emit-links
        ] 
        {^/            Article: [^/                Title: "Title of the article"^/                Sub-Title: {Sub-title of the article}^/                Paragraphs: [^/                    P1: [^/                        .title: "Title for Paragraph P1"^/                        .content: {Content for Paragraph P1}^/                        .image: http://optional.image-1.jpg^/                    ]^/                ]^/            ]   ^/        } 
        title: .select Article 'Title 
        Sub-title: .select Article 'Sub-Title 
        Paragraphs: .select Article 'Paragraphs 
        if none? Paragraphs [
            Paragraphs: copy [] 
            forall Article [
                label: Article/1 value: Article/2 if block? value [
                    if set-word? label [
                        append Paragraphs label 
                        append/only Paragraphs value
                    ]
                ]
            ]
        ] 
        Paragraphs-Blocks: extract/index Paragraphs 2 2 
        message-processing 
        .title title 
        .sub-title sub-title 
        forall Paragraphs-Blocks [
            Paragraph-Content: Paragraphs-Blocks/1 forall Paragraph-Content [
                refresh-screen 
                label: Paragraph-Content/1 value: Paragraph-Content/2 if (form label) = ".title" [
                    title: value 
                    .paragraph-title title
                ] 
                if (form label) = ".sub-title" [
                    title: value 
                    .paragraph-sub-title title
                ] 
                if (((form label) = ".text") or ((form label) = ".content")) [
                    content: value 
                    .content content
                ] 
                if find (form label) ".code" [code-markup: "```" 
                    if find (form label) "/" [language: (pick (split (form label) "/") 2) replace language ":" "" 
                        code-markup: rejoin [code-markup language]
                    ] content: rejoin [
                        code-markup 
                        newline 
                        value 
                        newline 
                        "```"
                    ] 
                    .content content
                ] 
                if find (form label) ".quote" [content: rejoin [
                    "<pre class='quote'>" 
                    trim/head value 
                    "</pre>" 
                    newline
                ] 
                    .content content
                ] 
                if (form label) = ".image" [
                    image: value 
                    .image image
                ] 
                if (((form label) = ".link") or ((form label) = ".url")) [
                    url: value 
                    either find (form label) "/" [refinements: remove (split (form label) "/") forall refinements [replace/all refinements/1 ":" ""]] [.link url]
                ] 
                if (((form label) = ".links") or ((form label) = ".urls")) [
                    links-collection: value 
                    .links links-collection
                ] 
                if (form label) = ".youtube" [
                    you-tube-url-or-id: value 
                    .youtube you-tube-url-or-id
                ] 
                Paragraph-Content: next Paragraph-Content
            ]
        ] 
        print (it: .to-full-path =>output-file) return it
    ] 
    html-gen: :.html-gen
Red [
    Title: "ReAdABLE.Human.Format" 
    Description: "ReAdABLE Human Format Library" 
    UUID: #f61f02b7-1b94-4e4d-8a3f-ef0ef12b61b7
] 
    unless value? '.cache [
        __OFFLINE_MODE__: false if value? in system/words '__OFFLINE_MODE__ [
            __OFFLINE_MODE__: get in system/words '__OFFLINE_MODE__
        ] 
        either __OFFLINE_MODE__ [
            if error? try [
                do-thru http://redlang.red/cache.red
            ] [
                print "error do cache.red from cache"
            ]
        ] [
            if error? try [
                do-thru/update http://redlang.red/cache.red
            ] [
                __OFFLINE_MODE__: true 
                if error? try [
                    do-thru http://redlang.red/cache.red
                ] [
                    print "error do cache.red from cache"
                ]
            ]
        ]
    ] 
    unless value? '.do-cache [
        .do-cache: func [param>urls] [either block? param>urls [
            forall param>urls [.do-cache (param>urls/1)]
        ] [either value? '.cache [.cache (param>urls)] [do (param>urls)]]] do-cache: :.do-cache
    ] 
    either value? '.cache [
        .cache https://redlang.red/section.red 
        .cache https://redlang.red/get-short-filename.red 
        .cache https://redlang.red/to-file.red 
        .cache https://redlang.red/use.red 
        .cache https://redlang.red/do-events.red
    ] [
        do https://redlang.red/section.red 
        do https://redlang.red/get-short-filename.red 
        do https://redlang.red/to-file.red 
        do https://redlang.red/use.red 
        do https://redlang.red/do-events.red
    ] 
    .emit: function [
        "Help:^/        ^/    " 
        param>line [char! string! block! none!] /_build "Build number for developer" 
        /silent "don't print message on console" 
        /_debug "debug mode"
    ] [
        if _debug [
            do https://redlang.red/do-trace
        ] 
        >builds: [
            0.0.0.1.1.1 "Initial Build"
        ] 
        if _build [
            unless silent [
                print >builds
            ] 
            return >builds
        ] 
        if _debug [
            do-trace 47 [
                ?? param>line
            ] %emit.1.red
        ] 
        if none? (param>line) [exit] either block? (param>line) [~line: rejoin (param>line)] [~line: (param>line)] write/lines/append =>output-file ~line
    ] 
    emit: :.emit 
    .select: function [.block-spec [block!] .selector [word! string!]] [selector: to-set-word form .selector 
        block: .block-spec 
        select block selector
    ] 
    .replace: function [
        series [series! none!] pattern 
        value 
        /all
    ] [
        if error? try [
            either all [
                replace/all series pattern value 
                return series
            ] [
                replace series pattern value 
                return series
            ]
        ] [
            return none
        ]
    ] 
    .get-full-path: function [.path [file! string! url!]] [.cases .type? '.path [
        string! url! [
            path: to-red-file to-string .path
        ]
    ] [
        path: .path
    ] 
        clean-path path
    ] 
    .to-full-path: :.get-full-path 
    .switch: function [
        {Evaluates the first block following the value found in cases} 
        value [any-type!] "The value to match" cases [block!] case [block!] "Default block to evaluate"
    ] [value: to-word value 
        switch/default value cases case
    ] 
    .cases: :.switch 
    .type?: function [
        "Returns the datatype of a value" 
        value [any-type!]
    ] [type: type?/word get/any value] 
    set to-word rejoin ["--" ">"] none 
    script-path: 
    system/options/script 
    either none? script-path [
        short-filename: "ReAdABLE.Human.Format.red"
    ] [
        short-filename: .get-short-filename/wo-extension script-path
    ] 
    if exists? %config/readable.config.red [
        do %config/readable.config.red
    ] 
    unless value? 'articles-types [
        articles-types: [
            Article 
            Tutorial 
            Memento 
            Glossary 
            Documentation 
            Doc 
            Index
        ]
    ] 
    article?: false 
    foreach article-type articles-types [
        if value? article-type [
            article?: true 
            article: get in system/words article-type 
            break
        ]
    ] 
    unless article? [
        Article: [
            Title: "Default Article to load instead"
        ]
    ] 
    .markdown-gen: function [/input <=input-file /output =>output-file [file! url! string! unset!]] [condition: (not value? 'article) and (not value? 'tutorial) either (condition) [.default-input-file: %ReAdABLE.Human.Format.data.red 
        .default-output-file: %ReAdABLE.Human.Format.html 
        unless input [
            <=input-file: .default-input-file
        ] 
        unless output [
            =>output-file: .default-output-file
        ] 
        print ["reading" <=input-file "..."] 
        do read <=input-file
    ] [] 
        if not value? 'article [
            if value? 'Tutorial [
                System/words/Article: Tutorial
            ]
        ] 
        either output [
            =>output-file: .to-file =>output-file
        ] [
            =>output-file: .to-file reduce [short-filename ".md"]
        ] 
        if exists? =>output-file [
            delete =>output-file 
            print ["deleting..." =>output-file]
        ] use ["global .emit you don't need to touch"] [
            spec: spec-of :.emit 
            body: body-of :.emit 
            bind body '=>output-file 
            emit: function spec body
        ] 
        use ["alert messages you can customize"] [
            message-processing: function [] [.do-events/no-wait 
                print "processing..." 
                .do-events/no-wait
            ] 
            refresh-screen: function [] [.do-events/no-wait]
        ] 
        use ["generic formatting functions you can customize"] [
            emit-title-level: function [.title .title-level] [title: .title 
                n: .title-level 
                title: replace/all title "    " "" 
                marker: copy "" 
                repeat i n [append marker "#"] 
                emit [newline marker " " title newline]
            ] emit-title: function [.title] [unless none? .title [
                emit-title-level .title 1
            ]] 
            .title: :emit-title 
            emit-sub-title: function [.title] [unless none? .title [
                emit-title-level .title 2
            ]] 
            .sub-title: :emit-sub-title 
            emit-paragraph-title: function [.title] [unless ((none? .title) or (.title = "")) [
                emit-title-level .title 3
            ]] 
            .paragraph-title: :emit-paragraph-title 
            emit-image: function [image] [if find image "https://imgur.com" [
                if not find image ".png" [
                    image: rejoin [image ".png"]
                ]
            ] 
                unless none? image [
                    emit [
                        "![" image "]" 
                        "(" image 
                        ")^/                    "
                    ]
                ]
            ] 
            .image: :emit-image 
            emit-content: function [content] [content-block: copy [] 
                either find content "```" [
                    use [lines flag flag_line] [lines: .read/lines content 
                        flag: false 
                        forall lines [
                            line: lines/1 i: index? lines 
                            if find line "```" [
                                .replace/all line "    " "" 
                                flag: not flag either flag [
                                    line: rejoin [newline newline line]
                                ] [append line newline 
                                    append line newline
                                ]
                            ] 
                            either flag = true [
                                .replace/all line "                " "" 
                                append line newline
                            ] [
                                .replace/all line "    " ""
                            ] 
                            append content-block line
                        ]
                    ] 
                    content: copy "" 
                    forall content-block [
                        i: index? content-block 
                        n: length? content-block 
                        append content content-block/1 unless i = n [
                            unless find content newline [
                                append content newline
                            ]
                        ]
                    ]
                ] [
                    content: .replace/all content "    " ""
                ] 
                emit content
            ] 
            .content: :emit-content 
            youtube?: function [url] [either block? url [
                foreach element url [
                    try [
                        if find element "youtube.com" [
                            return true
                        ]
                    ]
                ]
            ] [
                if find url "youtube.com" [
                    return true
                ]
            ] 
                return false
            ] 
            normalize-url-block: function [title-with-url] [first-item: title-with-url/1 either url? first-item [
                title: title-with-url/2 url: title-with-url/1
            ] [title: title-with-url/1 url: title-with-url/2 if issue? url [
                url: rejoin [(to-string url) (mold title-with-url/3)]
            ]] return reduce [title url]] emit-youtube: function [youtube-url-or-id [url! string! word! block!]] [YOUTUBE_WIDTH: 560 
                YOUTUBE_HEIGHT: 315 
                YOUTUBE_EMBED_URL_PREFIX: https://www.youtube.com/embed/ 
                unless none? youtube-url-or-id [
                    title: none 
                    either url? youtube-url-or-id [
                        youtube-url: youtube-url-or-id
                    ] [
                        either not block? youtube-url-or-id [
                            id: youtube-url-or-id 
                            youtube-url: rejoin [YOUTUBE_EMBED_URL_PREFIX id]
                        ] [set [title youtube-url] normalize-url-block youtube-url-or-id]
                    ] 
                    either find youtube-url "/embed/" [
                        youtube-embed-url: youtube-url-or-id
                    ] [
                        parse youtube-url [
                            thru "v=" copy id to end
                        ] 
                        youtube-embed-url: rejoin [YOUTUBE_EMBED_URL_PREFIX id]
                    ] unless none? title [
                        emit [title]
                    ] emit [
                        {<iframe width="} YOUTUBE_WIDTH {" height="} YOUTUBE_HEIGHT {" src="} 
                        youtube-embed-url 
                        {" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>}
                    ]
                ]
            ] 
            .youtube: :emit-youtube 
            emit-link: function [url.or.title-with-url [url! file! path! block! none!] /no-bullet 
                /screen-copy
            ] [
                if none? url.or.title-with-url [
                    return false
                ] 
                url: url.or.title-with-url 
                title: url 
                if block? url.or.title-with-url [
                    url.or.title-with-url: normalize-url-block url.or.title-with-url 
                    set [title url] url.or.title-with-url
                ] 
                unless none? url.or.title-with-url [
                    either not youtube? url [
                        bullet: "" 
                        unless no-bullet [
                            bullet: "- "
                        ] 
                        emit [
                            bullet 
                            "[" title "]" 
                            "(" url 
                            ")^/                        "
                        ]
                    ] [
                        emit-youtube url
                    ]
                ]
            ] 
            .link: :emit-link 
            emit-links: function [links-collection] [foreach [title url] links-collection [
                either not block? title [
                    either ((not url? title) and (not file? title)) [url-block: reduce [title url] emit-link url-block] [
                        emit-link title 
                        emit-link url
                    ]
                ] [
                    emit-link title 
                    emit-link url
                ]
            ]] 
            .links: :emit-links
        ] 
        {^/        Article: [^/            Title: "Title of the article"^/            Sub-Title: {Sub-title of the article}^/            Paragraphs: [^/                P1: [^/                    .title: "Title for Paragraph P1"^/                    .content: {Content for Paragraph P1}^/                    .image: http://optional.image-1.jpg^/                ]^/            ]^/        ]   ^/    } 
        title: select Article 'Title 
        Sub-title: select Article 'Sub-Title 
        Paragraphs: select Article 'Paragraphs 
        if none? Paragraphs [
            Paragraphs: copy [] 
            forall Article [
                label: Article/1 value: Article/2 if block? value [
                    if set-word? label [
                        append Paragraphs label 
                        append/only Paragraphs value
                    ]
                ]
            ]
        ] 
        Paragraphs-Blocks: extract/index Paragraphs 2 2 
        message-processing 
        .title title 
        .sub-title sub-title 
        forall Paragraphs-Blocks [
            Paragraph-Content: Paragraphs-Blocks/1 forall Paragraph-Content [
                refresh-screen 
                label: Paragraph-Content/1 value: Paragraph-Content/2 if (form label) = ".title" [
                    title: value 
                    .paragraph-title title
                ] 
                if (((form label) = ".text") or ((form label) = ".content")) [
                    content: value 
                    .content content
                ] 
                if find (form label) ".code" [code-markup: "```" 
                    if find (form label) "/" [language: (pick (split (form label) "/") 2) replace language ":" "" 
                        code-markup: rejoin [code-markup language]
                    ] content: rejoin [
                        code-markup 
                        newline 
                        value 
                        newline 
                        "```"
                    ] 
                    .content content
                ] 
                if find (form label) ".quote" [content: rejoin [
                    ">" 
                    trim/head value 
                    newline
                ] 
                    .content content
                ] 
                if (form label) = ".image" [
                    image: value 
                    .image image
                ] 
                if (((form label) = ".link") or ((form label) = ".url")) [
                    url: value 
                    either find (form label) "/" [refinements: remove (split (form label) "/") forall refinements [replace/all refinements/1 ":" ""]] [.link url]
                ] 
                if (((form label) = ".links") or ((form label) = ".urls")) [
                    links-collection: value 
                    .links links-collection
                ] 
                if (form label) = ".youtube" [
                    you-tube-url-or-id: value 
                    .youtube you-tube-url-or-id
                ] 
                Paragraph-Content: next Paragraph-Content
            ]
        ] 
        print (it: .to-full-path =>output-file) return it
    ] 
    markdown-gen: :.markdown-gen 
    .html-gen: function [
        /input <=input-file 
        /output =>output-file [file! url! string! unset!] /out =>out-file [file! url! string! unset!]
    ] [condition: (not value? 'article) and (not value? 'tutorial) either (condition) [.default-input-file: %ReAdABLE.Human.Format.data.red 
        .default-output-file: %ReAdABLE.Human.Format.html 
        unless input [
            <=input-file: .default-input-file
        ] 
        if out [
            output: true 
            =>output-file: =>out-file
        ] 
        unless output [
            =>output-file: .default-output-file
        ] 
        print ["reading" <=input-file "..."] 
        do read <=input-file
    ] [] 
        if not value? 'article [
            if value? 'Tutorial [
                System/words/Article: Tutorial
            ]
        ] 
        either output [
            =>output-file: .to-file =>output-file
        ] [
            =>output-file: .to-file reduce [short-filename ".html"]
        ] 
        if exists? =>output-file [
            delete =>output-file 
            print ["deleting..." =>output-file]
        ] use ["global .emit you don't need to touch"] [
            spec: spec-of :.emit 
            body: body-of :.emit 
            bind body '=>output-file 
            emit: function spec body
        ] 
        use ["alert messages you can customize"] [
            message-processing: function [] [.do-events/no-wait 
                print "processing..." 
                .do-events/no-wait
            ] 
            refresh-screen: function [] [.do-events/no-wait]
        ] 
        use ["generic formatting functions you can customize"] [
            emit-title-level: function [.title .title-level] [title: .title 
                n: .title-level 
                title: .replace/all title "    " "" 
                marker-start: rejoin ["<H" n ">"] 
                marker-finish: rejoin ["</H" n ">"] 
                emit [newline marker-start title marker-finish newline]
            ] emit-title: function [.title] [unless none? .title [
                emit-title-level .title 1
            ]] 
            .title: :emit-title 
            emit-sub-title: function [.title] [unless none? .title [
                emit-title-level .title 2
            ]] 
            .sub-title: :emit-sub-title 
            emit-paragraph-title: function [.title] [unless ((none? .title) or (.title = "")) [
                emit-title-level .title 3
            ]] 
            .paragraph-title: :emit-paragraph-title 
            emit-paragraph-sub-title: function [.title] [unless ((none? .title) or (.title = "")) [
                emit-title-level .title 4
            ]] 
            .paragraph-sub-title: :emit-paragraph-sub-title 
            emit-image: function [image] [if find image "https://imgur.com" [
                if not find image ".png" [
                    image: rejoin [image ".png"]
                ]
            ] 
                unless none? image [
                    emit [
                        "<a href='" image "'>" "<img src='" image "' width='100%' height='100%'>" "</a>"
                    ]
                ]
            ] 
            .image: :emit-image 
            emit-content: function [content] [rule: [
                any [
                    to "```" start: thru "```" finish: (change/part start "<pre class='code-listing'>" finish) to "```" start: thru "```" finish: (change/part start "</pre>" finish)
                ]
            ] parse content rule 
                content: rejoin ["<p>" content "</p>"] 
                emit content
            ] 
            .content: :emit-content 
            youtube?: function [url] [either block? url [
                foreach element url [
                    try [
                        if find element "youtube.com" [
                            return true
                        ]
                    ]
                ]
            ] [
                if find url "youtube.com" [
                    return true
                ]
            ] 
                return false
            ] 
            normalize-url-block: function [title-with-url] [first-item: title-with-url/1 either url? first-item [
                title: title-with-url/2 url: title-with-url/1
            ] [title: title-with-url/1 url: title-with-url/2 if issue? url [
                url: rejoin [(to-string url) (mold title-with-url/3)]
            ]] return reduce [title url]] emit-youtube: function [youtube-url-or-id [url! string! word! block!]] [YOUTUBE_WIDTH: 560 
                YOUTUBE_HEIGHT: 315 
                YOUTUBE_EMBED_URL_PREFIX: https://www.youtube.com/embed/ 
                unless none? youtube-url-or-id [
                    title: none 
                    either url? youtube-url-or-id [
                        youtube-url: youtube-url-or-id
                    ] [
                        either not block? youtube-url-or-id [
                            id: youtube-url-or-id 
                            youtube-url: rejoin [YOUTUBE_EMBED_URL_PREFIX id]
                        ] [set [title youtube-url] normalize-url-block youtube-url-or-id]
                    ] 
                    either find youtube-url "/embed/" [
                        youtube-embed-url: youtube-url-or-id
                    ] [
                        parse youtube-url [
                            thru "v=" copy id to end
                        ] 
                        youtube-embed-url: rejoin [YOUTUBE_EMBED_URL_PREFIX id]
                    ] unless none? title [
                        emit [title]
                    ] emit [
                        {<iframe width="} YOUTUBE_WIDTH {" height="} YOUTUBE_HEIGHT {" src="} 
                        youtube-embed-url 
                        {" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>}
                    ]
                ]
            ] 
            .youtube: :emit-youtube 
            emit-link: function [url.or.title-with-url [url! file! path! block! none!] /no-bullet 
                /screen-copy
            ] [
                if none? url.or.title-with-url [
                    return false
                ] 
                url: url.or.title-with-url 
                title: url 
                if block? url.or.title-with-url [
                    url.or.title-with-url: normalize-url-block url.or.title-with-url 
                    set [title url] url.or.title-with-url
                ] 
                unless none? url.or.title-with-url [
                    either not youtube? url [
                        bullet: "" 
                        unless no-bullet [
                            bullet: "- "
                        ] 
                        emit [
                            "<a href='" url "'>" title "</a>"
                        ]
                    ] [
                        emit-youtube url
                    ]
                ]
            ] 
            .link: :emit-link 
            emit-links: function [links-collection] [foreach [title url] links-collection [
                either not block? title [
                    either ((not url? title) and (not file? title)) [url-block: reduce [title url] emit-link url-block] [
                        emit-link title 
                        emit-link url
                    ]
                ] [
                    emit-link title 
                    emit-link url
                ]
            ]] 
            .links: :emit-links
        ] 
        {^/            Article: [^/                Title: "Title of the article"^/                Sub-Title: {Sub-title of the article}^/                Paragraphs: [^/                    P1: [^/                        .title: "Title for Paragraph P1"^/                        .content: {Content for Paragraph P1}^/                        .image: http://optional.image-1.jpg^/                    ]^/                ]^/            ]   ^/        } 
        title: .select Article 'Title 
        Sub-title: .select Article 'Sub-Title 
        Paragraphs: .select Article 'Paragraphs 
        if none? Paragraphs [
            Paragraphs: copy [] 
            forall Article [
                label: Article/1 value: Article/2 if block? value [
                    if set-word? label [
                        append Paragraphs label 
                        append/only Paragraphs value
                    ]
                ]
            ]
        ] 
        Paragraphs-Blocks: extract/index Paragraphs 2 2 
        message-processing 
        .title title 
        .sub-title sub-title 
        forall Paragraphs-Blocks [
            Paragraph-Content: Paragraphs-Blocks/1 forall Paragraph-Content [
                refresh-screen 
                label: Paragraph-Content/1 value: Paragraph-Content/2 if (form label) = ".title" [
                    title: value 
                    .paragraph-title title
                ] 
                if (form label) = ".sub-title" [
                    title: value 
                    .paragraph-sub-title title
                ] 
                if (((form label) = ".text") or ((form label) = ".content")) [
                    content: value 
                    .content content
                ] 
                if find (form label) ".code" [code-markup: "```" 
                    if find (form label) "/" [language: (pick (split (form label) "/") 2) replace language ":" "" 
                        code-markup: rejoin [code-markup language]
                    ] content: rejoin [
                        code-markup 
                        newline 
                        value 
                        newline 
                        "```"
                    ] 
                    .content content
                ] 
                if find (form label) ".quote" [content: rejoin [
                    "<pre class='quote'>" 
                    trim/head value 
                    "</pre>" 
                    newline
                ] 
                    .content content
                ] 
                if (form label) = ".image" [
                    image: value 
                    .image image
                ] 
                if (((form label) = ".link") or ((form label) = ".url")) [
                    url: value 
                    either find (form label) "/" [refinements: remove (split (form label) "/") forall refinements [replace/all refinements/1 ":" ""]] [.link url]
                ] 
                if (((form label) = ".links") or ((form label) = ".urls")) [
                    links-collection: value 
                    .links links-collection
                ] 
                if (form label) = ".youtube" [
                    you-tube-url-or-id: value 
                    .youtube you-tube-url-or-id
                ] 
                Paragraph-Content: next Paragraph-Content
            ]
        ] 
        print (it: .to-full-path =>output-file) return it
    ] 
    html-gen: :.html-gen
Red [
    Title: "ReAdABLE.Human.Format" 
    Description: "ReAdABLE Human Format Library" 
    UUID: #f61f02b7-1b94-4e4d-8a3f-ef0ef12b61b7
] 
    unless value? '.cache [
        __OFFLINE_MODE__: false if value? in system/words '__OFFLINE_MODE__ [
            __OFFLINE_MODE__: get in system/words '__OFFLINE_MODE__
        ] 
        either __OFFLINE_MODE__ [
            if error? try [
                do-thru http://redlang.red/cache.red
            ] [
                print "error do cache.red from cache"
            ]
        ] [
            if error? try [
                do-thru/update http://redlang.red/cache.red
            ] [
                __OFFLINE_MODE__: true 
                if error? try [
                    do-thru http://redlang.red/cache.red
                ] [
                    print "error do cache.red from cache"
                ]
            ]
        ]
    ] 
    unless value? '.do-cache [
        .do-cache: func [param>urls] [either block? param>urls [
            forall param>urls [.do-cache (param>urls/1)]
        ] [either value? '.cache [.cache (param>urls)] [do (param>urls)]]] do-cache: :.do-cache
    ] 
    either value? '.cache [
        .cache https://redlang.red/section.red 
        .cache https://redlang.red/get-short-filename.red 
        .cache https://redlang.red/to-file.red 
        .cache https://redlang.red/use.red 
        .cache https://redlang.red/do-events.red
    ] [
        do https://redlang.red/section.red 
        do https://redlang.red/get-short-filename.red 
        do https://redlang.red/to-file.red 
        do https://redlang.red/use.red 
        do https://redlang.red/do-events.red
    ] 
    .emit: function [
        "Help:^/        ^/    " 
        param>line [char! string! block! none!] /_build "Build number for developer" 
        /silent "don't print message on console" 
        /_debug "debug mode"
    ] [
        if _debug [
            do https://redlang.red/do-trace
        ] 
        >builds: [
            0.0.0.1.1.1 "Initial Build"
        ] 
        if _build [
            unless silent [
                print >builds
            ] 
            return >builds
        ] 
        if _debug [
            do-trace 47 [
                ?? param>line
            ] %emit.1.red
        ] 
        if none? (param>line) [exit] either block? (param>line) [~line: rejoin (param>line)] [~line: (param>line)] write/lines/append =>output-file ~line
    ] 
    emit: :.emit 
    .select: function [.block-spec [block!] .selector [word! string!]] [selector: to-set-word form .selector 
        block: .block-spec 
        select block selector
    ] 
    .replace: function [
        series [series! none!] pattern 
        value 
        /all
    ] [
        if error? try [
            either all [
                replace/all series pattern value 
                return series
            ] [
                replace series pattern value 
                return series
            ]
        ] [
            return none
        ]
    ] 
    .get-full-path: function [.path [file! string! url!]] [.cases .type? '.path [
        string! url! [
            path: to-red-file to-string .path
        ]
    ] [
        path: .path
    ] 
        clean-path path
    ] 
    .to-full-path: :.get-full-path 
    .switch: function [
        {Evaluates the first block following the value found in cases} 
        value [any-type!] "The value to match" cases [block!] case [block!] "Default block to evaluate"
    ] [value: to-word value 
        switch/default value cases case
    ] 
    .cases: :.switch 
    .type?: function [
        "Returns the datatype of a value" 
        value [any-type!]
    ] [type: type?/word get/any value] 
    set to-word rejoin ["--" ">"] none 
    script-path: 
    system/options/script 
    either none? script-path [
        short-filename: "ReAdABLE.Human.Format.red"
    ] [
        short-filename: .get-short-filename/wo-extension script-path
    ] 
    if exists? %config/readable.config.red [
        do %config/readable.config.red
    ] 
    unless value? 'articles-types [
        articles-types: [
            Article 
            Tutorial 
            Memento 
            Glossary 
            Documentation 
            Doc 
            Index
        ]
    ] 
    article?: false 
    foreach article-type articles-types [
        if value? article-type [
            article?: true 
            article: get in system/words article-type 
            break
        ]
    ] 
    unless article? [
        Article: [
            Title: "Default Article to load instead"
        ]
    ] 
    .markdown-gen: function [/input <=input-file /output =>output-file [file! url! string! unset!]] [condition: (not value? 'article) and (not value? 'tutorial) either (condition) [.default-input-file: %ReAdABLE.Human.Format.data.red 
        .default-output-file: %ReAdABLE.Human.Format.html 
        unless input [
            <=input-file: .default-input-file
        ] 
        unless output [
            =>output-file: .default-output-file
        ] 
        print ["reading" <=input-file "..."] 
        do read <=input-file
    ] [] 
        if not value? 'article [
            if value? 'Tutorial [
                System/words/Article: Tutorial
            ]
        ] 
        either output [
            =>output-file: .to-file =>output-file
        ] [
            =>output-file: .to-file reduce [short-filename ".md"]
        ] 
        if exists? =>output-file [
            delete =>output-file 
            print ["deleting..." =>output-file]
        ] use ["global .emit you don't need to touch"] [
            spec: spec-of :.emit 
            body: body-of :.emit 
            bind body '=>output-file 
            emit: function spec body
        ] 
        use ["alert messages you can customize"] [
            message-processing: function [] [.do-events/no-wait 
                print "processing..." 
                .do-events/no-wait
            ] 
            refresh-screen: function [] [.do-events/no-wait]
        ] 
        use ["generic formatting functions you can customize"] [
            emit-title-level: function [.title .title-level] [title: .title 
                n: .title-level 
                title: replace/all title "    " "" 
                marker: copy "" 
                repeat i n [append marker "#"] 
                emit [newline marker " " title newline]
            ] emit-title: function [.title] [unless none? .title [
                emit-title-level .title 1
            ]] 
            .title: :emit-title 
            emit-sub-title: function [.title] [unless none? .title [
                emit-title-level .title 2
            ]] 
            .sub-title: :emit-sub-title 
            emit-paragraph-title: function [.title] [unless ((none? .title) or (.title = "")) [
                emit-title-level .title 3
            ]] 
            .paragraph-title: :emit-paragraph-title 
            emit-image: function [image] [if find image "https://imgur.com" [
                if not find image ".png" [
                    image: rejoin [image ".png"]
                ]
            ] 
                unless none? image [
                    emit [
                        "![" image "]" 
                        "(" image 
                        ")^/                    "
                    ]
                ]
            ] 
            .image: :emit-image 
            emit-content: function [content] [content-block: copy [] 
                either find content "```" [
                    use [lines flag flag_line] [lines: .read/lines content 
                        flag: false 
                        forall lines [
                            line: lines/1 i: index? lines 
                            if find line "```" [
                                .replace/all line "    " "" 
                                flag: not flag either flag [
                                    line: rejoin [newline newline line]
                                ] [append line newline 
                                    append line newline
                                ]
                            ] 
                            either flag = true [
                                .replace/all line "                " "" 
                                append line newline
                            ] [
                                .replace/all line "    " ""
                            ] 
                            append content-block line
                        ]
                    ] 
                    content: copy "" 
                    forall content-block [
                        i: index? content-block 
                        n: length? content-block 
                        append content content-block/1 unless i = n [
                            unless find content newline [
                                append content newline
                            ]
                        ]
                    ]
                ] [
                    content: .replace/all content "    " ""
                ] 
                emit content
            ] 
            .content: :emit-content 
            youtube?: function [url] [either block? url [
                foreach element url [
                    try [
                        if find element "youtube.com" [
                            return true
                        ]
                    ]
                ]
            ] [
                if find url "youtube.com" [
                    return true
                ]
            ] 
                return false
            ] 
            normalize-url-block: function [title-with-url] [first-item: title-with-url/1 either url? first-item [
                title: title-with-url/2 url: title-with-url/1
            ] [title: title-with-url/1 url: title-with-url/2 if issue? url [
                url: rejoin [(to-string url) (mold title-with-url/3)]
            ]] return reduce [title url]] emit-youtube: function [youtube-url-or-id [url! string! word! block!]] [YOUTUBE_WIDTH: 560 
                YOUTUBE_HEIGHT: 315 
                YOUTUBE_EMBED_URL_PREFIX: https://www.youtube.com/embed/ 
                unless none? youtube-url-or-id [
                    title: none 
                    either url? youtube-url-or-id [
                        youtube-url: youtube-url-or-id
                    ] [
                        either not block? youtube-url-or-id [
                            id: youtube-url-or-id 
                            youtube-url: rejoin [YOUTUBE_EMBED_URL_PREFIX id]
                        ] [set [title youtube-url] normalize-url-block youtube-url-or-id]
                    ] 
                    either find youtube-url "/embed/" [
                        youtube-embed-url: youtube-url-or-id
                    ] [
                        parse youtube-url [
                            thru "v=" copy id to end
                        ] 
                        youtube-embed-url: rejoin [YOUTUBE_EMBED_URL_PREFIX id]
                    ] unless none? title [
                        emit [title]
                    ] emit [
                        {<iframe width="} YOUTUBE_WIDTH {" height="} YOUTUBE_HEIGHT {" src="} 
                        youtube-embed-url 
                        {" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>}
                    ]
                ]
            ] 
            .youtube: :emit-youtube 
            emit-link: function [url.or.title-with-url [url! file! path! block! none!] /no-bullet 
                /screen-copy
            ] [
                if none? url.or.title-with-url [
                    return false
                ] 
                url: url.or.title-with-url 
                title: url 
                if block? url.or.title-with-url [
                    url.or.title-with-url: normalize-url-block url.or.title-with-url 
                    set [title url] url.or.title-with-url
                ] 
                unless none? url.or.title-with-url [
                    either not youtube? url [
                        bullet: "" 
                        unless no-bullet [
                            bullet: "- "
                        ] 
                        emit [
                            bullet 
                            "[" title "]" 
                            "(" url 
                            ")^/                        "
                        ]
                    ] [
                        emit-youtube url
                    ]
                ]
            ] 
            .link: :emit-link 
            emit-links: function [links-collection] [foreach [title url] links-collection [
                either not block? title [
                    either ((not url? title) and (not file? title)) [url-block: reduce [title url] emit-link url-block] [
                        emit-link title 
                        emit-link url
                    ]
                ] [
                    emit-link title 
                    emit-link url
                ]
            ]] 
            .links: :emit-links
        ] 
        {^/        Article: [^/            Title: "Title of the article"^/            Sub-Title: {Sub-title of the article}^/            Paragraphs: [^/                P1: [^/                    .title: "Title for Paragraph P1"^/                    .content: {Content for Paragraph P1}^/                    .image: http://optional.image-1.jpg^/                ]^/            ]^/        ]   ^/    } 
        title: select Article 'Title 
        Sub-title: select Article 'Sub-Title 
        Paragraphs: select Article 'Paragraphs 
        if none? Paragraphs [
            Paragraphs: copy [] 
            forall Article [
                label: Article/1 value: Article/2 if block? value [
                    if set-word? label [
                        append Paragraphs label 
                        append/only Paragraphs value
                    ]
                ]
            ]
        ] 
        Paragraphs-Blocks: extract/index Paragraphs 2 2 
        message-processing 
        .title title 
        .sub-title sub-title 
        forall Paragraphs-Blocks [
            Paragraph-Content: Paragraphs-Blocks/1 forall Paragraph-Content [
                refresh-screen 
                label: Paragraph-Content/1 value: Paragraph-Content/2 if (form label) = ".title" [
                    title: value 
                    .paragraph-title title
                ] 
                if (((form label) = ".text") or ((form label) = ".content")) [
                    content: value 
                    .content content
                ] 
                if find (form label) ".code" [code-markup: "```" 
                    if find (form label) "/" [language: (pick (split (form label) "/") 2) replace language ":" "" 
                        code-markup: rejoin [code-markup language]
                    ] content: rejoin [
                        code-markup 
                        newline 
                        value 
                        newline 
                        "```"
                    ] 
                    .content content
                ] 
                if find (form label) ".quote" [content: rejoin [
                    ">" 
                    trim/head value 
                    newline
                ] 
                    .content content
                ] 
                if (form label) = ".image" [
                    image: value 
                    .image image
                ] 
                if (((form label) = ".link") or ((form label) = ".url")) [
                    url: value 
                    either find (form label) "/" [refinements: remove (split (form label) "/") forall refinements [replace/all refinements/1 ":" ""]] [.link url]
                ] 
                if (((form label) = ".links") or ((form label) = ".urls")) [
                    links-collection: value 
                    .links links-collection
                ] 
                if (form label) = ".youtube" [
                    you-tube-url-or-id: value 
                    .youtube you-tube-url-or-id
                ] 
                Paragraph-Content: next Paragraph-Content
            ]
        ] 
        print (it: .to-full-path =>output-file) return it
    ] 
    markdown-gen: :.markdown-gen 
    .html-gen: function [
        /input <=input-file 
        /output =>output-file [file! url! string! unset!] /out =>out-file [file! url! string! unset!]
    ] [condition: (not value? 'article) and (not value? 'tutorial) either (condition) [.default-input-file: %ReAdABLE.Human.Format.data.red 
        .default-output-file: %ReAdABLE.Human.Format.html 
        unless input [
            <=input-file: .default-input-file
        ] 
        if out [
            output: true 
            =>output-file: =>out-file
        ] 
        unless output [
            =>output-file: .default-output-file
        ] 
        print ["reading" <=input-file "..."] 
        do read <=input-file
    ] [] 
        if not value? 'article [
            if value? 'Tutorial [
                System/words/Article: Tutorial
            ]
        ] 
        either output [
            =>output-file: .to-file =>output-file
        ] [
            =>output-file: .to-file reduce [short-filename ".html"]
        ] 
        if exists? =>output-file [
            delete =>output-file 
            print ["deleting..." =>output-file]
        ] use ["global .emit you don't need to touch"] [
            spec: spec-of :.emit 
            body: body-of :.emit 
            bind body '=>output-file 
            emit: function spec body
        ] 
        use ["alert messages you can customize"] [
            message-processing: function [] [.do-events/no-wait 
                print "processing..." 
                .do-events/no-wait
            ] 
            refresh-screen: function [] [.do-events/no-wait]
        ] 
        use ["generic formatting functions you can customize"] [
            emit-title-level: function [.title .title-level] [title: .title 
                n: .title-level 
                title: .replace/all title "    " "" 
                marker-start: rejoin ["<H" n ">"] 
                marker-finish: rejoin ["</H" n ">"] 
                emit [newline marker-start title marker-finish newline]
            ] emit-title: function [.title] [unless none? .title [
                emit-title-level .title 1
            ]] 
            .title: :emit-title 
            emit-sub-title: function [.title] [unless none? .title [
                emit-title-level .title 2
            ]] 
            .sub-title: :emit-sub-title 
            emit-paragraph-title: function [.title] [unless ((none? .title) or (.title = "")) [
                emit-title-level .title 3
            ]] 
            .paragraph-title: :emit-paragraph-title 
            emit-paragraph-sub-title: function [.title] [unless ((none? .title) or (.title = "")) [
                emit-title-level .title 4
            ]] 
            .paragraph-sub-title: :emit-paragraph-sub-title 
            emit-image: function [image] [if find image "https://imgur.com" [
                if not find image ".png" [
                    image: rejoin [image ".png"]
                ]
            ] 
                unless none? image [
                    emit [
                        "<a href='" image "'>" "<img src='" image "' width='100%' height='100%'>" "</a>"
                    ]
                ]
            ] 
            .image: :emit-image 
            emit-content: function [content] [rule: [
                any [
                    to "```" start: thru "```" finish: (change/part start "<pre class='code-listing'>" finish) to "```" start: thru "```" finish: (change/part start "</pre>" finish)
                ]
            ] parse content rule 
                content: rejoin ["<p>" content "</p>"] 
                emit content
            ] 
            .content: :emit-content 
            youtube?: function [url] [either block? url [
                foreach element url [
                    try [
                        if find element "youtube.com" [
                            return true
                        ]
                    ]
                ]
            ] [
                if find url "youtube.com" [
                    return true
                ]
            ] 
                return false
            ] 
            normalize-url-block: function [title-with-url] [first-item: title-with-url/1 either url? first-item [
                title: title-with-url/2 url: title-with-url/1
            ] [title: title-with-url/1 url: title-with-url/2 if issue? url [
                url: rejoin [(to-string url) (mold title-with-url/3)]
            ]] return reduce [title url]] emit-youtube: function [youtube-url-or-id [url! string! word! block!]] [YOUTUBE_WIDTH: 560 
                YOUTUBE_HEIGHT: 315 
                YOUTUBE_EMBED_URL_PREFIX: https://www.youtube.com/embed/ 
                unless none? youtube-url-or-id [
                    title: none 
                    either url? youtube-url-or-id [
                        youtube-url: youtube-url-or-id
                    ] [
                        either not block? youtube-url-or-id [
                            id: youtube-url-or-id 
                            youtube-url: rejoin [YOUTUBE_EMBED_URL_PREFIX id]
                        ] [set [title youtube-url] normalize-url-block youtube-url-or-id]
                    ] 
                    either find youtube-url "/embed/" [
                        youtube-embed-url: youtube-url-or-id
                    ] [
                        parse youtube-url [
                            thru "v=" copy id to end
                        ] 
                        youtube-embed-url: rejoin [YOUTUBE_EMBED_URL_PREFIX id]
                    ] unless none? title [
                        emit [title]
                    ] emit [
                        {<iframe width="} YOUTUBE_WIDTH {" height="} YOUTUBE_HEIGHT {" src="} 
                        youtube-embed-url 
                        {" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>}
                    ]
                ]
            ] 
            .youtube: :emit-youtube 
            emit-link: function [url.or.title-with-url [url! file! path! block! none!] /no-bullet 
                /screen-copy
            ] [
                if none? url.or.title-with-url [
                    return false
                ] 
                url: url.or.title-with-url 
                title: url 
                if block? url.or.title-with-url [
                    url.or.title-with-url: normalize-url-block url.or.title-with-url 
                    set [title url] url.or.title-with-url
                ] 
                unless none? url.or.title-with-url [
                    either not youtube? url [
                        bullet: "" 
                        unless no-bullet [
                            bullet: "- "
                        ] 
                        emit [
                            "<a href='" url "'>" title "</a>"
                        ]
                    ] [
                        emit-youtube url
                    ]
                ]
            ] 
            .link: :emit-link 
            emit-links: function [links-collection] [foreach [title url] links-collection [
                either not block? title [
                    either ((not url? title) and (not file? title)) [url-block: reduce [title url] emit-link url-block] [
                        emit-link title 
                        emit-link url
                    ]
                ] [
                    emit-link title 
                    emit-link url
                ]
            ]] 
            .links: :emit-links
        ] 
        {^/            Article: [^/                Title: "Title of the article"^/                Sub-Title: {Sub-title of the article}^/                Paragraphs: [^/                    P1: [^/                        .title: "Title for Paragraph P1"^/                        .content: {Content for Paragraph P1}^/                        .image: http://optional.image-1.jpg^/                    ]^/                ]^/            ]   ^/        } 
        title: .select Article 'Title 
        Sub-title: .select Article 'Sub-Title 
        Paragraphs: .select Article 'Paragraphs 
        if none? Paragraphs [
            Paragraphs: copy [] 
            forall Article [
                label: Article/1 value: Article/2 if block? value [
                    if set-word? label [
                        append Paragraphs label 
                        append/only Paragraphs value
                    ]
                ]
            ]
        ] 
        Paragraphs-Blocks: extract/index Paragraphs 2 2 
        message-processing 
        .title title 
        .sub-title sub-title 
        forall Paragraphs-Blocks [
            Paragraph-Content: Paragraphs-Blocks/1 forall Paragraph-Content [
                refresh-screen 
                label: Paragraph-Content/1 value: Paragraph-Content/2 if (form label) = ".title" [
                    title: value 
                    .paragraph-title title
                ] 
                if (form label) = ".sub-title" [
                    title: value 
                    .paragraph-sub-title title
                ] 
                if (((form label) = ".text") or ((form label) = ".content")) [
                    content: value 
                    .content content
                ] 
                if find (form label) ".code" [code-markup: "```" 
                    if find (form label) "/" [language: (pick (split (form label) "/") 2) replace language ":" "" 
                        code-markup: rejoin [code-markup language]
                    ] content: rejoin [
                        code-markup 
                        newline 
                        value 
                        newline 
                        "```"
                    ] 
                    .content content
                ] 
                if find (form label) ".quote" [content: rejoin [
                    "<pre class='quote'>" 
                    trim/head value 
                    "</pre>" 
                    newline
                ] 
                    .content content
                ] 
                if (form label) = ".image" [
                    image: value 
                    .image image
                ] 
                if (((form label) = ".link") or ((form label) = ".url")) [
                    url: value 
                    either find (form label) "/" [refinements: remove (split (form label) "/") forall refinements [replace/all refinements/1 ":" ""]] [.link url]
                ] 
                if (((form label) = ".links") or ((form label) = ".urls")) [
                    links-collection: value 
                    .links links-collection
                ] 
                if (form label) = ".youtube" [
                    you-tube-url-or-id: value 
                    .youtube you-tube-url-or-id
                ] 
                Paragraph-Content: next Paragraph-Content
            ]
        ] 
        print (it: .to-full-path =>output-file) return it
    ] 
    html-gen: :.html-gen
