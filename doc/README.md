The Stdlib documentation
========================

The Stdlib documentation includes

- A Reference Manual
- A document presenting the standard library

The documentation of the latest released version is available on the Rocq
web site at [rocq-prover.org/docs](https://rocq-prover.org/docs).

Additionally, you can view the reference manual for the development version
at <https://coq.github.io/doc/master/refman/>, and the documentation of the
standard library for the development version at
<https://coq.github.io/doc/master/stdlib/>.

The reference manual is written is reStructuredText and compiled
using Sphinx. See [`sphinx/README.rst`](sphinx/README.rst)
to learn more about the format that is used.

The documentation for the standard library is generated from
the `.v` source files using coqdoc.

Dependencies
------------

### HTML documentation

If you have Nix installed, then the easiest way to get all the dependencies to
build the refman is to run:

    nix-shell --argstr job stdlib-refman-html

Otherwise, you need to install (in another way) Python 3, and the following Python packages:

  - sphinx >= 4.5.0
  - sphinx_rtd_theme >= 1.0.0
  - beautifulsoup4 >= 4.8.2
  - antlr4-python3-runtime >= 4.7.1 & <= 4.9.3
  - pexpect >= 4.6.0
  - sphinxcontrib-bibtex >= 0.4.2

For instance, on Debian / Ubuntu, you can install pip and setuptools
with `apt install python3-pip python3-setuptools` on Debian / Ubuntu then run:

    pip3 install sphinx sphinx_rtd_theme beautifulsoup4 \
                 antlr4-python3-runtime==4.7.1 pexpect sphinxcontrib-bibtex

You can check the dependencies using the `doc/tools/coqrst/checkdeps.py` script.

### Other formats

To produce the documentation in PDF and PostScript formats, the following
additional tools are required:

  - latex (latex2e)
  - pdflatex
  - dvips
  - makeindex
  - xelatex
  - latexmk

All of them are part of the TexLive distribution. E.g. on Debian / Ubuntu,
install them with:

    apt install texlive-full

Or if you want to use less disk space:

    apt install texlive-latex-extra texlive-fonts-recommended texlive-xetex \
                latexmk fonts-freefont-otf

### Setting the locale for Python

Make sure that the locale is configured on your platform so that Python encodes
printed messages with utf-8 rather than generating runtime exceptions
for non-ascii characters.  The `.UTF-8` in `export LANG=C.UTF-8` sets UTF-8 encoding.
The `C` can be replaced with any supported language code.  You can set the default
for a Docker build with `ENV LANG C.UTF-8`.  (Python may look at other
environment variables to determine the locale; see the
[Python documentation](https://docs.python.org/3/library/locale.html#locale.getdefaultlocale)).

Compilation
-----------

The current documentation targets are:

- `make refman-html`
  Build the reference manual in HTML form into `_build/default/doc/refman-html`

- `make stdlib-html`
  Build the standard library documentation into `_build/default/doc/stdlib/html`

To build the Sphinx documentation without stopping at the first
warning, change the value of the `SPHINXWARNOPT` variable (default is
`-W`). The following will build the Sphinx documentation without
stopping at the first warning, and store all the warnings in the file
`/tmp/warn.log`:

```
SPHINXWARNOPT="-w/tmp/warn.log" make refman-html
```

Note that inspecting local copies of the docs may behave in unexpected ways if
opening the sources with a browser (eg with `firefox
_build/default/doc/refman-html/index.html`). In order to avoid this, either
inspect the version generated by the CI or run a local server, for example
with:
```
cd _build/default/doc/refman-html/ && python3 -m http.server
```
