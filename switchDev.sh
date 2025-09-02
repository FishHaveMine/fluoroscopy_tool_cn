#!/bin/bash

set -e

echo "请选择打包环境:"
select ENV in "dev" "prod"; do
  if [[ "$ENV" == "dev" || "$ENV" == "prod" ]]; then
    break
  else
    echo "无效选择，请输入 1 或 2"
  fi
done

# 获取版本号信息
VERSION_LINE=$(grep '^version:' pubspec.yaml)
MAIN_VERSION=$(echo "$VERSION_LINE" | cut -d ':' -f2 | cut -d '+' -f1 | xargs)
BUILD_NUMBER=$(echo "$VERSION_LINE" | cut -d '+' -f2 | xargs)
CURRENT_TIME=$(date +"%Y%m%d%H%M%S")

# 设置包名和 App 名称
if [[ "$ENV" == "dev" ]]; then
  PACKAGE_NAME="com.example.fluoroscopy_tool.dev"
  APP_NAME="内销测试"
else
  PACKAGE_NAME="com.example.fluoroscopy_tool"
  APP_NAME="楼宇大师"
fi

# 修改包名（applicationId）
BUILD_GRADLE="android/app/build.gradle"
sed -i '' "s/applicationId \".*\"/applicationId \"$PACKAGE_NAME\"/" "$BUILD_GRADLE"
echo "修改包名（applicationId）- $PACKAGE_NAME"

# 修改 App 名称（android:label）
MANIFEST_PATH="android/app/src/main/AndroidManifest.xml"
sed -i '' "s/android:label=\"[^\"]*\"/android:label=\"$APP_NAME\"/" "$MANIFEST_PATH"
echo "修改 App 名称（android:label）- $APP_NAME"

echo "externalVersion- $MAIN_VERSION"
echo "internalVersion- $BUILD_NUMBER"
