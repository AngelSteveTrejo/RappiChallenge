//
//  CategoryViewCell.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/26/19.
//

import Foundation
import UIKit

/// Protocol used for select a category.
protocol CategoryViewCellDelegate {
    func didSelectCategory(idCategory: Int, categoryName: String)
}

/// View used to display each recipe.
final class CategoryViewCell: UITableViewCell {
    var delegate: CategoryViewCellDelegate?
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoryDataViewCell.self,
                                forCellWithReuseIdentifier: CategoryDataViewCell.reuseIdentifier)
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    private var cells: [Category] = [Category]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        selectionStyle = .none
        setupCollectionView()
        addSubviews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupViews() {
        setupContentView()
        setupConstraintsCollectionView()
    }
    
    private func addSubviews() {
        self.addSubview(containerView)
        containerView.addSubview(collectionView)
    }
    
    private func setupContentView() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            containerView.heightAnchor.constraint(equalToConstant: 100),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
            ])
    }
    
    /// Container view settings.
    private func setupConstraintsCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            ])
    }
    
    func fillData(using model: Decodable) {
        if let modelCategory = model as? [Category] {
            cells = modelCategory
        }
    }
}

// Mark: UICollectionViewDataSource
extension CategoryViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recipeModel = cells[indexPath.row].categories
        let categoryCell: CategoryDataViewCell = collectionView.dequeue(for: indexPath)
        categoryCell.fillData(using: recipeModel)
        return categoryCell
    }
}

// Mark: UICollectionViewDelegate
extension CategoryViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !cells.isEmpty,
            let delegate = delegate else {
                return
        }
        let model = cells[indexPath.row].categories
        delegate.didSelectCategory(idCategory: model.id, categoryName: model.name)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoryViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = 70
        return CGSize(width: collectionViewSize, height: 100)
    }
}
