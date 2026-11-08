#!/bin/bash

#image path
IMAGE_LOADER=MiniLoaderAll.bin
IMAGE_PARAMETER=parameter
IMAGE_TRUST=Image/trust.img
IMAGE_UBOOT=Image/uboot.img
IMAGE_MISC=Image/misc.img
IMAGE_BOOT=Image/boot.img
IMAGE_RECOVERY=Image/recovery.img
IMAGE_RESOURCE=Image/resource.img
IMAGE_SYSTEM=Image/system.img
IMAGE_UPDATE=Image/update.img
IMAGE_UNTI_UPDATE=update.img
PACKAGE_FILE=package-file

#key 
PRIVATE_KEY="privateKey.bin"
PUBLIC_KEY="publicKey.bin"
SECURE_EXE=SecureBootConsole
AFPTOOL_EXE=afptool
RKIMAGEMAKER_EXE=rkImageMaker

pause()
{
echo "Press any key to quit:"
read -n1 -s key
exit 1
}
if [ ! -f "$SECURE_EXE" ]; then
	echo "Error: No Found SecureBootConsole"
	pause
fi
if [ ! -f "$PRIVATE_KEY" ]; then
	echo "Error: No Found private Key"
	pause
fi
if [ ! -f "$PUBLIC_KEY" ]; then
	echo "Error: No Found public Key"
	pause
fi

echo "start to Sign Loader..."
if [ ! -f "$IMAGE_LOADER" ]; then
	echo "Error:No found Loader!"
	pause
else
	./$SECURE_EXE -sl $PUBLIC_KEY $IMAGE_LOADER
fi

echo "start to sign trust.img..."
if [ ! -f "$IMAGE_TRUST" ]; then
	echo "Error:No found trust.img!"
else
	./$SECURE_EXE -si $PRIVATE_KEY $IMAGE_TRUST
fi

echo "start to sign uboot.img..."
if [ ! -f "$IMAGE_UBOOT" ]; then
	echo "Error:No found uboot.img!"
else
	./$SECURE_EXE -si $PRIVATE_KEY $IMAGE_UBOOT
fi

echo "start to sign recovery.img..."
if [ ! -f "$IMAGE_RECOVERY" ]; then
	echo "Error:No found recovery.img!"
else
	./$SECURE_EXE -si $PRIVATE_KEY $IMAGE_RECOVERY
fi

echo "start to sign boot.img..."
if [ ! -f "$IMAGE_BOOT" ]; then
	echo "Error:No found boot.img!"
else
	./$SECURE_EXE -si $PRIVATE_KEY $IMAGE_BOOT
fi


echo "start to make update.img..."
if [ ! -f "$IMAGE_PARAMETER" ]; then
	echo "Error:No found parameter!"
	pause
fi
if [ ! -f "$PACKAGE_FILE" ]; then
	echo "Error:No found package-file!"
	pause
fi
./$AFPTOOL_EXE -pack ./ $IMAGE_UPDATE || pause
./$RKIMAGEMAKER_EXE -RK33A $IMAGE_LOADER $IMAGE_UPDATE $IMAGE_UNTI_UPDATE -os_type:androidos || pause
echo "Making update.img OK."
echo "Sign Firmware's digest"
if [ ! -f "$IMAGE_UNTI_UPDATE" ]; then
	echo "Error:No found update.img!"
	pause
fi
#./$SECURE_EXE -p -sh $PRIVATE_KEY $IMAGE_UNTI_UPDATE
echo "Succeed,Press any key to quit:"
read -n1 -s key
exit 0