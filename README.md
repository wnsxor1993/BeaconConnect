# BeaconConnect

**CLLocation으로 Beacon 감지 가능하도록 구현한 프로젝트**
<br>

## 🎯 프로젝트 목표

```
    1. Beacon 감지 구현
    2. CLLocation + CLBeacon 학습
```
<br>

## 🙊 목표 선정 이유
- Beacon을 통해 사용자의 위치를 확인하는 기능을 구현하기 위한 CLLocation, CLBeacon 학습용 프로젝트 선정

<br>

## 📝 화면 개요
|   화면    |
| :----------: |
|  <img src="https://user-images.githubusercontent.com/44107696/215018278-949d8366-3bf5-42e4-9af6-a3bf6e4793b4.gif" width="200"> |
|   비콘 감지    |

## ⚙️ 개발 환경


[![Swift](https://img.shields.io/badge/swift-v5.5-orange?logo=swift)](https://developer.apple.com/kr/swift/)
[![Xcode](https://img.shields.io/badge/xcode-v14.0-blue?logo=xcode)](https://developer.apple.com/kr/xcode/)
<img src="https://img.shields.io/badge/UIkit-000000?style=flat&logo=UIkit" alt="uikit" maxWidth="100%">


<br>

## 🌟 학습 내용
#### 1. Beacon Count

- 궁금한 사항
    - 신호를 감지하고 UI로 출력되는 비콘이 3개인데 locationManager didRange에서 출력되는 비콘의 숫자가 2개만 감지.

- 해결
    - 확실한 이유를 찾아내긴 힘들었음. 다만 현재로서 추측하는 것은 didRange에서 감지하는 비콘의 개수는 동일한 UUID의 비콘 수로 보임. 다른 UUID의 비콘도 등록할 수 있지만, 어지간하면 하나의 UUID의 비콘만 등록해주는 게 적절한 사용 방향으로 보임.
    (UUID의 범위가 지역으로 표현되는 걸로 보아, 상기의 건을 유추)


#### 2. iOS 13 이후 depreceated된 startRangingBeacons(in: )

- 궁금한 사항
    - 서칭에서 나온 방법들의 대다수가 iOS 13 이후 depreceated된 방법이어서 권장하는 방법 중 하나인 startRangingBeacons(satisfying:)을 어떻게 사용해야 될 지 감이 잡히지 않았음.

- 해결
    - 일본 블로그에서 방법을 찾아냄.
        - 먼저 CLBeaconIdentityConstraint를 UUID, 필요하면 major나 minor도 추가해서 생성을 한 뒤, 이 값을 CLBeaconRegion의 이니셜라이징 때 인자로 전달하여 생성.
        - startMonitoring(for:)은 동일하게 Region 값을 넣어주고, startRangingBeacons(satisfying:)에서는 CLBeaconRegion의 beaconIdentityConstraint 프로퍼티를 추출해서 인자값으로 넘겨주면 된다.
        - 참조 블로그 주소 (https://qiita.com/renchild8/items/62d5c6f399176981295f)

#### 3. CLLocation Background

- 궁금한 사항
    - CLLocation을 백그라운드에서도 감지되도록 구현하기 위해 allowsBackgroundLocationUpdates와 pausesLocationUpdatesAutomatically의 값을 설정했는데 이에 대한 오류가 발생

- 해결
    - 백그라운드에서 동작하기 위해서는 Capabilities에서 Background Modes를 추가하고 Location updates를 체크해줘야 했는데 이 부분을 까먹고 누락했음.
        - allowsBackgroundLocationUpdates : 백그라운드에서도 위치정보를 수신받을 수 있는 지에 대한 결정(백그라운드 돌리려면 true로 할당 / 기본값은 false)
        - pausesLocationUpdatesAutomatically : locationManager가 위치정보 수신을 일시 중지 할 수 있는 지에 대한 결정 (백그라운드 돌리려면 false로 할당 / 기본값은 true)
