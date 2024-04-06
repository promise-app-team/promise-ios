//
//  SortPromiseListView.swift
//  Promise
//
//  Created by dylan on 2023/08/04.
//

import Foundation
import UIKit

protocol SortPromiseListViewDelegate: AnyObject {
    func onOrderSelected(order: SortPromiseListEnum)
}

enum SortPromiseListEnum: Int {
    case selecting
    case dateTimeQuickOrder
    case dateTimeLateOrder
    
    func description() -> String {
        switch self {
        case .selecting:
            return L10n.Main.SortPromiseList.selectOrder
        case .dateTimeQuickOrder:
            return L10n.Main.SortPromiseList.dateTimeQuickOrder
        case .dateTimeLateOrder:
            return L10n.Main.SortPromiseList.dateTimeLateOrder
        }
    }
}

class SortPromiseListView: UIView {
    private var mainVM: MainVM
    weak var delegate: SortPromiseListViewDelegate?
    
    private var sortMethods: [SortPromiseListEnum] = [
        .dateTimeQuickOrder,
        .dateTimeLateOrder
    ]
    
    private lazy var selectedSortOrder = SortPromiseListEnum.dateTimeQuickOrder {
        didSet {
            guard oldValue != selectedSortOrder else { return }
            delegate?.onOrderSelected(order: selectedSortOrder)
        }
    }
    
    public var disabled: Bool = true {
        didSet {
            guard disabled else {
                layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
                sortTitle.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                sortIcon.image = Asset.arrowDown.image
                
                return
            }
            
            layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
            sortTitle.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            sortIcon.image = Asset.arrowDownLight.image
        }
    }
    
    private lazy var sortTitle = {
        let label = UILabel()
        
        label.text = SortPromiseListEnum.dateTimeQuickOrder.description()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(16, .width))
        label.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sortIcon = {
        let imageView = UIImageView(image: Asset.arrowDownLight.image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: adjustedValue(24, .width)),
            imageView.heightAnchor.constraint(equalToConstant: adjustedValue(24, .height)),
        ])
        
        return imageView
    }()
    
    private lazy var popoverContentView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = adjustedValue(8, .height)
        view.layer.borderWidth = adjustedValue(1, .width)
        view.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        
        let font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(16, .width))
        let textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        
        let timeQuickOrderLabel = UILabel()
        timeQuickOrderLabel.tag = SortPromiseListEnum.dateTimeQuickOrder.rawValue
        timeQuickOrderLabel.font = font
        timeQuickOrderLabel.textColor = textColor
        timeQuickOrderLabel.text = SortPromiseListEnum.dateTimeQuickOrder.description()
        
        let timeQuickOrderTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSelectSortOrder))
        timeQuickOrderLabel.addGestureRecognizer(timeQuickOrderTapGesture)
        timeQuickOrderLabel.isUserInteractionEnabled = true
        
        let timeLateOrderLabel = UILabel()
        timeLateOrderLabel.tag = SortPromiseListEnum.dateTimeLateOrder.rawValue
        timeLateOrderLabel.font = font
        timeLateOrderLabel.textColor = textColor
        timeLateOrderLabel.text = SortPromiseListEnum.dateTimeLateOrder.description()
        
        let timeLateOrderTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSelectSortOrder))
        timeLateOrderLabel.addGestureRecognizer(timeLateOrderTapGesture)
        timeLateOrderLabel.isUserInteractionEnabled = true
        
        timeQuickOrderLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLateOrderLabel.translatesAutoresizingMaskIntoConstraints = false
        [timeQuickOrderLabel, timeLateOrderLabel].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            timeQuickOrderLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: adjustedValue(12, .height)),
            timeQuickOrderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(16, .width)),
            timeQuickOrderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(16, .width)),
            
            timeLateOrderLabel.topAnchor.constraint(equalTo: timeQuickOrderLabel.bottomAnchor, constant: adjustedValue(14, .height)),
            timeLateOrderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(16, .width)),
            timeLateOrderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(16, .width)),
            timeLateOrderLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -adjustedValue(12, .height))
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var popoverView = {
        let popoverView = PopoverView(
            from: PopoverTarget(x: 0, y: adjustedValue(8, .height), target: self),
            in: mainVM.currentVC!,
            contentView: popoverContentView,
            isEnableDimmingView: true,
            paddingHorizontal: 0
        )
        
        popoverView.delegate = self
        
        return popoverView
    }()
    
    @objc private func onTapSelf() {
        popoverView.show()
    }
    
    @objc private func onSelectSortOrder(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            switch tag {
            case SortPromiseListEnum.dateTimeQuickOrder.rawValue:
                
                selectedSortOrder = SortPromiseListEnum.dateTimeQuickOrder
                
            case SortPromiseListEnum.dateTimeLateOrder.rawValue:
                
                selectedSortOrder = SortPromiseListEnum.dateTimeLateOrder
                
            default:
                break
            }
        }
        
        popoverView.dismiss()
    }
    
    init(mainVM: MainVM) {
        self.mainVM = mainVM
        super.init(frame: .null)
        
        configure()
        render()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapSelf))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
        
        backgroundColor = .white
        
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: adjustedValue(160, .width)).isActive = true
    }
    
    func render() {
        [sortTitle, sortIcon].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            sortTitle.topAnchor.constraint(equalTo: topAnchor, constant: adjustedValue(6, .height)),
            sortTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(16, .width)),
            sortTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -adjustedValue(6, .height)),
            
            sortIcon.topAnchor.constraint(equalTo: topAnchor, constant: adjustedValue(6, .height)),
            sortIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -adjustedValue(12, .width)),
            sortIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -adjustedValue(6, .height))
        ])
    }
}

extension SortPromiseListView: PopoverViewDelegate {
    func onWillShow() {
        self.superview?.layer.zPosition = 1
        
        UIView.animate(withDuration: 0.2) {
            self.sortIcon.transform = CGAffineTransform(rotationAngle: .pi)
            self.layer.borderColor = UIColor(red: 0.022, green: 0.75, blue: 0.619, alpha: 1).cgColor
            self.sortTitle.text = SortPromiseListEnum.selecting.description()
            self.sortTitle.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        }
    }
    
    func onWillHide() {
        self.superview?.layer.zPosition = 0
        
        UIView.animate(withDuration: 0.2) {
            self.sortIcon.transform = CGAffineTransform(rotationAngle: -(.pi * 2))
            self.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
            
            
            self.sortTitle.text = self.selectedSortOrder.description()
            self.sortTitle.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
}
