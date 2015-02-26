# pyfold.vim

pyfold is awesome folding for python files in vim. Inspired by
the many methods of folding away python functions and classes,
pyfold uses `foldexpr` to fold clases, methods, and functions,
without leaving any blank lines between them.

pyfold is also configurable to fold multi-line sections between
braces, brackets, and parentheses.

## Foldtext

pyfold also makes the foldtext nicer. When folding a function or
method with decorators, pyfold will make the foldtext look like

```python
@decorator: @another_decorator: my_func(args):
```

When folding braces, brackets, or parentheses, pyfold will add
the correct close brace, bracket, or parentheses. A small detail
but makes the folds look so much nicer.

## Installation

- **Pathogen**: `git clone git://github.com/ryankuczka/vim-pyfold.git ~/.vim/bundle`
- **Vundle**: `Plugin 'ryankuczka/vim-pyfold'`
- **NeoBundle**: `NeoBundle 'ryankuczka/vim-pyfold'`
- **vim-plug**: `Plug 'ryankuczka/vim-pyfold'`

## Performance
pyfold uses `set foldmethod=expr` to function. This can cause vim to slow down
a lot due to vim recalculating folds all the time. If vim gets slow, you can
temporarily disable or toggle pyfold on and off with the following commands.

```vim
:PyFoldEnable
:PyFoldDisable
:PyFoldToggle
```

### FastFold
[FastFold](https://github.com/Konfekt/FastFold) is a great plugin which will only
recalculate folds when saving which can greatly improve performance when using fold
methods such as `expr`. I highly recommend installing it alongside pyfold for the
best performance.

> Unfortunately, due to how FastFold works, if something else changes the
> foldmethod, such as diff mode, when the foldmethod would be changed back
> FastFold keeps it at `manual` and pyfold must be re-enabled via `:PyFoldEnable`

## Examples

### Gap-less folding

```python
class Foo(object):
    pass


class Bar(object):
    pass
```

becomes

```
+-  4 lines: class Foo(object):-----------------------------------------------
+-  2 lines: class Bar(object):-----------------------------------------------
```

instead of

```
+-  2 lines: class Foo(object):-----------------------------------------------


+-  2 lines: class Bar(object):-----------------------------------------------
```

with other methods.

### Decorator support

```python
def foo():
    pass

@my_decorator
def bar():
    pass
```

becomes

```
+-  3 lines: def foo():-------------------------------------------------------
+-  3 lines: @my_decorator: bar():--------------------------------------------
```

### Braces, Brackets, and Parentheses

Most python folding methods don't fold away multi-line sections between braces,
brackets, and parentheses which I always found annoying. Now:

```python
# With g:pyfold_braces = 1 (Default: 1)
MY_DICT = {
    'foo': 'bar',
}

# With g:pyfold_brackets = 1 (Default: 1)
MY_LIST = [
    'foo',
    'bar',
]

# With g:pyfold_parens = 1 (Default: 0)
MY_TUPLE = (
    'foo',
    'bar',
)
```

becomes

```python
# With g:pyfold_braces = 1 (Default: 1)
+-  3 lines: MY_DICT = {}-----------------------------------------------------

# With g:pyfold_brackets = 1 (Default: 1)
+-  4 lines: MY_LIST = []-----------------------------------------------------

# With g:pyfold_parens = 1 (Default: 0)
+-  4 lines: MY_TUPLE = ()----------------------------------------------------
```
