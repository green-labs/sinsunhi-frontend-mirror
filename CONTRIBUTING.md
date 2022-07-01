# 개발환경 구성

## 준비물

- Node.js v14.x 이상
- yarn

## 의존성 설치

```sh
yarn install
```

## 그래프큐엘 API 인트로스펙트

릴레이가 사용할 그래프큐엘 API의 스키마를 생성합니다.

```sh
yarn api-introspect
```

> 인트로스펙트 할 API를 변경해야할 경우, codegen.yml 에서 `.evn.development`의 엔드포인트를 참조하기 때문에 `.evn.development`의 NEXT_PUBLIC_GRAPHQL_API_URL, NEXT_PUBLIC_FMB_GRAPHQL_API_URL API 엔드포인트를 수정하면 됩니다. 그리고 위의 스크립트를 다시 실행해줍니다.

## 빌드

1. 릴레이

```sh
yarn relay:watch
```

2. 테일윈드css

```sh
yarn css:start
```

3. 리스크립트

```sh
yarn res:clean && yarn res:start
```

4. Next.js

```sh
yarn dev
```

> 1~4번을 한 번에 실행해주는 스크립트도 있습니다.

```sh
yarn dev:watch
```
