from IPython.core import excolors, ultratb, debugger
from IPython.core.excolors import exception_colors as exception_colors_orig
from IPython.utils import coloransi
from IPython.utils import PyColorize
import token
import tokenize
from prompt_toolkit.output.vt100 import _256_colors
from pygments.style import Style
from pygments.token import (Keyword, Name, Comment, String, Error, Text,
                            Number, Operator, Literal, Token)
from prompt_toolkit.styles.defaults import PROMPT_TOOLKIT_STYLE


c.TerminalInteractiveShell.confirm_exit = False
c.TerminalInteractiveShell.display_completions = "column"

# Define hexadecimal base16-default-dark colors
_base00 = '#181818'
_base01 = '#282828'
_base02 = '#383838'
_base03 = '#585858'
_base04 = '#b8b8b8'
_base05 = '#d8d8d8'
_base06 = '#e8e8e8'
_base07 = '#f8f8f8'
_base08 = '#ab4642'
_base09 = '#dc9656'
_base0A = '#f7ca88'
_base0B = '#a1b56c'
_base0C = '#86c1b9'
_base0D = '#7cafc2'
_base0E = '#ba8baf'
_base0F = '#a16946'
_baseDEBUG = '#ff0000'

# See https://github.com/jonathanslenders/python-prompt-toolkit/issues/355
_colors = (globals()['_base0' + d] for d in '08BADEC5379F1246')
for i, color in enumerate(_colors):
    r, g, b = int(color[1:3], 16), int(color[3:5], 16), int(color[5:], 16)
    _256_colors[r, g, b] = i + 6 if i > 8 else i

# Define a base16-default-dark Pygments style
class Base16Style(Style):

    background_color = _base00
    highlight_color = _base02
    default_style = _base05

    styles = {
        Text: _base05,
        Error: '%s bold' % _base08,
        Comment: _base03,
        Keyword: _base0E,
        Keyword.Constant: _base09,
        Keyword.Namespace: _base0D,
        Name.Builtin: _base0D,
        Name.Function: _base0D,
        Name.Class: _base0D,
        Name.Decorator: _base0E,
        Name.Exception: _base08,
        Number: _base09,
        Operator: _base0E,
        Literal: _base0B,
        String: _base0B
    }

# Apply the Pygments style, used for prompt colors and syntax highlighting
c.TerminalInteractiveShell.highlighting_style = Base16Style

# Override tokens
c.TerminalInteractiveShell.highlighting_style_overrides = {
    Token.Prompt: _base0B,
    Token.PromptNum: '%s bold' % _base0B,
    Token.OutPrompt: _base08,
    Token.OutPromptNum: '%s bold' % _base08,
    Token.Menu.Completions.Completion: 'bg:%s %s' % (_base01, _base04),
    Token.Menu.Completions.Completion.Current: 'bg:%s %s' % (_base04, _base01),
}

# IPython does not allow overriding prompt_toolkit
# classnames in style_overrides, it only accepts Pygments tokens.
# Because there are no Pygments tokens for the completion menu and
# matching brackets, we can not easily change their colors.
# The easiest way around this is by overriding the
# prompt_toolkit default style.

def _replace(l, X, Y):
  for i, v in enumerate(l):
     if v[0] == X:
        l.pop(i)
        l.insert(i, (v[0], Y))

_pt_style = PROMPT_TOOLKIT_STYLE
_replace(_pt_style, "matching-bracket.other", f"{_base05} bg:{_base03}")
_replace(_pt_style, "matching-bracket.cursor", f"{_base05} bg:{_base03}")
_replace(_pt_style, "completion-menu", f"{_base05} bg:{_base01}")
_replace(_pt_style, "completion-menu.completion.current", f"{_base01} bg:{_base05}")
_replace(_pt_style, "completion-menu.multi-column-meta", f"{_base01} bg:{_base05}")
_replace(_pt_style, "completion-menu.meta.completion", f"{_base05} bg:{_base01}")
_replace(_pt_style, "completion-menu.meta.completion.current", f"{_base01} bg:{_base05}")
_replace(_pt_style, "scrollbar.background", f"bg:{_base03}")
_replace(_pt_style, "scrollbar.button", f"bg:{_base06}")

# InteractiveShell only accepts ['Neutral', 'NoColor', 'LightBG', 'Linux'].
# We can't easily add an entry, so we´ll have to override one
colorLabel = "Linux"

# InteractiveShell.colors is legacy code and will probably be changed
# to use prompt_toolkit. In order to change the colors for tracebacks
# and object info, we have to override some attributes.

# Define the base16 color template
coloransi.color_templates = (
    # Dark colors
    ("Black"       , "0;30"),
    ("Red"         , "0;31"),
    ("Green"       , "0;32"),
    ("Yellow"      , "0;33"),
    ("Blue"        , "0;34"),
    ("Magenta"     , "0;35"),
    ("Cyan"        , "0;36"),
    ("White"       , "0;37"),

    # Bright colors (rendered bold in most terms)
    ("BrightBlack" , "1;30"),
    ("BrightRed"   , "1;31"),
    ("BrightGreen" , "1;32"),
    ("BrightYellow", "1;33"),
    ("BrightBlue"  , "1;34"),
    ("BrightMagenta", "1;35"),
    ("BrightCyan"  , "1;36"),
    ("BrightWhite" , "1;37"),

    # Define base16 colors using 256-colors to prevent unwanted bold text
    ("Base00", "0;38;5;0"), # Black
    ("Base08", "0;38;5;1"), # Red
    ("Base0B", "0;38;5;2"), # Green
    ("Base0A", "0;38;5;3"), # Yellow
    ("Base0D", "0;38;5;4"), # Blue
    ("Base0E", "0;38;5;5"), # Magenta
    ("Base0C", "0;38;5;6"), # Cyan
    ("Base05", "0;38;5;7"), # White
    ("Base03", "0;38;5;8"), # Bright Black
    ("Base07", "0;38;5;15"), # Bright White
    ("Base09", "0;38;5;16"),
    ("Base0F", "0;38;5;17"),
    ("Base01", "0;38;5;18"),
    ("Base02", "0;38;5;19"),
    ("Base04", "0;38;5;20"),
    ("Base06", "0;38;5;21"),

    ## Background colors
    ("Debug", "0;48;5;1;38;5;15"),
    #("LineNumber", "0;48;5;18;38;5;8"),
    #("LineNumberEm", "0;48;5;19;38;5;7"),
)

coloransi.make_color_table(coloransi.TermColors)
coloransi.make_color_table(coloransi.InputTermColors)

for name, value in coloransi.color_templates:
    setattr(coloransi.NoColors, name, '')

# Shorthands
C = coloransi.TermColors
IC = coloransi.InputTermColors

# Override the exception colors
def exception_colors():
    ex_colors = exception_colors_orig()

    ex_colors.add_scheme(coloransi.ColorScheme(
        colorLabel,

        # The color to be used for the top line
        topline=C.Base08,

        # The colors to be used in the traceback
        filename=C.Base0F,
        lineno=C.Base03,
        name=C.Normal,
        vName=C.Normal,
        val=C.Normal,
        em=C.Normal,

        # Emphasized colors for the last frame of the traceback
        normalEm=C.Normal,
        filenameEm=C.Base0F,
        linenoEm=C.Base07,
        nameEm=C.Normal,
        valEm=C.Normal,

        # Colors for printing the exception
        excName=C.Base08,
        line=C.Normal,
        caret=C.Normal,
        Normal=C.Normal,
    ))
    return ex_colors

excolors.exception_colors = exception_colors
ultratb.exception_colors = exception_colors
debugger.exception_colors = exception_colors

# Create another color scheme, used for pdb highlighting and object inspection
PyColorize.ANSICodeColors[colorLabel] = coloransi.ColorScheme(
    colorLabel, {
        'header'         : C.Base0A,
        token.NUMBER     : C.Base09,
        token.OP         : C.Normal,
        token.STRING     : C.Base0B,
        tokenize.COMMENT : C.Base03,
        token.NAME       : C.Normal,
        token.ERRORTOKEN : C.Base08,

        PyColorize._KEYWORD         : C.Base0E,
        PyColorize._TEXT            : C.Normal,

        ## Keep IC here, you can use other colors

        'in_prompt'      : IC.Green,
        'in_number'      : IC.Green,
        'in_prompt2'     : IC.Green,
        'in_normal'      : IC.Normal,  # color off (usu. Colors.Normal)

        'out_prompt'     : C.Base08,
        'out_number'     : C.Base08,

        'normal'         : C.Normal  # color off (usu. Colors.Normal)
})

c.InteractiveShell.colors = colorLabel
