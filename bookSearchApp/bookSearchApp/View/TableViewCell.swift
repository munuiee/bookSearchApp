// '내 책장' 셀

import Foundation
import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    static let identifier = "TableViewCell"
    
    private let title = UILabel()
    private let author = UILabel()
    private let price = UILabel()
    private let hStack = UIStackView()
    private let spacer = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellSet()
        
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellSet() {
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
    
    func configure(with detail: Details) {
        title.text = detail.title ?? "no title"
        author.text = detail.author ?? "no author"
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal  // 천 단위 콤마

        if let priceString = detail.price,
           let priceValue = Int(priceString),     
           let formatted = formatter.string(from: NSNumber(value: priceValue)) {
            price.text = "\(formatted)원"
        } else {
            price.text = "0원"
        }
        
    }
}
