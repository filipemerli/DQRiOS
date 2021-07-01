import UIKit

protocol ListViewControllerDelegate: AnyObject {
    func didChosseCode(code: String)
}

class ListViewController: UIViewController {
    
    //MARK: Properties
    
    private let cellIdentifier = "tableCell"
    private var viewModel: ListViewModel?
    private weak var delegate: ListViewControllerDelegate?
    private let filterButtonHeight: CGFloat = 35.0
    private let filterButtonWidth: CGFloat = 85.0
    private let topviewHeight: CGFloat = 70.0
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewControllerLabel: ViewControllersTitleLabel = {
        let label = ViewControllersTitleLabel()
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.allowsSelection = true
        return table
    }()
    
    private lazy var filterButton: FilterButton = {
        let button = FilterButton()
        return button
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.searchBarStyle = UISearchBar.Style.default
        bar.isUserInteractionEnabled = true
        bar.isTranslucent = false
        bar.placeholder = " Search..."
        return bar
    }()
    
    init(delegate: ListViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        filterButton.delegate = self
        searchBar.delegate = self
        view.backgroundColor = .white
        viewModel = ListViewModel(delegate: self)
        setSubviews()
    }
    
    deinit {
        viewModel = nil
    }
    
    //MARK: Class Methods
    
    private func setSubviews() {
        view.addSubview(topView)
        topView.addSubview(viewControllerLabel)
        topView.addSubview(filterButton)
        topView.addSubview(searchBar)
        view.addSubview(tableView)
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: topviewHeight),
            
            tableView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -getTabBarHeight()),
            
            viewControllerLabel.topAnchor.constraint(equalTo: topView.topAnchor),
            viewControllerLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            viewControllerLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            viewControllerLabel.heightAnchor.constraint(equalToConstant: filterButtonHeight),
            
            filterButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -5.0),
            filterButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: filterButtonHeight),
            filterButton.widthAnchor.constraint(equalToConstant: filterButtonWidth),
            
            searchBar.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor),
            searchBar.topAnchor.constraint(equalTo: viewControllerLabel.bottomAnchor)
        ])
    }
    
    private func getTabBarHeight() -> CGFloat {
        return self.tabBarController?.tabBar.frame.size.height ?? 0
    }
    
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true)
        }
    }
    
    private func reloadTableContent() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.backgroundColor = .white
        }
    }

}

    //MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.totalCount ?? 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ??
            UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        guard let quote = viewModel?.currency(at: indexPath.row) else {
            cell.textLabel?.text = "ERRO"
            return cell
        }
        cell.textLabel?.text = quote
        return cell
        
    }
    
}

    //MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let code = viewModel?.getCode(at: indexPath.row) else { return }
        delegate?.didChosseCode(code: code)
        tableView.deselectRow(at: indexPath, animated: false)
        self.dismiss(animated: true, completion: nil)
    }
    
}

    //MARK:- ListViewModelDelegate
extension ListViewController: ListViewModelDelegate {
    
    func onFetchCompleted() {
        reloadTableContent()
    }
    
    func onFetchFailed(with reason: String) {
        showAlert(title: "Alerta", message: reason)
    }
}

    // MARK: - FilterButtonDelegate

extension ListViewController: FilterButtonDelegate {
    
    func filterByCurrencieCode() {
        viewModel?.filterByCode()
    }
    
    func filterByCurrencieName() {
        viewModel?.filterByName()
    }

}

    // MARK: - UISearchBarDelegate

extension ListViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel?.searchAction(text: text.trimmingCharacters(in: .whitespaces))
        
    }
           
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.clearSearch()
        searchBar.resignFirstResponder()
    }
       
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
 
}
