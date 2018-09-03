import std.bitmanip;

class Graph {
  private:
    uint nodes;
    BitArray[] adjacency;
    uint[] currentOrder;
  
  protected:
    void reorder(in uint[] newOrder) {
    	Graph reordered = new Graph(this.size);
      foreach (uint i, uint v; newOrder) {
        foreach (uint j, uint u; newOrder) {
          if (this.isEdge(v, u)) {
            reordered.addEdge(i, j);
          }
        }

        reordered.currentOrder[i] = this.currentOrder[v];
      }

      this.adjacency = reordered.adjacency;
      this.currentOrder = reordered.currentOrder;
    }

    uint[] restoreOrder(in uint[] vertices) {
      uint[] result = new uint[vertices.length];
      foreach (i, v; vertices) {
        result[i] = this.currentOrder[v];
      }
      return result;
    }

    void reset() {
      adjacency.length = this.nodes;
      foreach (ref row; adjacency) {
        row = BitArray(new bool[nodes]);
      }

      currentOrder.length = nodes;
      foreach (uint i, ref element; this.currentOrder) {
        element = i;
      }
    }

  public:
    this(in uint nodes) {
      this.size = nodes;
    }

    @property uint size() {
      return this.nodes;
    }
    
    @property uint size(in uint newSize) {
      this.nodes = newSize;
      this.reset();
      return this.nodes;
    }

    void addEdge(in uint v, in uint u) {
      this.adjacency[v][u] = true;
      this.adjacency[u][v] = true;
    }

    bool isEdge(in uint v, in uint u) const {
      return this.adjacency[v][u];
    }

    Graph complement() const {
      Graph result = new Graph(this.nodes);
      foreach (i; 0 .. this.nodes) {
        result.adjacency[i] = this.adjacency[i].dup;
        result.adjacency[i].flip;
        result.adjacency[i][i] = false;
      }
      return result;
    }
}

unittest {
  Graph g = new Graph(3);
  assert(g.size == 3);
  g.size = 5;
  assert(g.size == 5);
  g.addEdge(0, 1);
  g.addEdge(0, 2);
  g.addEdge(0, 3);
  g.addEdge(0, 4);
  g.addEdge(1, 3);
  g.addEdge(2, 3);
  assert(g.isEdge(0, 1));
  assert(g.isEdge(1, 0));
  assert(g.isEdge(0, 0) == false);
  assert(g.isEdge(2, 4) == false);

  // Complement
  Graph g_ = g.complement();
  assert(g_.size == 5);
  assert(g_.isEdge(0, 1) == false);
  assert(g_.isEdge(1, 0) == false);
  assert(g_.isEdge(0, 0) == false);
  assert(g_.isEdge(2, 4));

  // Reordering
  g.reorder([4, 3, 1, 2, 0]);
  assert(g.size == 5);
  assert(g.isEdge(4, 0));
  assert(g.isEdge(1, 2));
  assert(g.isEdge(3, 4));
  assert(g.isEdge(3, 2) == false);
  assert(g.isEdge(0, 3) == false);

  g.reorder([4, 3, 2, 1, 0]); // actuall order is [0, 2, 1, 3, 4]
  assert(g.size == 5);
  g.addEdge(0, 1);
  g.addEdge(0, 2);
  g.addEdge(0, 3);
  g.addEdge(0, 4);
  g.addEdge(1, 3);
  g.addEdge(2, 3);
  assert(g.isEdge(0, 1));
  assert(g.isEdge(1, 0));
  assert(g.isEdge(0, 0) == false);
  assert(g.isEdge(2, 4) == false);

  // Restoring order
  assert(g.restoreOrder([]) == []);
  assert(g.restoreOrder([0]) == [0]);
  assert(g.restoreOrder([0, 1, 2]) == [0, 2, 1]);
  assert(g.restoreOrder([0, 3, 4]) == [0, 3, 4]);
}
