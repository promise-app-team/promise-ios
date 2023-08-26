//
//  PromiseListLayout.swift
//  Promise
//
//  Created by 신동오 on 2023/07/26.
//

import UIKit

final class PromiseListLayout: UICollectionViewFlowLayout {
    
    // MARK: - Private property
    private let activeDistance: CGFloat = 200
    private let zoomFactor: CGFloat = 0.25
    
    // MARK: - Initializer
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override function
    override func prepare() {
        configureLayout()
        super.prepare()
    }
    
    // MARK: - Private function
    private func configureLayout() {
        scrollDirection = .horizontal
        
        guard let collectionView = collectionView else {
            fatalError()
        }
        
        let unzoomedItemWidth: CGFloat = collectionView.frame.width - 80 // 80 = 좌 40 + 우 40
        let unzoomedItemHeight: CGFloat = collectionView.frame.height
        
        let itemWidth = unzoomedItemWidth / (1 + zoomFactor)
        let itemHeight = unzoomedItemHeight / (1 + zoomFactor)
        
        let leadingWidth = (collectionView.frame.width - itemWidth) / 2 // 약 40으로 계산됨(디바이스 넓이에 따라)
    
        minimumLineSpacing = leadingWidth * 2 / 3 // 2:3 비율에서 2에 해당
        
        // MARK: 아이템(약속 카드) 사이즈 설정
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let verticalInsets = (
            collectionView.frame.height
            - collectionView.adjustedContentInset.top
            - collectionView.adjustedContentInset.bottom
            - itemSize.height
        ) / 2
        
        let horizontalInsets = (
            collectionView.frame.width
            - collectionView.adjustedContentInset.right
            - collectionView.adjustedContentInset.left
            - itemSize.width
        ) / 2
        
        sectionInset = UIEdgeInsets(
            top: verticalInsets,
            left: horizontalInsets,
            bottom: verticalInsets,
            right: horizontalInsets
        )
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else {
            return nil
        }
        let rectAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)
        
        for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
            let distance = visibleRect.midX - attributes.center.x
            let normalizedDistance = distance / activeDistance
            
            if distance.magnitude < activeDistance {
                let zoom = 1 + zoomFactor * (1 - normalizedDistance.magnitude)
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                attributes.zIndex = Int(zoom.rounded())
                
                let focusRatio = 1 - (distance.magnitude / activeDistance)
                if let cell = collectionView.cellForItem(at: attributes.indexPath) as? PromiseListCell {
                    cell.updateBorder(focusRatio: focusRatio)
                }
            }
        }
        
        return rectAttributes
    }
    
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView else {
            return .zero
        }
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else {
            return .zero
        }
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2
        
        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        
        return context
    }
}
