#!/bin/sh

# decompress rpms into temporay folder
DIR=/tmp/pckgs_$(date "+%Y_%m_%d_%H_%M_%S")
echo "Decompressing into temporary folder $DIR"
mkdir $DIR
mv /tmp/pkginstall/simaai-package-palette-$MACHINE.tar.gz $DIR
pushd $DIR
tar -xzf simaai-package-palette-$MACHINE.tar.gz
popd

# install rpm repo file
echo "Installing local rpm repository"
mkdir -p /etc/yum.repos.d
cp /tmp/pkginstall/simaai-local.repo /etc/yum.repos.d/
echo "baseurl=$DIR" >> /etc/yum.repos.d/simaai-local.repo
dnf makecache

# install all rpms one by one and prepare report
if [[ $FORCE_REINSTALL -ne 0 ]]; then
    action="force re-"
fi
echo $action"installing $(wc -l < $DIR/list.txt) rpm packages"
LOG=/tmp/simaai_rpms_log.txt
rm -rf $LOG
dnf -y install $(cat $DIR/list.txt | tr '\n' ' ') | tee $LOG
result=${PIPESTATUS[0]}
if [[ $FORCE_REINSTALL -ne 0 && $result -eq 0 ]]; then
    dnf -y reinstall $(cat $DIR/list.txt | tr '\n' ' ') | tee $LOG
    result=${PIPESTATUS[0]}
fi

# report the result
echo "Installation completed: $result"
if [[ $result -eq 0 ]]; then
    echo "SiMa.ai Palette package succesfully installed"
else
    echo "SiMa.ai Palette package installation failed"
fi
echo "Installation log: $LOG"

# clean temporary folder
rm -rf $DIR
rm -rf /etc/yum.repos.d/simaai-local.repo
dnf makecache
rm -rf /tmp/pkginstall

exit $result
