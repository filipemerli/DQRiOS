import UIKit

class TabBarViewController: UITabBarController {
    
    /* Class responsible for app main and unique navigation flow,
       this main TabBar holds Conversion and List ViewControllers
       and switches between them by a bottom TabBar.
     */
    
    //MARK: Properties
    
    private lazy var listViewController: ListViewController = {
        let viewController = ListViewController()
        return viewController
    }()
    
    private lazy var conversionViewController: ConversionViewController = {
        let viewController = ConversionViewController()
        return viewController
    }()
    
    private lazy var listItem: UITabBarItem = {
        let icon = UITabBarItem(title: "Currencies", image: nil, selectedImage: nil)
        return icon
    }()
    
    private lazy var conversionItem: UITabBarItem = {
        let icon = UITabBarItem(title: "Convertion", image: nil, selectedImage: nil)
        return icon
    }()
    
    //MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarViewControllers()
    }
    
    //MARK: Class Methods
    
    private func setTabBarViewControllers() {
        listViewController.tabBarItem = listItem
        conversionViewController.tabBarItem = conversionItem
        self.viewControllers = [listViewController, conversionViewController]
    }
    
}
