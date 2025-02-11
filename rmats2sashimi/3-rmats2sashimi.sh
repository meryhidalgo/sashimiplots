#!/bin/bash

#SBATCH --job-name=rmats2sashimi
#SBATCH --time=03:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=8
#SBATCH --output=r2sashimi_%j.out

# ---- set the environment ----
module load Python
conda activate /scratch/blazqul/envs/pysam #biotools, rmats_412, r-envs, sratools, pysam

# Inputs a modificar si es necesario
working_dir=example
gff3=/scratch/blazqul/indexes/h_index/gencode.v41.primary_assembly.annotation.gff3
group_A=BIOD_GSC17 #contraste
group_B=BIOD_noTum11 #control

# No modificar a partir de aquí
config=config_sashimi.txt
grouping=grouping.gf
outdir=rmats2sashimi_out

cd $working_dir
if [ -d "$outdir" ]; then
  echo "Directorio $outdir ya existe. Cuidado, se sobreescribirá!"
  rm -rf "$outdir"
fi

mkdir -p "$outdir"

while IFS=$'\t' read -r gene coord1 coord2
do 
    mkdir -p $outdir/$gene
    /scratch/blazqul/envs/pysam/bin/python3 utils/src/rmats2sashimiplot/rmats2sashimiplot.py \
        --b1 b1_$group_A.txt --b2 b2_$group_B.txt \
        --l1 $group_A --l2 $group_B \
        -c $coord2:$gff3 \
        -o $outdir/$gene \
        --exon_s 1 --intron_s 5 \
        --group-info $grouping \
        --color '#0090C9,#C98D00' \
        --min-counts 1
done < $config

cd $outdir

folders=($(ls -d */))

for folder in "${folders[@]}"; do
	folder_name=$(basename "${folder}")
	# Move and rename the BAM file
	cd ${folder}
	rm -rf Sashimi_index
	mv Sashimi_plot/*.pdf .
	rm -rf Sashimi_plot
	mv * "${folder_name}.pdf"
	mv "${folder_name}.pdf" ../
	cd ..
	rm -rf ${folder}
	#rm -rf ${folder}/Sashimi_plot
done

echo "Sashimi plots extracted correctly!"
