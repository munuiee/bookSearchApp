//
//  DetailViewControllerDelegate.swift
//  bookSearchApp
//
//  Created by jyeee on 10/29/25.
//

import Foundation

protocol DetailViewControllerDelegate: AnyObject {
    func didTapAddBook(_ book: Book)
}
