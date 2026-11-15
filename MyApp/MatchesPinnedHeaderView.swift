import SwiftUI

// MARK: - 經典戰役頁面 (MatchesPinnedHeaderView)
/// 使用 LazyVStack 搭配 pinnedViews: [.sectionHeaders] 實現吸頂 Header
struct MatchesPinnedHeaderView: View {
    private let tournaments = MockData.tournamentSections

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 18, pinnedViews: [.sectionHeaders]) {
                    ForEach(tournaments) { tournament in
                        Section {
                            VStack(spacing: 14) {
                                ForEach(tournament.matches) { match in
                                    matchCard(match: match)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 20)
                        } header: {
                            pinnedHeaderView(for: tournament)
                        }
                    }
                }
                .padding(.top, 4)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("經典戰役")
        }
    }

    // MARK: - 吸頂標題元件
    private func pinnedHeaderView(for tournament: TournamentSection) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(.orange)
                        .font(.subheadline)

                    Text(tournament.tournamentName)
                        .font(.headline.bold())
                        .foregroundColor(.primary)
                }

                Text(tournament.season)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text("\(tournament.matches.count) 場對決")
                .font(.caption2.bold())
                .foregroundColor(.orange)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.orange.opacity(0.12))
                .clipShape(Capsule())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.primary.opacity(0.08)),
            alignment: .bottom
        )
    }

    // MARK: - 單場賽事卡片
    private func matchCard(match: MatchRecord) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // 頂部回合與勝負標籤
            HStack {
                Text(match.roundTitle)
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: match.isVictory ? "crown.fill" : "flag.fill")
                        .font(.caption2)
                    Text(match.result)
                        .font(.caption.bold())
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(match.isVictory ? Color.green : Color.gray)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }

            // 對陣與比數看板
            HStack(spacing: 12) {
                // 烏野
                VStack(spacing: 3) {
                    Text("烏野高中")
                        .font(.headline.bold())
                        .foregroundColor(.orange)
                    Text("KARASUNO")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)

                // 比數區塊（固定寬度與單行顯示，徹底避免折行問題）
                VStack(spacing: 3) {
                    Text(match.score)
                        .font(.system(size: 26, weight: .black, design: .rounded))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)

                    Text("局數 (SETS)")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.secondary)
                }
                .frame(width: 88)
                .padding(.vertical, 6)
                .background(Color(UIColor.tertiarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                // 對手學校
                VStack(spacing: 3) {
                    Text(match.opponentSchool)
                        .font(.headline.bold())
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    Text(match.opponentRomaji)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 4)

            Divider()

            // 決勝精彩回顧
            (Text("決勝時刻：")
                .font(.caption.bold())
                .foregroundColor(.orange)
            + Text(match.highlightSummary)
                .font(.caption)
                .foregroundColor(.secondary))
            .lineSpacing(2)
        }
        .haikyuuCard()
    }
}
