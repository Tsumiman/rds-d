import structure;
import graph;
import std.datetime.stopwatch;
import std.stdio;
import std.parallelism;
import std.range;

void logParallelism() {
  writefln("There are %s cores on this system.", totalCPUs);
}

void RDS_parallel(in Structure S, in Graph G, out uint[] R) {
  logParallelism();
  uint nodes = G.size;
  uint[] mu;
  uint lowerBound;
  foreach (v; parallel(nodes.iota)) {
    uint[] candidates;
    uint candidatesWeight;
    foreach (u; v+1 .. nodes) {
      if (S.checkPair(v, u)) {
        candidates ~= u;
        candidatesWeight += 1;
      }
    }
    
    uint[] current = [v];
    uint currentWeight = 1;
    uint sol = findMax(S, G, R, candidates, candidatesWeight, current, currentWeight, mu);
  }
  writeln(lowerBound);
}

void RDS(in Structure S, in Graph G, out uint[] R) {
  StopWatch sw;
  sw.start();
  RDS_parallel(S, G, R);
  sw.stop();
}
