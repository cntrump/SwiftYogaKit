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

import ObjectiveC.runtime

private var kYGYogaAssociatedKey: UInt8 = 0

#if os(macOS)
private var kYGNSViewFittingSizeAssociatedKey: UInt8 = 0
#endif

extension UIView {

    public var yoga: YGLayout {
        get {
            guard let yoga = objc_getAssociatedObject(self, &kYGYogaAssociatedKey) as? YGLayout else {
                let yoga = YGLayout(view: self)
                objc_setAssociatedObject(self, &kYGYogaAssociatedKey, yoga, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

                return yoga
            }

            return yoga
        }
    }

    public var isYogaEnabled: Bool {
        let yoga = objc_getAssociatedObject(self, &kYGYogaAssociatedKey) as? YGLayout

        return yoga != nil
    }

    #if os(macOS)
    var _swift_yoga_isFittingSize: Bool {
        get {
            guard let isFittingSize = objc_getAssociatedObject(self, &kYGNSViewFittingSizeAssociatedKey) as? NSNumber else {
                return false
            }

            return isFittingSize.boolValue
        }

        set {
            objc_setAssociatedObject(self, &kYGNSViewFittingSizeAssociatedKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    #endif
}
