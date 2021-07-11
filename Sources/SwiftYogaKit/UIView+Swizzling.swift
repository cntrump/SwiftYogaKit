/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#if os(macOS)
import AppKit
typealias UIView = NSView
typealias UIControl = NSControl
#else
import UIKit
#endif

import ObjectiveC.runtime
import Yoga

private func YogaSwizzleInstanceMethod(_ cls: AnyClass, _ originalSelector: Selector, _ swizzledSelector: Selector) {
    guard let originalMethod = class_getInstanceMethod(cls, originalSelector),
          let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector) else {
        return
    }

    let swizzledIMP = method_getImplementation(swizzledMethod)
    if class_addMethod(cls, originalSelector, swizzledIMP, method_getTypeEncoding(swizzledMethod)) {
        class_replaceMethod(cls,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod))
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}

private var kYGYogaMaxLayoutWidthAssociatedKey: UInt8 = 0

extension UIView {

    @objc public class func SwiftYogaKitSwizzle() {
        struct once {
            static let token = { () -> Bool in
                YogaSwizzleInstanceMethod(UIView.self, #selector(UIView.init(frame:)), #selector(_swift_yoga_init(frame:)))
                YogaSwizzleInstanceMethod(UIView.self, #selector(setter: UIView.frame), #selector(_swift_yoga_set(frame:)))
                YogaSwizzleInstanceMethod(UIView.self, #selector(setter: UIView.bounds), #selector(_swift_yoga_set(bounds:)))
                YogaSwizzleInstanceMethod(UIView.self, #selector(getter: UIView.intrinsicContentSize), #selector(getter: _swift_yoga_intrinsicContentSize))
                #if os(macOS)
                YogaSwizzleInstanceMethod(NSView.self, #selector(NSView.setFrameSize(_:)), #selector(_swift_yoga_set(frameSize:)))
                YogaSwizzleInstanceMethod(NSView.self, #selector(NSView.setBoundsSize(_:)), #selector(_swift_yoga_set(boundsSize:)))
                #endif

                return true
            }()
        }

        _ = once.token
    }

    var _swift_yoga_maxLayoutWidth: CGFloat {
        get {
            guard let value = objc_getAssociatedObject(self, &kYGYogaMaxLayoutWidthAssociatedKey) as? NSNumber else {
                return .nan
            }

            return CGFloat(value.doubleValue)
        }

        set {
            var value = newValue
            if value < 0 {
                value = .nan
            }

            objc_setAssociatedObject(self, &kYGYogaMaxLayoutWidthAssociatedKey, NSNumber(value: Double(value)), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc dynamic func _swift_yoga_init(frame: CGRect) -> Any? {
        let instance = _swift_yoga_init(frame: frame)
        _swift_yoga_apply_layout()

        return instance
    }

    @objc dynamic func _swift_yoga_set(frame: CGRect) {
        _swift_yoga_set(frame: frame)
        _swift_yoga_apply_layout()

        #if os(macOS)
        _swift_yoga_updateConstraintsIfNeeded(frame.width)
        #endif
    }

    @objc dynamic func _swift_yoga_set(bounds: CGRect) {
        _swift_yoga_set(bounds: bounds)
        _swift_yoga_apply_layout()
        _swift_yoga_updateConstraintsIfNeeded(bounds.width)
    }

    @objc dynamic var _swift_yoga_intrinsicContentSize: CGSize {
        var size = self._swift_yoga_intrinsicContentSize

        #if os(macOS)
        guard !_swift_yoga_isFittingSize else {
            return size
        }
        #endif

        guard isYogaEnabled else {
            return size
        }

        let yoga = self.yoga
        if yoga.isIncludedInLayout {
            var maxWidth = self._swift_yoga_maxLayoutWidth
            if maxWidth == 0 {
                maxWidth = .nan
            }

            size = yoga.calculateLayout(size: CGSize(width: maxWidth, height: .nan))
            self._swift_yoga_maxLayoutWidth = size.width
        }

        return size
    }

    #if os(macOS)
    @objc dynamic func _swift_yoga_set(frameSize: NSSize) {
        _swift_yoga_set(frameSize: frameSize)
        _swift_yoga_apply_layout()
        _swift_yoga_updateConstraintsIfNeeded(frameSize.width)
    }

    @objc dynamic func _swift_yoga_set(boundsSize: NSSize) {
        _swift_yoga_set(boundsSize: boundsSize)
        _swift_yoga_apply_layout()
        _swift_yoga_updateConstraintsIfNeeded(boundsSize.width)
    }
    #endif

    func _swift_yoga_apply_layout() {
        guard isYogaEnabled else {
            return
        }

        let yoga = self.yoga
        if yoga.isIncludedInLayout {
            yoga.applyLayout(preservingOrigin: true)
        }
    }

    func _swift_yoga_updateConstraintsIfNeeded(_ width: CGFloat) {
        guard isYogaEnabled, _swift_yoga_isAutoLayoutEnabled else {
            return
        }

        let maxWidth = self._swift_yoga_maxLayoutWidth
        if maxWidth != width {
            self._swift_yoga_maxLayoutWidth = width
            invalidateIntrinsicContentSize()
            #if !os(macOS)
            superview?.layoutIfNeeded()
            #endif
        }
    }

    var _swift_yoga_isAutoLayoutEnabled: Bool {
        if translatesAutoresizingMaskIntoConstraints {
            return false
        }
        
        for constraint in constraints {
            if #available(macOS 10.10, iOS 8.0, tvOS 8.0, *) {
                if constraint.isActive {
                    return true
                }
            } else {
                return true
            }
        }

        return false
    }
}
