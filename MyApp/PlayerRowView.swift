import SwiftUI

// MARK: - 球員列表列元件 (PlayerRowView)
/// 負責呈現 List 內每一位球員的概要資訊
struct PlayerRowView: View {
    let player: Player

    var body: some View {
        HStack(spacing: 14) {
            // 球員頭像
            AsyncImage(url: URL(string: player.avatarURL)) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.secondary.opacity(0.12))
                        ProgressView()
                    }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 72)
                        .clipped()
                        .contrast(1.08)
                        .saturation(1.15)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .shadow(color: player.school.themeColor.opacity(0.25), radius: 4, x: 0, y: 2)
                case .failure:
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(player.school.themeColor.opacity(0.15))
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .font(.title2)
                            .foregroundColor(player.school.themeColor)
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 72, height: 72)

            VStack(alignment: .leading, spacing: 6) {
                // 背號與姓名
                (Text("#\(player.number) ")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(player.school.themeColor)
                + Text(player.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                + Text(" (\(player.position.shortName))")
                    .font(.caption)
                    .foregroundColor(.secondary))

                // 學校名稱與吉祥物
                (Text(player.school.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                + Text(" ・ ")
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.6))
                + Text(player.school.mascot)
                    .font(.caption))

                // 標語徽章
                Text(player.school.motto)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(player.school.themeColor.opacity(0.12))
                    .foregroundColor(player.school.themeColor)
                    .clipShape(Capsule())
            }

            Spacer(minLength: 4)
        }
        .padding(.vertical, 4)
    }
}
