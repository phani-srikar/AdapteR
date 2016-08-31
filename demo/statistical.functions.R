## Fuzzy Logix DB Lytix(TM)
## is a high-speed in-database analytics library
## written in C++, exposing ~700 functions through SQL.
## SQL as low-level language makes analyses
## consumable from all SQL-enabled clients.

## This demo shows how the
## AdapteR package of Fuzzy Logix is
## easing interaction with the DB Lytix(TM) in-database
## library.
##
## The demo highlights how to build an
## interactive stock returns correlation demo
## computed in database!
if(!exists("connection")) {
    demo("connecting", package="AdapteR")
}

#############################################################
## For in-database analytics the matrix is in the warehouse
## to begin with.
options(debugSQL=FALSE)
sqlQuery(connection,
           "select top 10 * from finEquityReturns")

vtemp <- readline(paste0("Above: The table has equity returns ",
                        " stored as triples (what was the equity ",
                        " return of which ticker on what date).\n ",
                        " These triples define a matrix in deep format."))

###########################################################
## Column Means Matrix
## The SQL-through R way to compute mean of
## Equity returns across various stocks.
##
sqlQuery(connection, "
SELECT  a.TickerSymbol           AS TickerSymbol,
        FLSUM(a.EquityReturn)/(select count(distinct txndate) from finequityreturns) AS mean
FROM    FL_TRAIN.finEquityReturns a
WHERE   a.TickerSymbol IN ('AAPL','HPQ','IBM',
                           'MSFT','ORCL')
GROUP BY a.TickerSymbol
ORDER BY 1;")

vtemp <- readline(paste0("Above: The SQL-through R way to compute ",
                        " Column Means of matrix with DB Lytix."))

## A remote matrix is easily created by specifying
## table, row id, column id and value columns
##
eqnRtn <- FLMatrix(table_name        = "finEquityReturns",
                   row_id_colname    = "TxnDate",
                   col_id_colname    = "TickerSymbol",
                   cell_val_colname  = "EquityReturn")

## the equity return matrix is about 3k rows and cols
dim(eqnRtn)

vtemp <- readline("Above: a remote matrix is defined.")

## 1. select the desired stocks from the full matrix
flm <- eqnRtn[,c('AAPL','HPQ','IBM','MSFT','ORCL')]

vtemp <- readline("Above: use subsetting to select stocks")

## 2. use the default R 'apply' function
FLResult <- apply(flm,2,mean)
vtemp <- readline(paste0("Above: the R/AdapteR way to compute ",
                        " matrix column Means of FLMatrix ",
                        " -- transparently in-database ",
                        " using 'apply' "))

FLResult
vtemp <- readline("Above: Data is fetched only when printing")

## Casting methods fetch (selected) data from the warehouse into R memory
rEqnRtn <- as.matrix(eqnRtn[,c('AAPL','HPQ','IBM','MSFT','ORCL')])

## the result is in the same format as the R results
rResult <- apply(rEqnRtn,2,mean,na.rm=TRUE)
rResult
expect_equal(as.vector(rResult),
            as.vector(FLResult),
            tol=0.001,
            scale=as.vector(rResult),
            check.attributes=FALSE)
vtemp <- readline(paste0("Above: Fetching matrix and computing in-memory to check ",
                        " result equivalence"))

############################################################
## One could similarly apply max function across dimensions 
## of an in-database matrix
FLResult <- apply(flm,2,max)
FLResult
vtemp <- readline("Above: Finding max EquityReturn for selected stocks")

############
cat("Similarly using AdapteR several scalar functions from DB-Lytix ",
    "can be parallelly evaluated across dimensions of an in-database matrix \n ")

vtemp <- readline("Next: Shiny Demo taking stocks as input interactively \n ")
metaInfo <- read.csv("http://raw.githubusercontent.com/aaronpk/Foursquare-NASDAQ/master/companylist.csv")

run.FLStockMeanShiny <- function (){
###########################################################
    ## Shiny Correlation Plot Demo
    ##
    ## metadata can be easily combined on the client
    ## download metadata from

    ## metadata contains sectors and industries
    ## that will be selectable in the shiny web ui
    table(metaInfo$industry)
    table(metaInfo$Sector)
    stockMeanMatrix <- function(input){
        ## get selected and available ticker symbols
        metastocks <- as.character(
            metaInfo$Symbol[
                metaInfo$industry %in% input$industries |
                metaInfo$Sector %in% input$sectors])
        stocks <- intersect(
            unique(c(input$stocks,
                     metastocks)),
            colnames(eqnRtn))

        ## compute correlation matrix
        vsubset <- eqnRtn[,stocks]
        vresult <- apply(vsubset,2,mean)
        vresult <- as.matrix(vresult)
        ## plot with company names and stocks
        rownames(vresult) <- metaInfo$Name[
            match(rownames(vresult),
                  metaInfo$Symbol)]
        vresult
    }

    require(R.utils)
    require(shiny)
    shinyApp(
        ui = fluidPage(
            fluidRow(
                column(3,
                       selectInput(
                           "sectors", "Sectors:",
                           choices = levels(metaInfo$Sector),
                           selected = "Energy",
                           multiple = TRUE)),
                column(3,
                       selectInput(
                           "industries", "Industries:",
                           choices = levels(metaInfo$industry),
                           selected = "Commercial Banks",
                           multiple = TRUE)),
                column(6,
                       selectInput(
                           "stocks", "Stocks:",
                           choices = colnames(eqnRtn),
                           selected = c(),
                           multiple = TRUE))),
            fluidRow(tableOutput("matrix"))
        ),
        server = function(input, output) {
        output$matrix <- renderTable(
            stockMeanMatrix(input))
    }
    )
}

vtemp <- readline(paste0("To select stocks interactively, we defined a ",
                        " function above. \n Simply execute\n> ",
                        " run.FLCorrelationShiny()\nafter ending the Demo.",
                        " \nEnd the demo now:"))

### END ####
### Thank You ####