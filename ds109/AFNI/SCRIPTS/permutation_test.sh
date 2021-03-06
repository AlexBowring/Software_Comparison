cd /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL2/permutation_test

# Create a group mask
3dmask_tool                                                 \
    -prefix mask.nii.gz                                     \
    -input `ls /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-*/sub*/mask_epi_anat.*.HEAD` \
    -frac 1.0

# t-test analysis
3dttest++ 					       \
    -Clustsim 1 				       \
    -prefix perm_ttest++_Clustsim_result.nii.gz        \
    -prefix_clustsim Clustsim			       \
    -mask /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL2/permutation_test/mask.nii.gz   		       \
    -setA setA                    		       \
             01 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-01/sub01.results/stats.sub01_REML+tlrc.HEAD[14]" \
             02 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-02/sub02.results/stats.sub02_REML+tlrc.HEAD[14]" \
             03 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-03/sub03.results/stats.sub03_REML+tlrc.HEAD[14]" \
             04 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-08/sub08.results/stats.sub08_REML+tlrc.HEAD[14]" \
             05 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-09/sub09.results/stats.sub09_REML+tlrc.HEAD[14]" \
             06 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-10/sub10.results/stats.sub10_REML+tlrc.HEAD[14]" \
             07 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-11/sub11.results/stats.sub11_REML+tlrc.HEAD[14]" \
             08 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-14/sub14.results/stats.sub14_REML+tlrc.HEAD[14]" \
             09 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-15/sub15.results/stats.sub15_REML+tlrc.HEAD[14]" \
             10 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-17/sub17.results/stats.sub17_REML+tlrc.HEAD[14]" \
             11 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-18/sub18.results/stats.sub18_REML+tlrc.HEAD[14]" \
             12 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-21/sub21.results/stats.sub21_REML+tlrc.HEAD[14]" \
             13 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-22/sub22.results/stats.sub22_REML+tlrc.HEAD[14]" \
             14 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-26/sub26.results/stats.sub26_REML+tlrc.HEAD[14]" \
             15 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-27/sub27.results/stats.sub27_REML+tlrc.HEAD[14]" \
             16 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-28/sub28.results/stats.sub28_REML+tlrc.HEAD[14]" \
             17 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-30/sub30.results/stats.sub30_REML+tlrc.HEAD[14]" \
             18 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-31/sub31.results/stats.sub31_REML+tlrc.HEAD[14]" \
             19 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-32/sub32.results/stats.sub32_REML+tlrc.HEAD[14]" \
             20 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-43/sub43.results/stats.sub43_REML+tlrc.HEAD[14]" \
             21 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-48/sub48.results/stats.sub48_REML+tlrc.HEAD[14]" 

# Obtaining cluster extent threshold from the ClustSim.*.1D table
#clust_thrvol=`1d_tool.py -verb 0                                       \
#                        -infile Clustsim.CSimA.NN1_1sided.1D           \
#                        -csim_pthr   0.01                              \
#                        -csim_alpha "0.05"`
#echo "++ The final cluster volume threshold is: $clust_thrvol"

# Obtaining cluster-forming threshold
voxstat_thr=`p2dsetstat -quiet                                   \
                    -pval 0.005                                   \
                    "-1sided"                                    \
                    -inset perm_ttest++_Clustsim_result.nii.gz'[setA_Zscr]'`
echo "++ The voxelwise stat value threshold is: $voxstat_thr"

# Masking t-stat
3dcalc                                          \
    -a perm_ttest++_Clustsim_result.nii.gz      \
    -b mask.nii.gz                              \
    -expr 'a*b'                                 \
    -prefix perm_ttest++_Clustsim_result_t_stat_masked_4d.nii.gz 

# Obtaining thresholded results
# Positive clusters
3dclust                                                                \
    -1Dformat -nosum -1tindex 1 -1dindex 0                             \
    -2thresh -1e+09 $voxstat_thr  -dxyz=1                             \
    -savemask perm_Positive_clust_mask.nii.gz                          \
    1.01 892 perm_ttest++_Clustsim_result_t_stat_masked_4d.nii.gz

# Binarizing
3dcalc \
    -a perm_Positive_clust_mask.nii.gz                                      \
    -b perm_ttest++_Clustsim_result.nii.gz'[1]'                             \
    -expr "step(a)*b"                                                       \
    -prefix perm_Positive_clustered_t_stat.nii.gz                           \
    -float

# Negative clusters
3dclust                                                                \
    -1Dformat -nosum -1tindex 1 -1dindex 0                             \
    -2thresh -$voxstat_thr 1e+09 -dxyz=1                              \
    -savemask perm_Negative_clust_mask.nii.gz                          \
    1.01 892 perm_ttest++_Clustsim_result_t_stat_masked_4d.nii.gz

# Binarizing
3dcalc \
    -a perm_Negative_clust_mask.nii.gz                                      \
    -b perm_ttest++_Clustsim_result.nii.gz'[1]'                             \
    -expr "-step(a)*b"                                                      \
    -prefix perm_Negative_clustered_t_stat.nii.gz                           \
    -float

# Obtain 3d volumes from 4d volume to upload to Neurovault
3dTcat -prefix perm_ttest++_Clustsim_result_t_stat.nii.gz perm_ttest++_Clustsim_result.nii.gz'[1]'
3dTcat -prefix perm_ttest++_Clustsim_result_t_stat_masked.nii.gz perm_ttest++_Clustsim_result_t_stat_masked_4d.nii.gz'[1]'
