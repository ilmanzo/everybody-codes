import std.stdio, std.file, std.string, std.algorithm, std.range, std.typecons;

void main()
{
    alias P = Tuple!(long, "r", long, "c");
    auto g = "input1.txt".readText.splitLines;
    auto R = g.length, C = g[0].length;
    iota(R)
        .map!(r => iota(C - 1)
                .filter!(c => g[r][c] == 'T')
                .map!(c => (((r + c) & 1)
                    ? [P(r, c - 1), P(r, c + 1), P(r + 1, c)] : [
                        P(r, c - 1), P(r, c + 1), P(r - 1, c)
    ])
                    .filter!(p => p.r >= 0 && p.r < R && p.r <= p.c && p.c <= C - 1 - p.r && g[p.r][p
                        .c] == 'T' && tuple(r, c) < p)
                .count)
        .sum)
        .sum
        .writeln;
}
