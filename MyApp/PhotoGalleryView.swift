import SwiftUI

// MARK: - 經典劇照頁面 (PhotoGalleryView)
/// 使用 LazyVGrid 實現格子狀排列的劇照牆
/// 點選圖片可放大檢視，支援春季動畫與過渡效果
struct PhotoGalleryView: View {
    private let photos = MockData.galleryPhotos

    // 雙欄均分網格，每張卡片尺寸一致且整齊
    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    // 點選放大預覽的圖片
    @State private var selectedPhoto: GalleryPhoto? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(photos) { photo in
                            galleryItemView(for: photo)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                        selectedPhoto = photo
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                }

                // 大圖彈出覆蓋層 (LightBox Overlay)
                if let photo = selectedPhoto {
                    fullScreenOverlay(for: photo)
                }
            }
            .navigationTitle("經典劇照")
        }
    }

    // MARK: - 格子內的單張圖片元件
    private func galleryItemView(for photo: GalleryPhoto) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                Color(UIColor.secondarySystemFill)

                AsyncImage(url: URL(string: photo.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            .frame(height: 140)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(photo.title)
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text(photo.subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 4)
        }
        .padding(8)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 5, x: 0, y: 2)
    }

    // MARK: - 大圖檢視覆蓋層
    private func fullScreenOverlay(for photo: GalleryPhoto) -> some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        selectedPhoto = nil
                    }
                }

            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            selectedPhoto = nil
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.85))
                    }
                }
                .padding(.horizontal)

                AsyncImage(url: URL(string: photo.imageURL)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(radius: 20)
                    } else {
                        ProgressView()
                            .tint(.white)
                    }
                }
                .frame(maxHeight: 460)
                .padding(.horizontal)

                VStack(spacing: 6) {
                    Text(photo.title)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    Text(photo.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding()
            .transition(.scale(scale: 0.95).combined(with: .opacity))
        }
    }
}
