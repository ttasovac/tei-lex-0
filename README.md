# TEI Lex-0

Repository for the separate TEI Lex-0 Schema and Guidelines (test version).

## Structure

tei-lex-0/
├── README.md
├── LICENSE
├── CITATION.cff               #  See <https://citation-file-format.github.io/>
├── CHANGELOG.md

├── odd/
|   ├── examples/
|   ├── parts/
│   └── TEILex-0.odd            # Uses includes from parts

├── assets/
│   ├── css/
│   └── js/

├── build/                      # .gitignored
│   ├── rng/                    # GENERATED
│   ├── xsd/                    # GENERATED
│   ├── html/                   # GENERATED Guidelines
│   └── odd/                    # Copy of resolved ODD

├── tools/
│   ├── Makefile
│   ├── odd2rng.xsl             # wrapper (optional)
│   └── version.xsl             # inject version metadata

├── .github/
│   └── workflows/
│       └── build-and-publish.yml

gh-pages/
├── index.html
├── latest/
│   ├── index.html              # multiple pages output... 2 figure out
│   ├── tei-lex-0.rng
│   └── tei-lex-0.sch
├── v1.0.0/
│   ├── index.html
│   ├── tei-lex-0.rng
│   └── tei-lex-0.sch
└── v1.1.0/

├── .gitignore
└── .editorconfig
