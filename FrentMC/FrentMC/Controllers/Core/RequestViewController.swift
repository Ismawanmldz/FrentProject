//
//  RequestViewController.swift
//  FrentMC
//
//  Created by Ismawan Maulidza on 9/21/22.
//

import UIKit
import RxSwift
import RxCocoa

class RequestViewController: UIViewController {

    lazy private var requestTitles: UILabel = {
        let label = ReusableLabel(labelType: .title, labelString: "Cek Request👇")
        label.textColor = UIColor().getTitleColor()
        return label
    }()
    
    lazy private var searchButton: UIButton = {
        let btn = UIButton(type: .system)
        let img = UIImage(systemName: "magnifyingglass")
        let tintedImg = img?.withRenderingMode(.alwaysTemplate)
        btn.setImage(tintedImg, for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    lazy private var notificationButton: UIButton = {
        let btn = UIButton(type: .system)
        let img = UIImage(systemName: "bell")
        let tintedImg = img?.withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    lazy private var hStackView: UIStackView = {
        let stack =  UIStackView(arrangedSubviews: [searchButton, notificationButton])
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    
    lazy private var contentStackView: UIStackView = {
        let spacer = UIView()
       let stack = UIStackView(arrangedSubviews: [requestTitles, spacer, hStackView])
        stack.axis = .horizontal
        stack.spacing = 12
        return stack
    }()
    
    lazy private var tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 150
        tv.register(RequestViewCell.self, forCellReuseIdentifier: "RequestViewCell")
        return tv
    }()
    
    private let requestGoodViewModel = RequestGoodsViewModel()
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        //MARK: - TITLES
        view.addSubview(contentStackView)
        contentStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 0, right: 15))
        
        //MARK: - TABLE VIEW
        view.addSubview(tableView)
        tableView.anchor(top: contentStackView.bottomAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    private func bindTable() {
        requestGoodViewModel.requestGoods.bind(to: tableView.rx.items(cellIdentifier: "RequestViewCell", cellType: RequestViewCell.self)) { row, model, cell in
            cell.setupGoods(goods: model)
            cell.selectionStyle = .none
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 20
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(RequestGoods.self).bind { goods in
            print(goods.goodName)
        }.disposed(by: bag)
        
        requestGoodViewModel.fetchRequestGoods()
    }
    
}
