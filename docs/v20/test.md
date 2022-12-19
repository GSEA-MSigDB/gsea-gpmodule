# GSEA (v20.4.x)

Gene Set Enrichment Analysis

**Author:** Aravind Subramanian, Pablo Tamayo, David Eby; Broad
Institute

**Contact:**

[See the GSEA forum](https://groups.google.com/forum/#!forum/gsea-help)
for GSEA questions.

[Contact the GenePattern
team](http://software.broadinstitute.org/cancer/software/genepattern/contact)
for GenePattern issues.

**GSEA Version:** 4.3._x_

## Description

Evaluates a genomewide expression profile and determines whether *a
priori* defined sets of genes show statistically significant, cumulative
changes in gene expression that are correlated with a phenotype. The
phenotype may be categorical (e.g., tumor vs. normal) or continuous
(e.g., a numerical profile across all samples in the expression
dataset).

## Summary

Gene Set Enrichment Analysis (GSEA) is a powerful analytical method for
interpreting gene expression data. It evaluates cumulative changes in
the expression of groups of multiple genes defined based on prior
biological knowledge. It first ranks all genes in a data set, then
calculates an enrichment score for each gene set, which reflects how
often members of that gene set occur at the top or bottom of the ranked
data set (for example, in expression data, in either the most highly
expressed genes or the most underexpressed genes).

## Introduction

Microarray experiments profile the expression of tens of thousands of
genes over a number of samples that can vary from as few as two to
several hundreds. One common approach to analyzing these data is to
identify a limited number of the most interesting genes for closer
analysis. This usually means identifying genes with the largest changes
in their expression values based on a t-test or similar statistic, and
then picking a significance cutoff that will trim the list of
interesting genes down to a handful of genes for further research.

Gene Set Enrichment Analysis (GSEA) takes an alternative approach to
analyzing genomic data: it focuses on cumulative changes in the
expression of multiple genes as a group, which shifts the focus from
individual genes to groups of genes. By looking at several genes at
once, GSEA can identify pathways whose several genes each change a small
amount, but in a coordinated way. This approach helps reflect many of
the complexities of co-regulation and modular expression.

GSEA therefore takes as input two distinct types of data for its
analysis:

  - the gene expression data set
  - *gene sets*, where each set is comprised of a list of genes whose
    grouping together has some biological meaning; these gene sets can
    be drawn from the [Molecular Signatures Database
    (MSigDB)](http://www.gsea-msigdb.org/gsea/msigdb/index.jsp) or can be
    from other sources

The GSEA GenePattern module uses either categorical or continuous
phenotype data for its analysis. In the case of a categorical
phenotype, a dataset would contain two different classes of samples,
such as "tumor" and "normal." In the case of a continuous phenotype, a
dataset would contain a numerical value for each sample. Examples of
numerical profiles include the expression level of a specific gene or a
measure of cell viability over the course of a time series experiment.
The GSEA desktop application, available on the [GSEA
website](http://www.gsea-msigdb.org/gsea/index.jsp), has additional
functionalities. For instance, the GSEA desktop application can conduct
an enrichment analysis against a ranked list of genes, or analyze the
leading-edge subsets within each gene set. Many of these capabilities
are also available in separate GP modules (see GSEAPreranked and
GSEALeadingEdgeViewer).

**If you are using GSEA on RNA-seq data, please read [these
guidelines](http://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Using_RNA-seq_Datasets_with_GSEA).**

## Algorithm

GSEA first ranks the genes based on a measure of each gene's
differential expression with respect to the two phenotypes (for example,
tumor versus normal) or correlation with a continuous phenotype. Then
the entire ranked list is used to assess how the genes of each gene set
are distributed across the ranked list. To do this, GSEA walks down the
ranked list of genes, increasing a running-sum statistic when a gene
belongs to the set and decreasing it when the gene does not. A
simplified example is shown in the following figure.

![](./content_gseapic1.png)

The enrichment score (ES) is the maximum deviation from zero encountered
during that walk. The ES reflects the degree to which the genes in a
gene set are overrepresented at the top or bottom of the entire ranked
list of genes. A set that is not enriched will have its genes spread
more or less uniformly through the ranked list. An enriched set, on the
other hand, will have a larger portion of its genes at one or the other
end of the ranked list. The extent of enrichment is captured
mathematically as the ES statistic.

![](./content_gseapic2.png)

Next, GSEA estimates the statistical significance of the ES by a
permutation test. To do this, GSEA creates a version of the data set
with phenotype labels randomly scrambled, produces the corresponding
ranked list, and recomputes the ES of the gene set for this permuted
data set. GSEA repeats this many times (1000 is the default) and
produces an empirical null distribution of ES scores. Alternatively,
permutations may be generated by creating “random” gene sets (genes
randomly selected from those in the expression dataset) of equal size to
the gene set under analysis.

The nominal p-value estimates the statistical significance of a single
gene set's enrichment score, based on the permutation-generated null
distribution. The nominal p-value is the probability under the null
distribution of obtaining an ES value that is as strong or stronger than
that observed for your experiment under the permutation-generated null
distribution.

Typically, GSEA is run with a large number of gene sets. For example,
the MSigDB collection and subcollections each contain hundreds to
thousands of gene sets. This has implications when comparing enrichment
results for the many sets:

The ES must be adjusted to account for differences in the gene set sizes
and in correlations between gene sets and the expression data set. The
resulting normalized enrichment scores (NES) allow you to compare the
analysis results across gene sets.

The nominal p-values need to be corrected to adjust for multiple
hypothesis testing. For a large number of sets (rule of thumb: more than
30), we recommend paying attention to the False Discovery Rate (FDR)
q-values: consider a set significantly enriched if its NES has an FDR
q-value below 0.25.

For more information, see <http://www.gsea-msigdb.org/gsea>.

## Known Issues

### File names

Input expression datasets with the character '-' or spaces in their file
names causes GSEA to error.

### CLS Files

The GSEA GenePattern module interprets the sample labels in categorical
[CLS](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#CLS:_Categorical_.28e.g_tumor_vs_normal.29_class_file_format_.28.2A.cls.29)
files by their order of appearance, rather than via their numerical
value, unlike some other GenePattern modules. For example, in the CLS
file below:

    13 2 1
    # resistant sensitive
    1 1 1 1 1 1 1 1 0 0 0 0 0

Most other GenePattern modules would interpret the first 8 samples to be
sensitive and the remaining 5 to be resistant. However, GSEA assigns
resistant to the first 8 samples and sensitive to the rest. This is
because GSEA assigns the first name in the second line to the first
symbol found on the third line.

If the sample labels are in numerical order, as below, no difference in
behavior will be noted.

    13 2 1
    # resistant sensitive
    0 0 0 0 0 1 1 1 1 1 1 1 1 

## References

Subramanian A, Tamayo P, Mootha VK, Mukherjee S, Ebert BL, Gillette MA,
Paulovich A, Pomeroy SL, Golub TR, Lander ES, Mesirov JP. Gene set
enrichment analysis: A knowledge-based approach for interpreting
genome-wide expression profiles. *PNAS*. 2005;102(43);15545-15550.
([Link](http://www.pnas.org/content/102/43/15545.full.pdf.html))

Mootha VK, Lindgren CM, Eriksson K-F, Subramanian A, Sihag S, Lehar J,
Puigserver P, Carlsson E, Ridderstrale M, Laurila E, Houstis N, Daly MJ,
Patterson N, Mesivor JP, Golub TR, Tamayo P, Spiegelman B, Lander ES,
Hirschhorn JN, Altshuler D, Groop LC.  PGC-1-α responsive genes involved
in oxidative phosphorylation are coordinately downregulated in human
diabetes. *Nat Genet*. 2003;34:267-273.
([Link](http://www.nature.com/ng/journal/v34/n3/full/ng1180.html))

GSEA User Guide:
<http://www.gsea-msigdb.org/gsea/doc/GSEAUserGuideFrame.html>

GSEA website: <http://www.gsea-msigdb.org/>

This version of the module is based on the GSEA v4.1.x code base. See
the [Release
Notes](http://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/GSEA_v4.1.x_Release_Notes)
for new features and other notable changes.

## Parameters

- **Expression dataset**<span style="color:red;">*</span>
    - This is a file in either [GCT](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#GCT:_Gene_Cluster_Text_file_format_.28.2A.gct.29) or [RES](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#RES:_ExpRESsion_.28with_P_and_A_calls.29_file_format_.28.2A.res.29) format that contains the expression dataset.
[GSEA-specific TXT format](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#TXT:_Text_file_format_for_expression_dataset_.28.2A.txt.29) files are also accepted.
- **Gene sets database**<span style="color:red;">*</span>
    - This parameter's drop-down allows you to select gene sets from the [Molecular Signatures Database (MSigDB)](http://www.gsea-msigdb.org/gsea/msigdb/index.jsp) on the GSEA website. This drop-down provides access to only the most current version of MSigDB. You can also upload your own gene set file(s) in [GMT](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#GMT:_Gene_Matrix_Transposed_file_format_.28.2A.gmt.29), [GMX](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#GMX:_Gene_MatriX_file_format_.28.2A.gmx.29), or [GRP](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#GRP:_Gene_set_file_format_.28.2A.grp.29) format.
If you want to use files from an earlier version of MSigDB you will need to download them from the archived releases on the <a href="http://www.gsea-msigdb.org/gsea/downloads.jsp">website</a>.
- **Number of permutations**<span style="color:red;">*</span>
    - Specifies the number of permutations to perform in assessing the statistical significance of the enrichment score. It is best to start with a small number, such as 10, in order to check that your analysis will complete successfully (e.g., ensuring you have gene sets that satisfy the minimum and maximum size requirements and that the collapsing genes to symbols works correctly). After the analysis completes successfully, run it again with a full set of permutations. The recommended number of permutations is 1000. (Default: 1000)
- **Phenotype labels**<span style="color:red;">*</span>
    - A phenotype label file defines categorical or continuous-valued phenotypes and for each sample in your expression dataset assigns a label or numerical value for the phenotype. This is a tab-delimited text file in [CLS](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#CLS:_Categorical_.28e.g_tumor_vs_normal.29_class_file_format_.28.2A.cls.29) format. 
    - A categorical phenotype CLS file should contain only two labels, such as tumor and normal. 
    - A continuous phenotype CLS file may define one or more continuous-valued phenotypes. Each phenotype definition includes a profile, assigning a numerical value to each sample in the expression dataset.
    - GSEA interprets CLS files differently than many GenePattern modules. See the Known Issue for more details.
- **Target profile**
    - Name of the target phenotype for a continuous phenotype CLS. This parameter must be left blank in the case of a categorical CLS file.
- **Collapse dataset**<span style="color:red;">*</span>
    - Select whether to collapse each probe set in the expression dataset into a single vector for the gene, which gets identified by its gene symbol. It is also possible to remap symbols from one namespace to another without collapsing (an error will occur if multiple source genes map to a single destination gene). 
    - *No_Collapse* will use the dataset as-is, with its native feature identifiers. When you select this option, the chip annotation file (*chip platform* parameter) is ignored and you must specify a gene set file (*gene sets database file* parameter) that identify genes using the same feature (gene or probe) identifiers as is used in your expression dataset. 
    - Default: *Collapse*
- **Permutation type**<span style="color:red;">*</span>
    - Type of permutations to perform in assessing the statistical significance of the enrichment score. Options are:
      - phenotype (default): Random phenotypes are created by shuffling the phenotype labels on the samples. For each random phenotype, GSEA ranks the genes and calculates the enrichment score for all gene sets. These enrichment scores are used to create a distribution from which the significance of the actual enrichment score (for the actual expression data and gene set) is calculated. This is the recommended method when there are at least 7 samples in each phenotype. 
      - gene_set: Random gene sets, size matched to the actual gene set, are created and their enrichment scores calculated. These enrichment scores are used to create a null distribution from which the significance of the actual enrichment score (for the actual gene set) is calculated. This method is useful when you have too few samples to do phenotype permutations (that is, when you have fewer than 7 samples in any phenotype).
    - Phenotype permutation is recommended whenever possible. The phenotype permutation shuffles the phenotype labels on the samples in the dataset; it does not modify gene sets. Therefore, the correlations between the genes in the dataset and the genes in a gene set are preserved across phenotype permutations. The gene_set permutation creates random gene sets; therefore, the correlations between the genes in the dataset and the genes in the gene set are not preserved across gene_set permutations. Preserving the gene-to-gene correlation across permutations provides a more biologically reasonable (more stringent) assessment of significance.
- **Chip platform**
    - This drop-down allows you to specify the chip annotation file, which lists each probe on a chip and its matching HUGO gene symbol, used for the expression array. This parameter is required if *collapse dataset8 is set to true. The chip files listed here are from the [GSEA website](http://www.gsea-msigdb.org/gsea/downloads.jsp). If you used a file not listed here, you will need to provide it (in [CHIP](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#CHIP:_Chip_file_format_.28.2A.chip.29) format) using 'Upload your own file'. 
    - Please see the <a href="http://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/MSigDB_v7.0_Release_Notes">MSigDB 7.0 Release Notes</a> for information about symbol remapping.
- **Scoring scheme**<span style="color:red;">*</span>
    - The enrichment statistic. This parameter affects the running-sum statistic used for the enrichment analysis, controlling the value of p used in the enrichment score calculation. Options are:
      - classic Kolmorogorov-Smirnov: p=0
      - weighted (default): p=1; a running sum statistic that is incremented by the absolute value of the ranking metric when a gene belongs to the set (see the [2005 PNAS paper](http://www.pnas.org/content/102/43/15545.full.pdf.html) for details). 
      - weighted_p2: p=2 
      - weighted_p1.5: p=1.5
- **Metric for ranking genes**<span style="color:red;">*</span>
    - GSEA ranks the genes in the expression dataset and then analyzes that ranked list of genes. Use this parameter to select the metric used to score and rank the genes. The default metric for ranking genes is the *signal-to-noise ratio*. To use this metric, your expression dataset must contain at least three (3) samples for each phenotype. For descriptions of the ranking metrics, see [Metrics for Ranking Genes](http://www.gsea-msigdb.org/gsea/doc/GSEAUserGuideTEXT.htm#_Metrics_for_Ranking) in the GSEA User Guide.
- **Gene list sorting mod**<span style="color:red;">*</span>
    - Specifies whether to sort the genes using the real (default) or absolute value of the gene-ranking metric score.
- **Gene list ordering mode**<span style="color:red;">*</span>
    - Specifies the direction in which the gene list should be ordered (ascending or descending).
- **Max gene set size**<span style="color:red;">*</span>
    - After filtering from the gene sets any gene not in the expression dataset, gene sets larger than this are excluded from the analysis. Default: 500
- **Min gene set size**<span style="color:red;">*</span>
    - After filtering from the gene sets any gene not in the expression dataset, gene sets smaller than this are excluded from the analysis. Default: 15
- **Collapsing mode for probe sets with more than one match**<span style="color:red;">*</span>
    - Collapsing mode for sets of multiple probes for a single gene. Used only when the *collapse dataset* parameter is set to *Collapse*. Select the expression values to use for the single probe that will represent all probe sets for the gene. Options are:
      - Max_probe (default): For each sample, use the maximum expression value for the probe set. That is, if there are three probes that map to a single gene, the expression value that will represent the collapsed probe set will be the maximum expression value from those three probes. 
      - Median_of_probes: For each sample, use the median expression value for the probe set.
      - Mean_of_probes: For each sample, use the mean expression value for the probe set.
      - Sum_of_probes: For each sample, sum all the expression values of the probe set.
      - Abs_max_of_probes: For each sample, use the expression value for the probe set with the maximum **absolute value**. Note that each value retains its original sign but is chosen based on absolute value. In other words, the largest magnitude value is used. While this method is useful with computational-based input datasets it is generally **not recommended** for use with quantification-based expression measures such as counts or microarray fluorescence.
- **Normalization mode**<span style="color:red;">*</span>
    - Method used to normalize the enrichment scores across analyzed gene sets. Options are:
      - meandiv (default): GSEA normalizes the enrichment scores as described in [Normalized Enrichment Score (NES)](http://www.gsea-msigdb.org/gsea/doc/GSEAUserGuideTEXT.htm#_Normalized_Enrichment_Score) in the GSEA User Guide. 
      - None: GSEA does not normalize the enrichment scores.
- **Randomization mode**<span style="color:red;">*</span>
    - Method used to randomly assign phenotype labels to samples for phenotype permutations. ONLY used for phenotype permutations. Options are:
      - no_balance (default): Permutes labels without regard to number of samples per phenotype. For example, if your dataset has 12 samples in phenotype_a and 10 samples in phenotype_b, any permutation of phenotype_a has 12 samples randomly chosen from the dataset. 
      - equalize_and_balance: Permutes labels by equalizing the number of samples per phenotype and then balancing the number of samples contributed by each phenotype. For example, if your dataset has 12 samples in phenotype_a and 10 samples in phenotype_b, any permutation of phenotype_a has 10 samples: 5 randomly chosen from phenotype_a and 5 randomly chosen from phenotype_b.
- **Omit features with no symbol match**<span style="color:red;">*</span>
    - Used only when *collapse dataset* is set to *Collapse*. By default (*true*), the new dataset excludes probes/genes that have no gene symbols. Set to *false* to have the new dataset contain all probes/genes that were in the original dataset.
- **Make detailed gene set report**<span style="color:red;">*</span>
    - Create detailed gene set report (heat map, mountain plot, etc.) for each enriched gene set. Default: true
- **Median for class metrics**<span style="color:red;">*</span>
    - Specifies whether to use the median of each class, instead of the mean, in the *metric for ranking genes*. Default: false
- **Number of markers**<span style="color:red;">*</span>
    - Number of features (gene or probes) to include in the butterfly plot in the Gene Markers section of the gene set enrichment report. Default: 100
- **Plot graphs for the top sets of each phenotype**<span style="color:red;">*</span>
    - Generates summary plots and detailed analysis results for the top x genes in each phenotype, where x is 20 by default. The top genes are those with the largest normalized enrichment scores. Default: 20
- **Random seed**<span style="color:red;">*</span>
    - Seed used to generate a random number for phenotype and gene_set permutations. Timestamp is the default. Using a specific integer valued seed generates consistent results, which is useful when testing software.
- **Save random ranked lists**<span style="color:red;">*</span>
    - Specifies whether to save the random ranked lists of genes created by phenotype permutations. When you save random ranked lists, for each permutation, GSEA saves the rank metric score for each gene (the score used to position the gene in the ranked list). Saving random ranked lists is **very memory intensive**; therefore, this parameter is set to false by default.
- **Output file name**<span style="color:red;">*</span>
    - Name of the output file. The name cannot include spaces. Default: &lt;expression.dataset_basename&gt;.zip
- **Create svgs**<span style="color:red;">*</span>
    - Whether to create SVG images (compressed) along with PNGs. Saving PNGs requires **a lot of storage**; therefore, this parameter is set to false by default.
- **Selected gene sets**
    - Semicolon-separated list of gene sets from the provided gene sets database files (GMT/GMX/GRP). If you are using multiple files then you **must** prefix each selected gene set with its file name followed by '#' (like "my_file1.gmt#selected_gene_set1,my_file2.gmt#selected_gene_set2"). With a single file only the names are necessary. Leave this blank to select all gene sets.
- **Alt delim**
    - Optional alternate delimiter character for gene set names instead of comma for use with selected.gene.sets. If used, a semicolon is recommended.
- **Create gcts**<span style="color:red;">*</span>
    - Whether to save the dataset subsets backing the GSEA report heatmaps as GCT files; these will be subsets of your original dataset corresponding only to the genes of the heatmap.

<span style="color:red;">*</span> = required

## Input Files

1. *expression
dataset:* [GCT](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#GCT:_Gene_Cluster_Text_file_format_.28.2A.gct.29)
or
[RES](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#RES:_ExpRESsion_.28with_P_and_A_calls.29_file_format_.28.2A.res.29)
file

This file contains the expression dataset.

2. *gene sets
database:* [GMT](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#GMT:_Gene_Matrix_Transposed_file_format_.28.2A.gmt.29),
[GMX](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#GMX:_Gene_MatriX_file_format_.28.2A.gmx.29),
or
[GRP](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#GRP:_Gene_set_file_format_.28.2A.grp.29)
file.

Gene set files, either your own or from the listed MSigDB files.

3. *phenotype
labels:* [CLS](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#Phenotype_Data_Formats)
file

The GSEA module supports two kinds of class (CLS) files: categorical
phenotype and continuous phenotype.

A categorical phenotype CLS file must define a single phenotype having
two categorical labels, such as tumor and normal.

A continuous phenotype CLS may define multiple phenotypes. Each
phenotype definition assigns a numerical value for each sample. This
series of values defines the phenotype profile. For example,

  - For a continuous phenotype representing the expression levels of a
    gene of interest, the value for each sample is the expression value
    of the gene.
  - For a continuous phenotype representing cell viability in a time
    series experiment, the value for each sample is a measure of cell
    viability at a distinct time in the experiment.

4\. *chip platform:* an
optional [CHIP](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#CHIP:_Chip_file_format_.28.2A.chip.29)
file may be provided if you do not select a *chip platform* from the
drop-down

## Output Files

1. Enrichment Report archive: ZIP

ZIP file containing the result files. For more information on
interpreting these results, see [Interpreting GSEA
Results](http://www.gsea-msigdb.org/gsea/doc/GSEAUserGuideTEXT.htm#_Interpreting_GSEA_Results)
in the GSEA User Guide. Note that in prior versions the ZIP bundle was
created as the only output file. This behavior has been changed to give
direct access to the results without the need for a download.

2. Enrichment Report: HTML and PNG images

The GSEA Enrichment Report. As above, see the GSEA User Guide for more
info.

3. Optional SVG images (compressed)

Identical to the PNGs in the Enrichment Report, but in SVG format for
higher resolution. These are GZ compressed to reduce space usage; they
can be decompressed using 'gunzip' on Mac or Linux and 7-Zip on Windows

4. Optional GCTs

The datasets backing all the heatmap images from the Enrichment Report
for use in external visualizers or analysis tools. These will have the
same name as the corresponding image but instead with a GCT extension.
When Collapse or Remap_Only is set, the collapsed dataset is also saved 
as a GCT. These files will be created if the Create GCTs option is true.

## Platform Dependencies

**Task Type:**  
Gene List Selection

**CPU Type:**  
any

**Operating System:**  
any

**Language:**  
Java

## Version Comments

- **20.4.0** (2022-10-2): Updated to Human MSigDB v2022.1.Hs and Mouse MSigDB 2022.1.Mm.
- **20.3.6** (2022-9-15): Updated to Human MSigDB v2022.1.Hs. Direct support for Mouse MSigDB 2022.1.Mm is not yet available
- **20.3.5** (2022-3-22) Removed Log4J entirely from the code base. Fixed weighted_p1.5 computation. Added min dataset size warnings.
- **20.3.4** (2022-1-20): Updated Log4J to 2.17.1.
_ **20.3.3** (2022-1-19): Updated to MSigDB v7.5.1.
- **20.3.2** (2022-1-12): Updated to MSigDB v7.5. 
- **20.3.1** (2021-12-23): Updated with the GSEA Desktop 4.2.1 code base. Updated to Log4J 2.17.0. TXT file parser bug fix.
- **20.3.0** (2021-12-17): Updated with the GSEA Desktop 4.2.0 code base with numerous bug fixes. Adds the Abs_max_of_probes collapse mode. Fixed some issues handling datasets with missing values. Added the Spearman metric. Fixed issue with the min-sample check with gene_set permutation mode. Improved warnings and logging. Changed the FDR q-value scale on the NES vs Significance plot. Fixed bugs in weighted_p1.5 scoring.
- **20.2.4** (2021-4-22): Fixed minor typo.
- **20.2.3** (2021-4-2): Updated to MSigDB v7.4.
- **20.2.2** (2021-3-22): Updated to MSigDB v7.3.
- **20.2.1** (2020-10-27): Fixed a bug in the Collapse Sum mode.
- **20.2.0** (2020-9-23): Updated to MSigDB v7.2. Updated to use dedicated Docker container.
- **20.1.0** (2020-7-30): Updated to use the GSEA v4.1.0 code base.
- **20.0.5** (2020-4-2): Updated to use the GSEA v4.0.3 code base. Updated to give access to MSigDB v7.1.
- **20.0.4** (2019-11-19): Minor documentation update.
- **20.0.3** (2019-10-24): Updated to use the GSEA v4.0.2 code base. Updated to give access to MSigDB v7.0. OpenJDK 11 port. Java code moved into the GSEA Desktop code base.
- **19.0.26** (2019-10-10): Updated to use the GSEA v3.0 open-source code base. Updated to give access to MSigDB v6.2. Unified the Gene Set DB selector parameters and better downloading of MSigDB files. Added selected.gene.sets, alt.delim, creat.gcts and create.svgs parameters. Better temp file clean-up and other internal code improvements.
- **18** (2017-05-18): Updated to give access to MSigDB v6.0
- **17** (2016-02-04) Updated to give access to MSigDB v5.1
- **16** (2015-12-03): Updating the GSEA jar to deal with an issue with FTP access. Fixes an issue for GP@IU.
- **15** (2015-06-16): Add built-in support for MSigDB v5.0, which includes new hallmark gene sets.
- **14** (2013-06-14): Update the gene sets database list and the GSEA Java library, added support for continuous phenotypes. 
- **13** (2012-09-20): Updated and sorted the chip platforms list, changed default value of num permutations to 1000, and updated the GSEA java library.
- **12** (2011-04-08): Fixed parsing of gene sets database file names which contain @ and # symbols and added gene sets containing entrez ids.
- **11** (2010-11-05): Fixed parsing of chip platform file names which contain @ and # symbols.
- **10** (2010-10-01): Updated selections for the gene sets database parameter to reflect those available in MSigDB version 3.

Copyright © 2003-2022 Broad Institute, Inc., Massachusetts Institute of
Technology, and Regents of the University of California. All rights
reserved.

