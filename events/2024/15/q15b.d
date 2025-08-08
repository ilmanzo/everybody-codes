import std.stdio, std.file, std.string, std.container, std.typecons, std.algorithm, std.range, std
    .conv;

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

//immutable FILENAME = "sampleb.txt";
//immutable FILENAME = "inputb.txt";
immutable FILENAME = "inputc.txt";

void main()
{
    auto input = readText(FILENAME).chomp.splitter('\n').array;
    Pos startPos;

    outer: foreach (y, line; input)
    {
        if (line.empty)
            continue;
        foreach (x, char c; line)
        {
            if ((y == 0 || y == input.length - 1 || x == 0 || x == line.length - 1) && c == '.')
            {
                startPos = Pos(cast(int) y, cast(int) x);
                break outer;
            }
        }
    }

    Pos[][char] plants;
    foreach (y, line; input)
    {
        foreach (x, char c; line)
        {
            if (c != '#' && c != '~' && c != '.')
            {
                plants[c] ~= Pos(cast(int) y, cast(int) x);
            }
        }
    }

    auto bfs = (Pos start, Pos end) {
        alias State = Tuple!(long, "cost", Pos, "pos");
        auto queue = DList!State(State(0, start));
        bool[Pos] seen = [start: true];

        while (!queue.empty)
        {
            auto curr = queue.front;
            queue.removeFront();

            if (curr.pos == end)
                return curr.cost;
            if (input[curr.pos.y][curr.pos.x] == '#')
                continue;

            static immutable moves = [
                Pos(0, 1), Pos(0, -1), Pos(1, 0), Pos(-1, 0)
            ];
            foreach (move; moves)
            {
                Pos next = Pos(curr.pos.y + move.y, curr.pos.x + move.x);
                if (next.y < 0 || next.y >= input.length || next.x < 0 || next.x >= input[0].length)
                    continue;
                if (next in seen)
                    continue;

                seen[next] = true;
                queue.insertBack(State(curr.cost + 1, next));
            }
        }
        return long.max;
    };

    long[Pos][Pos] costs;
    auto pointsOfInterest = [startPos] ~ plants.values.joiner.array;
    foreach (p1; pointsOfInterest)
    {
        foreach (p2; pointsOfInterest)
        {
            if (p1 != p2)
                costs[p1][p2] = bfs(p1, p2);
        }
    }

    long minCost = long.max;
    foreach (order; plants.keys.array.permutations)
    {
        long[Tuple!(int, Pos)] memo;
        long solve(int typeIdx, Pos prevPos)
        {
            if (typeIdx == order.length)
                return costs[prevPos][startPos];

            auto state = tuple(typeIdx, prevPos);
            if (state in memo)
                return memo[state];

            long best = long.max;
            foreach (currPos; plants[cast(char) order[typeIdx]])
            {
                long segmentCost = costs[prevPos][currPos];
                if (segmentCost == long.max)
                    continue;

                long restCost = solve(typeIdx + 1, currPos);
                if (restCost != long.max)
                {
                    best = min(best, segmentCost + restCost);
                }
            }
            return memo[state] = best;
        };

        long pathCost = solve(0, startPos);
        minCost = min(minCost, pathCost);
    }

    minCost.writeln;
}
