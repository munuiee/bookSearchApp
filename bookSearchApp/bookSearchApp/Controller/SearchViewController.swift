// '책 검색' 페이지

import UIKit
import SnapKit

enum Section: Int, CaseIterable {
    case recent
    case results
}


class SearchViewController: UIViewController, UISearchBarDelegate {
    
    struct SearchBook: Hashable {
        let title: String
        let author: String
        let price: String
        let thumbnail: String?
    }
    
    private let searchBar = UISearchBar()
    private let api = KakaoBookAPI()
    private var books: [Book] = []
    private let fallbackSymbol = UIImage(systemName: "book") ?? UIImage()
    private let button = UIButton()
    private var recentThumbnails: [String] = []
    private var searchLists: [String] = []
    // 화면에 보여줄 섹션 순서표
    private var visibleSections: [Section] = []
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collection.backgroundColor = .clear
        return collection
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchSet()
        setupCol()
        cellRegister()
        rebuildVisibleSections()
    }
    
    
    /* ----- ☄️ 컬렉션뷰 ----- */
    private func setupCol() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // 등록
    func cellRegister() {
        collectionView.register(RecentCell.self, forCellWithReuseIdentifier: RecentCell.identifier)
        collectionView.register(ResultsCell.self, forCellWithReuseIdentifier: ResultsCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
    }
    
    // 보여줄 섹션 결정 함수
    private func rebuildVisibleSections() {
        var sections: [Section] = [.results] // resultsSection만 나오는 상태
        if !recentThumbnails.isEmpty {
            sections.insert(.recent, at: 0)
        }
        visibleSections = sections
        collectionView.reloadData()
    }
    
    
    func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self, sectionIndex < self.visibleSections.count else { return nil }
            switch self.visibleSections[sectionIndex] {
            case .recent:
                return self.recentSection()
            case .results:
                return self.resultsSection()
            }
        }
    }
    
    // 최근 본 책 섹션
    private func recentSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(64),
            heightDimension: .absolute(64)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(64),
            heightDimension: .absolute(64))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 12
        section.contentInsets = .init(top: 8, leading: 16, bottom: 16, trailing: 40)
        
        // 헤더
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(36))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    // 검색 결과 섹션
    private func resultsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 30, leading: 40, bottom: 16, trailing: 40)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(36))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -24, bottom: 0, trailing: 16)
        
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    /* ----- 검색 바 ----- */
    // UI
    private func searchSet() {
        searchBar.delegate = self
        [searchBar]
            .forEach{ view.addSubview($0) }
        
        searchBar.placeholder = "책 검색하기"
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = .clear
        searchBar.backgroundColor = .clear
        searchBar.returnKeyType = .search
        
        let textField = searchBar.searchTextField
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.layer.cornerRadius = 0
        textField.layer.masksToBounds = true
        
        if let searchIcon = textField.leftView as? UIImageView {
            searchIcon.tintColor = UIColor(named: "MainColor")
            searchIcon.image = searchIcon.image?.withRenderingMode(.alwaysTemplate)
        }
        
        let underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = .systemGray3
        textField.addSubview(underline)
        
        underline.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.snp.makeConstraints {
            $0.width.equalTo(290)
            $0.top.equalToSuperview().inset(100)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
    }
    
    // 검색 실행
    private func doneSearch(_ query: String) {
        print("🚀 querying:", query)
        api.fetchBooks(query: query) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let books):
                    self.books = books
                    self.rebuildVisibleSections()
                case .failure(let error):
                    print("Error fetching books: \(error)")
                }
            }
        }
    }
    
    // 검색버튼 클릭 시에 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let q = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !q.isEmpty else { return }
        print("🔎 search tapped:", q)
        searchBar.resignFirstResponder()
        doneSearch(q)
    }
    
    

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = books[indexPath.item]
        let vc = DetailViewController(book: selected)
        vc.modalPresentationStyle = .pageSheet
        
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.preferredCornerRadius = 30
            sheet.prefersGrabberVisible = true
        }
        present(vc, animated: true) { [weak self] in
            guard let self = self else { return }
            if let url = selected.thumbnailURL {
                // 중복 제거
                self.recentThumbnails.removeAll { $0 == url}
                // 썸네일 맨 앞 추가
                self.recentThumbnails.insert(url, at: 0)
                
                // 10개 제한
                if self.recentThumbnails.count > 10 {
                    self.recentThumbnails = Array(self.recentThumbnails.prefix(10))
                }
                
            }
            self.rebuildVisibleSections()
        }
    }
    
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch visibleSections[section] {
        case .recent: return recentThumbnails.count
        case .results: return books.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch visibleSections[indexPath.section] {
        case .recent:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentCell.identifier, for: indexPath) as? RecentCell else {
                return UICollectionViewCell()
            }
            let urlString = recentThumbnails[indexPath.item]
            cell.setImageURL(urlString)
            return cell
            
        case .results:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultsCell.identifier, for: indexPath) as! ResultsCell
            
            let book = books[indexPath.item]
            
            cell.configure(book)
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = .white
            background.strokeColor = .systemGray3
            background.strokeWidth = 1 / UIScreen.main.scale
            background.backgroundInsets = NSDirectionalEdgeInsets(top: 0, leading: -8, bottom: 0, trailing: -8)
            cell.backgroundConfiguration = background
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as! HeaderView
        
        switch visibleSections[indexPath.section] {
        case .recent:
            header.configure(titleText: "최근 본 책", symbolName: "text.book.closed.fill")
        case .results:
            header.configure(titleText: "검색 결과", symbolName: "archivebox.fill")
        }
        return header
    }
    
    
}

extension Book {
    var thumbnailURL: String? { thumbnail }
}

