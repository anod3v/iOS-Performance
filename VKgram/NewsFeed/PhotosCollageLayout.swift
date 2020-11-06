//
//  PhotosCollageLayout.swift
//  LoginForm
//
//  Created by Andrey on 31/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class PhotosCollageLayout: UICollectionViewLayout {
    
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]() // Хранит атрибуты для заданных индексов
    
    let maxNumberOfCells: Int = 4
    
    private var totalCellsHeight: CGFloat = 0 // Хранит суммарную высоту всех ячеек
    
    override func prepare() {
//
                self.cacheAttributes = [:] // Инициализируем атрибуты 
                guard let collectionView = self.collectionView else { return } // Проверяем наличие collectionView
                let itemsCount = collectionView.numberOfItems(inSection: 0) // Проверяем, что в секции есть хотя бы одна ячейка
                guard itemsCount > 0 else { return }

        var lastX: CGFloat = 0
        
        for index in 0..<itemsCount {
        
        let indexPath = IndexPath(item: index, section: 0)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
            if itemsCount == 1 {
                attributes.frame = CGRect(x: 0, y: 0,
                                          width: collectionView.bounds.size.width,
                                          height: collectionView.bounds.size.width)
                cacheAttributes[indexPath] = attributes
            } else if itemsCount == 2 {
                attributes.frame = CGRect(x: lastX, y: 0,
                                          width: collectionView.bounds.size.width / CGFloat(maxNumberOfCells / 2),
                                          height: collectionView.bounds.size.height)
                lastX += ( collectionView.bounds.size.width / 2 )
                cacheAttributes[indexPath] = attributes
            } else if itemsCount >= 3 {
                
                if index == 0 {
                    attributes.frame = CGRect(x: 0,
                                              y: 0,
                                              width: collectionView.bounds.size.width / CGFloat(maxNumberOfCells / 2),
                                              height: collectionView.bounds.size.height / CGFloat(maxNumberOfCells / 2))
                    cacheAttributes[indexPath] = attributes
                } else if index == 1 {
                    attributes.frame = CGRect(x: collectionView.bounds.size.width / CGFloat(maxNumberOfCells / 2),
                                                y: 0,
                                                width: collectionView.bounds.size.width / CGFloat(maxNumberOfCells / 2),
                                                height: collectionView.bounds.size.height / CGFloat(maxNumberOfCells / 2))
                    cacheAttributes[indexPath] = attributes
                } else if index == 2 {
                    attributes.frame = CGRect(x: 0,
                                              y: collectionView.bounds.size.height / CGFloat(maxNumberOfCells / 2),
                                              width: collectionView.bounds.size.width / CGFloat(maxNumberOfCells / 2),
                                              height: collectionView.bounds.size.height / CGFloat(maxNumberOfCells / 2))
                    cacheAttributes[indexPath] = attributes
                } else if index == 3 {
                    attributes.frame = CGRect(x: collectionView.bounds.size.width / CGFloat(maxNumberOfCells / 2),
                                              y: collectionView.bounds.size.height / CGFloat(maxNumberOfCells / 2),
                                              width: collectionView.bounds.size.width / CGFloat(maxNumberOfCells / 2),
                                              height: collectionView.bounds.size.height / CGFloat(maxNumberOfCells / 2))
                    cacheAttributes[indexPath] = attributes
                }
                
            }
            
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter { attributes in
            return rect.intersects(attributes.frame)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {     return cacheAttributes[indexPath] }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.collectionView?.frame.width ?? 0, height: self.totalCellsHeight)
    }
}
