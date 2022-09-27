# Subjects

<br>

- Observable에 값을 추가하는 대상이 Observer 인데, 위 두 기능을 모두 갖고 있는 것이 **Subject** 입니다.
- **Observable** 과 **Subject** 둘 다 **Subscribe** 를 할 수 있지만,
  - **Observable** 은 **unicast(1:1)** 방식으로 하나의 Observer만 구독할 수 있는 방면에
  - **Subject** 는 **Multicast(1:group)** 방식으로 여러개의 Observer가 구독할 수 있습니다.


<br>

## PublishSubject

- PublishSubjects 는 **구독이 된 시점 이후부터 발생한 이벤트만 전달**합니다.
- Completed나 Error가 발생하기 전까지 지속됩니다.
- 아래의 예제에서 `subject.on(.next(value))` 와 `subject.onNext(value)` 는 같습니다.

```swift
let subject = PublishSubject<String>()

subject.onNext("1") // 구독 전이라 방출X

subject.subscribe { event in
     print(event)
}

subject.on(.next("2")) // print next(2)
subject.onNext("3") // print next(3)

subject.onCompleted() // print completed

subject.onNext("4") // onCompleted 이후라 방출X
```

<br>

## BehaviorSubject

- PublishSubjects 와 비슷하나, BehaviorSubject 는 **초기 값을 갖고** 있습니다.
- 구독 이전에는 갖고 있는 최신 값을 방출합니다.

```swift
let subject = BehaviorSubject(value: "Initial Value")
        
subject.subscribe { event in
    print(event) // print next(Initial Value)
}

subject.onNext("1") // print next(1)
```

- 위와 같이 초기 값을 지정해 줬다면 구독 시점에 초기 값을 방출하지만,
- 아래와 같이 초기 값 설정 이후 추가적으로 이벤트가 발생했다면, BehaviorSubject 가 갖고 있는 마지막 값을 방출합니다.

```swift
let subject = BehaviorSubject(value: "Initial Value")
subject.onNext("Last") 

subject.subscribe { event in
    print(event) // print next(Last)
}

subject.onNext("1") // print next(1)
```

<br>

## ReplaySubject

- 생성 시 설정한 **bufferSize 만큼의 값들을 저장해, 구독 발생 시 방출**합니다.
- 버퍼 : 데이터를 다른 곳으로 전송하기 전, 일시적으로 그 데이터를 보관하는 메모리의 영역
- 버퍼를 메모리가 갖고 있기때문에, 메모리 사용에 주의해야 합니다.
- 이미지나 Array 같이 메모리를 많이 차지하는 값을, 큰 사이즈의 버퍼로 갖는다면 메모리에 많은 부하를 줍니다.
- 최근 n 개의 검색어를 보여주고 싶은 상황 등에 유용합니다.

```swift
let disposeBag = DisposeBag()
let subject = ReplaySubject<String>.create(bufferSize: 2)

subject.onNext("1")
subject.onNext("2")
subject.onNext("3")

subject.subscribe { event in
		print(event) // print next(2); next(3)
}.disposed(by: disposeBag)

subject.onNext("4")
subject.onNext("5")
subject.onNext("6") // print next(4); next(5); next(6)

subject.subscribe { event in
		print(event) // print next(4); next(5)
}.disposed(by: disposeBag)
```

- disposed() 를 해준 후라도, 값을 넣어준다면 기존 구독자가 해당 값을 받아 방출하게 됩니다.
- 이후 새로운 구독자는 역시 가장 최신 값을 bufferSize만 갖고, 방출합니다.

<br>

## Behavior Relay

- `import RxRelay`  혹은 `import RxCocoa` 해야하며, RxSwift 4.0 이후로 Variable 가 Depreated되어 현재의 Behavior Relay 로 대체되었습니다.
- **BehaviorSubject** 을 **wraping** 하고, 현재 값을 `value` 를 통해 파악한 후 State로 보유합니다.
-  `Subject` 나 ` Observable` 이 아닌 `asObservable()` 를 통해, 새로운  `value` 를 갖을 수 있습니다.
  - `onNext(_:) ` 사용 불가

- 또한, Behavior Relay 은 Error가 발생하지 않을 것임을 보증합니다.
  - `onError(_:) ` 도 사용 불가

- 마지막으로, Behavior Relay 은 할당 해제 시 자동적으로 완료됩니다.
  - `onCompleted(_:)` 도 사용 불가


```swift
let behaviorRelay = BehaviorRelay(value: "Initial Value")
// or
let behaviorRelay = BehaviorRelay(value: String()) // 값을 넣어주지 않고 구독이 발생하면, print next() 로 빈 값 출력

behaviorRelay.asObservable()
.subscribe { event in
		print(event) // print next(Initial Value)
}

behaviorRelay.value = "New Value" // Error발생 : value is get-only property

behaviorRelay.accept("NewValue") // print next(NewValue)
// 배열이 초기 값으로 들어갔다면
behaviorRelay.append("NewValue")
```
