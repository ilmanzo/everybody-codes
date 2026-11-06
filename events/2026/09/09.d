module day09;

import std.algorithm, std.file, std.format, std.stdio, std.string;

struct Plant { long growth, limit; }

alias Branches = long[long]; // branch length -> how many branches have it

/// Ages every branch by `dt`. Branches reaching `growth` split into two
/// half-growth branches plus a new shoot. Returns the number of splits.
long age(ref Branches branches, long growth, long dt) {
    Branches aged;
    foreach (length, count; branches)
        aged[length + dt] = count;
    const splits = aged.get(growth, 0);
    if (splits) {
        aged[growth / 2] += 2 * splits;
        aged[1] += splits;
    }
    aged.remove(growth);
    branches = aged;
    return splits;
}

/// Part 1: first time the plant has `limit` elements (every split adds one,
/// every branch counts its length), so it must be simulated unit by unit.
long timeByElements(Plant p) {
    Branches branches = [1: 1];
    long splits = 0;
    for (long time = 1;; time++) {
        const elements = splits + branches.byKeyValue.map!(kv => kv.key * kv.value).sum;
        if (elements >= p.limit)
            return time;
        splits += age(branches, p.growth, 1);
    }
}

/// Parts 2 and 3: first time the plant has `limit` leaves. Leaves only change
/// on a split, so jump straight from split to split.
long timeByLeaves(Plant p) {
    Branches branches = [1: 1];
    long time = 1, leaves = 1;
    while (leaves < p.limit) {
        const skip = p.growth - branches.keys.maxElement;
        const splits = age(branches, p.growth, skip);
        assert(splits, "no split");
        leaves += splits;
        time += skip;
    }
    return time;
}

Plant parse(string line) {
    Plant p;
    long id;
    line.formattedRead!"id=%s, growth=%s, limit=%s"(id, p.growth, p.limit);
    return p;
}

long solve(alias timeFor)(string file) =>
    readText(file).lineSplitter.filter!(l => l.strip.length).map!parse.map!timeFor.sum;

void main() {
    writeln(solve!timeByElements("input1.txt"));
    writeln(solve!timeByLeaves("input2.txt"));
    writeln(solve!timeByLeaves("input3.txt"));
}
