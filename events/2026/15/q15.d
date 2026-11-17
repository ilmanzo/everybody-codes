
import std.stdio;
import std.file;
import std.string;
import std.algorithm;
import std.array;
import std.typecons;
import std.datetime.stopwatch;
import std.container.dlist;

enum INF = long.max / 2;

class HerbQuest {
    string[] grid;
    int rows, cols;
    int startRow, startCol;
    int endRow, endCol;
    int[Tuple!(int, int)] herbs;

    // Up, Right, Down, Left
    static immutable int[] dRow = [-1, 0, 1, 0];
    static immutable int[] dCol = [0, 1, 0, -1];
    
    this(string filename) {
        grid = readText(filename).splitLines().filter!(l => l.length > 0).array;
        rows = cast(int)grid.length;
        cols = cast(int)grid[0].length;

        int herbCount = 0;
        foreach (row; 0 .. rows) {
            foreach (col; 0 .. cols) {
                if (grid[row][col] == 'S') {
                    startRow = row;
                    startCol = col;
                } else if (grid[row][col] == 'E') {
                    endRow = row;
                    endCol = col;
                } else if (grid[row][col] == '@') {
                    herbs[tuple(row, col)] = herbCount++;
                }
            }
        }
    }
    
    struct State(T) {
        int row, col, dir;
        static if (!is(T == void)) {
            T payload;
        }
    }
    
    struct Node(S, E = void) {
        S state;
        long t;
        static if (!is(E == void)) {
            E extra;
        }
    }
    
    enum BfsAction { Return, Continue, Expand }

    alias OnNodeFn(NodeT) = BfsAction delegate(ref NodeT curr);
    alias NextNodeFn(NodeT) = NodeT delegate(ref NodeT curr, int nextRow, int nextCol, int nextDir, bool isHerb);

    void eachValidMove(int row, int col, int dir, scope void delegate(int nextRow, int nextCol, int nextDir, bool isHerb) yield) {
        foreach (nextDir; 0 .. 4) {
            if (nextDir == (dir ^ 2)) continue; // Can't turn 180 degrees
            int nextRow = row + dRow[nextDir];
            int nextCol = col + dCol[nextDir];
            if (nextRow >= 0 && nextRow < rows && nextCol >= 0 && nextCol < cols && grid[nextRow][nextCol] != '#') {
                yield(nextRow, nextCol, nextDir, grid[nextRow][nextCol] == '@');
            }
        }
    }

    long bfs(StateT, NodeT)(StateT startState, NodeT startNode, scope OnNodeFn!NodeT onNode, scope NextNodeFn!NodeT nextNode) {
        DList!NodeT todo;
        bool[StateT] seen;
        
        todo.insertBack(startNode);
        seen[startState] = true;
        
        while (!todo.empty) {
            auto curr = todo.front;
            todo.removeFront();
            
            final switch (onNode(curr)) {
                case BfsAction.Return: return curr.t;
                case BfsAction.Continue: continue;
                case BfsAction.Expand: break;
            }
            
            eachValidMove(curr.state.row, curr.state.col, curr.state.dir, (nextRow, nextCol, nextDir, isHerb) {
                NodeT nextN = nextNode(curr, nextRow, nextCol, nextDir, isHerb);
                if (nextN.state !in seen) {
                    seen[nextN.state] = true;
                    todo.insertBack(nextN);
                }
            });
        }
        return -1;
    }

    long part1() {
        alias State1 = State!int;
        alias Node1 = Node!State1;
        
        int targetMask = (1 << herbs.length) - 1;
        State1 startState = State1(startRow, startCol, 1, 0); // 1 is RIGHT
        
        return bfs!(State1, Node1)(
            startState, 
            Node1(startState, 0),
            (ref Node1 curr) {
                if (curr.state.row == endRow && curr.state.col == endCol && curr.state.payload == targetMask) {
                    return BfsAction.Return;
                }
                return BfsAction.Expand;
            },
            (ref Node1 curr, int nextRow, int nextCol, int nextDir, bool isHerb) {
                int nextMask = curr.state.payload;
                if (isHerb) {
                    nextMask |= (1 << herbs[tuple(nextRow, nextCol)]);
                }
                return Node1(State1(nextRow, nextCol, nextDir, nextMask), curr.t + 1);
            }
        );
    }

    long part2(long target = 2026, bool exact = false) {
        alias State2 = State!long;
        alias Node2 = Node!State2;
        
        State2 startState = State2(startRow, startCol, 1, 0);
        
        return bfs!(State2, Node2)(
            startState, 
            Node2(startState, 0),
            (ref Node2 curr) {
                if (curr.state.row == endRow && curr.state.col == endCol) {
                    if ((exact && curr.state.payload == target) || (!exact && curr.state.payload >= target)) {
                        return BfsAction.Return;
                    }
                }
                return BfsAction.Expand;
            },
            (ref Node2 curr, int nextRow, int nextCol, int nextDir, bool isHerb) {
                long nextCount = curr.state.payload + (isHerb ? 1 : 0);
                return Node2(State2(nextRow, nextCol, nextDir, nextCount), curr.t + 1);
            }
        );
    }
    
    long part3() {
        alias State3 = State!void;
        alias Node3 = Node!(State3, long);
        long[long] best;
        
        foreach (startColIter; startCol + 1 .. endCol) {
            State3 startState = State3(startRow, startColIter, 1);
            
            bfs!(State3, Node3)(
                startState,
                Node3(startState, 0, 0),
                (ref Node3 curr) {
                    if (curr.state.row == startRow && curr.state.col == startColIter && curr.extra > 0) {
                        if (curr.extra !in best || curr.t < best[curr.extra]) {
                            best[curr.extra] = curr.t;
                        }
                        return BfsAction.Continue;
                    }
                    return BfsAction.Expand;
                },
                (ref Node3 curr, int nextRow, int nextCol, int nextDir, bool isHerb) {
                    long nextCount = curr.extra + (isHerb ? 1 : 0);
                    return Node3(State3(nextRow, nextCol, nextDir), curr.t + 1, nextCount);
                }
            );
        }
        
        long sulphurCycle = 1;
        long timeCycle = INF;
        double minRatio = double.max;
        
        foreach (k, v; best) {
            double ratio = cast(double)v / k;
            if (ratio < minRatio) {
                minRatio = ratio;
                sulphurCycle = k;
                timeCycle = v;
            }
        }
        
        long target = 202620262026L;
        long f = target / sulphurCycle - 10;
        if (f < 0) f = 0;
        
        return f * timeCycle + part2(target - f * sulphurCycle, true);
    }
}

void main() {
    auto sw = StopWatch(AutoStart.yes);
    auto hq = new HerbQuest("input1.txt");
    long part1 = hq.part1();
    writeln("part 1: ", part1, "  (", sw.peek.total!"msecs" / 1000.0, "s)");

    sw.reset();
    hq = new HerbQuest("input2.txt");
    long part2 = hq.part2();
    writeln("part 2: ", part2, "  (", sw.peek.total!"msecs" / 1000.0, "s)");

    sw.reset();
    hq = new HerbQuest("input3.txt");
    long part3 = hq.part3();
    writeln("part 3: ", part3, "  (", sw.peek.total!"msecs" / 1000.0, "s)");
}
