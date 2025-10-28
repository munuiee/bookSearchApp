import UIKit
import Foundation
import SnapKit

class BookShelfController: UIViewController {
    private let symbol = UIImageView()
    private let label = UILabel()
    private let deleteButton = UIButton()
    private let addButton = UIButton()
    private let hStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleSet()
    }
    
    private func titleSet() {
        [symbol, label]
            .forEach { view.addSubview($0)}
        
        symbol.image = UIImage(systemName: "books.vertical")
        symbol.tintColor = UIColor(named: "MainColor")
        symbol.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
            $0.width.height.equalTo(30)
        }
        
        label.text = "내 책장"
        label.font = UIFont.systemFont(ofSize: 24)
        label.snp.makeConstraints {
            $0.top.equalTo(symbol.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
}
