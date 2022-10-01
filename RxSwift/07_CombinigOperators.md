# Combining Operators

<br>

- Observable 혹은 Observable 내의 데이터를 **병합/결합(Combine)** 해주는 연산자 입니다.

<br>

## startWith

- sequence **초기값 앞에 값을 붙**일 수 있습니다.

- 단어 그대로 함께 시작하는 값을 지정하는 연산자 입니다.

- 추후에 어떠한 업데이트가 있더라도, 초기값을 즉시 얻을 수 있는 Observer를 보장합니다.

```swift
Observable
	.of("파리", "도쿄", "퀘백", "샌프란시스코")
	.startWith("가고싶은 여행지는")
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

// Print
// 가고싶은 여행지는
// 파리
// 도쿄
// 퀘백
// 샌프란시스코
```

<br>

## concat

- **같은 데이터 타입을 갖는 Observable 여러개를 병합**합니다.

```swift
let favoriteThings = Observable<String>.of("산책", "크리스마스", "운전", "여행", "요리")
let favoriteFood = Observable<String>.of("진한 커피", "빵", "떡", "팥", "수박", "샐러드")

Observable
	.concat(favoriteThings, favoriteFood)
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

// Print
// 산책, 크리스마스, 운전, 여행, 요리, 진한 커피, 빵, 떡, 팥, 수박, 샐러드
```

- 아래와 같이 Observable을 따로 생성해 주지 않아도 병합이 가능합니다.

```swift
let favoriteThings = Observable<String>.of("산책", "크리스마스", "운전", "여행", "요리")
let favoriteFood = Observable<String>.of("진한 커피", "빵", "떡", "팥", "수박", "샐러드")

favoriteThings.concat(favoriteFood)
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)
```

<br>

## concatMap

- 두 개의 `Observable` 을 **구독이 되기 전에 병합**합니다.
  

```swift
let favoriteThings: [String: Observable<String>] = [
    "좋아하는 행동": Observable.of("산책", "운전", "여행"),
  	"좋아하는 음식": Observable.of("진한 커피", "빵", "팥")
]

Observable
	.of("좋아하는 행동", "좋아하는 음식")
	.concatMap{ favoriteThings[$0] ?? .empty() }
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

// Print
// 산책, 운전, 여행, 진한 커피, 빵, 팥
```

<br>

## merge

- **여러개의 시퀀스를 하나의 Observable로 병합**합니다.
  
- 다만, 순서를 보장해주지 않습니다.
  


```swift
let favoriteThings = Observable<String>.of("산책", "크리스마스", "운전", "여행", "요리")
let favoriteFood = Observable<String>.of("진한 커피", "빵", "떡", "팥", "수박", "샐러드")

Observable
	.of(favoriteThings, favoriteFood)
	.merge()
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

// Print
// 산책, 크리스마스, 진한 커피, 운전, 빵, 여행, 떡, 요리, 팥, 수박, 샐러드
```

<br>

## merge(maxConcurrent:)

- `maxConcurrent` 에 1을 넣으면, 들어온 순서를 보장해 출력됩니다.

```swift
let favoriteThings = Observable<String>.of("산책", "크리스마스", "운전", "여행", "요리")
let favoriteFood = Observable<String>.of("진한 커피", "빵", "떡", "팥", "수박", "샐러드")

Observable
	.of(favoriteThings, favoriteFood)
	.merge(maxConcurrent: 1)
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

// Print
// 산책, 크리스마스, 운전, 여행, 요리, 진한 커피, 빵, 떡, 팥, 수박, 샐러드
```

<br>

## combineLatest(_:, _:, resultSelector:)

- 각 Observable의 **마지막 값을 병합**합니다.
- 2...8 까지의 Observable을 파라미터로 받습니다.
- 아래에서 확인할 수 있득, 파라미터인 Observable들의 **타입이 갖지 않아도** 됩니다.
- 어떻게 합칠지는 `resultSelector:` 에 넣어주면 됩니다.

```swift
let left = PublishSubject<Int>()
let right = PublishSubject<String>()

Observable
	// combineLatest(_:, _:, resultSelector: { (item, item) -> item })
	.combineLatest(left, right, resultSelector: {
  		lastLeft, lastRight in
 			print(lastLeft, lastRight)
	})
	.subscribe(onNext: { print($0) })


left.onNext(45)
right.onNext("100")
left.onNext(1)
right.onNext("2")
right.onNext("3")

// Print
// 45 100
// 1 100
// 1 2
// 1 3
```

- 아래와 같이 날짜 출력에도 사용 가능합니다.

```swift
let choice: Observable<DateFormatter.Style> = .of(.short, .medium, .long, .full)
let date = Observable.of(Date())

Observable
	.combineLatest(choice, date, resultSelector: { format, when -> String in
     	 let formmater = DateFormatter()
    	 formmater.dateStyle = format
    	 return formmater.string(from: when) })
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

// Print
// 10/1/22
// 10/1/22
// 2022년 10월 1일
// 2022년 10월 1일 토요일
```

- 아래와 같이 문자열 결합에도  사용 가능합니다.

```swift
let left = PublishSubject<String>.of("맛있는")
let right = PublishSubject<String>.of("수박", "떡볶이", "양배추")

Observable
	.combineLatest([left, right]) { value in
			value.joined(separator: " ") }
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

// Print
// 맛있는 수박
// 맛있는 떡볶이
// 맛있는 양배추
```



<br>

## zip

- 역시나 2...8개의 Observarble을 파라미터로 받으며, 각각의 Observable 값을 **순차적으로 병합**합니다.
- Observable 의 크기가 다르다면, 가장 작은 크기의 Observable 값의 수까지만 병합됩니다.
  - 이렇게 Observable에 따라 단계적으로 작동하는 방법을 `Indexed Sequencing` 이라고 합니다.


```swift
let one = PublishSubject<Int>.of(1, 2, 3, 4)
let two = PublishSubject<String>.of("울릉도", "뱃길따라", "독도는", "우리땅!")
let three = PublishSubject<String>.of("동남쪽", "200리", "우리땅")

Observable
	.zip(one, two, three) { count, first, second in
      return "\(count): \(first) \(second)" }
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

// Print
// 1: 울릉도 동남쪽
// 2: 뱃길따라 200리
// 3: 독도는 우리땅
```

<br>

## withLatestFrom

- 여러개의 Observable로 부터 데이터를 받을 때, 어떤 **Observable은 단순히 Trigger(방아쇠) 역할**을 합니다. 
- Observable에 계속 값을 넣어도, Trigger 역할을 하는 Observable에 값이 들어왔을 때의 최신 값만 방출됩니다.

```swift
let button = PublishSubject<String>() // or PublishSubject<Void>()
let textField = PublishSubject<String>()

button
	.withLatestFrom(textField)
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

textField.onNext("이건 출력됩니다.")

button.onNext("🔫") // PublishSubject<Void>() 일시, button.onNext(())

textField.onNext("이건 출력하지 않을거고,")
textField.onNext("이건 2번 출력됩니당.")

button.onNext(("🔫"))
button.onNext(("🔫"))

// Print
// 이건 출력됩니다.
// 이건 2번 출력됩니당.
// 이건 2번 출력됩니당.
```

<br>

## sample

- `withLatestFrom()` 은 Trigger에 값이 들어올 때마다 방출되지만, `sample()` 은 Trigger에 **여러 값이 들어와도 한 번만 방출**됩니다.

```swift
let button = PublishSubject<String>()
let textField = PublishSubject<String>()

textField
	.sample(button)
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

textField.onNext("이건 출력하지 않을거고,")
textField.onNext("이건 출력할거에요")

button.onNext(("🔫"))
button.onNext(("🔫")) // 무시 됌

// Print
// 이건 출력할거에요
```



#### ✔️ withLatestFrom 을 sample 처럼 사용하기

- 앞서, **Filtering Operators** 에서 학습했던 `distinctUntilChanged()` 을 통해 `withLatestFrom()` 을  `sample()` 처럼 사용할 수 있습니다.
  -  `distinctUntilChanged()` 은 연달아 들어오는 중복 값을 한 번만 방출하기때문에, Trigger가 반복적으로 들어와도 한 번만 처리합니다.

```swift
let button = PublishSubject<Void>()
let textField = PublishSubject<String>()

button
	.withLatestFrom(textField)
	.distinctUntilChanged()
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

textField.onNext("출력 X")
textField.onNext("출력 X")
textField.onNext("출력 O")

button.onNext(())
button.onNext(())

// Print
// 출력 O
```



## amb 

- Ambiguous 뜻 그대로 애매모호한 상황에 사용됩니다.
- 타입이 동일한 두 개의 Observable 중, 먼저 방출되는 요소가 나타나면  
  다른 Observable에 대한 구독을 중단합니다.
- 즉, 둘 중에 먼저 방출되는 Observable 만 살아남습니다.

```swift
let left = PublishSubject<String>()
let right = PublishSubject<String>()

let observable = left.amb(right)

observable
	.subscribe(onNext: { print($0) })

left.onNext("일") // 방출 시작
right.onNext("1") // 무시 됌
left.onNext("이")
left.onNext("삼")
right.onNext("2")

// Print 일 이 삼
```

<br>

## switchLatest

- SourceObservable로 들어온 **마지막 Observable만 구독**하고, 방출됩니다.

```swift
let one = PublishSubject<String>()
let two = PublishSubject<String>()
let three = PublishSubject<String>()

let source = PublishSubject<Observable<String>>()

source
	.switchLatest()
	.subscribe(onNext: { print($0) })

source.onNext(one)
two.onNext("1") // 무시 됌
one.onNext("2")
three.onNext("3") // 무시 됌

source.onNext(two)
one.onNext("5") // 무시 됌
two.onNext("4")

source.onNext(three)
two.onNext("6") // 무시 됌
one.onNext("7") // 무시 됌
three.onNext("8")

// Print 2 4 8
```

<br>

## reduce(_:, accumulator)

- Swift의 reduce와 동일합니다.
- 제공된 초기 값부터 시작해, 값을 방출할 때마다 해당 값을 가공합니다.

```swift
Observable
	.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
	.reduce(0, accumulator: +)
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

// Print 55
```

<br>

## scan(_:, accumulator)

- `reduce(_:, accumulator)` 는 최종 결과 값만 방출하지만, `scan(_:, accumulator)` 은 **연산이 될때마다 연산 결과 값을 방출**합니다.

```swift
Observable
	.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
	.scan(0, accumulator: +)
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

// Print
// 1
// 3
// 6
// 10
// 15
// 21
// 28
// 36
// 45
// 55
```

