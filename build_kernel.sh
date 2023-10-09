#!/bin/bash

export ARCH=arm64
mkdir out

BUILD_CROSS_COMPILE=$(pwd)/toolchain/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
KERNEL_LLVM_BIN=$(pwd)/toolchain/llvm-arm-toolchain-ship/10.0/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-
KERNEL_MAKE_ENV="DTC_EXT=$(pwd)/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y"

make -j8 -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE vendor/x1q_kor_singlex_defconfig
make -j8 -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE

IMAGE="out/arch/arm64/boot/Image.gz-dtb"

if [[ -f "$IMAGE" ]]; then
	rm AnyKernel3/zImage > /dev/null 2>&1
	rm AnyKernel3/*.zip > /dev/null 2>&1
	cp $IMAGE AnyKernel3/zImage
	cd AnyKernel3
	zip -r9 Kernel-x1q.zip .
fi