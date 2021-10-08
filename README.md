# 1. Install
Download all the files into one folder and run main.pl using "perl /absolute_path_of_main.pl/main.pl parameter1 parameter2 parameter3 ......".
The users should install the packages used in perl and python programs, such as PerlIO::gzip, Getopt::Long, File::Basename, etc.

# 2. A Step-to-step protocol of the HIVID2 pipeline 

## 2.1 Step to step tutorial

### 1st step: create a sample list

Manually create a file named total.sample.list should be step1/sample.list. Note that the path in the total.sample.list should be absolute full path and the word in the first four columns should be the same. Below is an example of sample.list:

Sample  FC  Lane  Libray  read_length library_size  
SRR12345  SRR12345  SRR12345  SRR12345  110;110 170 /absolute_path/bkread1.fq.gz /absolute_path/bkread2.fq.gz

### 2nd step: run HIVID2 in one shell script
perl /absolute_path/all_in_one.pl -o output_directory -tl /absolute_path/total.sample.list -fa1 /absolute_path/human_ref.fa -fa2 /absolute_path/virus_ref.fa -bin /absolute_path/HIVID2 -c /absolute_path/Config_file

**This program all_in_one.pl is to generate a all-in-one shell script for HIVID2 pipelin**

**The parameters of all_in_one.pl**
                    **-o**              <str>           absolute path of output directory
                    **-tl**             <str>           total sample list
                    **-fa1**            <str>           the absolute path of human reference when performing bwa-mem [hg19]
                    **-fa2**            <str>           the absolute path of pathogene reference when performing bwa-mem [virus]
                    **-bin**            <str>           the absolute path of HIVID2 program
                    **-c**              <str>           the absolute path of config file for running soap


## 2.2 Descript of result file and the format

The path of the files of final results:

The file of human breakpoint: step4/*/human/breakpoint/*human_bk.final.stp2.uniq2.final

The file of virus breakpoint: step4/*/virus/breakpoint/*HBV_bk.final.stp2.uniq

Format description of the result file:

1st column is the number of the chromosome where the breakpoint located.

2nd column is Specific position coordinates

3rd column is the pair amount of left support reads

4th column is the pair amount of right support reads

5th column is the pair amount of discordant support reads

6th column is total number of all support reads

7th column is normalized pair amount of left support reads (normalized_value =support_reads_number / effective_reads_number_of_the_sample)

8th column is normalized pair amount of right support reads (logarithmic) normalized value

9th column is normalized pair amount of discordant support reads

10th column is total number of reads (logarithmic) normalized value

11th column is reads id of left support reads

12th column is reads id of right support reads

## 2.3 The introduction of main.pl
Parameters
**-o**	   output directory path  
**-l**	   a file containing sample_id, library_id and FC_id  
**-stp**   step number (1/2/3/4)  
**-c**	   parameter configuration file  
**-filter**	   whether to filter the repeated comparison reads. Here, only the repeated comparison reads on the human genome are filtered. The repeated comparison reads on the HBV genome are not filtered. However, in the result, the reads of repeated alignments on the HBV genome will be discarded, and the only aligned reads on the corresponding human genome will be retained.  
**-f**     this parameter is currently useless，please do not use it.

## 2.4 Description of several predefinding files
### (1) -C   the Configure file
This configure file difined the referece genomes and alignment parameters used in step3. The users can make their own configure file. But we have involved some configure files which is named as Config* in the same folder of main.pl. Below is the description of the configuration file:  
soap: the path of the soap2 program  
ref_virus: the path of soap2 index of virus reference genome  
ref_human: the path of soap2 index of human reference genome  
insert_sd: the standard deviation of the insert size for the sequencing library  
virus_config: the parameters of soap2 corresponding to different read length; for example, "150;150:-l 50 -v 5 -r 1" means when the read length is 150 bps, then soap2 will use the parameter "-l 50 -v 5 -r 1"; please note that read length is set at sample.list under the folder step1.

# 3. One demo
A demo has been uploaded. Users can download the file "demo.rar" and unzip it. We have add an file named "used.cml" in each folder. used.cml contains the command lines used in that folder. Please note that users should replace the absolute path of all the files in each script to run the demo. 

# 4. Advanced analysis

After obtaining the integration sites, HIVID2 allows the user to decide whether to automatically perform advanced analysis using the identified virus integrations. 

(1)	Manually seprate result folders of step4 into two groups, For example, tumor and normal, or other user-definednames. If you ran tumor and normal samples in a single run, then you may move each sample (each sample has a folder in step4) into the tumor or normal folder; if you iniatially ran tumor and normal samples seprately during step4, then you can simply use the step4 folder of tumor and normal of each run.

(2)	Run advanced analysis
#First， run Analyse.sh, generatint R scripts and the relevant files.
sh /absolute_path_of_main.pl/advanced_analysis/Analyse.sh /absolute_path/tumor /absolute_path/normal        
#Second, run the generated R scripts
Rscript xxx.R

Note: If you want to get the graph one by one, please separate the script and change parameters. You can also run it line by line, and modify the parameters by yourself. 

# 5. Other tips
(1) In order to help the users to track the data processing, HIVID2 retained some intermediate procedure files during running of the pipeline. It may cause big hard disk consuming when deal with large amount of data such as WGS data. Fortunately, The users can can remove most of intermediate files of previous steps when running step4. When running step4, the user can remove all the files named "*paired.gz" and "*unpaired.gz" in step2, all the files named "*soap.gz" in step2. After completing step4, all the files except the files of final results could be deleted. But before deleting, the users should make sure they don't need them later.

(2) About setting the length in sample.list: It is OK to set the length based on the raw reads, But it will be better set the reads length after removing the adapter. Actually, users can set the read length in sample.list after completing step2 because this value of length will not be used in step2 but used in step3. And in step2, adapters will be removed.

(3) There is a file named "tfbsConsSites.txt" in the advanced analysis. This file cannot be uploaded onto github due to the size limitation. But the user could download this file from Table browser of UCSC.

(4) HIVID2 works quite well for virus-capture sequencing data. For WGS data, sometimes the used memory might be too large. In this case, the users may need to separate the fastq data into several parts before input into HIVID2 for step1,step2 and step3; then the users can merge the data of step3 for the separated parts to run step4. For WGS data, the users could alternatively first remove human reads or HBV reads before running HIVID2. 

(5) The programs of soap2 are also uploaded in this repository. The method of buliding index of soap2 is as following:
    2bwt-builder xx.fa
 
(6) It should be noted that there are a file named "ref.list" in the same folder of main.pl. "ref.list" must contain all the ID of reference genomes used in the sequence alignment of step3 and step4, or the user will get error or uncompleted results in *human_bk.final.stp2.uniq2.final during the procedure of deep removing PCR-duplications in step4. We have involved some predefined reference names in ref.list, but the users should add the references names used in their own experiments. In the ref.list, each ID should be followed by an underline, for example "chr1_".

(7) The workflow of HIVID2 includes four steps, if you want to manually run the 4 steps one by one, please refer to the file named "".

# 6. Citation
Xi Zeng, Linghao Zhao, Chenhang Shen, Yi Zhou, Guoliang Li, Wing-Kin Sung, HIVID2: an accurate tool to detect virus integrations in the host genome, Bioinformatics, Volume 37, Issue 13, 1 July 2021, Pages 1821–1827, https://doi.org/10.1093/bioinformatics/btab031
