#!/usr/bin/env bash
set ex
. /opt/JARVICE/jarvice_mpi.sh
saturne_ver=7.0.5
cd  
mkdir -p code_saturne/${saturne_ver}/build
mkdir -p code_saturne/${saturne_ver}/sources
cd code_saturne/${saturne_ver}/sources
ln -s /LOCAL/code_saturne/TAR/code_saturne-${saturne_ver}.tar.gz ./code_saturne-${saturne_ver}.tar.gz
tar xfz code_saturne-${saturne_ver}.tar.gz
cd ../build
../sources/code_saturne-${saturne_ver}/install_saturne.py CC=gcc CXX=g++ FC=gfortran
for ar in $(ls /LOCAL/code_saturne/TAR/*.tar.gz)
do
  echo $ar
  ln -s $ar $(basename $ar)
done
ls -lrt

sed -i 's@download  yes@download  no@g' setup 
sed -i 's@hdf5       no    no       None@hdf5       yes   yes      None@g' setup 
sed -i 's@cgns       no    no       None@cgns       yes   yes      None@g' setup  
sed -i 's@med        no    no       None@med        yes   yes      None@g' setup  
sed -i 's@scotch     no    no       None@scotch     yes   yes      None@g' setup  
sed -i 's@parmetis   no    no       None@parmetis   yes   yes      None@g' setup 
sed -i "s@$HOME/Code_Saturne/${saturne_ver}@/LOCAL/code_saturne/${saturne_ver}@g" setup

cat setup 
../sources/code_saturne-${saturne_ver}/install_saturne.py  CC=gcc CXX=g++ FC=gfortran
exit 0
