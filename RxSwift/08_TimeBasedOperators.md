# Time Based Operators

<br>

- Rx에서는 시간 흐름에 따라 데이터가 변동됩니다.
- Time Based Operators들은 시간 흐름을 지연하거나 다시 재생시키는 등 **시간을 제어**하는 연산자 입니다. 

<br>

## replay(bufferSize:)

- 이벤트 방출 이후,  버퍼 사이즈 수만큼 새로운 구독자로부터 **이벤트를 재방출** 합니다.

- `.connect()` 메서드 호출 전까지, 구독자 수와 관계 없이 아무 값도 방출하지 않습니다.


```swift
let replaySubject = PublishSubject<String>()
let replayOperator = replaySubject.replay(3)

replayOperator.connect()

replaySubject.onNext("이 값은")
replaySubject.onNext("저장해뒀다")
replaySubject.onNext("구독이 발생하면 방출해요")

replayOperator
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

replaySubject
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

replaySubject.onNext("이 값은 두 번 방출됩니다.")
replaySubject.onNext("기존 Observable과 함께 replay을 적용한 Observable도 방출하니까요!")

// Print
// 이 값은
// 저장해뒀다
// 구독이 발생하면 방출해요
// 이 값은 두 번 방출됩니다.
// 이 값은 두 번 방출됩니다.
// 기존 Observable과 함께 replay을 적용한 Observable도 방출하니까요!
// 기존 Observable과 함께 replay을 적용한 Observable도 방출하니까요!
```

<br>

## replayAll

- 역시나 이벤트를 재방출하지만, **버퍼 크기에 상관 없이 모든 이벤트를 다시 방출**합니다.
- 버퍼의 크기가 정해지지 않았기때문에,  
  많은 양의 데이터를 생성하면서, 종료 되지 않는 Observable에 사용하면 메모리 부족 현상이 일어날 수 있습니다.
- 때문에, 버퍼할 요소의 전체 개수를 정확히 아는 상황에 사용하는게 좋습니다.

```swift
let replaySubject = PublishSubject<String>()
let replayOperator = replaySubject.replayAll()

replayOperator.connect()

replaySubject.onNext("1")
replaySubject.onNext("2")
replaySubject.onNext("3")
replaySubject.onNext("4")
replaySubject.onNext("5 까지 전체 방출되고,")

replayOperator
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

replaySubject
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

replaySubject.onNext("6")
replaySubject.onNext("7 은 두 번 방출됩니다.")
```

<br>

## buffer(timeSpan: , count: , scheduler:)

- 이벤트 방출 시, **한 번에 Array로 묶어서 방출**합니다.
  - `timeSpan` 은 이벤트를 수집하는 시간,
  - `count` 는 Array에 담을 이벤트의 개수,
  - `scheduler` 는 해당 연산자가 실행 될 스레드 입니다. 

```swift
Observable<Int>
	.interval(
    	.seconds(1),
    	scheduler: MainScheduler.instance)
	.buffer(
    	timeSpan: .seconds(3),
    	count: 2,
    	scheduler: MainScheduler.instance)
	.take(5)
	.subscribe(onNext: { print($0) })

// Print - 3초 간격으로 2개씩 Print됩니다.
// [0, 1]
// [2, 3]
// [4, 5]
// [6, 7]
// [8, 9]
```

<br>

## window(timeSpan: , count: , scheduler:)

- `buffer()` 와 비슷하지만, Array가 아닌 **Observable로 하나씩 방출**합니다.


```swift
Observable<Int>
	.interval(
 		 .seconds(1),
 		 scheduler: MainScheduler.instance)
	.window(
  	 timeSpan: .seconds(3),
  	 count: 2,
  	 scheduler: MainScheduler.instance)
	.take(3)
	.subscribe {
 		 if let observable = $0.element {
 	   		observable.subscribe { print($0) }
 		 }}

// Print
// next(0)
// next(1)
// completed

// next(2)
// next(3)
// completed

// next(4)
// next(5)
// completed
```

<br>

## delay(dueTime: , scheduler:)

- **정해진 시간 동안 지연시킨 후, 방출**합니다.

```swift
Observable<[Int]>
	.of([1, 2, 3])
	.delay(
	  .seconds(3),
 	  scheduler: MainScheduler.instance)
	.subscribe(onNext: { print($0) })

// Print - 3초 후 Print
// [1, 2, 3]
```

<br>

## delaySubscription(dueTime: , scheduler:)

- `delay()` 와 비슷하나
  - `delay()`  는 방출을 지연시키고,
  - `delaySubscription()` 은 **구독을 지연**시킵니다.


<br>

## interval(period: , scheduler:)

- 시간 간격을 두고, **주기마다 이벤트를 방출**합니다.
- Dispose를 하지 않으면, 완료되지 않아 무한한 시퀀스를 생성합니다.


```swift
Observable<Int>
	.interval(
 	  .seconds(3),
    scheduler: MainScheduler.instance)
	.subscribe(onNext: { print($0) })

// Print - 3초 마다 Print
// 0
// 1
// 2 ...
```

<br>

## timer(dueTime: , period: , scheduler:)

- `interval` 과 비슷하나 아래 구현부에서 확인할 수 있듯, **첫 방출 시간을 설정**할 수 있습니다.
  - `dueTime ` 이후
  - `period` 간격으로 방출합니다.

```swift
public static func timer(_ dueTime: RxTimeInterval, period: RxTimeInterval? = nil, scheduler: SchedulerType) -> Observable<Element> {
  	return Timer(
    				dueTime: dueTime,
    				period: period,
    				scheduler: scheduler )}
```

```swift
Observable<Int>
	.timer(
		 .seconds(5),
		 period: .seconds(3),
		 scheduler: MainScheduler.instance)
	.subscribe(onNext: { print($0) })

// Print - 5초 뒤, 3초 간격으로 Print
// 0
// 1
// 2 ...
```

<br>

## timeout(dueTime: , scheduler:)

- **`dueTime` 시간 내에 이벤트가 방출되지 않는다면, Error를 방출**합니다. 
- 쉽게 말해, 제한 시간 초과 시 Error가 방출됩니다.

```swift
private let button = UIButton(type: .close)

button.rx.tap
	.do(onNext: {  print("Tap") })
	.timeout(
	   .seconds(3),
   	 scheduler: MainScheduler.instance)
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

// Print
// Unhandled error happened: Sequence timeout.
```
