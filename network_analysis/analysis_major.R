# MeSH descriptors - major

# Load packages
library(igraph)
library(poweRlaw)

# Read and describe unreduced network
# Weights in the 3rd field
df <- read.table('uid2uid_major.txt', header = FALSE)
df <- df[, 1:2]
g <- graph.data.frame(df)
g <- as.undirected(g)
g <- simplify(g)
vcount(g)
ecount(g)
graph.density(g)

# Read and describe check tags reduced network
# Weights in the 3rd field
df <- read.table('uid2uid_major_ct.txt', header = FALSE)
df <- df[, 1:2]
g <- graph.data.frame(df)
g <- as.undirected(g)
g <- simplify(g)
vcount(g)
ecount(g)
graph.density(g)

# Read and describe chi-squared reduced network
df <- read.table('network_major.txt', header = FALSE)
g <- graph.data.frame(df)
g <- as.undirected(g)
g <- simplify(g)
vcount(g)
ecount(g)
graph.density(g)

# Extract giant component
cl <- clusters(g)
g.giant <- induced.subgraph(g, which(cl$membership == which.max(cl$csize)))
g.giant.edges <- as.data.frame(get.edgelist(g.giant))
write.table(g.giant.edges, file = 'giant_major.txt', col.names = FALSE, row.names = FALSE, quote = FALSE)

# Network analysis on giant component
df <- read.table('giant_major.txt', header=F)
g <- graph.data.frame(df)
g <- as.undirected(g)
g <- simplify(g)
vcount(g)
ecount(g)
graph.density(g)

# Generate random network
set.seed(12345)
g.er <- erdos.renyi.game(n = vcount(g), p.or.m = ecount(g), type = 'gnm')
# Average path length
l.my <- average.path.length(g)
l.rnd <- average.path.length(g.er)
# Clustering coefficient
c.my <- transitivity(g)
c.rnd <- transitivity(g.er)
# Small-worldness index
swi <- (c.my / c.rnd) / (l.my / l.rnd)

# Centrality measures
deg <- degree(g)
bet <- betweenness(graph = g, directed = FALSE)
clo <- closeness(g, normalized = TRUE)
ecc <- eccentricity(g)
eig <- evcent(g, directed = FALSE)
cent.df <- data.frame(degree = deg, betweenness = bet, closeness = clo, eccentricity = ecc, eigenvector = eig$vector)
write.table(cent.df, file = "centrality_measures_major.txt", row.name = FALSE, quote = FALSE)

# Try to fit power-law model
cent.df <- read.table(file = "centrality_measures_major.txt", header = TRUE)
deg <- cent.df$degree

m_pl <- displ$new(deg)
est <- estimate_xmin(m_pl)
m_pl$setXmin(est)
plot(m_pl)
lines(m_pl)

# Bootstrap test for power law
bs_p <- bootstrap_p(m_pl, no_of_sims = 2500, threads = 2)
bs_p

# Try to fit alternative distributions
# Log-normal
fit <- fitdistr(deg, "lognormal")
ks.test(deg, "plnorm", fit$estimate)
# Poisson
fit <- fitdistr(deg, "poisson")
ks.test(deg, "ppois", fit$estimate)
# Exponential
fit <- fitdistr(deg, "exponential")
ks.test(deg, "pexp", fit$estimate)
