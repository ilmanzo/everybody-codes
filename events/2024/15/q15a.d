import std.stdio, std.file, std.string, std.container, std.typecons, std.algorithm, std.range;

struct Pos
{
    int y, x;
    bool opEquals(ref const Pos o) const
    {
        return y == o.y && x == o.x;
    }

    size_t toHash() const @safe
    {
        size_t h = y;
        return (h << 16) | x;
    }
}

immutable FILENAME = "inputa.txt";
//immutable FILENAME = "samplea.txt";

void main()
{
    auto input = readText(FILENAME).chomp.splitter('\n').array;
    Pos start;

    outer: foreach (y, line; input)
    {
        foreach (x, char c; line)
        {
            if ((y == 0 || y == input.length - 1 || x == 0 || x == line.length - 1) && c == '.')
            {
                start = Pos(cast(int) y, cast(int) x);
                break outer;
            }
        }
    }

    auto dijkstra = (Pos startNode) {
        alias State = Tuple!(long, "cost", Pos, "pos");
        auto queue = DList!State(State(0, startNode));
        bool[Pos] seen;

        while (!queue.empty)
        {
            auto curr = queue.front;
            queue.removeFront();

            if (curr.pos in seen)
                continue;
            seen[curr.pos] = true;

            auto p = curr.pos;
            char tile = input[p.y][p.x];

            if (tile != '.' && tile != 'H')
                continue;
            if (tile == 'H')
                return curr.cost;

            static immutable moves = [
                Pos(0, 1), Pos(0, -1), Pos(1, 0), Pos(-1, 0)
            ];
            moves.map!(m => Pos(p.y + m.y, p.x + m.x))
                .filter!(n => n.y >= 0 && n.y < input.length && n.x >= 0 && n.x < input[0].length)
                .each!(n => queue.insertBack(State(curr.cost + 1, n)));
        }
        return long.max;
    };

    (dijkstra(start) * 2).writeln;
}
