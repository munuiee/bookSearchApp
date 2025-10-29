import UIKit
import Foundation
import SnapKit

class BookShelfController: UIViewController, DetailViewControllerDelegate {
    private let symbol = UIImageView()
    private let label = UILabel()
    private let deleteButton = UIButton()
    private let addButton = UIButton()
    private let hStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleSet()
        buttonSet()
    }
    
    func didTapAddBook(_ book: Book) {
        print("✨ \(book.title) 추가됨!")
        reloadBooks()
    }
    
    private func reloadBooks() {
        
    }
    
    private func showDetail(for book: Book) {
        let detailVC = DetailViewController(book: book)
        detailVC.delegate = self
        present(detailVC, animated: true)
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
    
    private func buttonSet() {
        view.addSubview(hStack)
        hStack.axis =  .horizontal
        hStack.distribution = .equalSpacing
        hStack.spacing = 20
        hStack.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        [deleteButton, addButton].forEach { hStack.addArrangedSubview($0) }
        deleteButton.setTitle("전체 삭제", for: .normal)
        deleteButton.setTitleColor(.systemGray4, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)

        
        addButton.setTitle("추가하기", for: .normal)
        addButton.setTitleColor(UIColor(named: "MainColor"), for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
}
