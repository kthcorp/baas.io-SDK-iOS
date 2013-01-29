# Baas.io-SDK-iOS 

> https://github.com/baasio/baas.io-sdk-ios 로 이전했습니다.
>
> 이 Repository는 더 이상 사용되지 않습니다.

##Requirement 

**Command Line Tools 설치**

Xcode - Perferences - Downloads - Command Line Tools가 installed 상태인지 확인해주세요. 
<br>
<br>
## Install
Baas.io-SDK-iOS는 git의 submodules로 구성 되어 있습니다. SoruceTree 같은 툴을 이용할 경우 자동적으로 submodule을 인식하나, zip으로 다운의 경우 특별한 설정이 필요합니다. 그래서 터미널에서 아래와 같이 clone 하는 것을 추천합니다.

	# git clone --recursive git://github.com/kthcorp/baas.io-SDK-iOS.git

또는

	# git clone git://github.com/kthcorp/baas.io-SDK-iOS.git
	# cd baas.io-SDK-iOS
	# ./submodule_setup.sh

zip으로 다운 받으신 경우에는 사용 할 수 없습니다. 아래 링크에서 소스를 다운 받으세요.
<br>
https://baas.io/docs/ko/ios/download.html

## Build
일부 Xcode 버전에서 첫번째 빌드에서 header 파일을 못 찾는 버그가 있습니다. 컴파일 에러 발생 시 Project를 Clean(Shift+Cmd+K)하고 다시 Build(Cmd+R)하면 됩니다.


## 프로젝트에 추가하기
1. baas.io-sdk.xcodeproj 파일을 드래그하여 추가하려는 프로젝트에 넣는다.
2. [Build Settings] - [Header Search Paths]에 아래와 같이 입력하고, recursive 설정을 합니다.
	
	$(BUILT_PRODUCTS_DIR)/include


3. [Build Phases] - [Target Dependencies]에 baas.io-sdk를 추가합니다.
4. [Build Phases] - [Link Binary With Libraries]에 libbaas.io-sdk.a를 추가합니다.
