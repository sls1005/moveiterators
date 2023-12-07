import moveiterators

proc main =
  var a: array[10, seq[int]]
  for i in 0 ..< 10:
    a[i] = @[i]
  echo a

  for e in eachMovedFrom(a):
    echo e

  echo a

main()