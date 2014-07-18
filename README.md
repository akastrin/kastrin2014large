README
------

**Supplementary material.** Kastrin A, Rindflesch TC, Hristovski D (2014) Large-Scale Structure of a Network of Co-Occurring MeSH Terms: Statistical Analysis of Macroscopic Properties. PLoS ONE 9(7): e102188. doi:10.1371/journal.pone.0102188

### Running instructions

1. Put all provided files into the same folder.
2. Extract MEDLINE xml files into the folded `xml`.
3. Uncompress `mesh_uid2name.tar.gz` file.
4. Run `xml2txt.sh` file to process MEDLINE distribution and build `xml2txt.uid`. Update links to MEDLINE files as appropriate.
5. Run `create_network_all.sh` and `create_network_major.sh` files to build network files.
6. Run `analysis_all.R` and `analysis_major.R` files to perform network analysis.
7. Run `create_figures.R` to plot figures.

Processing the whole MEDLINE distribution takes about 2-3 days, so be patient.
