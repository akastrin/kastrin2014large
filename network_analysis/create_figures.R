library(ggplot2)
library(grid)
library(gridExtra)
library(igraph)
library(plyr)
library(poweRlaw)
library(wordcloud)
library(scales)

# Read data
df1 <- read.table('giant_all.txt', header = FALSE)
g1 <- graph.data.frame(df1)
g1 <- as.undirected(g1)
g1 <- simplify(g1)
df2 <- read.table('giant_major.txt', header = FALSE)
g2 <- graph.data.frame(df2)
g2 <- as.undirected(g2)
g2 <- simplify(g2)
df1 <- read.table(file = "centrality_measures_all.txt", header = TRUE)
df2 <- read.table(file = "centrality_measures_major.txt", header = TRUE)

# Figure 2: Degree distributions
deg1 <- df1$degree
deg2 <- df2$degree
# Power-law fit - all
m1.pl <- displ$new(deg1)
est1 <- estimate_xmin(m1.pl)
m1.pl$setXmin(est1)
# Power-law fit - major
m2.pl <- displ$new(deg2)
est2 <- estimate_xmin(m2.pl)
m2.pl$setXmin(est2)
# Plot figures
dd1 <- plot(m1.pl)
ll1 <- lines(m1.pl)
dd2 <- plot(m2.pl)
ll2 <- lines(m2.pl)
# Create left panel
plt1 <- ggplot(dd1, aes(x = x, y = y)) +
    geom_point(shape = 1, colour = "grey50", size = 1) +
    scale_x_continuous("Degree", trans=log_trans(), limits = c(1, 20000), breaks = c(1, 10, 100, 1000, 10000)) +
    scale_y_continuous("CCDF", trans = log_trans(), limits = c(3e-05, 1), breaks = c(1e-05, 1e-04, 1e-03, 1e-02, 1e-01, 1e+00),
                       labels = trans_format("log10", math_format(10^.x))) +
    theme_bw() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())
# Create right panel
plt2 <- ggplot(dd2, aes(x = x, y = y)) +
    geom_point(shape = 1, colour = "grey50", size = 1) +
    scale_x_continuous("Degree", trans=log_trans(), limits = c(1, 20000), breaks = c(1, 10, 100, 1000, 10000)) +
    scale_y_continuous("CCDF", trans = log_trans(), limits = c(3e-05, 1), breaks = c(1e-05, 1e-04, 1e-03, 1e-02, 1e-01, 1e+00),
                       labels = trans_format("log10", math_format(10^.x))) +
    theme_bw() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())
# Plot figure
grid.arrange(plt1, plt2, ncol = 2)

#Figure 3: Wordclouds
# All MeSH network
dm1 <- sort(deg1, decreasing=TRUE)[1:50]
df1 <- data.frame(uid = names(dm1), freq = dm1, row.names = NULL)
uid2mesh <- read.table('mesh_uid2name.txt', header = FALSE, sep = '|', stringsAsFactors = FALSE, quote="")
names(uid2mesh) <- c('uid', 'term')
df1 <- merge(x = df1, y = uid2mesh, by.x = 'uid', by.y = 'uid')
# Major MeSH network
dm2 <- sort(deg2, decreasing=TRUE)[1:50]
df2 <- data.frame(uid = names(dm2), freq = dm2, row.names = NULL)
uid2mesh <- read.table('mesh_uid2name.txt', header = FALSE, sep = '|', stringsAsFactors = FALSE, quote="")
names(uid2mesh) <- c('uid', 'term')
df2 <- merge(x = df2, y = uid2mesh, by.x = 'uid', by.y = 'uid')
# Plot wordclouds
set.seed(1234567)
par(mfrow = c(1, 2))
wordcloud(words = df1$term, freq = df1$freq, random.order = TRUE, scale = c(1.2, .2), rot.per = .20, colors=brewer.pal(8, "Dark2"))
wordcloud(words = df2$term, freq = df2$freq, random.order = TRUE, scale = c(2, .2), rot.per = .20, colors=brewer.pal(8, "Dark2"))

#Figure 4: Average clustering per degree
cl1 <- transitivity(graph = g1, type = "local")
cl2 <- transitivity(graph = g2, type = "local")
df1 <- data.frame(cl1, deg1)
df2 <- data.frame(cl2, deg2)
bla1 <- ddply(df1, ~deg1, summarise, mean = mean(cl1))
bla1 <- bla1[complete.cases(bla1), ]
bla2 <- ddply(df2, ~deg2, summarise, mean = mean(cl2))
bla2 <- bla2[complete.cases(bla2), ]
# Create left panel
plt1 <- ggplot(bla1, aes(x = deg1, y = mean)) +
    geom_point(shape = 1, colour = "grey50", size = 1) +
    scale_x_continuous("Degree", trans=log_trans(), limits = c(1, 20000), breaks = c(1, 10, 100, 1000, 10000)) +
    scale_y_continuous("Average Clustering", trans=log_trans(), limits = c(0.01, 1),
                       breaks = c(1e-02, 1e-01, 1e+00), labels = trans_format("log10", math_format(10^.x))) +
    theme_bw() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())
# Create right panel
plt2 <- ggplot(bla2, aes(x = deg2, y = mean)) +
    geom_point(shape = 1, colour = "grey50", size = 1) +
    scale_x_continuous("Degree", trans=log_trans(), limits = c(1, 20000), breaks = c(1, 10, 100, 1000, 10000)) +
    scale_y_continuous("Average Clustering", trans = log_trans(), limits = c(0.01, 1),
                       breaks = c(1e-02, 1e-01, 1e+00), labels = trans_format("log10", math_format(10^.x))) +
    theme_bw() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())
# Plot figure
grid.arrange(plt1, plt2, ncol = 2)
