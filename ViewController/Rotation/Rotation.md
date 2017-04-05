# 디바이스 회전

우선 디바이스 방향을 지원하는 기본 방법 2가지를 살펴보죠.

첫 번째 방법은 Target / General / Deployment Info / Device Orientation을 사용하는 방법입니다. 원하는 방향을 체크만 하면 됩니다. 
(Source: https://github.com/jongwonwoo/CodeSamples/tree/master/ViewController/Rotation/Rotation_infoPlist)

두 번째 방법은 AppDelegate에서 다음 함수를 구현하면 됩니다.
(Source: https://github.com/jongwonwoo/CodeSamples/tree/master/ViewController/Rotation/Rotation_appdelegate)
```swift
func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    return [.portrait, .landscape]
}
```

**결론: 처음부터 모든 방향을 지원할 생각으로 Autolayout을 이용합니다.**

그럼에도 불구하고 디바이스 회전을 제어해야 하는 경우가 생깁니다. 

비디오 앱을 만든다고 생각해보죠. 처음에는 Portrait만 지원했습니다. 그런데 비디오 재생 화면은 landscape도 지원하기로 한거죠.
(Source: https://github.com/jongwonwoo/CodeSamples/tree/master/ViewController/Rotation/Rotation_navigation_child)

우선 Navigation Controller에서 회전을 제어하려면 Navigation Controller를 상속해야 합니다. 그리고 회전과 관련된 함수를 override합니다. 
왜냐하면 Container View Controller가 회전에 관한 정보를 알려줘야 합니다. 

```swift
override var shouldAutorotate: Bool {
    return (self.topViewController?.shouldAutorotate)!
}
    
override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return (self.topViewController?.supportedInterfaceOrientations)!
}
```

이제 Navigation Controller에 push될 View Controller에 지원하는 디바이스 방향을 정의해줍니다.

```swift
override var shouldAutorotate: Bool {
    return true
}
    
override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return [.portrait, .landscape]
}
```

그런데 작은 문제가 있습니다. Portrait 상태인 A 화면에서 Landscape도 지원하는 B 화면을 열고, 디바이스를 Landscape로 돌리고 Back을 하면 A 화면이 Landscape로 열립니다.
그래서 A 화면의 View Controller를 다음과 같이 조금 수정해 줍니다.

```swift
override var shouldAutorotate: Bool {
    return true
}
    
override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return [.portrait]
}
```

얼마 지나지 않아 요구사항이 바뀌었습니다. 흔히 있는 일이죠.

이제 비디오 재생 화면은 Landscape만 지원해야 합니다. 그러니까 사용자가 디바이스를 어떻게 들고 있던 화면을 강제로 Landscape로 회전시켜야 합니다.
(Source: https://github.com/jongwonwoo/CodeSamples/tree/master/ViewController/Rotation/Rotation_navigation_portrait_child_only_landscape)

우선 비디오 재생 화면 View Controller의 지원하는 디바이스 방향을 수정합니다.

```swift
override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return [.landscapeLeft]
}
```

그리고 화면을 강제로 회전시키기 위해서 디바이스에게 원하는 방향을 알려줍니다.

```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        
    let value = UIDeviceOrientation.landscapeRight.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")
}
```

그런데 또 작은 문제가 있습니다.
디바이스가 LandscapeRight인 상태에서 비디오 재생 화면을 열면 portrait로 열립니다. 두 번째 열 때부터는 원하는대로 landscape로 열리고요.
일단 꼼수로 넘어갈 수는 있을 것 같습니다. 근본적인 원인을 찾기 전까지는요.

```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        
    if UIDevice.current.orientation == .landscapeRight {
        let value = UIDeviceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
        
    let value = UIDeviceOrientation.landscapeRight.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")
}
```

여기까지 만들면 디바이스 회전에 대해서 기본 준비는 된 것 같습니다.
이제 본격적으로 화면 레이아웃을 만들어야겠죠.
