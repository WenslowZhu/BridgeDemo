# Swift - 使用 Protocol 避免框架之间循环引用

![](./time_alone3_hires.jpg)

> 将高度复用的代码封装到静态库中不仅可以将代码解耦，还可以提高代码的可维护性。笔者所在公司的iOS项目是使用模块化开发的，项目中大量的可复用代码都被封装成静态库。

## 静态库的循环引用

设想这样的一个场景

A Framework 引用 B Framework，而此时B Framework 需要使用到 A Framework 中的一个**服务**。但不幸的是该服务**耦合** 在A Framework 中，为了避免**引用循环**，我们需要重构 A Framework，并且将该服务迁移到另外一个 C Framework 中。

我相信在现实中，没有程序员原意冒着风险去重构 A Framework 的代码和单元测试（~~有这个时间，老子还不如去多玩几把玩者~~）。


## 使用Protocol 解决循环引用

在这里笔者提供一种思路来帮助大家在无需重构现有代码的前提下，将 A Framework 中的服务暴露给 B Framework。

>这里的示例代码可以在文末的 Github 链接中下载到

### 准备工作

在我们主项目中，我们定义了一个 `Color` 服务

```swift
protocol ColorLayer {
    func backgroundColor() -> UIColor
}

class ColorService: ColorLayer {
    func backgroundColor() -> UIColor {
        return .red
    }
}
```

这时候我们新建一个静态库，并命名为 `BridgeTestFramework`

在这个静态库中，我们有这样的一段代码。

```swift
public class BridgeViewController: UIViewController {
    
    let colorService = ColorService()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colorService.backgroundColor()
    }
}
```

由于 `BridgeTestFramework` 被主项目引用，而 `BridgeTestFramework` 不能引用主项目，故编译器会给出错误。

### 在 `BridgeTestFramework` 中定义 Protocol

复制 `ColorService` 的 Protocol 到 `BridgeTestFramework` 中，别忘记小改一下这个 Protocol 的名字并将其访问权限更改为 `public`。

```swift
public protocol BridgeTestFrameworkColorLayer {
    func backgroundColor() -> UIColor
}
```

接着我们重构一下 `BridgeViewController`

```swift
public class BridgeViewController: UIViewController {
    
    let colorService: BridgeTestFrameworkColorLayer
    
    public init(colorService: BridgeTestFrameworkColorLayer) {
        self.colorService = colorService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colorService.backgroundColor()
    }
}
```

在这里我们将属性 `colorService` 的类型用 `BridgeTestFrameworkColorLayer` 代替。由于 `BridgeTestFrameworkColorLayer` 和 `ColorService` 所暴露出来的 **interface** 是一样的，所以我们可以正常使用 `backgroundColor()` 这个方法。

### 在主项目中实现 Protocol

接着我们回到主项目的代码。为 `ColorService` 引入 `BridgeTestFramework`，并拓展 `ColorService`。

```swift
import BridgeTestFramework

protocol ColorLayer {
    func backgroundColor() -> UIColor
}

class ColorService: ColorLayer, BridgeTestFrameworkColorLayer {
    func backgroundColor() -> UIColor {
        return .red
    }
}
```

由于 `ColorLayer` 与 `BridgeTestFrameworkColorLayer` 所定义的 **interface** 是一样的，所以我们无需更改 `ColorService` 的具体实现。

### 使用 Protocol

接着我们尝试在主项目中使用一下我们重构后的 `BridgeViewController` 吧。

```swift
class ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let bridgeVC = BridgeViewController(colorService: ColorService())
        present(bridgeVC, animated: true, completion: nil)
    }
}
```

由于 `ColorService` 实现了 `BridgeTestFrameworkColorLayer` 这个协议，`BridgeViewController` 可以正常使用 `ColorService` 对 `backgroundColor()` 这个 **interface** 的实现。

## 小结

在这个小 Demo 中我们使用 Protocol 在两个静态库之间搭起一座临时的桥梁。借助 Protocol 我们可以在避免循环引用的前提下，在已经存在从属引用关系的静态库之间分享某些服务。

但是请牢记，好的设计模式才是避免出现这种循环引用的根本解决方案。
