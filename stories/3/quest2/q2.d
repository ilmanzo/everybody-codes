import std.stdio;
import std.file;
import std.string;
import std.algorithm;
import std.array;
import std.typecons;

immutable long[2][4] DIRS = [[1, 0], [0, 1], [-1, 0], [0, -1]];

struct Grid {
    char[][] grid;

    long width() const { return grid.length > 0 ? cast(long)grid[0].length : 0; }
    long height() const { return cast(long)grid.length; }

    bool has(const long x, const long y) const {
        return x >= 0 && x < width() && y >= 0 && y < height();
    }

    int opApply(int delegate(long x, long y, char c) dg) const {
        foreach (y, row; grid) {
            foreach (x, c; row) {
                if (auto res = dg(cast(long)x, cast(long)y, c))
                    return res;
            }
        }
        return 0;
    }

    this(string filename) {
        if (!exists(filename)) return;
        char[][] g = readText(filename).splitLines().map!(l => l.dup).array;
        this.grid = g;
        return;
    }

    void fill(long start_x, long start_y, char c, ref long[] q_x, ref long[] q_y) {
        if (grid[start_y][start_x] != '.') return;

        grid[start_y][start_x] = c;
        q_x[0] = start_x;
        q_y[0] = start_y;

        size_t head = 0;
        size_t tail = 1;
        long w = width();
        long h = height();

        while (head < tail) {
            long x = q_x[head];
            long y = q_y[head];
            head++;

            foreach (dir; DIRS) {
                long nx = x + dir[0];
                long ny = y + dir[1];
                if (nx >= 0 && nx < w && ny >= 0 && ny < h && grid[ny][nx] == '.') {
                    grid[ny][nx] = c;
                    if (tail < q_x.length) {
                        q_x[tail] = nx;
                        q_y[tail] = ny;
                        tail++;
                    }
                }
            }
        }
    }

    bool allSurrounded() const {
        long w = width();
        long h = height();
        foreach (y; 0 .. h) {
            foreach (x; 0 .. w) {
                if (grid[y][x] == '#') {
                    foreach (dir; DIRS) {
                        long nx = x + dir[0];
                        long ny = y + dir[1];
                        if (nx < 0 || nx >= w || ny < 0 || ny >= h || grid[ny][nx] == '.') {
                            return false;
                        }
                    }
                }
            }
        }
        return true;
    }

    long visit(const(long[2])[] instructions, bool delegate(const ref Grid) endfunction) {
        long pos_x = 0, pos_y = 0;
        foreach (x, y, c; this) {
            if (c == '@') {
                pos_x = x;
                pos_y = y;
                break;
            }
        }

        long steps = 0;
        long ins_idx = 0;

        // use a queue for BFS traversal, preallocate to avoid reallocations
        long[] q_x = new long[](1000000);
        long[] q_y = new long[](1000000);

        while (!endfunction(this)) {
            auto ins = instructions[ins_idx % instructions.length];
            ins_idx++;

            long nx = pos_x + ins[0];
            long ny = pos_y + ins[1];

            // extend grid if necessary
            if (!has(nx, ny)) {
                if (nx < 0) {
                    char[][] new_grid = new char[][](height(), width() + 1);
                    foreach (r; new_grid) r[] = '.';
                    foreach (y; 0 .. height()) {
                        foreach (x; 0 .. width()) {
                            new_grid[y][(x + 1)] = grid[y][x];
                        }
                    }
                    grid = new_grid;
                    nx += 1;
                    pos_x += 1;
                } else if (ny < 0) {
                    char[][] new_grid = new char[][](height() + 1, width());
                    foreach (r; new_grid) r[] = '.';
                    foreach (y; 0 .. height()) {
                        foreach (x; 0 .. width()) {
                            new_grid[(y + 1)][x] = grid[y][x];
                        }
                    }
                    grid = new_grid;
                    ny += 1;
                    pos_y += 1;
                } else if (nx == width()) {
                    char[][] new_grid = new char[][](height(), width() + 1);
                    foreach (r; new_grid) r[] = '.';
                    foreach (y; 0 .. height()) {
                        foreach (x; 0 .. width()) {
                            new_grid[y][x] = grid[y][x];
                        }
                    }
                    grid = new_grid;
                } else {
                    char[][] new_grid = new char[][](height() + 1, width());
                    foreach (r; new_grid) r[] = '.';
                    foreach (y; 0 .. height()) {
                        foreach (x; 0 .. width()) {
                            new_grid[y][x] = grid[y][x];
                        }
                    }
                    grid = new_grid;
                }
            }

            if (grid[ny][nx] != '.') {
                continue;
            }

            steps++;
            grid[ny][nx] = '+';
            pos_x = nx;
            pos_y = ny;

            long w = width();
            long h = height();
            foreach (x; 0 .. w) {
                fill(x, 0, 'F', q_x, q_y);
                fill(x, h - 1, 'F', q_x, q_y);
            }
            foreach (y; 0 .. h) {
                fill(0, y, 'F', q_x, q_y);
                fill(w - 1, y, 'F', q_x, q_y);
            }

            foreach (y; 0 .. h) {
                foreach (x; 0 .. w) {
                    const char c = grid[y][x];
                    if (c == '.') {
                        grid[y][x] = '+';
                    } else if (c == 'F') {
                        grid[y][x] = '.';
                    }
                }
            }
        }

        return steps;
    }
}

void part1(string path) {
    auto g = Grid("inputa.txt");
    immutable long[2][] instructions = [[0, -1], [1, 0], [0, 1], [-1, 0]];
    long dest_x = 0, dest_y = 0;
    foreach (x, y, c; g) {
        if (c == '#') {
            dest_x = x;
            dest_y = y;
            g.grid[y][x] = '.';
            break;
        }
    }
    g.visit(instructions, (const ref Grid g) => g.grid[dest_y][dest_x] == '+').writeln;
}

void part2(string path) {
    auto g = Grid("inputb.txt");
    immutable long[2][] instructions = [[0, -1], [1, 0], [0, 1], [-1, 0]];
    g.visit(instructions, (const ref Grid grid) => grid.allSurrounded()).writeln;
}

void part3(string path) {
    auto g = Grid("inputc.txt");
    immutable long[2][] instructions = [
        [0, -1], [0, -1], [0, -1],
        [1, 0], [1, 0], [1, 0],
        [0, 1], [0, 1], [0, 1],
        [-1, 0], [-1, 0], [-1, 0]
        ];
    g.visit(instructions, (const ref Grid grid) => grid.allSurrounded()).writeln;
}

void main() {
    part1("inputa.txt");
    part2("inputb.txt");
    part3("inputc.txt");
}
