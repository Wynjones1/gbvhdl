#!/usr/bin/env python2.7
import pydot
graph = pydot.Dot(graph_type="digraph")

def add_node(name):
    add_node.counter += 1
    node = pydot.Node("%s" % add_node.counter, label=name)
    graph.add_node(node)
    return node
add_node.counter = 0

def add_edge(node0, node1, label):
    graph.add_edge(pydot.Edge(node0, node1, label=label))


idle          = add_node("idle")
alu_indirect  = add_node("indirect")
alu_register  = add_node("register")
alu_immediate = add_node("immediate")
add_edge(idle, alu_indirect,  " indirect");
add_edge(idle, alu_register,  " register");
add_edge(idle, alu_immediate, " immediate");
add_edge(alu_register,  idle);
add_edge(alu_indirect,  idle);
add_edge(alu_immediate, idle);

graph.write_png("out.png")
