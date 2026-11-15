import SwiftUI

// MARK: - 首頁探索視圖 (FeaturedHeroScrollView)
/// 在上下垂直捲動的頁面中，加入使用 iOS 17 `.scrollTargetBehavior(.paging)` 實現的水平分頁輪播區塊
struct FeaturedHeroScrollView: View {
    private let featuredPlayers = MockData.players

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // 1. 頂部精神標語
                    welcomeHeader

                    // 2. 水平平滑分頁捲動區塊 (.scrollTargetBehavior(.paging))
                    featuredHorizontalPagingSection

                    // 3. 本週精選球隊
                    featuredTeamBanner

                    // 4. 球員快速瀏覽列
                    quickPickSection
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("排球少年！！")
        }
    }

    // MARK: - 1. 頂部歡迎標題
    private var welcomeHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("HAIKYUU!! ALL STARS")
                .font(.caption.bold())
                .foregroundColor(.orange)
                .tracking(2)

            (Text("頂端的")
                .font(.title.bold())
                .foregroundColor(.primary)
            + Text(" 景色 ")
                .font(.title.bold())
                .foregroundColor(.orange)
            + Text("— 烏野與宿敵")
                .font(.title2.bold())
                .foregroundColor(.secondary))

            Text("「排球是永遠向上看的運動！」探索春高舞台上的傳奇選手與熱血戰役。")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }

    // MARK: - 2. 水平捲動分頁區塊 (.scrollTargetBehavior(.paging))
    private var featuredHorizontalPagingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("焦點王牌", systemImage: "sparkles")
                    .font(.headline.bold())
                    .foregroundColor(.primary)

                Spacer()
            }
            .padding(.horizontal)

            // 水平捲動搭配 iOS 17 .scrollTargetBehavior(.paging) 實現平滑分頁
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(featuredPlayers) { player in
                        NavigationLink {
                            PlayerDetailView(player: player)
                        } label: {
                            heroCard(for: player)
                        }
                        .buttonStyle(.plain)
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
        }
    }

    // 焦點球員橫幅大卡片（嚴格鎖定寬高約束）
    private func heroCard(for player: Player) -> some View {
        ZStack(alignment: .bottomLeading) {
            Color(UIColor.secondarySystemFill)
                .frame(height: 220)
                .overlay(
                    AsyncImage(url: URL(string: player.bannerURL)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .contrast(1.08)
                                .saturation(1.15)
                        case .failure:
                            player.school.themeColor.opacity(0.3)
                        @unknown default:
                            EmptyView()
                        }
                    }
                )
                .clipped()

            // 漸層覆蓋保護文字
            LinearGradient(
                colors: [.clear, .black.opacity(0.8)],
                startPoint: .top,
                endPoint: .bottom
            )

            // 卡片內資訊
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(player.school.rawValue)
                        .badgeCapsule(backgroundColor: player.school.themeColor)

                    Text(player.position.rawValue)
                        .font(.caption.bold())
                        .foregroundColor(.white.opacity(0.9))
                }

                (Text(player.name)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                + Text(" #\(player.number)")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .foregroundColor(player.school.themeColor))

                Text(player.quote)
                    .font(.caption)
                    .italic()
                    .lineLimit(1)
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(16)
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.18), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }

    // MARK: - 3. 今日焦點球隊
    private var featuredTeamBanner: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("代表球隊：烏野高中", systemImage: "flag.fill")
                .font(.headline)
                .foregroundColor(.orange)

            Text("「沒落的強豪，飛不起來的烏鴉」——在全國大賽上以多變的怪人快攻與全體同步進攻打破常規，震撼全日本！")
                .font(.footnote)
                .foregroundColor(.secondary)
                .lineSpacing(3)
        }
        .haikyuuCard(borderColor: Color.orange.opacity(0.25))
        .padding(.horizontal)
    }

    // MARK: - 4. 熱血選手快速點閱
    private var quickPickSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("人氣球員")
                .font(.headline.bold())
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(MockData.players) { player in
                        NavigationLink {
                            PlayerDetailView(player: player)
                        } label: {
                            VStack(spacing: 8) {
                                AsyncImage(url: URL(string: player.avatarURL)) { phase in
                                    switch phase {
                                    case .empty:
                                        Circle().fill(Color.secondary.opacity(0.15))
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    case .failure:
                                        Circle().fill(player.school.themeColor.opacity(0.2))
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(player.school.themeColor, lineWidth: 2))

                                Text(player.name)
                                    .font(.caption.bold())
                                    .foregroundColor(.primary)
                                    .lineLimit(1)

                                Text(player.position.shortName)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .frame(width: 80)
                            .padding(.vertical, 10)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: Color.black.opacity(0.04), radius: 3)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
