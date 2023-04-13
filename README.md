# Github 리포지토리 검색/관리 앱
- [Github API](https://docs.github.com/ko/rest)를 이용한 앱입니다.  
웹과 같이 검색을 통해 Github 리포지토리들을 찾을 수 있습니다.  
로그인 기능을 통해서 프로필과 연동하여 star/unstar 기능도 사용할 수 있습니다.  
이 정보는 실시간으로 반영됩니다.
- 프로젝트 기간 : 22.11.16 ~ 22.11.25
- *커밋 이력은 Private 저장소에 따로 기록되어 있습니다.*

## Deployment Target
- iOS 13.0

## 라이브러리
- 라이브러리 관리
    - CocoaPods
- 라이브러리
    - Alamofire
        - RxSwift, RxCocoa
    - SwiftKeychainWrapper
    
## 사용예시
![](https://user-images.githubusercontent.com/60916423/231820262-9cfc2a96-bdd7-4240-a7fb-436cc9736eb4.gif)


## 소개
### 검색 화면, 레파지토리 셀
- 애플리케이션 처음 시작 시 볼 수 있는 검색 화면입니다.  
서치바와 레파지토리 목록을 보여줄 테이블뷰가 있습니다.  
서치바에 원하는 검색어를 입력하면 검색어를 서버로 보내어 얻은 레파지토리 목록을 보여줍니다.
- 레파지토리를 보여주는 각 셀은 이름, 설명, 토픽, 스타 갯수, 언어, 라이센스, 업데이트 날짜, 스타 버튼을 포함하고 있습니다.
    - 토픽 정보가 있는 레파지토리만 토픽 정보를 보여줍니다.
    - 언어, 라이센스 정보가 있는 레파지토리만 언어, 라이센스 정보를 보여줍니다.
    - 로그인이 되지 않았다면 레파지토리의 스타 버튼은 모두 회색의 채워지지 않은 모양입니다
- 토픽 정보와 스타 갯수를 포함하는 추가적인 레파지토리 정보는 Scrollable하여 짤리지 않고 모든 정보를 볼 수 있습니다.

### 로그인
- 프로필 화면에서 로그인이 되어있지 않으면 로그인을 위한 안내 화면이 나옵니다.
- 로그인을 하게 되면 사용자의 정보와 사용자의 Starred 레파지토리 목록을 보여줍니다.
    - 사용자의 정보는 사진, 이름, 한 줄 소개, 팔로워 수, 팔로잉 수 입니다.
- Github Oauth 인증으로 부터 얻은 Access token은 Keychain에 안전하게 보관하며, 이후 사용자의 정보가 필요한 서버 요청에 Access token을 추가하여 요청을 보냅니다.
    - 따라서 애플리케이션을 껐다가 켜도 Access token은 Keychain에 유지되므로 로그인 상태를 유지할 수 있습니다.
    - 만약 Access token이 유효하지 않다면 서버 요청에 대한 응답 코드를 통해서 알아내게 되며 자동으로 로그아웃 처리를 하게 됩니다.
- 로그인을 하면 우측 상단의 로그인 버튼의 문구가 “Login”에서 “Logout”으로 바뀝니다.
- 검색 화면에서는 레파지토리의 Starred 여부가 색으로 구분되어 표시되고 스타 버튼을 누를 수 있습니다.

### 로그아웃
- 로그아웃 버튼을 누르게 되면 Alert을 통해 로그아웃 여부를 확인하고, 로그아웃 확인 버튼늘 누르면 검색 화면과 프로필 화면은 다시 로그인 전의 상태로 돌아갑니다.
- 로그아웃은 Keychain의 Access token을 삭제함으로써 구현되며, 재로그인 시 다시 Github 인증으로부터 Access token을 얻어와야 합니다.

### 주의 사항
- 검색 화면이나 프로필 화면에서 스타 버튼 클릭 시 곧바로 서버에 요청하여 데이터를 업데이트 합니다.  
따라서 곧바로 웹에서 확인했을 때는 업데이트 된 정상적인 데이터를 확인할 수 있습니다.  
그러나 앱에서는 곧바로 확인 시 데이터 업데이트가 바로 되지 않는 경우가 있었고, 최대 몇 초의 시간 뒤에 데이터가 업데이트되는 경우가 있었습니다.  
이는 데이터 업데이트 요청이나 데이터를 받아오는 요청이 실패하는 것은 아니고, 서버 요청을 통해 데이터는 잘 받아와지지만 업데이트 된 데이터를 가져오지 못하는 것으로 보아 Github의 캐시 서버에서 업데이트되지 않은 데이터를 주는 경우로 판단됩니다.
    - 스타 버튼을 누르면 서버에 데이터 업데이트 요청을 보내는데,  
    UI는 현재 앱의 데이터를 기반으로 새로운 상태를 표시하고(ex: 스타 on → off, 스타 카운트 10 → 9), viewWillAppear 시점에 새로운 데이터를 받아와서 표시하도록 구현하였습니다.
- 적은 경우에 로그인 요청이 실패하는 상황이 있었습니다.  
최대 몇 초의 시간을 잠시 기다린 후 다시 로그인 요청을 했을 때는 제대로 로그인되는 것을 보아, 앱에서 보내는 요청에는 달라진게 없는데 응답 결과가 다르므로 서버 측의 이슈가 있는 것으로 판단됩니다.

## 설계
- 필요 기능  
![](https://user-images.githubusercontent.com/60916423/231822086-5283f48d-8980-421f-9965-69b0859212a5.png)

- Use-case 다이어그램  
![](https://user-images.githubusercontent.com/60916423/231821119-a6c1535b-b792-43d5-ad14-e73df58c8773.png)

- Class 다이어그램  
![](https://user-images.githubusercontent.com/60916423/231821110-e563e6da-f760-4089-a546-f492c83c60a2.png)