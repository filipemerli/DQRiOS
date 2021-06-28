import UIKit

final class ViewControllersTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = "Currencies List"
        self.textAlignment = .center
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
}
