import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - 自訂 ViewModifier 與 View Extension

/// 自訂卡片樣式 ViewModifier：統一 App 內所有資訊卡片的背景、圓角、陰影與邊框效果
/// 支援 iPhone / iPad 與 Dark / Light Mode（採用系統動態背景顏色）
struct HaikyuuCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 18
    var borderColor: Color = Color.primary.opacity(0.08)
    var borderWidth: CGFloat = 1
    var shadowRadius: CGFloat = 8

    func body(content: Content) -> some View {
        content
            .padding()
            #if canImport(UIKit)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            #else
            .background(Color.secondary.opacity(0.1))
            #endif
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .shadow(color: Color.black.opacity(0.06), radius: shadowRadius, x: 0, y: 4)
    }
}

/// 生動圖片樣式 ViewModifier：套用對比度、飽和度、陰影與圓角組合
struct VibrantImageModifier: ViewModifier {
    var cornerRadius: CGFloat = 14
    var contrastValue: Double = 1.08
    var saturationValue: Double = 1.15
    var shadowRadius: CGFloat = 6

    func body(content: Content) -> some View {
        content
            .contrast(contrastValue)
            .saturation(saturationValue)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: Color.black.opacity(0.15), radius: shadowRadius, x: 0, y: 3)
    }
}

/// 標籤膠囊樣式 ViewModifier
struct BadgeCapsuleModifier: ViewModifier {
    var backgroundColor: Color
    var foregroundColor: Color = .white

    func body(content: Content) -> some View {
        content
            .font(.caption.bold())
            .foregroundColor(foregroundColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(backgroundColor.gradient)
            .clipShape(Capsule())
    }
}

// MARK: - View Extension 方便鏈式調用
extension View {
    /// 套用排球少年主題卡片樣式
    func haikyuuCard(
        cornerRadius: CGFloat = 18,
        borderColor: Color = Color.primary.opacity(0.08),
        borderWidth: CGFloat = 1,
        shadowRadius: CGFloat = 8
    ) -> some View {
        modifier(HaikyuuCardModifier(
            cornerRadius: cornerRadius,
            borderColor: borderColor,
            borderWidth: borderWidth,
            shadowRadius: shadowRadius
        ))
    }

    /// 套用生動圖片處理樣式
    func vibrantImageStyle(
        cornerRadius: CGFloat = 14,
        contrast: Double = 1.08,
        saturation: Double = 1.15,
        shadowRadius: CGFloat = 6
    ) -> some View {
        modifier(VibrantImageModifier(
            cornerRadius: cornerRadius,
            contrastValue: contrast,
            saturationValue: saturation,
            shadowRadius: shadowRadius
        ))
    }

    /// 套用膠囊標籤樣式
    func badgeCapsule(backgroundColor: Color, foregroundColor: Color = .white) -> some View {
        modifier(BadgeCapsuleModifier(backgroundColor: backgroundColor, foregroundColor: foregroundColor))
    }
}
