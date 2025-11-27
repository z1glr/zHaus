#import "../zHaus.typ": zHaus

#show: zHaus.with(
    title: "This is the title",
    subtitle: "and the subtitle",
    author: ("z1glr", "me"),
    date: "2025-11-26",
    tags: ("zHaus", "example"),
    abstract: none, // string
    // watermark: "DRAFT",

    table-caption-position: top,
    figure-caption-position: bottom,

    // papersize: "a4",
    // fonts: (
    //     heading: "Lexend",
    //     text: "Vollkorn",
    // ),

    keywords: ("template", "zHaus"),

    // page-numbering: "1",
    // margin: auto,
    // cols: 1,
    // lang: "de",
    // region: "de",
    // fontsize: 12pt,
    // colorlinks: true,
    // section-numbering: "1.1.1",
    // titlepage: true,
    // toc: true,
    // toc-own-page: true,
    // toc-depth: 3,
)

= Example
#lorem(20)
