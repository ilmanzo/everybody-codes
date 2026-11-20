import std/[strutils, sequtils, algorithm, math, tables]

type
  Color = enum C, M, Y, K, R, G, B
  Layer = seq[Color]

func parseColor(c: char): Color =
  case c
  of '1'..'7': Color(ord(c) - ord('1'))
  of 'C': C
  of 'M': M
  of 'Y': Y
  else: K

proc parse(path: string): seq[Layer] =
  for blk in path.readFile.split("\n\n"):
    let layer = blk.filterIt(it notin Newlines).map(parseColor)
    if layer.len > 0: result.add layer

const mix = {{C, M}: B, {C, Y}: G, {M, Y}: R}.toTable

func `+`(a, b: Color): Color =
  if K in {a, b}: K else: mix.getOrDefault({a, b}, a)

func part1(a, b: Layer): int =
  var counts: array[Color, int]
  for (x, y) in zip(a, b): inc counts[x + y]
  let top = counts.sorted(Descending)
  top[0] * top[1] * top[2]

func part2(l1, lt: Layer): int =
  var tbl = @[C, M, Y, K]
  while true:
    result = max(result, part1(l1, lt.mapIt(tbl[ord it])))
    if not tbl.nextPermutation: break

func part3(l: Layer): int =
  let n = l.countIt(it != K)
  prod([n div 3, (n + 1) div 3, (n + 2) div 3])

let (p1, p2, p3) = (parse("input1.txt"), parse("input2.txt"), parse("input3.txt"))
echo part1(p1[0], p1[1])
echo part2(p2[0], p2[1])
echo part3(p3[0])
