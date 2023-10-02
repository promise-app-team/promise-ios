//
//  FormThemeView.swift
//  Promise
//
//  Created by dylan on 2023/08/28.
//

import Foundation
import UIKit

class FormThemeCollectionView: UIView {
    private var createPromiseVM: CreatePromiseVM

    private let label = {
        let label = UILabel()
        label.text = L10n.CreatePromise.formThemeLabel
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: 12)
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var themeList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // 수직 스크롤
        layout.itemSize = CGSize(width: 100, height: 100) // 각 아이템의 크기
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .red
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FormThemeTagCell.self, forCellWithReuseIdentifier: "FormThemeTagCell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var themeListHeightConstraint: NSLayoutConstraint = themeList.heightAnchor.constraint(equalToConstant: 0)
    
    private func updateCollectionViewHeight() {
        themeList.layoutIfNeeded()  // 레이아웃을 즉시 업데이트
        let height = themeList.contentSize.height  // 새로운 높이 계산
        themeListHeightConstraint.constant = height  // 높이 업데이트
    }
    
    
    private func assignThemesDidChange() {
        createPromiseVM.themesDidChange = { [weak self] newThemes in
            DispatchQueue.main.async {
                self?.themeList.reloadData()
                self?.updateCollectionViewHeight()
            }
        }
    }
    
    init(vm: CreatePromiseVM) {
        createPromiseVM = vm
        super.init(frame: .null)
        
        Task {
            assignThemesDidChange()
            await createPromiseVM.getSupportedTheme()
        }
        
        
        configureFormThemeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureFormThemeView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        [label, themeList].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            themeList.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            themeList.leadingAnchor.constraint(equalTo: leadingAnchor),
            themeList.trailingAnchor.constraint(equalTo: trailingAnchor),
            themeList.bottomAnchor.constraint(equalTo: bottomAnchor),
            themeListHeightConstraint,
        ])
    }
}

extension FormThemeCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return createPromiseVM.themes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FormThemeTagCell", for: indexPath) as? FormThemeTagCell else {
            return UICollectionViewCell()
        }
        
        let theme = createPromiseVM.themes[indexPath.row]
        
        cell.configureFormThemeTagCell(with: theme)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 셀을 클릭했을 때의 로직
    }
}
