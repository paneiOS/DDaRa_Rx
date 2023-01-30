# MVVM-C/Rx를 적용한 라디오 프로젝트

## 목차
- [📻 프로젝트 소개](#-프로젝트-소개)
- [📻 Architecture](#-architecture)
- [📻 Foldering](#-foldering)
- [📻 Feature-1. 네트워크 구현](#-feature-1-네트워크-구현)
    + [고민한 점](#1-1-고민한-점) 
    + [Trouble Shooting](#1-2-trouble-shooting)
    + [키워드](#1-3-키워드)
- [📻 Feature-2. 상품 목록 화면 구현](#-feature-2-상품-목록화면-구현)
    + [고민한 점](#2-1-고민한-점)
    + [Trouble Shooting](#2-2-trouble-shooting)
    + [키워드](#2-3-키워드)
- [📻 Feature-3. 상품 상세화면 구현](#-feature-3-상품-상세화면-구현)
    + [고민한 점](#3-1-고민한-점) 
    + [Trouble Shooting](#3-2-trouble-shooting)
    + [키워드](#3-3-키워드)

## 📻 프로젝트 소개
`Network` 통신으로 서버에서 데이터를 받아 `CollectionView`로 라디오화면을 만들고 `TableView`로 즐겨찾기화면을 만듭니다.
`MainTabBar`로 3가지화면(설정화면을 포함하여)을 묶고 1개의 `PlayStatusView`를 공유하고있습니다.
라디오의 상세데이터는 `ActionSheet`로 보여주며 설정화면은 `ViewController`로 보여줍니다.

`MVVM-C` 및 `CleanArchiTecture` 를 적용했습니다.
사용한 라이브러리: `RxSwift`, `RxCocoa`, `RxDataSources`, `SnapKit`, `Kingfisher`

   
- 참여자 : Pane @kazamajinz (1명)

<br/>
   
|1. MenuBar|2. 목록 스크롤|3. 재생화면|4. 외부제어|5. 자동종료화면|
|-|-|-|-|-|
|<img width="200" src="https://user-images.githubusercontent.com/62927862/215344785-e03c1daf-c2cc-43c7-a89c-b07d17a59bb7.gif">|<img width="200" src="https://user-images.githubusercontent.com/62927862/215344951-c713a26b-db36-4860-aa5d-7bff9878ab24.gif">|<img width="200" src="https://user-images.githubusercontent.com/62927862/215344984-8952ab61-461e-4052-87b1-5a29188273cb.gif">|<img width="200" src="https://user-images.githubusercontent.com/62927862/215345007-87e497b5-3feb-41aa-9ee7-99a2db5fd7d2.gif">|<img width="200" src="https://user-images.githubusercontent.com/62927862/215345045-7d19e4ec-e5c0-4a30-aa16-a1463efd56d3.gif">|

## 📻 Architecture
![image](https://user-images.githubusercontent.com/62927862/215506774-f6c0784d-fb3c-4df6-afe3-a7d88a9be80b.png)


## 📻 Foldering
```
├── DDaRa
│   ├── App
│   ├── Data
│   │   ├── NetworkProvider
│   │   ├── ServiceAPI
│   ├── Domain
│   │   ├── DefaultStationsUseCase
│   ├── Presentation
│   │   ├── MainTabBarView
│   │   ├── SubComponents
│   │   │   ├── StationView
│   │   │   │   ├── View
│   │   │   │   ├── ViewModel
│   │   │   ├── FavoriteView
│   │   │   │   ├── View
│   │   │   │   ├── ViewModel
│   │   │   ├── PlayStatusView
│   │   │   │   ├── View
│   │   │   │   ├── ViewModel
│   │   │   ├── ActionSheetView
│   │   │   │   ├── View
│   │   │   │   ├── ViewModel
│   │   │   ├── Setting
│   │   │   │   ├── SettingViewController
│   │   │   │   ├── SubComponents
│   │   │   │   │   ├── SleepSettingViewController
│   ├── Common
│   │   ├── Protocol
│   │   ├── Timer
│   ├── Extension
│   └── Extension+Rx
└── DDaRaTestsTests
    └──Mock

```

## 📻 Feature-1. Architecture에 대한 고민
### 1-1 고민한 점 
#### 1️⃣ MVVM-C, Clean Architecture + MVVM 적용
명확한 계층분리를 위해 MVVM 구조에서 Coordinator를 view들의 계층을 관리하며 의존성을 주입합니다.
UseCase에 networkService를 주입하고 UseCase는 ViewModel에 주입하고 ViewModel에서도 Input-Output을 이용하여 명확하게 Input값과 Output값을 분리하고있습니다.
NetworkProvider에서 서버와의 통신에서는 URLSession을 주입하여 작동하지만 Test시에는 MockURLSession을 주입하여 작동합니다.
간단한 로직을 구현하는데 상당히 많은 양의 클래스가 필요했습니다. 이를위해 필요없는 요소를 축약하고 통합하였습니다.

#### 2️⃣ ViewModel에서 RxCocoa를 쓰면 안티패턴인가
ViewModel에서 RxCocoa를 import하고 있는데 RxCocoa를 import를 하고 있는게 안티패턴인가는 생각이 들었는데 많은 스타를 받은 다른분들의 MVVM의 아키텍처를 보면 ViewModel에서 input, output를 Driver로 전달하고 있는 예제들이 많이 있었습니다. 개인적인 생각은 써서 문제가 있다기보다는 필요성이 있을때 쓴다면 문제가 없는것 같은데 ViewModel에서 UI작업을 위한 메인스레드 작업할 일이 있는 경우가 당장 생각나진 않않습니다.


## 📻 Feature-2. 네트워크 구현
### 2-1 고민한 점
#### 1️⃣ Unit Test
`MockURLSession`을 구현한 이유
1. 실제 서버와 통신할 경우 테스트의 속도가 느려짐
2. 인터넷 연결상태에 따라 테스트 결과가 달라지므로 테스트 신뢰도가 떨어짐
3. 실제 데이터와 테스트를 통신을 하게 되면 불필요하게 업로드가 되는 Side-Effect를 방지할 수 있음.
4. JSON파일로 추가함으로 데이터를 추가하기가 용이함.

#### 2️⃣ API 추상화
배민의 기술블로그에서는 Alamofire를 한번 더 추상화하여 구현된 라이브러리인 `Moya`를 이용하여 UnitTest를 사용하고 `Quick/Nimble`을 사용하면 더 편하다고 언급하고 있습니다.
이전 프로젝트에서 MoYa를 이용해서 열거형으로 만들었었으나 API추가할때마다 case가 늘어나고 switch문을 매번 수정하는게 생각보다 불편하여 아래와 같이 수정하였습니다.
1. API마다 독립적인 구조체 타입으로 관리되도록 만듬.(ex `StationListAPI`, `StreamingAPI`)
2. URL 프로퍼티 외에도 HttpMethod 프로퍼티를 추가한 `APIProtocol`타입을 채택
3. 현재 post타입은 사용하고 있지않지만 추가작업을 위해 추가해놓음.
4. 협업시에 각자 담당한 API 구제초만 관리하면 되기 때문에 충돌을 막을 수 있음.

### 2-2 Trouble Shooting
#### 1️⃣ Mock 데이터 접근 시 Bundle에 접근하지 못하는 문제
- 문제점 : `JSON Decoding` 테스트를 할 때, `Bundle.main.path`를 통해 Mock 데이터에 접근하도록 했는데, path에 nil이 반환되는 문제가 발생했습니다. LLDB 확인 결과 Mock 데이터 파일이 포함된 Bundle은 `OpenMarketTests.xctest`이며, 테스트 코드를 실행하는 주체는 `OpenMarket App Bundle`임을 파악했습니다. 
- 해결방법 : 현재 executable의 Bundle 개체를 반환하는 `Bundle.main` (즉, App Bundle)이 아니라, 테스트 코드를 실행하는 주체를 가르키는 `Bundle(for: type(of: self))` (즉, XCTests Bundle)로 path를 수정하여 문제를 해결했습니다.


## 📻 Feature-3. PlayStatusView 구현
### 3-1 고민한 점
#### 1️⃣ PlayStatusView 공유
일반적인 Music앱들을 보면 하단의 재생창을 공유하고있다. 그렇기에 뷰의 계층안에서는 `PlayStatusView`가 가장 위에 있게 하는것이 목표였다.
단순하게 View를 취상위로 올리는것만 아니라 다른 View(StationView와 FavoriteView)에서 음악을 재생하였을때 PlayStatusView에서도 음악재생에 맞는 기능이 작동해야헀다.
StationView와 FavoriteView에서 음악을 재생하면 PlayStatusVie로 전달된다.
전달받으면 PlayStatusView에서는 커버이미지, 제목, 재생애니메이션, 상단의 상태창(`MPNowPlayingInfoCenter`)을 업데이트하고 PlayStatusViewModel에서는 AVPlayer를 통해 재생과 정지 작업을 한다.

### 3-2 Trouble Shooting
#### 1️⃣ Mock PlayStatusView를 여러곳에서 bind하기 때문에 생기는 중복 스트림 방출
- 문제점 : 즐겨찾기에서 재생시에 2번 재생버튼이 눌리며 노래가 재생후 바로 일시정지하는 상태가 발생했습니다. .debug()를 통해 중복 스트림이 발생하는 것을 확인했습니다.
- 해결방법 : .share()를 추가하여 1번만 발생하도록 수정하였습니다.


## 📻 Feature-4. StationView 구현
### 4-1 고민한 점 
#### 1️⃣ RxDataSources 사용
처음에는 DiffableDataSource를 사용하려고 하였으나 DiffableDataSource는 자주 사용해봤기 때문에 RxDataSources를 사용하였습니다.
기본적으로 `CollectionView`에 나타낼 데이터 타입 (UniqueProduct)은 DiffableDataSource와 같이 `Hashable`을 채택하여 구분해야했습니다. Section에 `Hashable`를 채택하여 Dictionary로 재구성하였고 Section의 Value값으로 Section의 타이틀을 나타냈습니다.

#### 2️⃣ PlayStatuView의 위치
Coordinator에서 모든 화면의 ViewController 및 ViewModel을 초기화하여 의존성을 관리하고, 화면 전환을 담당하도록 구현했습니다. 이때 화면 전환에 필요한 작업은 Coordinator에서 정의하여 클로저 타입의 변수로 구성된 action에 저장해두고, ViewModel에서 해당 action에 접근하여 클로저를 실행하도록 했습니다.

#### 3️⃣ Observable Subscribe 최소화 
Stream이 발생하는 경우, Observable을 최종 사용하는 위치에서만 `Subscribe`하여 Stream이 끊기지 않도록 구현했습니다. 따라서 Observable을 생성하고 이를 처리하는 중간 단계에서는 `flatmap`, `map`, `filter`, `compactMap` 등을 사용하여 필요한 형태로 변경만 해준 뒤 Observable 타입을 반환하도록 구현했습니다.

#### 4️⃣ Flow Coordinator 활용
Coordinator에서 모든 화면의 ViewController 및 ViewModel을 초기화하여 의존성을 관리하고, 화면 전환을 담당하도록 구현했습니다.


## 📻 Feature-5. FavoriteView, 상세화면 구현
### 5-1 고민한 점 
#### 1️⃣ TableView 사용
즐겨찾기 화면의 경우 이용자는 듣는게 우선적인 목표이기에 단순하고 간단하게 만들기 위해 TableView를 사용하였습니다.

#### 2️⃣ 상세화면은 ActionSheet 활용
ActionSheet에 재생과 좋아요를 넣어 모든것을 조작할 수 있도록 구현했습니다.
ActionSheet를 사용한 이유는 라디오를 실행할때 상세화면으로 한번 더 진입하는것이 유저에게는 불편할 수 있기때문에 ActionSheet를 활용하였습니다.

### 2-2 Trouble Shooting
#### 1️⃣ 초기화면 설정
- 문제점 : 테스터가 초기 이용자입장에서는 데이터가 많은 StationView가 좋지만 즐겨찾기를 이용하는 이용자입장에서는 한번 이동해야하는 번거로움이 있다는 이야기를 전달받았습니다.
- 해결방법 : FolwCoordinator로 관리하기 때문에 즐겨찾기의 유무로 초기화면을 바뀌도록 구현했습니다.

#### 2️⃣ TableView와 ActionSheet의 좋아요버튼
- 문제점 : 좋아요 버튼을 누를때 ActionSheet의 좋아요가 눌리면 TableView의 좋아요 버튼이 업데이트가 되어야 했습니다.
- 해결방법 : TableView의 전체 리로드를 피하기 위해 ActionSheet가 나온 cell의 index만 업데이트하였습니다.


## 📻 Feature-6. 설정화면, 
### 6-1 고민한 점 
#### 1️⃣ Flow Coordinator 활용(화면전환, 자동꺼짐 설정)
화면 전환에 필요한 작업과 자동꺼짐에 필요한 작업 2가지를 Coordinator에서 정의하여 클로저 타입의 변수로 구성된 SleepSettingAction 저장해두고, ViewController에서 해당 action에 접근하여 클로저를 실행하도록 했습니다.

#### 2️⃣ 자동꺼짐 설정
Flow Coordinator에서 전달한 action을 통해서 위의 정지 기능을 클로저로 실행합니다.
자동으로 꺼지기 위해서는 `PlayStatusView`의 UI 정지상태 업데이트, `PlayStatusViewModel`의 AVPlayer 정지, 외부 Controller 정지가 필요합니다.

#### 3️⃣ Timer 백그라운드
백그라운드에 진입했을때도 시간이 경과하면 작동이 되어야 하기때문에 `Timer()`의 scheduler를 사용하지 않고 `DispatchSourceTimer`를 활용하였습니다.

```swift
section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, environment in
    let bannerIndex = Int(max(0, round(contentOffset.x / environment.container.contentSize.width)))
    self?.imagePageControl.currentPage = bannerIndex
}
```
