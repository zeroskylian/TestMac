// swiftlint:disable all
// NSViewExtensions.swift - Copyright 2020 SwifterSwift

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

// MARK: - Properties

public extension NSView {
    /// SwifterSwift: Border color of view; also inspectable from Storyboard.
    @IBInspectable
    var borderColor: NSColor? {
        get {
            guard let color = layer?.borderColor else { return nil }
            return NSColor(cgColor: color)
        }
        set {
            wantsLayer = true
            layer?.borderColor = newValue?.cgColor
        }
    }
    
    /// SwifterSwift: Border width of view; also inspectable from Storyboard.
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer?.borderWidth ?? 0
        }
        set {
            wantsLayer = true
            layer?.borderWidth = newValue
        }
    }
    
    /// SwifterSwift: Corner radius of view; also inspectable from Storyboard.
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer?.cornerRadius ?? 0
        }
        set {
            wantsLayer = true
            layer?.masksToBounds = true
            layer?.cornerRadius = newValue.magnitude
        }
    }
    
    // SwifterSwift: Height of view.
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    /// SwifterSwift: Shadow color of view; also inspectable from Storyboard.
    @IBInspectable
    var shadowColor: NSColor? {
        get {
            guard let color = layer?.shadowColor else { return nil }
            return NSColor(cgColor: color)
        }
        set {
            wantsLayer = true
            layer?.shadowColor = newValue?.cgColor
        }
    }
    
    /// SwifterSwift: Shadow offset of view; also inspectable from Storyboard.
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer?.shadowOffset ?? CGSize.zero
        }
        set {
            wantsLayer = true
            layer?.shadowOffset = newValue
        }
    }
    
    /// SwifterSwift: Shadow opacity of view; also inspectable from Storyboard.
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer?.shadowOpacity ?? 0
        }
        set {
            wantsLayer = true
            layer?.shadowOpacity = newValue
        }
    }
    
    /// SwifterSwift: Shadow radius of view; also inspectable from Storyboard.
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer?.shadowRadius ?? 0
        }
        set {
            wantsLayer = true
            layer?.shadowRadius = newValue
        }
    }
    
    /// SwifterSwift: Background color of the view; also inspectable from Storyboard.
    @IBInspectable
    var layerBackgroundColor: NSColor? {
        get {
            if let colorRef = layer?.backgroundColor {
                return NSColor(cgColor: colorRef)
            } else {
                return nil
            }
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }
    
    /// SwifterSwift: Size of view.
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }
    
    /// SwifterSwift: Width of view.
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    var center: CGPoint {
        set {
            let rect = CGRect(origin: CGPoint(x: newValue.x - frame.width / 2.0, y: newValue.y - frame.height / 2.0), size: frame.size)
            frame = rect
        }
        get {
            CGPoint(x: frame.origin.x + frame.width / 2.0, y: frame.origin.y + frame.height / 2.0)
        }
    }
}

// MARK: - Methods

public extension NSView {
    /// SwifterSwift: Add array of subviews to view.
    ///
    /// - Parameter subviews: array of subviews to add to self.
    func addSubviews(_ subviews: [NSView]) {
        subviews.forEach { addSubview($0) }
    }
    
    /// SwifterSwift: Remove all subviews in view.
    func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}

#endif

private var AssociatedObjectHandle: UInt8 = 0
// MARK: - MMLayout
extension NSView {
    
    private struct AssociatedKeys {
        static var mm = "mm"
    }
    
    var mm: FrameViewDSL {
        get {
            var mm = objc_getAssociatedObject(self, &AssociatedKeys.mm) as? FrameViewDSL
            if mm == nil {
                mm = FrameViewDSL(view: self)
                objc_setAssociatedObject(self, &AssociatedKeys.mm, mm, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return mm!
        }
    }
}

#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif
import ObjectiveC.runtime

#if os(iOS) || os(tvOS)
public typealias FrameView = UIView
public typealias EdgeInsets = UIEdgeInsets
#else
public typealias FrameView = NSView
public typealias EdgeInsets = NSEdgeInsets
#endif

class FrameViewDSL {
    internal let view: FrameView
    
    init(view: FrameView) {
        self.view = view
    }
    
    var x: CGFloat {
        get {
            return view.frame.origin.x
        }
        set {
            var frame = view.frame
            frame.origin.x = newValue
            view.frame = frame
        }
    }
    
    var y: CGFloat {
        get {
            return view.frame.origin.y
        }
        set {
            var frame = view.frame
            frame.origin.y = newValue
            view.frame = frame
        }
    }
    
    var width: CGFloat {
        get {
            return view.frame.width
        }
        set {
            var frame = view.frame
            frame.size.width = newValue
            view.frame = frame
        }
    }
    
    var height: CGFloat {
        get {
            return view.frame.height
        }
        set {
            var frame = view.frame
            frame.size.height = newValue
            view.frame = frame
        }
    }
    
    var size: CGSize {
        get {
            return view.frame.size
        }
        set {
            var frame = view.frame
            frame.size = newValue
            view.frame = frame
        }
    }
    
    var centerX: CGFloat {
        get {
            return view.center.x
        }
        set {
            var center = view.center
            center.x = newValue
            view.center = center
        }
    }
    
    var centerY: CGFloat {
        get {
            return view.center.y
        }
        set {
            var center = view.center
            center.y = newValue
            view.center = center
        }
    }
    
    var maxX: CGFloat {
        return view.frame.maxX
    }
    
    var minX: CGFloat {
        return view.frame.minX
    }
    
    var maxY: CGFloat {
        return view.frame.maxY
    }
    
    var minY: CGFloat {
        return view.frame.minY
    }
    
    
    var top: CGFloat {
        get {
            return y
        }
        set {
            y = newValue
        }
    }
    
    var left: CGFloat {
        get {
            return x
        }
        set {
            x = newValue
        }
    }
    
    var right: CGFloat {
        get {
            assert(view.superview != nil, "must add subview first")
            return view.superview!.mm.width - view.mm.maxX
        }
        set {
            view.mm.x += view.mm.right - newValue
        }
    }
    
    var bottom: CGFloat {
        get {
            assert(view.superview != nil, "must add subview first")
            return view.superview!.mm.height - view.mm.maxY
        }
        set {
            view.mm.y += view.mm.bottom - newValue
        }
    }
    
    // MARK: - chain
    @discardableResult
    func top(_ value: CGFloat) -> Self {
        view.mm.y = value
        return self
    }
    
    @discardableResult
    func bottom(_ value: CGFloat) -> Self {
        view.mm.bottom = value
        return self
    }
    
    @discardableResult
    func flexToBottom(_ value: CGFloat) -> Self {
        view.mm.height += view.mm.bottom - value
        return self
    }
    
    @discardableResult
    func left(_ value: CGFloat) -> Self {
        view.mm.x = value
        return self
    }
    
    @discardableResult
    func right(_ value: CGFloat) -> Self {
        view.mm.right  = value
        return self
    }
    
    @discardableResult
    func flexToRight(_ value: CGFloat) -> Self {
        view.mm.width += view.mm.right - value
        return self
    }
    
    @discardableResult
    func width(_ value: CGFloat) -> Self {
        view.mm.width = value
        return self
    }
    
    @discardableResult
    func height(_ value: CGFloat) -> Self {
        view.mm.height = value
        return self
    }
    
    @discardableResult
    func size(_ value: CGSize) -> Self {
        view.mm.size = value
        return self
    }
    
    @discardableResult
    func centerX(_ value: CGFloat) -> Self {
        view.mm.centerX = value
        return self
    }
    
    @discardableResult
    func centerY(_ value: CGFloat) -> Self {
        view.mm.centerY = value
        return self
    }
    
    @discardableResult
    func center() -> Self {
        if let superView = view.superview {
            view.mm.centerX = superView.mm.width / 2.0
            view.mm.centerY = superView.mm.height / 2.0
        }
        return self
    }
    
    @discardableResult
    func fill(inset: EdgeInsets) -> Self {
        if let superView = view.superview {
            view.mm.x = 0 + inset.left
            view.mm.y = 0 + inset.top
            view.mm.width = superView.mm.width - inset.left - inset.right
            view.mm.height = superView.mm.height - inset.top - inset.bottom
        }
        return self
    }
}

protocol NibLoadable {
    // Name of the nib file
    static var nibName: String { get }
    static func createFromNib(in bundle: Bundle) -> Self
}

extension NibLoadable where Self: NSView {
    
    // Default nib name must be same as class name
    static var nibName: String {
        return String(describing: Self.self)
    }
    
    static func createFromNib(in bundle: Bundle = Bundle.main) -> Self {
        var topLevelArray: NSArray?
        bundle.loadNibNamed(NSNib.Name(nibName), owner: self, topLevelObjects: &topLevelArray)
        let views = [Any](topLevelArray!).filter { $0 is Self }
        return views.last as! Self
    }
}
