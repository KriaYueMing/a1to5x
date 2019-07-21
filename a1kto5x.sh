#!/bin/bash

#path
path="$(cd "$(dirname "$0")";pwd)"
echo $path

if [ -d TissotKernel ]; then
    echo "cd TissotKernel"
    cd TissotKernel
    if [ -d output ]; then
        rm -rf output
        mkdir output
    else
        mkdir output
    fi
    count=`ls -l *.zip | grep "^-" | wc -l`
    if [ "$count" = "1" ];then
        echo "$count=1"
        unzip *.zip -d output
        if [ -d old ]; then
            echo "old folder existed "
        else
            mkdir old
        fi
        fullname=*.zip
        filename=$(basename $fullname)
        mv *.zip old/
        cd old
        cd ..
        cd output
        echo "anykernel.sh patching..."
        sed -i 's/device.name1=tissot/device.name1=tiffany/' anykernel.sh
        sed -i 's/is_slot_device=1/is_slot_device=0/' anykernel.sh
        grep -q "ro.treble.enabled" anykernel.sh
        if [ $? -eq 0 ];then
            sed -i 's/\/system_root//' anykernel.sh
        fi
        if [ -d dtb-nontreble ]; then
            cd dtb-nontreble
            temp=$(ls -l *.dtb | awk '/^[^d]/ {print $5,$9}' | sort -nr | head -1)
            dtb=${temp##* }
            dts=${dtb%.*}.dts
            dtc -q -I dtb -O dts -o $dts $dtb
            rm $dtb
            cp $path/flags.txt ./
            sed -i '/parts/{n;d;}' $dts
            sed -i '/vbmeta/d' $dts
            sed -i '/android,system/{n;d;}' $dts
            sed -i '/android,system/{n;d;}' $dts
            sed -i '/android,system/{n;d;}' $dts
            sed -i '/android,system/d' $dts
            sed -i 'N;/\n.*,slotselect/!P;D' $dts
            sed -i '/,slotselect/{n;d;}' $dts
            sed -i '/,slotselect/{n;d;}' $dts
            sed -i '/,slotselect/d' $dts
            sed -i '/,fstab/r flags.txt' $dts
            sed -i '/,fstab/G' $dts
            sed -i '/android,firmware/{n;d;}' $dts
            sed -i 's/,avb//g' $dts
            sed -i '/,slotselect/{n;s/disable/ok/;}' $dts
            sed -i 's/,slotselect//g' $dts
            dtc -q -I dts -O dtb -o $dtb $dts
            rm $dts
            rm flags.txt
            cd ..
        fi
        if [ -d dtb-treble ]; then
            cd dtb-treble
            temp=$(ls -l *.dtb | awk '/^[^d]/ {print $5,$9}' | sort -nr | head -1)
            dtb=${temp##* }
            dts=${dtb%.*}.dts
            dtc -q -I dtb -O dts -o $dts $dtb
            rm $dtb
            cp $path/flags.txt ./
            sed -i '/parts/{n;d;}' $dts
            sed -i '/vbmeta/d' $dts
            sed -i '/android,system/{n;d;}' $dts
            sed -i '/android,system/{n;d;}' $dts
            sed -i '/android,system/{n;d;}' $dts
            sed -i '/android,system/d' $dts
            sed -i '/,fstab/r flags.txt' $dts
            sed -i '/,fstab/G' $dts
            sed -i '/android,firmware/{n;d;}' $dts
            sed -i 's/,avb//g' $dts
            sed -i '/,slotselect/{n;s/disable/ok/;}' $dts
            sed -i 's/,slotselect//g' $dts
            sed -i '/android,vendor/{n;s/vendor/cust/;}' $dts
            dtc -q -I dts -O dtb -o $dtb $dts
            rm $dts
            rm flags.txt
            cd ..
        fi
        if [ -d dtbs ]; then
            cd dtbs
            temp=$(ls -l *.dtb | awk '/^[^d]/ {print $5,$9}' | sort -nr | head -1)
            dtb=${temp##* }
            dts=${dtb%.*}.dts
            dtc -q -I dtb -O dts -o $dts $dtb
            rm $dtb
            cp $path/flags.txt ./
            until
            echo "Please select Treble Status?"
            echo "1.Treble"
            echo "2.Non-Treble"
            echo "Please enter the number(1 or 2): "
            read input
            test $input = 3
            do
                case $input in
			1)echo "Treble Status: Supported"
                          sed -i '/parts/{n;d;}' $dts
                          sed -i '/vbmeta/d' $dts
                          sed -i '/android,system/{n;d;}' $dts
                          sed -i '/android,system/{n;d;}' $dts
                          sed -i '/android,system/{n;d;}' $dts
                          sed -i '/android,system/d' $dts
                          sed -i 'N;/\n.*,slotselect/!P;D' $dts
                          sed -i '/,slotselect/{n;d;}' $dts
                          sed -i '/,slotselect/{n;d;}' $dts
                          sed -i '/,slotselect/d' $dts
                          sed -i '/,fstab/r flags.txt' $dts
                          sed -i '/,fstab/G' $dts
                          sed -i '/android,firmware/{n;d;}' $dts
                          sed -i '/,avb/{n;s/disable/ok/;}' $dts
                          sed -i 's/,avb//g' $dts
                          sed -i 's/,slotselect//g' $dts
                          sed -i '/android,vendor/{n;s/vendor/cust/;}' $dts
                          break
                          ;;
			2)echo "Treble Status: Non Supported"
                          sed -i '/parts/{n;d;}' $dts
                          sed -i '/vbmeta/d' $dts
                          sed -i '/android,system/{n;d;}' $dts
                          sed -i '/android,system/{n;d;}' $dts
                          sed -i '/android,system/{n;d;}' $dts
                          sed -i '/android,system/d' $dts
                          sed -i 'N;/\n.*,slotselect/!P;D' $dts
                          sed -i '/,slotselect/{n;d;}' $dts
                          sed -i '/,slotselect/{n;d;}' $dts
                          sed -i '/,slotselect/d' $dts
                          sed -i '/,fstab/r flags.txt' $dts
                          sed -i '/,fstab/G' $dts
                          sed -i '/android,firmware/{n;d;}' $dts
                          sed -i 's/,avb//g' $dts
                          sed -i 's/,slotselect//g' $dts
                          break
                          ;;
            esac
            done
            dtc -q -I dts -O dtb -o $dtb $dts
            rm $dts
            rm flags.txt
            cd ..
        fi
        if [ -f Image.gz-dtb ]; then
            split-appended-dtb Image.gz-dtb
            temp=$(ls -l *.dtb | awk '/^[^d]/ {print $5,$9}' | sort -nr | head -1)
            dtb=${temp##* }
            dts=${dtb%.*}.dts
            dtc -q -I dtb -O dts -o $dts $dtb
            rm $dtb
            cp $path/flags.txt ./
            until
            echo "Please select Treble Status?"
            echo "1.Treble"
            echo "2.Non-Treble"
            echo "Please enter the number(1 or 2): "
            read input
            test $input = 3
            do
                case $input in
			1)echo "Treble Status: Supported"
                          sed -i '/parts/{n;d;}' $dts
                          sed -i '/vbmeta/d' $dts
                          sed -i '/android,system/{n;d;}' $dts
                          sed -i '/android,system/{n;d;}' $dts
                          sed -i '/android,system/{n;d;}' $dts
                          sed -i '/android,system/d' $dts
                          sed -i '/,discard/{n;s/,slotselect//;}' *.dts
                          sed -i '/,avb/{n;s/status = "disable"/status = "ok"/;}' *.dts
                          sed -i 'N;/\n.*,slotselect/!P;D' $dts
                          sed -i '/,slotselect/{n;d;}' $dts
                          sed -i '/,slotselect/{n;d;}' $dts
                          sed -i '/,slotselect/d' $dts
                          sed -i '/,fstab/r flags.txt' $dts
                          sed -i '/,fstab/G' $dts
                          sed -i '/android,firmware/{n;d;}' $dts
                          sed -i 's/,avb//g' $dts
                          sed -i 's/,slotselect//g' $dts
                          sed -i '/android,vendor/{n;s/vendor/cust/;}' $dts
                          break
                          ;;
			2)echo "Treble Status: Non Supported"
                          sed -i '/parts/{n;d;}' $dts
                          sed -i '/vbmeta/d' $dts
                          sed -i '/android,system/{n;d;}' $dts
                          sed -i '/android,system/{n;d;}' $dts
                          sed -i '/android,system/{n;d;}' $dts
                          sed -i '/android,system/d' $dts
                          sed -i '/,slotselect/{n;s/status = "ok"/status = "disable"/;}' *.dts
                          sed -i '/,discard/{n;s/,slotselect//;}' *.dts
                          sed -i 'N;/\n.*,slotselect/!P;D' $dts
                          sed -i '/,slotselect/{n;d;}' $dts
                          sed -i '/,slotselect/{n;d;}' $dts
                          sed -i '/,slotselect/d' $dts
                          sed -i '/,fstab/r flags.txt' $dts
                          sed -i '/,fstab/G' $dts
                          sed -i '/android,firmware/{n;d;}' $dts
                          sed -i 's/,avb//g' $dts
                          sed -i 's/,slotselect//g' $dts
                          break
                          ;;
            esac
            done
            dtc -q -I dts -O dtb -o $dtb $dts
            rm $dts
            rm flags.txt
            rm Image.gz-dtb
            cat kernel *.dtb > Image.gz-dtb
            rm *.dtb
            rm kernel
        fi
        zip -q -r $filename.zip *
        for file in `ls | grep *tissot*.zip`; do  newfile=`echo $file | sed 's/tissot/tiffany/g'`;  mv $file $newfile; done
        for file in `ls | grep *Tissot*.zip`; do  newfile=`echo $file | sed 's/Tissot/Tiffany/g'`;  mv $file $newfile; done
        echo "done."
    else
        echo "The number of zip files in the current directory is greater than 1 or there is no zip file."
        echo "The script execution is aborted. Please check the number of current directory zip files."
        exit 1
    fi
    
else
    echo "TissotKernel folder does not exist,Script execution failed."
    exit 1
fi
