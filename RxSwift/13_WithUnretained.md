# WithUnretained

<br>

- RxSwift 6부터 추가된 기능입니다.
- 클로저에서 `[weak self]` 를 대신해 사용할 수 있습니다.

<br>

## 어떻게 구현되어있나?

구현부를 살펴보면 오브젝트를 매개변수로 입력받아, 에러핸들링 후 `(Object, Element)` 의 Tuple로 반환합니다.


```swift
public func withUnretained<Object: AnyObject, Out>(_ obj: Object, resultSelector: @escaping (Object, Element) -> Out) -> Observable<Out> {
    map { [weak obj] element -> Out in
        guard let obj = obj else { throw UnretainedError.failedRetaining }

        return resultSelector(obj, element)
    }
    .catch { error -> Observable<Out> in
        guard let unretainedError = error as? UnretainedError,
              unretainedError == .failedRetaining else {
            return .error(error)
        }

        return .empty()
    }
}
```

<br>

## 사용 예시
아래와 같이 클로저에서 self를 참조하고 있다면, `[weak self]` 를 사용해 Memory Leak을 방지해야 했습니다.  

```swift
viewModel.item
    .subscribe { [weak self] data in
        guard let self = self else { return }
        guard let data = data.element else { return }
        self.dataSource.item = data
    }
    .disposed(by: disposeBag)

```
이 역시도 잘못된 코드는 아니나, `withUnretained` 을 사용하게 되면  
아래와 같이 훨씬 간결하고 가독성이 좋은 코드를 작성할 수 있습니다.

```swift
viewModel.item
    .withUnretained(self)
    .subscribe { owner, data in
        owner.dataSource.item = data
    }
    .disposed(by: disposeBag)
```

## 오류 처리
하지만 error나 completion event를 처리해야한다면, 아래와 같이 다시 `[weak self]` 를 써야합니다. 

```swift
showSearchView
    .withUnretained(self)
    .subscribe{ (object, element) in
        object.start()
    } onError: { [weak self] error in
        guard let self = self else { return }
        object.start()
    }
    .disposed(by: disposeBag)
}
```

아래와 같이 `subscribe` 에 매개변수로 self를 넘겨주어 사용하면 해당 문제를 간결하게 해결할 수 있습니다.

```swift
showSearchView
    .subscribe(with: self) { (object, element) in
        object.start()
    } onError: { (object, error) in
        object.start()
    }
    .disposed(by: disposeBag)
}
```
