import std.stdio, std.file, std.string, std.array, std.range;

auto sort(const(char)[] s) {
    ulong total, swaps;
    foreach (_; 0 .. 3) {
        if (s.empty) break;
        immutable c = s[0];
        auto next = new char[s.length];
        size_t l, r = s.length - 1, w = next.length; // fill next from the back: no reverse needed
        void swap() { if (r > l) { total += r - l + 1; swaps++; } }
        while (l < r) {
            while (l < r && s[l] == c) l++;
            while (r > l && s[r] != c) next[--w] = s[r--];
            swap();
            while (r > l && s[r] == c) r--;
            while (l <= r && s[l] != c) next[--w] = s[l++];
            swap();
        }
        s = next[w .. $];
    }
    return [total, swaps];
}

auto load(int n, size_t k) => readText(format("input%d.txt", n)).strip.repeat(k).join;

void main() {
    writeln("part1=", load(1, 1).sort[1]);
    writeln("part2=", load(2, 10).sort[0]);
    writeln("part3=", load(3, 100).sort[0]);
}
