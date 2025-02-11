#!/bin/bash

#SBATCH --job-name=rmats_files
#SBATCH -c 5
#SBATCH --mem=4G
#SBATCH --output=rmats_files_%j.out

# ---- setting archivos entrada ----
working_dir=BIOD_sashimi
bams=/scratch/blazqul/ongoing_projects/BIOD_Lorea/bams_sashimi
design=/scratch/blazqul/ongoing_projects/BIOD_Lorea/design_sashimi.tab
group_A=BIOD_GSC17 #contraste
group_B=BIOD_noTum11 #control

# No modificar a partir de aquí
cd $working_dir

echo -n > b.txt

A=$(grep $group_A $design | awk '{print $1}')

for line in ${A[@]}; do
    #dev/null me recoge los mensajes de error de aquellas muestras que no encuentra
    fR1=$(realpath "$bams/$line".bam 2>/dev/null)
    echo -n "$fR1," >> b.txt
done

sed '$ s/.$//' b.txt > b1_${group_A}.txt

echo "Created b1 file"

echo -n > b.txt

B=$(grep $group_B $design | awk '{print $1}')

for line in ${B[@]}; do
    #dev/null me recoge los mensajes de error de aquellas muestras que no encuentra
    fR1=$(realpath "$bams/$line".bam 2>/dev/null)
    echo -n "$fR1," >> b.txt
done

sed '$ s/.$//' b.txt > b2_${group_B}.txt

rm b.txt

echo "Created b2 file"


contrast=$(grep $group_A $design | wc -l)
control=$(grep $group_B $design | wc -l)

echo -n > grouping.gf
echo -e "$group_A: 1-$contrast" >> grouping.gf
echo -e "$group_B: $((contrast + 1))-$((contrast + control))" >> grouping.gf
echo "Created grouping file"
