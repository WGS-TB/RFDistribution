# RFDistribution
These codes implement an improved version of the RF distribution computation by Bryant et al.
Here, we modified the dynamic programming algorithm introduced by Bryant et al for computing the distribution of RF distance for a given tree by leveraging the Number-Theoretic Transform (NTT), and improve the running time from O(l^5) to O(l^3log(l)), where l is the number of tips of the tree.
Given an unrooted phylogenetic tree with l tips (T), the procedure for computing the RF distribution of this tree is as follow:
Denote the node adjacent to tip l in T by v_0. Remove tip l, and root the resulting tree with v_0 as the root. We use this rooted tree as the input to the dynamic programming algorithm.


