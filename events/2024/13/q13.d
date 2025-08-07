import std.stdio;
import std.file;
import std.string;
import std.conv;
import std.math;
import std.container;
import std.array;
import std.algorithm;
import std.typecons;
import std.ascii;

struct Coord
{
    long r, c;
    bool opEquals(const ref Coord other) const
    {
        return r == other.r && c == other.c;
    }
}

struct State
{
    Coord coord;
    int level;
    bool opEquals(const ref State other) const
    {
        return level == other.level && coord == other.coord;
    }

    size_t toHash() const @trusted
    {
        size_t hash = 7;
        hash = 31 * hash + coord.r;
        hash = 31 * hash + coord.c;
        hash = 31 * hash + level;
        return hash;
    }
}

char[][] grid;
int[long][long] initial_levels;
Coord[] starts;
Coord end;

// find the shortest path from Start to End.
int dijkstra(Coord start)
{
    if (grid.empty || grid[0].empty)
        return int.max;
    auto rows = to!int(grid.length);
    auto cols = to!int(grid[0].length);
    alias PQElement = Tuple!(int, State);
    auto pq = BinaryHeap!(PQElement[], "a[0] > b[0]")(PQElement[].init);
    int[State] dist;
    auto startState = State(start, 0);
    dist[startState] = 0;
    pq.insert(tuple(0, startState));

    while (!pq.empty)
    {
        auto top = pq.front;
        pq.removeFront();

        int totalTime = top[0];
        State currentState = top[1];

        if (totalTime > dist[currentState])
            continue;

        if (currentState.coord == end && currentState.level == 0)
            return totalTime;

        static immutable Coord[4] dirs = [
            Coord(-1, 0), Coord(1, 0), Coord(0, -1), Coord(0, 1)
        ];

        foreach (dir; dirs)
        {
            Coord nextCoord = Coord(currentState.coord.r + dir.r, currentState.coord.c + dir.c);

            if (nextCoord.r < 0 || nextCoord.r >= rows || nextCoord.c < 0 || nextCoord.c >= cols)
                continue;

            auto neighborLevel = initial_levels[nextCoord.r][nextCoord.c];
            if (neighborLevel == int.max)
                continue;

            auto currentLevel = currentState.level;
            auto weight = min(
                abs(neighborLevel - currentLevel) + 1,
                abs(10 - neighborLevel + currentLevel) + 1,
                abs(10 - currentLevel + neighborLevel) + 1
            );
            auto newTime = totalTime + weight;

            State neighborState = State(nextCoord, neighborLevel);
            auto pDist = neighborState in dist;

            if (pDist is null || newTime < *pDist)
            {
                dist[neighborState] = newTime;
                pq.insert(tuple(newTime, neighborState));
            }
        }
    }
    assert(0); //should never reach here
}

//immutable FILENAME = "inputa.txt";
//immutable FILENAME = "inputb.txt";
immutable FILENAME = "inputc.txt";

void main()
{
    grid = readText(FILENAME).strip.splitLines.map!(a => a.dup).array;
    foreach (r, row; grid)
    {
        foreach (c, cell; row)
        {
            if (isDigit(cell))
            {
                initial_levels[r][c] = to!int(cell - '0');
            }
            else
            {
                switch (cell)
                {
                case 'S':
                    starts ~= Coord(r, c);
                    initial_levels[r][c] = 0;
                    break;
                case 'E':
                    end = Coord(r, c);
                    initial_levels[r][c] = 0;
                    break;
                case '#', ' ':
                    initial_levels[r][c] = int.max;
                    break;
                default:
                    initial_levels[r][c] = int.max;
                    break;
                }
            }
        }
    }
    auto results = starts.map!(s => s.dijkstra());
    writeln(results.minElement());
}
