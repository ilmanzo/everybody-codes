module quest07;

import std.stdio, std.file, std.format, std.string, std.conv, std.typecons;
import std.algorithm : any, filter, map, max, maxIndex, splitter, sum;
import std.array : array;
import std.range : iota;
import std.parallelism : taskPool;

alias Parsed = Tuple!(long[], "energies", size_t[][], "graph");

Parsed parse(string input) {
    auto lines = input.strip.splitLines;
    auto energies = new long[](lines.length + 1);
    auto graph = new size_t[][](lines.length + 1);
    foreach (line; lines) {
        size_t id;
        long energy;
        string conns;
        formattedRead(line, "id=%s, energy=%s, connections=%s", id, energy, conns);
        energies[id] = energy;
        graph[id] = conns.length ? conns.splitter(',').map!(to!size_t).array : null;
    }
    return Parsed(energies, graph);
}

size_t mostConnected(const size_t[][] graph) pure =>
    graph.maxIndex!"a.length < b.length";

// Simulates a pulse started at `start`; returns the total energy of nodes that did not explode.
long simulate(size_t start, size_t strength, const long[] energies, const size_t[][] graph, long limit = long.max) pure {
    const cnt = energies.length;
    auto cur = energies.dup;
    auto exploded = new bool[](cnt);

    auto pulsesFlat = new long[]((strength + 1) * cnt);
    long[][16] pulsesStack;
    auto pulses = strength < 16 ? pulsesStack[0 .. strength + 1] : new long[][](strength + 1);
    foreach (x; 0 .. strength + 1)
        pulses[x] = pulsesFlat[x * cnt .. (x + 1) * cnt];

    long[16] pulseCntStack;
    auto pulseCnt = strength < 16 ? pulseCntStack[0 .. strength + 1] : new long[](strength + 1);

    pulses[strength][start] = pulseCnt[strength] = 1;

    while (pulseCnt.any!(c => c > 0)) {
        foreach (x; 1 .. strength + 1) {
            if (pulseCnt[x] == 0) continue;
            foreach (n; 0 .. cnt) {
                const p = pulses[x][n];
                if (p == 0) continue;
                cur[n] += p * cast(long) x;
                if (x > 1) {
                    foreach (c; graph[n]) {
                        if (!exploded[c]) {
                            pulses[x - 1][c] += p;
                            pulseCnt[x - 1] += p;
                        }
                    }
                }
            }
            pulses[x][] = pulseCnt[x] = 0;
        }

        // nodes over the limit explode after the whole step has been accumulated
        foreach (n; 0 .. cnt) {
            if (exploded[n] || cur[n] < limit) continue;
            exploded[n] = true;
            // drop everything queued for this node, including explosion pulses from earlier nodes
            foreach (x; 1 .. strength + 1) {
                pulseCnt[x] -= pulses[x][n];
                pulses[x][n] = 0;
            }
            foreach (c; graph[n]) {
                if (!exploded[c]) {
                    pulses[strength][c]++;
                    pulseCnt[strength]++;
                }
            }
        }
    }

    return iota(cnt).filter!(n => !exploded[n]).map!(n => cur[n]).sum(0L);
}

long part1(Parsed p) => simulate(mostConnected(p.graph), 5, p.expand);

long part2(Parsed p) => simulate(mostConnected(p.graph), 10, p.expand);

long part3(Parsed p, long limit = 1_000_000) =>
    taskPool.reduce!max(
        iota(1, p.energies.length).map!(start => simulate(start, 10, p.expand, limit)),
        10
    );

unittest {
    enum sample1 =
"id=1, energy=5, connections=2,5,7
id=2, energy=9, connections=6,7
id=3, energy=3, connections=4
id=4, energy=8, connections=3
id=5, energy=1, connections=6,7
id=6, energy=7, connections=1,7
id=7, energy=6, connections=5";

    enum sample2 =
"id=1, energy=5, connections=2,3,5,7
id=2, energy=9, connections=1,3,4,5,6,7
id=3, energy=3, connections=1,2,4,6,7
id=4, energy=8, connections=1,2,7
id=5, energy=1, connections=2,3,4,6
id=6, energy=7, connections=1,2,3,4
id=7, energy=6, connections=1,2,4,6";

    auto s1 = parse(sample1);
    auto s2 = parse(sample2);

    assert(part1(s1) == 102);
    assert(part2(s2) == 1214633);
    assert(part3(s1, 100) == 187);

    if ("input1.txt".exists && "input2.txt".exists && "input3.txt".exists) {
        assert(part1(parse(readText("input1.txt"))) == 275);
        assert(part2(parse(readText("input2.txt"))) == 115659552);
        assert(part3(parse(readText("input3.txt"))) == 27133127);
    }
}

void main(string[] args) {
    string file(size_t i, string def) {
        auto f = args.length > i ? args[i] : def;
        return !f.exists && (f ~ ".txt").exists ? f ~ ".txt" : f;
    }

    auto p1 = parse(readText(file(1, "input1.txt")));
    auto p2 = parse(readText(file(2, "input2.txt")));
    auto p3 = parse(readText(file(3, "input3.txt")));

    writefln("Part 1: %d", part1(p1));
    writefln("Part 2: %d", part2(p2));
    writefln("Part 3: %d", part3(p3));
}
