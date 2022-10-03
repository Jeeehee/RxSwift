# RxSwift <img src="https://user-images.githubusercontent.com/92635121/191955960-95768ced-c2bc-404f-87f0-885f3fa91ca2.png" width=5%/>
대망의 RxSwift를 학습하는 공간입니다.

<br>

|No.|Subject|Note|
|:-:|:--|:--|
|01|[Why should we learn RxSwift?](https://github.com/Jeeehee/RxSwift/blob/main/RxSwift/01_WhyShouldWeLearnRxSwift.md)|RxSwift를 배워야 하는 이유|
|02|[Observable](https://github.com/Jeeehee/RxSwift/blob/main/RxSwift/02_Observable.md)|-  RxSwift의 핵심 Obsevable<br />-  `onNext`, `onCompleted`, `onError`<br />-  Dispose|
|03|[Observable 생성 Operators](https://github.com/Jeeehee/RxSwift/blob/main/RxSwift/03_Operators.md)|-  Observable 생성 연산자<br />-  `just` , `of` , `from` , `create` , `range` , `empty` , `never` , `interval `,  `timer` , `deferred` , `repeat`|
|04|[Subjects](https://github.com/Jeeehee/RxSwift/blob/main/RxSwift/04_Subjects.md)|-  Observable + Observer = Subject<br />-  `PublishSubject `, `BehaviorSubject` , `RelaySubject` , `Behavior Relay`|
|05|[FilteringOperators](https://github.com/Jeeehee/RxSwift/blob/main/RxSwift/05_FilteringOperators.md)|-  제약 조건을 적용해 처리하고자 하는 값만 방출<br />-  `ignoreElements` , `element(at:)` , `filter` , `skip(count:)` , `skip(while:)` , `skip(until:)` , `take(count:)` , `take(while:)` , `take(until:)` , `enumerated` , `distinctUntilChanged`|
|06|[Transforming Operators](https://github.com/Jeeehee/RxSwift/blob/main/RxSwift/06_TransformingOperators.md)|-  Observable이 방출하는 값을 변환(Transform) 해주는 연산자<br />-  `toArray` , `map` , `flatMap` , `flatMapLatest` , `meterialize` , `dematerialize`|
|07|[Combinig Operators](https://github.com/Jeeehee/RxSwift/blob/main/RxSwift/07_CombinigOperators.md)|- Observable 혹은 Observable 내의 데이터를 병합/결합(Combine) 해주는 연산자<br />- `startWith` , `concat` , `concatMap` , `merge` , `merge(maxConcurrent:)` , `combineLatest(_:, _:, resultSelector:)` , `zip` , `withLatestFrom` , `sample` , `amb ` , `switchLatest` , `reduce(_:, accumulator)`  , `scan(_:, accumulator)`|
|08|[Time Based Operators](https://github.com/Jeeehee/RxSwift/blob/main/RxSwift/08_TimeBasedOperators.md)|- 시간을 제어하는 연산자<br />- `replay(bufferSize:)` , `replayAll` , `buffer(timeSpan: , count: , scheduler:)` , `window(timeSpan: , count: , scheduler:)` , `delay(dueTime: , scheduler:)` , `delaySubscription(dueTime: , scheduler:)` , `interval(period: , scheduler:)` , `timer(dueTime: , period: , scheduler:)` , `timeout(dueTime: , scheduler:)`|
