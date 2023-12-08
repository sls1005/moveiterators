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
  ## this lasts until the last iteration is finished, and after that, `s` will be restored.
  ## Any attempt to modify `s` (including trying to `add` or assign to it) within the loop, except by using an address that's taken from an element before the first iteration, will not have its effect to last after the end of the last iteration.
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
  ## this lasts until the last iteration is finished, and after that, `s` will be restored.
  ## Any attempt to modify `s` (including trying to `add` or assign to it) within the loop (except by using the yielded variable or an address that's taken from an element before the first iteration or from a yielded variable) will not have its effect to last after the end of the last iteration.
  ## The current implementation uses `addr`.
  ##
  ## Despite its name, this is unrelated with view types. The current implementation uses move semantics internally.
  var tmp = move(s)
  for i in countUpBy1(0, len(tmp) - 1):
    yield addr(tmp[i])[] # It doesn't compile otherwise.
  s = move(tmp)

iterator itemsBorrowedFrom*(s: var string): char {.inline.} =
  var tmp = move(s)
  for i in countUpBy1(0,  len(tmp) - 1):
    yield tmp[i]
  s = move(tmp)

iterator mutableItemsBorrowedFrom*(s: var string): var char {.inline.} =
  ## The current implementation uses `addr`.
  var tmp = move(s)
  when declared(prepareMutation):
    prepareMutation(tmp)
  else:
    tmp.add("") # Ensure that it's on the heap.
  for i in countupBy1(0,  len(tmp) - 1):
    yield addr(tmp[i])[]
  s = move(tmp)

