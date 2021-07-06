/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#if os(macOS)
import AppKit
#else
import UIKit
#endif

import Yoga

func YGScaleFactor() -> Double {
    struct once {
        #if os(macOS)
        static let scaleFactor = NSScreen.main?.backingScaleFactor ?? 1
        #else
        static let scaleFactor = UIScreen.main.scale
        #endif
    }

    return Double(once.scaleFactor)
}

func YGGlobalConfig() -> YGConfigRef {
    struct once {
        static let config: YGConfigRef = {
            let config = YGConfigNew()
            YGConfigSetExperimentalFeatureEnabled(config, .webFlexBasis, true)
            YGConfigSetPointScaleFactor(config, YGScaleFactor())
            
            return config!
        }()
    }

    return once.config
}

@inline(__always) func YGSanitizeMeasurement(_ constrainedSize: CGFloat, _ measuredSize: CGFloat, _ measureMode: YGMeasureMode) -> CGFloat {
    var result: CGFloat

    switch measureMode {
    case .exactly:
        result = constrainedSize
    case .atMost:
        result = min(constrainedSize, measuredSize)
    default:
        result = measuredSize
    }

    return max(result, 0)
}

func YGMeasureView(_ node: YGNodeRef!, _ width: Double, _ widthMode: YGMeasureMode, _ height: Double, _ heightMode: YGMeasureMode) -> YGSize {
    let constrainedWidth: CGFloat = (widthMode == YGMeasureMode.undefined) ? .greatestFiniteMagnitude : CGFloat(width)
    let constrainedHeight: CGFloat = (heightMode == YGMeasureMode.undefined) ? .greatestFiniteMagnitude : CGFloat(height)

    let view = Unmanaged<UIView>.fromOpaque(node.context!).takeUnretainedValue()
    let yoga = view.yoga
    
    guard !yoga.isBaseView else {
        return YGSize(width: 0, height: 0)
    }

    #if os(macOS)
    let fittingSize = view.fittingSize
    let sizeThatFits = CGSize(width: min(fittingSize.width, constrainedWidth), height: min(fittingSize.height, constrainedHeight))
    #else
    let sizeThatFits = view.sizeThatFits(CGSize(width: constrainedWidth, height: constrainedHeight))
    #endif

    let w = YGSanitizeMeasurement(constrainedWidth, sizeThatFits.width, widthMode)
    let h = YGSanitizeMeasurement(constrainedHeight, sizeThatFits.height, heightMode)

    return YGSize(width: Double(w), height: Double(h))
}

@inline(__always) func YGNodeHasExactSameChildren(_ node: YGNodeRef, _ subviews: [UIView]) -> Bool {
    let count = subviews.count
    guard node.childCount == count else {
        return false
    }

    for i in 0 ..< count {
        let yoga = subviews[i].yoga
        guard node.getChild(i)?.hashValue == yoga.node.hashValue else {
            return false
        }
    }

    return true
}

func YGAttachNodesFromViewHierachy(_ view: UIView) {
    let yoga = view.yoga
    let node = yoga.node

    guard !yoga.isLeaf else {
        node.removeAllChildren()
        node.setMeasureFunc(YGMeasureView)

        return
    }

    node.setMeasureFunc(nil)

    let subviewsToInclude = view.subviews.filter { $0.isYogaEnabled && $0.yoga.isIncludedInLayout }

    if !YGNodeHasExactSameChildren(node, subviewsToInclude) {
        node.removeAllChildren()

        for i in 0 ..< subviewsToInclude.count {
            node.insertChild(subviewsToInclude[i].yoga.node, at: i)
        }
    }

    subviewsToInclude.forEach { YGAttachNodesFromViewHierachy($0) }
}

func YGApplyLayoutToViewHierarchy(_ view: UIView, _ preserveOrigin: Bool) {
    assert(Thread.isMainThread, "Framesetting should only be done on the main thread.")

    let yoga = view.yoga
    guard !yoga.isApplingLayout, yoga.isIncludedInLayout else {
        return
    }

    yoga.isApplingLayout = true

    // layout leaf node first
    if !yoga.isLeaf {
        for subview in view.subviews {
            guard subview.isYogaEnabled else {
                continue
            }

            let yoga = subview.yoga
            if yoga.isIncludedInLayout {
                YGApplyLayoutToViewHierarchy(subview, false)
            }
        }
    }
    
    let node = yoga.node
    let topLeft = CGPoint(x: CGFloat(node.left), y: CGFloat(node.top))
    let size = CGSize(width: CGFloat(node.width), height: CGFloat(node.height))
    var origin = CGPoint.zero

    #if os(macOS)
    if preserveOrigin {
        origin = view.frame.origin
    }
    #else
    let transformIsIdentity = view.transform.isIdentity

    if preserveOrigin {
        origin = transformIsIdentity ? view.frame.origin : CGPoint(x: view.center.x - view.bounds.width * 0.5,
                                                                   y: view.center.y - view.bounds.height * 0.5)
    }
    #endif

    var frame = CGRect(origin: origin, size: size).offsetBy(dx: topLeft.x, dy: topLeft.y)

    #if os(macOS)
    if let superview = view.superview, !superview.isFlipped, superview.isYogaEnabled {
        let yoga = superview.yoga
        if yoga.isIncludedInLayout {
            let height = max(CGFloat(yoga.node.height), 0)
            frame.origin.y = height - frame.maxY
        }
    }

    view.frame = frame
    #else
    if transformIsIdentity {
        view.frame = frame
    } else {
        var bounds  = view.bounds
        bounds.size = size
        view.bounds = bounds
        view.center = CGPoint(x: frame.midX, y: frame.midY)
    }
    #endif

    yoga.isApplingLayout = false
}
