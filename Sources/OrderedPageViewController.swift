import UIKit

public protocol OrderedPageViewControllerDataSource: class {
    func numberOfPages(in orderedPageViewController: OrderedPageViewController) -> Int
    func orderedPageViewController(_ orderedPageViewController: OrderedPageViewController, viewControllerAt index: Int) -> UIViewController
}

public protocol OrderedPageViewControllerDelegate: class {
    func orderedPageViewController(_ orderedPageViewController: OrderedPageViewController, willScrollToViewControllerAt index: Int)
    func orderedPageViewController(_ orderedPageViewController: OrderedPageViewController, didScrollToViewControllerAt index: Int)
}

open class OrderedPageViewController: UIPageViewController {

    open weak var orderedDataSource: OrderedPageViewControllerDataSource?
    open weak var orderedDelegate: OrderedPageViewControllerDelegate?
    fileprivate var navigationItemObservation: [NSKeyValueObservation]?

    open var visibleViewController: UIViewController? {
        if self.pageIndex != NSNotFound {
            return self.viewController(at: self.pageIndex)
        }
        return nil
    }

    open fileprivate(set) var numberOfPages: Int
    open fileprivate(set) var pageIndex: Int

    override weak open var delegate: UIPageViewControllerDelegate? {
        get { return super.delegate }
        set { }
    }

    override weak open var dataSource: UIPageViewControllerDataSource? {
        get { return super.dataSource }
        set { }
    }

    open var isInfinite: Bool

    fileprivate var cacheViewControllers: [Int: UIViewController]?

    public override init(transitionStyle style: UIPageViewController.TransitionStyle,
                         navigationOrientation: UIPageViewController.NavigationOrientation,
                         options: [UIPageViewController.OptionsKey: Any]? = nil) {
        self.isInfinite = true
        self.pageIndex = -1
        self.numberOfPages = -1
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }

    public required init?(coder: NSCoder) {
        self.isInfinite = true
        self.pageIndex = -1
        self.numberOfPages =  -1
        super.init(coder: coder)
    }

    deinit {
        self.navigationItemObservation = nil
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        super.delegate = self
        super.dataSource = self
        self.reloadPages()
    }

    open func scroll(toViewControllerAt index: Int, animated: Bool) {
        guard self.isViewLoaded else {
            self.pageIndex = index
            return
        }
        guard let viewController = self.viewController(at: index) else {
            return
        }
        var direction: UIPageViewController.NavigationDirection = .forward
        if self.pageIndex != -1 && self.pageIndex > index {
            direction = .reverse
        }
        self.setViewControllers([viewController], direction: direction, animated: animated) { [weak self] _ in
            guard let target = self else {
                return
            }
            target.pageIndex = index
            target.setNeedsUIUpdate()
            target.orderedDelegate?.orderedPageViewController(target, didScrollToViewControllerAt: target.pageIndex)
        }
    }

    fileprivate func observeNavigationItem<T>(_ childNavigationItem: UINavigationItem, using keyPath: ReferenceWritableKeyPath<UINavigationItem, T?>) -> NSKeyValueObservation {
        self.navigationItem[keyPath: keyPath] = childNavigationItem[keyPath: keyPath]
        return childNavigationItem.observe(keyPath, options: [.new], changeHandler: { [weak self] (_, change) in
            guard let target = self, let res = change.newValue else {
                return
            }
            target.navigationItem[keyPath: keyPath] = res
        })
    }

    fileprivate func setNeedsUIUpdate() {
        let navigationItem = self.visibleViewController?.navigationItem ?? self.navigationItem
        self.navigationItemObservation = [
            self.observeNavigationItem(navigationItem, using: \UINavigationItem.title),
            self.observeNavigationItem(navigationItem, using: \UINavigationItem.titleView),
            self.observeNavigationItem(navigationItem, using: \UINavigationItem.rightBarButtonItems),
            self.observeNavigationItem(navigationItem, using: \UINavigationItem.leftBarButtonItems),
            self.observeNavigationItem(navigationItem, using: \UINavigationItem.rightBarButtonItem),
            self.observeNavigationItem(navigationItem, using: \UINavigationItem.leftBarButtonItem)
        ]
        #if os(iOS)
        self.setNeedsStatusBarAppearanceUpdate()
        if #available(iOS 11.0, *) {
            self.setNeedsUpdateOfHomeIndicatorAutoHidden()
            self.setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        }
        #elseif os(tvOS)
        self.setNeedsFocusUpdate()
        if #available(tvOS 11.0, *) {
            self.setNeedsUserInterfaceAppearanceUpdate()
        }
        #endif
    }

    open func viewController(at index: Int) -> UIViewController? {
        if let viewController = self.cacheViewControllers?[index] {
            return viewController
        }
        guard index >= 0 && index < self.numberOfPages,
            let orderedDataSource = self.orderedDataSource else {
            return nil
        }
        let viewController = orderedDataSource.orderedPageViewController(self, viewControllerAt: index)
        self.cacheViewControllers?[index] = viewController
        return viewController
    }

    open func reloadPages() {
        guard let orderedDataSource = self.orderedDataSource else {
            return
        }
        self.numberOfPages = orderedDataSource.numberOfPages(in: self)
        if self.numberOfPages > 0 {
            self.cacheViewControllers = [:]
            self.pageIndex = min(max(self.pageIndex, 0), self.numberOfPages - 1)
            self.scroll(toViewControllerAt: self.pageIndex, animated: false)
        } else {
            self.cacheViewControllers = nil
            self.pageIndex = -1
        }
    }

    #if os(iOS)
    open override var childForStatusBarStyle: UIViewController? {
        return self.visibleViewController
    }

    open override var childForStatusBarHidden: UIViewController? {
        return self.visibleViewController
    }

    @available(iOS 11.0, *)
    open override var childForHomeIndicatorAutoHidden: UIViewController? {
        return self.visibleViewController
    }

    @available(iOS 11.0, *)
    open override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        return self.visibleViewController
    }
    #elseif os(tvOS)
    @available(tvOS 11.0, *)
    open override var childViewControllerForUserInterfaceStyle: UIViewController? {
        return self.visibleViewController
    }
    #endif
}

extension OrderedPageViewController: UIPageViewControllerDataSource {

    fileprivate func index(of viewController: UIViewController) -> Int {
        guard let controller = self.cacheViewControllers?.first(where: { $0.value == viewController }) else {
            return -1
        }
        return controller.key
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.index(of: viewController)
        if index <= 0 && self.isInfinite {
            index = self.numberOfPages
        }
        return self.viewController(at: index - 1)
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.index(of: viewController) + 1
        if self.isInfinite && index >= self.numberOfPages {
            index = 0
        }
        return self.viewController(at: index)
    }
}

extension OrderedPageViewController: UIPageViewControllerDelegate {

    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.view.isUserInteractionEnabled = false
        if pendingViewControllers.count > 0 {
            let index = self.index(of: pendingViewControllers[0])
            if index >= 0 && index != self.pageIndex {
                self.orderedDelegate?.orderedPageViewController(self, willScrollToViewControllerAt: index)
            }
        }
    }

    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.view.isUserInteractionEnabled = true
        guard let viewControllers = pageViewController.viewControllers else {
            return
        }
        if viewControllers.count > 0 {
            self.pageIndex = self.index(of: viewControllers[0])
        } else {
            self.pageIndex = -1
        }
        self.setNeedsUIUpdate()
        self.orderedDelegate?.orderedPageViewController(self, didScrollToViewControllerAt: self.pageIndex)
    }

    #if os(iOS)
    public func pageViewControllerSupportedInterfaceOrientations(_ pageViewController: UIPageViewController) -> UIInterfaceOrientationMask {
        return self.visibleViewController?.supportedInterfaceOrientations ?? self.supportedInterfaceOrientations
    }

    public func pageViewControllerPreferredInterfaceOrientationForPresentation(_ pageViewController: UIPageViewController) -> UIInterfaceOrientation {
        return self.visibleViewController?.preferredInterfaceOrientationForPresentation ?? self.preferredInterfaceOrientationForPresentation
    }
    #elseif os(tvOS)
    open override var preferredFocusEnvironments: [UIFocusEnvironment] {
        if let focus = self.visibleViewController?.preferredFocusEnvironments {
            return focus + super.preferredFocusEnvironments
        }
        return super.preferredFocusEnvironments
    }
    #endif
}

public extension OrderedPageViewControllerDelegate {
    func orderedPageViewController(_ orderedPageViewController: OrderedPageViewController, willScrollToViewControllerAt index: Int) { }
    func orderedPageViewController(_ orderedPageViewController: OrderedPageViewController, didScrollToViewControllerAt index: Int) { }
}
