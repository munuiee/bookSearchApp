/// 검색 결과 셀

import Foundation
import UIKit
import SnapKit

class ResultsCell: UICollectionViewCell {
    static let identifier = "ResultsCell"
    private let title = UILabel()
    private let author = UILabel()
    private let price = UILabel()
    private let hStack = UIStackView()
    private let spacer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(hStack)
        [title, author, spacer, price].forEach { hStack.addArrangedSubview($0) }
        
        title.font = .systemFont(ofSize: 15, weight: .semibold)
        title.textColor = UIColor(named: "MainColor")
        title.numberOfLines = 1
        title.lineBreakMode = .byTruncatingTail
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        title.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        author.font = .systemFont(ofSize: 9)
        author.numberOfLines = 1
        author.setContentCompressionResistancePriority(.required, for: .horizontal)
        author.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        price.font = .systemFont(ofSize: 13)
        price.textAlignment = .right
        price.setContentCompressionResistancePriority(.required, for: .horizontal)
        price.setContentHuggingPriority(.required, for: .horizontal)
        
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.alignment = .center
        hStack.distribution = .fill
        
        
        hStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.edges.equalToSuperview()
        }
        
        
        
    }
    
    
    
    func configure(_ book: Book) {
        title.text = book.title
        author.text = book.authors.joined(separator: ", ")
        let amount = NSNumber(value: book.salePrice ?? book.price)
        if let formatted = NumberFormatter.currencyKR.string(from: amount) {
                price.text = "\(formatted)원" 
            } else {
                price.text = "0원"
            }
    }
}

private extension NumberFormatter {
    static let currencyKR: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 0
        f.groupingSeparator = ","
        return f
    }()
}

