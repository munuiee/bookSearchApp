import UIKit
import Foundation
import SnapKit

final class DetailViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    private let book: Book
    
    private let bookTitle = UILabel()
    private let author = UILabel()
    private let price = UILabel()
    private let image = UIImageView()
    private let details = UILabel()
    
    private let xButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "X"
        config.baseForegroundColor = .black
        config.background.cornerRadius = 35
        config.baseBackgroundColor = .systemGray6
        config.cornerStyle = .capsule
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 25) // 👈 원하는 크기와 굵기
            return outgoing
        }
        let xButton = UIButton(configuration: config)
        return xButton
    }()
    
    private let cartButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "book.badge.plus") ?? UIImage(systemName: "book")
        config.title = "책 담기"
        
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseBackgroundColor = UIColor(named: "OpacityColor")
        config.baseForegroundColor = .white
        config.background.cornerRadius = 30
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 24, weight: .medium) // 👈 원하는 크기와 굵기
            return outgoing
        }
        let cartButton = UIButton(configuration: config)
        return cartButton
    }()
    
    private let vStack = UIStackView()
    private let hStack = UIStackView()
    private let buttonStack = UIStackView()
    
    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        buttonSet()
        
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.large()]
        }
        
        xButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }

    private func configureUI() {
        view.backgroundColor = .white
        [hStack, image, details]
            .forEach { view.addSubview($0) }
        [bookTitle, author]
            .forEach { vStack.addArrangedSubview($0) }
        [vStack, price]
            .forEach { hStack.addArrangedSubview($0) }
        
        bookTitle.font = .systemFont(ofSize: 24, weight: .medium)
        bookTitle.textAlignment = .left
        author.font = .systemFont(ofSize: 15)
        author.textAlignment = .left
        
        hStack.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(100)
            
        }
    }
    
  
    private func buttonSet() {

      
        buttonStack.axis = .horizontal
        buttonStack.alignment = .fill
        buttonStack.distribution = .fill
        buttonStack.spacing = 10
        
        [xButton, cartButton].forEach { buttonStack.addArrangedSubview($0) }
        
        view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
      
        xButton.snp.makeConstraints {
            $0.width.height.equalTo(70)
            $0.centerY.equalTo(buttonStack)
        }
        
        cartButton.layer.cornerRadius = 50
        cartButton.snp.makeConstraints {
            $0.width.equalTo(280)
            $0.height.equalTo(70)
            $0.centerY.equalTo(buttonStack)
        }
        
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
 
}
