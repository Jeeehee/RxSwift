# Error Handling

<br>

- RxSwift에서, `Catch` 와 `Retry` 를 통해 에러 핸들링이 가능합니다.

<br>

### Catch

- Swift의 do-try-catch 와 유사합니다.
- 기본 값으로 Error를 복구합니다.

![Group 1 (2)](https://user-images.githubusercontent.com/92635121/193757126-ea6db4da-d77d-47c6-b644-6e4d7f2e5a53.png)

<br>

### Retry

- `retry()` : 무제한 재시도합니다
- `retry(maxAttemptCount: Int)` : 지정된 횟수 만큼 재시도합니다.
- 인터넷이 끊긴 경우 등의 상황에 유용합니다.

![Group 2 (1)](https://user-images.githubusercontent.com/92635121/193757122-7f43757c-1d4a-45df-86c4-9bc4cd86eeb7.png)
