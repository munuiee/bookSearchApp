import Foundation

protocol DetailViewControllerDelegate: AnyObject {
    func didTapAddBook(_ book: Book)
}
