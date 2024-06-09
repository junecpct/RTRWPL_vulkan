# RT_vulkan
- VulkanのRay Tracing Extensionとレイトレーシングハードウェア(ex. NVIDIA製GPUのRT core, AMD製GPUのRay Acceleratorなど)を使用し, 簡単な電波の伝搬損失計算を行うプログラムです.
- アルゴリズムとしては, 送信点から発射したレイが受信エリアに到達したとき受信電力を計算する, SBR法を採択しています.<br><img src="https://github.com/junecpct/RT_vulkan/blob/main/image/sbr.png" width="800">
- 本プログラムはNVIDIA社の[Vulkan Ray Tracing Tutorial](https://github.com/nvpro-samples/vk_raytracing_tutorial_KHR)をベースにして作成しました.

## Setup
- Vulkan Ray Tracing Tutorialの[Setup](https://github.com/nvpro-samples/vk_raytracing_tutorial_KHR/blob/master/docs/setup.md)と同一です.
  - [nvpro-samples](https://github.com/nvpro-samples/build_all)


出力された結果を見るためには, 
- Vulkan ConfiguratorのValidation Settings → VK_LAYER_KHRONOS_validation → Validation Areas → GPU BaseをDebug Printfに変更し, Redirect Printf messages to stdoutにチェックを入れる必要があります.
- Vulkan Configuratorを閉じた後も設定が有効になるよう, Continue Overriding Layers on Exitにもチェックを入れることをおすすめします.

### Parameters
- hello_vulkan.h
  - `SAMPLE_WIDTH`H & `SAMPLE_HEIGHT`
    - `SAMPLE_WIDTH`×`SAMPLE_HEIGHT`個のレイを投射します.
    - 球面座標系を用いてレイを垂直・水平方向に投射しているため, 全方向に等間隔で投射するためには<br>`SAMPLE_WIDTH` : `SAMPLE_HEIGHT` = 2 : 1 にする必要があります.
  - `FRAME_WIDTH` & `FRAME_HEIGHT`
    - プログラムのウインドウがディスプレイより大きい場合, ディスプレイに映っていない部分は計算されないため, もっと小さい単位でフレームごとにレイを投射します.
    - プログラムのウインドウサイズを決める変数でもあります. GLFWの都合上, `FRAME_WIDTH`は120より大きくする必要があります.


### Input / Output Example

### Program list
Program | Details
---------|--------
<img src="https://github.com/junecpct/RT_vulkan/blob/main/MAIN/vk_SphereandPlane/images/sphereandplane.jpg" width="800"> | [SphereandPlane](MAIN/vk_SphereandPlane)<br> - レイ投射点：赤 (0.0, -1.0, 0.0)<br> - 受信球：緑 (0.0, 1.0, 0.0)<br><br>objファイルによって形成された球体と平面でできた問題空間にして, 電波の伝搬損失計算を適用したプログラムです.
<img src="https://github.com/junecpct/RT_vulkan/blob/main/MAIN/vk_ItoCampus/images/itocampus.jpg" width="1000"> | [ItoCampus](MAIN/vk_SphereandPlane)<br> - レイ投射点：赤 (130.0, 80.0, -50.0)<br> - 受信球：緑 (-55.19, 71.0, -62.049)<br><br>国土交通省が主導するオープンデータ化プロジェクト[PLATEAU](https://www.mlit.go.jp/plateau/)にて配布されている日本全国の3D都市モデルから, 九州大学伊都キャンパスの一部の3Dモデルを抽出し, objファイルに変換して問題空間を作成しました. 行われる計算はSphereandPlaneと同一です.
