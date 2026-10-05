import SwiftUI
import WebKit

@main struct ReceptaMedApp: App {
    var body: some Scene { WindowGroup { ReceptaScreen().ignoresSafeArea() } }
}
struct ReceptaScreen: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ReceptaController { ReceptaController() }
    func updateUIViewController(_ controller: ReceptaController, context: Context) {}
}
final class ReceptaController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    private let host = "agendaflow-central-demo.vini-saccomani.chatgpt.site"
    private let home = URL(string: "https://agendaflow-central-demo.vini-saccomani.chatgpt.site/app")!
    private var web: WKWebView!
    private let message = UILabel()
    private var privacyCover: UIView?
    private func inside(_ url: URL) -> Bool { url.scheme == "https" && url.host == host && (url.port == nil || url.port == 443) }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        NotificationCenter.default.addObserver(self, selector: #selector(concealContent), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(revealContent), name: UIApplication.didBecomeActiveNotification, object: nil)
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        web = WKWebView(frame: .zero, configuration: config)
        web.navigationDelegate = self
        web.uiDelegate = self
        web.allowsBackForwardNavigationGestures = true
        message.text = "Sem conexão. Confira a internet e toque aqui para tentar novamente."
        message.isUserInteractionEnabled = true
        message.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reload)))
        message.accessibilityTraits = .button
        message.font = .preferredFont(forTextStyle: .body)
        message.numberOfLines = 0; message.isHidden = true
        let stack = UIStackView(arrangedSubviews: [message, web])
        stack.axis = .vertical; stack.spacing = 0; stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        web.load(URLRequest(url: home, cachePolicy: .reloadIgnoringLocalCacheData))
    }
    // Avoid patient details in the app switcher snapshot.
    @objc private func concealContent() {
        guard privacyCover == nil else { return }
        let cover = UIView(frame: view.bounds)
        cover.backgroundColor = .systemBackground
        cover.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let label = UILabel()
        label.text = "ReceptaMed"
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        cover.addSubview(label)
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: cover.centerXAnchor), label.centerYAnchor.constraint(equalTo: cover.centerYAnchor)])
        view.addSubview(cover)
        privacyCover = cover
    }
    @objc private func revealContent() { privacyCover?.removeFromSuperview(); privacyCover = nil }
    deinit { NotificationCenter.default.removeObserver(self) }
    @objc private func reload() { message.isHidden = true; web.reload() }
    private func external(_ url: URL) { if ["https", "tel", "mailto"].contains(url.scheme ?? "") { UIApplication.shared.open(url) } }
    func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = action.request.url else { decisionHandler(.cancel); return }
        if inside(url) { decisionHandler(.allow) }
        else { if action.targetFrame?.isMainFrame != false { external(url) }; decisionHandler(.cancel) }
    }
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let url = action.request.url { if inside(url) { web.load(action.request) } else { external(url) } }
        return nil
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) { if (error as NSError).code != NSURLErrorCancelled { message.isHidden = false } }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) { if (error as NSError).code != NSURLErrorCancelled { message.isHidden = false } }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { message.isHidden = true }
}
