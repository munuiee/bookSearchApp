
import Foundation
import UIKit
import SnapKit

class HeaderView: UICollectionReusableView {
    static let identifier = "HeaderView"
    private let icon = UIImageView()
    private let label = UILabel()
    private let hstack = UIStackView()
   
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(hstack)
        [icon, label]
            .forEach { hstack.addArrangedSubview($0) }
        
        icon.tintColor = UIColor(named: "OpacityColor")
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24)
        
        hstack.axis = .horizontal
        hstack.alignment = .center
        hstack.spacing = 5
        
        hstack.translatesAutoresizingMaskIntoConstraints = false
        hstack.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(10)
            $0.top.equalToSuperview().inset(20)
        }

    }
    
    func configure(titleText: String, symbolName: String) {
        icon.image = UIImage(systemName: symbolName)
        label.text = titleText
    }
}
