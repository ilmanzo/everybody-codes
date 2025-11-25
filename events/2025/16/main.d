import std.stdio;
import std.file;
import std.string;
import std.conv;
import std.algorithm;
import std.range;
import std.array;
import std.bigint;

long[] loadInput(string filename) => readText(filename).strip.split(',').map!(to!long).array;
long numBlocksUsed(long length, const long[] blocks) => blocks.map!(c => length / c).sum;

long[] extractBlocks(long[] cols)
{
    long[] blocks;
    foreach (block; 1 .. cols.length + 1)
    {
        auto indices = iota(block - 1, cols.length, block);
        if (indices.all!(i => cols[i] > 0))
        {
            foreach (i; indices)
                cols[i]--;
            blocks ~= block;
        }
    }
    return blocks;
}

void main()
{
    writeln("Part 1: ", numBlocksUsed(90, "input1.txt".loadInput()));

    {
        auto cols = "input2.txt".loadInput();
        auto blocks = cols.extractBlocks;
        auto result = blocks.map!(a => BigInt(a))
            .fold!((a, b) => a * b)(BigInt(1));
        writeln("Part 2: ", result);
    }

    auto cols = "input3.txt".loadInput();
    auto blocks = cols.extractBlocks();
    const long target = 202_520_252_025_000;
    double density = blocks.map!(c => 1.0 / c).sum;
    long estimatedLen = cast(long)(target / density);
    long lowerBound = estimatedLen - 200_000;
    long upperBound = estimatedLen + 200_000;
    long ans = lowerBound;
    while (lowerBound <= upperBound)
    { // binary search
        long mid = lowerBound + (upperBound - lowerBound) / 2;
        if (numBlocksUsed(mid, blocks) <= target)
        {
            ans = mid; // mid is valid, try higher
            lowerBound = mid + 1;
        }
        else
            upperBound = mid - 1; // mid is too high
    }
    writeln("Part 3: ", ans);
    assert(numBlocksUsed(ans, blocks) <= target);
    assert(numBlocksUsed(ans + 1, blocks) > target);
}
