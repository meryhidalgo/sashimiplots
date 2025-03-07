# **README - Sashimi Plot Pipeline**  

START by creating a new directory. The name of this directory will be your working_dir variable. Inside it create: 

- **config.txt**: a tab-separated file with 2 columns -> `GENE	COORD`. No header is needed.  

  - **GENE** represents the gene name. It works better when GENE is ordered alphabetically, or at least place duplicated genes one after the other. The script will directly add `_1, _2...` only if they are consecutively written in the config file.  
  - **COORD** should be in the format: `chr10:114447880-114448020`.  


1. Once prepared, open 1-extend_coord_sashimi.sh. 

Modify **working_dir** variable, **adding** will be amount of pb to be added on both sides of the exons coordinatesGTF. **gtf_file** should not be modified while working with human v41 gencode gtf. If another species or another version is needed, paste path to gtf file. 


2. Launch 1-extend_coord_sashimi.sh by typing in terminal: 
```bash
sbatch 1-extend_coord_sashimi.sh
```
Another file called config_sashimi.txt will be created with a new column with sashimi coordinates and strandness of gene. Format: `chr10:-:114445880:114450020`. This file can be manually modified if you know exact coordinates you want to plot. 

## MAKE SURE B1, B2, GROUPING FILES ARE ALREADY CREATED IN WORKING DIR

3. Open 3-rmats2sashimi.sh. Again, modify **working_dir** variable, **groups** variable and **gff3** only if needed. By deafult a directory called rmats2sashimi_out inside your working_dir will be created. If there is already a folder there with that name, it will be replaced. Sashimis will be extracted with their gene_name.

If working in blazqul@atlas no change is needed. If not, environment and python executable path should be modified. 

```bash
sbatch 3-rmats2sashimi.sh
```

If there is any problem. If no plot for a specific gene is created, sometimes changing strand of exon might solve the error. 
chr10:-:114445880:114450020 -> chr10:+:114445880:114450020

You can manually change coordinates in config_sashimi.txt or relaunch 1-extend_coord_sashimi.sh changing adding parameter. 

## Expected outputs for:
- **1-extend_coord_sashimi.sh** -> CoordSashimi_x.out
    *File already exists. Careful, it will be overwritten!*
    Processing complete. Output saved to config_sashimi.txt.
- **2-list_bam_files.sh** -> rmats_files_x.out
    Created b1 file
    Created b2 file
    Created grouping file
- **3-rmats2sashimi.sh** -> r2sashimi_x.out
  LONG OUTPUT
    *Directorio rmats2sashimi_out ya existe. Cuidado, se sobreescribirá!*
    <module 'misopy' from '/scratch/blazqul/biotools_scratch/rmats2sashimi/utils/src/MISO/misopy/__init__.py'>
    Indexing GFF...
      - GFF: /scratch/blazqul/biotools_scratch/rmats2sashimi/example/rmats2sashimi_out/ABLIM1/Sashimi_index/tmp.gff3
      - Outputting to: /scratch/blazqul/biotools_scratch/rmats2sashimi/example/rmats2sashimi_out/ABLIM1/Sashimi_index
  CHECK END OF OUTPUT
    Sashimi plots extracted correctly!
    IF mv: cannot stat ‘CADM1.pdf’: No such file or directory -> CADM1 gene gave problems


PLEASE, manually move .out files to log directory to keep environment clean. 
