#!/bin/bash

#SBATCH --job-name=CoordSashimi
#SBATCH --time=00:05:00
#SBATCH --output=CoordSashimi_%j.out

# Inputs a modificar si es necesario
working_dir=example
adding=2000 #coordenadas a añadir a ambos lados para representación
gtf_file=/scratch/blazqul/indexes/h_index/gencode.v41.primary_assembly.annotation.gtf

# No modificar a partir de aquí
config=${working_dir}/config.txt #archivo config de entrada
output="${working_dir}/$(basename "${config}" .txt)_sashimi.txt" #config_BIOD_sashimi.txt
if [[ -f "$output" ]]; then
	echo "File already exists. Careful, it will be overwritten!"
fi

> "$output"

last_gene=""
duplicate_count=0

# Leer el archivo línea por línea
while IFS=$'\t' read -r gene range; do

  # Detectar duplicados
  if [[ "$gene" == "$last_gene" ]]; then
    ((duplicate_count++))
    gene="${gene}_${duplicate_count}"
  else
    duplicate_count=1
    last_gene="$gene"
  fi

  # Extraer coordenadas y cromosoma
  chr=$(echo "$range" | cut -d':' -f1)
  start=$(echo "$range" | cut -d':' -f2 | cut -d'-' -f1)
  end=$(echo "$range" | cut -d':' -f2 | cut -d'-' -f2)

  # Intentar encontrar la cadena en el GTF
  strand=$(grep "$start" "$gtf_file" | head -n 1 | awk '{print $7}')
  if [ -z "$strand" ]; then
    strand=$(grep "$end" "$gtf_file" | head -n 1 | awk '{print $7}')
  fi
  if [ -z "$strand" ]; then
    strand=$(grep "gene_name \"$gene\"" "$gtf_file" | head -n 1 | awk '{print $7}')
  fi
  if [ -z "$strand" ]; then
    strand="+" # Si no se encuentra, asumir que es positiva
  fi

  # Ajusta las coordemadas (-2000 for start, +2000 for end)
	new_start=$((start - $adding))
	new_end=$((end + $adding))

  # Crear la nueva columna
  new_column="${chr}:${strand}:${new_start}:${new_end}"

  # Escribir la línea con la nueva columna en el archivo de salida
  echo -e "${gene}\t${range}\t${new_column}" >> "$output"
done < "$config"

echo "Processing complete. Output saved to $output."


