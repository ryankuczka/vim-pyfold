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
