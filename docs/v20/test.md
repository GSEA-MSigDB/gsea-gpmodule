# GSEA (v20.3.x)

Gene Set Enrichment Analysis

**Author:** Aravind Subramanian, Pablo Tamayo, David Eby; Broad
Institute

**Contact:**

[See the GSEA forum](https://groups.google.com/forum/#!forum/gsea-help)
for GSEA questions.

[Contact the GenePattern
team](http://software.broadinstitute.org/cancer/software/genepattern/contact)
for GenePattern issues.

**GSEA Version:** 4.2.1

## Description

Evaluates a genomewide expression profile and determines whether *a
priori* defined sets of genes show statistically significant, cumulative
changes in gene expression that are correlated with a phenotype.  The
phenotype may be categorical (e.g., tumor vs. normal) or continuous
(e.g., a numerical profile across all samples in the expression
dataset).

## Summary

Gene Set Enrichment Analysis (GSEA) is a powerful analytical method for
interpreting gene expression data.  It evaluates cumulative changes in
the expression of groups of multiple genes defined based on prior
biological knowledge.  It first ranks all genes in a data set, then
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
individual genes to groups of genes.  By looking at several genes at
once, GSEA can identify pathways whose several genes each change a small
amount, but in a coordinated way.  This approach helps reflect many of
the complexities of co-regulation and modular expression.

GSEA therefore takes as input two distinct types of data for its
analysis:

  - the gene expression data set
  - *gene set*s, where each set is comprised of a list of genes whose
    grouping together has some biological meaning; these gene sets can
    be drawn from the [Molecular Signatures Database
    (MSigDB)](http://www.gsea-msigdb.org/gsea/msigdb/index.jsp)or can be
    from other sources

The GSEA GenePattern module uses either categorical or continuous
phenotype data for its analysis.  In the case of a categorical
phenotype, a dataset would contain two different classes of samples,
such as "tumor" and "normal."  In the case of a continuous phenotype, a
dataset would contain a numerical value for each sample.  Examples of
numerical profiles include the expression level of a specific gene or a
measure of cell viability over the course of a time series experiment.
The GSEA desktop application, available on the [GSEA
website](http://www.gsea-msigdb.org/gsea/index.jsp), has additional
functionalities.  For instance, the GSEA desktop application can conduct
an enrichment analysis against a ranked list of genes, or analyze the
leading-edge subsets within each gene set.  Many of these capabilities
are also available in separate GP modules (see GSEAPreranked and
GSEALeadingEdgeViewer). 

**If you are using GSEA on RNA-seq data, please read [these
guidelines](http://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Using_RNA-seq_Datasets_with_GSEA).**

## Algorithm

GSEA first ranks the genes based on a measure of each gene's
differential expression with respect to the two phenotypes (for example,
tumor versus normal) or correlation with a continuous phenotype.  Then
the entire ranked list is used to assess how the genes of each gene set
are distributed across the ranked list.  To do this, GSEA walks down the
ranked list of genes, increasing a running-sum statistic when a gene
belongs to the set and decreasing it when the gene does not.  A
simplified example is shown in the following figure.

![](./content_gseapic1.png)

The enrichment score (ES) is the maximum deviation from zero encountered
during that walk.  The ES reflects the degree to which the genes in a
gene set are overrepresented at the top or bottom of the entire ranked
list of genes.  A set that is not enriched will have its genes spread
more or less uniformly through the ranked list.  An enriched set, on the
other hand, will have a larger portion of its genes at one or the other
end of the ranked list. The extent of enrichment is captured
mathematically as the ES statistic.

![](./content_gseapic2.png)

Next, GSEA estimates the statistical significance of the ES by a
permutation test.  To do this, GSEA creates a version of the data set
with phenotype labels randomly scrambled, produces the corresponding
ranked list, and recomputes the ES of the gene set for this permuted
data set. GSEA repeats this many times (1000 is the default) and
produces an empirical null distribution of ES scores.  Alternatively,
permutations may be generated by creating “random” gene sets (genes
randomly selected from those in the expression dataset) of equal size to
the gene set under analysis.

 The nominal p-value estimates the statistical significance of a single
gene set's enrichment score, based on the permutation-generated null
distribution.  The nominal p-value is the probability under the null
distribution of obtaining an ES value that is as strong or stronger than
that observed for your experiment under the permutation-generated null
distribution.

Typically, GSEA is run with a large number of gene sets.  For example,
the MSigDB collection and subcollections each contain hundreds to
thousands of gene sets.  This has implications when comparing enrichment
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
[CLS](http://www.broadinstitute.org/cancer/software/genepattern/gp_guides/file-formats/sections/cls)
files by their order of appearance, rather than via their numerical
value, unlike some other GenePattern modules. For example, in the CLS
file below:

13 2 1

\# resistant sensitive

1 1 1 1 1 1 1 1 0 0 0 0 0

Most other GenePattern modules would interpret the first 8 samples to be
sensitive and the remaining 5 to be resistant. However, GSEA assigns
resistant to the first 8 samples and sensitive to the rest. This is
because GSEA assigns the first name in the second line to the first
symbol found on the third line.

If the sample labels are in numerical order, as below, no difference in
behavior will be noted.

13 2 1

\# resistant sensitive

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
([link](http://www.nature.com/ng/journal/v34/n3/full/ng1180.html))

GSEA User Guide:
<http://www.gsea-msigdb.org/gsea/doc/GSEAUserGuideFrame.html>

GSEA website: <http://www.gsea-msigdb.org/>

This version of the module is based on the GSEA v4.1.x code base. See
the [Release
Notes](http://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/GSEA_v4.1.x_Release_Notes)
for new features and other notable changes.

## Parameters

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Name</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">expression dataset <span style="color:red;">*</span></td>
<td align="left">This is a file in either <a href="http://www.broadinstitute.org/cancer/software/genepattern/gp_guides/file-formats/sections/gct">GCT</a> or <a href="http://www.broadinstitute.org/cancer/software/genepattern/gp_guides/file-formats/sections/res">RES</a> format that contains the expression dataset. </td>
</tr>
<tr class="even">
<td align="left">gene sets database <span style="color:red;">*</span></td>
<td align="left"><p>This parameter's drop-down allows you to select gene sets from the <a href="http://www.gsea-msigdb.org/gsea/msigdb/index.jsp">Molecular Signatures Database (MSigDB)</a>on the GSEA website.  This drop-down provides access to only the most current version of MSigDB.  You can also upload your own gene set file(s) in <a href="http://www.broadinstitute.org/cancer/software/genepattern/gp_guides/file-formats/sections/gmt">GMT</a>, <a href="http://www.broadinstitute.org/cancer/software/genepattern/gp_guides/file-formats/sections/gmx">GMX</a>, or <a href="http://www.broadinstitute.org/cancer/software/genepattern/gp_guides/file-formats/sections/grp">GRP</a> format. </p>
If you want to use files from an earlier version of MSigDB you will need to download them from the archived releases on the <a href="http://www.gsea-msigdb.org/gsea/downloads.jsp">website</a>.</td>
</tr>
<tr class="odd">
<td align="left">number of permutations <span style="color:red;">*</span></td>
<td align="left">Specifies the number of permutations to perform in assessing the statistical significance of the enrichment score. It is best to start with a small number, such as 10, in order to check that your analysis will complete successfully (e.g., ensuring you have gene sets that satisfy the minimum and maximum size requirements and that the collapsing genes to symbols works correctly). After the analysis completes successfully, run it again with a full set of permutations. The recommended number of permutations is 1000. Default: 1000</td>
</tr>
<tr class="even">
<td align="left">phenotype labels <span style="color:red;">*</span></td>
<td align="left"><p>A phenotype label file defines categorical or continuous-valued phenotypes and for each sample in your expression dataset assigns a label or numerical value for the phenotype.  This is a tab-delimited text file in <a href="http://www.broadinstitute.org/cancer/software/genepattern/gp_guides/file-formats/sections/cls">CLS</a> format.</p>
<p>A categorical phenotype CLS file should contain only two labels, such as tumor and normal.</p>
<p>A continuous phenotype CLS file may define one or more continuous-valued phenotypes.  Each phenotype definition includes a profile, assigning a numerical value to each sample in the expression dataset.</p>
GSEA interprets CLS files differently than many GenePattern modules.  See the Known Issue for more details.</td>
</tr>
<tr class="odd">
<td align="left">target profile</td>
<td align="left">Name of the target phenotype for a continuous phenotype CLS. This parameter must be left blank in the case of a categorical CLS file.</td>
</tr>
<tr class="even">
<td align="left">collapse dataset <span style="color:red;">*</span></td>
<td align="left"><p>Select whether to collapse each probe set in the expression dataset into a single vector for the gene, which gets identified by its gene symbol. It is also possible to remap symbols from one namespace to another without collapsing (an error will occur if multiple source genes map to a single destination gene).</p>
<p><em>No_Collapse</em> will use the dataset as-is, with its native feature identifiers. When you select this option, the chip annotation file (<em>chip platform</em> parameter) is ignored and you must specify a gene set file (<em>gene sets database file</em> parameter) that identify genes using the same feature (gene or probe) identifiers as is used in your expression dataset.</p>
Default: <em>Collapse</em></td>
</tr>
<tr class="odd">
<td align="left">permutation type <span style="color:red;">*</span></td>
<td align="left"><p>Type of permutations to perform in assessing the statistical significance of the enrichment score. Options are:</p>
<ul>
<li>phenotype (default): Random phenotypes are created by shuffling the phenotype labels on the samples. For each random phenotype, GSEA ranks the genes and calculates the enrichment score for all gene sets. These enrichment scores are used to create a distribution from which the significance of the actual enrichment score (for the actual expression data and gene set) is calculated. This is the recommended method when there are at least 7 samples in each phenotype.</li>
<li>gene_set: Random gene sets, size matched to the actual gene set, are created and their enrichment scores calculated. These enrichment scores are used to create a null distribution from which the significance of the actual enrichment score (for the actual gene set) is calculated. This method is useful when you have too few samples to do phenotype permutations (that is, when you have fewer than 7 samples in any phenotype).</li>
</ul>
Phenotype permutation is recommended whenever possible. The phenotype permutation shuffles the phenotype labels on the samples in the dataset; it does not modify gene sets. Therefore, the correlations between the genes in the dataset and the genes in a gene set are preserved across phenotype permutations. The gene_set permutation creates random gene sets; therefore, the correlations between the genes in the dataset and the genes in the gene set are not preserved across gene_set permutations. Preserving the gene-to-gene correlation across permutations provides a more biologically reasonable (more stringent) assessment of significance.</td>
</tr>
<tr class="even">
<td align="left">chip platform</td>
<td align="left"><p>This drop-down allows you to specify the chip annotation file, which lists each probe on a chip and its matching HUGO gene symbol, used for the expression array.  This parameter is required if <em>collapse dataset </em>is set to true.  The chip files listed here are from the GSEA website: <a href="http://www.gsea-msigdb.org/gsea/downloads.jsp" class="uri">http://www.gsea-msigdb.org/gsea/downloads.jsp</a>.  If you used a file not listed here, you will need to provide it (in<span style="background-color: rgb(239, 239, 239);"> </span><a href="http://www.broadinstitute.org/cancer/software/genepattern/gp_guides/file-formats/sections/chip">CHIP</a> format) using 'Upload your own file'.</p>
<p>Please see the <a href="http://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/MSigDB_v7.0_Release_Notes">MSigDB 7.0 Release Notes</a> for information about symbol remapping.</p></td>
</tr>
<tr class="odd">
<td align="left">scoring scheme <span style="color:red;">*</span></td>
<td align="left"><p>The enrichment statistic.  This parameter affects the running-sum statistic used for the enrichment analysis, controlling the value of p used in the enrichment score calculation.  Options are:</p>
<ul>
<li>classic Kolmorogorov-Smirnov: p=0</li>
<li>weighted (default): p=1; a running sum statistic that is incremented by the absolute value of the ranking metric when a gene belongs to the set (see the <a href="http://www.pnas.org/content/102/43/15545.full.pdf.html">2005 PNAS paper</a> for details)</li>
<li>weighted_p2: p=2</li>
<li>weighted_p1.5: p=1.5</li>
</ul></td>
</tr>
<tr class="even">
<td align="left">metric for ranking genes <span style="color:red;">*</span></td>
<td align="left"><p>GSEA ranks the genes in the expression dataset and then analyzes that ranked list of genes. Use this parameter to select the metric used to score and rank the genes. The default metric for ranking genes is the <em>signal-to-noise ratio</em>. To use this metric, your expression dataset must contain at least three (3) samples for each phenotype.</p>
For descriptions of the ranking metrics, see <a href="http://www.gsea-msigdb.org/gsea/doc/GSEAUserGuideTEXT.htm#_Metrics_for_Ranking">Metrics for Ranking Genes</a> in the GSEA User Guide.</td>
</tr>
<tr class="odd">
<td align="left">gene list sorting mode <span style="color:red;">*</span></td>
<td align="left">Specifies whether to sort the genes using the real (default) or absolute value of the gene-ranking metric score.</td>
</tr>
<tr class="even">
<td align="left">gene list ordering mode <span style="color:red;">*</span></td>
<td align="left">Specifies the direction in which the gene list should be ordered (ascending or descending).</td>
</tr>
<tr class="odd">
<td align="left">max gene set size <span style="color:red;">*</span></td>
<td align="left">After filtering from the gene sets any gene not in the expression dataset, gene sets larger than this are excluded from the analysis. Default: 500</td>
</tr>
<tr class="even">
<td align="left">min gene set size <span style="color:red;">*</span></td>
<td align="left">After filtering from the gene sets any gene not in the expression dataset, gene sets smaller than this are excluded from the analysis. Default: 15</td>
</tr>
<tr class="odd">
<td align="left">collapsing mode for probe sets with more than one match <span style="color:red;">*</span></td>
<td align="left"><p>Collapsing mode for sets of multiple probes for a single gene. Used only when the <em>collapse dataset</em> parameter is set to <em>Collapse</em>. Select the expression values to use for the single probe that will represent all probe sets for the gene. Options are:</p>
<ul>
<li>Max_probe (default): For each sample, use the maximum expression value for the probe set.  That is, if there are three probes that map to a single gene, the expression value that will represent the collapsed probe set will be the maximum expression value from those three probes.</li>
<li>Median_of_probes: For each sample, use the median expression value for the probe set.</li>
<li>Mean_of_probes: For each sample, use the mean expression value for the probe set.</li>
<li>Sum_of_probes: For each sample, sum all the expression values of the probe set.</li>
<li>Abs_max_of_probes: For each sample, use the expression value for the probe set with the maximum **absolute value**.  Note that each value retains its original sign but is chosen based on absolute value.
In other words, the largest magnitude value is used.  While this method is useful with computational-based input datasets it is generally **not recommended** for use with quantification-based expression 
measures such as counts or microarray fluorescence.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left">normalization mode <span style="color:red;">*</span></td>
<td align="left"><p>Method used to normalize the enrichment scores across analyzed gene sets. Options are:</p>
<ul>
<li>meandiv (default): GSEA normalizes the enrichment scores as described in<a href="http://www.gsea-msigdb.org/gsea/doc/GSEAUserGuideTEXT.htm#_Normalized_Enrichment_Score">Normalized Enrichment Score (NES)</a> in the GSEA User Guide.</li>
<li>None: GSEA does not normalize the enrichment scores.</li>
</ul></td>
</tr>
<tr class="odd">
<td align="left">randomization mode <span style="color:red;">*</span></td>
<td align="left"><p>Method used to randomly assign phenotype labels to samples for phenotype permutations. ONLY used for phenotype permutations. Options are:</p>
<ul>
<li>no_balance (default): Permutes labels without regard to number of samples per phenotype. For example, if your dataset has 12 samples in phenotype_a and 10 samples in phenotype_b, any permutation of phenotype_a has 12 samples randomly chosen from the dataset.</li>
<li>equalize_and_balance: Permutes labels by equalizing the number of samples per phenotype and then balancing the number of samples contributed by each phenotype. For example, if your dataset has 12 samples in phenotype_a and 10 samples in phenotype_b, any permutation of phenotype_a has 10 samples: 5 randomly chosen from phenotype_a and 5 randomly chosen from phenotype_b.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left">omit features with no symbol match <span style="color:red;">*</span></td>
<td align="left">Used only when <em>collapse dataset</em> is set to <em>Collapse</em>. By default (<em>true</em>), the new dataset excludes probes/genes that have no gene symbols. Set to <em>false</em> to have the new dataset contain all probes/genes that were in the original dataset. </td>
</tr>
<tr class="odd">
<td align="left">make detailed gene set report <span style="color:red;">*</span></td>
<td align="left">Create detailed gene set report (heat map, mountain plot, etc.) for each enriched gene set. Default: true</td>
</tr>
<tr class="even">
<td align="left">median for class metrics <span style="color:red;">*</span></td>
<td align="left">Specifies whether to use the median of each class, instead of the mean, in the <em>metric for ranking genes</em>. Default: false</td>
</tr>
<tr class="odd">
<td align="left">number of markers <span style="color:red;">*</span></td>
<td align="left">Number of features (gene or probes) to include in the butterfly plot in the Gene Markers section of the gene set enrichment report. Default: 100</td>
</tr>
<tr class="even">
<td align="left">plot graphs for the top sets of each phenotype <span style="color:red;">*</span></td>
<td align="left">Generates summary plots and detailed analysis results for the top x genes in each phenotype, where x is 20 by default. The top genes are those with the largest normalized enrichment scores. Default: 20</td>
</tr>
<tr class="odd">
<td align="left">random seed <span style="color:red;">*</span></td>
<td align="left">Seed used to generate a random number for phenotype and gene_set permutations. Timestamp is the default. Using a specific integer valued seed generates consistent results, which is useful when testing software. </td>
</tr>
<tr class="even">
<td align="left">save random ranked lists <span style="color:red;">*</span></td>
<td align="left">Specifies whether to save the random ranked lists of genes created by phenotype permutations. When you save random ranked lists, for each permutation, GSEA saves the rank metric score for each gene (the score used to position the gene in the ranked list). Saving random ranked lists is <strong>very memory intensive</strong>; therefore, this parameter is set to false by default. </td>
</tr>
<tr class="odd">
<td align="left">output file name <span style="color:red;">*</span></td>
<td align="left">Name of the output file. The name cannot include spaces. Default: &lt;expression.dataset_basename&gt;.zip</td>
</tr>
<tr class="even">
<td align="left">create svgs <span style="color:red;">*</span></td>
<td align="left">Whether to create SVG images (compressed) along with PNGs. Saving PNGs requires <strong>a lot of storage</strong>; therefore, this parameter is set to false by default. </td>
</tr>
<tr class="odd">
<td align="left">selected gene sets</td>
<td align="left">Semicolon-separated list of gene sets from the provided gene sets database files (GMT/GMX/GRP). If you are using multiple files then you <strong>must</strong> prefix each selected gene set with its file name followed by '#' (like &quot;my_file1.gmt#selected_gene_set1,my_file2.gmt#selected_gene_set2&quot;). With a single file only the names are necessary. Leave this blank to select all gene sets. </td>
</tr>
<tr class="even">
<td align="left">alt delim</td>
<td align="left">Optional alternate delimiter character for gene set names instead of comma for use with selected.gene.sets. If used, a semicolon is recommended. </td>
</tr>
<tr class="odd">
<td align="left">create gcts <span style="color:red;">*</span></td>
<td align="left">Whether to save the dataset subsets backing the GSEA report heatmaps as GCT files; these will be subsets of your original dataset corresponding only to the genes of the heatmap. </td>
</tr>
</tbody>
</table>

\* - required

## Input Files

1\. *expression
dataset: *[GCT](http://www.broadinstitute.org/cancer/software/genepattern/gp_guides/file-formats/sections/gct)
or
[RES](http://www.broadinstitute.org/cancer/software/genepattern/gp_guides/file-formats/sections/res)
file

This file contains the expression dataset.

2\. *gene sets
database:* [GMT](http://www.broadinstitute.org/cancer/software/genepattern/gp_guides/file-formats/sections/gmt),
[GMX](http://www.broadinstitute.org/cancer/software/genepattern/gp_guides/file-formats/sections/gmx),
or
[GRP](http://www.broadinstitute.org/cancer/software/genepattern/gp_guides/file-formats/sections/grp)
file.

Gene set files, either your own or from the listed MSigDB files.

3\. *phenotype
labels:* [CLS](http://www.broadinstitute.org/cancer/software/genepattern/gp_guides/file-formats/sections/cls)
file

The GSEA module supports two kinds of class (CLS) files: categorical
phenotype and continuous phenotype. 

A categorical phenotype CLS file must define a single phenotype having
two categorical labels, such as tumor and normal. 

A continuous phenotype CLS may define multiple phenotypes.  Each
phenotype definition assigns a numerical value for each sample.  This
series of values defines the phenotype profile.  For example,

  - For a continuous phenotype representing the expression levels of a
    gene of interest, the value for each sample is the expression value
    of the gene.
  - For a continuous phenotype representing cell viability in a time
    series experiment, the value for each sample is a measure of cell
    viability at a distinct time in the experiment.

4\. *chip platform:* an
optional [CHIP](http://www.broadinstitute.org/cancer/software/genepattern/gp_guides/file-formats/sections/chip)
file may be provided if you do not select a *chip platform* from the
drop-down

## Output Files

1\. Enrichment Report archive: ZIP

ZIP file containing the result files.  For more information on
interpreting these results, see [Interpreting GSEA
Results](http://www.gsea-msigdb.org/gsea/doc/GSEAUserGuideTEXT.htm#_Interpreting_GSEA_Results)
in the GSEA User Guide. Note that in prior versions the ZIP bundle was
created as the only output file. This behavior has been changed to give
direct access to the results without the need for a download.

2\. Enrichment Report: HTML and PNG images

The GSEA Enrichment Report.  As above, see the GSEA User Guide for more
info.

3\. Optional SVG images (compressed)

Identical to the PNGs in the Enrichment Report, but in SVG format for
higher resolution. These are GZ compressed to reduce space usage; they
can be decompressed using 'gunzip' on Mac or Linux and 7-Zip on Windows

3\. Optional GCTs

The datasets backing all the heatmap images from the Enrichment Report
for use in external visualizers or analysis tools. These will have the
same name as the corresponding image but instead with a GCT extension.
When Collapse or Remap_Only is set, the collapsed dataset is also saved 
as a GCT.  These files will be created if the Create GCTs option is true.

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

<table>
<thead>
<tr class="header">
<th align="left">Version</th>
<th align="left">Release Date</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">20.3.3</td>
<td align="left">2022-1-19</td>
<td align="left">Updated to MSigDB v7.5.1.</td>
</tr>
<tr class="even">
<td align="left">20.3.2</td>
<td align="left">2022-1-12</td>
<td align="left">Updated to MSigDB v7.5.</td>
</tr>
<tr class="odd">
<td align="left">20.3.1</td>
<td align="left">2021-12-23</td>
<td align="left">Updated with the GSEA Desktop 4.2.1 code base. Updated to Log4J 2.17.0. TXT file parser bug fix.</td>
<tr class="even">
<td align="left">20.3.0</td>
<td align="left">2021-12-17</td>
<td align="left">Updated with the GSEA Desktop 4.2.0 code base with numerous bug fixes. Adds the Abs_max_of_probes collapse mode. Fixed some issues handling datasets with missing values. Added the Spearman metric. Fixed issue with the min-sample check with gene_set permutation mode. Improved warnings and logging. Changed the FDR q-value scale on the NES vs Significance plot. Fixed bugs in weighted_p1.5 scoring.</td>
</tr>
<tr class="odd">
<td align="left">20.2.4</td>
<td align="left">2021-4-22</td>
<td align="left">Fixed minor typo.</td>
</tr>
<tr class="even">
<td align="left">20.2.3</td>
<td align="left">2021-4-2</td>
<td align="left">Updated to MSigDB v7.4.</td>
</tr>
<tr class="odd">
<td align="left">20.2.2</td>
<td align="left">2021-3-22</td>
<td align="left">Updated to MSigDB v7.3.</td>
</tr>
<tr class="even">
<td align="left">20.2.1</td>
<td align="left">2020-10-27</td>
<td align="left">Fixed a bug in the Collapse Sum mode.</td>
</tr>
<tr class="odd">
<td align="left">20.2.0</td>
<td align="left">2020-9-23</td>
<td align="left">Updated to MSigDB v7.2. Updated to use dedicated Docker container.</td>
</tr>
<tr class="even">
<td align="left">20.1.0</td>
<td align="left">2020-7-30</td>
<td align="left">Updated to use the GSEA v4.1.0 code base.</td>
</tr>
<tr class="odd">
<td align="left">20.0.5</td>
<td align="left">2020-4-2</td>
<td align="left">Updated to use the GSEA v4.0.3 code base. Updated to give access to MSigDB v7.1.</td>
</tr>
<tr class="even">
<td align="left">20.0.4</td>
<td align="left">2019-11-19</td>
<td align="left">Minor documentation update.</td>
</tr>
<tr class="odd">
<td align="left">20.0.3</td>
<td align="left">2019-10-24</td>
<td align="left">Updated to use the GSEA v4.0.2 code base. Updated to give access to MSigDB v7.0. OpenJDK 11 port. Java code moved into the GSEA Desktop code base.</td>
</tr>
<tr class="even">
<td align="left">19.0.26</td>
<td align="left">2019-10-10</td>
<td align="left">Updated to use the GSEA v3.0 open-source code base. Updated to give access to MSigDB v6.2. Unified the Gene Set DB selector parameters and better downloading of MSigDB files. Added selected.gene.sets, alt.delim, creat.gcts and create.svgs parameters. Better temp file clean-up and other internal code improvements.</td>
</tr>
<tr class="odd">
<td align="left">18</td>
<td align="left">2017-05-18</td>
<td align="left">Updated to give access to MSigDB v6.0</td>
</tr>
<tr class="even">
<td align="left">17</td>
<td align="left">2016-02-04</td>
<td align="left">Updated to give access to MSigDB v5.1</td>
</tr>
<tr class="odd">
<td align="left">16</td>
<td align="left">2015-12-03</td>
<td align="left">Updating the GSEA jar to deal with an issue with FTP access. Fixes an issue for GP@IU.</td>
</tr>
<tr class="even">
<td align="left">15</td>
<td align="left">2015-06-16</td>
<td align="left">Add built-in support for MSigDB v5.0, which includes new hallmark gene sets.</td>
</tr>
<tr class="odd">
<td align="left">14</td>
<td align="left">2013-06-14</td>
<td align="left">Update the gene sets database list and the GSEA Java library, added support for continuous phenotypes..</td>
</tr>
<tr class="even">
<td align="left">13</td>
<td align="left">2012-09-20</td>
<td align="left">Updated and sorted the chip platforms list, changed default value of num permutations to 1000, and updated the GSEA java library</td>
</tr>
<tr class="odd">
<td align="left">12</td>
<td align="left">2011-04-08</td>
<td align="left">Fixed parsing of gene sets database file names which contain @ and # symbols and added gene sets containing entrez ids</td>
</tr>
<tr class="even">
<td align="left">11</td>
<td align="left">2010-11-05</td>
<td align="left">Fixed parsing of chip platform file names which contain @ and # symbols</td>
</tr>
<tr class="odd">
<td align="left">10</td>
<td align="left">2010-10-01</td>
<td align="left">Updated selections for the gene sets database parameter to reflect those available in MSigDB version 3</td>
</tr>
</tbody>
</table>

Copyright © 2003-2021 Broad Institute, Inc., Massachusetts Institute of
Technology, and Regents of the University of California. All rights
reserved.

