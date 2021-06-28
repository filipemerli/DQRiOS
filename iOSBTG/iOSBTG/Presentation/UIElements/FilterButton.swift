import UIKit

protocol FilterButtonDelegate: AnyObject {
    func filterByCurrencieCode()
    func filterByCurrencieName()
}

final class FilterButton: UIButton {
    
    //MARK: Properties
    
    weak var delegate: FilterButtonDelegate?
    
    //MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setTitle("Sort by CODE", for: .normal)
        self.setTitle("Sort by NAME", for: .selected)
        self.setTitleColor(.black, for: .normal)
        self.setTitleColor(.black, for: .selected)
        self.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 12.0)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel?.textAlignment = .left
        self.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        self.titleLabel?.tintColor = .black
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.cornerRadius = 15.0 * 0.5
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.alpha = isHighlighted ? 0.54 : 1.0
        }
    }
    
    //MARK: Delegate
    
    @objc private func buttonPress() {
        if self.isSelected {
            self.isSelected = false
            delegate?.filterByCurrencieCode()
        } else {
            self.isSelected = true
            delegate?.filterByCurrencieName()
        }
    }
    
    
}
