# Relay

- RxSwift가 아닌, RxCocoa에 속하는 개념입니다.
- Subject는 `.comleted`, `.error`의 이벤트가 발생하면 Subscribe가 종료되지만  
Relay는 `Dispose` 되기 전까지 계속 동작해 **UI Event 처리에 적합**합니다.

<br>

## PublishRelay
- 아래 구현부에서 확인할 수 있듯, Publish Subject의 Wrapper 클래스 입니다.
- PublishSubject와 같이, 구독이 된 시점 이후부터 발생한 이벤트만 전달합니다.

```Swift
public final class PublishRelay<Element>: ObservableType {
    private let _subject: PublishSubject<Element>
    
    // Accepts `event` and emits it to subscribers
    public func accept(_ event: Element) {
        self._subject.onNext(event)
    }
    
    /// Initializes with internal empty subject.
    public init() {
        self._subject = PublishSubject()
    }

    /// Subscribes observer
    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        return self._subject.subscribe(observer)
    }
    
    /// - returns: Canonical interface for push style sequence
    public func asObservable() -> Observable<Element> {
        return self._subject.asObservable()
    }
}
```

<br>

## BehaviorRelay
- 역시나 Behavior Subject의 Wrapper 클래스 입니다.
- `.value` 로 초기값을 지정해줍니다.
- 값을 변경하기 위해 `.accept()` 을 사용합니다.

```Swift
public final class BehaviorRelay<Element>: ObservableType {
    private let _subject: BehaviorSubject<Element>

    /// Accepts `event` and emits it to subscribers
    public func accept(_ event: Element) {
        self._subject.onNext(event)
    }

    /// Current value of behavior subject
    public var value: Element {
        // this try! is ok because subject can't error out or be disposed
        return try! self._subject.value()
    }

    /// Initializes behavior relay with initial value.
    public init(value: Element) {
        self._subject = BehaviorSubject(value: value)
    }

    /// Subscribes observer
    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        return self._subject.subscribe(observer)
    }

    /// - returns: Canonical interface for push style sequence
    public func asObservable() -> Observable<Element> {
        return self._subject.asObservable()
    }
}
```
