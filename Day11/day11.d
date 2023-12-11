import std.stdio;
import std.file;
import std.math;
import std.array;
import std.algorithm;

size_t[] xrange(size_t end) { return xrange(0, end); }
size_t[] xrange(size_t start, size_t end) {
    size_t[] list;
    for(; start < end; start++) {
        list ~= start;
    }
    return list;
}

size_t pathdist(int[2] s1, int[2] s2) {
    return abs(s2[0] - s1[0]) + abs(s2[1] - s1[1]);
}

void main() {
    auto file = File("input.txt");
    string[] lines;
    file.byLine.each!(a => lines ~= a.idup);
    auto empty_rows = lines.map!(a => !any!(b => b == '#')(a));
    auto empty_cols = xrange(lines[0].length).map!(
        a => !any!(b => b[a] == '#')(lines)
    );
    auto rowinds = cumulativeFold!((a, b) => b ? a + 2 : a + 1)
        (empty_rows, empty_rows[0] ? -2 : -1).array;
    auto colinds = cumulativeFold!((a, b) => b ? a + 2 : a + 1)
        (empty_cols, empty_cols[0] ? -2 : -1).array;
    int[2][] stars;
    foreach(i, string row; lines) {
        foreach(j, char c; row) {
            if(c == '#') {
                stars ~= [rowinds[i], colinds[j]];
            }
        }
    }
    size_t totdist = 0;
    foreach(i, int[2] star1; stars) {
        foreach(int[2] star2; stars[i+1..$]) {
            totdist += pathdist(star1, star2);
        }
    }
    writeln(totdist);
}