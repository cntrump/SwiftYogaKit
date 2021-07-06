/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import CoreGraphics
import Yoga

public extension YGLayout {

    var direction: YGDirection {
        get {
            return YGNodeStyleGetDirection(node)
        }

        set {
            YGNodeStyleSetDirection(node, newValue)
        }
    }

    var flexDirection: YGFlexDirection {
        get {
            return YGNodeStyleGetFlexDirection(node)
        }

        set {
            YGNodeStyleSetFlexDirection(node, newValue)
        }
    }

    var justifyContent: YGJustify {
        get {
            return YGNodeStyleGetJustifyContent(node)
        }

        set {
            YGNodeStyleSetJustifyContent(node, newValue)
        }
    }

    var alignContent: YGAlign {
        get {
            return YGNodeStyleGetAlignContent(node)
        }

        set {
            YGNodeStyleSetAlignContent(node, newValue)
        }
    }

    var alignItems: YGAlign {
        get {
            return YGNodeStyleGetAlignItems(node)
        }

        set {
            YGNodeStyleSetAlignItems(node, newValue)
        }
    }

    var alignSelf: YGAlign {
        get {
            return YGNodeStyleGetAlignSelf(node)
        }

        set {
            YGNodeStyleSetAlignSelf(node, newValue)
        }
    }

    var position: YGPositionType {
        get {
            return YGNodeStyleGetPositionType(node)
        }

        set {
            YGNodeStyleSetPositionType(node, newValue)
        }
    }

    var flexWrap: YGWrap {
        get {
            return YGNodeStyleGetFlexWrap(node)
        }

        set {
            YGNodeStyleSetFlexWrap(node, newValue)
        }
    }

    var overflow: YGOverflow {
        get {
            return YGNodeStyleGetOverflow(node)
        }

        set {
            YGNodeStyleSetOverflow(node, newValue)
        }
    }

    var display: YGDisplay {
        get {
            YGNodeStyleGetDisplay(node)
        }

        set {
            YGNodeStyleSetDisplay(node, newValue)
        }
    }

    var flex: CGFloat {
        get {
            return CGFloat(YGNodeStyleGetFlex(node))
        }

        set {
            YGNodeStyleSetFlex(node, Double(newValue))
        }
    }

    var flexGrow: CGFloat {
        get {
            return CGFloat(YGNodeStyleGetFlexGrow(node))
        }

        set {
            YGNodeStyleSetFlexGrow(node, Double(newValue))
        }
    }

    var flexShrink: CGFloat {
        get {
            return CGFloat(YGNodeStyleGetFlexShrink(node))
        }

        set {
            YGNodeStyleSetFlexShrink(node, Double(newValue))
        }
    }

    var flexBasis: YGValue {
        get {
            return YGNodeStyleGetFlexBasis(node)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetFlexBasisPercent(node, newValue.value)
            case .point:
                YGNodeStyleSetFlexBasis(node, newValue.value)
            case .auto:
                YGNodeStyleSetFlexBasisAuto(node)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var left: YGValue {
        get {
            return YGNodeStyleGetPosition(node, .left)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetPositionPercent(node, .left, newValue.value)
            case .point:
                YGNodeStyleSetPosition(node, .left, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var top: YGValue {
        get {
            return YGNodeStyleGetPosition(node, .top)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetPositionPercent(node, .top, newValue.value)
            case .point:
                YGNodeStyleSetPosition(node, .top, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var right: YGValue {
        get {
            return YGNodeStyleGetPosition(node, .right)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetPositionPercent(node, .right, newValue.value)
            case .point:
                YGNodeStyleSetPosition(node, .right, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var bottom: YGValue {
        get {
            return YGNodeStyleGetPosition(node, .bottom)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetPositionPercent(node, .bottom, newValue.value)
            case .point:
                YGNodeStyleSetPosition(node, .bottom, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var start: YGValue {
        get {
            return YGNodeStyleGetPosition(node, .start)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetPositionPercent(node, .start, newValue.value)
            case .point:
                YGNodeStyleSetPosition(node, .start, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var end: YGValue {
        get {
            return YGNodeStyleGetPosition(node, .end)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetPositionPercent(node, .end, newValue.value)
            case .point:
                YGNodeStyleSetPosition(node, .end, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var marginLeft: YGValue {
        get {
            return YGNodeStyleGetMargin(node, .left)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetMarginPercent(node, .left, newValue.value)
            case .point:
                YGNodeStyleSetMargin(node, .left, newValue.value)
            case .auto:
                YGNodeStyleSetMarginAuto(node, .left)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var marginTop: YGValue {
        get {
            return YGNodeStyleGetMargin(node, .top)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetMarginPercent(node, .top, newValue.value)
            case .point:
                YGNodeStyleSetMargin(node, .top, newValue.value)
            case .auto:
                YGNodeStyleSetMarginAuto(node, .top)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var marginRight: YGValue {
        get {
            return YGNodeStyleGetMargin(node, .right)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetMarginPercent(node, .right, newValue.value)
            case .point:
                YGNodeStyleSetMargin(node, .right, newValue.value)
            case .auto:
                YGNodeStyleSetMarginAuto(node, .right)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var marginBottom: YGValue {
        get {
            return YGNodeStyleGetMargin(node, .bottom)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetMarginPercent(node, .bottom, newValue.value)
            case .point:
                YGNodeStyleSetMargin(node, .bottom, newValue.value)
            case .auto:
                YGNodeStyleSetMarginAuto(node, .bottom)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var marginStart: YGValue {
        get {
            return YGNodeStyleGetMargin(node, .start)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetMarginPercent(node, .start, newValue.value)
            case .point:
                YGNodeStyleSetMargin(node, .start, newValue.value)
            case .auto:
                YGNodeStyleSetMarginAuto(node, .start)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var marginEnd: YGValue {
        get {
            return YGNodeStyleGetMargin(node, .end)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetMarginPercent(node, .end, newValue.value)
            case .point:
                YGNodeStyleSetMargin(node, .end, newValue.value)
            case .auto:
                YGNodeStyleSetMarginAuto(node, .end)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var marginHorizontal: YGValue {
        get {
            return YGNodeStyleGetMargin(node, .horizontal)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetMarginPercent(node, .horizontal, newValue.value)
            case .point:
                YGNodeStyleSetMargin(node, .horizontal, newValue.value)
            case .auto:
                YGNodeStyleSetMarginAuto(node, .horizontal)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var marginVertical: YGValue {
        get {
            return YGNodeStyleGetMargin(node, .vertical)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetMarginPercent(node, .vertical, newValue.value)
            case .point:
                YGNodeStyleSetMargin(node, .vertical, newValue.value)
            case .auto:
                YGNodeStyleSetMarginAuto(node, .vertical)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var margin: YGValue {
        get {
            return YGNodeStyleGetMargin(node, .all)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetMarginPercent(node, .all, newValue.value)
            case .point:
                YGNodeStyleSetMargin(node, .all, newValue.value)
            case .auto:
                YGNodeStyleSetMarginAuto(node, .all)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var paddingLeft: YGValue {
        get {
            return YGNodeStyleGetPadding(node, .left)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetPaddingPercent(node, .left, newValue.value)
            case .point:
                YGNodeStyleSetPadding(node, .left, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var paddingTop: YGValue {
        get {
            return YGNodeStyleGetPadding(node, .top)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetPaddingPercent(node, .top, newValue.value)
            case .point:
                YGNodeStyleSetPadding(node, .top, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var paddingRight: YGValue {
        get {
            return YGNodeStyleGetPadding(node, .right)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetPaddingPercent(node, .right, newValue.value)
            case .point:
                YGNodeStyleSetPadding(node, .right, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var paddingBottom: YGValue {
        get {
            return YGNodeStyleGetPadding(node, .bottom)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetPaddingPercent(node, .bottom, newValue.value)
            case .point:
                YGNodeStyleSetPadding(node, .bottom, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var paddingStart: YGValue {
        get {
            return YGNodeStyleGetPadding(node, .start)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetPaddingPercent(node, .start, newValue.value)
            case .point:
                YGNodeStyleSetPadding(node, .start, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var paddingEnd: YGValue {
        get {
            return YGNodeStyleGetPadding(node, .end)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetPaddingPercent(node, .end, newValue.value)
            case .point:
                YGNodeStyleSetPadding(node, .end, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var paddingHorizontal: YGValue {
        get {
            return YGNodeStyleGetPadding(node, .horizontal)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetPaddingPercent(node, .horizontal, newValue.value)
            case .point:
                YGNodeStyleSetPadding(node, .horizontal, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var paddingVertical: YGValue {
        get {
            return YGNodeStyleGetPadding(node, .vertical)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetPaddingPercent(node, .vertical, newValue.value)
            case .point:
                YGNodeStyleSetPadding(node, .vertical, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var padding: YGValue {
        get {
            return YGNodeStyleGetPadding(node, .all)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetPaddingPercent(node, .all, newValue.value)
            case .point:
                YGNodeStyleSetPadding(node, .all, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var borderLeftWidth: CGFloat {
        get {
            return CGFloat(YGNodeStyleGetBorder(node, .left))
        }

        set {
            YGNodeStyleSetBorder(node, .left, Double(newValue))
        }
    }

    var borderTopWidth: CGFloat {
        get {
            return CGFloat(YGNodeStyleGetBorder(node, .top))
        }

        set {
            YGNodeStyleSetBorder(node, .top, Double(newValue))
        }
    }

    var borderRightWidth: CGFloat {
        get {
            return CGFloat(YGNodeStyleGetBorder(node, .right))
        }

        set {
            YGNodeStyleSetBorder(node, .right, Double(newValue))
        }
    }

    var borderBottomWidth: CGFloat {
        get {
            return CGFloat(YGNodeStyleGetBorder(node, .bottom))
        }

        set {
            YGNodeStyleSetBorder(node, .bottom, Double(newValue))
        }
    }

    var borderStartWidth: CGFloat {
        get {
            return CGFloat(YGNodeStyleGetBorder(node, .start))
        }

        set {
            YGNodeStyleSetBorder(node, .start, Double(newValue))
        }
    }

    var borderEndWidth: CGFloat {
        get {
            return CGFloat(YGNodeStyleGetBorder(node, .end))
        }

        set {
            YGNodeStyleSetBorder(node, .end, Double(newValue))
        }
    }

    var borderWidth: CGFloat {
        get {
            return CGFloat(YGNodeStyleGetBorder(node, .all))
        }

        set {
            YGNodeStyleSetBorder(node, .all, Double(newValue))
        }
    }

    var width: YGValue {
        get {
            return YGNodeStyleGetWidth(node)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetWidthPercent(node, newValue.value)
            case .point:
                YGNodeStyleSetWidth(node, newValue.value)
            case .auto:
                YGNodeStyleSetWidthAuto(node)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var height: YGValue {
        get {
            return YGNodeStyleGetHeight(node)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetHeightPercent(node, newValue.value)
            case .point:
                YGNodeStyleSetHeight(node, newValue.value)
            case .auto:
                YGNodeStyleSetHeightAuto(node)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var minWidth: YGValue {
        get {
            return YGNodeStyleGetMinWidth(node)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetMinWidthPercent(node, newValue.value)
            case .point:
                YGNodeStyleSetMinWidth(node, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var minHeight: YGValue {
        get {
            return YGNodeStyleGetMinHeight(node)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetMinHeightPercent(node, newValue.value)
            case .point:
                YGNodeStyleSetMinHeight(node, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var maxWidth: YGValue {
        get {
            return YGNodeStyleGetMaxWidth(node)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetMaxWidthPercent(node, newValue.value)
            case .point:
                YGNodeStyleSetMaxWidth(node, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    var maxHeight: YGValue {
        get {
            return YGNodeStyleGetMaxHeight(node)
        }

        set {
            switch newValue.unit {
            case .percent:
                YGNodeStyleSetMaxHeightPercent(node, newValue.value)
            case .point:
                YGNodeStyleSetMaxHeight(node, newValue.value)
            default:
                assertionFailure("Not implemented")
            }
        }
    }

    // Yoga specific properties, not compatible with flexbox specification
    var aspectRatio: CGFloat {
        get {
            return CGFloat(YGNodeStyleGetAspectRatio(node))
        }

        set {
            YGNodeStyleSetAspectRatio(node, Double(newValue))
        }
    }
}

public extension YGLayout {

    @inlinable @discardableResult func direction(_ value: YGDirection) -> YGLayout {
        direction = value

        return self
    }

    @inlinable @discardableResult func flexDirection(_ value: YGFlexDirection) -> YGLayout {
        flexDirection = value

        return self
    }

    @inlinable @discardableResult func justifyContent(_ value: YGJustify) -> YGLayout {
        justifyContent = value

        return self
    }

    @inlinable @discardableResult func alignContent(_ value: YGAlign) -> YGLayout {
        alignContent = value

        return self
    }

    @inlinable @discardableResult func alignItems(_ value: YGAlign) -> YGLayout {
        alignItems = value

        return self
    }

    @inlinable @discardableResult func alignSelf(_ value: YGAlign) -> YGLayout {
        alignSelf = value

        return self
    }

    @inlinable @discardableResult func position(_ value: YGPositionType) -> YGLayout {
        position = value

        return self
    }

    @inlinable @discardableResult func flexWrap(_ value: YGWrap) -> YGLayout {
        flexWrap = value

        return self
    }

    @inlinable @discardableResult func overflow(_ value: YGOverflow) -> YGLayout {
        overflow = value

        return self
    }

    @inlinable @discardableResult func display(_ value: YGDisplay) -> YGLayout {
        display = value

        return self
    }

    @inlinable @discardableResult func flex(_ value: CGFloat) -> YGLayout {
        flex = value

        return self
    }

    @inlinable @discardableResult func flexGrow(_ value: CGFloat) -> YGLayout {
        flexGrow = value

        return self
    }

    @inlinable @discardableResult func flexShrink(_ value: CGFloat) -> YGLayout {
        flexShrink = value

        return self
    }

    @inlinable @discardableResult func flexBasis(_ value: YGValue) -> YGLayout {
        flexBasis = value

        return self
    }

    @inlinable @discardableResult func left(_ value: YGValue) -> YGLayout {
        left = value

        return self
    }

    @inlinable @discardableResult func top(_ value: YGValue) -> YGLayout {
        top = value

        return self
    }

    @inlinable @discardableResult func right(_ value: YGValue) -> YGLayout {
        right = value

        return self
    }

    @inlinable @discardableResult func bottom(_ value: YGValue) -> YGLayout {
        bottom = value

        return self
    }

    @inlinable @discardableResult func start(_ value: YGValue) -> YGLayout {
        start = value

        return self
    }

    @inlinable @discardableResult func end(_ value: YGValue) -> YGLayout {
        end = value

        return self
    }

    @inlinable @discardableResult func marginLeft(_ value: YGValue) -> YGLayout {
        marginLeft = value

        return self
    }

    @inlinable @discardableResult func marginTop(_ value: YGValue) -> YGLayout {
        marginTop = value

        return self
    }

    @inlinable @discardableResult func marginRight(_ value: YGValue) -> YGLayout {
        marginRight = value

        return self
    }

    @inlinable @discardableResult func marginBottom(_ value: YGValue) -> YGLayout {
        marginBottom = value

        return self
    }

    @inlinable @discardableResult func marginStart(_ value: YGValue) -> YGLayout {
        marginStart = value

        return self
    }

    @inlinable @discardableResult func marginEnd(_ value: YGValue) -> YGLayout {
        marginEnd = value

        return self
    }

    @inlinable @discardableResult func marginHorizontal(_ value: YGValue) -> YGLayout {
        marginHorizontal = value

        return self
    }

    @inlinable @discardableResult func marginVertical(_ value: YGValue) -> YGLayout {
        marginVertical = value

        return self
    }

    @inlinable @discardableResult func margin(_ value: YGValue) -> YGLayout {
        margin = value

        return self
    }

    @inlinable @discardableResult func paddingLeft(_ value: YGValue) -> YGLayout {
        paddingLeft = value

        return self
    }

    @inlinable @discardableResult func paddingTop(_ value: YGValue) -> YGLayout {
        paddingTop = value

        return self
    }

    @inlinable @discardableResult func paddingRight(_ value: YGValue) -> YGLayout {
        paddingRight = value

        return self
    }

    @inlinable @discardableResult func paddingBottom(_ value: YGValue) -> YGLayout {
        paddingBottom = value

        return self
    }

    @inlinable @discardableResult func paddingStart(_ value: YGValue) -> YGLayout {
        paddingStart = value

        return self
    }

    @inlinable @discardableResult func paddingEnd(_ value: YGValue) -> YGLayout {
        paddingEnd = value

        return self
    }

    @inlinable @discardableResult func paddingHorizontal(_ value: YGValue) -> YGLayout {
        paddingHorizontal = value

        return self
    }

    @inlinable @discardableResult func paddingVertical(_ value: YGValue) -> YGLayout {
        paddingVertical = value

        return self
    }

    @inlinable @discardableResult func padding(_ value: YGValue) -> YGLayout {
        padding = value

        return self
    }

    @inlinable @discardableResult func borderLeftWidth(_ value: CGFloat) -> YGLayout {
        borderLeftWidth = value

        return self
    }

    @inlinable @discardableResult func borderTopWidth(_ value: CGFloat) -> YGLayout {
        borderTopWidth = value

        return self
    }

    @inlinable @discardableResult func borderRightWidth(_ value: CGFloat) -> YGLayout {
        borderRightWidth = value

        return self
    }

    @inlinable @discardableResult func borderBottomWidth(_ value: CGFloat) -> YGLayout {
        borderBottomWidth = value

        return self
    }

    @inlinable @discardableResult func borderStartWidth(_ value: CGFloat) -> YGLayout {
        borderStartWidth = value

        return self
    }

    @inlinable @discardableResult func borderEndWidth(_ value: CGFloat) -> YGLayout {
        borderEndWidth = value

        return self
    }

    @inlinable @discardableResult func borderWidth(_ value: CGFloat) -> YGLayout {
        borderWidth = value

        return self
    }

    @inlinable @discardableResult func width(_ value: YGValue) -> YGLayout {
        width = value

        return self
    }

    @inlinable @discardableResult func height(_ value: YGValue) -> YGLayout {
        height = value

        return self
    }

    @inlinable @discardableResult func minWidth(_ value: YGValue) -> YGLayout {
        minWidth = value

        return self
    }

    @inlinable @discardableResult func minHeight(_ value: YGValue) -> YGLayout {
        minHeight = value

        return self
    }

    @inlinable @discardableResult func maxWidth(_ value: YGValue) -> YGLayout {
        maxWidth = value

        return self
    }

    @inlinable @discardableResult func maxHeight(_ value: YGValue) -> YGLayout {
        maxHeight = value

        return self
    }

    // Yoga specific properties, not compatible with flexbox specification
    @inlinable @discardableResult func aspectRatio(_ value: CGFloat) -> YGLayout {
        aspectRatio = value

        return self
    }

    @inlinable @discardableResult func includInLayout(_ value: Bool = true) -> YGLayout {
        isIncludedInLayout = value

        return self
    }
}
