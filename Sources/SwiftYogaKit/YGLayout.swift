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

public struct YGDimensionFlexibility: OptionSet {

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let width = YGDimensionFlexibility(rawValue: 1 << 0)

    public static let height = YGDimensionFlexibility(rawValue: 1 << 1)
}

final public class YGLayout {

    public var isIncludedInLayout = true

    public var isDirty: Bool {
        get {
            return node.isDirty
        }
    }

    public var isLeaf: Bool {
        get {
            assert(Thread.isMainThread, "This method must be called on the main thread.")

            guard isIncludedInLayout else {
                return true
            }

            for subview in view.subviews {
                if !subview.isYogaEnabled {
                    continue
                }

                let yoga = subview.yoga
                if yoga.isIncludedInLayout {
                    return false
                }
            }

            return true
        }
    }

    public var numberOfChildren: UInt {
        get {
            return node.childCount
        }
    }

    public var resolvedDirection: YGDirection {
        get {
            return node.direction
        }
    }

    public var intrinsicSize: CGSize {
        get {
            return calculateLayout(size: CGSize(width: CGFloat.nan, height: CGFloat.nan))
        }
    }

    var isBaseView = true
    var isApplingLayout = false

    private(set) var node: YGNodeRef
    private var view: UIView

    var rootYogaView: UIView? {
        var node: UIView? = self.view

        while node != nil {
            guard let parent = node?.superview, parent.isYogaEnabled, parent.yoga.isIncludedInLayout else {
                break
            }

            node = parent
        }

        return node
    }

    deinit {
        YGNodeFree(node)
    }

    init(view: UIView) {
        self.view = view
        isBaseView = view.isMember(of: UIView.self) || view.isMember(of: UIControl.self)
        node = YGNodeNewWithConfig(YGGlobalConfig())
        node.context = UnsafeRawPointer(Unmanaged<UIView>.passUnretained(self.view).toOpaque())
    }

    public func markDirty() {
        guard isIncludedInLayout, isLeaf else {
            return
        }

        if !node.hasMeasureFunc {
            node.setMeasureFunc(YGMeasureView)
        }

        node.markDirty()

        guard let view = self.rootYogaView else {
            return
        }

        if view._swift_yoga_isAutoLayoutEnabled {
            view._swift_yoga_maxLayoutWidth = .nan
            view.invalidateIntrinsicContentSize()
            #if !os(macOS)
            view.superview?.layoutIfNeeded()
            #endif
        }
    }

    public func applyLayout() {
        applyLayout(preservingOrigin: false)
    }

    public func applyLayout(preservingOrigin preserveOrigin: Bool) {
        applyLayout(preservingOrigin: preserveOrigin, dimensionFlexibility: [])
    }

    public func applyLayout(preservingOrigin preserveOrigin: Bool, dimensionFlexibility: YGDimensionFlexibility) {
        guard !isApplingLayout, isIncludedInLayout else {
            return
        }

        var size = view.bounds.size

        if dimensionFlexibility.contains(.width) {
            size.width = .nan
        }

        if dimensionFlexibility.contains(.height) {
            size.height = .nan
        }

        _ = calculateLayout(size: size)
        YGApplyLayoutToViewHierarchy(view, preserveOrigin)
    }

    public func calculateLayout(size: CGSize) -> CGSize {
        assert(Thread.isMainThread, "Yoga calculation must be done on main.")
        assert(isIncludedInLayout, "Yoga is not enabled for this view.")

        YGAttachNodesFromViewHierachy(view)
        YGNodeCalculateLayout(node, Double(size.width), Double(size.height), YGNodeStyleGetDirection(node))

        return CGSize(width: node.width, height: node.height)
    }

    @inlinable public func configureLayout(block: ((YGLayout) -> Void)?) {
        block?(self)
    }
}

extension YGNodeRef {

    @inlinable var context: UnsafeRawPointer? {
        get {
            return YGNodeGetContext(self)
        }

        set {
            YGNodeSetContext(self, newValue)
        }
    }

    @inlinable var childCount: UInt {
        get {
            return UInt(YGNodeGetChildCount(self))
        }
    }

    @inlinable func getChild(_ index: Int) -> YGNodeRef? {
        return YGNodeGetChild(self, UInt32(index))
    }

    @inlinable func removeAllChildren() {
        YGNodeRemoveAllChildren(self)
    }

    @inlinable var hasMeasureFunc: Bool {
        get {
            return YGNodeHasMeasureFunc(self)
        }
    }

    @inlinable func setMeasureFunc(_ fn: YGMeasureFunc?) {
        YGNodeSetMeasureFunc(self, fn)
    }

    @inlinable func insertChild(_ node: YGNodeRef, at index: Int) {
        YGNodeInsertChild(self, node, UInt32(index))
    }

    @inlinable var isDirty: Bool {
        get {
            return YGNodeIsDirty(self)
        }
    }

    @inlinable func markDirty() {
        YGNodeMarkDirty(self)
    }

    @inlinable var direction: YGDirection {
        get {
            return YGNodeLayoutGetDirection(self)
        }
    }

    @inlinable var top: CGFloat {
        get {
            let top = CGFloat(YGNodeLayoutGetTop(self))
            return top.isInfinite || top.isNaN ? 0 : top
        }
    }

    @inlinable var left: CGFloat {
        get {
            let left = CGFloat(YGNodeLayoutGetLeft(self))
            return left.isInfinite || left.isNaN ? 0 : left
        }
    }

    @inlinable var width: CGFloat {
        get {
            let width = CGFloat(YGNodeLayoutGetWidth(self))
            return width.isInfinite || width.isNaN ? 0 : max(width, 0)
        }
    }

    @inlinable var height: CGFloat {
        get {
            let height = CGFloat(YGNodeLayoutGetHeight(self))
            return height.isInfinite || height.isNaN ? 0 : max(height, 0)
        }
    }
}
