# RT_vulkan
- VulkanのRay Tracing Extensionとレイトレーシングハードウェア(ex. NVIDIA製GPUのRT core, AMD製GPUのRay Acceleratorなど)を使用し、<br>簡単な電波の伝搬損失計算を行うプログラムです。
- 本プログラムはNVIDIA社の[Vulkan Ray Tracing Tutorial](https://github.com/nvpro-samples/vk_raytracing_tutorial_KHR)をベースにして作成しました。

## Setup
- Vulkan Ray Tracing Tutorialの[Setup](https://github.com/nvpro-samples/vk_raytracing_tutorial_KHR/blob/master/docs/setup.md)と同一です。
  - [nvpro-samples](https://github.com/nvpro-samples/build_all)

Program | Details
---------|--------
<img src="https://github.com/junecpct/RT_vulkan/blob/main/MAIN/vk_SphereandPlane/images/sphereandplane.jpg" width="400"> | [SphereandPlane](MAIN/vk_SphereandPlane)<br>レイ投射点：赤 ()<br>受信球：緑 ()<br>.objファイルによって形成された球体と平面でできた問題空間への電波の伝搬損失計算を適用したプログラムです。
<img src="https://github.com/junecpct/RT_vulkan/blob/main/MAIN/vk_ItoCampus/images/itocampus.jpg" width="500"> | [ItoCampus](MAIN/vk_SphereandPlane)<br>レイ投射点：赤 ()<br>受信球：緑 ()<br>国土交通省が主導するオープンデータ化プロジェクトPLATEAU\cite{plateau}のウェブサイトにて配布されている日本全国の3D都市モデルから, 九州大学伊都キャンパスの一部の3Dモデルを抽出し, objファイルに変換して問題空間を作成した.
