import std.stdio, std.array, std.algorithm, std.range, std.string, std.file, std.typecons;

struct Star
{
    int x;
    int y;
}

struct Edge
{
    int from;
    int to;
    int weight;
}

class UnionFind
{
    int[] parent;
    int[] rank;

    this(int n)
    {
        parent = new int[n];
        rank = new int[n];
        for (int i = 0; i < n; i++)
        {
            parent[i] = i;
            rank[i] = 0;
        }
    }

    int find(int x)
    {
        if (parent[x] != x)
            parent[x] = find(parent[x]);
        return parent[x];
    }

    bool unite(int x, int y)
    {
        int rootX = find(x);
        int rootY = find(y);

        if (rootX == rootY)
            return false;

        if (rank[rootX] < rank[rootY])
            parent[rootX] = rootY;
        else if (rank[rootX] > rank[rootY])
            parent[rootY] = rootX;
        else
        {
            parent[rootY] = rootX;
            rank[rootX]++;
        }

        return true;
    }
}

int manhattanDistance(Star a, Star b)
{
    import std.math : abs;

    return abs(a.x - b.x) + abs(a.y - b.y);
}

Star[] parseCoordinates(string[] lines)
{
    return lines
        .enumerate
        .map!(lineTuple => lineTuple.value
                .enumerate
                .filter!(charTuple => charTuple.value == '*')
                .map!(charTuple => Star(cast(int) charTuple.index, cast(int) lineTuple.index))

    )
        .joiner
        .array;
}

Edge[] kruskalMST(Star[] coords)
{
    Edge[] edges;
    int n = cast(int) coords.length;

    // Generate all edges between all pairs of coordinates
    for (int i = 0; i < n; i++)
    {
        for (int j = i + 1; j < n; j++)
        {
            int dist = manhattanDistance(coords[i], coords[j]);
            edges ~= Edge(i, j, dist);
        }
    }
    edges.sort!((a, b) => a.weight < b.weight);
    UnionFind uf = new UnionFind(n);
    Edge[] mst;

    foreach (edge; edges)
    {
        if (uf.unite(edge.from, edge.to))
        {
            mst ~= edge;
            if (mst.length == n - 1)
                break;
        }
    }

    return mst;
}

ulong part12(Star[] s)
{
    return s.length + s.kruskalMST().map!(edge => edge.weight).sum();
}

Star[][] groupStarsByDistance(Star[] stars, int maxDistance = 6)
{
    auto n = cast(int) stars.length;
    UnionFind uf = new UnionFind(n);
    for (int i = 0; i < n; i++)
    {
        for (int j = i + 1; j < n; j++)
        {
            if (manhattanDistance(stars[i], stars[j]) < maxDistance)
            {
                uf.unite(i, j);
            }
        }
    }
    return stars
        .enumerate
        .map!(indexedStar => tuple(
                indexedStar.value,
                uf.find(cast(int) indexedStar.index)
        ))
        .array
        .sort!((a, b) => a[1] < b[1])
        .chunkBy!(item => item[1])
        .map!(group => group[1]
                .map!(item => item[0])
                .array)
        .array;
}

ulong part3(Star[] stars)
{
    auto constellations = groupStarsByDistance(stars);
    auto brilliantStars = constellations.map!(c => c.part12).array;
    brilliantStars.sort!((a, b) => a > b);
    foreach (b; brilliantStars)
    {
        writeln(b);
    }
    //take the last 3 values and multiply them
    return brilliantStars.take(3).reduce!((a, b) => a * b);
}

//immutable FILENAME = "samplea.txt";
//immutable FILENAME = "inputa.txt";
//immutable FILENAME = "inputb.txt";
//immutable FILENAME = "samplec.txt";
immutable FILENAME = "inputc.txt";

void main()
{
    auto stars = readText(FILENAME).chomp.split('\n').parseCoordinates();
    //stars.part12.writeln;
    stars.part3.writeln;
}
