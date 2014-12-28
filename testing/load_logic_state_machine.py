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

ld_n_1        = add_node("load_n_0")
add_edge(idle, ld_n_1, " b=n,nn,(n),(nn)")

ld_r_1        = add_node("load_r_0")
add_edge(idle, ld_r_1, " b=r, rr, (r), (rr)")

ld_nn_1       = add_node("load_nn_0")
add_edge(ld_n_1, ld_nn_1, " b=nn,(nn)")

ld_indirect_1 = add_node("load_indirect")
add_edge(ld_r_1,        ld_indirect_1, " b=(r), (rr)")
add_edge(ld_n_1,        ld_indirect_1, " b=(n)")
add_edge(ld_nn_1,       ld_indirect_1, " b=(nn)")

ld_have_b     = add_node("load_have_b")
add_edge(ld_r_1,        ld_have_b, " b=r, rr")
add_edge(ld_nn_1,       ld_have_b, " b=nn")
add_edge(ld_n_1,        ld_have_b, " b=n")
add_edge(ld_indirect_1, ld_have_b, " b=(n), (nn), (r), (rr)")

ld_n_2        = add_node("load_load_n_1")
add_edge(ld_have_b, ld_n_2, " a=(n), (nn)")

ld_nn_2       = add_node("load_nn_1")
add_edge(ld_n_2, ld_nn_2, " a=(nn)")

ld_r_2          = add_node("load_r_1")
add_edge(ld_have_b, ld_r_2, " a=r, rr, (r), (rr)")

ld_have_a     = add_node("load_have_a")
add_edge(ld_n_2,    ld_have_a, " a=(n)")
add_edge(ld_nn_2,   ld_have_a, " a=(nn)")
add_edge(ld_r_2, ld_have_a, " a=(r), (rr)")

#ld_r_store = add_node("store")
#add_edge(ld_have_a, ld_r_store, " a=(n), (nn), (r), (rr)")
#add_edge(ld_r_2,    ld_r_store, " a=r, rr")
add_edge(ld_have_a, idle, " a=(n), (nn), (r), (rr)")
add_edge(ld_r_2,    idle, " a=r, rr")
#add_edge(ld_r_store,    idle, "")

graph.write_png("out.png")
