#!/bin/bash

#***************************************************************#
#                           main.sh                             #
#                  written by Kerensa McElroy                   #
#                          June 2018				#
#                                                               #
#                      telomere analysis                        #
#***************************************************************#

export TODAY=$(date +%Y-%m-%d_%H-%M)


#----------------------project variables------------------------#

export PROJECT=2018-05-04_telomere
export READ_ONE=_R1
export IN_DIR=/OSM/CBR/NRCA_FINCHGENOM/analysis/2016-09-21_telomere/subsamples

#-------------------environmental variables---------------------#

#functions

call_prog () {
	CMD="sbatch --dependency=${2} ${HOME}/scripts/${1}.sh"
	echo -e "\nRunning command: \n${CMD}" >> ${BIG}/logs/${TODAY}_main.log
        mkdir -p ${BIG}/logs/slurm/
        mkdir -p $BIG/logs/${TODAY}_${1}_slurm
	local __jobvar=${1}
	JOB_ID=`echo $(${CMD}) | tr ' ' '\n' | tail -n1` 
	eval $__jobvar="'$JOB_ID'"
}

multi_prog () {
        CMD="sbatch -a 0-${2} ${HOME}/scripts/${1}.sh"
        local __jobvar=${1}
        JOB_ID=`echo $(${CMD}) | tr ' ' '\n' | tail -n1`
        eval $__jobvar="'$JOB_ID'"
}

#-------------------------analysis------------------------------#

cd ${IN_DIR}

multi_prog jellyfish "$(expr $(ls ${IN_DIR}/*.fastq | wc -l) - 1)"
