#' @importFrom base64enc base64encode
b64encode <- function(s) {
  s <- base64encode(s)
  s <- sub("[=]$", "", s)
  s <- sub("[\n]+$", "", s)
  s
}

b64encode_urlsafe <- function(s) {
  s <- b64encode(s)
  s <- gsub("+", "-", s, fixed = TRUE)
  s <- gsub("/", "_", s, fixed = TRUE)
  s
}


with_prefix <- function(s, prefix) {
  sub("^(|sl|sc|dl|dc)*seguid:", prefix, s)
}

#' @import digest digest
.seguid <- function(seq, table, encoding, prefix) {
    assert_table(table)
    assert_in_alphabet(seq, alphabet = names(table))
    stopifnot(is.function(encoding))
    stopifnot(length(prefix) == 1, is.character(prefix), !is.na(prefix))

    checksum <- digest(seq, algo = "sha1", serialize = FALSE, raw = TRUE)
    checksum <- encoding(checksum)
    checksum <- sub("[\n]+$", "", checksum)
    checksum <- sub("[=]$", "", checksum)
    checksum <- paste(prefix, checksum, sep = "")
    assert_checksum(checksum)
    checksum
}


#' The SEGUID of nucleotide and amino-acid sequences
#'
#' @param seq A character string.
#'
#' @param table A named character string.
#'
#' @return
#' A character string.
#'
#' @examples
#' seguid("ACGTACGTACGT")
#'
#' @references
#' 1. Babnigg G, Giometti CS. A database of unique protein sequence
#'    identifiers for proteome studies. Proteomics.
#'    2006 Aug;6(16):4514-22. \doi{10.1002/pmic.200600032}.
#'
#' @importFrom base64enc base64encode
#' @importFrom digest digest
#' @export
seguid <- function(seq, table = "dna") {
  table2 <- get_table(table)
  .seguid(seq, table = table2, encoding = b64encode, prefix = "seguid:")
}


#' @rdname seguid
#' @export
slseguid <- function(seq, table = "dna") {
  table2 <- get_table(table)
  .seguid(seq, table = table2, encoding = b64encode_urlsafe, prefix = "slseguid:")
}


#' @param watson,crick (character string) Two complementary DNA strands.
#'
#' @param overhang (integer) Amount of 3' overhang in the 5' side of
#' the molecule. A molecule with 5' overhang has a negative value.
#' 
#' @rdname seguid
#' @export
dlseguid <- function(watson, crick, overhang, table = "dna") {
  table2 <- get_table(table)
  assert_anneal(watson, crick, overhang = overhang, table = table2)

  lw <- nchar(watson)
  lc <- nchar(crick)
  df <- data.frame(A = c(watson, crick), B = c(crick, watson), C = c(overhang, lw - lc + overhang))
  o <- order(df$A, df$B, df$C, decreasing = FALSE)
  df <- df[o[1],]
  w <- df$A
  c <- df$B
  o <- df$C

  msg <- repr_from_tuple(watson = w, crick = c, overhang = o, table = table2, space = "-")

  table2 <- paste0(table, "+[-\n]")
  with_prefix(slseguid(msg, table = table2), "dlseguid:")
}


#' @rdname seguid
#' @export
scseguid <- function(seq, table = "dna") {
  with_prefix(slseguid(rotate_to_min(seq), table = table), "scseguid:")
}


#' @rdname seguid
#' @export
dcseguid <- function(watson, crick = rc(watson, table = get_table(table)), table = "dna") {
  stopifnot(nchar(watson) == nchar(crick))
  table2 <- get_table(table)
  assert_anneal(watson, crick, overhang = 0, table = table2)

  watson_min <- rotate_to_min(watson)
  crick_min <- rotate_to_min(crick)

  ## Keep the "minimum" of the two variants
  if (watson_min < crick_min) {
      w <- watson_min
  } else {
      w <- crick_min
  }

  with_prefix(dlseguid(w, rc(w, table = table2), overhang = 0, table = table), "dcseguid:")
}