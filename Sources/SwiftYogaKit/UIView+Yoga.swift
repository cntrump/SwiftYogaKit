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
}
