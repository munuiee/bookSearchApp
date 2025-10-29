import UIKit
import Foundation
import SnapKit

final class DetailViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    private let book: Book
    
    private let bookTitle = UILabel()
    private let author = UILabel()
    private let price = UILabel()
    private let thumbnail = UIImageView()
    private let contents = UILabel()
    
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
        config.baseBackgroundColor = UIColor(named: "MainColor")
        config.baseForegroundColor = .white
        config.background.cornerRadius = 30
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 24, weight: .medium)
            return outgoing
        }
        let cartButton = UIButton(configuration: config)
        return cartButton
    }()
    
    private let vStack = UIStackView()
    private let buttonStack = UIStackView()
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        buttonSet()
        

        
        configureUI()
        apply(book)
        
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.large()]
        }
        
        xButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
  

    }

    
    private func configureUI() {
        
        view.addSubview(vStack)
        vStack.axis = .vertical
        vStack.spacing = 10
        
        [bookTitle, author].forEach { vStack.addArrangedSubview($0) }
        
        bookTitle.font = .systemFont(ofSize: 25, weight: .medium)
        bookTitle.textAlignment = .left
        bookTitle.numberOfLines = 2
        author.font = .systemFont(ofSize: 15)
        author.textAlignment = .left
        
        
        view.addSubview(price)
        price.textAlignment = .right
        price.font = .systemFont(ofSize: 18)
        price.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(vStack.snp.bottom).offset(15)
        }
        
        vStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(price.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(buttonStack.snp.top).offset(-12)
        }
        
        scrollView.addSubview(contentStack)
        contentStack.axis = .vertical
        contentStack.spacing = 10
        contentStack.isLayoutMarginsRelativeArrangement = true

        contentStack.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
        contentStack.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            }
        
        [thumbnail, contents].forEach{ contentStack.addArrangedSubview($0) }
 
        thumbnail.contentMode = .scaleAspectFit
        thumbnail.clipsToBounds = true
        thumbnail.layer.shadowOffset = CGSize(width: 4, height: 0)
        thumbnail.layer.shadowOpacity = 0.4
        thumbnail.layer.shadowColor = UIColor.gray.cgColor
        thumbnail.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(350)
            $0.centerX.equalToSuperview()
            //$0.top.equalTo(price.snp.bottom).offset(50)
        }
        thumbnail.setContentHuggingPriority(.defaultLow, for: .vertical)
        contentStack.setCustomSpacing(16, after: thumbnail)
        contents.numberOfLines = 0
        contents.font = .systemFont(ofSize: 14)
    
  
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
        cartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)

        
    }
    
    
    private func apply(_ book: Book) {
        bookTitle.text = book.title
        author.text = book.authors.joined(separator: ", ")
        let priceValue = book.salePrice ?? book.price
        price.text = "\(priceValue)원"
        contents.text = book.contents.isEmpty ? "상세 설명이 없습니다." : book.contents
        
        if let urlStr = book.thumbnail,
            let url = highResURL(from: urlStr) {
            loadImage(from: url) { [weak self] img in self?.thumbnail.image = img }
        } else {
            thumbnail.image = UIImage(systemName: "book")
        }
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data, let img = UIImage(data: data) else {
                return DispatchQueue.main.async { completion(nil) }
            }
            DispatchQueue.main.async { completion(img) }
        }.resume()
    }
        
    
    private func highResURL(from urlString: String) -> URL? {
        // 1) fname 쿼리에서 원본 URL 추출
        if let outer = URL(string: urlString),
           let comps = URLComponents(url: outer, resolvingAgainstBaseURL: false),
           let fname = comps.queryItems?.first(where: { $0.name == "fname" })?.value {

            let decoded = fname.removingPercentEncoding ?? fname
            var inner = URLComponents(string: decoded)
            // 2) http로 오면 https로 승격
            if inner?.scheme?.lowercased() == "http" {
                inner?.scheme = "https"
            }
            if let url = inner?.url { return url }
        }

        // 3) 리사이즈 토큰 제거 + http→https 방어
        var cleaned = urlString.replacingOccurrences(of: "C120x174", with: "")
        if cleaned.hasPrefix("http://") {
            cleaned = "https://" + cleaned.dropFirst("http://".count)
        }
        return URL(string: cleaned)
    }



    
    @objc private func closeTapped() { dismiss(animated: true) }
    @objc private func addToCartTapped() { print("장바구니 담기: \(book.title)") }

 
}
