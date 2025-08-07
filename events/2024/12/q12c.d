import std.stdio;
import std.file;
import std.conv;
import std.string;
import std.array;
import std.algorithm;
import std.typecons;
import std.exception;

struct Coord
{
    long x;
    long y;
}

alias PowerResult = Tuple!(long, "v1", long, "v2");

PowerResult[Tuple!(Coord, Coord)] memoCache;

PowerResult getPower(Coord src, Coord nd_tgt)
{
    auto key = tuple(src, nd_tgt);
    if (auto p_result = key in memoCache)
        return *p_result;

    long time = 0;
    for (;;)
    {
        auto tgt = Coord(nd_tgt.x - time, nd_tgt.y - time);
        long dx = tgt.x - src.x;
        long dy = tgt.y - src.y;
        PowerResult result;
        long p1 = dx / 2;
        if (dx == dy && dx % 2 == 0)
        {
            result = tuple(p1 + src.y, p1 * (1 + src.y));
            return memoCache[key] = result;
        }
        long p2 = dy - dx / 2;
        long t2 = dx - dy;
        if (dx % 2 == 0 && t2 > 0 && t2 <= p2)
        {
            result = tuple(p2 + src.y, p2 * (1 + src.y));
            return memoCache[key] = result;
        }
        long p3 = dy / 3;
        long t3 = dx / 2 - (2 * dy) / 3;
        if (dy % 3 == 0 && dx % 2 == 0 && t3 > 0)
        {
            result = tuple(p3 + src.y, p3 * (1 + src.y));
            return memoCache[key] = result;
        }
        time++;
    }
}

void main()
{
    auto letters = [Coord(0, 0), Coord(0, 1), Coord(0, 2)];
    Coord[] meteors;
    foreach (line; readText("inputc.txt").splitLines())
    {
        auto parts = line.strip.split;
        if (parts.length < 2)
            continue;
        meteors ~= Coord(to!long(parts[0]), to!long(parts[1]));
    }
    long totalPower = 0;
    foreach (m; meteors)
    {
        auto powers = letters.map!(l => getPower(l, m)).array;
        auto bestPower = powers.maxElement!(p => tuple(p.val1, -p.val2));
        totalPower += bestPower.val2;
    }
    writeln(totalPower);
}
