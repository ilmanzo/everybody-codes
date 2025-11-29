import std.stdio;
import std.algorithm;
import std.array;
import std.string;

uint[][] readInput()
{
    string[] grid;
    string line;
    while ((line = readln()) !is null)
        grid ~= line.strip();
    return grid.map!(row => row.map!(c => c - '0').array).array;
}

void part1(uint[][] grid)
{
    auto rows = cast(int) grid.length;
    auto cols = cast(int) grid[0].length;
    auto centerRow = rows / 2.0;
    auto centerCol = cols / 2.0;
    auto radius = 10;
    int total = 0;
    for (int row = 0; row < rows; row++)
    {
        for (int col = 0; col < cols; col++)
        {
            auto distSquared = (row - centerRow) * (row - centerRow) +
                (
                    col - centerCol) * (col - centerCol);
            auto radiusSquared = radius * radius;
            if (distSquared < radiusSquared)
                total += grid[row][col];
        }
    }
    writeln(total);
}

void main()
{
    auto grid = readInput();
    part1(grid);
}
