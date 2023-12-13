#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Definition of Complementary DNA Symbols
COMPLEMENT_TABLE = {"G":"C",
                    "A":"T",
                    "C":"G",
                    "T":"A"}

# Definition of Complementary IUPAC Ambigous DNA Symbols
"""
The table below was adapted from Cornish-Bowden, 1985:

======== ================== ============ ======================================
Symbol   Meaning            Complement   Origin of designation
======== ================== ============ ======================================
 G        G                  C            Guanine
 A        A                  T            Adenine
 T        T                  A            Thymine
 C        C                  G            Cytosine
 R        A or G             Y            puRine
 Y        C or T             R            pYrimidine
 M        A or C             K            aMino
 K        G or T             M            Ketone
 S        C or G             S            Strong interaction (3 H bonds)
 W        A or T             W            Weak interaction (2 H bonds)
 H        A or C or T        D            not-G, H (follows G in the alphabet)
 B        C or G or T        V            not-A, B follows A
 V        A or C or G        B            not-T (not-U), V follows U
 D        A or G or T        H            not-C, D follows C
 N        G or A or T or C   N            aNy
======== ================== ============ ======================================


Cornish-Bowden, A. (1985). Nomenclature for incompletely specified
bases in nucleic acid sequences: recommendations 1984.
Nucleic Acids Research, 13(9), 3021–3030.
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC341218
"""
COMPLEMENT_TABLE_IUPAC = ("ABCDGHKMSTVWN", "TVGHCDMKSABWN")