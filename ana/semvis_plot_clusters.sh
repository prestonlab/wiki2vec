#!/bin/bash

gl=0
gh=6.8

# whole brain, all models

# faces
fsleyes \
    ~/work/bender/gptemplate/highres_brain_all/gp_template_mni_affine.nii.gz -cm greyscale -dr $gl $gh \
    ~/work/bender/batch/rsa/prex_mn3_hmax_face/stat_thresh.nii.gz -cm colormap1 -inc -dr 2.3 4 -a 50 -n face_visual \
    ~/work/bender/batch/rsa/prex_mn3_subcat_face/stat_thresh.nii.gz -cm colormap2 -inc -dr 2.3 4 -a 50 -n face_subcat \
    ~/work/bender/batch/rsa/prex_mn3_wiki_w2v_face/stat_thresh.nii.gz -cm colormap3 -inc -dr 2.3 4 -a 50 -n face_wikiw2v &

# scenes
fsleyes \
    ~/work/bender/gptemplate/highres_brain_all/gp_template_mni_affine.nii.gz -cm greyscale -dr $gl $gh \
    ~/work/bender/batch/rsa/prex_mn3_hmax_scene/stat_thresh.nii.gz -cm colormap1 -inc -dr 2.3 4 -a 50 -n scene_visual \
    ~/work/bender/batch/rsa/prex_mn3_subcat_scene/stat_thresh.nii.gz -cm colormap2 -inc -dr 2.3 4 -a 50 -n scene_subcat \
    ~/work/bender/batch/rsa/prex_mn3_wiki_w2v_scene/stat_thresh.nii.gz -cm colormap3 -inc -dr 2.3 4 -a 50 -n scene_wikiw2v \
    ~/work/bender/batch/rsa/prex_mn3_geo_scene/stat_thresh.nii.gz -cm colormap4 -inc -dr 2.3 4 -a 50 -n scene_geo &

# mpfc

# faces
cd ~/work/bender/batch/rsa/prex_mn3_subcat_face
fslmaths cluster_mask100 -thr 61 -uthr 61 -bin ampfc
fslmaths stat_thresh -mas ampfc stat_ampfc

cd ~/work/bender/batch/rsa/prex_mn3_wiki_w2v_face
fslmaths cluster_mask100 -thr 72 -uthr 72 -bin vmpfc
fslmaths cluster_mask100 -thr 73 -uthr 73 -bin dmpfc
fslmaths stat_thresh -mas vmpfc stat_vmpfc
fslmaths stat_thresh -mas dmpfc stat_dmpfc

fsleyes \
    ~/work/bender/gptemplate/highres_brain_all/gp_template_mni_affine.nii.gz -cm greyscale -dr $gl $gh \
    ~/work/bender/batch/rsa/prex_mn3_subcat_face/stat_ampfc.nii.gz -cm colormap2 -inc -dr 2.3 4 \
    ~/work/bender/batch/rsa/prex_mn3_wiki_w2v_face/stat_vmpfc.nii.gz -cm colormap3 -inc -dr 2.3 4 \
    ~/work/bender/batch/rsa/prex_mn3_wiki_w2v_face/stat_dmpfc.nii.gz -cm colormap3 -inc -dr 2.3 4 &

# scenes
cd ~/work/bender/batch/rsa/prex_mn3_subcat_scene
fslmaths cluster_mask100 -thr 90 -uthr 90 -bin dmpfc
fslmaths stat_thresh -mas dmpfc stat_dmpfc

fsleyes \
    ~/work/bender/gptemplate/highres_brain_all/gp_template_mni_affine.nii.gz -cm greyscale -dr $gl $gh \
    ~/work/bender/batch/rsa/prex_mn3_subcat_scene/stat_dmpfc.nii.gz -cm colormap2 -inc -dr 2.3 4 &


# hpc

# faces
cd ~/work/bender/batch/rsa/prex_mn3_subcat_face
fslmaths cluster_mask100 -thr 71 -uthr 71 -bin rhpc
fslmaths rhpc -mas ~/work/bender/gptemplate/highres_brain_all/b_hip rhpc
fslmaths stat_thresh -mas rhpc stat_rhpc

cd ~/work/bender/batch/rsa/prex_mn3_wiki_w2v_face
fslmaths cluster_mask100 -thr 56 -uthr 56 -bin lhpc
fslmaths stat_thresh -mas lhpc stat_lhpc

fsleyes \
    ~/work/bender/gptemplate/highres_brain_all/gp_template_mni_affine.nii.gz -cm greyscale -dr $gl $gh \
    ~/work/bender/batch/rsa/prex_mn3_subcat_face/stat_rhpc.nii.gz -cm colormap2 -inc -dr 2.3 4 \
    ~/work/bender/batch/rsa/prex_mn3_wiki_w2v_face/stat_lhpc.nii.gz -cm colormap3 -inc -dr 2.3 4 &

# scenes
cd ~/work/bender/batch/rsa/prex_mn3_wiki_w2v_scene
fslmaths cluster_mask100 -thr 28 -uthr 28 -bin rhpc
fslmaths stat_thresh -mas rhpc stat_rhpc
fslmaths cluster_mask100 -thr 26 -uthr 26 -bin lhpc
fslmaths stat_thresh -mas lhpc stat_lhpc

cd ~/work/bender/batch/rsa/prex_mn3_geo_scene
fslmaths cluster_mask100 -thr 116 -uthr 116 -bin rhpc
fslmaths rhpc -mas ~/work/bender/gptemplate/highres_brain_all/b_hip rhpc
fslmaths stat_thresh -mas rhpc stat_rhpc
fslmaths cluster_mask100 -thr 110 -uthr 110 -bin lhpc
fslmaths lhpc -mas ~/work/bender/gptemplate/highres_brain_all/b_hip lhpc
fslmaths stat_thresh -mas lhpc stat_lhpc

fsleyes \
    ~/work/bender/gptemplate/highres_brain_all/gp_template_mni_affine.nii.gz -cm greyscale -dr $gl $gh \
    ~/work/bender/batch/rsa/prex_mn3_wiki_w2v_scene/stat_lhpc.nii.gz -cm colormap3 -inc -dr 2.3 4 \
    ~/work/bender/batch/rsa/prex_mn3_wiki_w2v_scene/stat_rhpc.nii.gz -cm colormap3 -inc -dr 2.3 4 \
    ~/work/bender/batch/rsa/prex_mn3_geo_scene/stat_lhpc.nii.gz -cm colormap4 -inc -dr 2.3 4 \
    ~/work/bender/batch/rsa/prex_mn3_geo_scene/stat_rhpc.nii.gz -cm colormap4 -inc -dr 2.3 4 &
