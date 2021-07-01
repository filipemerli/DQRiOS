import UIKit

class ConversionViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var resultButton: UIButton! {
        didSet {
            resultButton.addTarget(self, action: #selector(resultButtonAction), for: .touchUpInside)
        }
    }
    @IBOutlet weak var sourceButton: UIButton! {
        didSet {
            sourceButton.addTarget(self, action: #selector(sourceButtonAction), for: .touchUpInside)
        }
    }
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var offlineAlertLabel: UILabel!
    @IBOutlet weak var convertButton: UIButton! {
        didSet {
            convertButton.addTarget(self, action: #selector(convertButtonAction), for: .touchUpInside)
            convertButton.layer.cornerRadius = 10.0
        }
    }
    
    //MARK: Properties
    
    private lazy var listViewController: ListViewController = {
        let viewController = ListViewController(delegate: self)
        return viewController
    }()
    
    private enum SelectionState {
        case source
        case result
    }
    
    private var lastSelectionState: SelectionState?
    
    private var viewModel: ConversionViewModel?
    private var didSelectSourceCode: Bool = false
    private var didSelectResultCode: Bool = false
    
    //MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceTextField.delegate = self
        viewModel = ConversionViewModel(delegate: self)
        offlineAlertLabel.isHidden = true
        convertButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.viewModel?.updateOfflineQuotes()
        }
    }
    
    deinit {
        viewModel = nil
    }
    
    //MARK: Class Methods
    
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true)
        }
    }
    
    private func callConvertion() {
        guard let text = sourceTextField.text else { return }
        guard let sourceCode = sourceButton.title(for: .normal) else { return }
        guard let desiredCode = resultButton.title(for: .normal) else { return }
        viewModel?.getCurrency(value: text, sourceCode: sourceCode, desiredCode: desiredCode)
    }
    
    @objc private func sourceButtonAction() {
        lastSelectionState = .source
        showListController()
    }
    
    @objc private func resultButtonAction() {
        lastSelectionState = .result
        showListController()
    }
    
    @objc private func convertButtonAction() {
        sourceTextField.resignFirstResponder()
        callConvertion()
    }
    
    private func showListController() {
        sourceTextField.resignFirstResponder()
        present(listViewController, animated: true, completion: nil)
    }
}

    //MARK: - UITextFieldDelegate

extension ConversionViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        sourceTextField.text?.removeAll()
        if didSelectResultCode && didSelectSourceCode {
            convertButton.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        convertButton.isHidden = true
    }
}

    //MARK: - ConversionViewModelDelegate

extension ConversionViewController: ConversionViewModelDelegate {
    func onGetCurrencyCompleted(result: String) {
        DispatchQueue.main.async {
            self.resultTextField.text = result
        }
    }
    
    func onGetDataCompleted() {

    }
    
    func onFetchFailed(with reason: String) {
        showAlert(title: "Alerta", message: reason)
    }
    
    func displayOfflineAlert() {
        offlineAlertLabel.isHidden = false
    }
}

    //MARK: - ConversionListViewControllerDelegate

extension ConversionViewController: ListViewControllerDelegate {
    
    func didChosseCode(code: String) {
        switch lastSelectionState {
        case .source:
            didSelectSourceCode = true
            DispatchQueue.main.async { [weak self] in
                self?.sourceButton.setTitle(code, for: .normal)
            }
        case .result:
            didSelectResultCode = true
            DispatchQueue.main.async { [weak self] in
                self?.resultButton.setTitle(code, for: .normal)
            }
        case .none:
            return
        }
    }

    
}
