/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import XCTest
import SwiftYogaKit
import Yoga

#if os(macOS)

extension NSView {
    func exchangeSubview(at index1: Int, withSubviewAt index2: Int) {
        let count = subviews.count
        guard index1 < count, index2 < count, index1 != index2 else {
            return
        }

        let subview1Index = min(index1, index2)
        let subview1 = subviews[subview1Index]

        let subview2Index = max(index1, index2)
        let subview2 = subviews[subview2Index]

        addSubview(subview1, positioned: .above, relativeTo: subviews[subview2Index - 1])
        addSubview(subview2, positioned: .below, relativeTo: subviews[subview1Index + 1])
    }
}

class NSFlippedView: NSView {
    override var isFlipped: Bool { get { true } }
}

class NSFlippedControl: NSView {
    override var isFlipped: Bool { get { true } }
}

typealias UIView = NSFlippedView
typealias UIControl = NSFlippedControl
private let kScaleFactor = NSScreen.main?.backingScaleFactor ?? 1
#else
private let kScaleFactor = UIScreen.main.scale
#endif

class Tests: XCTestCase {

    override class func setUp() {
        UIView.SwiftYogaKitSwizzle()
    }

    func testConfigureLayoutIsNoOpWithNilBlock() {
        let view = UIView()
        let block: ((YGLayout) -> Void)? = nil
        XCTAssertNoThrow(view.yoga.configureLayout(block: block))
    }

    func testConfigureLayoutBlockWorksWithValidBlock() {
        let view = UIView()
        view.yoga.configureLayout {
            XCTAssertNotNil($0)
            $0.width = 25
        }

        XCTAssertTrue(view.yoga.isIncludedInLayout)
        XCTAssertEqual(view.yoga.width.value, 25)
    }

//    func testNodesAreDeallocedWithSingleView() {
//        weak var layoutRef: YGLayout?
//
//        autoreleasepool {
//            var view: UIView? = UIView()
//            view?.yoga.flexBasis = 1
//
//            layoutRef = view?.yoga
//            XCTAssertNotNil(layoutRef)
//
//            view = nil
//        }
//
//        XCTAssertNil(layoutRef)
//    }

//    func testNodesAreDeallocedCascade() {
//        weak var topLayout: YGLayout?
//        weak var subviewLayout: YGLayout?
//
//        autoreleasepool {
//            var view: UIView? = UIView()
//            topLayout = view?.yoga
//            topLayout?.flexBasis = 1
//
//            let subview = UIView()
//            subviewLayout = subview.yoga
//            subviewLayout?.flexBasis = 1
//
//            view = nil
//        }
//
//        XCTAssertNil(topLayout)
//        XCTAssertNil(subviewLayout)
//    }

    func testIsEnabled() {
        let view = UIView()
        XCTAssertTrue(view.yoga.isIncludedInLayout)

        view.yoga.isIncludedInLayout = false
        XCTAssertFalse(view.yoga.isIncludedInLayout)

        view.yoga.isIncludedInLayout = true
        XCTAssertTrue(view.yoga.isIncludedInLayout)
    }

//    func testSizeThatFitsAsserts() {
//        let view = UIView()
//        let group = DispatchGroup()
//        let queue = DispatchQueue(label: "com.facebook.Yoga.testing")
//        queue.async(group: group) {
//            XCTAssertThrowsError(view.yoga.intrinsicSize)
//        }
//        group.wait()
//    }

    #if !os(macOS)
    func testSizeThatFitsSmoke() {
        let container = UIView()
        container.yoga.flexDirection = .row
        container.yoga.alignItems = .flexStart

        let longTextLabel = UILabel()
        longTextLabel.text = "This is a very very very very very very very very long piece of text."
        longTextLabel.lineBreakMode = .byTruncatingTail
        longTextLabel.numberOfLines = 1
        longTextLabel.yoga.flexShrink = 1
        container.addSubview(longTextLabel)

        let textBadgeView = UIView()
        textBadgeView.yoga.margin = 0
        textBadgeView.yoga.width = 10
        textBadgeView.yoga.height = 10
        container.addSubview(textBadgeView)

        let textBadgeViewSize = textBadgeView.yoga.intrinsicSize
        XCTAssertEqual(textBadgeViewSize.height, 10)
        XCTAssertEqual(textBadgeViewSize.width, 10)

        let containerSize = container.yoga.intrinsicSize
        let longTextLabelSize = longTextLabel.yoga.intrinsicSize

        XCTAssertEqual(longTextLabelSize.height, containerSize.height)
        XCTAssertEqual(longTextLabelSize.width + textBadgeView.yoga.intrinsicSize.width,
                       containerSize.width)
    }
    #endif

    func testSizeThatFitsEmptyView() {
        let view = UIView(frame: CGRect(x: 10, y: 10, width: 200, height: 200))
        view.yoga.isIncludedInLayout = true

        let viewSize = view.yoga.intrinsicSize
        XCTAssertEqual(viewSize.height, 0)
        XCTAssertEqual(viewSize.width, 0)
    }

    func testPreservingOrigin() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 75))
        container.yoga.isIncludedInLayout = true

        let view = UIView()
        view.yoga.isIncludedInLayout = true
        view.yoga.flexBasis = 0
        view.yoga.flexGrow = 1
        container.addSubview(view)

        let view2 = UIView()
        view2.yoga.isIncludedInLayout = true
        view2.yoga.marginTop = 25
        view2.yoga.flexBasis = 0
        view2.yoga.flexGrow = 1
        container.addSubview(view2)

        container.yoga.applyLayout(preservingOrigin: true)
        XCTAssertEqual(50, view2.frame.origin.y)

        view2.yoga.applyLayout(preservingOrigin: false)
        XCTAssertEqual(25, view2.frame.origin.y)
    }

    func testContainerWithFlexibleWidthGetsCorrectlySized() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        container.yoga.isIncludedInLayout = true

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.yoga.isIncludedInLayout = true
        view.yoga.width = 100
        view.yoga.height = 100
        container.addSubview(view)

        container.yoga.applyLayout(preservingOrigin: true, dimensionFlexibility: [.width])
        XCTAssertEqual(100, container.frame.size.width)
        XCTAssertEqual(200, container.frame.size.height)
    }

    func testContainerWithFlexibleHeightGetsCorrectlySized() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        container.yoga.isIncludedInLayout = true

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.yoga.isIncludedInLayout = true
        view.yoga.width = 100
        view.yoga.height = 100
        container.addSubview(view)

        container.yoga.applyLayout(preservingOrigin: true, dimensionFlexibility:[.height])
        XCTAssertEqual(200, container.frame.size.width)
        XCTAssertEqual(100, container.frame.size.height)
    }

    func testContainerWithFlexibleWidthAndHeightGetsCorrectlySized() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        container.yoga.isIncludedInLayout = true

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.yoga.isIncludedInLayout = true
        view.yoga.width = 100
        view.yoga.height = 100
        container.addSubview(view)

        container.yoga.applyLayout(preservingOrigin: true, dimensionFlexibility: [.width, .height])
        XCTAssertEqual(100, container.frame.size.width)
        XCTAssertEqual(100, container.frame.size.height)
    }

    func testMarkingDirtyOnlyWorksOnLeafNodes() {
        let container = UIView()
        container.yoga.isIncludedInLayout = true

        let subview = UIView()
        subview.yoga.isIncludedInLayout = true
        container.addSubview(subview)

        XCTAssertFalse(container.yoga.isDirty)
        container.yoga.markDirty()
        XCTAssertFalse(container.yoga.isDirty)

        XCTAssertFalse(subview.yoga.isDirty)
        subview.yoga.markDirty()
        XCTAssertTrue(subview.yoga.isDirty)
    }

    #if !os(macOS)
    func testThatMarkingLeafsAsDirtyWillTriggerASizeRecalculation() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 50))
        container.yoga.isIncludedInLayout = true
        container.yoga.flexDirection = .row
        container.yoga.alignItems = .flexStart

        let view = UILabel()
        view.text = "This is a short text."
        view.numberOfLines = 1
        view.yoga.isIncludedInLayout = true
        container.addSubview(view)

        container.yoga.applyLayout(preservingOrigin: true)
        let viewSizeAfterFirstPass = view.frame.size

        view.text = "This is a slightly longer text."
        XCTAssertTrue(view.frame.size.equalTo(viewSizeAfterFirstPass))

        view.yoga.markDirty()

        container.yoga.applyLayout(preservingOrigin: true)
        XCTAssertFalse(view.frame.size.equalTo(viewSizeAfterFirstPass))
    }
    #endif

    func testFrameAndOriginPlacement() {
        let containerSize = CGSize(width: 330, height: 50)

        let container = UIView(frame: CGRect(origin: .zero, size: containerSize))
        container.yoga.isIncludedInLayout = true
        container.yoga.flexDirection = .row

        let subview1 = UIView()
        subview1.yoga.isIncludedInLayout = true
        subview1.yoga.flexGrow = 1
        container.addSubview(subview1)

        let subview2 = UIView()
        subview2.yoga.isIncludedInLayout = true
        subview2.yoga.flexGrow = 1
        container.addSubview(subview2)

        let subview3 = UIView()
        subview3.yoga.isIncludedInLayout = true
        subview3.yoga.flexGrow = 1
        container.addSubview(subview3)

        container.yoga.applyLayout(preservingOrigin: true)

        XCTAssertEqual(subview2.frame.origin.x, subview1.frame.maxX)
        XCTAssertEqual(subview3.frame.origin.x, subview2.frame.maxX)

        var totalWidth: CGFloat = 0
        for  view in container.subviews {
            totalWidth += view.bounds.size.width
        }

        XCTAssertEqual(containerSize.width,
                       totalWidth,
                       "The container's width is \(containerSize.width), the subviews take up \(totalWidth)")
    }

    func testThatLayoutIsCorrectWhenWeSwapViewOrder() {
        let containerSize = CGSize(width: 300, height: 50)

        let container = UIView(frame: CGRect(origin: .zero, size: containerSize))
        container.yoga.isIncludedInLayout = true
        container.yoga.flexDirection = .row

        let subview1 = UIView()
        subview1.yoga.isIncludedInLayout = true
        subview1.yoga.flexGrow = 1
        container.addSubview(subview1)

        let subview2 = UIView()
        subview2.yoga.isIncludedInLayout = true
        subview2.yoga.flexGrow = 1
        container.addSubview(subview2)

        let subview3 = UIView()
        subview3.yoga.isIncludedInLayout = true
        subview3.yoga.flexGrow = 1
        container.addSubview(subview3)

        container.yoga.applyLayout(preservingOrigin: true)

        XCTAssertTrue(subview1.frame.equalTo(CGRect(x: 0, y: 0, width: 100, height: 50)))
        XCTAssertTrue(subview2.frame.equalTo(CGRect(x: 100, y: 0, width: 100, height: 50)))
        XCTAssertTrue(subview3.frame.equalTo(CGRect(x: 200, y: 0, width: 100, height: 50)))

        container.exchangeSubview(at: 2, withSubviewAt: 0)
        subview2.yoga.isIncludedInLayout = false
        container.yoga.applyLayout(preservingOrigin: true)

        XCTAssertTrue(subview3.frame.equalTo(CGRect(x: 0, y: 0, width: 150, height: 50)))
        XCTAssertTrue(subview1.frame.equalTo(CGRect(x: 150, y: 0, width: 150, height: 50)))

        // this frame shouldn't have been modified since last time.
        XCTAssertTrue(subview2.frame.equalTo(CGRect(x: 100, y: 0, width: 100, height: 50)))
    }

    func testThatWeRespectIncludeInLayoutFlag() {
        let containerSize = CGSize(width: 300, height: 50)

        let container = UIView(frame: CGRect(origin: .zero, size: containerSize))
        container.yoga.isIncludedInLayout = true
        container.yoga.flexDirection = .row

        let subview1 = UIView()
        subview1.yoga.isIncludedInLayout = true
        subview1.yoga.flexGrow = 1
        container.addSubview(subview1)

        let subview2 = UIView()
        subview2.yoga.isIncludedInLayout = true
        subview2.yoga.flexGrow = 1
        container.addSubview(subview2)

        let subview3 = UIView()
        subview3.yoga.isIncludedInLayout = true
        subview3.yoga.flexGrow = 1
        container.addSubview(subview3)

        container.yoga.applyLayout(preservingOrigin: true)

        for subview in container.subviews {
            XCTAssertEqual(subview.bounds.size.width, 100)
        }

        subview3.yoga.isIncludedInLayout = false
        container.yoga.applyLayout(preservingOrigin: true)

        XCTAssertEqual(subview1.bounds.size.width, 150)
        XCTAssertEqual(subview2.bounds.size.width, 150)

        // We don't set the frame to zero, so, it should be set to what it was
        // previously at.
        XCTAssertEqual(subview3.bounds.size.width, 100)
    }

    func testThatNumberOfChildrenIsCorrectWhenWeIgnoreSubviews() {
        let container = UIView()
        container.yoga.isIncludedInLayout = true
        container.yoga.flexDirection = .row

        let subview1 = UIView()
        subview1.yoga.isIncludedInLayout = false
        container.addSubview(subview1)

        let subview2 = UIView()
        subview2.yoga.isIncludedInLayout = false
        container.addSubview(subview2)

        let subview3 = UIView()
        subview3.yoga.isIncludedInLayout = true
        container.addSubview(subview3)

        container.yoga.applyLayout(preservingOrigin: true)
        XCTAssertEqual(container.yoga.numberOfChildren, 1)

        subview2.yoga.isIncludedInLayout = true
        container.yoga.applyLayout(preservingOrigin: true)
        XCTAssertEqual(container.yoga.numberOfChildren, 2)
    }

    func testThatViewNotIncludedInFirstLayoutPassAreIncludedInSecond() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        container.yoga.isIncludedInLayout = true
        container.yoga.flexDirection = .row

        let subview1 = UIView()
        subview1.yoga.isIncludedInLayout = true
        subview1.yoga.flexGrow = 1
        container.addSubview(subview1)

        let subview2 = UIView()
        subview2.yoga.isIncludedInLayout = true
        subview2.yoga.flexGrow = 1
        container.addSubview(subview2)

        let subview3 = UIView()
        subview3.yoga.isIncludedInLayout = true
        subview3.yoga.flexGrow = 1
        subview3.yoga.isIncludedInLayout = false
        container.addSubview(subview3)

        container.yoga.applyLayout(preservingOrigin: true)

        XCTAssertEqual(subview1.bounds.size.width, 150)
        XCTAssertEqual(subview2.bounds.size.width, 150)
        XCTAssertEqual(subview3.bounds.size.width, 0)

        subview3.yoga.isIncludedInLayout = true
        container.yoga.applyLayout(preservingOrigin: true)

        XCTAssertEqual(subview1.bounds.size.width, 100)
        XCTAssertEqual(subview2.bounds.size.width, 100)
        XCTAssertEqual(subview3.bounds.size.width, 100)
    }

    func testIsLeafFlag() {
        let view = UIView()
        XCTAssertTrue(view.yoga.isLeaf)

        for _ in 0..<10 {
            let subview = UIView()
            view.addSubview(subview)
        }
        XCTAssertTrue(view.yoga.isLeaf)

        view.yoga.isIncludedInLayout = true
        view.yoga.width = 50
        XCTAssertTrue(view.yoga.isLeaf)

        let subview = view.subviews[0]
        subview.yoga.isIncludedInLayout = true
        subview.yoga.width = 50
        XCTAssertFalse(view.yoga.isLeaf)
    }

    func testThatWeCorrectlyAttachNestedViews() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        container.yoga.isIncludedInLayout = true
        container.yoga.flexDirection = .column

        let subview1 = UIView()
        subview1.yoga.isIncludedInLayout = true
        subview1.yoga.width = 100
        subview1.yoga.flexGrow = 1
        subview1.yoga.flexDirection = .column
        container.addSubview(subview1)

        let subview2 = UIView()
        subview2.yoga.isIncludedInLayout = true
        subview2.yoga.width = 150
        subview2.yoga.flexGrow = 1
        subview2.yoga.flexDirection = .column
        container.addSubview(subview2)

        for view in [ subview1, subview2 ] {
            let someView = UIView()
            someView.yoga.isIncludedInLayout = true
            someView.yoga.flexGrow = 1
            view.addSubview(someView)
        }
        container.yoga.applyLayout(preservingOrigin: true)

        // Add the same amount of new views, reapply layout.
        for view in [ subview1, subview2 ] {
            let someView = UIView()
            someView.yoga.isIncludedInLayout = true
            someView.yoga.flexGrow = 1
            view.addSubview(someView)
        }
        container.yoga.applyLayout(preservingOrigin: true)

        XCTAssertEqual(subview1.bounds.size.width, 100)
        XCTAssertEqual(subview1.bounds.size.height, 25)
        for subview in subview1.subviews {
            let subviewSize = subview.bounds.size
            XCTAssertNotEqual(subviewSize.width, 0)
            XCTAssertNotEqual(subviewSize.height, 0)
            XCTAssertFalse(subviewSize.height.isNaN)
            XCTAssertFalse(subviewSize.width.isNaN)
        }

        XCTAssertEqual(subview2.bounds.size.width, 150)
        XCTAssertEqual(subview2.bounds.size.height, 25)
        for subview in subview2.subviews {
            let subviewSize = subview.bounds.size
            XCTAssertNotEqual(subviewSize.width, 0)
            XCTAssertNotEqual(subviewSize.height, 0)
            XCTAssertFalse(subviewSize.height.isNaN)
            XCTAssertFalse(subviewSize.width.isNaN)
        }
    }

    func testThatANonLeafNodeCanBecomeALeafNode() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        container.yoga.isIncludedInLayout = true

        let subview1 = UIView()
        subview1.yoga.isIncludedInLayout = true
        container.addSubview(subview1)

        let subview2 = UIView()
        subview2.yoga.isIncludedInLayout = true
        subview1.addSubview(subview2)

        container.yoga.applyLayout(preservingOrigin: true)
        XCTAssertTrue(!subview1.yoga.isLeaf && subview2.yoga.isLeaf)

        subview2.removeFromSuperview()
        container.yoga.applyLayout(preservingOrigin: true)
        XCTAssertTrue(subview1.yoga.isLeaf)
    }

    func testPointPercent() {
        XCTAssertEqual(YGValue.point(1).value, 1)
        XCTAssertEqual(YGValue.point(1).unit, .point)
        XCTAssertEqual(YGValue.percent(2).value, 2)
        XCTAssertEqual(YGValue.percent(2).unit, .percent)
    }

    func testPositionalPropertiesWork() {
        let view = UIView()

        view.yoga.left = 1
        XCTAssertEqual(view.yoga.left.value, 1)
        XCTAssertEqual(view.yoga.left.unit, .point)
        view.yoga.left = 2%
        XCTAssertEqual(view.yoga.left.value, 2)
        XCTAssertEqual(view.yoga.left.unit, .percent)

        view.yoga.right = 3
        XCTAssertEqual(view.yoga.right.value, 3)
        XCTAssertEqual(view.yoga.right.unit, .point)
        view.yoga.right = 4%
        XCTAssertEqual(view.yoga.right.value, 4)
        XCTAssertEqual(view.yoga.right.unit, .percent)

        view.yoga.top = 5
        XCTAssertEqual(view.yoga.top.value, 5)
        XCTAssertEqual(view.yoga.top.unit, .point)
        view.yoga.top = 6%
        XCTAssertEqual(view.yoga.top.value, 6)
        XCTAssertEqual(view.yoga.top.unit, .percent)

        view.yoga.bottom = 7
        XCTAssertEqual(view.yoga.bottom.value, 7)
        XCTAssertEqual(view.yoga.bottom.unit, .point)
        view.yoga.bottom = 8%
        XCTAssertEqual(view.yoga.bottom.value, 8)
        XCTAssertEqual(view.yoga.bottom.unit, .percent)

        view.yoga.start = 9
        XCTAssertEqual(view.yoga.start.value, 9)
        XCTAssertEqual(view.yoga.start.unit, .point)
        view.yoga.start = 10%
        XCTAssertEqual(view.yoga.start.value, 10)
        XCTAssertEqual(view.yoga.start.unit, .percent)

        view.yoga.end = 11
        XCTAssertEqual(view.yoga.end.value, 11)
        XCTAssertEqual(view.yoga.end.unit, .point)
        view.yoga.end = 12%
        XCTAssertEqual(view.yoga.end.value, 12)
        XCTAssertEqual(view.yoga.end.unit, .percent)
    }

    func testMarginPropertiesWork() {
        let view = UIView()

        view.yoga.margin = 1
        XCTAssertEqual(view.yoga.margin.value, 1)
        XCTAssertEqual(view.yoga.margin.unit, .point)
        view.yoga.margin = 2%
        XCTAssertEqual(view.yoga.margin.value, 2)
        XCTAssertEqual(view.yoga.margin.unit, .percent)

        view.yoga.marginHorizontal = 3
        XCTAssertEqual(view.yoga.marginHorizontal.value, 3)
        XCTAssertEqual(view.yoga.marginHorizontal.unit, .point)
        view.yoga.marginHorizontal = 4%
        XCTAssertEqual(view.yoga.marginHorizontal.value, 4)
        XCTAssertEqual(view.yoga.marginHorizontal.unit, .percent)

        view.yoga.marginVertical = 5
        XCTAssertEqual(view.yoga.marginVertical.value, 5)
        XCTAssertEqual(view.yoga.marginVertical.unit, .point)
        view.yoga.marginVertical = 6%
        XCTAssertEqual(view.yoga.marginVertical.value, 6)
        XCTAssertEqual(view.yoga.marginVertical.unit, .percent)

        view.yoga.marginLeft = 7
        XCTAssertEqual(view.yoga.marginLeft.value, 7)
        XCTAssertEqual(view.yoga.marginLeft.unit, .point)
        view.yoga.marginLeft = 8%
        XCTAssertEqual(view.yoga.marginLeft.value, 8)
        XCTAssertEqual(view.yoga.marginLeft.unit, .percent)

        view.yoga.marginRight = 9
        XCTAssertEqual(view.yoga.marginRight.value, 9)
        XCTAssertEqual(view.yoga.marginRight.unit, .point)
        view.yoga.marginRight = 10%
        XCTAssertEqual(view.yoga.marginRight.value, 10)
        XCTAssertEqual(view.yoga.marginRight.unit, .percent)

        view.yoga.marginTop = 11
        XCTAssertEqual(view.yoga.marginTop.value, 11)
        XCTAssertEqual(view.yoga.marginTop.unit, .point)
        view.yoga.marginTop = 12%
        XCTAssertEqual(view.yoga.marginTop.value, 12)
        XCTAssertEqual(view.yoga.marginTop.unit, .percent)

        view.yoga.marginBottom = 13
        XCTAssertEqual(view.yoga.marginBottom.value, 13)
        XCTAssertEqual(view.yoga.marginBottom.unit, .point)
        view.yoga.marginBottom = 14%
        XCTAssertEqual(view.yoga.marginBottom.value, 14)
        XCTAssertEqual(view.yoga.marginBottom.unit, .percent)

        view.yoga.marginStart = 15
        XCTAssertEqual(view.yoga.marginStart.value, 15)
        XCTAssertEqual(view.yoga.marginStart.unit, .point)
        view.yoga.marginStart = 16%
        XCTAssertEqual(view.yoga.marginStart.value, 16)
        XCTAssertEqual(view.yoga.marginStart.unit, .percent)

        view.yoga.marginEnd = 17
        XCTAssertEqual(view.yoga.marginEnd.value, 17)
        XCTAssertEqual(view.yoga.marginEnd.unit, .point)
        view.yoga.marginEnd = 18%
        XCTAssertEqual(view.yoga.marginEnd.value, 18)
        XCTAssertEqual(view.yoga.marginEnd.unit, .percent)
    }

    func testPaddingPropertiesWork() {
        let view = UIView()

        view.yoga.padding = 1
        XCTAssertEqual(view.yoga.padding.value, 1)
        XCTAssertEqual(view.yoga.padding.unit, .point)
        view.yoga.padding = 2%
        XCTAssertEqual(view.yoga.padding.value, 2)
        XCTAssertEqual(view.yoga.padding.unit, .percent)

        view.yoga.paddingHorizontal = 3
        XCTAssertEqual(view.yoga.paddingHorizontal.value, 3)
        XCTAssertEqual(view.yoga.paddingHorizontal.unit, .point)
        view.yoga.paddingHorizontal = 4%
        XCTAssertEqual(view.yoga.paddingHorizontal.value, 4)
        XCTAssertEqual(view.yoga.paddingHorizontal.unit, .percent)

        view.yoga.paddingVertical = 5
        XCTAssertEqual(view.yoga.paddingVertical.value, 5)
        XCTAssertEqual(view.yoga.paddingVertical.unit, .point)
        view.yoga.paddingVertical = 6%
        XCTAssertEqual(view.yoga.paddingVertical.value, 6)
        XCTAssertEqual(view.yoga.paddingVertical.unit, .percent)

        view.yoga.paddingLeft = 7
        XCTAssertEqual(view.yoga.paddingLeft.value, 7)
        XCTAssertEqual(view.yoga.paddingLeft.unit, .point)
        view.yoga.paddingLeft = 8%
        XCTAssertEqual(view.yoga.paddingLeft.value, 8)
        XCTAssertEqual(view.yoga.paddingLeft.unit, .percent)

        view.yoga.paddingRight = 9
        XCTAssertEqual(view.yoga.paddingRight.value, 9)
        XCTAssertEqual(view.yoga.paddingRight.unit, .point)
        view.yoga.paddingRight = 10%
        XCTAssertEqual(view.yoga.paddingRight.value, 10)
        XCTAssertEqual(view.yoga.paddingRight.unit, .percent)

        view.yoga.paddingTop = 11
        XCTAssertEqual(view.yoga.paddingTop.value, 11)
        XCTAssertEqual(view.yoga.paddingTop.unit, .point)
        view.yoga.paddingTop = 12%
        XCTAssertEqual(view.yoga.paddingTop.value, 12)
        XCTAssertEqual(view.yoga.paddingTop.unit, .percent)

        view.yoga.paddingBottom = 13
        XCTAssertEqual(view.yoga.paddingBottom.value, 13)
        XCTAssertEqual(view.yoga.paddingBottom.unit, .point)
        view.yoga.paddingBottom = 14%
        XCTAssertEqual(view.yoga.paddingBottom.value, 14)
        XCTAssertEqual(view.yoga.paddingBottom.unit, .percent)

        view.yoga.paddingStart = 15
        XCTAssertEqual(view.yoga.paddingStart.value, 15)
        XCTAssertEqual(view.yoga.paddingStart.unit, .point)
        view.yoga.paddingStart = 16%
        XCTAssertEqual(view.yoga.paddingStart.value, 16)
        XCTAssertEqual(view.yoga.paddingStart.unit, .percent)

        view.yoga.paddingEnd = 17
        XCTAssertEqual(view.yoga.paddingEnd.value, 17)
        XCTAssertEqual(view.yoga.paddingEnd.unit, .point)
        view.yoga.paddingEnd = 18%
        XCTAssertEqual(view.yoga.paddingEnd.value, 18)
        XCTAssertEqual(view.yoga.paddingEnd.unit, .percent)
    }

    func testBorderWidthPropertiesWork() {
        let view = UIView()

        view.yoga.borderWidth = 1
        XCTAssertEqual(view.yoga.borderWidth, 1)

        view.yoga.borderLeftWidth = 2
        XCTAssertEqual(view.yoga.borderLeftWidth, 2)

        view.yoga.borderRightWidth = 3
        XCTAssertEqual(view.yoga.borderRightWidth, 3)

        view.yoga.borderTopWidth = 4
        XCTAssertEqual(view.yoga.borderTopWidth, 4)

        view.yoga.borderBottomWidth = 5
        XCTAssertEqual(view.yoga.borderBottomWidth, 5)

        view.yoga.borderStartWidth = 6
        XCTAssertEqual(view.yoga.borderStartWidth, 6)

        view.yoga.borderEndWidth = 7
        XCTAssertEqual(view.yoga.borderEndWidth, 7)
    }

    #if !os(macOS)
    func testOverflowPropertiesWork() {
        let container = UIView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        container.yoga.configureLayout {
            $0.flexDirection = .row
            $0.alignItems = .center
        }

        let view = UIView()
        container.addSubview(view)
        view.yoga.configureLayout {
            $0.width = 22
            $0.height = 22
        }

        let label = UILabel()
        label.text = "longlonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglong"
        container.addSubview(label)
        label.yoga.configureLayout {
            $0.isIncludedInLayout = true
        }

        container.yoga.applyLayout(preservingOrigin: true)
        XCTAssertEqual(container.frame.width, 30)
        XCTAssertEqual(label.frame.width, 30)

        container.yoga.overflow = .scroll
        container.yoga.applyLayout(preservingOrigin: true)
        XCTAssertEqual(container.frame.width, 30)
        XCTAssertGreaterThan(label.frame.width, 30)

        container.yoga.overflow = .hidden
        container.yoga.applyLayout(preservingOrigin: true)
        XCTAssertEqual(container.frame.width, 30)
        XCTAssertEqual(label.frame.width, 30)

        container.yoga.overflow = .visible
        container.yoga.applyLayout(preservingOrigin: true)
        XCTAssertEqual(container.frame.width, 30)
        XCTAssertEqual(label.frame.width, 30)
    }
    #endif

    #if !os(macOS)
    func testIsIncludedInLayoutWork() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.yoga.configureLayout {
            $0.flexDirection = .column
        }

        let container = UIControl()
        view.addSubview(container)
        container.yoga.configureLayout {
            $0.flexDirection = .row
        }

        let label = UILabel()
        label.text = "abcdefgABCDEFG"
        container.addSubview(label)
        label.yoga.isIncludedInLayout = true
        label.yoga.markDirty()

        view.yoga.applyLayout(preservingOrigin: true)
        XCTAssertGreaterThan(container.frame.height, 0)

        label.yoga.isIncludedInLayout = false

        view.yoga.applyLayout(preservingOrigin: true)
        XCTAssertEqual(container.frame.height, 0)
    }
    #endif

    func testOnePixelWork() {
        let onePixel: CGFloat = 1 / kScaleFactor

        let view = UIView()
        view.yoga.configureLayout {
            $0.flexDirection = .column
        }

        let subView1 = UIView()
        view.addSubview(subView1)
        subView1.yoga.configureLayout {
            $0.width = 320
            $0.height = .point(320 + onePixel)
        }

        let subView2 = UIView()
        view.addSubview(subView2)
        subView2.yoga.configureLayout {
            $0.marginTop = 20
            $0.width = 320
            $0.height = .point(onePixel)
        }

        let fittingSize = view.yoga.calculateLayout(size: CGSize(width: 320, height: CGFloat.nan))
        view.frame = CGRect(origin: .zero, size: fittingSize)
        view.yoga.applyLayout(preservingOrigin: true)
        XCTAssertLessThan(abs(subView2.frame.height - onePixel), CGFloat.ulpOfOne)
    }

    func testBaseViewLeafNodeWork() {
        let container = UIView()
        container.yoga.configureLayout {
            $0.width = 300
            $0.height = 180
        }

        let subview1 = UIView()
        container.addSubview(subview1)
        subview1.yoga.isIncludedInLayout = true

        let subview2 = UIView()
        subview1.addSubview(subview2)
        subview2.yoga.isIncludedInLayout = true

        let subview3 = UIView()
        subview2.addSubview(subview3)
        subview3.yoga.configureLayout {
            $0.width = 80
            $0.height = 60
        }

        container.yoga.applyLayout(preservingOrigin: true)

        XCTAssertEqual(subview1.frame.size.height, 60)
        XCTAssertEqual(subview2.frame.size.height, 60)
        XCTAssertEqual(subview3.frame.size.height, 60)

        subview2.yoga.isIncludedInLayout = false
        subview2.frame = .zero;
        container.yoga.applyLayout(preservingOrigin: true)

        XCTAssertEqual(subview1.frame.size.height, 0)
        XCTAssertEqual(subview2.frame.size.height, 0)
        XCTAssertEqual(subview3.frame.size.height, 60)

        XCTAssertEqual(container.frame.size.width, 300)
        XCTAssertEqual(container.frame.size.height, 180)
    }

    func testAutoLayoutSupport() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))

        let container = UIView()
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.topAnchor, constant:24),
            container.leftAnchor.constraint(equalTo: view.leftAnchor, constant:24)
        ])

        container.yoga.configureLayout {
            $0.flexDirection = .column
        }

        let subview1 = UIView()
        container.addSubview(subview1)
        subview1.yoga.configureLayout {
            $0.height = 80
            $0.width = 60
            $0.marginBottom = 16
        }

        let subview2 = UIView()
        container.addSubview(subview2)
        subview2.yoga.configureLayout {
            $0.height = 180
            $0.width = 200
        }

        let subview3 = UIView()
        container.addSubview(subview3)
        subview3.yoga.configureLayout {
            $0.height = 100
            $0.width = 80
            $0.marginTop = 24
        }

        #if os(macOS)
        view.layoutSubtreeIfNeeded()
        #else
        view.layoutIfNeeded()
        #endif

        XCTAssertEqual(container.frame.origin.x, 24)
        XCTAssertEqual(container.frame.origin.y, 24)
        XCTAssertEqual(container.frame.size.width, 200)
        XCTAssertEqual(container.frame.size.height, 80 + 16 + 180 + 24 + 100)
    }
}

