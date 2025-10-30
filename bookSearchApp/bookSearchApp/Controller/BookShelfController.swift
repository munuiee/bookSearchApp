import UIKit
import Foundation
import SnapKit

class BookShelfController: UIViewController, DetailViewControllerDelegate {
    private var storeInfo: [Details] = []
    private let coreDataManager = CoreDataManager.shared
    private let symbol = UIImageView()
    private let label = UILabel()
    private let deleteButton = UIButton()
    private let addButton = UIButton()
    private let hStack = UIStackView()
    private let tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleSet()
        buttonSet()
        tableSet()
        storeInfo = coreDataManager.getInformation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadBooks()
    }
    
    func didTapAddBook(_ book: Book) {
        print("✨ \(book.title) 추가됨!")
        reloadBooks()
    }
    
    private func reloadBooks() {
        storeInfo = coreDataManager.getInformation()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
        deleteButton.addTarget(self, action: #selector(deleteButton(_:)), for: .touchUpInside)

        
        addButton.setTitle("추가하기", for: .normal)
        addButton.setTitleColor(UIColor(named: "MainColor"), for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    private func tableSet() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.rowHeight = 80
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(hStack.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20) 
        }
    }
    
    
    @objc private func deleteButton(_ sender: UIButton) {
        

        guard !storeInfo.isEmpty else { return }
        
        let alert = UIAlertController(title: "전체 삭제", message: "모든 항목을 삭제할까요?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) {[weak self] _ in
            guard let self = self else { return }
            self.coreDataManager.deleteAllDetails()
            self.storeInfo.removeAll()
            self.tableView.reloadData()
        })
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {
            [weak self](action, view, completion) in
            guard let self = self else { return }
            let info = self.storeInfo[indexPath.row]
            
            CoreDataManager.shared.delete(details: info)
            
            self.storeInfo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    

}

extension BookShelfController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell
        else { return .init() }
        
        cell.configure(with: storeInfo[indexPath.row])
   
        return cell
    }
}
