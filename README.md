# 🏐 排球少年！！全明星圖鑑 (Haikyuu!! All Stars)

這是我在彼得潘 iOS App 程式設計課的作業：「使用 SwiftUI 製作結合酷炫動畫效果的電子書 App」。平時在系排打球，寫 code 的時候當然也要把排球魂點滿！所以這次決定拿神作《排球少年！！》來當主題，順便挑戰把作業清單上的進階排版跟動畫要求全部解鎖。

## 🎬 App 操作展示

> 💡 **Tip:** 請將錄製好的 `app_demo.gif` 直接拖曳到這行文字的位置，GitHub 會自動幫你轉成圖片連結！

## ✨ 實作亮點與解鎖功能

這次作業除了多頁面切換跟 List 基本盤，還塞了這些好玩的東西：

* **iPhone & iPad 完美雙棲**
  透過 `@Environment(\.horizontalSizeClass)` 判斷裝置。拿 iPhone 看是標準底部 TabBar，用 iPad 打開則會自動套用 iPadOS 18 專屬的頂部膠囊列與側邊欄 (`.tabViewStyle(.sidebarAdaptable)`)。
  
* **天生支援 Dark / Light Mode**
  忍住不亂寫死色碼，全 App 都用 Apple 原生的語意化色彩（例如 `.primary`、`systemGroupedBackground`），切換深色模式時畫面依然乾淨舒服。

* **IG 限動感卡片 & 吸頂標題 (Pinned Header)**
  * 用 iOS 17 的 `.scrollTargetBehavior(.paging)` 做出像限時動態一樣滑順的全螢幕水平分頁。
  * 賽事紀錄那頁用了 `LazyVStack(pinnedViews: [.sectionHeaders])`，往下滑的時候錦標賽標題會牢牢吸在最上面，不怕忘記滑到哪。

* **有靈魂的微動畫**
  * 點擊收藏愛心時，會觸發 iOS 17 的 `.symbolEffect(.bounce)` 活潑彈跳。
  * 畫面進場加了 `.spring()` 彈簧動畫，戰力面板展開則用 `.transition` 控制，手感更滑順。
  * 自己寫了一個 `.vibrantImageStyle()` Modifier 來拉高對比跟飽和度，讓動漫海報視覺張力更強。

* **AsyncImage 抓圖 & App 內建百科**
  圖片全用 `AsyncImage` 非同步載入，還加了轉圈圈防呆。想看更詳細的球員介紹，點擊按鈕會透過封裝好的 `SFSafariViewController` 直接在 App 內彈出網頁，不用再跳轉到 Safari。

## 📂 專案架構

受不了所有東西塞在同一個畫面，所以有把職責切乾淨：
* `Models.swift`: 統一定義遵從 `Identifiable` 的 Struct 還有測試資料。
* `CustomModifiers.swift`: 把常用的 UI 樣式封裝成 ViewModifier，省掉一大堆重複的 code。
* 為了讓專案完整一點，根目錄還偷塞了一個手刻的毛玻璃質感 `landing_page.html` 響應式展示網頁。

## 🛠 開發環境
* Xcode / iOS 17+
* SwiftUI
