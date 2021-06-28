import UIKit

class ConversionViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var sourcePicker: UIPickerView!
    @IBOutlet weak var resultPicker: UIPickerView!
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var offlineAlertLabel: UILabel!
    @IBOutlet weak var convertButton: UIButton! {
        didSet {
            convertButton?.addTarget(self, action: #selector(convertAction), for: .touchUpInside)
        }
    }
    
    //MARK: Properties
    
    private var viewModel:  ConversionViewModel?
    
    //MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourcePicker.tag = 1
        resultPicker.tag = 2
        sourceTextField.delegate = self
        sourcePicker.delegate = self
        resultPicker.delegate = self
        sourcePicker.dataSource = self
        resultPicker.dataSource = self
        viewModel = ConversionViewModel(delegate: self)
        convertButton.isHidden = true
        offlineAlertLabel.isHidden = true
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
    
    private func setOutletsRules() {
        resultTextField.allowsEditingTextAttributes = false
    }
    
    @objc private func convertAction() {
        callConvertion()
        sourceTextField.resignFirstResponder()
    }
    
    private func callConvertion() {
        guard let text = sourceTextField.text else { return }
        let sourceRow = sourcePicker.selectedRow(inComponent: 0)
        let desiredRow = resultPicker.selectedRow(inComponent: 0)
        viewModel?.getCurrency(value: text, sourceRow: sourceRow, desiredRow: desiredRow)
    }
}

    //MARK: - UITextFieldDelegate

extension ConversionViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        convertButton.isHidden = false
        sourceTextField.text?.removeAll()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        convertButton.isHidden = true
        callConvertion()
    }
}

    //MARK: - UIPickerViewDelegate

extension ConversionViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            viewModel?.sourceSelected = row
        } else {
            viewModel?.resultDesired = row
        }
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
        DispatchQueue.main.async { [weak self] in
            self?.sourcePicker.reloadAllComponents()
            self?.resultPicker.reloadAllComponents()
        }
    }
    
    func onFetchFailed(with reason: String) {
        //showAlert(title: "Alerta", message: reason) // bug here
    }
    
    func displayOfflineAlert() {
        offlineAlertLabel.isHidden = false
    }
}

    //MARK: - UIPickerViewDataSource

extension ConversionViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel?.pickerCount ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel?.getCode(index: row)
    }
}
