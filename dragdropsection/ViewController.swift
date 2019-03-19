//
//  ViewController.swift
//  dragdropsection
//
//  Created by Max Nelson on 3/1/19.
//  Copyright © 2019 Maxcodes. All rights reserved.
//

import UIKit

class DragDrop: UIViewController {
    
    fileprivate var items: [String] = [
        "alexbed",
        "alexbox",
        "alexdesk",
        "alexfridge",
        "alexitems",
        "alexlake",
        "alexroad",
        "alexshoes",
        "alexvalley"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collection.backgroundColor = .white
        view.addSubview(collection)
    
        collection.delegate = self
        collection.dataSource = self
        collection.dragDelegate = self
        collection.dropDelegate = self
        collection.dragInteractionEnabled = true
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CELL")
        collection.contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath:IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first,
            let sourceIndexPath = item.sourceIndexPath {
            
            collectionView.performBatchUpdates({
                self.items.remove(at: sourceIndexPath.item)
                self.items.insert(item.dragItem.localObject as! String, at: destinationIndexPath.item)
                
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
    
}

extension DragDrop: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
           self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }
}

extension DragDrop: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.items[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}

extension DragDrop: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let square = (collectionView.frame.width-8) / 3
        return CGSize(width: square, height: square)
    }
}

extension DragDrop: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath)
        cell.backgroundColor = .white
        print(indexPath)
        let image = UIImage(named: self.items[indexPath.row])
        let cellImage = UIImageView(image: image)
        cellImage.contentMode = .scaleAspectFill
        cell.contentView.addSubview(cellImage)
        cell.contentView.clipsToBounds = true
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellImage.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 4).isActive = true
        cellImage.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 4).isActive = true
        cellImage.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -4).isActive = true
        cellImage.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -4).isActive = true
        return cell
    }
}

