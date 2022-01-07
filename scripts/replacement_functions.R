### replacement function for detectRUNS::tableRuns()
### the average percentage of samples showing the HRR islands is added to the output of the function

## 1. redefine the function snpInsideRunsCpp (not exported from detectRUNS)
snpInsideRunsCpp <- utils::getFromNamespace("snpInsideRunsCpp", "detectRUNS")

## 2. redefine the function tableRuns()
tableRuns <- function(runs=NULL,SnpInRuns=NULL,genotypeFile, mapFile, threshold = 0.5) {
  
  #set a threshold
  threshold_used=threshold*100
  message(paste('Threshold used:',threshold_used))
  
  #read map file
  if(file.exists(mapFile)){
    # using data.table to read data
    mappa <- data.table::fread(mapFile, header = F)
  } else {
    stop(paste("file", mapFile, "doesn't exists"))
  }
  names(mappa) <- c("CHR","SNP_NAME","x","POSITION")
  mappa$x <- NULL
  
  
  if(!is.null(runs) & is.null(SnpInRuns)){
    message('I found only Runs data frame. GOOD!')
    
    #change colnames in runs file
    names(runs) <- c("POPULATION","IND","CHROMOSOME","COUNT","START","END","LENGTH")
    
    #Start calculation % SNP in ROH
    message("Calculation % SNP in ROH") #FILIPPO
    all_SNPinROH <- data.frame("SNP_NAME"=character(),
                               "CHR"=integer(),
                               "POSITION"=numeric(),
                               "COUNT"=integer(),
                               "BREED"=factor(),
                               "PERCENTAGE"=numeric(),
                               stringsAsFactors=FALSE)
    
    # create progress bar
    total <- length(unique(runs$CHROMOSOME))
    message(paste('Chromosome founds: ',total)) #FILIPPO
    n=0
    pb <- txtProgressBar(min = 0, max = total, style = 3)
    
    #SNP in ROH
    for (chrom in sort(unique(runs$CHROMOSOME))) {
      runsChrom <- runs[runs$CHROMOSOME==chrom,]
      mapKrom <- mappa[mappa$CHR==chrom,]
      snpInRuns <- snpInsideRunsCpp(runsChrom,mapKrom, genotypeFile)
      all_SNPinROH <- rbind.data.frame(all_SNPinROH,snpInRuns)
      n=n+1
      setTxtProgressBar(pb, n)
    }
    close(pb)
    message("Calculation % SNP in ROH finish") #FILIPPO
  } else if (is.null(runs) & !is.null(SnpInRuns)) {
    message('I found only SNPinRuns data frame. GOOD!')
    all_SNPinROH=SnpInRuns
  } else{
    stop('You gave me Runs and SNPinRuns! Please choose one!')
  }
  
  #consecutive number
  all_SNPinROH$Number <- seq(1,length(all_SNPinROH$PERCENTAGE))
  
  #final data frame
  final_table <- data.frame("GROUP"=character(0),"Start_SNP"=character(0),"End_SNP"=character(0),
                            "chrom"=character(0),"nSNP"=integer(0),"from"=integer(0),"to"=integer(0), "avg_pct"=numeric(0))
  
  
  #vector of breeds
  group_list=as.vector(unique(all_SNPinROH$BREED))
  
  for (grp in group_list){
    message(paste('checking: ',grp))
    
    #create subset for group/thresold
    group_subset=as.data.frame(all_SNPinROH[all_SNPinROH$BREED %in% c(grp) & all_SNPinROH$PERCENTAGE > threshold_used,])
    
    #print(group_subset)
    
    #variable
    old_pos=group_subset[1,7]
    snp_pos1=group_subset[1,3]
    Start_SNP=group_subset[1,1]
    snp_count=0
    sum_pct = 0
    
    x=2
    while(x <= length(rownames(group_subset))) {
      
      snp_count = snp_count + 1
      new_pos=group_subset[x,7]
      old_pos=group_subset[x-1,7]
      chr_old=group_subset[x-1,2]
      chr_new =group_subset[x,2]
      sum_pct = sum_pct + group_subset[x-1,"PERCENTAGE"]
      
      diff=new_pos-old_pos
      
      if ((diff > 1) | (chr_new != chr_old) | x==length(rownames(group_subset))) {
        if (x==length(rownames(group_subset))){
          end_SNP=group_subset[x,1]
          TO=group_subset[x,3]
        }else{
          end_SNP=group_subset[x-1,1]
          TO=group_subset[x-1,3]
        }
        
        final_table <- rbind.data.frame(final_table,final_table=data.frame("Group"= group_subset[x-1,5],
                                                                           "Start_SNP"=Start_SNP,
                                                                           "End_SNP"=end_SNP,
                                                                           "chrom"=group_subset[x-1,2],
                                                                           "nSNP"=snp_count,
                                                                           "from"=snp_pos1,
                                                                           "to"=TO,
                                                                           "avg_pct"=sum_pct))
        
        #reset variable
        snp_count=0
        sum_pct=0
        snp_pos1=group_subset[x,3]
        Start_SNP=group_subset[x,1]
      }
      
      #upgrade x value
      x <- x+1
      
    }
  }
  
  final_table$avg_pct = final_table$avg_pct/final_table$nSNP
  
  rownames(final_table) <- seq(1,length(row.names(final_table)))
  return(final_table)
}
