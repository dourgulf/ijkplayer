#!/bin/sh

# this scripts resign to run in Xcode aggregate target

UNIVERSAL_OUTPUT_FOLDER="${PROJECT_DIR}/build/${CONFIGURATION}"

# make the output directory and delete the framework directory
mkdir -p "${UNIVERSAL_OUTPUT_FOLDER}"
rm -rf "${UNIVERSAL_OUTPUT_FOLDER}/${PROJECT_NAME}.framework"

# Step 1. Build Device and Simulator versions
xcodebuild -project "${PROJECT_NAME}.xcodeproj" -target "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
# ffmpeg在i386架构下编译需要使用“-read_only_relocs suppress”参数，
# 而此参数又和bitcode冲突，实际上模拟器也并不需要什么i386版本了，于是去掉
xcodebuild -project "${PROJECT_NAME}.xcodeproj" -target "${PROJECT_NAME}" -arch x86_64 -configuration ${CONFIGURATION} -sdk iphonesimulator BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build

# Step 2. Copy the framework structure to the universal folder
echo "==============Step 2=============="
echo "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework"

cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework" "${UNIVERSAL_OUTPUT_FOLDER}/"

DEBUG_SYM_DIR="${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework.dSYM"
if [ -d ${DEBUG_SYM_DIR} ]; then
	cp -R  "${DEBUG_SYM_DIR}" "${UNIVERSAL_OUTPUT_FOLDER}/"
fi

# Step 3. Create universal binary file using lipo and place the combined executable in the copied framework directory
lipo -create -output "${UNIVERSAL_OUTPUT_FOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework/${PROJECT_NAME}"

echo "==============Completion=============="
echo "${UNIVERSAL_OUTPUT_FOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}"

# Step 4. Copy strings bundle if exists
STRINGS_INPUT_FOLDER="${PROJECT_NAME}Strings.bundle"
if [ -d "${STRINGS_INPUT_FOLDER}" ]; then
STRINGS_OUTPUT_FOLDER="${UNIVERSAL_OUTPUT_FOLDER}/${PROJECT_NAME}Strings.bundle"
rm -rf "${STRINGS_OUTPUT_FOLDER}"
cp -R "${STRINGS_INPUT_FOLDER}" "${STRINGS_OUTPUT_FOLDER}"
fi