
#let horizontalrule = block(spacing: 4em)[#line(start: (10%, 0%), end: (90%, 0%), stroke: 0.5pt)]

#let zHaus(
    title: none, // string
    subtitle: none, // string
    author: none, // array[string]
    date: none, // string
    tags: none, // array[string]
    abstract: none, // string
    table-caption-position: none, // alignment
    figure-caption-position: none, // alignment
    keywords: none, // array[string]
    fonts: none, // dict: (heading: string, text: string)
    watermark: none, // string
    papersize: none, // string
    page-numbering: none, // string
    margin: auto, // page margins
    cols: none, // integer
    lang: none, // string
    region: none, // string
    fontsize: none, // size
    colorlinks: none, // boolean
    section-numbering: none,
    titlepage: none, // boolean
    toc: none, // boolean
    toc-own-page: none, // boolean
    toc-depth: none, // integer
    body,
) = {
    import "@preview/codly:1.3.0": *
    import "@preview/codly-languages:0.1.1": *
    import "@preview/luzid-checkbox:0.1.0": luzid

    import "@preview/valkyrie:0.2.2" as z

    // parse all the parameters
    title = z.parse(title, z.content(optional: true))
    subtitle = z.parse(subtitle, z.content(optional: true))
    author = z.parse(author, z.array(z.string()))
    date = z.parse(date, z.string(optional: true))
    tags = z.parse(tags, z.array(z.either(z.string(), z.content())))
    abstract = z.parse(abstract, z.string(optional: true))
    table-caption-position = z.parse(table-caption-position, z.alignment(default: top))
    figure-caption-position = z.parse(figure-caption-position, z.alignment(default: bottom))
    keywords = z.parse(keywords, z.array(z.string()))
    fonts = z.parse(fonts, z.dictionary((heading: z.string(default: "Lexend"), text: z.string(default: "Vollkorn"))))
    watermark = z.parse(watermark, z.string(optional: true))
    papersize = z.parse(papersize, z.schemas.papersize(default: "a4"))
    page-numbering = z.parse(page-numbering, z.string(default: "1"))
    cols = z.parse(cols, z.integer(default: 1))
    lang = z.parse(lang, z.string(default: "de"))
    region = z.parse(region, z.string(default: "de"))
    fontsize = z.parse(fontsize, z.length(default: 12pt))
    colorlinks = z.parse(colorlinks, z.boolean(default: true))
    section-numbering = z.parse(section-numbering, z.string(optional: true))
    titlepage = z.parse(titlepage, z.boolean(default: false))
    toc = z.parse(toc, z.boolean(default: false))
    toc-own-page = z.parse(toc-own-page, z.boolean(default: false))
    toc-depth = z.parse(toc-depth, z.integer(default: 3))


    // helper function from pandoc (https://github.com/jgm/pandoc/blob/fe62b25f4926e2d11e3c3cbfe085086766611783/data/templates/template.typst#L1-L11)
    let content-to-string(content) = {
        if content.has("text") {
            content.text
        } else if content.has("children") {
            content.children.map(content-to-string).join("")
        } else if content.has("body") {
            content-to-string(content.body)
        } else if content == [ ] {
            " "
        }
    }

    // get the average scaleing for the actual page dimension
    let page-size-scale(page) = (page.height / 297mm + page.width / 210mm) / 2

    // definitions
    show terms: it => {
        it
            .children
            .map(child => [
                #strong[#child.term]
                #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
            ])
            .join()
    }

    // tables without stroke
    set table(
        inset: 6pt,
        stroke: none,
    )

    // table caption position
    show figure.where(
        kind: table,
    ): set figure.caption(position: table-caption-position)

    // image caption position
    show figure.where(
        kind: image,
    ): set figure.caption(position: figure-caption-position)

    // localized quotes
    set smartquote(enabled: true)

    // set document metadata
    set document(
        title: title,
        date: datetime.today(),
        author: if author != none { author } else { none },
        keywords: if keywords != none { keywords } else { none },
    )

    // Text defaults
    set text(
        lang: lang,
        region: region,
        font: fonts.text,
        size: fontsize,

        spacing: 90%,
    )

    // setup the page
    set page(
        paper: papersize,

        numbering: page-numbering,

        margin: margin,

        columns: cols,

        // render the watermark
        foreground: if watermark != none {
            context (
                rotate(-calc.atan(page.height / page.width))[
                    #set text(font: fonts.heading, size: 120pt * page-size-scale(page), fill: black.transparentize(80%))
                    *#watermark*
                ]
            )
        },

        // header
        header-ascent: 25% + 0pt,
        header: context {
            title
            h(1fr)
            date
            line(length: 100%, stroke: 0.5pt)
        },

        // footer
        footer-descent: 30% + 0pt,
        footer: context {
            line(length: 100%, stroke: 0.5pt)

            if author != none {
                author.join(", ")
            }
            h(1fr)
            counter(page).display(page-numbering)
        },
    )

    // Block quotations
    show quote: set text(luma(119))
    set quote(quotes: false)
    show quote: body => {
        box(stroke: (left: 3pt + luma(221)))[
            #v(0.5em)
            #pad(left: 0.5em, body)
            #v(0.5em)
        ]
    }

    // unnumbered lists
    show list: set block(spacing: 2em)
    set list(marker: ([•], "–", "*"), indent: 1em)

    // numbered lists
    show enum: set block(spacing: 2em)
    set enum(indent: 1em)

    // colorlinks
    show link: set text(fill: rgb("#4077c0"))

    // images
    set image(fit: "contain")
    show image: it => {
        align(center, it)
    }

    // figures
    set figure(
        gap: 1em,
        placement: none,
    )
    show figure.caption: set text(size: 9pt) // how to set space below?
    show figure: set block(below: 1.5em)

    show figure.caption: it => context [
        #set align(left)
        #set par(justify: true)
        *#it.supplement~#it.counter.display()#it.separator*#text(fill: luma(119))[#it.body]
    ]

    // Footnote formatting
    show footnote: set text(fill: rgb("#a50000"))

    set footnote.entry(indent: 1em)
    show footnote.entry: set par(spacing: 0.5em, justify: false, first-line-indent: 3em)
    show footnote.entry: set text(size: 8pt, weight: 200)

    // HEADINGS
    show heading: set text(font: fonts.heading)
    show heading: set block(below: 2em)
    set heading(numbering: section-numbering)

    // STYLING LABELLED SECTIONS
    show <epigraph>: set text(rgb("#777"))
    show <epigraph>: set par(justify: false)

    show <refs>: set par(
        justify: false,
        spacing: 16pt,
        first-line-indent: 0em,
        hanging-indent: 2em,
        leading: 8pt,
    )

    set par(justify: true)

    let palette = (
        red: rgb("#f54f4f"),
        yellow: rgb("#ffd04c"),
        orange: rgb("#F98F4D"),
        blue: rgb("#1c7ad1"),
        teal: rgb("#127386"),
        sapphire: rgb("#1f9fb4"),
        green: rgb("#0a6b3d"),
        wine: rgb("#BE596F"),
        lavender: rgb("#88648F"),
        background: rgb("#fef5e6"),
        gray: rgb("#787878"),
        white: white,
    )

    if titlepage {
        context [
            // get the colors from the palette
            #let color1 = palette.red
            #let color2 = palette.yellow
            #let color3 = palette.blue
            #let color4 = palette.green
            #let background = palette.background
            #let border = palette.white

            #let height = page.height
            #let width = page.width

            #let margin = 5mm

            #set text(size: 1em * page-size-scale(page))

            // setup the page independent of the others
            #set page(
                background: rect(width: 100%, height: 100%, fill: background, stroke: none),
                header: none,
                footer: none,
                margin: 0pt,
                columns: 1,
            )

            // draw a quarter circle by masking a full one
            #let arc(radius: 20mm, pos: 0, color: white) = {
                place(
                    dy: -radius,
                    dx: -radius,
                    box(
                        width: 2 * radius,
                        height: 2 * radius,
                        radius: 50%,
                        stroke: none,
                        clip: true,
                        scale(
                            y: -100% * (2 * calc.trunc(pos / 2) - 1),
                            x: -100% * (2 * calc.trunc(calc.rem(pos + 1, 4) / 2) - 1),
                            origin: bottom + right,
                            polygon(
                                fill: color,
                                stroke: none,
                                (0%, 0%),
                                (50%, 0%),
                                (50%, 50%),
                                (0%, 50%),
                            ),
                        ),
                    ),
                )
            }

            // draw a circle
            #let circ(radius: 20mm, color: white) = {
                place(
                    dx: -radius,
                    dy: -radius,
                    circle(radius: radius, fill: color),
                )
            }

            // top-left arc
            #place(
                dx: 0mm,
                dy: 0mm,
                arc(radius: height / 2, pos: 2, color: color1),
            )

            // bottom-left arc
            #place(
                dx: width / 2,
                dy: height / 2,
                arc(radius: height / 2, pos: 3, color: color3),
            )

            // bottom-right arc
            #place(
                dx: width / 2,
                dy: height / 2,
                arc(radius: width / 2, pos: 2, color: color4),
            )

            // middle arc
            #place(
                dx: width / 2,
                dy: height / 2,
                arc(radius: (1 - calc.sin(45deg)) * height / 2, pos: 1, color: color2),
            )

            // top-right circle
            #place(
                dx: 13 / 16 * width,
                dy: height / 4,
                circ(radius: height / 16, color: color3),
            )

            // bottom-circle
            #place(
                dx: 19 / 32 * width,
                dy: 29 / 32 * height,
                circ(radius: height / 32, color: color1),
            )

            // border
            #place(
                dx: margin,
                dy: margin,
                rect(
                    width: 100% - 2 * margin,
                    height: 100% - 2 * margin,
                    stroke: 2pt + border,
                ),
            )

            // title and subtitle
            #place(
                dx: 2 * margin,
                dy: 4 * margin,
            )[
                #block(width: height / 2 - 8 * margin)[
                    #set par(spacing: 0.5em, justify: false)

                    #if title != none {
                        [
                            #set text(font: fonts.heading, size: 3em, weight: "black")
                            #title
                        ]
                    }

                    #if subtitle != none {
                        [
                            #set text(weight: "light", fill: white, size: 2em)
                            #emph[#subtitle]
                        ]
                    }
                ]
            ]

            // authors and date
            #place(
                dx: 2 * margin,
                dy: 2 * margin + height / 2,
            )[
                #block(width: width / 2 - 3 * margin)[
                    #set par(spacing: 0.5em)
                    #set text(font: fonts.text, fill: white, size: 1.5em)
                    #align(
                        right,
                        {
                            author.join(", ")

                            if date != none {
                                v(0.5em)
                                set text(size: 0.8em)

                                date
                            }
                        },
                    )
                ]
            ]

            // tags
            #if tags != none {
                place(
                    dx: 11 / 16 * width,
                    dy: 7 / 8 * height,
                )[
                    #block(width: width - 11 / 16 * width - 2 * margin, height: height / 16)[
                        #set text(font: fonts.text, size: 2em)
                        #v(1fr)
                        #align(right, tags.map(tag => "#" + tag).join(h(0.5em)))
                        #v(1fr)
                    ]
                ]
            }

            // abstract
            #if abstract != none {
                place(
                    dx: width / 2,
                    dy: height / 2,
                )[
                    #block(width: width / 2 - margin)[
                        #pad(x: margin, top: 2 * margin, {
                            set par(spacing: 0.5em)
                            set text(fill: silver, style: "italic", font: fonts.text, size: 1.5em)

                            abstract
                        })
                    ]
                ]
            }

            #pagebreak()
        ]
    }

    // table of content
    if toc {
        set page(columns: 1)

        outline(
            title: auto,
            depth: toc-depth,
        )

        if toc-own-page {
            pagebreak()
        }
    }

    // syntax highlighting
    show: codly-init.with()
    codly(
        zebra-fill: none,
        stroke: 0.5pt + luma(179),
        display-icon: false,
        radius: 0pt,
        inset: (x: 1em),
        fill: luma(247),
    )

    // alternative checkboxes
    show: luzid.with(color-map: (
        task: palette.gray,
        done: palette.green,
        rescheduled: palette.sapphire,
        scheduled: palette.teal,
        important: palette.yellow,
        cancelled: palette.red,
        cancelled-stroke: palette.gray,
        progress: palette.green,
        question: palette.orange,
        star: palette.yellow,
        note: palette.wine,
        location: palette.lavender,
        information: palette.blue,
        idea: palette.yellow,
        amount: palette.green,
        pro: palette.green,
        contra: palette.red,
        bookmark: palette.red,
        quote: palette.gray,
        up: palette.green,
        down: palette.red,
        win: palette.lavender,
        key: palette.yellow,
        fire: palette.red,
    ))

    body
}
