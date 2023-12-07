import moveiterators

proc main =
  var s: seq[seq[int]]
  for k in 1..10:
    s.add @[k]

  doAssert(len(s) == 10)
  echo s

  for x in itemsBorrowedFrom(s):
    echo x
    doAssert(len(s) == 0)

  doAssert(len(s) == 10)
  echo s

  for x in mutableItemsBorrowedFrom(s):
    x = @[0]
    doAssert(len(s) == 0)

  doAssert(len(s) == 10)
  echo s

main()