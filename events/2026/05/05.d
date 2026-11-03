module quest05;

import std.stdio;
import std.file : readText;
import std.string : splitLines, strip;
import std.algorithm : filter, count, all, canFind;
import std.array : array, join;

struct Point {
    int x, y;
    Point opBinary(string op : "+")(Point rhs) const pure nothrow @nogc => Point(x + rhs.x, y + rhs.y);
}

immutable Point[] ORTHOGONAL = [Point(0, -1), Point(0, 1), Point(-1, 0), Point(1, 0)];
immutable Point[] DIAGONAL = [
    Point(-1, -1), Point(0, -1), Point(1, -1),
    Point(-1, 0),               Point(1, 0),
    Point(-1, 1),  Point(0, 1),  Point(1, 1)
];

struct Grid {
    int width, height;
    ubyte[] bytes;

    static Grid parse(string input) {
        auto lines = input.strip.splitLines.filter!(l => l.length > 0).array;
        if (!lines.length) return Grid();
        return Grid(cast(int) lines[0].length, cast(int) lines.length, cast(ubyte[]) lines.join);
    }

    bool contains(Point p) const pure nothrow @nogc => p.x >= 0 && p.x < width && p.y >= 0 && p.y < height;
    ref inout(ubyte) opIndex(Point p) inout pure nothrow @nogc => bytes[width * p.y + p.x];
    size_t count(ubyte val) const => bytes.count(val);
}

size_t around(in Grid g, Point p, string kinds) =>
    DIAGONAL.count!(d => g.contains(p + d) && kinds.canFind(cast(char) g[p + d]));

void spread(ref Grid g, Point[] todo, ubyte kind, string wanted) {
    foreach (p; todo) g[p] = kind;
    // index walk, not pop: length-- then ~= was ~68x slower (600x600: 17s -> 0.25s)
    for (size_t i = 0; i < todo.length; i++) {
        auto p = todo[i];
        foreach (d; DIAGONAL) {
            auto n = p + d;
            if (g.contains(n) && g[n] != kind && g.around(n, wanted) >= 5) {
                g[n] = kind;
                todo ~= n;
            }
        }
    }
}

void land(ref Grid g) => g.spread([Point(g.width / 2, g.height / 2)], '#', "#1");

Point[] landWhere(alias pred)(in Grid g) {
    Point[] cells;
    foreach (y; 0 .. g.height)
        foreach (x; 0 .. g.width)
            if (g[Point(x, y)] == '#' && pred(g, Point(x, y)))
                cells ~= Point(x, y);
    return cells;
}

void sand(ref Grid g) => g.spread(landWhere!((in g, p) => g.around(p, "#") < 8)(g), '=', "=");

void tree(alias rule)(ref Grid g) {
    foreach (p; landWhere!rule(g)) g[p] = '@';
}

size_t[3] solve(string notes) {
    auto g = Grid.parse(notes);
    size_t[3] parts;
    g.land();
    parts[0] = g.count('#');
    g.sand();
    parts[1] = g.count('=');
    g.tree!((in g, p) => ORTHOGONAL.all!(o => g.around(p + o, "#") == 8))();
    foreach (_; 0 .. 2)
        g.tree!((in g, p) => g.around(p, "@") >= 4 && g.around(p, "=") == 0)();
    parts[2] = g.count('@');
    return parts;
}

enum EXAMPLE =
"010100100100001101000
111101001000001110000
101111011000101010011
001000101010000100000
000110100110011001100
000001110111111000000
101100010101011110000
001101100000001010011
001001001111010001001
100011011110011010101
001100101110010010000";

unittest {
    assert(solve(EXAMPLE) == [137, 69, 14]);
}

int main(string[] args) {
    if (args.length != 2) {
        stderr.writeln("Usage: quest05 <input file>");
        return 1;
    }
    auto parts = solve(readText(args[1]));
    writefln("Part 1: %d\nPart 2: %d\nPart 3: %d", parts[0], parts[1], parts[2]);
    return 0;
}
