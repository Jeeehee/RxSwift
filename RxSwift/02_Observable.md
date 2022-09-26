# Observable

<br>

- `Observable` == `Observable sequence` == `Sequence`
- `Observer` 가 `Observable` 을 구독하는 형태로, 이벤트를 비동기적으로 생성하는 기능입니다.
- `Subscribe` 메서드를 통해 `Observer` 와 `Observable` 을 연결합니다.
- `Observable` 은 계속해서 이벤트를 생성하는데, 이러한 과정을 `Emit(방출)` 이라고 표현합니다.
- 각 각의 이벤트들은 **숫자**나 **커스텀 한 인스턴스** 등과 같은 값을 갖거나, 탭과 같은 **제스처**를 인식할 수도 있습니다.



<br>

## Event 종류

| Event       | 설명                                                         |
| ----------- | ------------------------------------------------------------ |
| onNext      | 구성 요소를 계속해서 방출시킬 수 있는 기능으로, 최신/다음 데이터를 `Observer` 에게 **전달**하는 이벤트입니다. |
| onCompleted | 성공적으로 일련의 이벤트들을 종료시킬 수 있는 기능으로, `Observer` 에게 **완료**되었음을 알리는 이벤트입니다. |
| onError     | Event에서 에러가 발생하여 추가적으로 이벤트를 생성하지 않을 것임을 의미하며, 에러와 함께 종료됩니다.<br />`Observer` 에게 **오류 발생** 을 알리는 이벤트입니다. |

```swift
public enum Event<Element> {
 	/// Next elemet is produced.
 	case next(Element)
 	
 	/// Sequence terminated with an error.
 	case error(Swift.Error)
 	
 	/// Sequence completed successfully.
 	case completed
 }

/*
1. 여기서 .next 이벤트는 어떠한 Element 인스턴스를 가지고 있는 것을 확인할 수 있다.
2. .error 이벤트는 Swift.Error 인스턴스를 가진다.
3. completed 이벤트는 아무런 인스턴스를 가지지 않고 단순히 이벤트를 종료시킨다.
*/
```



<br>

## Dispose

- **Dispose** : 처분할 수 있는, 사용 후 버릴 수 있는

```swift
let subscription = observable.subscribe { print($0) }
subscription.dispose()
```

- 위와 같이 `dispose` 를 사용해 원하는 시점에 구독을 해지할 수 있습니다.
- 하지만, 매번 별도로 해지를 관리해야하는 불편함이 따릅니다.
- 아래와 같이 `DisposeBag()` 을 사용해 여러개의 구독을 한 번에 해지할 수 있습니다.

```swift
let disposeBag = DisposeBag()

Observable.of("A", "B", "C")
    .subscribe { print($0) }
    .disposed(by: disposeBag)
```



<br>



#### ❓ 왜 구독을 해지해야 하는가?

Observer 은 기본적으로 Completed or Error 이벤트가 발생할 때까지 구독을 유지합니다.  
완료되거나 에러가 발생 시, 해당 Observer를 해지 함으로써 메모리에서 제거해 메모리 릭을 방지합니다.
