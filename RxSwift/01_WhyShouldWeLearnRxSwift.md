# 왜 RxSwift를 배워야 하는가?

<br>

우선, 명령형 프로그래밍의 경우 비동기적인 App을 만드는게 어렵습니다.  
ViewController 안의 ViewDidLoad를 예로 들면,

```Swift
override func viewDidLoad() {
  super.viewDidLoad()
  
  attribute()
  layout()
  createDataSource()
}
```

위와 같이 여러 method들이 존재하게 되는데, 해당 method가 어떤 역할을 하는지 직관적으로 알 수 없을 뿐더러  
해당 method들의 순서가 바뀐다면, App이 예상한 바와 다르게 동작할 수 있습니다.  

RxSwift는 비동기 프로그래밍을 보다 간결하게 작성할 수 있어, 이러한 문제점을 보완합니다.

<br>

## RxSwift?

- Reactive Extensions Swift의 약어로, Swift의 Reactive Programming을 도와주는 라이브러리입니다.
- Reactive Programming 이란 데이터를 **관찰**하고 있다가 해당 데이터가 **변경**이 되면, UI를 **실시간**으로 업데이트해주는 프로그래밍 방식입니다.

<br>

## 왜 RxSwift인가?
- 이미 Swift에는 비동기 API(Notification, Delegate, Grand Central Dispatch(GCD), Closures) 가 존재하지만, 이들은 데이터를 다 받고 난 후에 UI를 업데이트해줍니다. (부분별로 나눠 사용하기 어려움)
- RxSwift는 데이터 변경을 Observe 하고 있기 때문에, 개발자가 작성한 순서대로 작동하는 것이 아니라 사용자와 상호 작용하며 UI를 실시간으로 업데이트해줍니다.
