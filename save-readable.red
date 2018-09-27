Red [
    Title: ""
]

if not value? '.redlang [
    do https://redlang.red
]
.redlang [read remove-last]


save-readable: function [>block >file][

    out: copy ""

    ;do https://redlang.red/read
    lines: .read/lines mold >block
    lines: skip lines 1
    ;do https://redlang.red/remove-last
    remove-last lines

    forall lines [
        line: lines/1
        parse line [thru "    " copy line to end]
        append out line
        append out newline
    ]
    write >file out

]