

![image-20230529104042392](C:\Users\tangj\AppData\Roaming\Typora\typora-user-images\image-20230529104042392.png)



![image-20230815155735097](C:\Users\tangj\AppData\Roaming\Typora\typora-user-images\image-20230815155735097.png)

```bash
# ONT 陆地棉 R0 热敏品种0h  三组生物学重复
bsub -J 7275 -n 4 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 "stringtie -o SRR13857275.gtf --rf -G /public/home/jwtang/shihezi_ont/AS_T_R/AS/T0/GCF_007990345.1_Gossypium_hirsutum_v2.1_genomic.gtf -L SRR13857275.sorted.bam"
bsub -J 7274 -n 4 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 "stringtie -o SRR13857274.gtf --rf -G /public/home/jwtang/shihezi_ont/AS_T_R/AS/T0/GCF_007990345.1_Gossypium_hirsutum_v2.1_genomic.gtf -L SRR13857274.sorted.bam"
bsub -J 7262 -n 4 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 "stringtie -o SRR13857262.gtf --rf -G /public/home/jwtang/shihezi_ont/AS_T_R/AS/T0/GCF_007990345.1_Gossypium_hirsutum_v2.1_genomic.gtf -L SRR13857262.sorted.bam"
#R4
bsub -J 7258 -n 4 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 "stringtie -o SRR13857258.gtf --rf -G /public/home/jwtang/shihezi_ont/AS_T_R/AS/T0/GCF_007990345.1_Gossypium_hirsutum_v2.1_genomic.gtf -L /public/home/jwtang/shihezi_ont/SRR13857258/SRR13857258.sorted.bam"
bsub -J 7257 -n 4 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 "stringtie -o SRR13857257.gtf --rf -G /public/home/jwtang/shihezi_ont/AS_T_R/AS/T0/GCF_007990345.1_Gossypium_hirsutum_v2.1_genomic.gtf -L /public/home/jwtang/shihezi_ont/SRR13857257/SRR13857257.sorted.bam"
#R8 
bsub -J 7254 -n 4 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 "stringtie -o SRR13857254.gtf --rf -G /public/home/jwtang/shihezi_ont/AS_T_R/AS/T0/GCF_007990345.1_Gossypium_hirsutum_v2.1_genomic.gtf -L SRR13857254.sorted.bam"
bsub -J 7253 -n 4 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 "stringtie -o SRR13857253.gtf --rf -G /public/home/jwtang/shihezi_ont/AS_T_R/AS/T0/GCF_007990345.1_Gossypium_hirsutum_v2.1_genomic.gtf -L SRR13857253.sorted.bam"
bsub -J 7252 -n 4 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 "stringtie -o SRR13857252.gtf --rf -G /public/home/jwtang/shihezi_ont/AS_T_R/AS/T0/GCF_007990345.1_Gossypium_hirsutum_v2.1_genomic.gtf -L SRR13857252.sorted.bam"
#R12
bsub -J 7255 -n 4 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 "stringtie -o SRR13857255.gtf --rf -G /public/home/jwtang/shihezi_ont/AS_T_R/AS/T0/GCF_007990345.1_Gossypium_hirsutum_v2.1_genomic.gtf -L SRR13857255.sorted.bam"
bsub -J 7273 -n 4 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 "stringtie -o SRR13857273.gtf --rf -G /public/home/jwtang/shihezi_ont/AS_T_R/AS/T0/GCF_007990345.1_Gossypium_hirsutum_v2.1_genomic.gtf -L SRR13857273.sorted.bam"
bsub -J 7272 -n 4 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 "stringtie -o SRR13857272.gtf --rf -G /public/home/jwtang/shihezi_ont/AS_T_R/AS/T0/GCF_007990345.1_Gossypium_hirsutum_v2.1_genomic.gtf -L SRR13857272.sorted.bam"
#合并三个生物学重复
bsub -J stringtie_merge -n 4 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 "stringtie --merge -o R0.gtf -G /public/home/jwtang/shihezi_ont/AS_T_R/AS/T0/GCF_007990345.1_Gossypium_hirsutum_v2.1_genomic.gtf SRR13857275.gtf SRR13857274.gtf SRR13857262.gtf"
#使用gffcompare比较
bsub -J gffcompare -n 4 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 "gffcompare -r /public/home/jwtang/shihezi_ont/AS_T_R/AS/T0/GCF_007990345.1_Gossypium_hirsutum_v2.1_genomic.gtf -o R4_out R4.gtf"
```

```bash
#统计生成的gtf的 gene trancript CDS
bsub -J gtftk_count -n 4 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 "gtftk count -i R0.gtf"
```

