from moveiterators/utils import countUpBy1

iterator eachMovedFrom*[T](src: var seq[T]): T {.inline.} =
  ## Each item is moved out of `src`, and `src` is reset.
  ## Before the first iteration, `src` will be set to empty;
  ## any address associated with any element of `src` should not be used afterward.
  var tmp = move(src)
  for i in countUpBy1(0, len(tmp) - 1):
    yield move(tmp[i])

iterator eachMovedFrom*[I; T](src: var array[I, T]): T {.inline.} =
  ## Each item is moved out of `src`, and `src` is reset.
  ## After the last iteration, `src` will be reset completely.
  ## Neither `src` nor any of its elements should be accessed within the loop.
  for i in countUpBy1(0, len(src) - 1):
    yield move(src[i])

iterator itemsBorrowedFrom*[T](s: var seq[T]): T {.inline.} =
  ## Yields every item from `s`.
  ## Due to safety concerns, the memory of `s` is kept out of reach during the iterations;
  ## anyone trying to access `s` will instead get an empty `seq`, and the attempt to access any of its elements could instead cause an `IndexDefect`;
  ## this lasts until the end of the last iteration, and after that, `s` will be restored.
  ## Any attempt to modify `s` (including trying to `add` or assign to it) within the loop, except by using an address taken from one of the elements before the first iteration, will not have an effect that lasts after the end of the last iteration.
  ##
  ## Despite its name, this is unrelated with view types. The current implementation uses move semantics internally.
  var tmp = move(s)
  for i in countUpBy1(0,  len(tmp) - 1):
    yield tmp[i]
  s = move(tmp)

iterator mutableItemsBorrowedFrom*[T](s: var seq[T]): var T {.inline.} =
  ## Yields every item from `s`.
  ## Due to safety concerns, the memory of `s` is kept out of reach (except by using the yielded variable) during the iterations;
  ## anyone trying to access `s` will instead get an empty `seq`, and the attempt to access any of its elements could instead cause an `IndexDefect`;
  ## this lasts until the end of the last iteration, and after that, this restriction will be undone.
  ## Any attempt to modify `s` (including trying to `add` or assign to it) within the loop (except by using the yielded variable or an address taken from one of the elements before the first iteration or from a yielded variable) will not have an effect that lasts after the end of the last iteration.
  ##
  ## Despite its name, this is unrelated with view types. The current implementation uses move semantics internally.
  var r: ref seq[T] # The only reason for using `ref seq` here is that the compiler will refuse to compile if `seq` is used instead.
  r.new()
  r[] = move(s)
  for i in countUpBy1(0, len(r[]) - 1):
    yield r[][i]
  s = move(r[])

iterator itemsBorrowedFrom*(s: var string): char {.inline.} =
  var tmp = move(s)
  for i in countUpBy1(0,  len(tmp) - 1):
    yield tmp[i]
  s = move(tmp)

iterator mutableItemsBorrowedFrom*(s: var string): var char {.inline.} =
  var r: ref string # The only reason for using `ref string` here is that the compiler will refuse to compile if `string` is used instead.
  r.new()
  r[] = move(s)
  for i in countupBy1(0,  len(r[]) - 1):
    yield r[][i]
  s = move(r[])

