import std.stdio, std.string, std.conv, std.array, std.algorithm, std.file;

struct Point
{
    int x, y, z;
    this(int[3] p)
    {
        x = p[0];
        y = p[1];
        z = p[2];
    }

    bool opEquals(const ref Point o) const
    {
        return x == o.x && y == o.y && z == o.z;
    }

    size_t toHash() const @safe
    {
        size_t h = 17;
        h = h * 31 + x;
        h = h * 31 + y;
        h = h * 31 + z;
        return h;
    }
}

//immutable FILENAME = "sampleb.txt";
immutable FILENAME = "inputb.txt";

void main()
{

    auto moves = readText(FILENAME).chomp.splitter('\n').map!(a => a.split(',').array).array;
    bool[Point] visited;

    foreach (movet; moves)
    {
        int[3] current = [0, 0, 0];
        foreach (move; movet)
        {
            auto old = current;
            int coordIdx, sign;

            final switch (move[0])
            {
            case 'U':
                coordIdx = 0;
                sign = 1;
                break;
            case 'D':
                coordIdx = 0;
                sign = -1;
                break;
            case 'R':
                coordIdx = 1;
                sign = 1;
                break;
            case 'L':
                coordIdx = 1;
                sign = -1;
                break;
            case 'F':
                coordIdx = 2;
                sign = 1;
                break;
            case 'B':
                coordIdx = 2;
                sign = -1;
                break;
            }

            current[coordIdx] += sign * to!int(move[1 .. $]);

            int step = old[coordIdx] < current[coordIdx] ? 1 : -1;
            for (int i = old[coordIdx] + step; i != current[coordIdx] + step; i += step)
            {
                auto p = current;
                p[coordIdx] = i;
                visited[Point(p)] = true;
            }
        }
    }
    visited.length.writeln;
}
