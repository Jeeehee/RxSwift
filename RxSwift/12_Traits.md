# Traits

<br>

- App의 정확성과 안정성을 향상시키고, Rx를 보다 직관적이고 직접적인 경험으로 만드는 시스템입니다.
- 모든 컨텍스트에서 사용할 수 있는 원시 Observerble과 비교할 때,  
인터페이스 경계에서 Observerble 프로퍼티를 전달하고 보장하며 문법적으로도 더 쉽습니다. 
- Traits은 Struct이며, 읽기 전용 Observable Sequence Property와 함께 wrapping되어있습니다.
- Trait이 만들어고, `asObservable()`을 호출하면 observable seqeunce로 다시 변환합니다.

<br>

## RxSwift Traits
- 아래 Traits은 부수작용을 공유하지 않습니다.

#### 1. Single
- 항상 단일 요소 혹은 오류를 방출합니다.
- 부수작용을 공유하지 않습니다.
- 사용하는 일반적인 예로는 응답과 오류만 반환할 수 있는 HTTP요청이 있고,  
이와 같이 단일 요소만 방출할 때 사용됩니다.

#### 2. Completable
- 완료 이벤트나 에러를 방출할 수 있으면서, 아무 요소도 방출하지 않을 수도 있습니다.
- 요소를 내보낼 수 없는 경우나 완료에 따른 다른 요소를 신경쓰지 않는 경우에 사용됩니다.

#### 3. Maybe
- 위 `Single`과 `Completable` 의 중간의 느낌으로  
단일 요소를 방출하거나 아무 요소도 방출하지 않고 완료, 에러 방출을 할 수 있습니다.


<br>

## RxCocoa Traits
- Share연산자가 내부적으로 사용된 상태로, Traits를 구독하는 모든 구독자는 동일한 시퀀스 및 부수작용을 공유합니다.

#### 1. Driver
- UI에 Reactive 코드를 작성하는 직관적인 방법을 제공하거나, App에서 데이터 스트림을 모델링하는 모든 경우를 위한 것입니다.
- 오류를 방출하지 않고, 부수작용을 공유합니다.
- Observer는 Main Scheulder에서 발생합니다.
- UI 작업 등 MainThread에서 작업해야할 때, Observable 대신 사용합니다.

#### 2. ControlProperty / ControlEvent
- 절대 실패하거나 에러가 발생하지 않습니다.
- MainScheduler.instance에서 이벤트를 전달합니다.
- `textField.rx.controlEvent(.editingDidEndOnExit)` 와 같이 사용하며,  
 해당 프로퍼티의 변경사항을 Observable<Data> 로 받아올 수 있습니다.
