import moveiterators

proc main =
  var s = "123456789"

  doAssert(len(s) == 9)
  echo s

  for x in itemsBorrowedFrom(s):
    echo x
    doAssert(len(s) == 0)

  doAssert(len(s) == 9)
  echo s

  for x in mutableItemsBorrowedFrom(s):
    x = '0'
    doAssert(len(s) == 0)

  doAssert(len(s) == 9)
  echo s

main()