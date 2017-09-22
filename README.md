#  Introduction

*Gene Set Enrichment Analysis* (GSEA) is a computational method that determines whether an a priori defined set of genes shows statistically significant, concordant differences between two biological states (e.g. phenotypes).  See the [GSEA website](http://www.gsea-msigdb.org) for more details.

The GSEA module for GenePattern is a free genomic analysis program written in the Java(tm) language implementing the GSEA method and useful utilities by wrapping the tool from the [GSEA Desktop](https://github.com/GSEA-MSigDB/gsea-desktop) in a form suitable for [GenePattern](http://www.genepattern.org/).  This allows running GSEA analyses on the GenePattern servers in a batch setting using a web UI, with no client installation. 

See the [module documentation](https://gsea-msigdb.github.io/gsea-gpmodule/v19/index.html) for tips on usage.

# License

The GSEA module for GenePattern is made available under the terms of a BSD-style license, a copy of which is included in the distribution in the [LICENSE.txt](LICENSE.txt) file.  See that file for exact terms and conditions.

The module relies upon the GSEA Desktop JAR.  See the [GSEA Desktop GitHub repository](https://github.com/GSEA-MSigDB/gsea-desktop) for information about its license.


#  Latest Version

The latest binary release of this software can be obtained from the GenePattern module repository, available from the Administration screen of the web UI.  It is currently in Beta release as v19.x. 

If you have any comments, suggestions or bugs to report, please see our [Contact page](http://www.gsea-msigdb.org/gsea/contact.jsp) for information on how to reach us.

# History and Acknowledgments

The **GSEA Desktop application version 1.0** was developed by Aravind Subramanian as part of his PhD thesis.  The work was supported by the Broad Institute of MIT and Harvard and advised by Jill Mesirov, Pablo Tamayo, Vamsi Mootha, Sayan Mukherjee, Todd Golub and Eric Lander.  See the README in the [GSEA Desktop GitHub repository](https://github.com/GSEA-MSigDB/gsea-desktop) for further history of the GSEA Desktop and list of additional contributors.

**The GSEA module for GenePattern, up to and including v18** were based on the GSEA Desktop v2.x code base, while **v19.x** is based on the open-source GSEA Desktop v3.0 code base; the initial GitHub commit corresponds to this v19 release of August 7, 2017. The earlier code revision history is not available.
  
David Eby was responsible for the open-source conversion of the GSEA Desktop and all the GSEA modules and handles current maintenance and new feature development.  While David is listed on the initial commit to this public GitHub repository, original authorship is due to the individuals listed in the GSEA history regardless of the GitHub history metadata.

The GSEA project is currently a joint effort of the Broad Institute and the University of California San Diego, and funded by the National Cancer Institute of the National Institutes of Health (PI: JP Mesirov).

# Dependencies

The GSEA module for GenePattern is 100% Pure Java.  Java 8 is required for our pre-built binaries.  Builds against other versions of Java may be possible but are unsupported.  **Oracle Java is recommended as there are known issues when running with OpenJDK.**

See the [LICENSE-3RD-PARTY.txt](LICENSE-3RD-PARTY.txt) file for a list of the module's library dependencies.  The module wraps the GSEA Desktop; see the [GitHub repository](https://github.com/GSEA-MSigDB/gsea-desktop) for its dependencies.

In our GSEA Desktop binary builds, all required 3rd party library code is bundled into the single self-contained gsea-3.0.jar file so that no additional downloads or installation are required.  For the GenePattern module, additional library dependencies are included as separate files in the 'lib' directory. 

------
Copyright (c) 2003-2017 Broad Institute, Inc., Massachusetts Institute of Technology, and Regents of the University of California.  All rights reserved.
