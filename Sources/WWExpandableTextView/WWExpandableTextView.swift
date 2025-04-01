//
//  WWExpandableTextView.swift
//  Example
//
//  Created by William.Weng on 2025/4/1.
//

import UIKit

// MARK: - 可限制行數的UITextView
open class WWExpandableTextView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var minHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var maxHeightConstraint: NSLayoutConstraint!
    
    public override var intrinsicContentSize: CGSize { return textViewIntrinsicContentSize(textView) }
    
    public var text: String? {
        set { textView.text = newValue }
        get { return textView.text }
    }
    
    private let minPointSize: CGFloat = 12.0
    
    private var lines: CGFloat = 3.0
    private var gap: CGFloat = 12.0
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initSetting()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetting()
    }
}

// MARK: - UITextViewDelegate
extension WWExpandableTextView: UITextViewDelegate {}
public extension WWExpandableTextView {
    func textViewDidChange(_ textView: UITextView) { updateTextViewHeight(textView) }
}

// MARK: - 公開函式
public extension WWExpandableTextView {
    
    /// [參數設定](https://medium.com/jeremy-xue-s-blog/swift-認識-intrinsic-content-size-content-hugging-content-compression-4b76b8969dcc)
    /// - Parameters:
    ///   - delegate: UITextViewDelegate?
    ///   - tag: Int
    ///   - lines: CGFloat
    ///   - gap: CGFloat
    func configure(delegate: UITextViewDelegate? = nil, tag: Int = 3939889, lines: CGFloat, gap: CGFloat) {
        textView.tag = tag
        textView.delegate = delegate
        updateConstraint(lines: lines, gap: gap)
    }
    
    /// [文字框相關設定](https://juejin.cn/post/6844904106318888968)
    /// - Parameters:
    ///   - font: 字型
    ///   - backgroundColor: 背景顏色
    ///   - borderWidth: 框線寬度
    ///   - borderColor: 框線顏色
    ///   - cornerRadius: 外框圓角
    func setting(font: UIFont, backgroundColor: UIColor, borderWidth: CGFloat, borderColor: UIColor) {
        textViewSetting(font: font, backgroundColor: backgroundColor, borderWidth: borderWidth, borderColor: borderColor)
    }
    
    /// 更新高度
    func updateHeight() {
        updateTextViewHeight(textView)
    }
}

// MARK: - 小工具
private extension WWExpandableTextView {
    
    /// [初始化設定](https://blog.csdn.net/gang544043963/article/details/52440621)
    func initSetting() {
        initViewFromXib()
        textViewSetting()
        updateConstraint(lines: lines, gap: gap)
    }
    
    /// [讀取Nib畫面 => 加到View上面](https://blog.twjoin.com/ios-view-更新-從-setneedsdisplay-到-layoutsubviews-2e673359ccac)
    func initViewFromXib() {
        
        let bundle = Bundle.module
        let name = String(describing: WWExpandableTextView.self)
        
        bundle.loadNibNamed(name, owner: self, options: nil)
        contentView.frame = bounds
        
        addSubview(contentView)
    }
    
    /// [文字框相關設定](https://blog.csdn.net/thelittleboy/article/details/84023892)
    /// - Parameters:
    ///   - font: 字型
    ///   - backgroundColor: 背景顏色
    ///   - borderWidth: 框線寬度
    ///   - borderColor: 框線顏色
    ///   - cornerRadius: 外框圓角
    func textViewSetting(font: UIFont = .systemFont(ofSize: 12.0), backgroundColor: UIColor = .white, borderWidth: CGFloat = 0.5, borderColor: UIColor = .lightGray) {
        
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        
        textView.font = font
        textView.backgroundColor = backgroundColor
        textView.delegate = self
        
        updateTextViewHeight(textView)
    }
    
    /// [更新高度](https://juejin.cn/post/6953830851821961247)
    /// - Parameter textView: UITextView
    func updateTextViewHeight(_ textView: UITextView) {
        
        let greatestFiniteSize = CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude)
        let currentHeight = textView.sizeThatFits(greatestFiniteSize).height
        
        textView.isScrollEnabled = currentHeight > maxHeightConstraint.constant
        invalidateIntrinsicContentSize()
    }
    
    /// [更新高度限制 (最大 / 最小)](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/自動更新高度的-cell-ios-16-uikit-新功能-c2de7adfe34c)
    /// - Parameters:
    ///   - lines: 行數
    ///   - gap: 間隔
    func updateConstraint(lines: Double, gap: Double) {
        
        self.lines = lines
        self.gap = gap
        
        minHeightConstraint.constant = (textView.font?.pointSize ?? minPointSize) + gap
        maxHeightConstraint.constant = (textView.font?.pointSize ?? minPointSize) + gap * lines
        updateConstraintsIfNeeded()
    }
    
    /// [更新固有高度](https://blog.csdn.net/hard_man/article/details/50888377)
    /// - Parameter textView: UITextView
    /// - Returns: CGSize
    func textViewIntrinsicContentSize(_ textView: UITextView) -> CGSize {
        
        let textViewSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let height = max(min(textViewSize.height, maxHeightConstraint.constant), minHeightConstraint.constant)
        let size = CGSize(width: UIView.noIntrinsicMetric, height: height)
                
        return size
    }
}
