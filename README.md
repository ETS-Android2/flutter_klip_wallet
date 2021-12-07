## Introduction
본인의 클립(Klip) 지갑에 있는, 특정 스마트 컨트랙트에서 발행된 NFT 목록을 조회할 수 있는 안드로이드 앱입니다. <br />
Flutter 프레임워크로 개발했으며, MethodChannel을 통해 App2App SDK를 사용했습니다.
- 프로젝트 root 디렉토리에 .env 파일을 생성하여 KLIP_SCA=*[NFT 발행 스마트 컨트랙트의 주소]* 줄을 추가해줍니다.
- 카카오톡이 설치되어있는 안드로이드 환경에서 작동합니다. 
- 'Klip으로 로그인' 버튼을 눌러서 클립 지갑에서 정보 제공 동의 후, NFT 조회 버튼을 누르면 하단에 격자 이미지 형태로 NFT 목록이 생성됩니다. 
- 각 이미지를 터치하면 NFT 상세 조회 팝업이 열립니다.
- 'Total(Klay) Balance'와 'Operations'는 현재 동작하지 않습니다.

-----

This is an Android app that allows you to view the list of NFTs minted by certain smart contract in your Klip wallet. <br />
Developed with Flutter framework, using App2App SDK via MethodChannel.
- Make .env file at project root directory and add following line: KLIP_SCA=*[NFT minting smart contract address]*
- Works in the Android environment where KakaoTalk is installed.
- Click the 'Login with Klip' button to agree to the provision of information in the Clip Wallet, and then click the NFT inquiry button to create a list of NFTs in the form of a grid image at the bottom.
- Touch each image to open the NFT detailed inquiry popup.
- 'Total(Klay) Balance' and 'Operations' are not currently working.

## Screenshots
<img src="https://user-images.githubusercontent.com/60031762/144945130-9ac8061a-87a1-4e19-a326-dadbef629925.png" height="700" />

## Development Environment
- Flutter 2.5.3
- Android Studio 2020.3

## Application Version
- minSdkVersion : 16
- targetSdkVersion : 30

## References
- Klip App2App API & Klip App2App Android SDK: https://docs.klipwallet.com/
- UI: https://github.com/TheAlphamerc/flutter_wallet_app
