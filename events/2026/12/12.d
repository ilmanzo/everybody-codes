import std.stdio;
import std.file;
import std.algorithm;
import std.array;
import std.string;
import std.typecons;

alias Grid = ubyte[];
const int[2][4] DIRS = [[1, 0], [0, 1], [-1, 0], [0, -1]];

auto parse(string path) {
    auto lines = readText(path).strip().splitLines();
    int width = cast(int) lines[0].length;
    int height = cast(int) lines.length;
    auto grid = cast(ubyte[]) lines.join("").dup;
    return tuple!("width", "height", "grid")(width, height, grid);
}

ulong reflectShape(Grid grid, int width, int height) {
    foreach (y; 0 .. height) {
        foreach (x; 0 .. width) {
            if (grid[y * width + x] != '#') continue;

            ulong getRect(bool horiz) {
                int pMin = horiz ? x : y;
                int pMax = pMin;
                int sMin = horiz ? y : x;
                int sMax = sMin;
                
                int pLimit = horiz ? width : height;
                int sLimit = horiz ? height : width;

                bool isHash(int p, int s) {
                    int cx = horiz ? p : s;
                    int cy = horiz ? s : p;
                    return grid[cy * width + cx] == '#';
                }

                while (pMax + 1 < pLimit && isHash(pMax + 1, sMin)) {
                    pMax++;
                }

                while (sMax + 1 < sLimit) {
                    bool ok = true;
                    foreach (p; pMin .. pMax + 1) {
                        if (!isHash(p, sMax + 1)) { ok = false; break; }
                    }
                    if (ok && pMin > 0 && isHash(pMin - 1, sMax + 1)) ok = false;
                    if (ok && pMax + 1 < pLimit && isHash(pMax + 1, sMax + 1)) ok = false;
                    if (!ok) break;
                    sMax++;
                }

                auto g2 = grid.dup;
                int minX = horiz ? pMin : sMin;
                int maxX = horiz ? pMax : sMax;
                int minY = horiz ? sMin : pMin;
                int maxY = horiz ? sMax : pMax;
                
                foreach (cy; minY .. maxY + 1) {
                    foreach (cx; minX .. maxX + 1) {
                        g2[cy * width + cx] = '.';
                    }
                }
                
                return min(maxX - minX + 1, maxY - minY + 1) + reflectShape(g2, width, height);
            }

            return min(getRect(true), getRect(false));
        }
    }
    return 0;
}

ulong reflect(Grid grid, int width, int height) {
    ulong total = 0;

    foreach (y; 0 .. height) {
        foreach (x; 0 .. width) {
            if (grid[y * width + x] != '#') continue;

            int[2][] coords;
            int minX = x, minY = y, maxX = x, maxY = y;
            grid[y * width + x] = '.';
            int[2][] queue = [[x, y]];

            while (queue.length > 0) {
                int cx = queue[$ - 1][0];
                int cy = queue[$ - 1][1];
                queue.length--;
                
                coords ~= [cx, cy];
                minX = min(minX, cx);
                minY = min(minY, cy);
                maxX = max(maxX, cx);
                maxY = max(maxY, cy);
                
                foreach (d; DIRS) {
                    int nx = cx + d[0], ny = cy + d[1];
                    if (nx >= 0 && nx < width && ny >= 0 && ny < height && grid[ny * width + nx] == '#') {
                        grid[ny * width + nx] = '.';
                        queue ~= [nx, ny];
                    }
                }
            }

            int w = maxX - minX + 1;
            int h = maxY - minY + 1;
            auto g2 = new ubyte[w * h];
            g2[] = '.';
            foreach (c; coords) {
                g2[(c[1] - minY) * w + c[0] - minX] = '#';
            }

            total += reflectShape(g2, w, h);
        }
    }

    return total;
}

void main() {
    auto p1 = parse("input1.txt");
    writeln(reflect(p1.grid, p1.width, p1.height));

    auto p2 = parse("input2.txt");
    writeln(reflect(p2.grid, p2.width, p2.height));

    auto p3 = parse("input3.txt");
    writeln(reflect(p3.grid, p3.width, p3.height));
}
