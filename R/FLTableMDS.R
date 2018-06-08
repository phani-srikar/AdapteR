#' @include FLMatrix.R
NULL

#' An S4 class to represent FLTableMDS, an in-database data.frame.
#'
#' @slot select FLTableQuery the select statement for the table.
#' @slot dimnames the observation id and column names
#' @slot isDeep logical (currently ignored)
#' @method names FLTableMDS
#' @param object retrieves the column names of FLTable object
#' @export
setClass("FLTableMDS",
         contains="FLTableMD"
        )


setClass("FLTableMDS.Hadoop", contains = "FLTableMDS")
setClass("FLTableMDS.TD", contains = "FLTableMDS")
setClass("FLTableMDS.TDAster", contains = "FLTableMDS")



#' An S4 class to represent FLTableMDSDeep, an in-database data.frame.
#'
#' @slot select FLTableQuery the select statement for the table.
#' @slot dimnames the observation id and column names
#' @slot isDeep logical (currently ignored)
#' @slot mapSelect \code{FLSelectFrom} object which contains the 
#' mapping information if any
#' @export
setClass("FLTableMDSDeep",
         contains="FLTableMDS",
         slots = list(
         ),
         prototype = prototype(type="double",
                                dimColumns=c("group_id_colname","obs_id_colname"))
        )

setClass("FLTableMDSDeep.Hadoop", contains = "FLTableMDSDeep")
setClass("FLTableMDSDeep.TD", contains = "FLTableMDSDeep")
setClass("FLTableMDSDeep.TDAster", contains = "FLTableMDSDeep")


#' Constructor function for FLTableMDS.
#'
#' \code{FLTableMDS} constructs an object of class \code{FLTableMDS}.
#'
#' \code{FLTableMDS} refers to an in-database table with multiple data sets.
#' This object is commonly used as input for some data mining functions
#' which operate parallelly on all the datasets
#' @param database name of the database
#' @param table name of the table
#' @param group_id_colname column name identifying the datasets
#' @param obs_id_colname column name set as primary key
#' @param var_id_colname column name where variable id's are stored if \code{FLTableMDS} is deep
#' @param cell_val_colname column name where cell values are stored if \code{FLTableMDS} is deep
#' @param group_id vector of dataset IDs'to be considered.
#' Default is all those contained in the table
#' @return \code{FLTableMDS} returns an object of class FLTableMDS mapped to a table
#' in database
#' @examples
#' widetableMD <- FLTableMDS(table="tblAutoMPGMD",
#'                       group_id_colname="GroupID",
#'                       obs_id_colname="ObsID")
#' deeptableMD <- FLTableMDS(table="LinRegrMultiMD",
#'                       group_id_colname="DatasetID",
#'                       obs_id_colname="ObsID",
#'                       var_id_colname="VarID",
#'                       cell_val_colname="Num_Val")
#' head(widetableMD)
#' head(deeptableMD)

#' @export
FLTableMDS <- function(table,
                      group_id_colname,
                      obs_id_colname,
                      var_id_colnames=character(0), 
                      cell_val_colname=character(0),
                      whereconditions=character(0),
                      connection=getFLConnection(),
                      # group_id=c(),
                      # fetchIDs=TRUE,
                      dims=list(0,0,0),
                      sparse=TRUE,
                      dimnames=list(list(NULL),list(NULL),list(NULL)),
                      ...
                      ){
        FLTableMD(table = table,
                group_id_colname = group_id_colname,
                obs_id_colname = obs_id_colname,
                var_id_colnames = var_id_colnames, 
                cell_val_colname= cell_val_colname,
                whereconditions = whereconditions,
                connection = getFLConnection(),
                dims = dims,
                sparse = sparse,
                dimnames = dimnames,
                MDS = TRUE,
                ...)
}

#' @export
is.FLTableMDS <- function(object)
    inherits(object,"FLTableMDS")
