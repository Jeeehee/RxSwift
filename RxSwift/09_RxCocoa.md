# RxCocoa

<br>

- 기존 Framework인 **Cocoa touch에 Reactive의 장점을 더한**, RxSwift를 기반으로 한 **라이브러리** 입니다.
- RxCocoaSMS iOS(iPhone, iPad, Apple Watch, Apple TV), macOS 모두에 적용 가능합니다.
- `ObserverType` 은 값을 주입하는 타입이고, `ObservableType` 은 값을 관찰할 수 있는 타입입니다.
- 앱의 데이터 흐름을 단순화 하기 위해, RxCocoa에서의 바인딩은 단방향 데이터 스트림입니다.
  - Producer(`ObserverType`)는 값을 만들어내고, Receiver( `ObservableType` )는 만들어진 값을 수신해 처리합니다.
  - 따라서, Receiver는 인터페이스나 Producer로 바인딩을 수행할 수 없습니다.


![Group 1](/Users/jiheesmac/Downloads/Group 1.png)

- `bind(to:)` 는 호출 시, 부수 작용이 없는 `subscribe()` 와 같습니다.

<br>

## Traits

- 직관적이며 작성하기 쉬운 코드를 작성하는데 도움이 되는, **UI 작업에 특화 된 Observable** 입니다.
- MainThread에서 실행되며, Error 를 방출하지 않습니다.
- Share연산자가 내부적으로 사용된 상태로, Traits를 구독하는 모든 구독자는 동일한 시퀀스 및 부수작용을 공유합니다.

<br>

### 1. Control Property

- `Subject` 처럼 프로퍼티에 값을 주입하거나, 관찰합니다.
- 아래와 같이 `UIComponents.rx` 를 통해 접근합니다.
- 해당 프로퍼티의 변경사항을 `Observable<Data>` 로 받아올 수 있습니다.

```swift
textField.rx.controlEvent(.editingDidEndOnExit)
```

<br>

### 2. ControlEvent

- Event(버튼 탭이나, 텍스트필드 리턴 등)에 대한 Observable을 받아옵니다.
- 위 Control Property에 명시되어있는 예제와 같이, UI의 이벤트를 확인하기 위해 사용합니다.

<br>

### 3. Driver

- Observable은 기본적으로 Backgound thread에서 동작합니다.
- UI 작업 등 MainThread에서 작업해야할 때, Observable 대신 사용합니다. 
- `.observe(on: MainScheduler.instance)` 를 `asDriver()` 로 단순화 합니다.

```swift
public func asDriver() -> Driver<Element> {
  	let source = self.asObservable()
  	.observe(on:DriverSharingStrategy.scheduler)
  
  	return SharedSequence(source)
}
```
