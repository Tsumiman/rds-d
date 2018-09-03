import structure;
import graph;
import std.stdio;

class Clique: Structure {
  public:
    this (in Graph g) {
      super(g);
    }
    
    static this () {
      string name = "Clique";
      string shortcut = "-c";
    }

    override bool checkPair(in uint v, in uint u) const {
      return graph.isEdge(v, u);
    }

    override bool checkAddition(in uint v, in uint[] p) const {
      foreach (u; p) {
        if (!graph.isEdge(v, u)) {
          return false;
        }
      }
      return true;
    }

    override bool checkSolution(in uint[] p) const {
      foreach (u; p) {
        foreach (v; p) {
          if (u == v) {
            continue;
          }

          if (!graph.isEdge(v, u)) {
            return false;
          }
        }
      }
      return true;
    }
}

unittest {
  Graph g = new Graph(5);
  g.addEdge(0, 1);
  g.addEdge(0, 2);
  g.addEdge(0, 3);
  g.addEdge(1, 2);
  g.addEdge(1, 3);
  g.addEdge(1, 4);
  g.addEdge(2, 3);
  g.addEdge(3, 4);
  Clique C = new Clique(g);

  assert(C.checkPair(0, 1));
  assert(C.checkPair(1, 4));
  assert(C.checkPair(2, 4) == false);
  assert(C.checkAddition(1, [3]));
  assert(C.checkAddition(0, [1, 2, 3]));
  assert(C.checkAddition(4, [1, 2, 3, 4]) == false);
  assert(C.checkSolution([1, 2, 3]));
  assert(C.checkSolution([0, 1, 2, 3]));
  assert(C.checkSolution([0, 1, 4]) == false);
}
