import std.stdio;
import std.file : readText;
import std.string : strip, split;
import std.algorithm : map, sort, uniq, min, max;
import std.math : abs;
import std.conv : to;
import std.array : array;
import std.typecons : Tuple, tuple;
import std.container : BinaryHeap, Array;
import std.datetime.stopwatch : StopWatch;

struct Point
{
    long x;
    long y;
    this(long x, long y)
    {
        this.x = x;
        this.y = y;
    }

    bool opEquals(ref const Point rhs) const
    {
        return x == rhs.x && y == rhs.y;
    }

    size_t toHash() const
    {
        auto ux = cast(ulong) x;
        auto uy = cast(ulong) y;
        return cast(size_t)((ux * 9999) ^ uy);
    }
}

immutable Point[] DIRS = [
    Point(-1, 0), Point(1, 0), Point(0, -1), Point(0, 1)
];

alias Instr = Tuple!(char, "dir", int, "len");
Instr[] parse(string fname)
{
    return fname.readText.strip.split(",").map!(s => Instr(s[0], s[1 .. $].to!int)).array;
}

void main()
{
    "input1.txt".p1p2();
    "input2.txt".p1p2();
    "input3.txt".p3();
}

void turn(ref long dx, ref long dy, char dir)
{
    if (dir == 'L')
    {
        auto t = dx;
        dx = -dy;
        dy = t;
    }
    else
    {
        auto t = dx;
        dx = dy;
        dy = -t;
    }
}

void buildPath(Instr[] instrs, void delegate(long, long) pointVisit = null, void delegate(long, long, long, long) segVisit = null)
{
    long x = 0, y = 0;
    long dx = 0, dy = 1;
    if (pointVisit)
        pointVisit(x, y);
    foreach (i; instrs)
    {
        long sx = x, sy = y;
        turn(dx, dy, i.dir);
        long xn = x + i.len * dx;
        long yn = y + i.len * dy;
        if (segVisit)
            segVisit(sx, sy, xn, yn);
        foreach (_; 0 .. i.len)
        {
            x += dx;
            y += dy;
            if (pointVisit)
                pointVisit(x, y);
        }
    }
}

void p1p2(string fname)
{
    auto sw = StopWatch();
    sw.start();
    auto instrs = parse(fname);
    Point start = Point(0, 0);
    Point end;
    bool[Point] wall;
    Point last = Point(0, 0);
    buildPath(instrs, (long x, long y) {
        wall[Point(x, y)] = true;
        last = Point(x, y);
    }, null);
    end = last;
    long[Point] dist;
    dist[start] = 0;
    Point[] q;
    q ~= start;
    size_t qi = 0;
    long ans = -1;
    while (qi < q.length)
    {
        auto curr = q[qi++];
        auto d = dist[curr];
        foreach (dp; DIRS)
        {
            auto nextP = Point(curr.x + dp.x, curr.y + dp.y);
            if (nextP == end)
            {
                ans = d + 1;
                qi = q.length;
                break;
            }
            if (nextP !in wall && nextP !in dist)
            {
                dist[nextP] = d + 1;
                q ~= nextP;
            }
        }
    }
    writefln("%s -> %s (%.3fs)", fname, ans, sw.peek.total!"msecs" / 1000.0);
}

struct CoordinateCompression
{
    long[] vals;
    this(long[] original)
    {
        vals = original.sort.uniq.array;
    }

    long compressed(long v) const
    {
        size_t lo = 0, hi = vals.length;
        while (lo < hi)
        {
            auto mid = (lo + hi) >> 1;
            if (vals[mid] < v)
                lo = mid + 1;
            else
                hi = mid;
        }
        return cast(long) lo;
    }

    long original(long idx) const
    {
        return vals[cast(size_t) idx];
    }

    long minComp() const
    {
        return 0;
    }

    long maxComp() const
    {
        return cast(long)(vals.length - 1);
    }
}

void p3(string fname)
{
    auto sw = StopWatch();
    sw.start();
    auto instrs = fname.parse();
    Point start = Point(0, 0);
    Point end;
    Tuple!(long, long, long, long)[] segments;
    Point last;
    buildPath(instrs, (long x, long y) { last = Point(x, y); }, (long x1, long y1, long x2, long y2) {
        segments ~= tuple(x1, y1, x2, y2);
    });
    end = last;
    long[] xs;
    long[] ys;
    foreach (s; segments)
    {
        xs ~= [s[0] - 1, s[0], s[0] + 1, s[2] - 1, s[2], s[2] + 1];
        ys ~= [s[1] - 1, s[1], s[1] + 1, s[3] - 1, s[3], s[3] + 1];
    }
    auto cx = CoordinateCompression(xs);
    auto cy = CoordinateCompression(ys);
    auto sx = cx.compressed(start.x);
    auto sy = cy.compressed(start.y);
    auto ex = cx.compressed(end.x);
    auto ey = cy.compressed(end.y);
    bool[Point] wallComp;
    foreach (s; segments)
    {
        long x1 = cx.compressed(s[0]), y1 = cy.compressed(s[1]);
        long x2 = cx.compressed(s[2]), y2 = cy.compressed(s[3]);
        foreach (x; min(x1, x2) .. max(x1, x2) + 1)
            foreach (y; min(y1, y2) .. max(y1, y2) + 1)
                wallComp[Point(x, y)] = true;
    }
    struct State
    {
        long cost;
        long x;
        long y;
        this(long cost, long x, long y)
        {
            this.cost = cost;
            this.x = x;
            this.y = y;
        }
    }

    auto pq = BinaryHeap!(State[], "a.cost > b.cost")(State[].init);
    pq.insert(State(0, sx, sy));
    long[Point] dists;
    dists[Point(sx, sy)] = 0;
    long ans = -1;
    while (!pq.empty)
    {
        auto curr = pq.front;
        pq.removeFront();
        if (curr.x == ex && curr.y == ey)
        {
            ans = curr.cost;
            break;
        }
        if (auto pd = Point(curr.x, curr.y) in dists)
            if (*pd < curr.cost)
                continue;
        foreach (dp; DIRS)
        {
            long nx = curr.x + dp.x;
            long ny = curr.y + dp.y;
            if (nx < cx.minComp() || nx > cx.maxComp() || ny < cy.minComp() || ny > cy.maxComp())
                continue;
            long weight = abs(cx.original(curr.x) - cx.original(nx)) + abs(
                cy.original(curr.y) - cy.original(ny));
            bool isEnd = (nx == ex && ny == ey);
            if (isEnd || Point(nx, ny) !in wallComp)
            {
                long newCost = curr.cost + weight;
                auto np = Point(nx, ny);
                if (np !in dists || newCost < dists[np])
                {
                    dists[np] = newCost;
                    pq.insert(State(newCost, nx, ny));
                }
            }
        }
    }
    writefln("p3: %s (%.3fs)", ans, sw.peek.total!"msecs" / 1000.0);
}
