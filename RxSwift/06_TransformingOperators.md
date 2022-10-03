# Transforming Operators

<br>

- Observable이 **방출하는 값을 변환(Transform)** 해주는 연산자 입니다.

<br>

## toArray

- Observable의 **독립 요소들을 Array로 변환**해줍니다.

```swift
Observable
	.of(1, 3, 5, 7, 9)
	.toArray()
	.subscribe { print($0) }
	.disposed(by: disposeBag)
// Print [1, 3, 5, 7, 9]
```

<br>

## map

- Swift의  **`map()` 과 동일**합니다.

```swift
Observable
	.of(1, 2, 3, 4, 5)
	.map { $0 * 2 }
	.subscribe { print($0) }
	.disposed(by: disposeBag)
// Print 2, 4, 6, 8, 10
```

<br>

## flatMap

- 아래 구현부에서 확인할 수 있듯,
  -  `map()` 은 이벤트를 방출하지만 
  - `flatMap()` 은   `Observable` 을 방출합니다.

- **여러개의 `Observable` 을 하나의 `Observable` 로 합쳐 방출**합니다. (2차원 배열을 배열로 바꾸듯)

```swift
public func flatMap<Source: ObservableConvertibleType>(_ selector: @escaping (Element) throws -> Source) -> Observable<Source.Element> {
		return FlatMap(source: self.asObservable(), selector: selector)
}
```

```swift
struct Student {
  var score: BehaviorSubject<Int>
}

let student = PublishSubject<Student>() // 커스텀 타입을 갖고 있는 객체

student
	.asObserver()
	.flatMap { $0.score }
	.subscribe { print($0) }
	.disposed(by: disposeBag)

let jee = Student(score: BehaviorSubject(value: 100))
let dori = Student(score: BehaviorSubject(value: 200))
let jee2 = Student(score: BehaviorSubject(value: 300))

student.onNext(jee)
student.onNext(dori)
student.onNext(jee2)
jee.score.onNext(80)
dori.score.onNext(30)

// print 100, 200, 300, 80, 30
```

<br>

## flatMapLatest

- `flatMap` 과 비슷하나,
  - `flatMap`  은 모든 `Observable` 의 이벤트를 받아 하나의 `Observable` 로 방출하지만, 
  - `flatMapLatest` 은 새로운 `Observable` 의 값이 들어오면, 이전에 등록되어 있던 `Observable` 에는 새 값을 넣어줄 수 없게 됩니다.

- 검색어 자동 완성 구현 등에 유용합니다.


```swift
struct Student {
  var score: BehaviorSubject<Int>
}

let student = PublishSubject<Student>() // 커스텀 타입을 갖고 있는 객체

student
	.asObserver()
	.flatMapLatest { $0.score }
	.subscribe { print($0) }
	.disposed(by: disposeBag)

let jee = Student(score: BehaviorSubject(value: 100))
let dori = Student(score: BehaviorSubject(value: 200))
let jee2 = Student(score: BehaviorSubject(value: 300))

student.onNext(jee)
student.onNext(dori)

jee.score.onNext(20) // dori가 들어왔기 때문에, 출력 안됨
dori.score.onNext(80)

student.onNext(jee2)
dori.score.onNext(30) // jee2가 들어왔기 때문에, 출력 안됨

// print 100, 200, 80, 300
```

<br>

## meterialize

- 요소 뿐만 아니라, **요소를 갖고 있는 이벤트를 방출**합니다.

```swift
Observable.of("A", "B", "C")
	.materialize()
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

// Print
// next(A)
// next(B)
// next(C)
```

- 하지만, materialize() 하지 않아도    
  아래와 같이 `.subscribe { print($0) }` 을 하게 되면, 역시 요소를 갖고 있는 이벤트가 방출됩니다.

```swift
Observable
	.of(1, 3, 5, 7, 9)
	.subscribe { print($0) } // Print next(1), next(3), next(5), next(7), next(9)
  .subscribe(onNext: { print($0) }) // Print 1, 3, 5, 7, 9
	.disposed(by: disposeBag)

```

<br>

## dematerialize

- `materialize()` 와 반대되는 개념으로, **요소를 포함한 이벤트를 다시 요소만 방출**하도록 변경해줍니다.

```swift
Observable.of("A", "B", "C")
	.materialize()
	.dematerialize()
	.subscribe(onNext: { print($0) })
	.disposed(by: disposeBag)

// Print
// A
// B
// C
```
