check.PROPvars <- function(condflds, treeflds = NULL,
	propvars=c("CONDPROP_UNADJ", "SUBPPROP_UNADJ", "MICRPROP_UNADJ", "MACRPROP_UNADJ"), 
	diavar="DIA", MICRO_BREAKPOINT_DIA=5, MACRO_BREAKPOINT_DIA=NULL){

  ###################################################################################
  ## DESCRIPTION: Check for necessary proportion variables.
  ## VALUE: Vector of PROPORTION variables in dataset.
  ###################################################################################
  
  ## Check condnames
  if (is.null(condflds)) {
    message("invalid condflds")
	return(NULL)
  }
  
  ## Check for missing propvars
  propchk <- unlist(sapply(propvars, findnm, condflds, returnNULL = TRUE))
  if (is.null(propchk)) {
    message("there are no propvars in dataset: ", toString(propvars))
    stop()
  } else if (length(propchk) < length(propvars)) {
    missprop <- propvars[!propvars %in% names(propchk)]
    message("propvars not in cond table: ", toString(missprop))
  } else {
    propvars <- propchk
  }

  ## Check for missing diavar
  if (!is.null(treeflds)) {
    micro_breakpointnm <- findnm("MICRO_BREAKPOINT_DIA", condflds, returnNULL=TRUE)
    macro_breakpointnm <- findnm("MACRO_BREAKPOINT_DIA", condflds, returnNULL=TRUE)
    if (any(!is.null(c(micro_breakpointnm, macro_breakpointnm))) && 
			!diavar %in% treeflds) {
      message(diavar, " is not in tree table")
    }
  }
 
  return(propvars)
}
