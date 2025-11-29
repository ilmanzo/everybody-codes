import std.stdio;
import std.file;
import std.string;
import std.conv;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.typecons;

void main() {
    auto timeStart = StopWatch();
    timeStart.start();

    immutable INPUT_FILE = "input2.txt";
    auto grid = readText(INPUT_FILE).strip.splitLines.map!(to!(char[])).array;
    auto nRows = grid.length;
    auto nCols = grid[0].length;

    long rs, cs;
    // Find starting position 'S'
    foreach (r, row; grid) {
        foreach (c, cell; row) {
            if (cell == 'S') {
                rs = r;
                cs = c;
                goto found;
            }
        }
    }
    found:

    auto bfs(typeof(tuple(rs, cs)) start) {
        auto dist = [start: 0];
        auto todo = [start];
        size_t head = 0;

        while (head < todo.length) {
            auto pos = todo[head++];
            auto r = pos[0];
            auto c = pos[1];

            if (grid[r][c] == 'E') {
                return dist[pos];
            }

            static immutable int[4] dr = [-1, 1, 0, 0];
            static immutable int[4] dc = [0, 0, -1, 1];

            foreach (i; 0..4) {
                long rn = r + dr[i];
                long cn = c + dc[i];

                if (rn >= 0 && rn < nRows && cn >= 0 && cn < nCols) {
                    auto nextPos = tuple(rn, cn);
                    auto nextCell = grid[rn][cn];
                    if (canFind("TSE", nextCell) && !(nextPos in dist)) {
                        dist[nextPos] = dist[pos] + 1;
                        todo ~= nextPos;
                    }
                }
            }
        }
        return int.max; // Return "infinity" if 'E' is not found
    }

    auto ans2 = bfs(tuple(rs, cs));
    writefln("part 2: %s  (%.3fs)", ans2, timeStart.peek.total!"usecs" / 1_000_000.0);
}
