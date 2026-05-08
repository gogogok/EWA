//
//  YouTubeVideoView.swift
//  EWA
//
//  Created by Дарья Жданок on 6.05.26.
//

import UIKit
import WebKit

protocol YouTubeVideoViewDelegate: AnyObject {
    func youtubeVideoViewDidPlay(_ view: YouTubeVideoView, currentTime: Double)
    func youtubeVideoViewDidPause(_ view: YouTubeVideoView, currentTime: Double)
}

final class YouTubeVideoView: UIView, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {
    
    weak var delegate: YouTubeVideoViewDelegate?
    
    private var isApplyingRemoteEvent = false
    
    private lazy var webView: WKWebView = {
        let contentController = WKUserContentController()
        contentController.add(self, name: "playerEvent")
        
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true

        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        webView.backgroundColor = .black
        webView.scrollView.isScrollEnabled = false
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        return webView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .black
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func loadVideo(videoId: String) {
        guard let url = URL(string: "\(Environment.current.baseURL)/youtube/player?videoId=\(videoId)") else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue(Environment.current.baseURL, forHTTPHeaderField: "Referer")

        webView.load(request)
    }
    
    func playFromRemote() {
        isApplyingRemoteEvent = true
        webView.evaluateJavaScript("playVideo();") { [weak self] _, _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.isApplyingRemoteEvent = false
            }
        }
    }
    
    func pauseFromRemote() {
        isApplyingRemoteEvent = true
        webView.evaluateJavaScript("pauseVideo();") { [weak self] _, _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.isApplyingRemoteEvent = false
            }
        }
    }
    
    func seekFromRemote(to seconds: Double) {
        isApplyingRemoteEvent = true
        webView.evaluateJavaScript("seekVideo(\(seconds));") { [weak self] _, _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.isApplyingRemoteEvent = false
            }
        }
    }
    
    func getCurrentTime(completion: @escaping (Double) -> Void) {
        webView.evaluateJavaScript("getCurrentTime();") { result, _ in
            let time = result as? Double ?? 0
            completion(time)
        }
    }
    
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        
        return nil
    }
    
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        guard !isApplyingRemoteEvent else {
            return
        }
        
        guard let body = message.body as? [String: Any],
              let action = body["action"] as? String,
              let currentTime = body["currentTime"] as? Double
        else {
            return
        }
        
        if action == "play" {
            delegate?.youtubeVideoViewDidPlay(self, currentTime: currentTime)
        }
        
        if action == "pause" {
            delegate?.youtubeVideoViewDidPause(self, currentTime: currentTime)
        }
    }
}
