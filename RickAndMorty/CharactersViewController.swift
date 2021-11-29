//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Yariv Nissim on 4/14/21.
//

import UIKit

class CharactersViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, Character>!
    
    private let networkController = NetworkControllerImpl()
    private var imageCache: [Int: UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Rick and Morty Characters", comment: "Title of the screen")
        createCollectionView()
        
        networkController.getAllCharacters { (result) in
            DispatchQueue.main.async {
                self.updateUI(result: result)
            }
        }
    }
}

private extension CharactersViewController {
    private func updateUI(result: Result<RickAndMortyResponse, NetworkError>) {
        do {
            let response = try result.get()
            
            var snapshot = dataSource.snapshot()
            if snapshot.numberOfSections == 0 {
                snapshot.appendSections([0])
            }
            snapshot.appendItems(response.results, toSection: 0)
            dataSource.apply(snapshot, animatingDifferences: true)
        } catch {
            print(error)
        }
    }
    
    func createCollectionView() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Character> { [weak self] (cell, indexPath, character) in
            guard let self = self else { return }
            
            if self.imageCache[character.id] == nil {
                self.networkController.getImage(for: character.image) { [self] (image) in
                    guard self.imageCache[character.id] == nil, let image = image else { return }
                    self.imageCache[character.id] = image
                    var snapshot = self.dataSource.snapshot()
                    snapshot.reloadItems([character])
                    self.dataSource.apply(snapshot, animatingDifferences: true)
                }
            }
            var content = cell.defaultContentConfiguration()
            content.text = character.name
            content.image = self.imageCache[character.id]
            content.imageProperties.maximumSize = .init(width: 40, height: 40)
            content.imageProperties.reservedLayoutSize = content.imageProperties.maximumSize
            content.imageProperties.cornerRadius = 8
            cell.contentConfiguration = content
        }
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        dataSource = UICollectionViewDiffableDataSource<Int, Character>(collectionView: collectionView) { (collectionView, indexPath, character) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: character)
        }
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.backgroundColor = .systemBackground
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}
