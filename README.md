# SwiftYogaKit

Ported version of [YogaKit](https://github.com/cntrump/yoga/tree/master/YogaKit).

Dependency on [yoga](https://github.com/cntrump/yoga).

## Install

### SPM (Swift Package Manager)

package respository URL: https://github.com/cntrump/SwiftYogaKit.git

### Carthage

```
github "cntrump/SwiftYogaKit" ~> 1.0.0
```

## Usage

```swift
import SwiftYogaKit
```

### Add swizzle for auto apply layout.

iOS / tvOS

```swift
func applicationDidFinishLaunching(_ application: UIApplication) {
    UIView.SwiftYogaKitSwizzle()
}
```

macOS

```swift
func applicationWillFinishLaunching(_ aNotification: Notification) {
    NSView.SwiftYogaKitSwizzle()
}
```

### A simple layout

```swift
override func viewDidLoad() {

    let root = self.view!
    root.backgroundColor = .white
    root.yoga
        .alignItems(.center)
        .justifyContent(.center)

    let child1 = UIView()
    child1.backgroundColor = .blue
    child1.yoga
        .width(100)
        .height(10)
        .marginBottom(25)
    root.addSubview(child1)

    let child2 = UIView()
    child2.backgroundColor = .green
    child2.yoga
        .alignSelf(.flexEnd)
        .width(200)
        .height(200)
    root.addSubview(child2)

    let child3 = UIView()
    child3.backgroundColor = .yellow
    child3.yoga
        .alignSelf(.flexStart)
        .width(100)
        .height(100)
    root.addSubview(child3)
}
```

### Self-sizing Table View Cells

```swift
tableView.estimatedRowHeight = UITableView.automaticDimension
tableView.rowHeight = UITableView.automaticDimension
```

Subclass `UITableViewCell`, calculate cell size in `sizeThatFits(_:)`

```swift
override func sizeThatFits(_ size: CGSize) -> CGSize {
    var w: CGFloat = 0
    if #available(iOS 11.0, *) {
        w = size.width - self.safeAreaInsets.left - self.safeAreaInsets.right
    }

    return contentView.yoga.calculateLayout(size: CGSize(width: w, height: .nan))
}
```
