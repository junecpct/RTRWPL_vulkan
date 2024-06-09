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
  - `SAMPLE_WIDTH` & `SAMPLE_HEIGHT`
    - `SAMPLE_WIDTH`×`SAMPLE_HEIGHT`個のレイを投射します.
    - 球面座標系を用いてレイを垂直・水平方向に投射しているため, 全方向に等間隔で投射するためには<br>`SAMPLE_WIDTH` : `SAMPLE_HEIGHT` = 2 : 1 にする必要があります.
  - `FRAME_WIDTH` & `FRAME_HEIGHT`
    - プログラムのウインドウがディスプレイより大きい場合, ディスプレイに映っていない部分は計算されないため, もっと小さい単位でフレームごとにレイを投射します.
    - プログラムのウインドウサイズを決める変数でもあります. GLFWの都合上, `FRAME_WIDTH`は120より大きくする必要があります.


### Parameter / Output Example
```
// SAMPLE_WIDTH = 20000, SAPMLE_HEIGHT = 10000
_______________
Vulkan Version:
 - available:  1.3.268
 - requesting: 1.2.0
______________________
Used Instance Layers :
VK_LAYER_LUNARG_monitor

Used Instance Extensions :
VK_KHR_surface
VK_KHR_xcb_surface
VK_EXT_debug_utils
UNASSIGNED-CreateInstance-status-message(INFO / SPEC): msgNum: -2016116905 - Validation Information: [ UNASSIGNED-CreateInstance-status-message ] Object 0: handle = 0x55cac15aacd0, type = VK_OBJECT_TYPE_INSTANCE; | MessageID = 0x87d47f57 | vkCreateInstance():  Khronos Validation Layer Active:
    Settings File: Found at /home/friskaddict/.local/share/vulkan/settings.d/vk_layer_settings.txt specified by VkConfig application override.
    Current Enables: VK_VALIDATION_FEATURE_ENABLE_DEBUG_PRINTF_EXT.
    Current Disables: None.

    Objects: 1
        [0] 0x55cac15aacd0, type: 1, name: NULL
____________________
Compatible Devices :
0: NVIDIA RTX A6000
Could NOT locate mandatory extension 'VK_KHR_acceleration_structure'
Skipping physical device llvmpipe (LLVM 15.0.7, 256 bits)
Physical devices found : 1
________________________
Used Device Extensions :
VK_KHR_swapchain
VK_KHR_acceleration_structure
VK_KHR_ray_tracing_pipeline
VK_KHR_deferred_host_operations
VK_KHR_shader_non_semantic_info

Loading File:  media/scenes/itocampus.obj
ray ID: 1575878, result: 0.000011, total path: 203.058731, depth: 1
ray ID: 1575879, result: 0.000011, total path: 203.095886, depth: 1
ray ID: 99570015, result: 0.000010, total path: 433.973846, depth: 2
ray ID: 103109641, result: 0.000013, total path: 274.146149, depth: 3
ray ID: 106482070, result: 0.000021, total path: 505.726257, depth: 8
ray ID: 194115071, result: 0.000017, total path: 288.275757, depth: 4
ray ID: 196598804, result: 0.000049, total path: 504.811523, depth: 15
Elapsed time: 0.224912 [s]
```

### Program list
Program | Details
---------|--------
<img src="https://github.com/junecpct/RT_vulkan/blob/main/MAIN/vk_SphereandPlane/images/sphereandplane.jpg" width="800"> | [SphereandPlane](MAIN/vk_SphereandPlane)<br> - レイ投射点：赤 (0.0, -1.0, 0.0)<br> - 受信球：緑 (0.0, 1.0, 0.0)<br><br>objファイルによって形成された球体と平面でできた問題空間にして, 電波の伝搬損失計算を適用したプログラムです.
<img src="https://github.com/junecpct/RT_vulkan/blob/main/MAIN/vk_ItoCampus/images/itocampus.jpg" width="1000"> | [ItoCampus](MAIN/vk_SphereandPlane)<br> - レイ投射点：赤 (130.0, 80.0, -50.0)<br> - 受信球：緑 (-55.19, 71.0, -62.049)<br><br>国土交通省が主導するオープンデータ化プロジェクト[PLATEAU](https://www.mlit.go.jp/plateau/)にて配布されている日本全国の3D都市モデルから, 九州大学伊都キャンパスの一部の3Dモデルを抽出し, objファイルに変換して問題空間を作成しました. 行われる計算はSphereandPlaneと同一です.
