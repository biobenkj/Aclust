create.annot.triche <-
function(probe.vec, only.locations = F){
	
	## probe.vec is a vector with illumina IDs
  #	legal.inds <- grep("gc", probe.vec)
  #	if (length(legal.inds) < length(probe.vec)) cat("Some probes were removed due to names not matching the annotation package")
	
	n.probes <- length(probe.vec)
	
	IlmnID <- probe.vec
	
	
	
	## get chromosome 
	CHR <- unlist(as.list(IlluminaHumanMethylation450kCHR37[probe.vec]))
	
	##  CPG location, genome build 37
	Coordinate_37 <- unlist(as.list(IlluminaHumanMethylation450kCPG37[probe.vec]))
	Coordinate_37 <- as.numeric(Coordinate_37)
	
	if (only.locations) {
			annot <- data.table( IlmnID, CHR, Coordinate_37,   key = c("CHR", "Coordinate_37") )
			return(annot)
	}  else{
	
	## get design type
	Infinium_Design_Type <- unlist(as.list(IlluminaHumanMethylation450kDESIGN[probe.vec]))
	
	#	UCSC_RefGene_Name (from NCBI), gene symbol
	legal.inds <- grep("cg", probe.vec)
	UCSC_RefGene_Name <- rep("", length(probe.vec))
	UCSC_RefGene_Name[legal.inds] <- unlist(as.list(IlluminaHumanMethylation450kSYMBOL[probe.vec[legal.inds]]))
	UCSC_RefGene_Name[which(is.na(UCSC_RefGene_Name))] <- ""
		
	## regulatory group
	mapped_probes <- mappedkeys(IlluminaHumanMethylation450kREGULATORYGROUP)
	t <- match(probe.vec, mapped_probes)
	inds <- which(!is.na(t))
	UCSC_RefGene_Group <- rep("", n.probes)
	UCSC_RefGene_Group[inds] <- unlist(as.list(IlluminaHumanMethylation450kREGULATORYGROUP[probe.vec[inds]]))

	
	## associated CpG island (resort)
	mapped_probes <- mappedkeys(IlluminaHumanMethylation450kCPGINAME)
	t <- match(probe.vec, mapped_probes)
	inds <- which(!is.na(t))
	UCSC_CpG_Islands_Name <- rep("", n.probes)
	UCSC_CpG_Islands_Name[inds] <- unlist(as.list(IlluminaHumanMethylation450kCPGINAME[probe.vec[inds]]))
	
	
	## region within resort
	mapped_probes <- mappedkeys(IlluminaHumanMethylation450kCPGIRELATION)
	t <- match(probe.vec, mapped_probes)
	inds <- which(!is.na(t))
	Relation_to_UCSC_CpG_Island <- rep("", n.probes)
	Relation_to_UCSC_CpG_Island[inds] <- unlist(as.list(IlluminaHumanMethylation450kCPGIRELATION[probe.vec[inds]]))

	
	annot <- data.table( IlmnID, Infinium_Design_Type , 
                       CHR, Coordinate_37,  UCSC_RefGene_Name, 
                       UCSC_RefGene_Group, UCSC_CpG_Islands_Name, 
                       Relation_to_UCSC_CpG_Island, 
                       key = c("CHR", "Coordinate_37") )
	
	return(annot)
	}
	
}
