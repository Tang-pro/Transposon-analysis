#从repeatmasker中注释到的转座子提取isoform对于的转座子类型
awk '{print $5, $11}' Ghirsutum_transcript.fa.out | sed '1,3d' > Gh_repeatclass
#按照第一列进行排序
sort -k1,1 Gh_repeatclass > Gh_repeatclass.sorted
#将repeatmasker中Ghirsutum_transcript.fa.out.gff转换为bed格式
module load bedops/2.4.39
gff2bed <Ghirsutum_transcript.fa.out.gff> Ghirsutum_transcript.fa.out.gff.bed
#取出前三列
cut -f1-3 Ghirsutum_transcript.fa.out.gff.bed > temp_file
#添加转座子注释信息
awk 'NR==FNR{a[$1]=$2;next} $1 in a{print $0"\t"a[$1]}' Gh_repeatclass.sorted temp_file > Ghirsutum_transcript.fa.bed
#将Ghirsutum_transcript.fa.bed的第4列（转座子类型）替换到第8列
awk 'NR==FNR{a[NR]=$4; next} {if(a[FNR]){ $8=a[FNR] }}1' OFS="\t" Ghirsutum_transcript.fa.bed Ghirsutum_transcript.fa.out.gff.bed > Ghrepeat.bed

#在基因组序列重复注释中提前四列（染色体号，起始位置，终止位置，转座子分类）
awk '{OFS="\t"; print $5,$6,$7,$11}' Ghirsutum_genome.fasta.out | sed '1,3d' > Ghirsutum_genome.fasta.tmp
#主要gff和bed的起始位置不同，BED 文件: 采用 0-based (零基) 编号系统，GFF 文件: 采用 1-based (一基) 编号系统
awk 'BEGIN{OFS="\t"} { $2 = $2 - 1; print }' Ghirsutum_genome.fasta.tmp > Ghirsutum_genome.fasta.bed
#改名，并移动至“/public/home/jwtang/PRJNA503814_ZJU/aws_rawdata/TM_1/TAMA_merge/isoform_masker/Ghisoform/Genome”
mv Ghirsutum_genome.fasta.bed Ghgenome.bed
#根据基因组提取启动子区域
awk '$3 == "transcript"' ../../Ghincfib_gene.gtf | \
awk 'BEGIN{OFS="\t"}{
    if($7=="+") {
        start = $4-2000;
        if(start < 0) start = 1;
        print $1, start, $4, ".", $7, $12;
    } else {
        print $1, $5, $5+2000, ".", $7, $12;
    }
}' > promoters
#剔除^Scaffold
grep -v "^Scaffold" promoters > promoters_iso.bed


#提取终止子区域
awk '$3 == "transcript"' ../../Ghincfib_gene.gtf | \
awk 'BEGIN{OFS="\t"}{
    if($7=="+") {
        end = $5+2000;
        print $1, $5, end, ".", $7, $12;
    } else {
        start = $4-2000;
        if(start < 0) start = 1;
        print $1, start, $4, ".", $7, $12;
    }
}' > terminators

#计算每个转座子的类型在对应的每种isoform类型中的比例
for type in $(cut -f14 Gh_Internal | sort | uniq); do
  LTR_count=$(awk -v t="$type" '$14 == t && $8 ~ /LTR/' Gh_Internal | wc -l)
  LINE_count=$(awk -v t="$type" '$14 == t && $8 ~ /LINE/' Gh_Internal | wc -l)
  total_count=$(awk -v t="$type" '$14 == t' Gh_Internal | wc -l)
  
  LTR_ratio=$(echo "scale=4; $LTR_count / $total_count" | bc)
  LINE_ratio=$(echo "scale=4; $LINE_count / $total_count" | bc)
  
  echo "$type类型中LTR的比例: $LTR_ratio"
  echo "$type类型中LINE的比例: $LINE_ratio"
done


for type in $(cut -f11 Gh_joined_intersect_promoters | sort | uniq); do
  LTR_count=$(awk -v t="$type" '$11 == t && $10 ~ /LTR/' Gh_joined_intersect_promoters | wc -l)
  LINE_count=$(awk -v t="$type" '$11 == t && $10 ~ /LINE/' Gh_joined_intersect_promoters | wc -l)
  total_count=$(awk -v t="$type" '$11 == t' Gh_joined_intersect_promoters | wc -l)
  
  LTR_ratio=$(echo "scale=4; $LTR_count / $total_count" | bc)
  LINE_ratio=$(echo "scale=4; $LINE_count / $total_count" | bc)
  
  echo "$type类型中LTR的比例: $LTR_ratio"
  echo "$type类型中LINE的比例: $LINE_ratio"
done

for type in $(cut -f11 Gh_joined_intersect_terminators | sort | uniq); do
  LTR_count=$(awk -v t="$type" '$11 == t && $10 ~ /LTR/' Gh_joined_intersect_terminators | wc -l)
  LINE_count=$(awk -v t="$type" '$11 == t && $10 ~ /LINE/' Gh_joined_intersect_terminators | wc -l)
  total_count=$(awk -v t="$type" '$11 == t' Gh_joined_intersect_terminators | wc -l)
  
  LTR_ratio=$(echo "scale=4; $LTR_count / $total_count" | bc)
  LINE_ratio=$(echo "scale=4; $LINE_count / $total_count" | bc)
  
  echo "$type类型中LTR的比例: $LTR_ratio"
  echo "$type类型中LINE的比例: $LINE_ratio"
done
