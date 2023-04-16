# BottomSheetView

[![Swift 5](https://img.shields.io/badge/swift-5-blue.svg?style=flat)](https://swift.org/)
[![CI Status](https://img.shields.io/travis/qwerty3345/BottomSheetView.svg?style=flat)](https://travis-ci.org/qwerty3345/BottomSheetView)
[![Version](https://img.shields.io/cocoapods/v/BottomSheetView.svg?style=flat)](https://cocoapods.org/pods/BottomSheetView)
[![SwiftPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)

📚BottomSheetView is a library that makes it very easy to implement bottom sheet style views used in many Apps such as Map, Stock...
☺️Implement a bottom sheet easily with BottomSheetView!
> 😵From UIKit 15 version, `UISheetPresentationController` was introduced, but the target version is still higher.

<details>
<summary>Korean</summary>
📚BottomSheetView 는 네이버지도앱, 주식앱 등 여러 곳에서 사용되는 바텀시트 스타일의 뷰를 아주 손쉽게 구현하기 위한 라이브러리입니다!

☺️BottomSheetView와 함께 손쉽게 바텀시트를 구현 해 보세요!

> 😵UIKit 15 버전부터는 `UISheetPresentationController` 가 도입되었지만, 아직은 target 버전이 높습니다.

</details>



https://user-images.githubusercontent.com/59835351/232277869-77c3f5e1-5198-4b99-84e4-70c239200e1c.mp4



## 📝 Example


### Initial setup

How to use is very simple.
Just create a `BottomSheetView` and call its `configure` method, and you're done!

```swift
// Inside the ViewController to represent the BottomSheet...
let bottomSheetView = BottomSheetView()
let contentViewContoller = YourContentViewController()

override func viewDidLoad() {
  bottomSheetView.configure(
    parentViewController: self,
    contentViewController: contentViewContoller
  )
}

```

### **Change BottomSheet mode**

The basic setting of the bottom sheet supports three modes: `full`/`half`/`tip`.
If you want to use only two modes, `full`/`half`, you can set it as below!

```swift
bottomSheetView.isTipEnabled = false
```

### Set size for full/half/tip mode

```swift
// Make struct that implements BottomSheetLayout protocol
struct SomeLayout: BottomSheetLayout {
  func anchoring(of position: BottomSheetPosition) -> BottomSheetAnchoring {
    switch position {
    case .full:
      return .fractional(0.9) // Fill up to 90%
    case .half:
      return .absolute(500) // absolute value by 500
    case .tip:
      return .fractional(0.2) // Fill up to 20%
    }
  }
}

bottomSheetView.layout = SomeLayout()
```

### **BottomSheet design custom**

```swift
bottomSheetView.appearance = BottomSheetAppearance(
  backgroundColor: .white,
  bottomSheetCornerRadius: 20,
  grabberBackgroundColor: .lightGray,
  grabberWidth: 32,
  grabberHeight: 6,
  isContentScrollViewBouncingWhenScrollDown: true
)
```



<details>

<summary>Korean</summary>

### 초기 설정

사용방법은 아주 간단합니다.
`BottomSheetView`를 생성하고 `configure` 메서드를 호출해주기만 하면 끝입니다!

```swift
// 바텀시트를 나타낼 ViewController 내부...
let bottomSheetView = BottomSheetView()
let contentViewContoller = YourContentViewController()

override func viewDidLoad() {
  bottomSheetView.configure(
    parentViewController: self,
    contentViewController: contentViewContoller
  )
}

```

### 바텀시트 모드 변경

바텀시트의 기본 설정은 `전체(full)`/`중간(middle)`/`바닥(tip)`의 3가지 모드를 지원합니다.

만약 `전체(full)`/`중간(middle)`의 두가지 모드만 사용하길 원한다면 아래처럼 설정하면 됩니다!

```swift
bottomSheetView.isTipEnabled = false
```

### 전체/중간/바닥 모드의 사이즈 설정

```swift
// BottomSheetLayout 를 implement 한 struct 구현
struct SomeLayout: BottomSheetLayout {
  func anchoring(of position: BottomSheetPosition) -> BottomSheetAnchoring {
    switch position {
    case .full:
      return .fractional(0.9) // 90% 비율만큼 채움
    case .half:
      return .absolute(500) // 500만큼의 절대값
    case .tip:
      return .fractional(0.2) // 20% 비율만큼 채움
    }
  }
}

bottomSheetView.layout = SomeLayout()
```

### 바텀시트 디자인 커스텀

```swift
bottomSheetView.appearance = BottomSheetAppearance(
  backgroundColor: .white,
  bottomSheetCornerRadius: 20,
  grabberBackgroundColor: .lightGray,
  grabberWidth: 32,
  grabberHeight: 6,
  isContentScrollViewBouncingWhenScrollDown: true
)
```

</details>


## Requirements

iOS 11.0 +


## 💾 Installation

### CocoaPods
BottomSheetView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BottomSheetView'
```

### Swift Package Manager
Follow [this doc.](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app)

## 🧑🏻‍💻 Author

Mason Kim, qwerty3345@naver.com


## ✨ Special Thanks to
###  Contributer & Helper
Wallaby, avocado34.131@gmail.com

### Inspired by
Shin Yamamoto, [Floating Panel](https://github.com/scenee/FloatingPanel/)


## License

BottomSheetView is available under the MIT license. See the LICENSE file for more info.
