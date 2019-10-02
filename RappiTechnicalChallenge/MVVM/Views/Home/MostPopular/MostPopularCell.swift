//
//  MostPopularCell.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/26/19.
//

import Foundation
import UIKit

protocol MostPopularCellDelegate {
    func didSelectMostPopular(model: RestaurantModel)
}

final class MostPopularCell: UITableViewCell {
    var delegate: MostPopularCellDelegate?
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MostPopularDataCell.self,
                                forCellWithReuseIdentifier: MostPopularDataCell.reuseIdentifier)
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .white
        return collectionView
    }()
    let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    private var cells: [RestaurantCollectionModel] = [RestaurantCollectionModel]() {
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
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 250),
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
        if let popularRestaurantModel = model as? [RestaurantCollectionModel] {
            cells = popularRestaurantModel
        }
    }
}

// Mark: UICollectionViewDataSource
extension MostPopularCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = cells[indexPath.row].collection
        let categoryCell: MostPopularDataCell = collectionView.dequeue(for: indexPath)
        categoryCell.fillData(using: model)
        return categoryCell
    }
}

// Mark: UICollectionViewDelegate
extension MostPopularCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = cells[indexPath.row].collection
        delegate?.didSelectMostPopular(model: model)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MostPopularCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = 256
        return CGSize(width: collectionViewSize, height: 250)
    }
}
