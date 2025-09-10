# Create-.XCFramework-in-iOS
## Create .XCFramework in iOS

### Tạo thư viện đóng gói trong ios 

### 1. Chuẩn bị Project
**Ví dụ nhự HuyQRScanner** <br>

Xong cd vào project bắt đầu chạy lệnh 

### 2. Tạo XCFramework bằng Xcode Command Line
Mở Terminal và navigate đến thư mục project của bạn, sau đó chạy các lệnh sau: <br>
Bước 1: Build cho iOS Device <br>
```swift
xcodebuild archive \
  -project HuyQRScanner.xcodeproj \
  -scheme HuyQRScanner \
  -destination "generic/platform=iOS" \
  -archivePath "build/HuyQRScanner-iOS.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

```
### Bước 2: Build cho iOS Simulator

```swift
xcodebuild archive \
  -project HuyQRScanner.xcodeproj \
  -scheme HuyQRScanner \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "build/HuyQRScanner-iOS-Simulator.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES
```

### Bước 3: Tạo XCFramework
```swift
xcodebuild -create-xcframework \
  -framework "build/HuyQRScanner-iOS.xcarchive/Products/Library/Frameworks/HuyQRScanner.framework" \
  -framework "build/HuyQRScanner-iOS-Simulator.xcarchive/Products/Library/Frameworks/HuyQRScanner.framework" \
  -output "build/HuyQRScanner.xcframework"

```

### 3. Script tự động hóa
Tạo file **build_xcframework.sh** để tự động hóa quá trình:
```swift
#!/bin/bash

# Tên project và scheme
PROJECT_NAME="HuyQRScanner"
SCHEME_NAME="HuyQRScanner"

# Tạo thư mục build
mkdir -p build

# Clean previous builds
rm -rf build/*

echo "Building for iOS Device..."
xcodebuild archive \
  -project ${PROJECT_NAME}.xcodeproj \
  -scheme ${SCHEME_NAME} \
  -destination "generic/platform=iOS" \
  -archivePath "build/${PROJECT_NAME}-iOS.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "Building for iOS Simulator..."
xcodebuild archive \
  -project ${PROJECT_NAME}.xcodeproj \
  -scheme ${SCHEME_NAME} \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "build/${PROJECT_NAME}-iOS-Simulator.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "build/${PROJECT_NAME}-iOS.xcarchive/Products/Library/Frameworks/${PROJECT_NAME}.framework" \
  -framework "build/${PROJECT_NAME}-iOS-Simulator.xcarchive/Products/Library/Frameworks/${PROJECT_NAME}.framework" \
  -output "build/${PROJECT_NAME}.xcframework"

echo "XCFramework created successfully at build/${PROJECT_NAME}.xcframework"

```
### 4. Chạy script
```swift
chmod +x build_xcframework.sh
./build_xcframework.sh
```

Sau khi có thư mục : HuyQRScanner.xcframework thì add vào trong xcode <br>
<img width="1144" height="512" alt="Screenshot 2025-09-10 at 12 12 22" src="https://github.com/user-attachments/assets/72746639-29ab-46e6-857a-fc31f069618c" /> <br>

<img width="1086" height="647" alt="image" src="https://github.com/user-attachments/assets/1dbae937-ca04-44ec-b1dd-f6acbb3b02bf" />

