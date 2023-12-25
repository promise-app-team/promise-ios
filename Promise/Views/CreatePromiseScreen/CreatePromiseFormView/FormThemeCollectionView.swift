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
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FormThemeTagCell.self, forCellWithReuseIdentifier: FormThemeTagCell.identifier)
        
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
            
            themeList.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 9),
            themeList.leadingAnchor.constraint(equalTo: leadingAnchor),
            themeList.trailingAnchor.constraint(equalTo: trailingAnchor),
            themeList.bottomAnchor.constraint(equalTo: bottomAnchor),
            themeListHeightConstraint,
        ])
    }
}

extension FormThemeCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return createPromiseVM.themes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let theme = createPromiseVM.themes[indexPath.row]
        return FormThemeTagCell.cellSize(for: theme)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormThemeTagCell.identifier, for: indexPath) as? FormThemeTagCell else {
            return UICollectionViewCell()
        }
        
        let theme = createPromiseVM.themes[indexPath.row]
        
        cell.configureFormThemeTagCell(with: theme)
        return cell
    }
    
    // 셀을 클릭했을 때의 로직
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 특정 셀만 업데이트(:cellForItemAt 가 실행됨)
        // collectionView.reloadItems(at: [indexPath])
        
        createPromiseVM.onChangeThemes(index: indexPath.row)
        
        KeyboardManager.shared.hideKeyboard()
    }
}
