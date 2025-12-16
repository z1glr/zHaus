#import "../zHaus.typ": zHaus

#show: zHaus.with(
  title: "foo",
  subtitle: "bar",

  author: ("z1glr",),
  date:  "2025-12-16",

    tags: ("template",), // array[string]
    abstract: "abstract", // string

    // keywords: ("key",), // array[string]

    watermark: "DRAFT", // string

    lang: "de", // string
    region: "de", // string

    // papersize: "us-letter", // string
    // page-numbering: none, // string
    // margin: auto, // page margins
    // cols: none, // integer
  //
    // colorlinks: none, // boolean
    // section-numbering: none,
    // titlepage: none, // boolean
    // toc: none, // boolean
    // toc-own-page: none, // boolean
    // toc-depth: none, // integer
    //

  titlepage: true,
)


