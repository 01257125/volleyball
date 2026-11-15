import SwiftUI
#if canImport(SafariServices) && canImport(UIKit)
import SafariServices
import UIKit
#endif
#if canImport(WebKit) && canImport(UIKit)
import WebKit
#endif

// MARK: - SafariView (SFSafariViewController)
/// 使用 UIViewControllerRepresentable 封裝 SFSafariViewController
/// 供使用者在 App 內部直接安全、完整地瀏覽角色的維基百科官方頁面
#if canImport(SafariServices) && canImport(UIKit)
struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = false
        configuration.barCollapsingEnabled = true

        let safariVC = SFSafariViewController(url: url, configuration: configuration)
        safariVC.dismissButtonStyle = .close
        return safariVC
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // 不需要動態更新
    }
}
#else
struct SafariView: View {
    let url: URL
    var body: some View {
        Link("在瀏覽器中開啟：\(url.absoluteString)", destination: url)
    }
}
#endif

// MARK: - WebView (WKWebView)
/// 封裝 WebKit WKWebView 符合作業顯示網頁之需求
#if canImport(WebKit) && canImport(UIKit)
struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
#endif
