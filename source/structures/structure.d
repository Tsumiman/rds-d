import std.stdio;
import graph;

class Structure {
  protected:
    const Graph graph;

  public:
    this (in Graph graph) {
      this.graph = graph;
    }

    // Verifiers. These should be implemented by subclasses.
    abstract bool checkPair(in uint v, in uint u) const;
    abstract bool checkAddition(in uint v, in uint[] p) const;
    abstract bool checkSolution(in uint[] p) const;

    //
    void initAux(uint v, in uint[] C) {}
    void prepareAux(in uint v, in uint[] p, in uint[] C) {}
    void undoAux(in uint v, in uint[] p, in uint[] C) {}
}
