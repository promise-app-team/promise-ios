//
//  CarouselCell.swift
//  Promise
//
//  Created by kwh on 1/18/24.
//

import UIKit

protocol CarouselViewDelegate: AnyObject {
    func currentPageDidChange(to page: Int)
    func onTapAttendPromiseButton()
}

class CarouselLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        if let collectionView = collectionView {
            itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        }
    }
    
    private func configureCaruselLayout() {
        guard let collectionView = collectionView else {
            fatalError()
        }
        
        let collectionViewWidth = collectionView.frame.width
        let collectionViewHeight = collectionView.frame.height
        
        itemSize = CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
}

class CarouselView: UIView {
    
    struct CarouselData {
        let image: UIImage?
        let title: String
        let bulletPoints: [String]
    }
    
    // MARK: - Properties
    
    private var pages: Int
    private weak var delegate: CarouselViewDelegate?
    private var carouselData = [CarouselData]()
    private var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            delegate?.currentPageDidChange(to: currentPage)
        }
    }
    
    // MARK: - Subviews
    
    private lazy var carouselCollectionView: UICollectionView = {
        // MARK: configure flow layout
        let carouselLayout = CarouselLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.minimumLineSpacing = 0
        
        // MARK: confiure collection view
        let collection = UICollectionView(frame: .zero, collectionViewLayout: carouselLayout)
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.dataSource = self
        collection.delegate = self
        collection.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.cellId)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    //    carouselCollectionView.collectionViewLayout.itemSize =
    
    private lazy var pageControl: CarouselPageControl = {
        let pageControl = CarouselPageControl()
        
        pageControl.dotRadius = 5
        pageControl.dotSpacings = 8
        
        pageControl.pageIndicatorTintColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0.022, green: 0.75, blue: 0.619, alpha: 1)
        
        pageControl.backgroundColor = .clear
        pageControl.numberOfPages = pages
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    // MARK: - Initializers
    
    init(with data: [CarouselData], delegate: CarouselViewDelegate?) {
        self.pages = data.count
        self.carouselData = data
        self.delegate = delegate
        super.init(frame: .zero)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        [
            carouselCollectionView,
            pageControl
        ].forEach { addSubview($0) }
        setupAutoLayout()
    }
    
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            carouselCollectionView.topAnchor.constraint(equalTo: topAnchor),
            carouselCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            carouselCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            carouselCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension CarouselView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.cellId, for: indexPath) as? CarouselCell else { return UICollectionViewCell() }
        
        let image = carouselData[indexPath.row].image
        let title = carouselData[indexPath.row].title
        let bulletPoints = carouselData[indexPath.row].bulletPoints
        
        cell.configure(
            image: image,
            title: title,
            bulletPoints: bulletPoints
        )
        
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UICollectionView Delegate

extension CarouselView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
        
        updatePageControlVisibility(for: scrollView)
        updateAttendButtonVisibility(for: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentPage = getCurrentPage()
        
        if !decelerate {
            updatePageControlVisibility(for: scrollView)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
        
        updatePageControlVisibility(for: scrollView)
        pageControl.scrollViewDidScroll(scrollView)
    }
    
    private func updatePageControlVisibility(for scrollView: UIScrollView) {
        let isLastPage = currentPage == pages - 1
        
        UIView.animate(withDuration: 0.3) {
            self.pageControl.alpha = isLastPage ? 0 : 1
        }
    }
    
    private func updateAttendButtonVisibility(for scrollView: UIScrollView) {
        let isLastPage = currentPage == pages - 1
        
        if let currentCell = self.carouselCollectionView.cellForItem(at: IndexPath(item: self.currentPage, section: 0)) as? CarouselCell {
            
            if(isLastPage) {
                UIView.animate(withDuration: 0.3, delay: 0.2) {
                    currentCell.showAttendButton()
                }
            } else {
                if let lastCell = self.carouselCollectionView.cellForItem(at: IndexPath(item: pages - 1, section: 0)) as? CarouselCell {
                    lastCell.hideAttendButton()
                }
            }
        }
    }
}

// MARK: - Helpers

private extension CarouselView {
    func getCurrentPage() -> Int {
        
        let visibleRect = CGRect(origin: carouselCollectionView.contentOffset, size: carouselCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = carouselCollectionView.indexPathForItem(at: visiblePoint) {
            return visibleIndexPath.row
        }
        
        return currentPage
    }
}

extension CarouselView: CarouselCellDelegate {
    func onTapAttendPromiseButton() {
        delegate?.onTapAttendPromiseButton()
    }
}
