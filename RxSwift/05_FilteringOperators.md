# Filtering Operators

<br>

- 아래의 연산자들을 이용해, `.onNext(_:)` 로 받는 값을 **선택적**으로 방출할 수 있습니다.
  - 제약 조건을 적용해 처리하고자 하는 값만 받습니다.
  - 기존의 `filter(_:)` 와 비슷합니다.


<br>

## ignoreElements()

-  `.onNext(_:)` 이벤트를 **무시(Ignore)** 합니다.
- `.onError(_:)` 와 `onCompleted(_:)` 만 전달되어, 종료 시점만 알 수 있습니다.
- 아래 예시와 같이, 특정 값이 들어온 이후 종료해야 하는 상황에 유용합니다.

```swift
var count = Int()
let strikes = PublishSubject<String>()
let disposeBag = DisposeBag()

strikes
.ignoreElements()
.subscribe { _ in
    print("You're out")
}.disposed(by: disposeBag)

while count < 3 {
    strikes.onNext("Strike ⚾️"); count += 1
}
strikes.onCompleted()
```

<br>

## element(at: )

- 발생한 이벤트 중 `elementAt(at: index)` **index번째 이벤트만 방출**합니다.

```swift
let strikes = PublishSubject<String>()
let disposeBag = DisposeBag()

strikes
.element(at: 1)
.subscribe(
    onNext: { score in
       print(score) },
    onCompleted: {
    	 print("2 Strike, 1 Ball")
    }).disposed(by: disposeBag)

strikes.onNext("Strike ⚾️")
strikes.onNext("Ball ⚾️")
strikes.onNext("Strike ⚾️")

strikes.onCompleted()
// Print Ball ⚾️
// Print 2 Strike, 1 Ball
```

<br>

## filter()

- 아래의 구현부에서 확인할 수 있듯, 기존의  `filter(_:)` 와 같이 Closure로 동작하여 **조건에 맞는 값만 필터링해 방출**합니다.

```swift
public func filter(_ predicate: @escaping (Element) throws -> Bool) -> Observable<Element> {
     Filter(source: self.asObservable(), predicate: predicate)
}
```

```swift
let strikes = PublishSubject<String>()
let disposeBag = DisposeBag()
var count = Int()

strikes
.filter { $0 == "Strike ⚾️" }
.subscribe {
    print(count, "Strike")
}.disposed(by: disposeBag)

strikes.onNext("Strike ⚾️"); count += 1
strikes.onNext("Ball ⚾️")
strikes.onNext("Strike ⚾️"); count += 1

strikes.onCompleted()

// Print 2 Strike
```

<br>

## skip(count:)

- 처음 발생하는 `skip(count: Int)` **count 만큼 이벤트 방출을 Skip** 합니다.
- `첫 요소...count` 가 범위 입니다.


```swift
Observable.of("A", "B", "C", "D", "E", "F")
	.skip(2)
	.subscribe { print($0) }
	.disposed(by: disposeBag)
// Print next(C)
// next(D)
// next(E)
// next(F)
// completed
```

<br>

## skip(while:)

- 아래 구현부에서 확인할 수 있듯,  `filter(_:)` 와 같이 특정 값만 걸러주지만,
  - `filter(_:)` 는 조건에 맞는 값을 방출하고
  - `skip(while:)`  은 **조건에 맞지 않는 값을 방출**합니다.
- **주의해야 할 점** : 조건에 맞지 않는 값을 전부 다 방출하는 것이 아니라  
  특정 값이 조건에 부합하지 않는 순간, 해당 값을 기준으로 이후 요소들은 조건에 관계 없이 전부 방출됩니다.

```swift
public func skip(while predicate: @escaping (Element) throws -> Bool) -> Observable<Element> {
    SkipWhile(source: self.asObservable(), predicate: predicate)
}
```

```swift
Observable
	.of(1, 3, 5, 6, 7, 8)
	.skip(while: { $0 % 2 != 0 }) // 첫 번째 짝수부터 방출하겠다.
	.subscribe( { print($0) })
	.disposed(by: disposeBag)
// Print 6, 7, 8
```

<br>

## skip(until:)

- `filter(_:)` 와 `skip(while:)` 처럼 고정 조건이 아닌, Trigger 가 되는 시퀀스에서 이벤트가 발생하기 전까지 모든 이벤트가 Skip됩니다.

```swift
let disposeBag = DisposeBag()

let subject = PublishSubject<String>()
let trigger = PublishSubject<String>()

subject
	.skip(until: trigger)
	.subscribe { print($0) }
	.disposed(by: disposeBag)

trigger
	.subscribe { print($0) }
	.disposed(by: disposeBag)

subject.onNext("이건")
subject.onNext("방출되지 않아요")

trigger.onNext("이제")

subject.onNext("방출됩니당")
// Print
// 이제
// 방출됩니당
```

<br>

## take(count:)

- `skip(count: Int)` 과 반대되는 개념으로, 첫 번째 요소를 기준으로 **count 만큼만 이벤트를 방출** 합니다.

```swift
Observable
	.of(1, 2, 3, 4, 5)
	.take(3)
	.subscribe { print($0) }
	.disposed(by: disposeBag)
// Print 1, 2, 3
```

<br>

## take(while:)

- `skip(while:)`  와 비슷하지만,
  - `skip(while:)` 은 조건에 맞는 값을 방출하지 않고, **조건에 맞는 첫 번째 값부터 모두 방출**하고
  - `take(while:)` 은 조건에 맞는 값을 모두 방출하고, **조건에 맞지 않는 첫 번째 값부터 모두 방출하지 않**습니다.
- `filter()` 와 다른 점은
  - `filter()` 는 값 전체를 순회하며 조건에 맞는 모든 값을 방출하지만,
  - `take(while:)` 은 조건에 맞지 않는 순간, 이후 값들은 전부 무시합니다. (일부 값만 순회)

```swift
Observable
	.of(1, 3, 5, 6, 7, 8)
  .take(while: { $0 % 2 != 0 }) // 짝수가 나타날 때까지 방출하겠다.
	.subscribe { print($0) }
  .disposed(by: disposeBag)
// Print 1, 3, 5

```

<br>

## take(until:)

- 역시나 `skip(until:)`  과 비슷하지만,
  - `skip(until:)` 은 Trigger에서 이벤트가 방출된 후부터 이벤트가 방출되고
  - `take(until:)` 은 **Trigger에서 이벤트가 방출되기 전까지만 이벤트가 방출**됩니다.

```swift
let disposeBag = DisposeBag()

let subject = PublishSubject<String>()
let trigger = PublishSubject<String>()

subject
	.take(until: trigger)
	.subscribe { print($0) }
	.disposed(by: disposeBag)

trigger
	.subscribe { print($0) }
	.disposed(by: disposeBag)

subject.onNext("이 값들은")
subject.onNext("방출됩니당")

trigger.onNext("얘도 방출 돼요") // subject 종료

subject.onNext("trigger에서 이벤트가 방출되었으니, 얘는 방출되지 않아요")

// Print
// 이 값들은
// 방출됩니당
// completed
// 얘도 방출 돼요
```

<br>

## enumerated()

- **방출된 이벤트의 index와, 값을 확인**할 수 있습니다.
- Swift의 `enumerated()` 와 유사하게, 시퀀스에서 방출되는 각 요소를 **(index, value)** 의 튜플 형태의 값을 갖습니다.

```swift
Observable
	.of(1, 3, 5, 6, 7, 8)
	.take(while: { $0 % 2 != 0 })
	.enumerated()
// Print
// index: 0, element: 1
// index: 1, element: 3
// index: 2, element: 5
	.subscribe { print($0) }
	.disposed(by: disposeBag)
// Print 1, 3, 5
```

<br>

## distinctUntilChanged()

- **연달아 중복된 값**이 들어온다면, 중복 방출을 막고 **하나의 이벤트만 방출**합니다.

``` swift
Observable
	.of("이런", "이런", "유용한 기능도 있어요", "이런", "신기한", "신기한", "RxSwift")
	.distinctUntilChanged()
	.subscribe { print($0) }
	.disposed(by: disposeBag)
// Print
// 이런
// 유용한 기능도 있어요
// 이런
// 신기한
// RxSwift
// completed
```
