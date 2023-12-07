import moveiterators

proc main =
  var s: seq[seq[int]]
  for k in 1..10:
    s.add @[k]

  doAssert(len(s) == 10)
  echo s

  for e in eachMovedFrom(s):
    echo e

  doAssert(len(s) == 0)

main()