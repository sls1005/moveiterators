iterator countUpBy1*[T: SomeSignedInt](start, stop: T): T {.inline.} =
  ## Yields all numbers from the interval [`start`, `stop`] sequentially.
  if likely(start <= stop):
    var n = start
    while true:
      yield n
      if n == stop: # Overflows are prevented by performing this check before addition.
        break
      n = n +% 1
