import std.stdio;
import std.bitmanip;
import rds;
import graph;
import clique;

void main()
{
  Graph graph = new Graph(50);
  Clique c = new Clique(graph);
  uint[] result;
  RDS(c, graph, result); 
}
