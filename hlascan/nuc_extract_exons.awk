#!/usr/bin/gawk
BEGIN{
    sequence=""
    ref_allele=""
}{

    if($1 ~ /.*\*/){
        if(NR == 11){
            ref_allele=$1
        }
        for(i=2;i<=NF;i++){
            sequence=sequence $i
        }
        if($1 == ref_allele){
            reference=reference sequence
        }
        data[$1]=data[$1] sequence
        sequence=""
    }
}
END{
    split(reference,ref_exons,"|")
    for(allele in data){
        split(data[allele],allele_exons,"|")

        num_exon=1
        for (pos_exon=1;pos_exon<=length(allele_exons);pos_exon++){
            previous_length=0

            split(ref_exons[num_exon],ref_bases,"")
            split(allele_exons[pos_exon],allele_exon_bases,"")

            for(nb_base=1;nb_base<=length(ref_bases);nb_base++){
                if(allele_exon_bases[nb_base] == "-"){
                    allele_data[allele][num_exon]=allele_data[allele][num_exon] ref_bases[nb_base]
                }else if(allele_exon_bases[nb_base] == "."){
                    # do nothing
                }else if(allele_exon_bases[nb_base] == "*"){
                    allele_data[allele][num_exon]=allele_data[allele][num_exon] "N"
                }else {
                    allele_data[allele][num_exon]=allele_data[allele][num_exon] allele_exon_bases[nb_base]
                }
                tmp=allele_data[allele][num_exon]
                gsub("\n","",tmp)
                if(length(tmp) % 60 == 0){
                    if(previous_length != length(tmp)){
                        allele_data[allele][num_exon]=allele_data[allele][num_exon]"\n"
                    }
                    previous_length=length(tmp)
                }
            }
            num_exon++
        }

        if(allele ~ /^MIC/ || allele ~/^TAP/){
            print "#" allele
        }else{
            print "#HLA-" allele
        }
        for(pos_exon=1;pos_exon<=length(allele_data[allele]);pos_exon++){
            print ">EX"pos_exon
            print allele_data[allele][pos_exon]
        }
    }
}