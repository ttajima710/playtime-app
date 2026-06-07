Ready for review
Select text to add comments on the plan
「たのしい！プレイタイム」Flutter Web アプリ開発計画
Context（背景）
1-2歳向け知育スマホアプリ「たのしい！プレイタイム」を新規開発する。 「触ると動く・音が鳴る」という直感的なフィードバックで幼児の好奇心を刺激するアプリ。 Flutter Web (PWA) として開発し、GitHub Pages にデプロイする。 Figmaワイヤフレーム（React）はデザイン参考として使用し、実装はFlutter (Dart) で行う。

技術スタック
言語/フレームワーク: Dart / Flutter Web
音声: Web Audio API（dart:js_interop 経由で電子音を生成）
ルーティング: go_router
アニメーション: Flutter標準 AnimationController（ワイヤフレームのmotion/framer-motion風の動きを再現）
デプロイ: GitHub Pages + GitHub Actions
PWA: manifest.json + Service Worker
プロジェクト構成
Game_child_app/
├── docs/ # 既存参考資料（変更しない）
├── lib/
│ ├── main.dart # アプリ起動点
│ ├── app.dart # MaterialApp + GoRouter
│ ├── theme/
│ │ └── app_theme.dart # パステルカラーのテーマ定義
│ ├── services/
│ │ └── audio_service.dart # Web Audio API ラッパー（JS interop）
│ ├── widgets/
│ │ ├── home_button.dart # 1秒長押しで戻るボタン（Homeアイコン、プログレス円表示）
│ │ ├── floating_decoration.dart # 浮遊装飾（音符・星・シャボン玉）
│ │ └── animated_button.dart # タップアニメーション付きボタン
│ └── screens/
│ ├── home_screen.dart # ホーム画面
│ ├── game_select_screen.dart # ゲーム選択画面
│ ├── piano/
│ │ ├── piano_screen.dart # ピアノ画面
│ │ └── piano_key.dart # 鍵盤ウィジェット
│ ├── drawing/
│ │ ├── drawing_screen.dart # らくがき画面
│ │ └── drawing_canvas.dart # CustomPainter描画
│ └── remote/
│ ├── remote_screen.dart # リモコン画面
│ └── remote_button.dart # ボタンウィジェット
├── web/
│ ├── index.html # PWA設定含む
│ ├── manifest.json # PWA マニフェスト
│ └── icons/ # アプリアイコン
├── pubspec.yaml
├── .github/workflows/deploy.yml # 自動デプロイ
└── README.md
画面別の実装内容（5画面）

1. ホーム画面
   黄色→ピンクのグラデーション背景
   ウサギキャラクター（青い円の中）＋周りにパレット・テディベア・サーカステントの装飾（ワイヤフレーム準拠）
   シャボン玉・虹・音符・風船・星の浮遊アニメーション（spring/repeat/infinity系）
   「あそぶ」ボタン（緑色、脈動アニメーション）→ ゲーム選択画面へ遷移
   タイトル「たのしい！プレイタイム」「1-2さいむけ」のテキスト表示（ワイヤフレーム準拠）
2. ゲーム選択画面
   2×2グリッド（GridView）でゲーム3つ＋未実装枠
   ピアノ（音符アイコン・ピンク系）
   らくがき（パレットアイコン・黄色系）
   りもこん（スマホアイコン・青系）
   ???（グレー・押せない状態）
   将来のゲーム追加を想定したGridView.builder実装
3. ピアノ
   画面いっぱいの白鍵8つ（ドレミファソラシド）＋ 黒鍵5つ
   鍵盤に「ドレミ」の文字を刻印（木目調デザイン）
   Web Audio API で各周波数のsine波を生成
   マルチタッチ対応（Listenerウィジェットで複数ポインタ管理）
   スライド演奏対応（指を滑らせると鍵盤が切り替わる）
   タップ時：鍵盤沈み込み＋音符・キラキラエフェクト
   ホームボタン：左上、1秒長押しで選択画面に戻る（プログレス円表示、ワイヤフレーム準拠）
4. らくがき
   全面キャンバス（CustomPainter）
   虹色の太い線（HSLColorのhueを回転）
   描画中：キラキラ音が持続（色に合わせて音程変化、300Hz〜1020Hz）
   指を離す：スタンプ（星/ハート）出現 ＋ 「ポンッ」リリース音
   ゴミ箱ボタン：長押しで全消去
   ホームボタン：1秒長押し
5. リモコン
   0〜9の大きな数字ボタン＋動物アイコン
   数字タップで音声再生（各ボタンに異なる周波数）
   特殊ボタン：電話（メロディ）、テレビ（スウィープ音）、電源（下降音）
   同時押し対応（複数ボタンが同時に音を鳴らせる）
   ホームボタン：1秒長押し
   音声サービスの設計（audio_service.dart）
   dart:js_interop で Web Audio API を直接制御：

playTone(frequency, duration, waveType) → 単発の音（ピアノ、リモコン）
startContinuousTone(frequency) → 持続音（らくがき描画中）
updateFrequency(frequency) → 持続音の周波数変更
stopContinuousTone() → 持続音停止
playMelody(notes) → メロディ再生（リモコン特殊ボタン）
iOS Safari対策：初回タップ時にAudioContextをresume()する初期化フロー必須。

実装ステップ（段階的に進行）
Phase 1: 基盤セットアップ
Flutter Web プロジェクト作成
ディレクトリ構成の整備
go_router でルーティング設定（5画面）
パステルカラーのテーマ定義
Web Audio API の音声サービス基本実装
Phase 2: ホーム画面 + ゲーム選択画面
ホーム画面UI（グラデーション、クマキャラ、装飾アニメーション、あそぶボタン）
ゲーム選択画面UI（2×2グリッド）
画面遷移の確認
Phase 3: ピアノ
鍵盤レイアウト（白鍵8＋黒鍵5）
タップで音が鳴る機能
マルチタッチ＋スライド演奏
タップエフェクト
ホームボタン（3秒長押し）
Phase 4: らくがき
CustomPainterで虹色描画
描画音（持続音＋周波数変化）
スタンプ＋リリース音
ゴミ箱（長押し全消去）
Phase 5: リモコン
数字＋特殊ボタンのレイアウト
各ボタンの音声
同時押し対応
Phase 6: PWA + デプロイ
manifest.json（全画面表示、ポートレート固定）
Service Worker（オフライン起動）
GitHub リポジトリ作成 + GitHub Actions 設定
GitHub Pages デプロイ
Phase 7: 仕上げ
連打対応の調整
アニメーション調整
iPhone「ホーム画面に追加」での実機テスト
PWA設定
manifest.json:

name: 「たのしい！プレイタイム」
display: standalone（全画面）
orientation: portrait（縦固定）
アイコン: 192x192, 512x512
index.html に追加:

apple-mobile-web-app-capable: yes
apple-mobile-web-app-status-bar-style: black-translucent
apple-touch-icon
GitHub Pages デプロイ
GitHub Actions (.github/workflows/deploy.yml):

トリガー: main ブランチへの push
Flutter SDK セットアップ
flutter build web --release --base-href /リポジトリ名/
build/web/ を GitHub Pages にデプロイ
検証方法
確認項目 方法
ローカル動作 flutter run -d chrome
タッチ操作 Chrome DevTools モバイルエミュレータ
ピアノの和音 マルチタッチで複数鍵盤同時押し
らくがきの虹色 指で長い線を描いて色変化を確認
リモコン同時押し 2本指で異なるボタンを同時タップ
ホームボタン 1秒未満で離す→戻らない、1秒以上→戻る。プログレス円が表示される
PWA起動 iPhone「ホーム画面に追加」→全画面起動
オフライン 機内モードでアプリ起動
音声（iOS） Safari で初回タップ後に音が鳴るか確認
参考ファイル（デザイン・仕様の根拠）
docs/Notion_specification 326b6ec07cf680c9af5dd42f61375b79.md — 要件定義書（全機能の根拠）
docs/Figma_wireframe/src/app/pages/Home.tsx — ホーム画面のデザイン参考
docs/Figma_wireframe/src/app/pages/PianoGame.tsx — ピアノのWeb Audio API実装パターン
docs/Figma_wireframe/src/app/pages/DrawingGame.tsx — らくがきの描画・音声パターン
docs/Figma_wireframe/src/app/pages/RemoteGame.tsx — リモコンのボタン・音声パターン
docs/Figma_wireframe/src/app/components/HomeButton.tsx — 長押しプログレスの仕組み
