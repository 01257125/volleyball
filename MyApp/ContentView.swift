import SwiftUI

// MARK: - 主視圖容器 (ContentView)
/// 使用 TabView 分別完美適配 iPhone 與 iPad：
/// - iPhone: 採用原生標準底部導覽列 (Bottom Tab Bar)，界面乾淨洗鍊、不遮擋內容
/// - iPad: 採用 iPadOS 18 專屬頂部膠囊列與側邊欄適配 (.sidebarAdaptable)
struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                // iPadOS 模式：支援頂部膠囊標籤列與側邊欄展開
                TabView {
                    Tab("首頁", systemImage: "house.fill") {
                        FeaturedHeroScrollView()
                    }

                    Tab("名冊", systemImage: "person.3.fill") {
                        PlayerListView()
                    }

                    Tab("戰役", systemImage: "trophy.fill") {
                        MatchesPinnedHeaderView()
                    }

                    Tab("劇照", systemImage: "photo.on.rectangle") {
                        PhotoGalleryView()
                    }
                }
                .tabViewStyle(.sidebarAdaptable)
            } else {
                // iPhone 模式：使用經典原生底部導覽列，體驗最穩定純粹
                TabView {
                    FeaturedHeroScrollView()
                        .tabItem {
                            Label("首頁", systemImage: "house.fill")
                        }

                    PlayerListView()
                        .tabItem {
                            Label("名冊", systemImage: "person.3.fill")
                        }

                    MatchesPinnedHeaderView()
                        .tabItem {
                            Label("戰役", systemImage: "trophy.fill")
                        }

                    PhotoGalleryView()
                        .tabItem {
                            Label("劇照", systemImage: "photo.on.rectangle")
                        }
                }
            }
        }
        .tint(.orange)
    }
}

#Preview {
    ContentView()
}
