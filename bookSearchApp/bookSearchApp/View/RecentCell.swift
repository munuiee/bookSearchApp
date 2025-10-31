// 최근 본 책 셀

import Foundation
import UIKit
import SnapKit

class RecentCell: UICollectionViewCell {
    static let identifier = "RecentCell"
    private let bookImage = UIImageView()
    private let titleLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with book: Book) {
        titleLabel.text = book.title
        
        if let thumbnail = book.thumbnail,
           let url = URL(string: thumbnail) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.bookImage.image = UIImage(data: data)
                }
            }.resume()
        } else {
            bookImage.image = UIImage(systemName: "book.closed")
        }
    }

    
    private func configureUI() {
        contentView.addSubview(bookImage)
        bookImage.contentMode = .scaleAspectFill
        bookImage.clipsToBounds = true
        bookImage.layer.borderWidth = 1
        bookImage.layer.cornerRadius = 32
        bookImage.layer.borderColor = UIColor.systemGray5.cgColor
        
        bookImage.translatesAutoresizingMaskIntoConstraints = false
        bookImage.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(64)
            $0.top.equalToSuperview().offset(15)
        }
    }
    
    func setImage(_ image: UIImage?) {
        bookImage.image = image
    }
    
    func setImageURL(_ urlString: String?) {
        bookImage.image = UIImage(systemName: "book")
          guard let s = urlString, let url = URL(string: s) else { return }
          URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
              guard let self = self, let data = data, let img = UIImage(data: data) else { return }
              DispatchQueue.main.async { self.bookImage.image = img }
          }.resume()
      }
}
