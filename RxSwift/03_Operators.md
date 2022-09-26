# Observable 생성 Operators

<br>



## Observable 생성

### 1. just

- 오직 하나의 이벤트만 갖는 `Observable Sequence` 를 생성합니다.

```swift
let observable = Observable.just(1)
```

<br>

### 2. of

- 단일 이벤트 뿐만 아니라 여러 이벤트를 넣을 수 있는 연산자로, 2개 이상의 이벤트를 전달해야 하는 경우에 쓰입니다.
- 주어진 값들의 타입 추론을 통해 `Observable Sequence` 를 생성합니다.

```swift
let observable1 = Observable.of([1, 2, 3])
// Array로 넣게 되면, 타입은 Observable<[Int]>가 됩니다.

observable1.subscribe { event in
		if let element = event.element {
				print(element)
		}
}
// print [1, 2, 3]
```

```swift
let observable2 = Observable.of(1, 2, 3)

observable2.subscribe { event in
    if let element = event.element {
         print(element)
    }
}
// print
// 1
// 2
// 3
```

<br>


### 3. From

- 오직 Array 만 이벤트로 갖습니다.
- Array 각 요소들을 하나씩 방출합니다.

```swift
let observable3 = Observable.from([1, 2, 3])

observable3.subscribe { event in
    if let element = event.element {
        print(element)
    }
}
// print
// 1
// 2
// 3
```

<br>

### 4. Create

- 아래의 구현 코드에서 볼 수 있듯, Escape Closure 방식으로 생성합니다.

```swift
public static func create(_ subscribe: @escaping (AnyObserver<Element>) -> Disposable) -> Observable<Element> {
  AnonymousObservable(subscribe)
}
```

```swift
Observable<Int>.create { observer in
     observer.onNext(1)
     observer.ononCompleted()
                        
     return Disposables.create()
}
.subscribe(
  		onNext: { print($0) }, // 위의 이벤트가 Completed되면 해당 값은 무시됨
  		onError: { print($0) },
  		onCompleted: { print("Completed") },
  		onDisposed: { print("Disposed") }
	).disposed(by: disposeBag)
}
```

<br>

### 5. Range

- start부터, count까지 1씩 증가하는 정수를 이벤트로 갖습니다.

```swift
Observable.range(start: 1, count: 9)
		.subscribe(
 			  onNext: { num in
        print("2 * \(num) = \(num * 2)")
    },
 			  onCompleted: { print("Completed") }
		).disposed(by: disposeBag)
```

<br>

### 6. Empty

- Observable 생성 후, onCompleted 만 방출됩니다.
- 쉽게 말해 빈 값으로 종료만 시킵니다.
- 즉시 종료되는 Observable을 리턴하거나, 값을 갖지 않는 Observable을 리턴하는 경우 사용됩니다.

```swift
 Observable<Void>.empty()
     .subscribe(
         onNext: { print($0) }, // 무시됨
         onCompleted: { print("Completed") })
     .disposed(by: disposeBag)
```

<br>

### 7. Never

- Empty +  onCompleted 조차 방출되지 않습니다.

<br>

### 8. Interval

- 시간 간격을 두고, 주기마다 이벤트를 방출합니다.
- Completed 되지 않고, 무한한 시퀀스를 생성합니다.
- 직접 해제(dispose)시켜주지 않으면, 무한 반복합니다.

```swift
Observable<Int>.interval(.seconds(2), scheduler: MainScheduler.instance)
     .subscribe(
         onNext: { print($0) },
         onCompleted: { print("Completed") })
// onCompleted는 실행되지 않고, 2초마다 0부터 1씩 증가하는 정수가 무한 Print 됩니다.
```

<br>

### 8. Timer

- 지정된 시간이 지난 후, 이벤트를 방출합니다. 
- 특정 시간 이후에 이벤트 방출을 하고싶을 때 사용합니다.
- Interval와 다르게, 유한히 반복합니다.

```swift
Observable<Int>.timer(.seconds(10), scheduler: MainScheduler.instance)
     .subscribe(
         onNext: { print($0) },
         onCompleted: { print("Completed") })
// 10초 후 0이 Print되고, onCompleted 가 실행됩니다.
```

<br>

### 9. Deferred

- 아래 구현부에서 확인할 수 있듯, Observable을 만들어내는 Factory Closure를 인자로 받습니다.

```swift
public static func deferred(_ observableFactory: @escaping () throws -> Observable<Element>)
-> Observable<Element> {
 	 Deferred(observableFactory: observableFactory)
}
```

- Observer가 구독하기 전까지 Observable을 생성하지 않고, 구독이 이루어 졌을 때 Observer 별로 새로운 Observable을 생성해줍니다.

```swift
Observable<Int>.deferred {
  	observableSwitch.toggle() // toggle() = 현재 Bool값을 반대로 바꿔줌

	  guard observableSwitch else { return Observable.of(1, 2, 3) }
 	  return Observable<Int>.timer(.seconds(10), scheduler: MainScheduler.instance)
}
.subscribe { event in
     switch event {
     case let .next(value): print(value)
     default: print("Done")
   }
}.disposed(by: disposeBag)
```

<br>

### 10. Repeat

- 이벤트를 무한 반복해 방출합니다.
- Interval 와 다른 점은, 시간을 설정할 수 없습니다.
- `take(_ count: Int)` 로 제한할 수 있습니다.

```swift
Observable.repeatElement("아이폰 14.. 살까? 말까?")
    .subscribe(
        onNext: { print($0) },
        onCompleted: { print("Completed") })
    .disposed(by: disposeBag)

// 위와 같이 구현하면, 아이폰14를 살지 말지 무한 고민하지만
// 아래와 같이 구현하면 10번 고민 후, 결정 완료 하게 됩니다.

Observable.repeatElement("아이폰 14.. 살까? 말까?")
    .take(10)
    .subscribe(
        onNext: { print($0) },
        onCompleted: { print("결정 완료") })
    .disposed(by: disposeBag)
```

<br>

#### ❓ Observable.of 와 Observable.from 모두 Array를 인자로 받을 수 있는데, 이 둘의 차이가 무엇인가?

**Observarble.of([1, 2, 3])** 은 `[1, 2, 3]` 을 단일 Element로 갖지만,  
**Observable.from([1, 2, 3])** 은 `[1]`, ` [2]`, ` [3]` 을 Element 갖습니다.
