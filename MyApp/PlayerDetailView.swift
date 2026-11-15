import SwiftUI
import AVKit

// MARK: - 球員詳情頁面 (PlayerDetailView)
struct PlayerDetailView: View {
    let player: Player

    @State private var isHeaderAppeared: Bool = false
    @State private var showAllStats: Bool = false
    @State private var isFavorited: Bool = false
    @State private var favoriteBounceCount: Int = 0

    @State private var showSafari: Bool = false
    @State private var showVideoSheet: Bool = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                // 1. 頂部視覺海報與頭像區塊（嚴格拘束寬高，防破版）
                headerBannerSection

                // 2. 球員名言金句
                quoteSection

                // 3. 基本檔案卡片
                basicInfoSection

                // 4. 六維戰力指標與展開動畫
                statsSection

                // 5. 賽事高光紀實（排球名場面文字解析）
                matchHighlightSection

                // 6. 招牌絕技卡片
                signatureMovesSection
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.top, 4)
            .padding(.bottom, 36)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle(player.name)
        .navigationBarTitleDisplayMode(.inline)
        // 進入二級詳情頁面時隱藏底部 TabBar，確保版面乾淨且不遮擋內容
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 12) {
                    Button {
                        showVideoSheet = true
                    } label: {
                        Image(systemName: "play.tv")
                            .foregroundColor(player.school.themeColor)
                    }

                    favoriteToolbarButton
                }
            }
        }
        .sheet(isPresented: $showSafari) {
            if let url = URL(string: player.wikiURL) {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        }
        .sheet(isPresented: $showVideoSheet) {
            NavigationStack {
                VStack(spacing: 16) {
                    if let localVideoURL = Bundle.main.url(forResource: "sample_video", withExtension: "mp4") {
                        VideoPlayer(player: AVPlayer(url: localVideoURL))
                            .frame(height: 240)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)
                    }
                    Text("SwiftUI VideoPlayer 影音播放展示")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .navigationTitle("影音展示")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("關閉") {
                            showVideoSheet = false
                        }
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                isHeaderAppeared = true
            }
        }
    }

    // MARK: - 1. 頂部視覺區塊（使用 overlay 鎖定尺寸，徹底解決橫向撐爆版面問題）
    private var headerBannerSection: some View {
        ZStack(alignment: .bottomLeading) {
            // 底層容器固定 210pt 高度，寬度自動貼齊父視圖
            Color(UIColor.secondarySystemFill)
                .frame(height: 210)
                .overlay(
                    AsyncImage(url: URL(string: player.bannerURL)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            player.school.themeColor.opacity(0.3)
                        @unknown default:
                            EmptyView()
                        }
                    }
                )
                .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.8)],
                startPoint: .top,
                endPoint: .bottom
            )

            HStack(spacing: 12) {
                AsyncImage(url: URL(string: player.avatarURL)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipped()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2.5))
                            .shadow(radius: 4)
                    } else {
                        Circle()
                            .fill(player.school.themeColor)
                            .frame(width: 60, height: 60)
                    }
                }
                .frame(width: 60, height: 60)

                VStack(alignment: .leading, spacing: 2) {
                    Text(player.name)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    Text(player.japaneseName)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.85))
                        .lineLimit(1)
                }

                Spacer()

                Text("#\(player.number)")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(player.school.themeColor.opacity(0.95))
                    .shadow(color: .black.opacity(0.4), radius: 3)
            }
            .padding(14)
        }
        .frame(height: 210)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .scaleEffect(isHeaderAppeared ? 1.0 : 0.96)
        .opacity(isHeaderAppeared ? 1.0 : 0.0)
    }

    // MARK: - 2. 名言佳句區塊
    private var quoteSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "quote.opening")
                    .foregroundColor(player.school.themeColor)
                Spacer()
                Image(systemName: "quote.closing")
                    .foregroundColor(player.school.themeColor)
            }

            Text("「\(player.quote)」")
                .font(.subheadline)
                .italic()
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("— \(player.name)（\(player.school.rawValue)）")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .haikyuuCard(borderColor: player.school.themeColor.opacity(0.2))
    }

    // MARK: - 3. 基本資料卡片
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("球員基本檔案", systemImage: "person.text.rectangle.fill")
                    .font(.headline)
                    .foregroundColor(player.school.themeColor)

                Spacer()

                Button {
                    showSafari = true
                } label: {
                    Label("百科檔案", systemImage: "safari.fill")
                        .font(.caption.bold())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.blue.gradient)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }

            Divider()

            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("所屬學校")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(player.school.rawValue)
                        .font(.footnote.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 4) {
                    Text("球場位置")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(player.position.rawValue)
                        .font(.footnote.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 4) {
                    Text("身高")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.1f cm", player.height))
                        .font(.footnote.bold())
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 2)

            Text(player.biography)
                .font(.footnote)
                .foregroundColor(.secondary)
                .lineSpacing(3)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .haikyuuCard()
    }

    // MARK: - 4. 六維能力值卡片
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("各項戰力指標", systemImage: "chart.bar.xaxis")
                    .font(.headline)
                    .foregroundColor(player.school.themeColor)

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                        showAllStats.toggle()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(showAllStats ? "收合" : "展開細節")
                            .font(.caption.bold())
                        Image(systemName: showAllStats ? "chevron.up" : "chevron.down")
                            .font(.caption2.bold())
                    }
                    .foregroundColor(player.school.themeColor)
                }
            }

            statBarRow(title: "力量 (Power)", value: player.stats.power, color: .red)
            statBarRow(title: "彈跳 (Jumping)", value: player.stats.jumping, color: .orange)
            statBarRow(title: "體力 (Stamina)", value: player.stats.stamina, color: .green)

            if showAllStats {
                VStack(spacing: 12) {
                    statBarRow(title: "技術 (Technique)", value: player.stats.technique, color: .blue)
                    statBarRow(title: "速度 (Speed)", value: player.stats.speed, color: .purple)
                    statBarRow(title: "球商 (Intelligence)", value: player.stats.intelligence, color: .indigo)
                }
                .padding(.top, 4)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.95).combined(with: .opacity),
                    removal: .opacity
                ))
            }
        }
        .haikyuuCard()
    }

    private func statBarRow(title: String, value: Int, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(value) / 5")
                    .font(.caption.bold())
                    .foregroundColor(.primary)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.secondary.opacity(0.15))
                        .frame(height: 8)

                    Capsule()
                        .fill(color.gradient)
                        .frame(width: geo.size.width * CGFloat(value) / 5.0, height: 8)
                }
            }
            .frame(height: 8)
        }
    }

    // MARK: - 5. 賽事高光紀實（排球名場面文字解析）
    private var matchHighlightSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("賽事高光紀實", systemImage: "flame.circle.fill")
                    .font(.headline)
                    .foregroundColor(player.school.themeColor)

                Spacer()

                Text("經典名場面")
                    .font(.caption2.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(player.school.themeColor.opacity(0.12))
                    .foregroundColor(player.school.themeColor)
                    .clipShape(Capsule())
            }

            Text(player.matchHighlight)
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineSpacing(5)
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(player.school.themeColor.opacity(0.15), lineWidth: 1)
                )
        }
        .haikyuuCard()
    }

    // MARK: - 6. 招牌絕技卡片
    private var signatureMovesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("招牌絕技", systemImage: "bolt.fill")
                .font(.headline)
                .foregroundColor(.orange)

            Text(player.signatureMove)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.orange.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .haikyuuCard()
    }

    // MARK: - 收藏按鈕
    private var favoriteToolbarButton: some View {
        Button {
            isFavorited.toggle()
            favoriteBounceCount += 1
        } label: {
            Image(systemName: isFavorited ? "heart.fill" : "heart")
                .foregroundColor(isFavorited ? .red : .primary)
                .symbolEffect(.bounce, value: favoriteBounceCount)
        }
    }
}
