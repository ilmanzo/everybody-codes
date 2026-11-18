import std.stdio, std.file, std.string, std.algorithm;

struct P {
    int x, y;
    P opBinary(string op : "+")(P o) const => P(x + o.x, y + o.y);
}

struct Dir { P d, n1, c1, n2, c2; }

immutable Dir[4] DIRS = [
    {P( 1,  0), P( 0, -1), P(1, 0), P(0,  1), P(1, 1)},
    {P( 0,  1), P(-1,  0), P(0, 1), P(1,  0), P(1, 1)},
    {P(-1,  0), P( 0, -1), P(0, 0), P(0,  1), P(0, 1)},
    {P( 0, -1), P(-1,  0), P(0, 0), P(1,  0), P(1, 0)},
];

struct Grid {
    string[] rows;
    int w() const => cast(int) rows[0].length;
    int h() const => cast(int) rows.length;
    bool opIndex(P p) const => p.x >= 0 && p.y >= 0 && p.x < w && p.y < h && rows[p.y][p.x] == '#';
}

Grid load(string filename) => Grid(filename.readText.stripRight.splitLines);

/// BFS over '#' cells from the origin; calls onBorder(cell, dir) for every non-'#' neighbour.
void flood(alias onBorder)(Grid g) {
    auto q = [P(0, 0)];
    bool[P] seen = [q[0]: true];
    for (size_t i; i < q.length; ++i)
        foreach (d; DIRS) {
            const n = q[i] + d.d;
            if (!g[n]) onBorder(q[i], d);
            else if (n !in seen) { seen[n] = true; q ~= n; }
        }
}

auto part1(Grid g) {
    auto q = [P(0, 0)];
    int[P] dist = [q[0]: 0];
    for (size_t i; i < q.length; ++i) {
        const u = q[i];
        if (u == P(g.w - 1, g.h - 1)) return dist[u];
        foreach (d; DIRS) {
            const v = u + d.d;
            if (g[v] && v !in dist) { dist[v] = dist[u] + 1; q ~= v; }
        }
    }
    return -1;
}

auto part2(Grid g) {
    int total;
    g.flood!((p, d) => total++);
    return total;
}

struct Node { P cell, pos; }

auto part3(Grid g) {
    Node[][Node] edges;
    void link(Node a, Node b) {
        foreach (e; [[a, b], [b, a]])
            if (!edges.get(e[0], null).canFind(e[1])) edges[e[0]] ~= e[1];
    }

    g.flood!((pos, d) {
        const c1 = pos + d.c1, c2 = pos + d.c2;
        link(Node(pos, c1), Node(pos, c2));
        foreach (nc; [Node(pos + d.n1, c1), Node(pos + d.n2, c2)])
            if (g[nc.cell]) link(Node(pos, nc.pos), nc);
    });

    struct Item { int steps; Node u; }
    auto q = [Item(0, Node(P(0, 0), P(0, 0)))];
    bool[Node] seen = [q[0].u: true];
    for (size_t i; i < q.length; ++i) {
        const cur = q[i];
        if (cur.u.pos == P(g.w, g.h)) return cur.steps;
        foreach (v; edges.get(cur.u, null))
            if (v !in seen) { seen[v] = true; q ~= Item(cur.u.pos == v.pos ? cur.steps : cur.steps + 1, v); }
    }
    return -1;
}

void main() {
    "input1.txt".load.part1.writeln;
    "input2.txt".load.part2.writeln;
    "input3.txt".load.part3.writeln;   
}
